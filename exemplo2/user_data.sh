#!/bin/bash

sudo su
yum update -y
yum install -y docker
service docker start
usermod -a -G docker ec2-user
docker run -p 80:8080 brunograna/public-api
# Este tipo de arquivo é executado toda vez que o container sobe na aws.