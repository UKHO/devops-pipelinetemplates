# Snyk Azure Pipelines Build Template
This repo contains the pipeline template required to run the snyk scans available against your repository.

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
  - template: snyk/snyk-pipeline-run.yml@UKHOTemplates
    parameters:
      organization: $(organization)
```

## Parameters

| Name                    | Description                                                                                | Required? | Default |
|-------------------------|--------------------------------------------------------------------------------------------|-----------|---------|
| `organization`          | The GUID of the organization for which the scan is to be run                               | true      | ''      |
| `serviceConnectionToken`| A Service Account token to which can be authenticated to the organization                  | true      | ''      |
| `testType`              | The type of test to run. Available values are `sca|code|iac|container`                     | false     | sca     |
| `dockerImageName`       | The name of the docker image to be built and scanned                                       | false     | ''      |
| `dockerfilePath`        | The path to dockerfile that is being scanned                                               | false     | ''      |
| `targetFile`            | The name of the sln to be used in the SCA scanning                                         | false     | ''      |
| `severityThreshold`     | The severity threshold of vuln scanning. Anything below the threshold will be ignored      | false     | medium  |
| `codeSeverityThreshold` | The severity threshold of code SAST scanning. Anything below the threshold will be ignored | false     | medium  |
| `additionalArguments`   | Any additional arguments to run with the command. [Commands can be found here](https://docs.snyk.io/snyk-cli/cli-commands-and-options-summary#options-for-multiple-commands)                                                        | false     | ''      |

## Results

The template uses the `PublishPipelineArtifact` built in task to output the scan results in a json format. The logs will show a more human readable version for analysis however for reference we will output this file. If there are no issues, there will be no file published. Results from the pipeline are not monitored in the dashboard to allow for engineers to adjust and make changes without affecting overall metrics.

## Suppressions

Suppressions should be performed from the Snyk interface rather than using other methods. This is so that the Cyber Security team can properly audit suppressions and where there are remediation they should be dealt with immediately and not delayed. 