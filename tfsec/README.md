resources:
  repositories: 
    - repository: UKHOTemplates
      type: github
      endpoint: GitHub_Service_Connection_Name
      name: UKHO/devops-pipelinestemplates

steps: 
    - template: tfsec/tfsec-pipelines.yml@UKHOTemplates
      parameters: 
        WorkingDirectory: "$(System.DefaultWorkingDirectory)/Terraform_Folder"