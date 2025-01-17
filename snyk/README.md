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

The snyk-pipeline-run template is an all in one template to show how jobs are setup to run. This can be added to your pipeline to run the test you wish to run as below. Please note that additional steps may need to be undertaken to be able to successfully scan your project as described in the scan types below.

```yaml
jobs:
  - template: snyk/snyk-pipeline-run.yml@UKHOTemplates
    parameters:
      organization: $(organization)
```

or if you wish to just add individual scan steps to your pipeline you can add them as follows. Please note that you will need to import the `snyk-cli-download.yml` template before importing any scan templates. This does not require any parameters. 

```yaml
steps:
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
To be able to perform this type of scan you will first need to restore your project dependencies so that the scanning tool can navigate the manifest to look for vulnerabilities within your dependencies and licenses. Please refer to your projects documentation on how to do this before performing this scan. Any vulnerabilities found will be published to the pipeline in a json format for viewing.

### Container
To be able to perform this type of scan you will first need to build your docker container as this is what the tool will be analyzing. Once built you can provide the docker image name and for information/remediation on your dockerfile you can provide its path. Any vulnerabilities found will be published to the pipeline in a json format for viewing.

### IAC
This test type will perform a scan of infrastructure as code and feedback if there are any vulnerabilities found. This can scan the repo or a single file. To specify file you can pass in the file path via the `targetFile` parameter. Nothing needs to be built/restored to be able to run this type of scan. Any vulnerabilities found will be published to the pipeline in a json format for viewing.

### Code
This test type will perform a scan of the code and feedback if there are any vulnerabilities found. This is similar to the PR scan that is performed however you can stop your pipeline with this check. Nothing needs to be built/restored to be able to run this type of scan. Any vulnerabilities found will be published to the pipeline in a json format for viewing.

## Results

The template uses the `PublishPipelineArtifact` built in task to output the scan results in a json format. The logs will show a more human readable version for analysis however for reference we will output this file. If there are no issues, there will be no file published. Results from the pipeline are not monitored in the dashboard to allow for engineers to adjust and make changes without affecting overall metrics.

## Suppressions

Suppressions should be performed from the Snyk interface rather than using other methods. This is so that the Cyber Security team can properly audit suppressions and where there are remediation they should be dealt with immediately and not delayed. 
