#!/bin/bash 

clear

echo "

___  ____ _  _ ____    _ _  _ ____ ___ ____ _    _    ____ ____ 
  /  |___ |  | [__     | |\ | [__   |  |__| |    |    |___ |__/ 
 /__ |___ |__| ___]    | | \| ___]  |  |  | |___ |___ |___ |  \ 
                                                                
"
 
#This script will install qbittorrent.

######################################################################

#Functions List

noanswer () { echo "Skipping..." ; }
updatesys () { yes | sudo apt-get update && sudo apt-get upgrade; }

######################################################################

echo "This script assumes you have your docker files located in your /home/$USER/raspi-docker folder."
echo "If your folder is located elsewhere, you will need to change the location of your docker-compose files in this script."
echo "This script follows my other guide of insatlling Docker and Mullvad VPN. Visit https://github.com/LordZeuss/raspi-docker for more info."
echo " "
echo "NOTE: With this qbittorrent script, it will default to downloading in the /home/$USER/Downloads folder."
echo "NOTE: The config files will default to /home/$USER/raspi-docker/qbittorrent unless otherwise changed in the script."
echo "I recommend changing the locations of downloads and the config file location if yours is in an alternate location."
echo " "
echo "This Script assumes your timezone is US/Central. You may need to modify."
######################################################################

#Update the system

echo " "
echo " "
echo "Would you like to update your system (Recommended)? (y/n/e)"
echo " "
echo "y=yes | n=no | e=exit-program"
read yesorno

if [ "$yesorno" = y ]; then
	updatesys
	echo "Update Successful."
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
	exit 1
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Test if Docker is working and installed

echo "Would you like to check if Docker is working(Recommended)? (y/n/e)"

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
	exit 1
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install qBittorrent

echo "Would you like install qBittorrent? (y/n/e)"

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
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/qbittorrent:/config
      - /home/$USER/raspi-docker/downloads:/downloads
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
	exit 1
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi


#Install Transmission

echo "Would you like install Transmission? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/transmission
	mkdir /home/$USER/raspi-docker/transmission/config
	echo "transmission:
    image: linuxserver/transmission
    container_name: transmission
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - TRANSMISSION_WEB_HOME=/combustion-release/ #optional
#      - USER=username #optional
#      - PASS=password #optional
    volumes:
      - ./home/$USER/raspi-docker/transmission/config:/config
      - ./home/$USER/raspi-docker/downloads:/downloads
      - ./downloads/TransmissionWatchFolder:/watch
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
	exit 1
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install Deluge

echo "Would you like install Deluge? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/deluge
	mkdir /home/$USER/raspi-docker/deluge/config
	echo "deluge:
    image: linuxserver/deluge
    container_name: deluge
    # network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - UMASK=022 #optional
      - DELUGE_LOGLEVEL=error #optional
    volumes:
      - ./home/$USER/raspi-docker/deluge/config:/config
      - ./home/$USER/raspi-config/downloads:/downloads
    ports:
      - 8112:8112
      - 58846:58846
      - 58946:58946" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo "Goodbye!"
	exit 1
else
	echo "Not a valid answer. Exiting..."
	exit 1
fi


######################################################################

echo " "
echo " "
echo " "
echo "Installer Complete."
echo "To access Portainer, go to the IP of this device in a web-browser, port 9000. Ex: 192.168.1.18:9000"
echo " "
echo "Goodbye!" 
