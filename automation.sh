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

# Checks if inventory.html exists in /var/wwww/html folder
# If it is not present, create the file with header and other html tags
# If the file exists, append the log meta data to html file

if [[ ! -f "/var/www/html/inventory.html" ]]
then
	printf "inventory.html does not exist, creating the html file with header.\n"

	echo -e "<html> <head><title>Apache log book keeping</title></head>  <body> <table border=1 > <thead> <tr> <th>Log Type</th> <th>Time Created</th> <th>Type</th> <th>Size</th> </tr> <thead> <tbody>" > /var/www/html/inventory.html 
fi

# fetch log type, creation time, log type and size from the newly created tar file name

log_details=`ls -rt *httpd* | head -1`
log_type=`echo $log_details | awk -F"-" '{print $2}'`
time_cr=$timestamp
typelog=`echo $log_details | awk -F"." '{print $2}'`
size=`ls -lh $log_details | awk -F" " '{print $5}'`

# Append the formatted data into inventory.html file

echo -e "<tr>" >>/var/www/html/inventory.html
echo -e "
	<td>$log_type</td><td>$time_cr</td><td>$typelog</td><td>$size</td>" >>/var/www/html/inventory.html
echo -e "</tr>" >> /var/www/html/inventory.html

# Adding the script to CRON
# If Cron file is not present, create the cron file with schedule

if [[ ! -f /etc/cron.d/automation ]]
then
	printf "/etc/cron.d/automation does not exist, creating the file with required schedule.\n"
	# Below cron runs the script with root privilege everyday at 8:30 am
	echo "30 08 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi

# End of script
