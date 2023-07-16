locals {
  template = templatefile("${path.module}/${var.template_file}", {
    workload_identity_pool_provider = google_iam_workload_identity_pool_provider.this.name
    service_account                 = google_service_account.this.email
  })
}

resource "local_file" "this" {
  filename = "${path.module}/workflow.yaml"
  content  = local.template
}