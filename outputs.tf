output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Jenkins-Worker-Public-IP" {
  value = {
    for instance in aws_instance.jenkins-worker :
    instance.id => instance.public_ip
  }
}

output "dns-name" {
  value = aws_lb.application-lb.dns_name
}