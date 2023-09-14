##############################
## vpc

resource "aws_vpc" "vpcprd" {
  cidr_block = var.vpc_cidr[2]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.tags[2]}-vpc"
  }
}

##############################
## public subnet
#  subnet

resource "aws_subnet" "publicprd" {

  # Count means how many you want to create the same resource
  # This will be generated with array format
  # For example, if the number of availability zone is three, then nat[2], nat[1], nat[2] will be created.
  # If you want to create each resource with independent name, then you have to copy the same code and modify some code

  

  count = length(var.prd_public_subnet)
  vpc_id     = aws_vpc.vpcprd.id
  cidr_block = var.prd_public_subnet[count.index]
  availability_zone       = var.aws_az[count.index]

  tags = {
    Name = "${var.tags[2]}-prd-pub-sub-${var.aws_az_des[count.index]}"
  }
}

######################################
## Public route table and association

# public route table

resource "aws_route_table" "prd-public-rt" {
  count = length(var.prd_public_subnet)
  vpc_id = aws_vpc.vpcprd.id

  tags = {
    Name = "${var.tags[2]}-prd-pub-rt-${var.aws_az_des[count.index]}"
  }
}


# public route association

resource "aws_route_table_association" "prdpublicassociationa" {
  count = length(var.prd_public_subnet)

# element is used for select the resource from the array 
# Usage = element (array, index) => equals array[index]

  subnet_id      = element(aws_subnet.publicprd.*.id, count.index)
  route_table_id = element(aws_route_table.prd-public-rt.*.id, count.index)

}


# public route 

resource "aws_route" "igwprd" {
  count = length(var.prd_public_subnet)

  route_table_id         = aws_route_table.prd-public-rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

##############################
## workload subnet
#  subnet
resource "aws_subnet" "subnetworkloadprd" {
  count            = length(var.prd_workload_subnet)
  vpc_id     = aws_vpc.vpcprd.id
  cidr_block = var.prd_workload_subnet[count.index]
  availability_zone = var.aws_az[count.index]
  tags = {
    Name = "${var.tags[2]}-prd-workload-subnet-${var.aws_az_des[count.index]}"
  }
}


######################################
## prd-workload route table and association

# prd-workload route table

resource "aws_route_table" "prd-workload-rt" {
  count            = length(var.prd_workload_subnet)
  vpc_id     = aws_vpc.vpcprd.id

  tags = {
    Name = "${var.tags[2]}-prd-workload-rt-${var.aws_az_des[count.index]}"
  }
}


# prd-workload route association

resource "aws_route_table_association" "prd-workloadcassociationa" {
  count            = length(var.prd_workload_subnet)

  subnet_id      = element(aws_subnet.subnetworkloadprd.*.id, count.index)
  route_table_id = element(aws_route_table.prd-workload-rt.*.id, count.index)

}


# prd-workload route 

 


resource "aws_route" "prd-workload" {
  count            = length(var.prd_workload_subnet)

  route_table_id = element(aws_route_table.prd-workload-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway_a.id
}



##############################
## TGW subnet
# # subnet
resource "aws_subnet" "subnetprdtgw" {
  count = length(var.prd_tgw_subnet)
  vpc_id     = aws_vpc.vpcprd.id
  cidr_block = var.prd_tgw_subnet[count.index]
  availability_zone = var.aws_az[count.index]
  tags = {
    Name = "${var.tags[2]}-tgw-prd-subnet-${var.aws_az_des[count.index]}"
  }
}


######################################
## TGW route table and association

# TGW route table

resource "aws_route_table" "tgw-prd-rt" {
  count = length(var.prd_tgw_subnet)
  vpc_id = aws_vpc.vpcprd.id

  tags = {
    Name = "${var.tags[2]}-tgw-prd-rt-${var.aws_az_des[count.index]}"
  }
}


# TGW route table association

resource "aws_route_table_association" "TGWcassociationprda" {
  count = length(var.prd_tgw_subnet)

  subnet_id      = element(aws_subnet.subnetprdtgw.*.id, count.index)
  route_table_id         = element(aws_route_table.tgw-prd-rt.*.id, count.index)
}

# TGW route 



resource "aws_route" "TGWprd" {
  count = length(var.prd_tgw_subnet)

  route_table_id         = element(aws_route_table.tgw-prd-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "aws_ec2_transit_gateway.test.id"
}


##############################
## igw

resource "aws_internet_gateway" "prdigw" {
  vpc_id = aws_vpc.vpcprd.id

  tags = {
    Name = "${var.tags[2]}-IGW"
  }
}

