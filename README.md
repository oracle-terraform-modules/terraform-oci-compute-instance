# Oracle Cloud Infrastructure Terraform Module for Compute Instance

This Module provides an easy way to launch compute instances with advanced settings and good practices embedded.

On top of the compute instance capabilities, this module can also provision and attach additional Block Volumes to the instances.

**Please Note:**

> All Oracle-provided images include firewall rules that allow only "root" on Linux instances or "Administrators" on Windows Server instances to make outgoing connections to the iSCSI network endpoints (169.254.0.2:3260, 169.254.2.0/24:3260) that serve the instance's boot and block volumes.
>
> Oracle recommends that you do not use custom images without these rules unless you understand the security risks. See [Compute Best Practices](https://docs.cloud.oracle.com/iaas/Content/Compute/References/bestpracticescompute.htm#two) for recommendations on how to manage instances.

## Maintainers

This module is maintained by Oracle.

## Requirements

The diagram below summarizes the required components and their respective versions to use this module.

![versions](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/docs/diagrams/versions.svg?raw=true&sanitize=true)

To enforce versions compatibility of both Terraform and the OCI provider, your root configuration should ideally include this block in `main.tf` for version pinning:

```HCL
terraform {
  required_version = ">= 0.12"
  required_providers {
    oci = {
      version = ">= 3.27"
    }
  }
}
```

For detailed information about inputs and outputs, and potential sub-modules, see [docs/terraformoptions](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/docs/terraformoptions.adoc).

## How to use this module

*See [Oracle Cloud Infrastructure documentation](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm) to get started with the Oracle Cloud Infrastructure Terraform Provider.*

The [examples](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/tree/master/examples/) folder contains detailed examples that shows how to use this module. The following code example creates an Oracle Cloud Infrastructure compute instance on AD-1 with an additional Block Volume attached:

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
  block_storage_sizes_in_gbs = [50]
  shape                      = var.shape
}
```

## What's coming next for this module?

The current focus is to get back in close the gap between this module and the provider's capabilities. We started with a complete code base update for [HCL2 syntax compatibility](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/releases/tag/v2.0.2), then adding support for [Regional Subnets](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/releases/tag/v2.0.4) and now [Flexible Shapes](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/pull/49).

We will continue to push in that direction with the goal of [feature parity with the provider's capabilities](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/projects/4), as well as adding more features and integration points with other OCI services: Block Volume Backups, Secondary VNICs and IPs, etc ...

Compute Instances are also a perfect place to illustrate [module composition principles](https://www.terraform.io/docs/language/modules/develop/composition.html) reusing the other existing official Terraform OCI Modules

## Configuring iSCSI volume attachments

- For guidance configuring iSCSI on a Windows platform, see [Adding a Block Volume to a Windows Instance](https://docs.cloud.oracle.com/iaas/Content/GSG/Tasks/addingstorageForWindows.htm).

- For guidance configuring iSCSI on a Linux platform, see [iSCSI Commands and Information](https://docs.cloud.oracle.com/iaas/Content/Block/Concepts/iscsiinformation.htm). See also this example of inline iSCSI commands execution using `iscsiadm` CLI called from terraform file: [instance.tf](https://github.com/terraform-providers/terraform-provider-oci/blob/master/examples/compute/instance/instance.tf).

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

## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community: raising issues, improving documentation, fixing bugs, or adding new features.

Learn how to [contribute](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/CONTRIBUTING.adoc).

[Folks who contributed](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/CONTRIBUTORS.adoc) with explanations, code, feedback, ideas, testing etc.

## License

Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/LICENSE.txt) for more details.
