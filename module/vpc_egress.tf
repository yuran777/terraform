data "aws_availability_zones" "available" {
  state = "available"
}

##############################
## vpc

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr[0]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tags[0]}-vpc"
  }
}

##############################
## public subnet
#  subnet

resource "aws_subnet" "subnetpub" {

  # Count means how many you want to create the same resource
  # This will be generated with array format
  # For example, if the number of availability zone is three, then nat[0], nat[1], nat[2] will be created.
  # If you want to create each resource with independent name, then you have to copy the same code and modify some code

  count = length(var.egress_public_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.egress_public_subnet[count.index]
  availability_zone       = var.aws_az[count.index]

  tags = {
    Name = "${var.tags[0]}-pub-sub-${var.aws_az_des[count.index]}"
  }
}

######################################
## Public route table and association

# public route table

resource "aws_route_table" "public-rt" {
  count = length(var.egress_public_subnet)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags[0]}-pub-rt-${var.aws_az_des[count.index]}"
  }
}


# public route association

resource "aws_route_table_association" "publicassociationa" {
  count = length(var.egress_public_subnet)

# element is used for select the resource from the array 
# Usage = element (array, index) => equals array[index]

  subnet_id      = element(aws_subnet.subnetpub.*.id, count.index)
  route_table_id = element(aws_route_table.public-rt.*.id, count.index)

}


# public route 

resource "aws_route" "igw" {
  count = length(var.egress_public_subnet)

  route_table_id         = element(aws_route_table.public-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

##############################
## FW subnet
#  subnet
resource "aws_subnet" "subnetfw" {
  count            = length(var.egress_fw_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.egress_fw_subnet[count.index]
  availability_zone = var.aws_az[count.index]
  tags = {
    Name = "${var.tags[0]}-fw-subnet-${var.aws_az_des[count.index]}"
  }
}


######################################
## FW route table and association

# FW route table

resource "aws_route_table" "fw-rt" {
  count = length(var.egress_fw_subnet)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags[0]}-fw-rt-${var.aws_az_des[count.index]}"
  }
}


# FW route association

resource "aws_route_table_association" "FWcassociationa" {
  count = length(var.egress_fw_subnet)

  subnet_id      = element(aws_subnet.subnetfw.*.id, count.index)
  route_table_id = element(aws_route_table.fw-rt.*.id, count.index)

}


# FW route 

 


resource "aws_route" "FW" {
  count = length(var.egress_fw_subnet)

  route_table_id         = element(aws_route_table.fw-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway_a.id
}



##############################
## TGW subnet
# # subnet
resource "aws_subnet" "subnettgw" {
  count = length(var.egress_tgw_subnet)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.egress_tgw_subnet[count.index]
  availability_zone = var.aws_az[count.index]
  tags = {
    Name = "${var.tags[0]}-tgw-subnet-${var.aws_az_des[count.index]}"
  }
}


######################################
## TGW route table and association

# TGW route table

resource "aws_route_table" "tgw-rt" {
  count = length(var.egress_tgw_subnet)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags[0]}-tgw-rt-${var.aws_az_des[count.index]}"
  }
}


# TGW route table association

resource "aws_route_table_association" "TGWcassociationa" {
  count = length(var.egress_tgw_subnet)

  subnet_id      = element(aws_subnet.subnettgw.*.id, count.index)
  route_table_id         = element(aws_route_table.tgw-rt.*.id, count.index)
}

# TGW route 



resource "aws_route" "TGW" {
  count = length(var.egress_tgw_subnet)

  route_table_id         = element(aws_route_table.tgw-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "aws_ec2_transit_gateway.test.id"
}


##############################
## igw

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.tags[0]}-IGW"
  }
}

##############################
## Nat gateway

# NAT Gateway a
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id      = aws_subnet.subnetpub[0].id

}


# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
}
