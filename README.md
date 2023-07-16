# Using Terraform to set up GCP Identify Federation for GitHub Action AND generate the appropiate workflow file

This Terraform configuration sets up the GCP Identify Federation for GitHub Action AND generates the appropiate workflow file.

First, the script provisions the Workload Identity Pool and the provider. It then creates a service account with the appropriate IAM permission and connects it to the provider. Please note for simplicity sake the service account uses the editor role which of course violates the least privilege principal.

It then writes the approprite GitHub action workflow file using the `workflow.tpl` file as a template.

 The easiest way to run this is in Cloud Shell. Set the values for the `project_id` and the `git_repo` in `terraform.tfvars` and execute the following commands.

    terraform init
    terraform plan
    terraform apply

The workflow YAML file is automatically written to  the `workflow.yaml` file which you can place in your Git repo.

We include two sample workflow templates, one for Cloud Run and one for Terraform.


