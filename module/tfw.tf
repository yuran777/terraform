
# # TGW

resource "aws_ec2_transit_gateway" "test" {
  description = "test"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "test" {
  subnet_ids         = [aws_subnet.subnettgw[0].id, aws_subnet.subnetprdtgw[0].id]
  transit_gateway_id = aws_ec2_transit_gateway.test.id
  vpc_id             = aws_vpc.vpc.id
}

