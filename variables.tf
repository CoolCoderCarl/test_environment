variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}


variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "playground-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}
