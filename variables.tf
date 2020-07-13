variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}
variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    type = "list"
    default = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    type = "list"
    default = ["10.0.3.0/24", "10.0.4.0/24","10.0.5.0/24"]
}

# variable "azs"{
#   type = "list"
#   default = ["eu-west-2a","eu-west-2b", "eu-west-2c"]
# }

data "aws_availability_zones" "azs" {}
