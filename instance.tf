provider "aws" {
    access_key = "AKIA2VOPYYKR4LDHTGA**"
    secret_key = "bIUl8O39jsfdhKxMEREbcrlqvdmfKqzMR3Qp5GW*"
    region = "us-east-1"
  
}

resource "aws_instance" "web" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"

}

resource "aws_key_pair" "my_keypair" {
  key_name   = "my_keypair-us-east-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiUH590RxYbn8raZX3SKc3KbZYyvHjgdBMrPCDI7BSNZjxqW9fvLakhzezSqYFibef6tJq2+x/etGdVBlfeEEgG1LBfIvt1fKwJRN1D1lGsOUDhVRlN6FqnYd0CSJ/TXCjrUiXYZLzDY6R4+5CDuVwi00JGLpE96Y9itaeC9DozmPeo4yyp3Gaeso001KRtYCFicfIstEY6I0yC0Y22hPfEjGrbwDxLquN53UMpjRWUuhbw8vjEEYb5oeVTJsuqFqQlHUOA0mHPYY+DX/9nnkg6NtKlF6lUrUTrcpi33YdAOgHhqkK3Or4OwSCut3MNOJj4kRamSWNwneHhUJju/3J"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "my_own"
  }
}

resource "aws_subnet" "my_own_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.17.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_own_subnet"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_own_subnet.id
  private_ips = ["172.118.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-0b0dcb5067f052a63" 
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
