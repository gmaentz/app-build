
variable "department" {
  type = string

  validation {
    condition     = length(var.department) == 3
    error_message = "Department length must be 3 characters."
  }
}

variable "cost_code" {
  type = string
  validation {
    condition     = can(regex("^(?:[0-9]{1,2}\\-){2}[0-9]{1,2}$", var.cost_code))
    error_message = "Must be an cost code address of the form X-X-X."
  }
}

variable "phone_number" {
  type      = string
  sensitive = true
  default   = "867-5309"
}

locals {
  contact_info = {
    department   = var.department
    cost_code    = var.cost_code
    phone_number = var.phone_number
  }

  my_number = nonsensitive(var.phone_number)
}

output "department" {
  value = local.contact_info.department
}

output "cost_code" {
  value = local.contact_info.cost_code
}

output "phone_number" {
  sensitive = true
  value     = local.contact_info.phone_number
}

output "my_number" {
  value = local.my_number
}

