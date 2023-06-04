terraform {
  backend "s3" {
    bucket = "harsha-eks-demo"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_c_association" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name        = "eks_security_group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-demo"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.24"
  
 
  vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
    security_group_ids = [aws_security_group.security_group.id]
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_node_group_role_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "ng-default"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
    aws_subnet.subnet_c.id
  ]

  instance_types = ["m5.xlarge"]

  scaling_config {
    desired_size = 3
    min_size     = 1
    max_size     = 10
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}



 
