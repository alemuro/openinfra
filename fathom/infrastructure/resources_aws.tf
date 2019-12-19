provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "selected" {
  cidr_block = "${var.vpc_cidr}"
}

data "aws_subnet_ids" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"
}

resource "aws_security_group" "front" {
  name        = "${var.stage}-${var.project}-front-sg"
  description = "Allow HTTP/HTTPS/SSH inbound traffic from everywhere"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* Spotinst */
data "aws_ami" "fathom-ubuntu-18" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["openinfra-fathom_lite-ubuntu_18.04-*"]
  }
}

resource "aws_eip" "public_ip" {
  vpc = true
}
