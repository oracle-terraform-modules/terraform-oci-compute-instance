# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the versioning follows the [Semantic Versioning 2.0.0](https://semver.org/) specification.

Given a version number MAJOR.MINOR.PATCH:

- MAJOR version when making incompatible API changes,
- MINOR version when adding functionality in a backwards compatible manner,
- PATCH version when making backwards compatible bug fixes.

## [UNRELEASED]

Added:

- support Flex instance shape
- new output : instances_summary

Fixed:

- Outputs produces unnecessarily multidimensional objects (Issue #31)

Repo maintenance:

- add .gitattributes for consistent line ending and tab
- add pre-commit configuration file

## 2.0.4 - 2021-02-13

### Changed

- Terraform block now defines minimum terraform version and required providers. Block Moved to main.tf
- block volumes attachment type is now paravirtualized by default
- boot volume size default value is now passed by the service
- README content is automatically generated for the following sections: Requirements, Providers, Inputs, Outputs

### Fixed

Issue #41 - When regional subnets are used, the instance fails to detect the availability domain

- Instance Domain selection do not rely on vnic AD anymore: use Data Source + a list local
- add var.ad_number, data.oci_identity_availability_domains.ad, local.ADs

Documentation enhancement:

- CHANGELOG format
- Sample code in the main README is now compliant with Terraform 0.12 syntax
- Missing description, type or default value for variables module inputs

## 2.0.3 - 2021-01-31

### Changed

- Upgrade to HCL2, for compatibility with Terraform 0.12 or higher
- Cleanup copyright notice statements in source files

## 2.0.2 - 2021-01-22

### Added

- CONTRIBUTING.md - contributor's guide

### Changed

- Add link to CONTRIBUTING.md in README.md
- Bump copyright year to 2021 in README.md

## 2.0.1 - 2019-05-08

### Changed

- v0.12 preparation: Fix metadata usage to be canonical

## 2.0.0 - 2018-12-04

### Changed

- Updated Hostname label for multiple compute instances
- Updated Volume display name
- Changes variable assign_public_ip default from true to false

### Added

- Support for multiple subnets
- Support for paravirtualized attachments
- Support for private IP list
