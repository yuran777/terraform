variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "account" {
  default     = "yrk"
  description = "aws account"
}

variable "tags" {
  type        = string
  default     = "egress-inspection"
  description = "egress-inspection resource tags"
}

####################
##vpc
variable "aws_az" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "aws_az_des" {
  type    = list(string)
  default = ["2a", "2c"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "private_TGW_subnet" {
  type    = list(string)
  default = ["10.1.0.0/24", "10.4.0.0/24"]
}


variable "private_FW_subnet" {
  type    = list(string)
  default = ["10.2.0.0/24", "10.5.0.0/24"]
}

variable "public_subnet" {
  type    = list(string)
  default = ["10.3.0.0/24", "10.1.6.0/24"]
}
