variable "keyPath" {
  default = "~/.ssh/id_rsa"
}

# variable "private_key" {
#   default = file("~/.ssh/id_rsa")
# }

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