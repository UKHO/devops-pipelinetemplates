# Template for adding a GitHub tag from an Azure Pipeline 

Tags are references that point to specific points in Git history. Tagging is generally used to capture a point in history that is used for a marked version release (i.e. v1.0.1).
With this template, the required tag name and commit Id on the the tag needs to attached are sent from the calling pipeline as parameters to this template

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

**Note** : This job should be added at sensible stage in the pipeline, ideally, at the end of the live deployment stage where we can easily see in GitHub what the last commit that got released to production.

```yaml
- job: autotag
  dependsOn: "<DEPENDS ON JOB>"
    conditional: "succeeded('<CONDITIONAL JOB>')"
  steps: 
    - template: auto_tag/auto-tag.yml@UKHOTemplates
      parameters: 
        TagName: "$(Build.BuildId)"
        SourceVersion: "$(Build.SourceVersion)"
```

