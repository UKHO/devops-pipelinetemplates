# Post-Release Pipeline Template

## Overview

This template provides a standardised post-release stage that can be reused across pipelines.
It eliminates the need to duplicate common post-release steps—such as GitHub commit tagging and pipeline run retention in every pipeline.

By consuming this template, pipelines automatically gain consistent post-release behaviour with minimal configuration.

## Usage

1. Reference this repository in your pipeline YAML

```yaml
resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

1. Add the post-release stage template and specify the required condition and dependsOn parameters.
An example is shown below:

```yaml
  - template: post-release-stage/post-release-stage.yml@UKHOTemplates
    parameters:
      condition: succeeded('deploy_live')
      dependsOn:
        - "deploy_live"
```
