# Creating Compute Instances using Flex shape

This example illustrates how to use this module to creates compute instances using Flex Shape, and optionally provision and attach a block volume to the created instances.

Two modules will be configured:

- the first module will create 1 instance (1 OCPU, 16GB RAM) with 1 Block Volume (50GB) attached to it
- the second module will create 4 instances (1 OCUP, 1GB RAM) with no additional Block Volume

## Prerequisites

You will need to collect the following information before you start:

1. your OCI provider authentication values
2. a compartment OCID in which the instances will be created
3. a subnet OCID to which the instance's primary VNICs will be attached

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

[Terraform Variable Definition file]:https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files
[docs/prerequisites.adoc]:https://github.com/oracle-terraform-modules/terraform-oci-compute-instance/blob/master/docs/prerequisites.adoc
