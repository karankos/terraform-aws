
##################PUBLIC######################
/*
  Public Subnet
*/

resource "aws_subnet" "public-subnet"{
count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${element(var.public_subnet_cidr,count.index)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"

  tags{
    Name = "Terraform Public Subnet-${count.index+1}"
  }
}

/*
  Public Route table
*/
resource "aws_route_table" "public-rt"{
  vpc_id = "${aws_vpc.default.id}"

  route{
    cidr_block ="0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags{
    Name = "Terraform Public Route Table"
  }
}
/*
  Public Route table association with Public Subnet
*/
resource "aws_route_table_association" "terraform-public"{
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  route_table_id="${aws_route_table.public-rt.id}"
}

###############PRIVATE######################
/*
  Private Subnet
*/
resource "aws_subnet" "private-subnet"{
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${element(var.private_subnet_cidr,count.index)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  tags{
    Name = "Terraform Private Subnet-${count.index+1}"
  }
}
#
/*
  Private Route Table
*/
resource "aws_route_table" "private-rt"{
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id = "${aws_vpc.default.id}"

  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id,count.index)}"
  }

  tags{
    Name = "Terraform Private Route Table"
  }
}

/*
  Private Route table association with Public Subnet
*/
resource "aws_route_table_association" "terraform-private"{
  count = "${length(data.aws_availability_zones.azs.names)}"
  subnet_id = "${element(aws_subnet.private-subnet.*.id,count.index)}"
  route_table_id="${element(aws_route_table.private-rt.*.id, count.index)}"
}
