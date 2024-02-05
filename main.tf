data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

resource "aws_key_pair" "webserver" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3l8YJ/iQwpquJpPjKDNRzD3TNMHoPqJq1U20g562iI0c89pSTkVOQ9WcKrlUOvB32ltN4tbTHK7C9Xseywn3EaABFy+NhQxccLethKhLyIQl3W/MwCFIlb2YLvj4fPIDeqmlHLMTU+78OIWjjf8VG5IEmUnZXNy75xUJ5XRzN8dpS3Buazm4VmouJzwPbJ7McLZJhjmm1V8wZH8axhwflqrOPYvatdmD5Ny1k4zzyL9yJfcVeb8ufJVvDkOZanFGyVmgDum9V34HVRArY8oY+3xNXx0CY4XlAb0iG+Li8xGY+NzCrCe09duX5d97d1XWYzdoFvZzuXwZ08xmfq2PEO3a1+MkUD0rMy4Ct4JFypdwuvQUKzpAgXsfMIftXNWM4J3fmlpkz7PAvYd2l2gHqP13NlCdKilM/BFNosruiBvOyPCPYjBzhjuwBrUu54XP5iPByyH9XrsHA1b1nTo22nwdovKVOoR7z5KfULHXv9F5fzSae27P+aKfy1BcKeSs= mohammedashick@haji.local"
}

resource "aws_vpc" "iac_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "Some Custom VPC"
  }
}

resource "aws_subnet" "iac_public_subnet" {
  vpc_id            = aws_vpc.iac_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "iac_private_subnet" {
  vpc_id            = aws_vpc.iac_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Some Private Subnet"
  }
}

resource "aws_internet_gateway" "iac_ig" {
  vpc_id = aws_vpc.iac_vpc.id

  tags = {
    Name = "Some Internet Gateway"
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

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "Allow SSH Acces"
  vpc_id = aws_vpc.iac_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
      from_port = 433
      to_port = 433
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      
  }
}

resource "aws_instance" "webserver" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
    tags = {
    Name = "IAC_DEMO"
  }
  subnet_id  = aws_subnet.iac_public_subnet.id
  associate_public_ip_address = true
#   subnet_id       = aws_subnet.demo_vpc_subnet.id
    key_name = aws_key_pair.webserver.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
  user_data = file("init.tpl")
    
}




output "publicIP" {
  value = aws_instance.webserver.public_ip
}

