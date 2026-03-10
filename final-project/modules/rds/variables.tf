variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "allowed_security_groups" {
  type    = list(string)
  default = []
}
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_engine" { type = string }
variable "db_instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "use_aurora" { type = bool }
variable "aurora_engine" { type = string }
variable "aurora_instance_class" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
