provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "tinfra"{
    name="terraform-tinfra"
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

resource "aws_instance" "tinfra" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.tinfra.name}"]

  tags {
    Name = "tinfra"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("/home/ubuntu/Ran_NV.pem")}"

    }

provisioner "local-exec" {
    command = "rm ip_address.txt"
    command = "echo ${aws_instance.tinfra.public_ip} > ip_address.txt"
}

provisioner "remote-exec"{
 
        inline=[
            "pwd",
            "git --version"
           ]
     }

}

output "ip" {
  value = "${aws_instance.tinfra.public_ip}"
}
