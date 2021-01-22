# CONTRIBUTING

Oracle welcomes contributions to this repository from anyone.

If you want to submit a pull request to fix a bug or enhance an existing feature, please first open an issue and link to that issue when you submit your pull request.

If you have any questions about a possible submission, feel free to open an issue too.

## Contributing to the terraform-oci-compute-instance repository

Pull requests can be made under The Oracle Contributor Agreement(OCA).

For pull requests to be accepted, the bottom of your commit message must have the following line using your name and e-mail address as it appears in the OCA Signatories list.

`Signed-off-by: Your Name <you@example.org>`

This can be automatically added to pull requests by committing with:

`git commit --signoff`

or by turning on the "Always Sign Off" flag in your IDE's preferences.

Only pull requests from committers that can be verified as having signed the OCA can be accepted.

## Pull request process

1. Fork this repository

1. Create a branch in your own fork to implement the changes. We recommend using the issue number as part of your branch name, e.g.: `1234-fixes`

1. Ensure that any documentation is updated with the changes that are required by your fix

1. Update README.md when necessary

1. Ensure that any samples are updated if the base image has been changed

1. Update CHANGELOG.md - add information about the changes that are done in this pull request, increment the version

1. Tag your branch with the new version

1. Submit the pull request. **Do not leave the pull request description blank**. Explain exactly what your changes are meant to do and provide simple steps on how to validate your changes. Ensure that you reference the issue you created as well adding `#1234` to the description. We will assign the pull request to 2-3 people for review before it is merged.