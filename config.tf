provider "aws" {
  region = "ap-southeast-1" 
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a" 
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            	= aws_vpc.my_vpc.id
  cidr_block        	= "10.0.2.0/24"
  availability_zone 	= "ap-southeast-1a" 
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            	= aws_vpc.my_vpc.id
  cidr_block        	= "10.0.3.0/24"
  availability_zone 	= "ap-southeast-1a" 
}

# Create IGW
resource "aws_internet_gateway" "my_igw" {
  vpc_id 		= aws_vpc.my_vpc.id
}

# Create Elastic IP 
resource "aws_eip" "my_eip" {
  vpc 			= true
}

# Create NAT gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  subnet_id     		= aws_subnet.public_subnet_1.id
  allocation_id 		= aws_eip.my_eip.id
}

# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id 		= aws_vpc.my_vpc.id

  route {
    cidr_block 		= "0.0.0.0/0"
    gateway_id 		= aws_internet_gateway.my_igw.id
  }
}

# Config public subnets with route table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      	= aws_subnet.public_subnet_1.id
  route_table_id 	= aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      	= aws_subnet.public_subnet_2.id
  route_table_id 	= aws_route_table.public_route_table.id
}

# Security Group Config
resource "aws_security_group" "my_security_group" {
  vpc_id 		= aws_vpc.my_vpc.id

  ingress {
    from_port   		= 80
    to_port     		= 80
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
  }

  ingress {
    from_port   		= 443
    to_port     		= 443
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
  }

  egress {
    from_port   		= 0
    to_port     		= 0
    protocol    		= "-1"
    cidr_blocks 		= ["0.0.0.0/0"]
  }
}

# EC2 Config
resource "aws_instance" "my_instance" {
  ami                     	= "ami-0a70416fa5fd4cb39" 
  instance_type          	= "t2.medium"
  subnet_id              	= aws_subnet.private_subnet.id
  associate_public_ip 	= false
  security_group_ids 	= [aws_security_group.my_security_group.id]

  root_block_device {
    volume_size 	= 40
    volume_type 	= "gp2" 
  }
}
