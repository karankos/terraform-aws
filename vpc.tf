/*
  Define VPC
*/
resource "aws_vpc" "default"{
  cidr_block = "${var.vpc_cidr}"
  tags{
    Name = "terraform-aws-vpc"
  }

}

/*
  Internet Gateway
*/
resource "aws_internet_gateway" "igw"{
  vpc_id = "${aws_vpc.default.id}"
  tags{
    Name = "Terraform IGW"
  }
}

/*
    Elastic IP
*/
resource "aws_eip" "eip" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc = true
  tags{
    Name = "Elastic IP - ${count.index+1}"
  }
}

/*
  NAT Gateway
*/
resource "aws_nat_gateway" "nat" {
  //other arguments
  count = "${length(data.aws_availability_zones.azs.names)}"
  allocation_id = "${element(aws_eip.eip.*.id,count.index)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"

  tags{
    Name = "Terraform NAT - ${count.index+1}"
  }

  depends_on = ["aws_internet_gateway.igw"]
}
