function Terraform-Init {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $DeploymentResourceGroupName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $DeploymentStorageAccountName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformStorageKeyName
  )

  $activity = "terraform init command execution"
  Write-Output "Starting $activity"

  terraform init -migrate-state -backend-config="resource_group_name=$DeploymentResourceGroupName" `
    -backend-config="storage_account_name=$DeploymentStorageAccountName" `
    -backend-config="key=$TerraformStorageKeyName"

  ThrowErrorIfCommandHadError -Activity $activity
  Write-Output "Finished $activity"
}

function ThrowErrorIfCommandHadError {
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Activity
  )
  if (!$?) {
    throw "Something went wrong during: $Activity"
  }
}

function SetLocationAndOutputInformation {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Directory
  )
  Set-Location $Directory
  Write-Host "Current Directory: $( Get-Location )"

  Write-Host "Directory Content:"
  Get-ChildItem -File | ForEach-Object { Write-Host $_ }

  Write-Host "Terraform Version:"
  terraform --version
}

function Terraform-Workspace {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $WorkSpace
  )
  $activity = "terraform workspace '$WorkSpace' command execution"
  Write-Output "Starting $activity"

  $ErrorActionPreference = 'SilentlyContinue'     # new workspace command files if workspace already exist
  terraform workspace new $WorkSpace 2>&1 > $null # if error thrown, just means workspace exists for usage
  $ErrorActionPreference = 'Continue'             # if no workspace exists, then it will get created
  terraform workspace select $WorkSpace

  ThrowErrorIfCommandHadError -Activity $activity
  Write-Output "Finished $activity"
}

function Terraform-Validate {
  $activity = "terraform validation command execution"
  Write-Output "Starting $activity"

  terraform validate

  ThrowErrorIfCommandHadError -Activity $activity
  Write-Output "Finished $activity"
}

function Terraform-Plan {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformPlanName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformOutputFileName
  )

  $activity = "terraform plan command execution"
  Write-Output "Starting $activity"

  terraform plan -out $TerraformPlanName | Tee-Object $TerraformOutputFileName

  if ($( Test-Path $TerraformPlanName ) -eq $false) {
    Write-Host -ForegroundColor Red "Terraform Plan '$TerraformPlanName' was not created. See directory content:"
    Get-ChildItem -File | ForEach-Object { Write-Host $_ }
  }

  ThrowErrorIfCommandHadError -Activity $activity
  Write-Output "Finished $activity"
}

function Terraform-Apply {
  [CmdletBinding()]
  param (  )

  $activity = "terraform apply command execution"
  Write-Output "Starting $activity"

  terraform apply -auto-approve

  ThrowErrorIfCommandHadError -Activity $activity
  Write-Output "Finished $activity"
}

function ExportRequiredTerraformOutputVariables {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformOutputVariables
  )

  if (![string]::IsNullOrEmpty($TerraformOutputVariables)) {
    Write-Output "Exporting required variables for deployment"
    foreach ($terraformOutputVariable in $TerraformOutputVariables -split " ") {
      Write-Host "Exporting '$terraformOutputVariable' variable from terraform output."
      try {
        $output = terraform output -raw $terraformOutputVariable
        Write-Host "##vso[task.setvariable variable=$terraformOutputVariable;isoutput=true]$output"
        Write-Host "Exported."
      }
      catch {
        throw
      }
    }
    Write-Output "Required variables exported"
  }
  else {
    Write-Host "No variables defined for export in TerraformOutputVariables parameter."
  }

}

function SetNeedsVerificationIfTerraformPlanWillDestroyResources {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TerraformOutputFileName
  )

  if ($( Test-Path -Path $TerraformOutputFileName ) -eq $false) {
    Write-Host -ForegroundColor Red "Terraform Output File '$TerraformOutputFileName' was not created. See directory content:"
    Get-ChildItem -File | ForEach-Object { Write-Host $_ }
  }
  else {
    $numberOfOccurancesToIndicateDeletionOfResources = 2
    $totalDestroyLines = (Get-Content -Path $TerraformOutputFileName |
      Select-String -Pattern "destroy" -CaseSensitive |
      Where-Object { $_ -ne "" }).length

    if ($totalDestroyLines -ge $numberOfOccurancesToIndicateDeletionOfResources) {
      Write-Host "Terraform plan indicates resources will be destroyed, please verify..."
      Write-Host "##vso[task.setvariable variable=needsVerification;isoutput=true]true"
    }
  }
}
