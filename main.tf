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
data "oci_core_subnet" "this" {
  count     = length(var.subnet_ocids)
  subnet_id = element(var.subnet_ocids, count.index)
}

############
# Instance
############
resource "oci_core_instance" "this" {
  count = var.instance_count
  // If no explicit AD number, spread instances on all ADs in round-robin. Looping to the first when last AD is reached
  availability_domain  = var.ad_number == null ? element(local.ADs, count.index) : element(local.ADs, var.ad_number - 1)
  compartment_id       = var.compartment_ocid
  display_name         = var.instance_display_name == "" ? "" : var.instance_count != "1" ? "${var.instance_display_name}_${count.index + 1}" : var.instance_display_name
  extended_metadata    = var.extended_metadata
  ipxe_script          = var.ipxe_script
  preserve_boot_volume = var.preserve_boot_volume
  shape                = var.shape

  create_vnic_details {
    assign_public_ip = var.assign_public_ip
    display_name     = var.vnic_name == "" ? "" : var.instance_count != "1" ? "${var.vnic_name}_${count.index + 1}" : var.vnic_name
    hostname_label   = var.hostname_label == "" ? "" : var.instance_count != "1" ? "${var.hostname_label}-${count.index + 1}" : var.hostname_label
    private_ip = element(
      concat(var.private_ips, [""]),
      length(var.private_ips) == 0 ? 0 : count.index,
    )
    skip_source_dest_check = var.skip_source_dest_check
    // Current implementation requires providing a list of subnets when using ad-specific subnets
    subnet_id = data.oci_core_subnet.this[count.index % length(data.oci_core_subnet.this.*.id)].id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_authorized_keys)
    user_data           = var.user_data
  }

  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
    source_id               = var.source_ocid
    source_type             = var.source_type
  }

  timeouts {
    create = var.instance_timeout
  }
}

##################################
# Instance Credentials Datasource
##################################
data "oci_core_instance_credentials" "this" {
  count       = var.resource_platform != "linux" ? var.instance_count : 0
  instance_id = oci_core_instance.this[count.index].id
}

#########
# Volume
#########
resource "oci_core_volume" "this" {
  count               = var.instance_count * length(var.block_storage_sizes_in_gbs)
  availability_domain = oci_core_instance.this[count.index % var.instance_count].availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${oci_core_instance.this[count.index % var.instance_count].display_name}_volume${floor(count.index / var.instance_count)}"
  size_in_gbs = element(
    var.block_storage_sizes_in_gbs,
    floor(count.index / var.instance_count),
  )
}

####################
# Volume Attachment
####################
resource "oci_core_volume_attachment" "this" {
  count           = var.instance_count * length(var.block_storage_sizes_in_gbs)
  attachment_type = var.attachment_type
  instance_id     = oci_core_instance.this[count.index % var.instance_count].id
  volume_id       = oci_core_volume.this[count.index].id
  use_chap        = var.use_chap
}

