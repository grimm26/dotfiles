config {
  module = true
  force = false
}

plugin "aws" {
  deep_check = false
  enabled = true
  version = "0.15.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_module_pinned_source" {
  enabled = true
  style = "semver"
}
