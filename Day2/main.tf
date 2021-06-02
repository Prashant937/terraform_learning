provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "devops" {

#   provisioner "remote-exec" {
#     inline = [
#        "sudo apt install awscli",
#        "sudo apt update",
#        "sudo apt install nginx",
#     ]
#   }
  ami                    = "ami-0747bdcabd34c712a"
  key_name               = "[terra-devops]"
  subnet_id              = aws_subnet.my-fist-subnet.id
  vpc_security_group_ids = [aws_security_group.ingress-all-test.id]
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.test_profile_12.name

  tags = {
    Name = "my-first-instance"
  }
}

resource "aws_security_group" "ingress-all-test" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.my-first-vpc.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# provisioner "remote-exec" {
#   inline = [
#     "sudo apt install awscli",
#   ]
# }

resource "aws_vpc" "my-first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-learning"
  }
}

resource "aws_subnet" "my-fist-subnet" {
  vpc_id                  = aws_vpc.my-first-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-learning"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::my_first_bucket",
          "arn:aws:s3:::my_first_bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "test_profile_12" {
  name = "test_profile_12"
  role = aws_iam_role.test_role.name
}

resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "my-terraform-devops-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "prashant"
  }
}
