provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "infra"{
    name="terraform-infra"
    description="Created by terraform"
 
    ingress{
        from_port = 22
        to_port = 22
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
}

resource "aws_instance" "infra" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.infra.name}"]

  tags {
    Name = "infra"
  }

  connection {
    user = "ubuntu"
    private_key = "${var.key_path}"
    type = "ssh"
  }

provisioner "local-exec" {
    command = "rm ip_address.txt"
    command = "echo ${aws_instance.infra.public_ip} > ip_address.txt"
}
}

output "ip" {
  value = "${aws_instance.infra.public_ip}"
}
