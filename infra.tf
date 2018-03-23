provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "tinfra" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["launch-wizard-1"]

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
            "git --version",
            "sudo apt-get -y update",
            "sudo apt-get -y install nginx",
            "sudo service nginx restart"
           ]
     }

}

output "ip" {
  value = "${aws_instance.tinfra.public_ip}"
}
