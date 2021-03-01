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

# * This module will create a shape-based Compute Instance. OCPU and memory values are defined by the provided value for shape.
module "instance_nonflex" {
  source = "oracle-terraform-modules/compute-instance/oci"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  # compute instance parameters
  ad_number             = var.instance_ad_number
  instance_count        = var.instance_count
  instance_display_name = var.instance_display_name
  shape                 = var.shape
  source_ocid           = var.source_ocid
  source_type           = var.source_type
  # operating system parameters
  ssh_authorized_keys = var.ssh_authorized_keys
  # networking parameters
  assign_public_ip = var.assign_public_ip
  subnet_ocids     = var.subnet_ocids
  # storage parameters
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

output "instance_nonflex" {
  description = "ocid of created instances."
  value       = module.instance_nonflex.instances_summary
}

# * This module will create a shape-based Compute instance. OCPU and memory values are defined by the provided value for shape.
# * `instance_flex_memory_in_gbs` and ìnstance_flex_ocpus` values are ignored because the selected shape is not Flex.
module "instance_nonflex_custom" {
  source = "oracle-terraform-modules/compute-instance/oci"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  # compute instance parameters
  ad_number                   = var.instance_ad_number
  instance_count              = var.instance_count
  instance_display_name       = "instance_nonflex_custom"
  shape                       = var.shape
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  instance_flex_memory_in_gbs = 8 # only used if shape is Flex type
  instance_flex_ocpus         = 1 # only used if shape is Flex type
  # operating system parameters
  ssh_authorized_keys = var.ssh_authorized_keys
  # networking parameters
  assign_public_ip = var.assign_public_ip
  subnet_ocids     = var.subnet_ocids
  # storage parameters
  block_storage_sizes_in_gbs = [] # no block volume will be created
}

output "instance_nonflex_custom" {
  description = "ocid of created instances."
  value       = module.instance_nonflex_custom.instances_summary
}
