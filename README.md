# Oracle Cloud Infrastructure Compute Instance Terraform Module

The Oracle Cloud Infrastructure Compute Instance Terraform Module provides an easy way to launch compute instances and optionally create and attach any number of block volumes.

Please Note:

- Oracle-provided images include firewall rules that restrict access to the boot and block volumes. Oracle recommends that you do not use custom images without these rules unless you understand the security risks. See [Compute Best Practices](https://docs.cloud.oracle.com/iaas/Content/Compute/References/bestpracticescompute.htm#two) for recommendations on how to manage instances.

## Prerequisites

See the [Oracle Cloud Infrastructure Terraform Provider docs](https://www.terraform.io/docs/providers/oci/index.html) for information about setting up and using the Oracle Cloud Infrastructure Terraform Provider.

## How to use this module

The [examples](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/tree/master/examples/instance_default) folder contains a detailed example that shows how to use this module.

The following code example creates an Oracle Cloud Infrastructure compute instance:

```hcl
module "instance" {
  source = "oracle-terraform-modules/compute-instance/oci"
  instance_count             = 1 # how many instances do you want?
  ad_number                  = 1 # AD number to provision instances. If null, instances are provisionned in a rolling manner starting with AD1
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = var.instance_display_name
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  assign_public_ip           = var.assign_public_ip
  ssh_authorized_keys        = var.ssh_authorized_keys_file
  block_storage_sizes_in_gbs = [60, 70]
  shape                      = var.shape
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| oci | >= 3.27 |

## Providers

| Name | Version |
|------|---------|
| oci | >= 3.27 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ad\_number | (Optional) The availability domain number of the instance. If none is provided, it will start with AD-1 and continue in round-robin. | `number` | `null` | no |
| assign\_public\_ip | Whether the VNIC should be assigned a public IP address. | `bool` | `false` | no |
| attachment\_type | (Optional) The type of volume. The only supported values are iscsi and paravirtualized. | `string` | `"paravirtualized"` | no |
| block\_storage\_sizes\_in\_gbs | Sizes of volumes to create and attach to each instance. | `list(number)` | `[]` | no |
| boot\_volume\_size\_in\_gbs | The size of the boot volume in GBs. | `number` | `null` | no |
| compartment\_ocid | (Required) (Updatable) The OCID of the compartment where to create all resources | `string` | n/a | yes |
| extended\_metadata | (Optional) (Updatable) Additional metadata key/value pairs that you provide. | `map(any)` | `{}` | no |
| hostname\_label | The hostname for the VNIC's primary private IP. | `string` | `""` | no |
| instance\_count | Number of instances to launch. | `number` | `1` | no |
| instance\_display\_name | (Optional) (Updatable) A user-friendly name for the instance. Does not have to be unique, and it's changeable. | `string` | `""` | no |
| instance\_flex\_memory\_in\_gbs | (Optional) (Updatable) The total amount of memory available to the instance, in gigabytes. | `number` | `null` | no |
| instance\_flex\_ocpus | (Optional) (Updatable) The total number of OCPUs available to the instance. | `number` | `null` | no |
| instance\_timeout | Timeout setting for creating instance. | `string` | `"25m"` | no |
| ipxe\_script | (Optional) The iPXE script which to continue the boot process on the instance. | `string` | `null` | no |
| preserve\_boot\_volume | Specifies whether to delete or preserve the boot volume when terminating an instance. | `bool` | `false` | no |
| private\_ips | Private IP addresses of your choice to assign to the VNICs. | `list(string)` | `[]` | no |
| resource\_platform | Platform to create resources in. | `string` | `"linux"` | no |
| shape | The shape of an instance. | `string` | `"VM.Standard2.1"` | no |
| skip\_source\_dest\_check | Whether the source/destination check is disabled on the VNIC. | `bool` | `false` | no |
| source\_ocid | The OCID of an image or a boot volume to use, depending on the value of source\_type. | `string` | n/a | yes |
| source\_type | The source type for the instance. | `string` | `"image"` | no |
| ssh\_authorized\_keys | Public SSH keys path to be included in the ~/.ssh/authorized\_keys file for the default user on the instance. | `string` | n/a | yes |
| subnet\_ocids | The unique identifiers (OCIDs) of the subnets in which the instance primary VNICs are created. | `list(string)` | n/a | yes |
| use\_chap | (Applicable when attachment\_type=iscsi) Whether to use CHAP authentication for the volume attachment. | `bool` | `false` | no |
| user\_data | Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide custom Cloud-Init configuration. | `string` | `null` | no |
| vnic\_name | A user-friendly name for the VNIC. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_id | ocid of created instances. |
| instance\_password | Passwords to login to Windows instance. |
| instance\_username | Usernames to login to Windows instance. |
| instances\_summary | Private and Public IPs for each instance. |
| private\_ip | Private IPs of created instances. |
| public\_ip | Public IPs of created instances. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Windows remote scripts execution

Terraform supports using Windows Remote Management (WinRM) for connecting to Windows instances. Ensure that your Windows image has WinRM properly configured to allow remote access. Following is a sample WinRM configuration:

```HCL
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

- For guidance configuring iSCSI on a Windows platform, see [Adding a Block Volume to a Windows Instance](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/addingstorageForWindows.htm).

- For guidance configuring iSCSI on a Linux platform, see [iSCSI Commands and Information](https://docs.cloud.oracle.com/iaas/Content/Block/Concepts/iscsiinformation.htm). See also this example of inline iSCSI commands execution using `iscsiadm` CLI called from terraform file: [instance.tf](https://github.com/terraform-providers/terraform-provider-oci/blob/master/examples/compute/instance/instance.tf).

## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.

Learn how to [contribute](CONTRIBUTING.md).

[Folks who contributed with explanations, code, feedback, ideas, testing etc.](CONTRIBUTORS.md)

## License

Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/LICENSE.txt) for more details.
