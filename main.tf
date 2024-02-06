data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

resource "aws_key_pair" "webserver" {
  public_key = var.public_key_path
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
  instance_type = var.instance_type
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





