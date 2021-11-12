# Oracle Cloud Infrastructure Terraform Module for Compute Instance

This module provides an easy way to launch compute instances with advanced settings and good practices embedded.

On top of the compute instance capabilities, this module can also:

- provision and attach additional Block Volumes to the instances,
- assign a reserved public IP, instead of using Ephemeral,
- assign a backup policy for boot volumes

**Please Note:**

> All Oracle-provided images include firewall rules that allow only "root" on Linux instances or "Administrators" on Windows Server instances to make outgoing connections to the iSCSI network endpoints (169.254.0.2:3260, 169.254.2.0/24:3260) that serve the instance's boot and block volumes.
>
> Oracle recommends that you do not use custom images without these rules unless you understand the security risks. See [Compute Best Practices](https://docs.cloud.oracle.com/iaas/Content/Compute/References/bestpracticescompute.htm#two) for recommendations on how to manage instances.

## Requirements

The diagram below summarizes the required components and their respective versions to use this module.

![versions](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/docs/diagrams/versions.svg?raw=true&sanitize=true)

To enforce versions compatibility of both Terraform and the OCI provider, your root configuration should ideally include this block for version pinning:

```HCL
terraform {
  required_version = ">= 0.12.6"
  required_providers {
    oci = {
      version = ">= 4.0.0"
    }
  }
}
```

For detailed information about inputs and outputs, and potential sub-modules, see [docs/terraformoptions](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/docs/terraformoptions.adoc).

## How to use this module

*See [Oracle Cloud Infrastructure documentation](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm) to get started with the Oracle Cloud Infrastructure Terraform Provider.*

The [examples](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/tree/main/examples/) folder contains detailed examples that shows how to use this module. The following code example creates an Oracle Cloud Infrastructure compute instance on AD-1 with an additional Block Volume attached:

```hcl
module "instance" {
  source = "oracle-terraform-modules/compute-instance/oci"
  instance_count             = 1 # how many instances do you want?
  ad_number                  = 1 # AD number to provision instances. If null, instances are provisionned in a rolling manner starting with AD1
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = var.instance_display_name
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  public_ip                  = var.public_ip # NONE, RESERVED or EPHEMERAL
  ssh_public_keys            = var.ssh_public_keys
  block_storage_sizes_in_gbs = [50]
  shape                      = var.shape
  instance_state             = var.instance_state # RUNNING or STOPPED
  boot_volume_backup_policy  = var.boot_volume_backup_policy # disabled, gold, silver or bronze
}
```

## What's coming next for this module?

The current focus is to close the gap between this module and the provider's capabilities. We started with a complete codebase update for [HCL2 syntax compatibility](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/releases/tag/v2.0.2), then adding support for [Regional Subnets](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/releases/tag/v2.0.4) and lastly [Flexible Shapes](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/pull/49).

We will continue to push in that direction with the goal of [feature parity with the provider's capabilities](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/projects/4), as well as adding more features and integration points with other OCI services: Block Volume Backups, Secondary VNICs and IPs, etc ...

Given the dependency to Network and Storage for Compute Instances, this module is also a perfect place to illustrate [module composition principles](https://www.terraform.io/docs/language/modules/develop/composition.html) and how to reuse the other official Terraform OCI modules.

## Contributing

This project is open source and maintained by Oracle.  
Oracle appreciates any contributions that are made by the open source community: raising issues, improving documentation, fixing bugs, or adding new features.

Learn how to [contribute](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/CONTRIBUTING.adoc).

[Folks who contributed](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/CONTRIBUTORS.adoc) with explanations, code, feedback, ideas, testing etc.

## License

Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/LICENSE.txt) for more details.
