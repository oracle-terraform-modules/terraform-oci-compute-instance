# Oracle Cloud Infrastructure Compute Instance Terraform Module

The Oracle Cloud Infrastructure Compute Instance Terraform Module provides an easy way to launch compute instances and optionally create and attach any number of block volumes.

Please Note:

* Oracle-provided images include firewall rules that restrict access to the boot and block volumes. Oracle recommends that you do not use custom images without these rules unless you understand the security risks. See [Compute Best Practices](https://docs.cloud.oracle.com/iaas/Content/Compute/References/bestpracticescompute.htm#two) for recommendations on how to manage instances.

## Prerequisites

See the [Oracle Cloud Infrastructure Terraform Provider docs](https://www.terraform.io/docs/providers/oci/index.html) for information about setting up and using the Oracle Cloud Infrastructure Terraform Provider.

## How to use this module

The [examples](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/tree/master/examples/instance_default) folder contains a detailed example that shows how to use this module.

The following code example creates an Oracle Cloud Infrastructure compute instance:

```hcl
module "instance" {
  source = "oracle-terraform-modules/compute-instance/oci"

  compartment_ocid           = "${var.compartment_ocid}"
  instance_display_name      = "${var.instance_display_name}"
  source_ocid                = "${var.source_ocid}"
  subnet_ocids               = "${var.subnet_ocids}"
  ssh_authorized_keys        = "${var.ssh_authorized_keys_file}"
  block_storage_sizes_in_gbs = [60, 70]
}
```

**Following are arguments available to the Compute Instance module:**

Argument | Description
--- | ---
compartment_ocid | Unique Oracle Cloud Identifier (OCID) of the compartment in which the VCN is created
instance_display_name | Display name of the compute instance
extended_metadata | Additional metadata key/value pairs provided by the user
ipxe_script | The iPXE script which initiates the boot process on the compute instance
preserve_boot_volume | Specifies whether to delete or preserve the boot volume when the instance is terminated
boot_volume_size_in_gbs | The size of the boot volume in GBs
shape | The instance shape
assign_public_ip | Specifies whether the VNIC should be assigned a public IP address
vnic_name | A user-friendly name for the VNIC
hostname_label | The hostname for the VNIC's primary private IP
private_ips | A list of private IP address of your choice to assign to the VNIC
skip_source_dest_check | Specifies whether the source/destination check is disabled on the VNIC
subnet_ocids | A list of the subnet OCIDs in which to place the instance's primary VNICs
ssh_authorized_keys | Path to the public SSH keys to place in the instance's **~/.ssh/authorized_keys** file for the default user on the instance
user_data | User-defined base64-encoded data to be used by `Cloud-Init` to run custom scripts, or provide a custom `Cloud-Init` configuration
source_ocid | Unique Oracle Cloud Identifier (OCID) of an image or a boot volume to use as source of instance creation, depending on the value of source_type. For more information, see [Oracle Cloud Infrastructure Images](https://docs.cloud.oracle.com/iaas/images/)
source_type | The source type for the instance
instance_timeout | Timeout setting for creating instance(Note: large instance types may need larger timeout than the default 25m)
instance_count | Number of instances to launch
block_storage_sizes_in_gbs | The size in GBs of block volumes created and attached to each instance
attachment_type | The type of volume attachment. Allowed values are: iscsi, paravirtualized
use_chap | Whether to use CHAP authentication for the volume attachment
resource_platform | Platform in which to create resources
vcn_ocid | Unique identifier (OCID) of the VCN

## Windows remote scripts execution
Terraform supports using Windows Remote Management (WinRM) for connecting to Windows instances. Ensure that your Windows image has WinRM properly configured to allow remote access. Following is a sample WinRM configuration:

```hcl
winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}’'
winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
```

## Configure iSCSI volume attachments
* For guidance configuring iSCSI on a Windows platform, see [Adding a Block Volume to a Windows Instance](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/addingstorageForWindows.htm).

* For guidance configuring iSCSI on a Linux platform, see [iSCSI Commands and Information](https://docs.cloud.oracle.com/iaas/Content/Block/Concepts/iscsiinformation.htm). See also this example of inline iSCSI commands execution using `iscsiadm` CLI called from terraform file: [instance.tf](https://github.com/terraform-providers/terraform-provider-oci/blob/master/examples/compute/instance/instance.tf).


## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community. 

Learn how to [contribute](CONTRIBUTING.md).

[Folks who contributed with explanations, code, feedback, ideas, testing etc.](CONTRIBUTORS.md)

## License

Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/LICENSE.txt) for more details.
