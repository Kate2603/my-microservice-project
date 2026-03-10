variable "vpc_name" {
  description = "VPC name tag"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs (must be 3)"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs (must be 3)"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs (must be 3)"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
