// Copyright (c) 2018, 2021 Oracle and/or its affiliates.

output "instance_flex" {
  description = "ocid of created instances. "
  value       = module.instance_flex.instances_summary
}

output "instance_flex_custom" {
  description = "ocid of created instances. "
  value       = module.instance_flex_custom.instances_summary
}

output "instance_nonflex" {
  description = "ocid of created instances. "
  value       = module.instance_nonflex.instances_summary
}

output "instance_nonflex_custom" {
  description = "ocid of created instances. "
  value       = module.instance_nonflex_custom.instances_summary
}
