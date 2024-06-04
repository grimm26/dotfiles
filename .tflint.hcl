config {
  call_module_type = "all"
  force            = false
}

plugin "aws" {
  enabled    = true
  deep_check = false
  version    = "0.31.0"
  source     = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_unused_declarations" {
  enabled = false
}

rule "terraform_module_pinned_source" {
  enabled = true
  style   = "semver"
}
rule "terraform_unused_required_providers" {
  enabled = true
}
rule "terraform_required_providers" {
  enabled = false
}
