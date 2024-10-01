variable "project_name" {
  description = "Project name."
  default     = "demo"
}

variable "project_owner" {
  description = "Project owner or point of contact."
  default     = "team.demo@company.com"
}

variable "tf_s3_name" {
  description = "AWS s3 bucket name for storing terraform state."
  default     = "terraform-state-d3d425e29e7d1f25"
}

variable "tf_db_name" {
  description = "AWS dynamodb table name for locking terraform state."
  default     = "terraform-state-d3d425e29e7d1f25"
}
