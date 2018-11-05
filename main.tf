// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

####################
# Subnet Datasource
####################
data "oci_core_subnets" "this" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${var.vcn_ocid}"

  filter {
    name   = "id"
    values = ["${var.subnet_ocids}"]
  }
}

############
# Instance
############
resource "oci_core_instance" "this" {
  count                = "${var.instance_count}"
  availability_domain  = "${lookup(data.oci_core_subnets.this.subnets[count.index % length(data.oci_core_subnets.this.subnets)], "availability_domain")}"
  compartment_id       = "${var.compartment_ocid}"
  display_name         = "${var.instance_display_name == "" ? "" : "${var.instance_count != "1" ? "${var.instance_display_name}_${count.index + 1}" : "${var.instance_display_name}"}"}"
  extended_metadata    = "${var.extended_metadata}"
  ipxe_script          = "${var.ipxe_script}"
  preserve_boot_volume = "${var.preserve_boot_volume}"
  shape                = "${var.shape}"

  create_vnic_details {
    assign_public_ip       = "${var.assign_public_ip}"
    display_name           = "${var.vnic_name == "" ? "" : "${var.instance_count != "1" ? "${var.vnic_name}_${count.index + 1}" : "${var.vnic_name}"}"}"
    hostname_label         = "${var.hostname_label == "" ? "" : "${var.instance_count != "1" ? "${var.hostname_label}-${count.index + 1}" : "${var.hostname_label}"}"}"
    private_ip             = "${element(var.private_ips, length(var.private_ips) == 1 ? 0 : count.index)}"
    skip_source_dest_check = "${var.skip_source_dest_check}"
    subnet_id              = "${lookup(data.oci_core_subnets.this.subnets[count.index % length(data.oci_core_subnets.this.subnets)], "id")}"
  }

  metadata {
    ssh_authorized_keys = "${file("${var.ssh_authorized_keys}")}"
    user_data           = "${var.user_data}"
  }

  source_details {
    boot_volume_size_in_gbs = "${var.boot_volume_size_in_gbs}"
    source_id               = "${var.source_ocid}"
    source_type             = "${var.source_type}"
  }

  timeouts {
    create = "${var.instance_timeout}"
  }
}

#########
# Volume
#########
resource "oci_core_volume" "this" {
  count               = "${var.instance_count * length(var.block_storage_sizes_in_gbs)}"
  availability_domain = "${oci_core_instance.this.*.availability_domain[count.index % var.instance_count]}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${oci_core_instance.this.*.display_name[count.index % var.instance_count]}_volume${count.index / var.instance_count}"
  size_in_gbs         = "${element(var.block_storage_sizes_in_gbs, count.index / var.instance_count)}"
}

####################
# Volume Attachment
####################
resource "oci_core_volume_attachment" "this" {
  count           = "${var.instance_count * length(var.block_storage_sizes_in_gbs)}"
  attachment_type = "${var.attachment_type}"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.this.*.id[count.index % var.instance_count]}"
  volume_id       = "${oci_core_volume.this.*.id[count.index]}"
  use_chap        = "${var.use_chap}"
}
