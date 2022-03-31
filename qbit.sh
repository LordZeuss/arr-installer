#!/bin/bash 

echo "

___  ____ _  _ ____    _ _  _ ____ ___ ____ _    _    ____ ____ 
  /  |___ |  | [__     | |\ | [__   |  |__| |    |    |___ |__/ 
 /__ |___ |__| ___]    | | \| ___]  |  |  | |___ |___ |___ |  \ 
                                                                
"

#This is a script to help install essentials for docker. 

#This script will install portainer, sonarr, radarr, jackett, and qbittorrent.

######################################################################

#Functions List

noanswer () { echo "Skipping..." ; }
updatesys () { yes | sudo apt-get update && sudo apt-get upgrade; }

######################################################################

echo "This script assumes you have your docker files located in your /home/$USER/raspi-docker folder."
echo "If your folder is located elsewhere, you will need to change the location of your docker-compose files in this script."
echo "This script follows my other guide of insatlling Docker and Mullvad VPN. Visit https://github.com/LordZeuss/raspi-docker for more info.
echo " "
echo "NOTE: With this qbittorrent script, it will default to downloading in the /home/$USER/Downloads folder."
echo "NOTE: The config files will default to /home/$USER/raspi-docker/qbittorrent unless otherwise changed in the script."
echo "I recommend changing the locations of downloads and the config file location if yours is in an alternate location."
echo " "
echo "This Script assumes your timezone is US/Eastern. You may need to modify."
######################################################################

#Update the system

echo "Would you like to update your system (Recommended)? (y/n/e)"
echo "y=yes | n=no | e=exit-program'
read yesorno

if [ "$yesorno" = y ]; then
	updatesys
	echo "Update Successful."
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Test if Docker is working and installed

echo "Would you like to check if Docker is working(Recommended)? (y/n)"

read yesorno

if [ "$yesorno" = y ]; then
	echo 'Checking Docker version...'
	docker version
	docker-compose -v
	echo " "
	echo "If no errors occured, Docker should be good to go."
	echo "If an error occured, try running the docker-troubleshoot-fix.sh script."
	echo " "
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install Qbittorrent

echo "Would you like to check if Docker is working(Recommended)? (y/n)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/qbittorrent
	echo "qbittorrent:
    container_name: qbittorrent
    image: hotio/qbittorrent
    ports:
      - 8282:8080
    environment:
      - PUID=1001
      - PGID=100
      - UMASK=002
      - TZ=US/Eastern
    volumes:
      - /home/$USER/raspi-docker/qbittorrent:/config
    restart: unless-stopped" >> home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################
echo " "
echo "Installer Complete."
echo "To access Portainer, go to the IP of this device in a web-browser, port 9000. Ex: 192.168.1.18:9000"
echo " "
echo "Goodbye!" 
