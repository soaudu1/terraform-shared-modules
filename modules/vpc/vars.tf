variable "aws_region" {}
variable "name" {}
variable "cidr_block" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
