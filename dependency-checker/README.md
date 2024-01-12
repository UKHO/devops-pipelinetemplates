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
| `scanPath`        | The path to output the test result file to. Default: `$(Build.SourcesDirectory)\\src`                                         | false     |
| `reportPath`      | The name of the test result file. Default: `$(Build.SourcesDirectory)\\DCReport`                                              | false     |
| `supressionPath`  | The location of your supression file. Default: `none`                                                                         | false     |

#### example with some parameters

```yaml
  - template: dependency-checker/windows-dependency-checker.yaml@UKHOTemplates
    paramerers:
      scanName: "MyDCCheck"
      scanPath: "$(Build.SourcesDirectory)\\App"
```

## Notes

- Any backslashes need to be doubled `\\` 
- A restore may be needed before the scan takes place.
- This template assumes a library is installed called BuildAndDeploy, this is an inhouse tool but available via PowershellGallery.com.

## Linux

linux build would rely on a container
