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

On rare occasions, you might find it necessary to omit specific checks, although it's not mandatory. Please refrain from excluding checks without thoroughly investigating the errors. To achieve this, simply create a .trivyignore file within your Terraform directory (the folder undergoing scanning), specifying the ID of the resource you intend to exclude.

![image](https://github.com/UKHO/devops-pipelinetemplates/assets/52528924/ee92d2a9-81fc-459b-b99d-f445ecb0804c)


## Results

Trivy will generate and publish results in the build pipeline under the Test and Coverage sections, allowing you to access a comprehensive overview of successes and failures. Utilise the filter to seamlessly switch between the two views. Furthermore, any failed scans will be clearly presented within the Docker console for immediate visibility and action.

## Local setup

Trivy can be installed locally on Windows by downloading the [Windows compatible binaries](https://github.com/aquasecurity/trivy/releases/latest/) and adding the location of the files to the Windows PATH environment variable.

Once installed, run a Trivy scan using a command prompt be navigating to your Trivy location and running commands as below:

- To scan a local project including language-specific files:
`trivy fs /path/to/your_project_folder`

- To scan a single file:
`trivy fs ./trivy-ci-test/single_file`,

Other operating system installation instructions can be found [here].(https://aquasecurity.github.io/trivy/v0.18.3/installation/)

A [VS Code plugin](https://github.com/aquasecurity/trivy-vscode-extension) for Trivy is available.






