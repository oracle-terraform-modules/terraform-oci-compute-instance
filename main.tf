// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

terraform {
  required_version = ">= 0.12" // terraform version below 0.12 is not tested/supported with this module
  required_providers {
    oci = {
      version = ">= 3.27" // force downloading oci-provider compatible with terraform v0.12
    }
  }
}

// Get all the Availability Domains for the region
data "oci_identity_availability_domains" "ad" {
  compartment_id = var.compartment_ocid
}

locals {
  ADs = [
    // Iterate through data.oci_identity_availability_domains.ad and create a list containing AD names
    for i in data.oci_identity_availability_domains.ad.availability_domains : i.name
  ]
}

####################
# Subnet Datasource
####################
data "oci_core_subnet" "instance_subnet" {
  count     = length(var.subnet_ocids)
  subnet_id = element(var.subnet_ocids, count.index)
}

############
# Shapes
############

// Create a data source for compute shapes.
// Filter on AD1 to remove duplicates. This should give all the shapes supported on the region.
// This will not check quota and limits for AD requested at resource creation
data "oci_core_shapes" "ad1" {
  compartment_id      = var.compartment_ocid
  availability_domain = local.ADs[0]
}

locals {
  shapes_config = {
    // prepare data with default values for flex shapes. Used to populate shape_config block with default values
    // Iterate through data.oci_core_shapes.ad1.shapes (this exclude duplicate data in multi-ad regions) and create a map { name = { memory_in_gbs = "xx"; ocpus = "xx" } }
    for i in data.oci_core_shapes.ad1.shapes : i.name => {
      "memory_in_gbs" = i.memory_in_gbs
      "ocpus"         = i.ocpus
    }
  }
  shape_is_flex = length(regexall("^*.Flex", var.shape)) > 0 # evaluates to boolean true when var.shape contains .Flex
}

############
# Instance
############
resource "oci_core_instance" "instance" {
  count = var.instance_count
  // If no explicit AD number, spread instances on all ADs in round-robin. Looping to the first when last AD is reached
  availability_domain  = var.ad_number == null ? element(local.ADs, count.index) : element(local.ADs, var.ad_number - 1)
  compartment_id       = var.compartment_ocid
  display_name         = var.instance_display_name == "" ? "" : var.instance_count != "1" ? "${var.instance_display_name}_${count.index + 1}" : var.instance_display_name
  extended_metadata    = var.extended_metadata
  ipxe_script          = var.ipxe_script
  preserve_boot_volume = var.preserve_boot_volume
  shape                = var.shape
  shape_config {
    // If shape name contains ".Flex" and instance_flex inputs are not null, use instance_flex inputs values for shape_config block
    // Else use values from data.oci_core_shapes.ad1 for var.shape
    memory_in_gbs = local.shape_is_flex == true && var.instance_flex_memory_in_gbs != null ? var.instance_flex_memory_in_gbs : local.shapes_config[var.shape]["memory_in_gbs"]
    ocpus         = local.shape_is_flex == true && var.instance_flex_ocpus != null ? var.instance_flex_ocpus : local.shapes_config[var.shape]["ocpus"]
  }

  create_vnic_details {
    assign_public_ip = var.public_ip == "NONE" ? var.assign_public_ip : false
    display_name     = var.vnic_name == "" ? "" : var.instance_count != "1" ? "${var.vnic_name}_${count.index + 1}" : var.vnic_name
    hostname_label   = var.hostname_label == "" ? "" : var.instance_count != "1" ? "${var.hostname_label}-${count.index + 1}" : var.hostname_label
    private_ip = element(
      concat(var.private_ips, [""]),
      length(var.private_ips) == 0 ? 0 : count.index,
    )
    skip_source_dest_check = var.skip_source_dest_check
    // Current implementation requires providing a list of subnets when using ad-specific subnets
    subnet_id = data.oci_core_subnet.instance_subnet[count.index % length(data.oci_core_subnet.instance_subnet.*.id)].id

    freeform_tags = local.merged_freeform_tags
    defined_tags  = var.defined_tags
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_keys != null ? var.ssh_public_keys : file(var.ssh_authorized_keys)
    user_data           = var.user_data
  }

  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
    source_id               = var.source_ocid
    source_type             = var.source_type
  }

  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags

  timeouts {
    create = var.instance_timeout
  }
}

##################################
# Instance Credentials Datasource
##################################
data "oci_core_instance_credentials" "crendential" {
  count       = var.resource_platform != "linux" ? var.instance_count : 0
  instance_id = oci_core_instance.instance[count.index].id
}

#########
# Volume
#########
resource "oci_core_volume" "volume" {
  count               = var.instance_count * length(var.block_storage_sizes_in_gbs)
  availability_domain = oci_core_instance.instance[count.index % var.instance_count].availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${oci_core_instance.instance[count.index % var.instance_count].display_name}_volume${floor(count.index / var.instance_count)}"
  size_in_gbs = element(
    var.block_storage_sizes_in_gbs,
    floor(count.index / var.instance_count),
  )
  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags
}

####################
# Volume Attachment
####################
resource "oci_core_volume_attachment" "volume_attachment" {
  count           = var.instance_count * length(var.block_storage_sizes_in_gbs)
  attachment_type = var.attachment_type
  instance_id     = oci_core_instance.instance[count.index % var.instance_count].id
  volume_id       = oci_core_volume.volume[count.index].id
  use_chap        = var.use_chap
}

####################
# Networking
####################

data "oci_core_vnic_attachments" "vnic_attachment" {
  count          = var.instance_count
  compartment_id = var.compartment_ocid
  instance_id    = oci_core_instance.instance[count.index].id

  depends_on = [
    oci_core_instance.instance
  ]
}

data "oci_core_private_ips" "private_ips" {
  count   = var.instance_count
  vnic_id = data.oci_core_vnic_attachments.vnic_attachment[count.index].vnic_attachments[0].vnic_id

  depends_on = [
    oci_core_instance.instance
  ]
}

resource "oci_core_public_ip" "public_ip" {
  count          = var.public_ip == "NONE" ? 0 : var.instance_count
  compartment_id = var.compartment_ocid
  lifetime       = var.public_ip

  display_name  = var.public_ip_display_name != null ? var.public_ip_display_name : oci_core_instance.instance[count.index].display_name
  private_ip_id = data.oci_core_private_ips.private_ips[count.index].private_ips[0].id
  # public_ip_pool_id = oci_core_public_ip_pool.test_public_ip_pool.id # * (BYOIP CIDR Blocks) are not supported yet by this module.

  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags
}
