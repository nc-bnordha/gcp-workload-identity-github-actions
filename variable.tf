variable "project_id" {
  type        = string
  description = "ID of the Google Project"
}

variable "git_repo" {
  type        = string
  description = "Name of the GIT Repo"
}

variable "template_file" {
  type = string
  default = "workflow.tpl"
}