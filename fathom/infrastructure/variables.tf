variable spotinst_account {}
variable spotinst_token {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "project" {}
variable "domain" {}

variable "stage" {
  default = "live"
}

variable "key_name" {
  default = ""
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "fathom_email" {}

variable "fathom_password" {
  default = "Adm1n"
}
