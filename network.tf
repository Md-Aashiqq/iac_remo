resource "aws_vpc" "iac_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "iac_public_subnet" {
  vpc_id            = aws_vpc.iac_vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_subnet" "iac_private_subnet" {
  vpc_id            = aws_vpc.iac_vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "iac_ig" {
  vpc_id = aws_vpc.iac_vpc.id

  tags = {
    Name = "Iac_Network_Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.iac_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.iac_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.iac_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
