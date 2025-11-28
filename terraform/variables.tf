variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster_name" {
  default = "devops-eks"
}

variable "k8s_version" {
  default = "1.30"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}