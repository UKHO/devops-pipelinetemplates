# Template for Gated Infrastructure Deploy

This template is designed to allow you to deploy resources via Terraform with a manual verification step if the Terraform `plan` indicates that any resources will be destroyed. When no resources are flagged for destruction then the pipeline will automatically continue to Terraform `apply`. If the verification job is triggered, then you will need to approve in Azure DevOps in order to move on to the `apply` step. The job will fail if you either reject or do not approve within the timeout period.

This template makes use of `terraform plan` and `terraform apply`.

**The plan cannot foresee every circumstance and scenario compared to the apply.**

## How does it work?

The template is broken into three jobs:

- the plan job
- the manual verification
- the apply job

In the plan job, a plan is made and then inspected to see if any resources are indicated for destruction. If there are, then a flag is set to true. This flag is a condition for the manual verification job. If the condition is met, then the manual verification will trigger. When the manual verification has been approved, the apply job will trigger. If approval is not given, the apply job won't run.

## Usage

For a complete working example, please refer to the [acg-connect](https://github.com/UKHO/acg-connect) repository.

1. Reference this repository in your root `azure-pipelines.yml` file.

    ```yaml
    resources:
      repositories:
        - repository: UKHOTemplates
          type: github
          endpoint: UKHO
          name: UKHO/devops-pipelinetemplates
          ref: refs/heads/gated-infrastructure-deploy-template
    ```

2. Add this template block to your pipeline and fill out the values that relate to your deployment. The template content is a series of `jobs`, therefore they need to be rooted under a `stage`.

    ```yaml
    jobs:
      - template: gated-infrastructure-deploy/gated-infrastructure-deploy.yml@UKHOTemplates
        parameters:
          AzDOEnvironmentName: "string"
          TFStateResourceGroupName: "string"
          TFStateStorageAccountName: "string"
          TFStateContainerName: "string"
          TFStateBlobName: "string"
          TerraformWorkspace: "string"
          TerraformArtifactConfigRelativePath: "string"
          TerraformArtifact: "string"
          VariablesTemplateRelativePath: "string"
          TerraformVariableMappings:
            TERRAFORM_VARIABLE: "VALUE" 
          TerraformOutputVariables:
            POSSIBLE_TERRAFORM_OUTPUT_VARIABLE
    ```

3. Consult the table below to fill out each of the parameters with the value that you require.

    | parameter | Required | Type | Description | 
    | - | - | - | - | 
    | AzDOEnvironmentName | Yes | string | Environment name as defined in Azure DevOps |
    | TFStateResourceGroupName | Yes | string | Terraform state resource group |
    | TFStateStorageAccountName | Yes | string | Terraform state storage account |
    | TFStateContainerName | Yes | string | Terraform state container |
    | TFStateBlobName | Yes| string | Terraform state blob |
    | TerraformWorkspace | Yes | string | Terraform workspace |
    | TerraformArtifact| Yes | string | Artifact containing your .tf files and any other supporting files for your deployment |
    | TerraformArtifactConfigRelativePath | Yes | string | Relative path to the .tf files inside your artifact |
    | VariablesTemplateRelativePath | Yes | string | Relative path to a YAML template containing a variables expression |
    | TerraformVariableMappings | Yes | object | A key/value map of Terraform variables to be injected into the PowerShell runtime environment for Terraform to use |
    | TerraformOutputVariables| No | object | An array of Terraform output variables to be retrieved after the Terraform apply has completed |

    **Notes**:

    - *TerraformWorkspace*: This value will be appended onto the blob name in the form `[TFStateBlobName]:[TerraformWorkspace]`, e.g. `terraform.deployment.tfplan:dev`   

    - *TerraformArtifact*: The files in the artifact will be used without modifying their contents. Your pipeline will need to include jobs to make any required modfications to your supporting files e.g. inserting configuration values, before publishing the artifact.

    - *TerraformArtifactConfigRelativePath*: Inside the template, the full path to the configuration will be `$(Pipeline.Workspace)/[TerraformArtifact][TerraformArtifactConfigRelativePath]`.
      
      Example 1: The artifact is named 'tfartifact' and the .tf files are in the root. `TerraformArtifactConfigRelativePath` would be `/` and the concatenated path would be `$(Pipeline.Workspace)/tfartifact/`.

      ```
      +-- terraform
      |   +-- azure.tf
      |   +-- main.tf
      |   +-- variables.tf
      |   +-- output.tf
      ```

      Example 2: The artifact is named 'buildartifact' and the .tf files are in a subfolder. `TerraformArtifactConfigRelativePath` would be `terraform/` and the concatenated path would be `$(Pipeline.Workspace)/buildartifact/terraform/`.

      ```
      +-- src
      +-- terraform
      |   +-- azure.tf
      |   +-- main.tf
      |   +-- variables.tf
      |   +-- output.tf
      ```

    - *VariablesTemplateRelativePath*: Inside the template, the full path to the variable template will be `${{variables['System.DefaultWorkingDirectory']}}${{ parameters.VariablesTemplateRelativePath }}@self`. This allows the template to pull in all the variables it needs for the deployment. The relative path must be from the repository root directory.

      Example: In the repository acg-connect, the following (simplified) folder structure exists. `VariablesTemplateRelativePath` would be `/build/pipeline/templates/var/dev-deploy.yml`.

      ```
      +-- build
      |   +-- pipeline
      |       +-- templates
      |           +-- var
      |               +-- dev-deploy.yml
      |           +-- continuous-deployment.yml
      |       +-- azure-pipelines.yml
      |   +-- terraform
      +-- documentation
      +-- src
      ```

    - *TerraformVariableMappings*: This parameter allows for the mapping of values from Azure DevOps variable groups to be passed to Terraform for environment variables, tfvars, etc.
    
      ```
      ARM_CLIENT_ID: $(TERRAFORM-CLIENT-ID)
      ARM_CLIENT_SECRET: $(TERRAFORM-CLIENT-SECRET)
      ARM_TENANT_ID: $(TERRAFORM-TENANT-ID)
      ARM_SUBSCRIPTION_ID: $(TERRAFORM-SUBSCRIPTION-ID)
      TF_VAR_allowed_ips: $(whiteListedIps)
      TF_VAR_spoke_rg: $(spokeRG)
      ```
  
    - *TerraformOutputVariables*:

      Fairly common to have Terraform output variables that are values passed back out of Terraform after infrastructure has been created or updated, such as connection strings. This parameter allows them to be exported out via the `"##vso[task.setvariable variable=[var_name];isoutput=true]$output"` syntax. These can subsequently be accessed in sequential jobs by the use of a variable in a variable block. Sequential jobs that rely on this variable will need to have a `dependsOn` to ensure that the `deployInfrastructure` job has completed before they proceed.
      
      ``` yaml
      - deployment: deployService  
        displayName: "Deploy Service"  
        dependsOn:  
        - deployInfrastructure  
        condition: succeeded('deployInfrastructure')  
        variables:  
        - name: "WEB_APP_NAME"  
          value: $[dependencies.deployInfrastructure.outputs['deployInfrastructure.deployment.web_app_name']]
      ```
