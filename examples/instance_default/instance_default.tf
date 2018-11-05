// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "instance_display_name" {}

variable "subnet_ocids" {
  type = "list"
}

variable "source_ocid" {}
variable "ssh_authorized_keys" {}
variable "vcn_ocid" {}

variable "block_storage_sizes_in_gbs" {
  type = "list"
}

provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}

module "instance" {
  source = "../../"

  #source                    = "oracle-terraform-modules/compute-instance/oci"
  compartment_ocid           = "${var.compartment_ocid}"
  instance_display_name      = "${var.instance_display_name}"
  source_ocid                = "${var.source_ocid}"
  vcn_ocid                   = "${var.vcn_ocid}"
  subnet_ocids               = "${var.subnet_ocids}"
  ssh_authorized_keys        = "${var.ssh_authorized_keys}"
  block_storage_sizes_in_gbs = "${var.block_storage_sizes_in_gbs}"
}
