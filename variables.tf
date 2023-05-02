variable "vpc-cidr" {
  type = string

}

variable "vpc-name" {
  type = string

}

variable "igw_name" {

  type = string
}

variable "enable-dns-hostnames" {
  type = bool

}

variable "enable-dns-support" {
  type = bool

}

variable "public_subnet_cidr" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "private_subnet_name" {
  type = string
}


variable "public_rt" {
  type = string
}

variable "private_rt" {
  type = string
}

variable "public_sg" {
  type = string
}

variable "private_sg" {
  type = string
}
