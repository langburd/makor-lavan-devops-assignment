variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "The tags to apply to the resource group"
  type        = map(string)
  default     = {}
}
