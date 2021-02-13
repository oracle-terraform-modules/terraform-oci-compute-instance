// Copyright (c) 2018, 2021 Oracle and/or its affiliates.

variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "instance_display_name" {
  type = string
}

variable "subnet_ocids" {
  type = list(string)
}

variable "source_ocid" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
}

variable "block_storage_sizes_in_gbs" {
  type = list(string)
}

variable "shape" {
  type = string
}

variable "assign_public_ip" {
  type = bool
}

variable "instance_count" {
  type = number
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "instance" {
  source                     = "../../"
  instance_count             = var.instance_count
  ad_number                  = 3
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = var.instance_display_name
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  ssh_authorized_keys        = var.ssh_authorized_keys
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
  shape                      = var.shape
  assign_public_ip           = var.assign_public_ip
}
