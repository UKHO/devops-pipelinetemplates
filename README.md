# Azure DevOps Pipeline Templates

This repository contains template files that can be used in Azure DevOps Pipelines. The purpose of this repo is to standardise the way that steps are done for common tasks, avoiding code duplication and potential mistakes. Each template comes with its own README which contains instructions on how to use it.

Below is a summary of the templates we have available

## Templates

| Name                                                         | Description                                                                                                                                        |
|--------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| [Checkov](./checkov)                                         | Terraform scanning to ensure that there is no security misconfiguration in your terraform files                                                    |
| [Github Tag](./github-tag)                                   | Github tags to your commits for marking significant points in a project's development                                                              |
| [Retain pipeline run](./retain-pipelinerun)                  | Retaining a pipeline run for longer than the default configured 30 days after production release                                                   |
| [SAST](./sast)                                               | SAST scan of the dotnet projects                                                                                                                   |
| [trivy](./trivy)                                             | Static analysis security scanner against your Terraform                                                                                            |
| [Gated Infrastructure Deploy](./gated-infrastructure-deploy) | Will trigger manual validation step if Terraform `plan` detects resource destruction |
