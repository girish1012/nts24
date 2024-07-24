provider "aws" {
    access_key = "AKIAW5IZRWOY2BYFATP4"
    secret_key = "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"
    region = "us-east-1"
  }


variable "region" {

 default = "us-east-1"

}

variable "private_key_path" {

 default = "nts24key-new.pem"

}



resource "aws_instance" "web-server" {

  count = 2

 ami      = "ami-04a81a99f5ec58529"

 instance_type = "t2.micro"

 key_name   = "nts24key-new"

 tags = {

  "Name" = "vmnts24-${count.index}"

 }





}



output "out_ip1" {

  value = aws_instance.web-server[0].public_ip

}



output "out_ip2" {

  value = aws_instance.web-server[1].public_ip

}



resource "null_resource" "nr24_1" {



provisioner "remote-exec" {

  inline = [

    "sudo apt-get update",

		"sudo apt-get install -y nginx"    

     

   ]

  }



connection {

 user    = "ubuntu"

  private_key = "${file("${var.private_key_path}")}"

   host = "${aws_instance.web-server[0].public_ip}"

}



  

}



resource "null_resource" "nr24" {


provisioner "remote-exec" {

  inline = [

    "sudo apt-get update",

		"sudo apt-get install -y apache2"    

     

   ]

  }



connection {

 user    = "ubuntu"

  private_key = "${file("${var.private_key_path}")}"

   host = "${aws_instance.web-server[1].public_ip}"

}

}