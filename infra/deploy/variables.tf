variable "prefix" {
  description = "Prefix to be used when tagging aws resources."
  default     = "demo"
}

variable "project_name" {
  description = "Project name."
  default     = "demo"
}

variable "project_owner" {
  description = "Project owner or point of contact."
  default     = "team.demo@company.com"
}

variable "db_username" {
  description = "Database username for the demo app."
  default     = "demo-user"
}

variable "db_password" {
  description = "Database password for the demo app."
}
