#############################################
#################### VPC ####################
#############################################

resource "aws_vpc" "vpc_main" {
  cidr_block = lookup(var.cidr_block, "vpc_route")

  tags = {
    Name = "vpc-main"
  }
}

#############################################
############## INTERNET GATEWAY #############
#############################################

resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "int-gateway"
  }
}

#############################################
############## PUBLIC SUBNETS ##############
#############################################

## 1 ##
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = lookup(var.cidr_block, "public_1")
  availability_zone = lookup(var.availability_zone, "availability_zone_1")

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_route_table" "route_tables_public_1" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_internet_gateway.int_gateway.id
  }

  tags = {
    Name = "rt-public-1"
  }
}

resource "aws_route_table_association" "route_association_public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_tables_public_1.id
}


## 2 ##
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = lookup(var.cidr_block, "public_2")
  availability_zone = lookup(var.availability_zone, "availability_zone_2")

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_route_table" "route_tables_public_2" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_internet_gateway.int_gateway.id
  }

  tags = {
    Name = "rt-public-2"
  }
}

resource "aws_route_table_association" "route_association_public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.route_tables_public_2.id
}

#############################################
############## PRIVATE SUBNETS ##############
#############################################

## 1 ##
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = lookup(var.cidr_block, "private_1")
  availability_zone = lookup(var.availability_zone, "availability_zone_1")
  
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_route_table" "route_table_privet_1" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "rt-privet-2"
  }
}

resource "aws_route_table_association" "route_association_privet_1" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.route_table_privet_1.id
}

resource "aws_eip" "eip_1" {
  domain = "vpc"
  
  tags = {
    Name = "eip-2"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  
  tags = {
    Name = "nat-private-1"
  }
}



## 2 ##
resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = lookup(var.cidr_block, "private_2")
  availability_zone = lookup(var.availability_zone, "availability_zone_2")
  
  tags = {
    Name = "private-subnet-2"
  }

}

resource "aws_route_table" "route_table_privet_2" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = lookup(var.cidr_block, "default_route")
    gateway_id = aws_nat_gateway.nat_2.id
  }
  
  tags = {
    Name = "rt-privet-2"
  }
}

resource "aws_route_table_association" "route_association_privet_2" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.route_table_privet_2.id
}

resource "aws_eip" "eip_2" {
  domain = "vpc"
  
  tags = {
    Name = "eip-2"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
  
  tags = {
    Name = "nat-private-2"
  }
}

