data "aws_availability_zones" "available" {
  count = var.create_vpc ? 1 : 0
}

resource "aws_vpc" "main" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = merge(local.tags, { Name = "${title(var.project_name)} VPC" })
}

resource "aws_subnet" "public" {
  count                   = var.create_vpc ? var.az_count : 0
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags                    = merge(local.tags, { Name = "${title(var.project_name)} Public Subnet" })
}

resource "aws_subnet" "private" {
  count             = var.create_vpc ? var.az_count : 0
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags              = merge(local.tags, { Name = "${title(var.project_name)} Private Subnet" })
}

resource "aws_internet_gateway" "main" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags   = merge(local.tags, { Name = "${title(var.project_name)} Internet Gateway" })
}

resource "aws_route" "route" {
  count                  = var.create_vpc ? 1 : 0
  route_table_id         = aws_vpc.main[0].main_route_table_id
  destination_cidr_block = var.allow_all_cidr
  gateway_id             = aws_internet_gateway.main[0].id
}
