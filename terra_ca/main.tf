resource "aws_vpc" "main" {
  #in the assignment don't forget to change the network numbers!
  cidr_block = "172.16.0.0/16"

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name  = var.pub_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_subnet" "prv_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name  = var.priv_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_internet_gateway" "inet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_route_table" "public_routing_table" {
  vpc_id = aws_vpc.main.id

  route { #traffic from anywhere is routed
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet_gateway.id
  }

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public_routing_table.id
}

resource "aws_eip" "nat_elastic_ip" {
  vpc = true

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id     = aws_subnet.pub_subnet.id

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

# private routing table
resource "aws_route_table" "private_routing_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name  = var.iac_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

#
resource "aws_route_table_association" "private_routing_table_assoc" {
  subnet_id      = aws_subnet.prv_subnet.id
  route_table_id = aws_route_table.private_routing_table.id
}