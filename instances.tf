# Get AMI
data "aws_ssm_parameter" "linuxAMI" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "linuxAMI-west1" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "master-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "worker-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }

  depends_on = [
    aws_main_route_table_association.set-master-default-rt-assoc
  ]

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
  ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-master.yml
  EOF
  }

}

resource "aws_instance" "jenkins-worker" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAMI-west1.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-worker-sg.id]
  subnet_id                   = aws_subnet.subnet_3.id

  tags = {
    Name = join("_", ["jenkins_worker_tf", count.index + 1])
  }

  depends_on = [
    aws_main_route_table_association.set-worker-default-rt-assoc, aws_instance.jenkins-master
  ]

  provisioner "local-exec" {
    command = <<EOF
  aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id}
  ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/jenkins-worker.yml
  EOF
  }
}