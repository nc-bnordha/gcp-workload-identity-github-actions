name: Terraform using GCP Identify Federation for GitHub Action
on: [push]

jobs:
  cloudrun:
    permissions:
      contents: 'read'
      id-token: 'write'
    runs-on: ubuntu-latest

    steps:
    # actions/checkout MUST come before auth
    - uses: 'actions/checkout@v3'
  
    - id: 'auth'
      name: 'Authenticate to Google Cloud'
      uses: 'google-github-actions/auth@v1'
      # Update the values with the output from the setup step
      with:
        workload_identity_provider: ${workload_identity_pool_provider}
        service_account: ${service_account}

    - id: 'deploy'
      uses: 'google-github-actions/deploy-cloudrun@v1'
      with:
        service: 'hello-cloud-run'
        image: 'gcr.io/cloudrun/hello'
