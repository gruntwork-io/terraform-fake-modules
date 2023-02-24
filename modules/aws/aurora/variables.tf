variable "vpc_id" {
  type = string
}

variable "namespace" {
  type    = string
  default = "grunty"
}

variable "environment" {
  type    = string
  default = "development"
}


variable "engine_name" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "13.6"
}

variable "tags" {
  description = "This is any so we can pass in anything, and get it back as an output named tags"
  type        = any
  default     = {}
}
