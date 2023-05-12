data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

# resource "aws_instance" "public" {
#   count = 2

#   ami                         = data.aws_ami.amazonlinux.id
#   associate_public_ip_address = true
#   instance_type               = "t3.micro"
#   key_name                    = "sanjeevk-tf"
#   vpc_security_group_ids      = [aws_security_group.public.id]
#   subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[count.index]
#   user_data                   = file("user-data.sh")

#   tags = {
#     Name = "${var.env_code}-public"
#   }
# }

# resource "aws_security_group" "public" {
#   name        = "${var.env_code}-public"
#   description = "Allow inbound traffic"
#   vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

#   ingress {
#     description = "SSH from public"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["71.198.160.159/32"]
#   }

#   ingress {
#     description = "HTTP from public"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     security_groups = [aws_security_group.load_balancer.id]
#   }

#   ingress {
#     description = "HTTP from load balancer"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.env_code}-public"
#   }
# }

resource "aws_instance" "private" {
  count = 2

  ami                    = data.aws_ami.amazonlinux.id
  instance_type          = "t3.micro"
  key_name               = "sanjeevk-tf"
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = data.terraform_remote_state.level1.outputs.private_subnet_id[count.index]
  user_data                   = file("user-data.sh")

  tags = {
    Name = "${var.env_code}-private"
  }
}

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Allow VPC traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.level1.outputs.vpc_cidr]
  }

  ingress {
    description = "HTTP from load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-private"
  }
}
