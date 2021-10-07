# Creating Compute Instances with a reserved public IP

This example illustrates how to use this module to creates compute instances with a reserved public IP.

One modules will be configured:

- 1 instance (1 OCPU, 1GB RAM) with a reserved public IP associated with the Primary IP of the primary VNIC.

## Prerequisites

You will need to collect the following information before you start:

1. your OCI provider authentication values
2. a compartment OCID in which the instances will be created
3. a source OCID to deploy the instance, usually an image ocid from [OCI Platform Images list]
4. a subnet OCID to which the instance's primary VNICs will be attached

For detailed instructions, see [docs/prerequisites.adoc]

## Using this example with Terraform cli

Prepare one [Terraform Variable Definition file] named `terraform.tfvars` with the required authentication information.

*TIP: You can rename and configure `terraform.tfvars.example` from this example's folder.*

Then apply the example using the following commands:

```shell
> terraform init
> terraform plan
> terraform apply
```

See [Provisioning Infrastructure with Terraform] for more details about Terraform CLI and the available subcommands.

[Terraform Variable Definition file]:https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files
[docs/prerequisites.adoc]:https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/main/docs/prerequisites.adoc
[Provisioning Infrastructure with Terraform]:https://www.terraform.io/docs/cli/run/index.html
[OCI Platform Images list]:https://docs.oracle.com/en-us/iaas/images/
