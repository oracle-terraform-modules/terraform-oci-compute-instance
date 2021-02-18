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
  type    = string
  default = null
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

# * This module will create a Flex Compute Instance, using default values: 1 OCPU, 16 GB memory.
module "instance_flex" {
  source                     = "../../"
  instance_count             = 1
  shape                      = "VM.Standard.E3.Flex"
  ad_number                  = 1
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = "instance_flex"
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  ssh_authorized_keys        = var.ssh_authorized_keys
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
  assign_public_ip           = var.assign_public_ip
}

# * This module will create a Flex Compute Instance, using values provided by the module: 1 OCPU, 1 GB memory.
module "instance_flex_custom" {
  source                      = "../../"
  instance_count              = 2
  shape                       = "VM.Standard.E3.Flex"
  instance_flex_memory_in_gbs = 1
  instance_flex_ocpus         = 1
  ad_number                   = 1
  compartment_ocid            = var.compartment_ocid
  instance_display_name       = "instance_flex_custom"
  source_ocid                 = var.source_ocid
  subnet_ocids                = var.subnet_ocids
  ssh_authorized_keys         = var.ssh_authorized_keys
  block_storage_sizes_in_gbs  = var.block_storage_sizes_in_gbs
  assign_public_ip            = var.assign_public_ip
}

# * This module will create a shape-based Compute Instance. OCPU and memory values are defined by the shape.
module "instance_nonflex" {
  source                     = "../../"
  instance_count             = 1
  shape                      = "VM.Standard2.1"
  ad_number                  = 2
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = "instance_nonflex"
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  ssh_authorized_keys        = var.ssh_authorized_keys
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
  assign_public_ip           = var.assign_public_ip
}

# * This module will create a shape-based Compute instance. OCPU and memory values are defined by the shape.
# * `instance_flex_memory_in_gbs` and ìnstance_flex_ocpus` values are ignored.
module "instance_nonflex_custom" {
  source                      = "../../"
  instance_count              = 1
  shape                       = "VM.Standard2.1"
  instance_flex_memory_in_gbs = 8
  instance_flex_ocpus         = 1
  ad_number                   = 2
  compartment_ocid            = var.compartment_ocid
  instance_display_name       = "instance_nonflex_custom"
  source_ocid                 = var.source_ocid
  subnet_ocids                = var.subnet_ocids
  ssh_authorized_keys         = var.ssh_authorized_keys
  block_storage_sizes_in_gbs  = var.block_storage_sizes_in_gbs
  assign_public_ip            = var.assign_public_ip
}
