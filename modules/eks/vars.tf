variable "aws_region" {}
variable "name" {}
variable "cluster_role_arn" {}
variable "node_group_role_arn" {}
variable "subnet_ids" { type = list(string) }
variable "kubernetes_version" { default = "1.29" }
variable "node_group_desired_size" { default = 2 }
variable "node_group_min_size" { default = 1 }
variable "node_group_max_size" { default = 3 }
variable "instance_types" { 
  type = list(string) 
  default = ["t3.medium"] 
}
variable "dependency" {}
variable "tags" {
  type    = map(string)
  default = {}
}
