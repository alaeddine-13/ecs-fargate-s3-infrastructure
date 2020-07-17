data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "${var.aws_region}a"
}


data "aws_subnet" "subnet2" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "${var.aws_region}b"
}

resource "aws_security_group" "sg" {
  name        = var.project_name
  description = "Allows TCP traffic on port 4000"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description     = "Allows TCP traffic on port 4000"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-${var.project_name}"
  description = "Allows TCP traffic on port 4000"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "Allows TCP traffic on port 4000"
    from_port   = var.app_port
    to_port     = var.app_port
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

data "aws_route53_zone" "this" {
  name         = var.route53_zone
  private_zone = false
}
