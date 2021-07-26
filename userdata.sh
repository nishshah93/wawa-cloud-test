#!/bin/bash
sudo su
sudo yum update -y
sudo yum install -y httpd
chkconfig httpd on
cd /var/www/html
aws s3api get-object --bucket nish-wawa-test-bucket --key index.html index.html
sudo systemctl start httpd
