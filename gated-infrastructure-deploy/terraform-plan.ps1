param (
    [Parameter(Mandatory)]
    [ValidateScript({
            if (-not(Test-Path -Path $_ -PathType 'Container')) {
                throw "The directory path '$_' does not exist."
            }
            $true
        })]
    [string] $TerraformFilesDirectory,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformPlanName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateBlobName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateStorageAccountName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Workspace
)

. $(Join-Path $PSScriptRoot "terraform-cmdlets.ps1")

$terraformOutputFileName = "terraform_output.txt"

SetLocationAndOutputInformation -Directory $TerraformFilesDirectory
Terraform-Init -TFStateResourceGroupName $TFStateResourceGroupName -TFStateStorageAccountName $TFStateStorageAccountName -TFStateBlobName $TFStateBlobName
Terraform-Workspace -Workspace $Workspace
Terraform-Validate
Terraform-Plan -TerraformPlanName $TerraformPlanName -TerraformOutputFileName $terraformOutputFileName
SetNeedsVerificationIfTerraformPlanWillDestroyResources -TerraformOutputFileName $terraformOutputFileName