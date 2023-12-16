variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the hosted zone"
  type        = map(string)
  default     = {}
}
