// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

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

variable "shape" {
  description = "The shape of an instance."
  type        = string
  default     = "VM.Standard2.1"
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
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type        = string
}

variable "user_data" {
  description = "Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration."
  type        = string
  default     = null
}

# networking parameters

variable "assign_public_ip" {
  description = "Whether the VNIC should be assigned a public IP address."
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
