## Cached Dotnet Azure Pipelines Template

Azure DevOps shared template for cached dotnet `restore`, `build`, `test` and `publish` using `Cache@2` and `DotNetCoreCLI@2` tasks.

## Pre-requisite

Before using this task, you need to lock your project dependencies and generate a `packages.lock.json` file in your projects root directory. To do this add the following to your Directory.Build.props file (or create one if it doesn't exist) where building by solution or to each csproj where building by project:
```xml
<PropertyGroup>
  <RestorePackagesWithLockFile>true</RestorePackagesWithLockFile>
</PropertyGroup>
```

## Usage

Reference this repository in your pipeline yaml

```yaml
resources:
  repositories:
    - repository: UKHOTemplates
      type: github
      endpoint: Your_Github_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

Add to your job steps

```yaml
steps:
  - template: cached-dotnet/cached-dotnet.yml@UKHOTemplates
    parameters:
      solutionOrProject: "$(Build.SourcesDirectory)/MyApp.sln"
      buildConfiguration: "Release"
      runtime: "linux-x64"
      buildProject: true
      testProject: true
      publishProject: false
```

## Parameters

| Name                | Description                                                                                                 | Required? |
|---------------------|-------------------------------------------------------------------------------------------------------------|-----------|
| `solutionOrProject` | Solution or project used for restore, build and test. Default: `$(Build.SourcesDirectory)`               | false     |
| `buildConfiguration`| Build configuration passed to dotnet commands. Default: `Release`                                          | false     |
| `publishOutput`     | Publish output path. Default: `$(Build.ArtifactStagingDirectory)/publish`                                  | false     |
| `nugetPackagesPath` | Path used by the NuGet package cache. Default: `$(Pipeline.Workspace)/.nuget/packages`                    | false     |
| `buildOutputPath`   | Build/test output folder. Default: `$(Pipeline.Workspace)/.dotnet/build`                                  | false     |
| `runtime`           | Runtime passed to build/test/publish (for example `linux-x64` or `win-x64`). Default: empty               | false     |
| `buildProject`      | Controls whether the build task runs. Default: `false`                                                      | false     |
| `testProject`       | Controls whether the test task runs. Default: `false`                                                       | false     |
| `publishProject`    | Controls whether publish runs. Default: `false`                                                            | false     |

## Steps Included

1. `Cache@2` caches NuGet packages using dependency files as cache keys.
2. `DotNetCoreCLI@2 restore` runs only when the NuGet cache is not restored.
3. `DotNetCoreCLI@2 build` runs when `buildProject` is `true`.
4. `DotNetCoreCLI@2 test` runs when `testProject` is `true`.
5. `DotNetCoreCLI@2 publish` runs when `publishProject` is `true`.

## Sample Pipeline

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

resources:
  repositories:
    - repository: UKHOTemplates
      type: github
      endpoint: Your_Github_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates

stages:
  - stage: build
    displayName: Build and Publish
    jobs:
      - job: dotnet
        displayName: Cached dotnet build
        steps:
          - checkout: self
          - template: cached-dotnet/cached-dotnet.yml@UKHOTemplates
            parameters:
              solutionOrProject: "$(Build.SourcesDirectory)/MyApp.sln"
              buildConfiguration: "Release"
              runtime: "linux-x64"
              buildProject: true
              testProject: true
              publishProject: false
              publishOutput: "$(Build.ArtifactStagingDirectory)/publish"

          - task: PublishBuildArtifacts@1
            displayName: Publish app artifact
            inputs:
              PathtoPublish: "$(Build.ArtifactStagingDirectory)/publish"
              ArtifactName: "app"
              publishLocation: "Container"
```
