#!/bin/bash 

echo "

___  ____ _  _ ____    _ _  _ ____ ___ ____ _    _    ____ ____ 
  /  |___ |  | [__     | |\ | [__   |  |__| |    |    |___ |__/ 
 /__ |___ |__| ___]    | | \| ___]  |  |  | |___ |___ |___ |  \ 
                                                                
"

#This is a script to help install essentials for docker. 

#This script will install portainer, sonarr, radarr, and jackett.

######################################################################

#Functions List

noanswer () { echo "Skipping..." ; }
updatesys () { yes | sudo apt-get update && sudo apt-get upgrade; }

######################################################################

echo "This script assumes you have your docker files located in your /home/$USER/raspi-docker folder."
echo " "
echo "If your folder is located elsewhere, you will need to change the location of your docker-compose files in this script."
echo " "
echo "This script follows my other guide of insatlling Docker and Mullvad VPN. Visit https://github.com/LordZeuss/raspi-docker for more info."
echo " "
######################################################################

#Update the system
echo " "
echo "Would you like to update your system (Recommended)? (y/n/e)"
echo " "
echo "y=yes | n=no | e=exit-program"
echo " "

read yesorno

if [ "$yesorno" = y ]; then
	updatesys
	echo "Update Successful."
	echo " "
elif [ "$yesorno" = n ]; then
	echo "Skipping..."
	echo " "
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
	echo "Docker-Compose version not found is not an error"
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

#Install Portainer

echo "Would you like to install Portainer (Required if not already insalled)? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	echo "portainer:
  container_name: portainer
  restart: unless-stopped
  ports:
   - 9000:9000
  volumes:
   - /var/run/docker.sock:/var/run/docker.sock
   - /home/dockeras/portainer:/data
  environment:
   - PUID=1000
   - PGID=150
   - TZ=US/Eastern
  image: portainer/portainer" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
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

#Install Sonarr

echo "Would you like to install Sonarr? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	echo "sonarr:
  container_name: sonarr
  restart: unless-stopped
  ports:
   - 8989:8989
  volumes:
   - /home/dockeras/sonarr:/config
   - /home/downloads:/downloads
   - /home/downloads:/tv
  environment:
   - PUID=1000
   - PGID=150
   - TZ=US/Eastern
  image: linuxserver/sonarr" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
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

#Install Radarr

echo "Would you like to install Radarr? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	echo "radarr:
    image: linuxserver/radarr:5.14
    container_name: radarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=UTC
      - UMASK=022 #optional
    volumes:
      - ./home/dockeras/radarr:/config
      - ./home/downloads:/movies
    ports:
      - 7878:7878
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
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

#Installing Jackett

echo "Would you like to install Jackett (Required for Sonarr/Radarr)? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	echo "jackett:
  container_name: jackett
  restart: unless-stopped
  ports:
   - 9117:9117
  volumes:
   - /home/dockeras/jackett:/config
  environment:
   - PUID=1000
   - PGID=150
   - TZ=US/Eastern
  image: linuxserver/jackett" >> /home/$USER/raspi-docker/docker-compose.yml 		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
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

#############################################################################################

#Install AdGuard

echo "Would you like to install AdGuard (DNS Adblocker)? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir adguard
	echo "adguardhome:
    image: adguard/adguardhome
    container_name: adguardhome
    ports:
      - 53:53/tcp
      - 53:53/udp
      - 784:784/udp
      - 853:853/tcp
      - 3000:3000/tcp
      - 80:80/tcp
      - 443:443/tcp
    volumes:
      - ./workdir:/opt/adguardhome/work
      - ./confdir:/opt/adguardhome/conf
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
echo "Successfully Added"
echo " "
echo "Add - 67:67/udp -p 68:68/tcp -p 68:68/udp to use AdGuard as DHCP Server."
echo "Find on port 3000. IP:3000"
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


#Readarr

echo "Would you like to install Readarr? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir readarr
	echo "readarr:
    image: lscr.io/linuxserver/readarr:develop
    container_name: readarr
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=US/Eastern
    volumes:
      - /home/$USER/raspi-docker/readarr:/config
      - /path/to/books:/books #optional
      - /path/to/downloadclient-downloads:/downloads #optional
    ports:
      - 8787:8787
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
echo "Successfully Added"
echo " "
echo "Don't forget to add the path to your books and or download client!"
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



#bazarr

echo "Would you like to install Bazarr (Subtitles)? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir bazarr
	echo "bazarr:
    image: lscr.io/linuxserver/bazarr
    container_name: bazarr
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=US/Eastern
    volumes:
      - /home/$USER/raspi-docker/bazarr:/config
      - /path/to/movies:/movies #optional
      - /path/to/tv:/tv #optional
    ports:
      - 6767:6767
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
echo "Successfully Added"
echo " "
echo "Don't forget to add the path to your movies and tv shows!"
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



#overseerr

echo "Would you like to install Overseerr? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir Overseerr
	echo "overseerr:
    image: sctx/overseerr:latest
    container_name: overseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=US/Eastern
    ports:
      - 5055:5055
    volumes:
      - /home/$USER/raspi-docker/overseerr:/app/config
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
echo "Successfully Added"
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


#heimdall

echo "Would you like to install Heimdall? (y/n/e)"

read yesorno

if [ "$yesorno" = y ]; then
	mkdir heimdall
	echo "heimdall:
    image: lscr.io/linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=US/Eastern
    volumes:
      - /home/$USER/raspi-docker/heimdall:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed. 
echo "Successfully Added"
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





echo " "
echo "Installer Complete. Run qbittorrent.sh if you would like to install that as well."
echo " "
echo "NOTE: With the qbittorrent script, it will default to downloading in the /home/$USER/Downloads folder."
echo "NOTE: The config files will default to /home/$USER/raspi-docker/qbittorrent unless otherwise changed in the script."
echo "I recommend changing the locations of downloads and the config file location if yours is in an alternate location."
echo " "
echo "To access Portainer, go to the IP of this device in a web-browser, port 9000. Ex: 192.168.1.18:9000"
echo "Goodbye!"
