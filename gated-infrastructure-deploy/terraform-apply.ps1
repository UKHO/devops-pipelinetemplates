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
  [string] $TFStateBlobName,
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $TFStateResourceGroupName,
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $TFStateStorageAccountName,
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string] $Workspace,
  [string] $TerraformOutputVariables
)

. $(Join-Path $PSScriptRoot "terraform-cmdlets.ps1")

SetLocationAndOutputInformation -Directory $TerraformFilesDirectory
Terraform-Init -TFStateResourceGroupName $TFStateResourceGroupName -TFStateStorageAccountName $TFStateStorageAccountName -TFStateBlobName $TFStateBlobName
Terraform-Workspace -Workspace $Workspace
Terraform-Apply
ExportRequiredTerraformOutputVariables -TerraformOutputVariables $TerraformOutputVariables