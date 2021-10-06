# Copyright (c) 2018, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

#############
# Boot Volume
#############

# Assign a backup policy to instance's boot volume

resource "oci_core_volume_backup_policy_assignment" "boot_volume_backup_policy" {
  # * The boot volume backup policy is controlled by var.boot_volume_backup_policy.
  # * You can choose between OCI default backup policies : gold, silver, bronze.
  # * If you set the variable to "disabled", no backup policy will be applied to the boot volume.
  count     = var.boot_volume_backup_policy != "disabled" ? var.instance_count : 0
  asset_id  = oci_core_instance.instance.*.boot_volume_id[count.index]
  policy_id = local.backup_policies[var.boot_volume_backup_policy]
}

#########
# Volume
#########
resource "oci_core_volume" "volume" {
  count               = var.instance_count * length(var.block_storage_sizes_in_gbs)
  availability_domain = oci_core_instance.instance[count.index % var.instance_count].availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${oci_core_instance.instance[count.index % var.instance_count].display_name}_volume${floor(count.index / var.instance_count)}"
  size_in_gbs = element(
    var.block_storage_sizes_in_gbs,
    floor(count.index / var.instance_count),
  )
  freeform_tags = local.merged_freeform_tags
  defined_tags  = var.defined_tags
}

####################
# Volume Attachment
####################
resource "oci_core_volume_attachment" "volume_attachment" {
  count           = var.instance_count * length(var.block_storage_sizes_in_gbs)
  attachment_type = var.attachment_type
  instance_id     = oci_core_instance.instance[count.index % var.instance_count].id
  volume_id       = oci_core_volume.volume[count.index].id
  use_chap        = var.use_chap
}
