// Copyright (c) 2018, 2021 Oracle and/or its affiliates.

terraform {
  required_version = ">= 0.13" // terraform version below 0.12 is not tested/supported with this module
  required_providers {
    oci = {
      version = ">= 4.0.0" // force downloading oci-provider compatible with terraform v0.12
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

# # * This module will create 1 Flex Compute Instances, with a reserved public IP
module "instance_reserved_ip" {
  source = "oracle-terraform-modules/compute-instance/oci"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  freeform_tags    = var.freeform_tags
  defined_tags     = var.defined_tags
  # compute instance parameters
  ad_number                   = null
  instance_count              = 1
  instance_display_name       = "instance_reserved_ip"
  instance_state              = var.instance_state
  shape                       = var.shape
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  instance_flex_memory_in_gbs = 1 # only used if shape is Flex type
  instance_flex_ocpus         = 1 # only used if shape is Flex type
  # operating system parameters
  ssh_public_keys = var.ssh_public_keys
  # networking parameters
  public_ip    = var.public_ip # NONE, RESERVED or EPHEMERAL
  subnet_ocids = var.subnet_ocids
  # storage parameters
  boot_volume_backup_policy  = var.boot_volume_backup_policy
  block_storage_sizes_in_gbs = [] # no block volume will be created
  preserve_boot_volume       = false
}

output "instance_reserved_ip" {
  description = "IP information of the instances provisioned by this module."
  value       = module.instance_reserved_ip.instances_summary
}
