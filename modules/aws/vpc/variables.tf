variable "namespace" {
  type    = string
  default = "gruntwork"
}

variable "environment" {
  type    = string
  default = "development"
}

variable "max_az_count" {
  description = "The maximum number of availability zone's to span when creating subnets."
  type        = number
  default     = 4

  validation {
    condition     = var.max_az_count > 0 && var.max_az_count < 7
    error_message = "Max number of availability zones is 6."
  }
}

variable "nat_gw_count" {
  description = "The number of NAT gateways to create."
  type        = number
  default     = 0

  validation {
    condition     = var.nat_gw_count <= 6
    error_message = "Max NAT gateway count cannot be more than the maximum number of AZs available to a region."
  }
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidrsubnet_newbits" {
  # Definition taken directly from Terraform documentation. Use tools like ipcalc to figure out best prefix for your use case.
  description = "The number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a newbits value of 4, the resulting subnet address will have length /20."
  type        = number
  default     = 4
}

variable "tags" {
  description = "Custom tags to output for this module."
  type        = map(string)
  default     = {}
}
