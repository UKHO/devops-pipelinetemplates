Param(
    [Parameter(mandatory=$true)][string]$buildId,
    [Parameter(mandatory=$true)][string]$commitId
)
$timestamp = Get-Date -format 'dd-MM-yyyy-hh.mm.ss'
$tagName = "$buildId" + "-" + $timestamp

Write-Host "Creating tag $tagName"
git tag $tagName $commitId
Write-Host "Tag created"

Write-Host "Pushing Tag $tagName"
git push origin $tagName
Write-Host "Tag pushed"