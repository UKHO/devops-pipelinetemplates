# Azure DevOps Pipeline Templates

This repository contains template files that can be used in Azure DevOps Pipelines. The purpose of this repo is to standardise the way that steps are done for common tasks, avoiding code duplication and potential mistakes. Each template comes with its own README which contains instructions on how to use it.

Below is a summary of the templates we have available

## Templates

| Name                                                         | Description                                                                                                                                        |
|--------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| [Checkov](./checkov)                                         | Terraform scanning to ensure that there is no security misconfiguration in your terraform files                                                    |
| [Github Tag](./github-tag)                                   | Github tags to your commits for marking significant points in a project's development                                                              |
| [Retain pipeline run](./retain-pipelinerun)                  | Retaining a pipeline run for longer than the default configured 30 days after production release                                                   |
| [Snyk](./snyk)                                               | Snyk pipeline runs for SAST, SCA, IAC and Container scanning projects                                                                                                                   |
| [Trivy](./trivy)                                             | Static analysis security scanner against your Terraform                                                                                            |
| [Gated Infrastructure Deploy](https://github.com/UKHO/devops-gated-infrastructure-deploy) | Template for running terraform plan and apply with a manual verification step inbetween which triggers when destroyed resources are detected in plan. |
| [Infrastructure Pipeline](https://github.com/UKHO/devops-infrastructure-pipeline-template) | Infrastructure (terraform) pipeline template that implements the 'Gated Infrastructure Deploy' template in 3 environments (dev/qa/live) along with build & checks stages. |
| [Web Service Pipeline](https://github.com/UKHO/devops-web-service-pipeline-template) | Pipeline template that builds & checks a dotnet web app and deploys into a web app (slot & swap) in azure in 3 environments (dev/qa/live). |
| [Trigger ADDS AutoTests Pipeline](https://github.com/UKHO/devops-trigger-adds-autotest-pipeline) | Job template that with service connection to an app config+key vault is able to trigger target pipelines from another pipeline and wait for results. |