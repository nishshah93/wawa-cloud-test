//Create the vpn with private subnets, Route table and NAT gateway for allowing access
resource "aws_vpc" "test" {
  //this will allow you to have (32-26) = 6, so 2^6 meaning 64 ip addresses 
  cidr_block       = "10.0.0.0/26" 
  instance_tenancy = "default"

  tags = {
    Name = "wawa_cloud"
  }
}

// we can let it select random availability zone or we can give it one
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-east-1c"

  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "10.0.0.48/28"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private_subnet_2"
  }
}

// Set up the route tables for public and private subnets 
resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public_rt_1"
  }
}

resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public_rt_2"
  }
}

resource "aws_egress_only_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "egree_internet_gw"
  }
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block        = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private_rt_1"
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block        = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway2.id
  }
  tags = {
    Name = "private_rt_2"
  }
}

// Setup the association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}


resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt_1.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt_2.id
}


// Add Internet gateway to public subnet and NAT gateway to private subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "public_gw"
  }
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public_1.id
  tags = {
    "Name" = "nat_gw_1"
  }
}

resource "aws_eip" "nat_gateway_2" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id = aws_subnet.public_2.id
  tags = {
    "Name" = "nat_gw_2"
  }
}