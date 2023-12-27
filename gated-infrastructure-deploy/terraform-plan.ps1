param (
    [Parameter(Mandatory)]
    [ValidateScript({
            if (-not(Test-Path -Path $_ -PathType 'Container')) {
                throw "The directory path '$_' does not exist."
            }
            $true
        })]
    [string] $terraformFilesDirectory,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $terraformPlanName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $terraformStorageKeyName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $deploymentResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $deploymentStorageAccountName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $workSpace
)

. $(Join-Path $PSScriptRoot "terraform-cmdlets.ps1")

$terraformOutputFileName = "terraform_output.txt"

SetLocationAndOutputInformation -Directory $terraformFilesDirectory
Terraform-Init -DeploymentResourceGroupName $deploymentResourceGroupName -DeploymentStorageAccountName $deploymentStorageAccountName -TerraformStorageKeyName $terraformStorageKeyName
Terraform-Workspace -WorkSpace $workSpace
Terraform-Validate
Terraform-Plan -TerraformPlanName $terraformPlanName -TerraformOutputFileName $terraformOutputFileName
SetNeedsVerificationIfTerraformPlanWillDestroyResources -TerraformOutputFileName $terraformOutputFileName
