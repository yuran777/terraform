variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "account" {
  default     = "yrk"
  description = "aws account"
}

variable "tags" {
  type        = list(string)
  default     = ["egress-inspection", "shared", "prd", "dev" ]
  description = " resource tags for egress, shared, prd, dev"
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

# vpc

variable "vpc_cidr" {
  type    = list(string)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16", "10.4.0.0/16"]
}

# variable "vpc_egress_cidr" {
#   type    = string
#   default = "10.1.0.0/16"
# }

# variable "vpc_shared_cidr" {
#   type    = string
#   default = "10.2.0.0/16"
# }

# variable "vpc_prd_cidr" {
#   type    = string
#   default = "10.3.0.0/16"
# }

# variable "vpc_dev_cidr" {
#   type    = string
#   default = "10.4.0.0/16"
# }

variable "egress_public_subnet" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "egress_tgw_subnet" {
  type    = list(string)
  default = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "egress_fw_subnet" {
  type    = list(string)
  default = [ "10.1.5.0/24", "10.1.6.0/24"]
}

variable "shared_subnet" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}


variable "prd_public_subnet" {
  type    = list(string)
  default = ["10.3.1.0/24", "10.3.2.0/24"]
}

variable "prd_workload_subnet" {
  type    = list(string)
  default = ["10.3.3.0/24", "10.3.4.0/24"]
}

variable "prd_tgw_subnet" {
  type    = list(string)
  default = ["10.3.5.0/24", "10.3.6.0/24"]
}

variable "dev_subnet" {
  type    = list(string)
  default = ["10.4.1.0/24", "10.4.2.0/24"]
}
