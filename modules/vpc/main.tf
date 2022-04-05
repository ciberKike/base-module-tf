
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cdir
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = merge(var.tags_network, {Name = format("VPC-%s", var.sufix_name_resource)})
}

resource "aws_internet_gateway" "internet_gateway" {
    depends_on = [aws_vpc.vpc]
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags_network)
}

resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone_name["public1"]
    cidr_block = var.cidr_block["public1"]
    map_public_ip_on_launch = "true"
    tags = merge(var.tags_network, {Name = format("public-subnet-1-%s", var.sufix_name_resource)})
}

resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone_name["public2"]
    cidr_block = var.cidr_block["public2"]
    map_public_ip_on_launch = "true"
    tags = merge(var.tags_network, {Name = format("public-subnet-2-%s", var.sufix_name_resource)})
}

resource "aws_subnet" "private_subnet1" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone_name["private1"]
    cidr_block = var.cidr_block["private1"]
    map_public_ip_on_launch = "false"
    tags = merge(var.tags_network, {Name = format("private-subnet-1-%s", var.sufix_name_resource)})
}

resource "aws_subnet" "private_subnet2" {
    vpc_id = aws_vpc.vpc.id
    availability_zone = var.availability_zone_name["private2"]
    cidr_block = var.cidr_block["private2"]
    map_public_ip_on_launch = "false"
    tags = merge(var.tags_network, {Name = format("private-subnet-2-%s", var.sufix_name_resource)})
}

resource "aws_eip" "eip" {
    vpc = "true"
    tags = merge(var.tags_network, {Name = format("EIP-nat-gateway-%s", var.sufix_name_resource)})
}

resource "aws_eip" "eip2" {
    vpc = "true"
    tags = merge(var.tags_network, {Name = format("EIP-nat-gateway-%s", var.sufix_name_resource)})
}


resource "aws_nat_gateway" "natgateway" {
    subnet_id = aws_subnet.public_subnet1.id
    allocation_id = aws_eip.eip.id
    tags = merge(var.tags_network, {Name = format("%s", var.sufix_name_resource)})
}

resource "aws_nat_gateway" "natgateway2" {
    subnet_id = aws_subnet.public_subnet2.id
    allocation_id = aws_eip.eip2.id
    tags = merge(var.tags_network, {Name = format("%s", var.sufix_name_resource)})
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags_network, {Name = format("public-routetable-%s", var.sufix_name_resource)})
}

resource "aws_route" "default_public_route" {
    depends_on = [aws_internet_gateway.internet_gateway]
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet1_route_tablea_ssociation"{
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "public_subnet2_route_table_association"{
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet2.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags_network, {Name = format("private1-routetable-%s", var.sufix_name_resource)})
}

resource "aws_route" "default_private_route" {
    depends_on = [aws_internet_gateway.internet_gateway]
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway.id
}

resource "aws_route_table_association" "private_subnet1_route_table_association"{
    route_table_id = aws_route_table.private_route_table.id
    subnet_id = aws_subnet.private_subnet1.id
}

resource "aws_route_table" "private_route_table2" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.tags_network, {Name = format("private2-routetable-%s", var.sufix_name_resource)})
}

resource "aws_route" "default_private_route2" {
    depends_on = [aws_internet_gateway.internet_gateway]
    route_table_id = aws_route_table.private_route_table2.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway2.id
}


resource "aws_route_table_association" "private_subnet2_route_table_association"{
    route_table_id = aws_route_table.private_route_table2.id
    subnet_id = aws_subnet.private_subnet2.id
}

