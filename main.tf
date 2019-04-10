# Configure the Netlify Provider
provider "netlify" {
  token = "${var.netlify_token}"
}

# Create a new deploy key for this specific website
resource "netlify_deploy_key" "key" {}

# Define your site
resource "netlify_site" "main" {
  name = "mikes-site"

  repo {
    deploy_key_id = "${netlify_deploy_key.key.id}"
    provider = "github"
    repo_path = "mikenomitch/tf_test"
    repo_branch = "master"
  }
}
