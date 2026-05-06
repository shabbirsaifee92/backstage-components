terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.12"
    }
  }

  # Configure a remote backend so state persists across runs.
  # Example for S3:
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "github-repos/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

variable "repo_name" {
  type = string
}

variable "repo_owner" {
  type    = string
  default = "shabbirsaifee92"
}

variable "description" {
  type    = string
  default = ""
}

variable "visibility" {
  type    = string
  default = "private"

  validation {
    condition     = contains(["private", "internal", "public"], var.visibility)
    error_message = "visibility must be private, internal, or public."
  }
}

provider "github" {
  owner = var.repo_owner
  # Uses GITHUB_TOKEN env var set by the workflow
}

resource "github_repository" "new" {
  name        = var.repo_name
  description = var.description
  visibility  = var.visibility
  auto_init   = true
}

output "repo_url" {
  value = github_repository.new.html_url
}
