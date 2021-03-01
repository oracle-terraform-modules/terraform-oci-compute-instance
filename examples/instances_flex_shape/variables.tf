# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider identity parameters
variable "fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "private_key_path" {
  description = "path to oci api private key used"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "region" {
  description = "the oci region where resources will be created"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
}

variable "tenancy_ocid" {
  description = "tenancy ocid where to create the sources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "user_ocid" {
  description = "ocid of user that terraform will use to create the resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

# general oci parameters

variable "compartment_ocid" {
  description = "compartment ocid where to create all resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

# compute instance parameters

variable "instance_ad_number" {
  description = "The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin."
  type        = number
  default     = 1
}

variable "instance_count" {
  description = "Number of identical instances to launch from a single module."
  type        = number
  default     = 1
}

variable "instance_display_name" {
  description = "(Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable."
  type        = string
  default     = "module_instance_flex"
}

variable "instance_flex_memory_in_gbs" {
  type        = number
  description = "(Updatable) The total amount of memory available to the instance, in gigabytes."
  default     = null
}

variable "instance_flex_ocpus" {
  type        = number
  description = "(Updatable) The total number of OCPUs available to the instance."
  default     = null
}

variable "shape" {
  description = "The shape of an instance."
  type        = string
  default     = "VM.Standard.E3.Flex"
}

variable "source_ocid" {
  description = "The OCID of an image or a boot volume to use, depending on the value of source_type."
  type        = string
}

variable "source_type" {
  description = "The source type for the instance."
  type        = string
  default     = "image"
}

# operating system parameters

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type        = string
}

# networking parameters

variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address."
  type        = bool
  default     = false
}

variable "subnet_ocids" {
  description = "The unique identifiers (OCIDs) of the subnets in which the instance primary VNICs are created."
  type        = list(string)
}

# storage parameters

variable "block_storage_sizes_in_gbs" {
  description = "Sizes of volumes to create and attach to each instance."
  type        = list(string)
  default     = [50]
}









