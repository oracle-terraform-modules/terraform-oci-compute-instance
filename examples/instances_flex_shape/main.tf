// Copyright (c) 2018, 2021 Oracle and/or its affiliates.

terraform {
  required_version = ">= 0.12" // terraform version below 0.12 is not tested/supported with this module
  required_providers {
    oci = {
      version = ">= 3.27" // force downloading oci-provider compatible with terraform v0.12
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# * This module will create a Flex Compute Instance, using default values: 1 OCPU, 16 GB memory.
# * `instance_flex_memory_in_gbs` and `instance_flex_ocpus` are not provided: default values will be applied.
module "instance_flex" {
  source = "oracle-terraform-modules/compute-instance/oci"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  freeform_tags    = var.freeform_tags
  defined_tags     = var.defined_tags
  # compute instance parameters
  ad_number                   = var.instance_ad_number
  instance_count              = var.instance_count
  instance_display_name       = var.instance_display_name
  shape                       = var.shape
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  instance_flex_memory_in_gbs = 1 # only used if shape is Flex type
  instance_flex_ocpus         = 1 # only used if shape is Flex type
  # operating system parameters
  ssh_public_keys = var.ssh_public_keys
  # networking parameters
  assign_public_ip = var.assign_public_ip
  subnet_ocids     = var.subnet_ocids
  # storage parameters
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

output "instance_flex" {
  description = "ocid of created instances."
  value       = module.instance_flex.instances_summary
}

# # # * This module will create 4 Flex Compute Instances, using values provided to the module: 1 OCPU, 1 GB memory.
# module "instance_flex_custom" {
#   source = "oracle-terraform-modules/compute-instance/oci"
#   # general oci parameters
#   compartment_ocid = var.compartment_ocid
#   freeform_tags    = var.freeform_tags
#   defined_tags     = var.defined_tags
#   # compute instance parameters
#   ad_number                   = null
#   instance_count              = 4
#   instance_display_name       = "instance_flex_custom"
#   shape                       = var.shape
#   source_ocid                 = var.source_ocid
#   source_type                 = var.source_type
#   instance_flex_memory_in_gbs = 1 # only used if shape is Flex type
#   instance_flex_ocpus         = 1 # only used if shape is Flex type
#   # operating system parameters
#   ssh_public_key = var.ssh_public_key
#   # networking parameters
#   assign_public_ip = var.assign_public_ip
#   subnet_ocids     = var.subnet_ocids
#   # storage parameters
#   block_storage_sizes_in_gbs = [] # no block volume will be created
# }

# output "instance_flex_custom" {
#   description = "ocid of created instances."
#   value       = module.instance_flex_custom.instances_summary
# }
