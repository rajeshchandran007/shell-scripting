#!/bin/bash

if [ -z "$1" ]; then 
    echo -e "\e[31m Component name is required \n example usage is: \n\t bash createServer.sh componentName \e[0m"   
    exit 1 
fi 

COMPONENT=$1
HOSTED-ZONE-ID="Z00636481OT8FNJLH82AQ"

AMI_ID="$(aws ec2 describe-images --region us-east-1 --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq ".Images[].ImageId" | sed -e 's/"//g')"
echo "AMI ID: $AMI_ID"

SG_ID="$(aws ec2 describe-security-groups --filters Name=group-name,Values=b51-allow-all | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')"
echo "Security Group ID: $SG_ID"

# aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SGID  --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"| jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g'

CREATE_SERVER() {
    PRIVATE_IP="$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"| jq ."Instances[].PrivateIpAddress" | sed -e 's/"//g')"
    echo "Private IP: $PRIVATE_IP"

    sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/$COMPONENT/" route53.json > /tmp/dns.json 

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED-ZONE-ID --change-batch file:///tmp/dns.json | jq
}

if [ "$1" == "all" ]; then 
    for component in frontend catalogue cart user shipping payment mongodb mysql rabbitmq redis; do 
        COMPONENT=$component
        CREATE_SERVER
    done 
else 
        CREATE_SERVER 
fi 