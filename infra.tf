provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "infra" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["launch-wizard-1"]

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
