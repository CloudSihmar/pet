provider "aws" {
  region = "ap-south-1"
}

resource "tls_private_key" "docker_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "docker_key" {
  key_name   = "docker_key"
  public_key = tls_private_key.docker_key.public_key_openssh
}

resource "aws_security_group" "docker_sg" {
  name_prefix = "docker_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_instance" {
  ami             = "ami-0c2af51e265bd5e0e"  
  instance_type   = "t2.micro"  
  key_name        = aws_key_pair.docker_key.key_name
  security_groups = [aws_security_group.docker_sg.name]

  tags = {
    Name = "Docker-Instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > instance_ip.txt"
  }
}

output "instance_ip" {
  description = "The public IP of the Jenkins instance"
  value       = aws_instance.docker_instance.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.docker_key.private_key_pem
  sensitive = true
}

output "instance_ssh_key" {
  value     = aws_key_pair.docker_key.key_name
}
