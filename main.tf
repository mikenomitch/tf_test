// configure the github provider
provider "github" {
  organization = "mikenomitch"
}

// Configure the repository with the dynamically created Netlify key.
resource "github_repository_deploy_key" "key" {
  title      = "Netlify"
  repository = "mikenomitch/tf_test"
  key        = "${netlify_deploy_key.key.public_key}"
  read_only  = false
}

// Create a webhook that triggers Netlify builds on push.
resource "github_repository_webhook" "main" {
  repository = "mikenomitch/tf_test"
  name       = "web"
  events     = ["delete", "push", "pull_request"]

  configuration {
    content_type = "json"
    url          = "https://api.netlify.com/hooks/github"
  }

  depends_on = ["netlify_site.main"]
}

# Configure the Netlify Provider
provider "netlify" {
  token = "${var.netlify_token}"
}

# Create a new deploy key for this specific website
resource "netlify_deploy_key" "key" {}

# Define your site
resource "netlify_site" "main" {
  name = "mike_tf_test_site_four_c"

  repo {
    deploy_key_id = "${netlify_deploy_key.key.id}"
    provider = "github"
    repo_path = "mikenomitch/tf_test"
    repo_branch = "master"
    dir = "/"
  }
}
