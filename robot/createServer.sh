#!/bin/bash
AMI_ID="$(aws ec2 describe-images --region us-east-1 --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')"
echo "AMI ID: $AMI_ID"

SG_ID="$(aws ec2 describe-security-groups --filters Name=group-name,Values=b51-allow-all | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')"

echo "Security Group ID: $SG_ID"

# aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID | jq