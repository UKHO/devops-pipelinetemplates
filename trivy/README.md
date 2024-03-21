# Trivy Azure Pipelines Build Template

Azure DevOps Pipeline template for running [Trivy] against your Terraform (https://github.com/aquasecurity/trivy)

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
    - template: trivy/trivy-pipelines.yml@UKHOTemplates
      parameters: 
        WorkingDirectory: "$(System.DefaultWorkingDirectory)/Terraform_Folder"
```


## Parameters


| Name                 | Description                                                                                    | Required? |
|----------------------|------------------------------------------------------------------------------------------------|-----------|
| `TrivyIgnore`        | Checks that have been ignored                                                                  | False     |
| `WorkingDirectory`   | Override with desired path - $(System.DefaultWorkingDirectory)                                 | False     |


## Ignore checks https://avd.aquasec.com/misconfig/azure

There may be occasions when you wish to exclude certain checks, but it's not required. Please do not exclude checks without properly investigating the errors.
To do this create .trivyignore file inside your terraform folder (folder being scanned) with the ID of the resource you want to exclude.

![image](https://github.com/UKHO/devops-pipelinetemplates/assets/52528924/ee92d2a9-81fc-459b-b99d-f445ecb0804c)


## Results

Trivy will output the published results into the build pipeline under Test and Coverage, from there you can see a detailed summary of failures and passes. 
Use the filter to switch between the two. In addition, the failed scans are displayed inside the docker console.






