data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "prashant_vpc" {
  cidr_block = var.my_vpc_cidr
   tags = {
    Name = "vpc-learning"
  }
}

resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.prashant_vpc.id
  tags = {
    Name = "gateway-learning"
  }
}

resource "aws_subnet" "my_subnet" {
  cidr_block              = var.my_subnet_cidr
  vpc_id                  = aws_vpc.prashant_vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

   tags = {
    Name = "subnet-learning"
  }
}

resource "aws_route_table" "my_routing_table" {
  vpc_id = "${aws_vpc.prashant_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mygateway.id}"
  }
  
   tags = {
    Name = "rtb-learning"
  }
}

resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_routing_table.id
}

resource "aws_security_group" "ingress-all-test" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.prashant_vpc.id
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
  
   tags = {
    Name = "security-group-learning"
  }
   
}

output "security_group_id" {
  value = aws_security_group.ingress-all-test.id
}

output "my_subnet_id" {
  value = aws_subnet.my_subnet.id
}
