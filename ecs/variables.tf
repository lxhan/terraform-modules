variable "project_name" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "owner" {
  type    = string
  default = "Alex Han"
}

variable "environment" {
  type    = string
  default = "development"
}

variable "app_port" {
  type    = number
  default = 5000
}

variable "app_count" {
  type    = number
  default = 1
}

variable "az_count" {
  type    = string
  default = 4
}

variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "health_check_path" {
  type    = string
  default = "/api/health"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}