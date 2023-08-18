# Template for Pipeline Run Retention 

Retaining a pipeline run for longer than the default configured 30 days is handled by the creation of retention leases.
If a pipeline run is deployed to production should be retained for longer than 30 days, then this task ensures the run is valid for 1 year (or more as configured) by adding a new retention lease.

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

2. Add a job to your pipeline with the required parameters to create retention lease.
   Below is an example 


```yaml
- job:
  dependsOn: "<DEPENDS ON JOB>"
    conditional: "succeeded('<CONDITIONAL JOB>')"
  steps: 
     - checkout: UKHOTemplates
     - template: retain-pipeline/retain-pipeline.yml@UKHOTemplates
             parameters:
                DaysValid: 365
                AccessToken: "$(System.AccessToken)"
                DefinitionId: '$(System.DefinitionId)'
                OwnerId: '$(Build.RequestedForId)'
                BuildId: '$(Build.BuildId)'
                CollectionUri: '$(System.CollectionUri)'
                TeamProject: '$(System.TeamProject)'
```

