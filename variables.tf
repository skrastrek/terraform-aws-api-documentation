variable "name_prefix" {
  type    = string
  default = "api"
}

variable "title" {
  type = string
}

variable "resource_policy_allow_read_cloudfront_distribution_arns" {
  type    = list(string)
  default = null
}

variable "apis" {
  type = map(object({
    name          = string
    open_api_spec_yaml = optional(string)
    open_api_spec_url  = optional(string)
  }))

  validation {
    condition = length([
      for k, v in var.apis : k if v.open_api_spec_yaml == null && v.open_api_spec_url == null
    ]) == 0 && length([
      for k, v in var.apis : k if v.open_api_spec_yaml != null && v.open_api_spec_url != null
    ]) == 0
    error_message = "Each API entry must have exactly one of 'open_api_spec_yaml' or 'open_api_spec_url'."
  }
}

variable "tags" {
  type = map(string)
}
