variable "env" {
  description = "Short environment identifier e.g. dev/prd"
  type        = string
}

variable "region" {
  description = "AWS region to create resources in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use for EKS cluster workers"
  type        = string
}

variable "instance_max" {
  description = "Maximum number of EKS workers that the auto scaling group can spin up"
  type        = number
}
