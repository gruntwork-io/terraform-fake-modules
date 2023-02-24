variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  description = "This is any so we can pass in anything, and get it back as an output named tags"
  type        = any
  default     = {}
}
