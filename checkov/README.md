# Checkov Azure Pipelines Build Template
This repo contains an Azure DevOps Pipeline template for running [Checkov](https://www.checkov.io/1.Welcome/What%20is%20Checkov.html) against terraform

## Usage

Reference this repository in the pipeline yaml
```yaml
resources:
  repositories:
    - repository: UKHOTemplates
      type: github
      endpoint: Your_Github_Service_Connection_Name
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

## Results

The template uses the `PublishTestResults` built in task to report the test results. Due to the way Checkov outputs its test results the results are not shown the logs. To view the failures you will need to go to the test results section for the job you have added these steps to, from there each failure will be reported as an individual test case.

## Suppressions

There are occasions where you may wish to suppress failures that Checkov is detecting. Each suppression should be done on the individual resources and done inline rather than a blanket across the whole run. This allows you to manually assess each failure and ensure that the suppression is correct for that resource. [More details on Checkov suppressions can be found here](https://www.checkov.io/2.Basics/Suppressing%20and%20Skipping%20Policies.html)
