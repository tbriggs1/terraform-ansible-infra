resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "master-vpc-jenkins"
  }
}

resource "aws_vpc" "vpc_worker" {
  provider             = aws.region-worker
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "master-vpc-jenkins"
  }
}

# Internet GW
resource "aws_internet_gateway" "master-gw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id

  tags = {
    Name = "master"
  }
}

resource "aws_internet_gateway" "worker-gw" {
  provider = aws.region-worker
  vpc_id = aws_vpc.vpc_worker.id

  tags = {
    Name = "worker"
  }
}

data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

# Subnets
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "172.16.1.0/24"
}

# Subnets
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "172.16.2.0/24"
}

# Subnets
resource "aws_subnet" "subnet_3" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_worker.id
  cidr_block = "10.0.1.0/24"
}

