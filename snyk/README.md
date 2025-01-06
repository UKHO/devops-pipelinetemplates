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
jobs:
  - template: snyk/snyk-pipeline-run.yml@UKHOTemplates
    parameters:
      organization: $(organization)
```

or if you wish to just add individual steps to your pipeline

```yaml
jobs:
  - template: snyk/snyk-iac-scan.yml@UKHOTemplates
    parameters:
      organization: $(organization)
```
> The steps do not provide pre-requisite steps to prepare the code for scanning so only import steps if you just need to scan.

## Parameters

| Name                    | Description                                                                                | Required? | Default |
|-------------------------|--------------------------------------------------------------------------------------------|-----------|---------|
| `organization`          | The GUID of the organization for which the scan is to be run. This is found in your Snyk org settings                               | true      | ''      |
| `serviceConnectionToken`| A Service Account token to which can be authenticated to the organization. This can be created in Snyk                  | true      | ''      |
| `testType`              | The type of test to run. Available values are `sca\|code\|iac\|container`                     | false     | sca     |
| `dockerImageName`       | The name of the docker image to be built and scanned                                       | false     | ''      |
| `dockerfilePath`        | The path to dockerfile that is being scanned                                               | false     | ''      |
| `targetFile`            | The name of the sln to be used in the SCA scanning or the IAC file to be scanned                                         | false     | ''      |
| `severityThreshold`     | The severity threshold of vuln scanning. Anything below the threshold will be ignored      | false     | medium  |
| `codeSeverityThreshold` | The severity threshold of code SAST scanning. Anything below the threshold will be ignored | false     | medium  |
| `additionalArguments`   | Any additional arguments to run with the command. [Commands can be found here](https://docs.snyk.io/snyk-cli/cli-commands-and-options-summary#options-for-multiple-commands)                                                        | false     | ''      |

## Test Types

### SCA
This test type will perform a scan of your dependencies and feedback if there are any vulnerabilities found. To do this it performs a dotnet restore using the dotnet cli task with the dotnet version set to 8.x.

### Container
This test type will perform a scan of the built container and feedback if there are any vulnerabilities found. To do this it builds the container using the image name provided and then performs the scan.

### IAC
This test type will perform a scan of infrastructure as code and feedback if there are any vulnerabilities found. This can scan the repo or a single file. To specify file you can pass in the file path via the `targetFile` parameter.

### Code
This test type will perform a scan of the code and feedback if there are any vulnerabilities found. This is similar to the PR scan that is performed however you can stop your pipeline with this check.

## Results

The template uses the `PublishPipelineArtifact` built in task to output the scan results in a json format. The logs will show a more human readable version for analysis however for reference we will output this file. If there are no issues, there will be no file published. Results from the pipeline are not monitored in the dashboard to allow for engineers to adjust and make changes without affecting overall metrics.

## Suppressions

Suppressions should be performed from the Snyk interface rather than using other methods. This is so that the Cyber Security team can properly audit suppressions and where there are remediation they should be dealt with immediately and not delayed. 
