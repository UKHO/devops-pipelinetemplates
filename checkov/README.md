# Checkov Azure Pipelines Build Template
This repo contains an Azure DevOps Pipeline template for running [Checkov](https://www.checkov.io/1.Welcome/What%20is%20Checkov.html) against terraform

## Usage

Reference this repository in the pipeline yaml
```yaml
resources:
  repositories:
    - repository: UKHOTemplates
      type: github
      name: UKHO/devops-pipelinetemplates
```

Add to your jobs steps

```yaml
steps:
  - template: checkov/checkov.yml@UKHOTemplates
    parameters:
      scanDirectory: "$(System.DefaultWorkingDirectory)/folder_containing_terraform"
```

## Parameters

| Name              | Description                                                                              | Required? |
|-------------------|------------------------------------------------------------------------------------------|-----------|
| `scanDirectory`   | The path to the directory containing your terraform files                                | true      |
| `outputDirectory` | The path to output the test result file to. Default: `$(System.DefaultWorkingDirectory)` | false     |
| `outputName`      | The name of the test result file. Default: `Checkov-Report.xml`                          | false     |

## Suppressions

There are occasions where you may wish to suppress failures that Checkov is detecting. Each suppression should be done on the individual resources and done inline rather than a blanket across the whole run. This allows you to manually assess each failure and ensure that the suppression is correct for that resource. [More details on Checkov suppressions can be found here](https://www.checkov.io/2.Basics/Suppressing%20and%20Skipping%20Policies.html)
