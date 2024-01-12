# Dependency Checker

The way to use dependency checker for windows and linux is different.

## Windows

dependency-check is added to the environment PATH so can be called by using `dependency-check.bat` this has the nvdapikey added so if it wants to run an update the database can relatively quickly during the run.

```code
- task: PowerShell@2
  inputs:
    targetType: "inline"
    script: |
      $outPath = "$(Build.SourcesDirectory)\DCReport"
      dependency-check --project "__BUILDNAME__ - $(Build.SourceBranchName)" --scan '$(Pipeline.Workspace)\\__PROJECTDIRECTORY__\\' --out "$outPath" --suppression "$(Pipeline.Workspace)\\NVD Suppressions\NVDSuppressions.xml"
      if ((test-path $outPath) -and (get-childitem $outPath | Measure-Object | select-object -ExpandProperty Count) -gt 0) {
          write-host "Attempt $i successful"
      }
    pwsh: true
  displayName: "Run NVD Checker"

- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Build.SourcesDirectory)\DCReport'
    artifact: "NVD report"
    publishLocation: "pipeline"

- task: PowerShell@2
  displayName: "Fail build if dependency checker has vulnerabilities"
  inputs:
    targetType: inline
    script: Invoke-VulnerabilityCheck -ReportLocation $(Build.SourcesDirectory)\DCReport\*
```

The Failure assumes a library is installed called BuildAndDeploy, this is an inhouse tool but available via PowershellGallery.com.

## Linux

linux build would rely on a container

```
- bash: |
    DC_VERSION="latest"
    DC_DIRECTORY=$HOME/OWASP-Dependency-Check
    DC_PROJECT="dependency-check scan: $(pwd)"
    DATA_DIRECTORY="$DC_DIRECTORY/data"
    CACHE_DIRECTORY="$DC_DIRECTORY/data/cache"

    if [ ! -d "$DATA_DIRECTORY" ]; then
        echo "Initially creating persistent directory: $DATA_DIRECTORY"
        mkdir -p "$DATA_DIRECTORY"
    fi
    if [ ! -d "$CACHE_DIRECTORY" ]; then
        echo "Initially creating persistent directory: $CACHE_DIRECTORY"
        mkdir -p "$CACHE_DIRECTORY"
    fi

    # Make sure we are using the latest version
    docker pull owasp/dependency-check:$DC_VERSION
  displayName: pull image
- bash: |
    DC_VERSION="latest"
    DC_DIRECTORY=$HOME/OWASP-Dependency-Check
    DC_PROJECT="dependency-check scan: $(pwd)"
    DATA_DIRECTORY="$DC_DIRECTORY/data"
    CACHE_DIRECTORY="$DC_DIRECTORY/data/cache"
    
    mkdir -p odc-reports
    
    docker run --rm \
        -e user=$USER \
        -u $(id -u ${USER}):$(id -g ${USER}) \
        --volume $(pwd):/src:z \
        --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data:z \
        --volume $(pwd)/odc-reports:/reports:z \
        owasp/dependency-check:$DC_VERSION \
        --nvdApiKey $(NvdApiKey) \
        --scan /src \
        --format "ALL" \
        --project "$DC_PROJECT" \
        --out /reports
  workingDirectory: $(Build.SourcesDirectory)
  displayName: nvd check
- publish: $(Build.SourcesDirectory)/odc-reports
```
