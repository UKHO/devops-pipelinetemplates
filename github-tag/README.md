# Template for adding a GitHub tag from an Azure Pipeline 

Tags are references that point to specific points in Git history. Tagging is generally used to capture a point in history that is used for a marked version release (i.e. v1.0.1).
The tag name and commit Id on which the tag needs to attached are sent from the calling pipeline as parameters to this template. The tag name can be any string with no spaces and no special characters such as \, ?, ~, ^, :, * , [, @, .. 

## Usage

1. Reference this repository in your pipeline YAML

```yaml
resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

2. Add a job to your pipeline with the required parameters to create the tag

**Note**: This job should be added at a sensible stage in the pipeline to avoid the proliferation of tags. For example, the initial use case in Calypso is after the live deployment stage so we can easily see in GitHub the last commit that was released to production.

```yaml
- job: githubtag
  dependsOn: "<DEPENDS ON JOB>"
    conditional: "succeeded('<CONDITIONAL JOB>')"
  steps: 
    - template: github-tag/github-tag.yml@UKHOTemplates
      parameters: 
        TagName: "$(Build.BuildId)"
        SourceVersion: "$(Build.SourceVersion)"
```
