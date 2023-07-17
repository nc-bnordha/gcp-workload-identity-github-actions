resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_iam_workload_identity_pool" "this" {
  display_name              = "GitHub pool"
  workload_identity_pool_id = "github-pool"
  depends_on = [google_project_service.iam, google_project_service.cloudresourcemanager]
}

resource "google_iam_workload_identity_pool_provider" "this" {
  workload_identity_pool_provider_id = "github-provider"
  workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
  display_name                       = "GITHub provider"

  attribute_mapping = {
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "google.subject"       = "assertion.sub"
  }

  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "this" {
  account_id   = var.service_account
  display_name = "GITHub Service Account"
  depends_on = [google_project_service.iam, google_project_service.cloudresourcemanager]
}

resource "google_service_account_iam_binding" "this" {
  service_account_id = google_service_account.this.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${var.git_repo}"
  ]
}

# Should be adjusted for least privilege principle
resource "google_project_iam_member" "this" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.this.email}"
}

# resource "google_project_iam_member" "run_admin" {
#   project = var.project_id
#   role    = "roles/run.admin"
#   member  = "serviceAccount:${google_service_account.this.email}"
# }

