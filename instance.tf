provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "ansible_host" {
  ami = "ami-035c5dc086849b5de"
  instance_type = "t2.micro"
  key_name = "id"
  subnet_id = "${aws_subnet.main-public-1.id}"
  vpc_security_group_ids = [ "${aws_security_group.allow-ssh.id}" ]

  provisioner "file" {
    source = var.keyPath
    destination = "/tmp/id_rsa"
  }

  provisioner "file" {
    source = "playbook.yaml"
    destination = "/home/ec2-user/playbook.yaml"
  }

    provisioner "file" {
    source = "private_ips.txt"
    destination = "/tmp/private_ips.txt"
  }

  provisioner "file" {
    source = "hosts.py"
    destination = "/tmp/hosts.py"
  }

  provisioner "file" {
    source = "inventory.txt"
    destination = "/home/ec2-user/inventory.txt"
  }

   provisioner "file" {
    source = "ansible.sh"
    destination = "/tmp/ansible.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "mv /tmp/id_rsa ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa",
      "chmod 777 /tmp/ansible.sh",
      "sudo bash /tmp/ansible.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = ["sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key ~/.ssh/id_rsa -i inventory.txt playbook.yaml -b"]
  }
 


  connection {
    user = "ec2-user"
    private_key = file(var.keyPath)
    host = self.public_ip
  }

  tags = {
    Name = "Node Controller"
  }

  depends_on = [
    aws_instance.ansible_target_1, aws_instance.ansible_target_2
  ]

}

resource "aws_instance" "ansible_target_1" {
  ami = "ami-035c5dc086849b5de"
  instance_type = "t2.micro"
  key_name = "id"
  vpc_security_group_ids = [ "${aws_security_group.allow-ssh.id}", "${aws_security_group.allow-http.id}" ]
  subnet_id = "${aws_subnet.main-public-1.id}"

  provisioner "local-exec" {
    command = "echo ${self.tags.Name} ansible_host=${self.private_ip} ansible_user=ec2-user >> inventory.txt"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "Ansible-Node-1"
  }
}

resource "aws_instance" "ansible_target_2" {
  ami = "ami-035c5dc086849b5de"
  instance_type = "t2.micro"
  key_name = "id"
  subnet_id = "${aws_subnet.main-public-1.id}"
  vpc_security_group_ids = [ "${aws_security_group.allow-ssh.id}", "${aws_security_group.allow-http.id}" ]

  provisioner "local-exec" {
    command = "echo ${self.tags.Name} ansible_host=${self.private_ip} ansible_user=ec2-user >> inventory.txt"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "Ansible-Node-2"
  }
}