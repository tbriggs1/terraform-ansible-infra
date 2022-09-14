variable "keyPath" {
  default = "~/.ssh/id_rsa"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "ami" {
  default = "ami-035c5dc086849b5de"
}

variable "region-master" {
  type    = string
  default = "eu-west-2"
}

variable "region-worker" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "workers-count" {
  type    = number
  default = 1
}

variable "webserver-port" {
  type    = number
  default = 80
}

variable "dns-name" {
  type    = string
  default = "cropmanagementdev.com."
}