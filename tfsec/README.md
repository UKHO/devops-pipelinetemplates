Reference the repository in your yaml pipeline

resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinestemplates

Steps to add your job      

- job: tfsec
  steps: 
    - template: tfsec/tfsec-pipelines.yml@UKHOTemplates
      parameters: 
        WorkingDirectory: "$(System.DefaultWorkingDirectory)/Terraform_Folder"