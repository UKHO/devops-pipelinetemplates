# TfSec Azure Pipelines Build Template

Azure DevOps Pipeline template for running [TFSec] against your Terraform (https://aquasecurity.github.io/tfsec/v1.26.0/)

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
- job: tfsec
  steps: 
    - template: tfsec/tfsec-pipelines.yml@UKHOTemplates
      parameters: 
        WorkingDirectory: "$(System.DefaultWorkingDirectory)/Terraform_Folder"
```


## Parameters


| Name                 | Description                                                                                    | Required? |
|----------------------|------------------------------------------------------------------------------------------------|-----------|
| `excluded`           | Checks that have been excluded                                                                 | False     |
| `WorkingDirectory`   | Override with desired path - $(System.DefaultWorkingDirectory)                                 | False     |


## Exclude checks [azure-network-no-public-ingress,azure-network-no-public-egress]

There may be occasions when you wish to exclude certain checks, but it's not required. Please do not exclude checks without properly investigating the errors.
To do this allow parameters for exclusions. To exclude these options, use a comma separated list. 
WorkingDirectory: Sets directory to scan, use this parameter with your own desired path.


## Results

TFSEC will output the published results into the build pipeline under Test and Coverage, from there you can see a detailed summary of failures and passes. 
Use the filter to switch between the two. In addition, the results are displayed inside the docker console.






