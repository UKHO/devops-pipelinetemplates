# Trivy Azure Pipelines Build Template

Azure DevOps Pipeline template for running [TFSec] against your Terraform (https://github.com/aquasecurity/trivy)

## Usage

Reference this repository inside the yaml pipeline

```yaml
resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

Steps to add your job

```yaml
- job: trivy
  steps: 
    - template: tfsec/trivy-pipelines.yml@UKHOTemplates
      parameters: 
        WorkingDirectory: "$(System.DefaultWorkingDirectory)/Terraform_Folder"
```


## Parameters


| Name                 | Description                                                                                    | Required? |
|----------------------|------------------------------------------------------------------------------------------------|-----------|
| `TrivyIgnore`        | Checks that have been ignored                                                                  | False     |
| `WorkingDirectory`   | Override with desired path - $(System.DefaultWorkingDirectory)                                 | False     |


## Ignore checks [azure-network-no-public-ingress,azure-network-no-public-egress]

There may be occasions when you wish to exclude certain checks, but it's not required. Please do not exclude checks without properly investigating the errors.
To do this allow parameters for ignores. To ignore these options, use a comma separated list. 
WorkingDirectory: Sets directory to scan, use this parameter with your own desired path.


## Results

Trivy will output the published results into the build pipeline under Test and Coverage, from there you can see a detailed summary of failures and passes. 
Use the filter to switch between the two. In addition, the failed scans are displayed inside the docker console.






