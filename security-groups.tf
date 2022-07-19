resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-ssh"
  description = "Security group that allows SSH"

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "allow-http" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow HTTP"
  description = "Security group to allow ssh"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    protocol = "tcp"
    to_port = 443
  }


  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 81
    protocol = "tcp"
    to_port = 81
  }

  tags = {
    Name = "Allow HTTP"
  }
}
