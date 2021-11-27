#!/bin/bash

# TASK 1
# Running update command
# Variables

S3BUCKET="upgrad-jitesh"
MYNAME="jitesh"
printf "Checking for updates...\n"

#sudo apt update -y > /dev/null 2>&1

# Check if apach2 is installed or not

check=`which apache2`
printf "$check\n"
if [[ -z $check ]]
then
	printf "Installing apache2..\n"
        sudo apt install apache2
else
        echo "Apache is installed on path -> " ` which apache2` 
fi

checkApache=`systemctl --state=active | grep apache2`
if [[ ! -z $checkApache ]]
then
	printf "Apache2 is running\n"
else
	printf "apache2 is not Running..\n"
	printf "Starting Apache2..\n"
	sudo /etc/init.d/apache2 start
	printf "\n"
	systemctl --state=active | grep apache2
fi
cd "/root/Automation_Project/tmp/"

# creating tar of apache access logs with timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')
cp /var/log/apache2/access.log .
tar cvfj $MYNAME-httpd-logs-$timestamp.tar  access.log
rm access.log

# AWS CLI
# aws s3 \
# cp /tmp/${MYNAME}-httpd-logs-${timestamp}.tar \
# s3://${S3BUCKET}/${MYNAME}-httpd-logs-${timestamp}.tar

if [[ ! -f "/var/www/html/inventory.html" ]]
then
#	printf "inventory.html is not preset. \nCreating it..\n"
 #       echo -e "
 #       Log Type         Time Created         Type        Size
 #       " > /var/www/html/inventory.html
#	print "\n" >> /var/www/html/inventory.html
	echo -e "<html> <head><title>Apache log book keeping</title></head>  <body> <table border=1 > <thead> <tr> <th>Log Type</th> <th>Time Created</th> <th>Type</th> <th>Size</th> </tr> <thead> <tbody>" > /var/www/html/inventory.html 

fi

log_details=`ls -rt *httpd* | head -1`
log_type=`echo $log_details | awk -F"-" '{print $2}'`
time_cr=$timestamp
typelog=`echo $log_details | awk -F"." '{print $2}'`
size=`ls -lh $log_details | awk -F" " '{print $5}'`
echo -e "<tr>" >>/var/www/html/inventory.html
echo -e "
	<td>$log_type</td><td>$time_cr</td><td>$typelog</td><td>$size</td>" >>/var/www/html/inventory.html
#printf "<td>%s</td><td>%s</td><td>%s</td><td>%s</td>\n" "$log_type $time_cr $typelog $size" >> /var/www/html/inventory.html
echo -e "</tr>" >> /var/www/html/inventory.html
