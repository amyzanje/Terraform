

resource "null_resource" "initialize_terraform" {


  provisioner "local-exec" {

    command = "cmd.exe /c new.bat"

  }
  depends_on = [terraform.init]
}



#resource "null_resource" "pre_hook" {

### when    = destroy

#}

#}

#resource "null_resource" "pre_hook" {
# provisioner "local-exec" {
#command = "echo  > terraform.tfvars && cmd.exe /c new.bat"
#  when    = "init"
#}
#}





provider "aws" {
  region = "us-east-1"

}





###########  VPC block ##################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = var.enable-dns-hostnames
  enable_dns_support   = var.enable-dns-support
  tags = {
    Name = var.vpc-name
  }
}

##########  Internet Gateway ############

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = var.igw_name
  }
}

######### Subnet #################

resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = var.public_subnet_name
  }
}


resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
  }
}



############ Route Table ###################
resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.public_rt
  }
}

resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = var.private_rt
  }
}


########### Route #####################

#resource "aws_route" "Public" {
# route_table_id         = aws_route_table.Public.id
#destination_cidr_block = "0.0.0.0/0"
#gateway_id             = aws_internet_gateway.gw.id
#depends_on             = [aws_route_table.Public]
#}


######### Security Group ###################

resource "aws_security_group" "Public_Sg" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = var.public_sg
  }
}

resource "aws_security_group" "Private_Sg" {
  name        = "only from subnet"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["10.0.1.0/24"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = var.private_sg
  }
}


################# Route Table Association #################

resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "Private" {
  subnet_id      = aws_subnet.Private.id
  route_table_id = aws_route_table.Private.id
}
################### KEY ################################
