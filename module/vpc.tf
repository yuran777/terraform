data "aws_availability_zones" "available" {
  state = "available"
}

##############################
## vpc

resource "aws_vpc" "egress_inspectionvpc" {
  cidr_block       = "10.3.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "egress_inspectionvpc"
  }
}

##############################
## public subnet
#  subnet
resource "aws_subnet" "egress_inspection-public-subnet-a" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.3.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]   # e.g. ap-northeast-2a

  tags = {
    Name = "egress_inspection-public-subnet-a"
  }
}

resource "aws_subnet" "egress_inspection-public-subnet-c" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.6.0/24"

  availability_zone = data.aws_availability_zones.available.names[2]   # e.g. ap-northeast-2c

  tags = {
    Name = "egress_inspection-public-subnet-c"
  }
}

######################################
## Public route table and association

# public route table

resource "aws_route_table" "public-rt-a" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "public-rt-a"
  }
}

resource "aws_route_table" "public-rt-c" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "public-rt-c"
  }
}

# public route association

resource "aws_route_table_association" "publicassociationa" {
  subnet_id      = aws_subnet.egress_inspection-public-subnet-a.id
  route_table_id = aws_route_table.public-rt-a.id
}


resource "aws_route_table_association" "publicassociationc" {
  subnet_id      = aws_subnet.egress_inspection-public-subnet-c.id
  route_table_id = aws_route_table.public-rt-c.id
}

# public route 
resource "aws_route" "igw-a" {
  route_table_id         = aws_route_table.public-rt-a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}
resource "aws_route" "igw-c" {
  route_table_id         = aws_route_table.public-rt-c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

##############################
## FW subnet
#  subnet
resource "aws_subnet" "egress_inspection-FW-subnet-a" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]   # e.g. ap-northeast-2a

  tags = {
    Name = "egress_inspection-FW-subnet-a"
  }
}

resource "aws_subnet" "egress_inspection-FW-subnet-c" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.5.0/24"

  availability_zone = data.aws_availability_zones.available.names[2]   # e.g. ap-northeast-2c

  tags = {
    Name = "egress_inspection-FW-subnet-c"
  }
}

######################################
## FW route table and association

# FW route table

resource "aws_route_table" "FW-rt-a" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "FW-rt-a"
  }
}


resource "aws_route_table" "FW-rt-c" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "FW-rt-c"
  }
}

# FW route association

resource "aws_route_table_association" "FWcassociationa" {
  subnet_id      = aws_subnet.egress_inspection-FW-subnet-a.id
  route_table_id = aws_route_table.FW-rt-a.id
}
resource "aws_route_table_association" "FWcassociationc" {
  subnet_id      = aws_subnet.egress_inspection-FW-subnet-c.id
  route_table_id = aws_route_table.FW-rt-c.id
}

# FW route 

resource "aws_route" "FW-a" {
  route_table_id         = aws_route_table.FW-rt-a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway_a.id
}
resource "aws_route" "FW-c" {
  route_table_id         = aws_route_table.FW-rt-c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway_a.id

}


##############################
## TGW subnet
#  subnet
resource "aws_subnet" "egress_inspection-TGW-subnet-a" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.2.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]   # e.g. ap-northeast-2a

  tags = {
    Name = "egress_inspection-TGW-subnet-a"
  }
}

resource "aws_subnet" "egress_inspection-TGW-subnet-c" {
  vpc_id     = aws_vpc.egress_inspectionvpc.id
  cidr_block = "10.3.4.0/24"

  availability_zone = data.aws_availability_zones.available.names[2]   # e.g. ap-northeast-2c

  tags = {
    Name = "egress_inspection-TGW-subnet-c"
  }
}


######################################
## TGW route table and association

# TGW route table

resource "aws_route_table" "TGWrta" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "TGWrta"
  }
}

resource "aws_route_table" "TGWrtc" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "TGWrtc"
  }
}

# TGW route table association

resource "aws_route_table_association" "TGWcassociationa" {
  subnet_id      = aws_subnet.egress_inspection-TGW-subnet-a.id
  route_table_id = aws_route_table.TGWrta.id
}

resource "aws_route_table_association" "TGWcassociationc" {
  subnet_id      = aws_subnet.egress_inspection-TGW-subnet-c.id
  route_table_id = aws_route_table.TGWrtc.id
}

# TGW route 

resource "aws_route" "TGW-a" {
  route_table_id         = aws_route_table.TGWrta.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = "aws_ec2_transit_gateway.test.id"
}
resource "aws_route" "TGW-c" {
  route_table_id         = aws_route_table.TGWrtc.id
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = "aws_transit_gateway.test.id"

}

##############################
## igw

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.egress_inspectionvpc.id

  tags = {
    Name = "yrk-igw"
  }
}

##############################
## Nat gateway

# NAT Gateway a
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.egress_inspection-public-subnet-a.id
}

# # NAT Gateway c
# resource "aws_nat_gateway" "nat_gateway_c" {
#   allocation_id = aws_eip.nat_eip_c.id
#   subnet_id     = aws_subnet.egress_inspection-public-subnet-c.id
# }

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
}

# resource "aws_eip" "nat_eip_c" {
#   domain = "vpc"
# }

# # TGW

resource "aws_ec2_transit_gateway" "test" {
  description = "test"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "test" {
  subnet_ids         = [aws_subnet.egress_inspection-TGW-subnet-a.id, aws_subnet.egress_inspection-TGW-subnet-a.id]
  transit_gateway_id = aws_ec2_transit_gateway.test.id
  vpc_id             = aws_vpc.egress_inspectionvpc.id
}
