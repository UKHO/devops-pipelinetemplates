function Terraform-Init {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateResourceGroupName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateStorageAccountName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateContainerName,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TFStateBlobName
  )

  $activity = "terraform init command execution"
  Write-Output "Starting $activity"

  terraform init -migrate-state -backend-config="resource_group_name=$TFStateResourceGroupName" `
    -backend-config="storage_account_name=$TFStateStorageAccountName" `
    -backend-config="container_name=$TFStateContainerName" `
    -backend-config="key=$TFStateBlobName"

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
    [string] $Workspace
  )
  $activity = "terraform Workspace '$Workspace' command execution"
  Write-Output "Starting $activity"

  $ErrorActionPreference = 'SilentlyContinue'     # new workspace command files if workspace already exist
  terraform workspace new $Workspace 2>&1 > $null # if error thrown, just means workspace exists for usage
  $ErrorActionPreference = 'Continue'             # if no workspace exists, then it will get created
  terraform workspace select $Workspace

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
    [string] $TerraformOutputFileName
  )

  $activity = "terraform plan command execution"
  Write-Output "Starting $activity"

  $planName = "tfplan"

  terraform plan -out $planName | Tee-Object $TerraformOutputFileName

  if ($( Test-Path $planName ) -eq $false) {
    Write-Host -ForegroundColor Red "Terraform Plan '$planName' was not created. See directory content:"
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
    [Parameter()]
    [string] $TerraformOutputVariables
  )

  if (![string]::IsNullOrEmpty($TerraformOutputVariables)) {
    Write-Output "Exporting required variables for deployment"
    foreach ($terraformOutputVariable in $TerraformOutputVariables -split " ") {
      $activity = "Exporting '$terraformOutputVariable' variable from terraform output."

      Write-Host $activity

      $output = terraform output -raw $terraformOutputVariable
      ThrowErrorIfCommandHadError -Activity $activity

      Write-Host "##vso[task.setvariable variable=$terraformOutputVariable;isoutput=true]$output"
      Write-Host "Exported."
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