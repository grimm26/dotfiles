config {
  module = true
  force = false
}

plugin "aws" {
  deep_check = false
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style = "semver"
}
