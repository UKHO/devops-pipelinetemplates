# Template for adding tag in an Azure Pipelines 

Tags are references that point to specific points in Git history. Tagging is generally used to capture a point in history that is used for a marked version release (i.e. v1.0.1).
With this template, tags created are of the format `<BuildId>-<Timestamp>` on top of the git commit, which is used for the main pipeline build. BuildId and CommitId paramters are sent from the main pipeline which is using this template.  

## Usage

Reference this repository inside the yaml pipeline

```yaml
resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinetemplates
```

Steps to add tagging template to your pipeline as job

```yaml
- job: autotag
  dependsOn: "<DEPENDS ON JOB>"
    conditional: "succeeded('<CONDITIONAL JOB>')"
  steps: 
    - template: auto_tag/auto-tag.yml@UKHOTemplates
      parameters: 
        BuildId: "$(Build.BuildId)"
        SourceVersion: "$(Build.SourceVersion)"
```
