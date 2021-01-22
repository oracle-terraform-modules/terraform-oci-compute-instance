// Copyright (c) 2018, 2021 Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
}

variable "compartment_ocid" {
}

variable "instance_display_name" {
}

variable "subnet_ocids" {
  type = list(string)
}

variable "source_ocid" {
}

variable "ssh_authorized_keys" {
}

variable "block_storage_sizes_in_gbs" {
  type = list(string)
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "instance" {
  source = "../../"

  compartment_ocid           = var.compartment_ocid
  instance_display_name      = var.instance_display_name
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  ssh_authorized_keys        = var.ssh_authorized_keys
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}
