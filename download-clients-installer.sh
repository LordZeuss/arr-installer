#!/bin/bash

clear

echo "
 
___  ____ _  _ ____    _ _  _ ____ ___ ____ _    _    ____ ____ 
  /  |___ |  | [__     | |\ | [__   |  |__| |    |    |___ |__/ 
 /__ |___ |__| ___]    | | \| ___]  |  |  | |___ |___ |___ |  \ 
 
"

#This script will install download clients in docker.

######################################################################

#Functions List

noanswer () { echo "Skipping..." ; }
updatesys () { yes | sudo apt-get update && sudo apt-get upgrade; }

######################################################################

echo "This script assumes you have your docker files located in your /home/$USER/raspi-docker folder."
echo "If your folder is located elsewhere, you will need to change the location of your docker-compose files in this script."
echo "This script follows my other guide of insatlling Docker and Mullvad VPN. Visit https://github.com/LordZeuss/raspi-docker for more info."
echo " "
echo "NOTE: With this script, it will default to downloading in the /home/$USER/Downloads folder."
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
echo "y=yes | n=no | f=Change-container-volumes-&-location | e=exit-program"
read -n1 yesorno

if [ "$yesorno" = y ]; then
	updatesys
	echo "Update Successful."
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Test if Docker is working and installed

echo "Would you like to check if Docker is working(Recommended)? (y/n/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	echo 'Checking Docker version...'
	docker version
	docker-compose -v
	echo " "
	echo "If no errors occured, Docker should be good to go."
	echo "If an error occured, try running the docker-troubleshoot-fix.sh script."
	echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install qBittorrent

echo "Would you like install qBittorrent? (y/n/f/e)"

read -n1 yesorno

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
	echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
          echo " "
          read -n1 -p "You have selected to change the location/volumes of the container. Would you like to coninue? (y/n) " fix
  		if [ "$fix" = y ]; then
        echo " "
        read -p "Enter the location of the docker-compose.yml file: " qbitanswer
  			read -p "Enter the new location for config: " qbitconfig
        read -p "Enter the new location for downloads: " qbitdl
  			sleep 1
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
            - $qbitocnfig:/config
            - $qbitdl:/downloads
          restart: unless-stopped" >> $qbitanswer
    			echo " " >> $qbitanswer
    			echo " "
			echo "Done."
  			echo " "
  		elif [ "$fix" = n ]; then
  			echo " "
			echo "Not adding qBittorrent to any file."
  			source download-client-installer.sh
  			return
  		else
  			echo " "
			echo "Goodbye!"
  			exit 1
  		fi
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi


#Install Transmission

echo "Would you like install Transmission? (y/n/f/e)"

read -n1 yesorno

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
	echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to coninue? (y/n) " fix
    if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " transmissionanswer
      read -p "Enter the new location for config: " transmissionconfig
      read -p "Enter the new location for downloads: " transmissiondl
      sleep 1
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
          - $transmissionconfig:/config
          - $transmissiondl:/downloads
          - ./downloads/TransmissionWatchFolder:/watch
        ports:
          - 9091:9091
          - 51413:51413
          - 51413:51413/udp
        restart: unless-stopped" >> $transmissionanswer
        echo " " >> $transmissionanswer
        echo " "
	echo "Done."
        echo "To add a username and password, edit the docker-config.yml file after adding. Disabled by default."
        echo " "
    elif [ "$fix" = n ]; then
      echo " "
      echo "Not adding Transmission to any file."
      source download-client-installer.sh
      return
    else
     echo " "
     echo "Goodbye!"
      exit 1
    fi
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install Deluge

echo "Would you like install Deluge? (y/n/f/e)"

read -n1 yesorno

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
	echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
          echo " "
          read -n1 -p "You have selected to change the location/volumes of the container. Would you like to coninue? (y/n) " fix
  		if [ "$fix" = y ]; then
        echo " "
        read -p "Enter the location of the docker-compose.yml file: " delugeanswer
  			read -p "Enter the new location for config: " delugeconfig
        read -p "Enter the new location for downloads: " delugedl
  			sleep 1
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
            - $delugeconfig:/config
            - $delugedl:/downloads
          ports:
            - 8112:8112
            - 58846:58846
            - 58946:58946" >> $delugeanswer
    			echo " " >> $delugeanswer
    			echo " "
			echo "Done."
  			echo " "
  		elif [ "$fix" = n ]; then
  			echo " "
			echo "Not adding Deluge to any file."
  			source download-client-installer.sh
  			return
  		else
  			echo " "
			echo "Goodbye!"
  			exit 1
  		fi
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi


######################################################################


#Install nzbget

echo "Would you like install NZBGet? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/nzbget
	mkdir /home/$USER/raspi-docker/nzbget/config
	echo "nzbget:
    image: lscr.io/linuxserver/nzbget:latest
    container_name: nzbget
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
      - NZBGET_USER=admin #optional
      - NZBGET_PASS=admin #optional
    volumes:
      - /home/$USER/raspi-docker/nzbget/config:/config
      - /home/$USER/raspi-docker/downloads:/downloads #optional
    ports:
      - 6789:6789
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " "
	echo "Default username & password is admin"
        echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
          echo " "
          read -n1 -p "You have selected to change the location/volumes of the container. Would you like to coninue? (y/n) " fix
  		if [ "$fix" = y ]; then
        echo " "
        read -p "Enter the location of the docker-compose.yml file: " nzbgetanswer
  		read -p "Enter the new location for config: " nzbgetconfig
        read -p "Enter the new location for downloads: " nzbgetdown
        read -p "Enter the login user-name: " nzbgetlogin
        read -p "Enter the login password: " nzbgetpass
  			sleep 1
  			echo "nzbget:
    image: lscr.io/linuxserver/nzbget:latest
    container_name: nzbget
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
      - NZBGET_USER=$nzbgetlogin #optional
      - NZBGET_PASS=$nzbgetpass #optional
    volumes:
      - $nzbgetconfig:/config
      - $nzbgetdown:/downloads #optional
    ports:
      - 6789:6789
    restart: unless-stopped" >> $nzbgetanswer
    			echo " " >> $nzbgetanswer
    			echo " "
			echo "Done."
  			echo " "
  		elif [ "$fix" = n ]; then
  			echo " "
			echo "Not adding NZBGet to any file."
  			source download-client-installer.sh
  			return
  		else
  			echo " "
			echo "Goodbye!"
  			exit 1
  		fi
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi



#Install sabnzbd

echo "Would you like install SABnzbd? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/sabnzbd
	mkdir /home/$USER/raspi-docker/sabnzbd/config
	echo "sabnzbd:
    image: lscr.io/linuxserver/sabnzbd:latest
    container_name: sabnzbd
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/sabnzbd/config:/config
      - /home/$USER/raspi-docker/downloads:/downloads #optional
    ports:
      - 8080:8080
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
    echo " "
    echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
          echo " "
          read -n1 -p "You have selected to change the location/volumes of the container. Would you like to coninue? (y/n) " fix
  		if [ "$fix" = y ]; then
        echo " "
        read -p "Enter the location of the docker-compose.yml file: " sabanswer
  		read -p "Enter the new location for config: " sabconfig
        read -p "Enter the new location for downloads: " sabdown
  			sleep 1
  			echo "sabnzbd:
    image: lscr.io/linuxserver/sabnzbd:latest
    container_name: sabnzbd
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $sabconfig:/config
      - $sabdown:/downloads #optional
    ports:
      - 8080:8080
    restart: unless-stopped" >> $sabanswer
    			echo " " >> $sabanswer
    			echo " "
			echo "Done."
  			echo " "
  		elif [ "$fix" = n ]; then
  			echo " "
			echo "Not adding SABnzbd to any file."
  			source download-client-installer.sh
  			return
  		else
  			echo " "
			echo "Goodbye!"
  			exit 1
  		fi
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi




echo " "
echo " "
echo " "
echo "Installer Complete."
echo "To access Portainer, go to the IP of this device in a web-browser, port 9000. Ex: 192.168.1.18:9000"
echo " "
echo "Goodbye!"
