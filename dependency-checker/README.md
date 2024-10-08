# Dependency Checker Azure Pipelines Template

## Usage

Reference this repository in the pipeline yaml
```yaml
resources:
  repositories:
    - repository: UKHOTemplates
      type: github
      endpoint: Your_Github_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

Add to your jobs steps

```yaml
steps:
  - template: dependency-checker/windows-dependency-checker.yaml@UKHOTemplates
```

The way to use dependency checker for windows and linux is different.

## Windows

dependency-check is added to the environment PATH so can be called by using `dependency-check.bat` this has the nvdapikey added so if it wants to run an update the database can relatively quickly during the run.

### Build Parameters

| Name              | Description                                                                                                                   | Required? |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------|-----------|
| `scanName`        | The path to the directory containing your terraform files. Default: `$(Build.DefinitionName) - $(Build.SourceBranchName)`     | false     |
| `scanPath`        | The path to test. Default: `$(Build.SourcesDirectory)\\src`                                                                   | false     |
| `reportPath`      | The location of the test result file. Default: `$(Build.SourcesDirectory)\\DCReport`                                          | false     |
| `suppressionPath` | The location of your supression file. Default: `none`                                                                         | false     |

#### example with some parameters

```yaml
  - template: dependency-checker/windows-dependency-checker.yaml@UKHOTemplates
    parameters:
      scanName: "MyDCCheck"
      scanPath: "$(Build.SourcesDirectory)\\App"
```

## Notes

- Any backslashes need to be doubled `\\` 
- A restore may be needed before the scan takes place.
- This template assumes a library is installed called BuildAndDeploy, this is an inhouse tool but available via PowershellGallery.com.

## Linux

linux build would rely on a container

```yaml
  steps:
    - template: dependency-checker/linux-dependency-checker.yaml@UKHOTemplates
      parameters:
        NvdApiKey: $(NvdApiKey)
```

### Build Parameters

| Name              | Description                                                                                                                   | Required? |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------|-----------|
| `NvdApiKey`       | NvdApiKey that must be passed in to connect to the NVD DataBase. This is hosted in the DDC owned `AzDoLive-KV` Key Vault. A AzDo Libary group should be used to request it.       | true     
| `scanName`        | The path to the directory containing your packages. Default: `$(Build.DefinitionName) - $(Build.SourceBranchName)`     | false     |
| `scanPath`        | The path to test. Default: `$(Build.SourcesDirectory)`                                                                        | false     |
| `suppressionPath` | The location of your supression file. Default: `none`                                                                         | false     |
