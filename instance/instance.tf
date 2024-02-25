provider "aws" {
    region = "eu-north-1"
    access_key = var.access_key
    secret_key = var.secret_key
  
}

resource "aws_instance" "jen" {
    availability_zone = "eu-north-1a"
    ami = "ami-0014ce3e52359afbd"
    instance_type = "t3.micro"
    key_name = "jen"
    vpc_security_group_ids = [aws_security_group.default.id]
    ebs_block_device {
      device_name = "/dev/sda1"
      volume_size = 10
      volume_type = "standard"
    } 
}

resource "aws_security_group" "default" {
    ingress{
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}