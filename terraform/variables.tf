// These should be picked up from environment variables prefixed with 'TF_VAR_'
// e.g, before running terraform, make sure to,
// export TF_VAR_ATLAS_USERNAME=erjohnso
variable "GOOGLE_PROJECT_ID" { }
variable "ATLAS_USERNAME" { }
variable "ATLAS_TOKEN" { }
variable "ATLAS_ENVIRONMENT" {
    default = "paul715/atlasdemo-env"
}

variable "consul_server_count" { 
  default = 3
}
