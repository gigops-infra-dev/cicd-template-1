variable "name" {
  type = string
}

variable "repo" {
  type = string
}

variable "region" {
  type = string
}

variable "create_oidc" {
  type    = bool
  default = true
}

variable "profile" {
  type = string
}
