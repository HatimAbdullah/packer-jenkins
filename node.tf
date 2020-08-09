provider "aws" {
  region = "me-south-1"
}

resource "aws_key_pair" "hajen" {
  key_name   = "hajen"
  public_key =  file("./ssh/id_rsa.pub")
}

resource "aws_instance" "lordfish" {
  ami           = "ami-0b26282e36596f8fc"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.guardfish.id]
  key_name = aws_key_pair.hajen.key_name

  tags = {
    Name = "evil-server"
}
}

resource "aws_security_group" "guardfish" {
  name = "guardfish"
  
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "lordfish-gateway" {
  value = aws_instance.lordfish.public_ip
}

