###################################################################

# Script name : automation.sh
# Author : Jitesh Kale

###################################################################

#!/bin/bash

# Static Variables

S3BUCKET="upgrad-jitesh"
MYNAME="jitesh"

printf "Checking for updates...\n"

# get updates everytime script runs
# output is send to null void

sudo apt update -y > /dev/null 2>&1

# Check if apach2 is installed or not
# If apache2 is not installed, run the install command

check=`which apache2`
if [[ -z $check ]]
then
	printf "Installing apache2..\n"
        sudo apt install apache2
else
        echo "Apache is installed on path -> " ` which apache2` 
fi

# Check if apache is running or not
# This can also check even after ubuntu is restarted/rebooted

checkApache=`systemctl --state=active | grep apache2`
if [[ ! -z $checkApache ]]
then
	printf "Apache2 is running.\n"
else
	printf "Apache2 is not Running..\n"
	printf "Starting Apache2..\n"
	sudo /etc/init.d/apache2 start
	printf "\n"
	systemctl --state=active | grep apache2
fi

# Switching to project tmp directory where tars will be stored

cd /tmp/

# creating tar of apache access logs with timestamp into tmp folder
timestamp=$(date '+%d%m%Y-%H%M%S')
cp /var/log/apache2/access.log .
tar cvfj $MYNAME-httpd-logs-$timestamp.tar  access.log > /dev/null 2>&1

# Removes copied access.log file from tmp folder
rm access.log

# AWS CLI commands are fired to copy tar archive to S3 bucket
printf "Storing tar file to S3 bucket.\n"
aws s3 \
cp /tmp/${MYNAME}-httpd-logs-${timestamp}.tar \
s3://${S3BUCKET}/${MYNAME}-httpd-logs-${timestamp}.tar

# End of script
