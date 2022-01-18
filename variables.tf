# Copyright (c) 2018, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general oci parameters

variable "compartment_ocid" {
  description = "(Updatable) The OCID of the compartment where to create all resources"
  type        = string
}

variable "instance_timeout" {
  description = "Timeout setting for creating instance."
  type        = string
  default     = "25m"
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the resources created using freeform tags."
  type        = map(string)
  default     = null
}

variable "defined_tags" {
  description = "predefined and scoped to a namespace to tag the resources created using defined tags."
  type        = map(string)
  default     = null
}

locals {
  default_freeform_tags = {
    # * This list of freeform tags are added by default to user provided freeform tags (var.freeform_tags) if local.merged_freeform_tags is used
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-modules/compute-instance/oci"
  }
  merged_freeform_tags = merge(local.default_freeform_tags, var.freeform_tags)
}

# compute instance parameters

variable "ad_number" {
  description = "The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin."
  type        = number
  default     = null
}

# variable "fd_number" {
#   // for future use, adding fault domain support
#   description = "(Updatable) The fault domain of the instance."
#   type        = number
#   default     = null
# }

variable "instance_count" {
  description = "Number of identical instances to launch from a single module."
  type        = number
  default     = 1
}

variable "instance_display_name" {
  description = "(Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable."
  type        = string
  default     = ""
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

variable "instance_state" {
  type        = string
  description = "(Updatable) The target state for the instance. Could be set to RUNNING or STOPPED."
  default     = "RUNNING"

  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.instance_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "shape" {
  description = "The shape of an instance."
  type        = string
  default     = "VM.Standard2.1"
}

variable "baseline_ocpu_utilization" {
  description = "(Updatable) The baseline OCPU utilization for a subcore burstable VM instance"
  type        = string
  default     = "BASELINE_1_1"

  validation {
    condition     = contains(["BASELINE_1_8", "BASELINE_1_2", "BASELINE_1_1"], var.baseline_ocpu_utilization)
    error_message = "Accepted values are BASELINE_1_8, BASELINE_1_2 or BASELINE_1_1."
  }
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

variable "extended_metadata" {
  description = "(Updatable) Additional metadata key/value pairs that you provide."
  type        = map(any)
  default     = {}
}

variable "resource_platform" {
  description = "Platform to create resources in."
  type        = string
  default     = "linux"
}

variable "ssh_authorized_keys" {
  #! Deprecation notice: Please use `ssh_public_keys` instead
  description = "DEPRECATED: use ssh_public_keys instead. Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance. To provide multiple keys, see docs/instance_ssh_keys.adoc."
  type        = string
  default     = null
}

variable "user_data" {
  description = "Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration."
  type        = string
  default     = null
}

# networking parameters

variable "assign_public_ip" {
  #! Deprecation notice: will be removed at next major release. Use `var.public_ip` instead.
  description = "Deprecated: use `var.public_ip` instead. Whether the VNIC should be assigned a public IP address (Always EPHEMERAL)."
  type        = bool
  default     = false
}

variable "hostname_label" {
  description = "The hostname for the VNIC's primary private IP."
  type        = string
  default     = ""
}

variable "ipxe_script" {
  description = "(Optional) The iPXE script which to continue the boot process on the instance."
  type        = string
  default     = null
}

variable "private_ips" {
  description = "Private IP addresses of your choice to assign to the VNICs."
  type        = list(string)
  default     = []
}

variable "public_ip" {
  description = "Whether to create a Public IP to attach to primary vnic and which lifetime. Valid values are NONE, RESERVED or EPHEMERAL."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "RESERVED", "EPHEMERAL"], var.public_ip)
    error_message = "Accepted values are NONE, RESERVED or EPHEMERAL."
  }
}

variable "public_ip_display_name" {
  description = "(Updatable) A user-friendly name. Does not have to be unique, and it's changeable."
  type        = string
  default     = null
}

variable "skip_source_dest_check" {
  description = "Whether the source/destination check is disabled on the VNIC."
  type        = bool
  default     = false
}

variable "subnet_ocids" {
  description = "The unique identifiers (OCIDs) of the subnets in which the instance primary VNICs are created."
  type        = list(string)
}

variable "vnic_name" {
  description = "A user-friendly name for the VNIC."
  type        = string
  default     = ""
}

variable "primary_vnic_nsg_ids" {
  description = "A list of the OCIDs of the network security groups (NSGs) to add the primary VNIC to"
  type        = list(string)
  default     = null
}

# storage parameters

variable "attachment_type" {
  description = "(Optional) The type of volume. The only supported values are iscsi and paravirtualized."
  type        = string
  default     = "paravirtualized"
}

variable "block_storage_sizes_in_gbs" {
  description = "Sizes of volumes to create and attach to each instance."
  type        = list(number)
  default     = []
}

# variable "block_storage_enable_autotune" {
#   // for future use, adding block volume performance auto-tune
#   description = "(Optional) (Updatable) Specifies whether the auto-tune performance is enabled for this volume."
#   type        = bool
#   default     = true
# }

variable "boot_volume_backup_policy" {
  description = "Choose between default backup policies : gold, silver, bronze. Use disabled to affect no backup policy on the Boot Volume."
  type        = string
  default     = "disabled"

  validation {
    condition     = contains(["gold", "silver", "bronze", "disabled"], var.boot_volume_backup_policy)
    error_message = "Accepted values are gold, silver, bronze or disabled (case sensitive)."
  }
}

variable "boot_volume_size_in_gbs" {
  description = "The size of the boot volume in GBs."
  type        = number
  default     = null
}

variable "preserve_boot_volume" {
  description = "Specifies whether to delete or preserve the boot volume when terminating an instance."
  type        = bool
  default     = false
}

variable "use_chap" {
  description = "(Applicable when attachment_type=iscsi) Whether to use CHAP authentication for the volume attachment."
  type        = bool
  default     = false
}
