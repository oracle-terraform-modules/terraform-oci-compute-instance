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
  instance_state              = var.instance_state
  shape                       = var.shape
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  instance_flex_memory_in_gbs = var.instance_flex_memory_in_gbs # only used if shape is Flex type
  instance_flex_ocpus         = 1                               # only used if shape is Flex type
  baseline_ocpu_utilization = var.baseline_ocpu_utilization
  # operating system parameters
  ssh_public_keys = var.ssh_public_keys
  # networking parameters
  public_ip            = var.public_ip # NONE, RESERVED or EPHEMERAL
  subnet_ocids         = [oci_core_subnet.example_sub.id]
  primary_vnic_nsg_ids = [oci_core_network_security_group.example_nsg.id]
  # storage parameters
  boot_volume_backup_policy  = var.boot_volume_backup_policy
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}

output "instance_flex" {
  description = "ocid of created instances."
  value       = module.instance_flex.instances_summary
}

module "example_vcn" {
  source = "oracle-terraform-modules/vcn/oci"

  # general oci parameters
  compartment_id = var.compartment_ocid

  # vcn parameters
  lockdown_default_seclist = false # boolean: true or false
}

resource "oci_core_network_security_group" "example_nsg" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = module.example_vcn.vcn_id

  #Optional
  display_name  = "NSG_example"
  freeform_tags = var.freeform_tags
}

resource "oci_core_subnet" "example_sub" {
  #Required
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.compartment_ocid
  vcn_id         = module.example_vcn.vcn_id

  #Optional
  display_name               = "example-sub"
  dns_label                  = "example"
  prohibit_public_ip_on_vnic = true
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
# instance_state                = var.instance_state
#   shape                       = var.shape
#   source_ocid                 = var.source_ocid
#   source_type                 = var.source_type
#   instance_flex_memory_in_gbs = 1 # only used if shape is Flex type
#   instance_flex_ocpus         = 1 # only used if shape is Flex type
#   # operating system parameters
#   ssh_public_key = var.ssh_public_key
#   # networking parameters
#   public_ip    = var.public_ip # NONE, RESERVED or EPHEMERAL
#   subnet_ocids     = var.subnet_ocids
#   # storage parameters
#   boot_volume_backup_policy = "silver"
#   block_storage_sizes_in_gbs = [] # no block volume will be created
# }

# output "instance_flex_custom" {
#   description = "ocid of created instances."
#   value       = module.instance_flex_custom.instances_summary
# }
