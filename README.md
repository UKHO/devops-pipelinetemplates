# Azure DevOps Pipeline Templates

This repository contains template files that can be used in Azure DevOps Pipelines. The purpose of this repo is to standardise the way that steps are done for common tasks, avoiding code duplication and potential mistakes. Each template comes with its own README which contains instructions on how to use it.

Below is a summary of the templates we have available

## Security

| Name                   | Description                                                                                     |
|------------------------|-------------------------------------------------------------------------------------------------|
| [`Checkov`](./checkov) | Terraform scanning to ensure that there is no security misconfiguration in your terraform files |
| [`Github Tag`](./github-tag) | Github tags to your commits for marking significant points in a project's development  |
| [`SAST`](./sast) | SAST scan of the dotnet projects  |
| [`tfsec`](./tfsec) | Static analysis security scanner against your Terraform   |
