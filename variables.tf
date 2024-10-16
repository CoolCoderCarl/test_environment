variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "test-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "bucket_name" {
  description = "Bucket to store patients results"
  type        = string
  default     = "bucket-patients-result-docs-1"
}


variable "web_ami" {
  description = "AMI for web app"
  type        = string
  default     = "ami-0e54eba7c51c234f6"
}

# Aurora Database (PostgreSQL)
variable "aurora_admin_username" {
  description = "Aurora DB PostgreSQL - Username"
  type        = string
  sensitive   = true
  default     = "admin_user"
}

variable "aurora_admin_password" {
  description = "Aurora DB PostgreSQL - Password"
  type        = string
  sensitive   = true
  default     = "admin_pass"
}

