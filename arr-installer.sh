#!/bin/bash

clear

echo "

___  ____ _  _ ____    _ _  _ ____ ___ ____ _    _    ____ ____
  /  |___ |  | [__     | |\ | [__   |  |__| |    |    |___ |__/
 /__ |___ |__| ___]    | | \| ___]  |  |  | |___ |___ |___ |  \

"

#This is a script to help install essentials for docker.


######################################################################

#Functions List

noanswer () { echo "Skipping..." ; }
updatesys () { yes | sudo apt-get update && sudo apt-get upgrade; }

######################################################################

echo "This script assumes you have your docker files located in your /home/$USER/raspi-docker folder."
echo " "
echo "If your folder is located elsewhere, you will need to change the location of your docker-compose files in this script, or clicking f when selecting containers."
echo " "
echo "This script follows my other guide of installing Docker and Mullvad VPN. Visit https://github.com/LordZeuss/raspi-docker for more info."
echo " "
######################################################################

#Update the system
echo " "
echo "Would you like to update your system (Recommended)? (y/n/e)"
echo " "
echo "y=yes | n=no | f=Change-container-volumes-&-location | e=exit-program"
echo " "

read -n1 yesorno
echo " "

if [ "$yesorno" = y ]; then
	updatesys
	echo "Update Successful."
	echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
	echo " "
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
echo " "

if [ "$yesorno" = y ]; then
	echo 'Checking Docker version...'
	docker version
	docker-compose -v
	echo " "
	echo "If no errors occured, Docker should be good to go."
	echo "Docker-Compose build unknown is not an error"
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
sudo mkdir /home/$USER/raspi-docker/downloads
sudo chmod 777 /home/$USER/raspi-docker/downloads

#Install Portainer

echo "Would you like to install Portainer (Required if not already insalled)? (y/n/f/e)"
echo " "
read -n1 yesorno

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
   - PGID=1000
   - TZ=US/Central
  image: portainer/portainer-ce" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
		read -n1 -p "You have selected to change the location/volumes of this container. Would you like to continue? (y/n) " fix
		echo " "
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " answer
			sleep 1
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
   - PGID=1000
   - TZ=US/Central
  image: portainer/portainer-ce" >> $answer
  			echo " " >> $answer
			echo " "
			echo "Done."
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Portainer to any file."
			source arr-installer.sh
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

#Install Sonarr

echo "Would you like to install Sonarr? (y/n/f/e)"
echo " "
read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/downloads/tv
	mkdir /home/$USER/raspi-docker/sonarr
	mkdir /home/$USER/raspi-docker/sonarr/config
	echo "sonarr:
  container_name: sonarr
  restart: unless-stopped
  ports:
   - 8989:8989
  volumes:
   - /home/$USER/raspi-docker/sonarr/config:/config
   - /home/$USER/raspi-docker/downloads:/downloads
   - /home/$USER/raspi-docker/downloads/tv:/tv
  environment:
   - PUID=1000
   - PGID=1000
   - TZ=US/Central
  image: linuxserver/sonarr" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = e ]; then
	echo " "
	echo "Goodbye!"
	exit 1
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " sonarranswer
			read -p "Enter the new location for config: " config
			read -p "Enter the new location of the downloads folder: " downloads
			read -p "Enter the new location of where the TV Content is: " tv
			sleep 1
			echo "sonarr:
  container_name: sonarr
  restart: unless-stopped
  ports:
   - 8989:8989
  volumes:
   - $config:/config
   - $downloads:/downloads
   - $tv:/tv
  environment:
   - PUID=1000
   - PGID=1000
   - TZ=US/Central
  image: linuxserver/sonarr" >> $sonarranswer
  			echo " " >> $sonarranswer

		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Sonarr to any file."
			source arr-installer.sh
			return
		else
			echo " "
			echo "Goodbye!"
			exit 1
		fi
else
	echo " "
	echo "Not a valid answer. Exiting..."
	exit 1
fi

######################################################################

#Install Radarr

echo "Would you like to install Radarr? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/radarr
	mkdir /home/$USER/raspi-docker/downloads/movies
	mkdir /home/$USER/raspi-docker/radarr/config
	echo "radarr:
    image: lscr.io/linuxserver/radarr
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - UMASK=022 #optional
    volumes:
      - /home/$USER/raspi-docker/radarr/config:/config
      - /home/$USER/raspi-docker/downloads/movies:/movies
    ports:
      - 7878:7878
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
    	read -p "Enter the location of the docker-compose.yml file: " radarranswer
			read -p "Enter the new location for config: " rconfig
			read -p "Enter the new location of where the Movie Content is: " movies
			sleep 1
			echo "radarr:
    image: lscr.io/linuxserver/radarr
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
      - UMASK=022 #optional
    volumes:
      - $rconfig:/config
      - $movies:/movies
    ports:
      - 7878:7878
    restart: unless-stopped" >> $radarranswer
  			echo " " >> $radarranswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Radarr to any file."
			source arr-installer.sh
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

######################################################

#Readarr

echo "Would you like to install Readarr? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/readarr
	mkdir /home/$USER/raspi-docker/readarr/config
	mkdir /home/$USER/raspi-docker/downloads/books
	echo "readarr:
    image: lscr.io/linuxserver/readarr:develop
    container_name: readarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/readarr/config:/config
      - /path/to/books:/books #optional
      - /home/$USER/raspi-docker/downloads/books:/downloads #optional
    ports:
      - 8787:8787
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
echo "Don't forget to add the path to your books and or download client!"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
     			echo " "
     			read -p "Enter the location of the docker-compose.yml file: " readarranswer
			read -p "Enter the new location for config: " rrconfig
			read -p "Enter the new location of the downloads folder (Optional):  " rrdownloads
			read -p "Enter the new location of where the Book files are(Optional): " books
			sleep 1
			echo "readarr:
    image: lscr.io/linuxserver/readarr:develop
    container_name: readarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $rrconfig:/config
      - $rrdownloads:/downloads
      - $books:/books
    ports:
      - 8787:8787
    restart: unless-stopped" >> $readarranswer
  			echo " " >> $readarranswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Readarr to any file."
			source arr-installer.sh
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

######################################################

#Bazarr

echo "Would you like to install Bazarr (Subtitles)? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/bazarr
	mkdir /home/$USER/raspi-docker/bazarr/config
	echo "bazarr:
    image: lscr.io/linuxserver/bazarr
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/bazarr/config:/config
      - /home/$USER/raspi-docker/downloads/movies:/movies #optional
      - /home/$USER/raspi-docker/downloads/tv:/tv #optional
    ports:
      - 6767:6767
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
echo "Don't forget to add the path to your movies and tv shows!"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " bazarranswer
			read -p "Enter the new location for config: " brconfig
			read -p "Enter the new location of the Movies Folder (Optional):  " brmovies
			read -p "Enter the new location of the TV Folder (Optional): " brtv
			sleep 1
			echo "bazarr:
    image: lscr.io/linuxserver/bazarr
    container_name: bazarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $brconfig:/config
      - $brmovies:/movies
      - $brtv:/tv
    ports:
      - 6767:6767
    restart: unless-stopped" >> $bazarranswer
  			echo " " >> $bazarranswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Bazarr to any file."
			source arr-installer.sh
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

######################################################

#Overseerr

echo "Would you like to install Overseerr? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/overseerr
	mkdir /home/$USER/raspi-docker/overseerr/config
	echo "overseerr:
    image: sctx/overseerr:latest
    container_name: overseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=US/Central
    ports:
      - 5055:5055
    volumes:
      - /home/$USER/raspi-docker/overseerr/config:/app/config
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
        echo " "
    	read -p "Enter the location of the docker-compose.yml file: " overanswer
			read -p "Enter the new location for config: " overconfig
			sleep 1
			echo "overseerr:
    image: sctx/overseerr:latest
    container_name: overseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=US/Central
    ports:
      - 5055:5055
    volumes:
      - $overconfig:/app/config
    restart: unless-stopped" >> $overanswer
  			echo " " >> $overanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Overseerr to any file."
			source arr-installer.sh
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

######################################################

#Lidarr

echo "Would you like to install Lidarr (Music)? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/lidarr
	mkdir /home/$USER/raspi-docker/downloads/music
	mkdir /home/$USER/raspi-docker/lidarr/config
	echo "lidarr:
    image: lscr.io/linuxserver/lidarr
    container_name: lidarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/lidarr/config:/config
      - /home/$USER/raspi-docker/downloads/music:/music #optional
      - /home/$USER/raspi-docker/downloads:/downloads #optional
    ports:
      - 8686:8686
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " lidarranswer
			echo " "
			read -p "Enter the new location for config: " lidarrconfig
			read -p "Enter the new location of the Music Folder (Optional):  " lrmusic
			read -p "Enter the new location of the Downloads Folder (Optional): " lrdownloads
			sleep 1
			echo "lidarr:
    image: lscr.io/linuxserver/lidarr
    container_name: lidarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $lidarrconfig:/config
      - $lrmusic:/music #optional
      - $lrdownloads:/downloads #optional
    ports:
      - 8686:8686
    restart: unless-stopped" >> $lidarranswer
  			echo " " >> $lidarranswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Lidarr to any file."
			source arr-installer.sh
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

######################################################

#Prowlarr

echo "Would you like install Prowlarr (Required for Sonarr/Radarr)? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/prowlarr
	mkdir /home/$USER/raspi-docker/prowlarr/config
	echo "prowlarr:
    image: lscr.io/linuxserver/prowlarr:develop
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/prowlarr/config:/config
    ports:
      - 9696:9696
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
    if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " prowlarranswer
      read -p "Enter the new location for config: " prowlarrconfig
      sleep 1
      echo "prowlarr:
        image: lscr.io/linuxserver/prowlarr:develop
        container_name: prowlarr
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=US/Central
        volumes:
          - $prowlarrconfig:/config
        ports:
          - 9696:9696
        restart: unless-stopped" >> $prowlarranswer
        echo " " >> $prowlarranswer
        echo " "
	echo "Done."
        echo " "
    elif [ "$fix" = n ]; then
      echo " "
      echo "Not adding Prowlarr to any file."
      source arr-installer
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

#Installing Jackett

echo "Would you like to install Jackett? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/jackett
	echo "jackett:
  container_name: jackett
  restart: unless-stopped
  ports:
   - 9117:9117
  volumes:
   - /home/$USER/raspi-docker/jackett:/config
  environment:
   - PUID=1000
   - PGID=1000
   - TZ=US/Central
  image: linuxserver/jackett" >> /home/$USER/raspi-docker/docker-compose.yml 		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
    echo " "
    read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " jackettanswer
			read -p "Enter the new location for config: " jackett
			sleep 1
			echo "jackett:
  container_name: jackett
  restart: unless-stopped
  ports:
   - 9117:9117
  volumes:
   - $jackett:/config
  environment:
   - PUID=1000
   - PGID=1000
   - TZ=US/Central
  image: linuxserver/jackett" >> $jackettanswer
  			echo " " >> $jackettanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Jackett to any file."
			source arr-installer.sh
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

#############################################################

#Jellyfin

echo "Would you like install Jellyfin Media Server? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/jellyfin
	mkdir /home/$USER/raspi-docker/jellyfin/config
	echo "jellyfin:
    image: lscr.io/linuxserver/jellyfin
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
      - JELLYFIN_PublishedServerUrl=192.168.0.5 #optional
    volumes:
      - /home/$USER/raspi-docker/config:/config
      - /home/$USER/raspi-docker/downloads/tv:/data/tvshows
      - /home/$USER/raspi-docker/downloads/movies:/data/movies
    ports:
      - 8096:8096
      - 8920:8920 #optional
      - 7359:7359/udp #optional
      - 1900:1900/udp #optional
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml 	#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " " >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
	echo " "
	echo "Successfully Added"
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
    if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " jellyanswer
      read -p "Enter the new location for config: " jellyconfig
      read -p "Enter the new location for TV Shows: " jellytv
      read -p "Enter the new location for Movies: " jellymovies
      read -p "Enter the IP of the Server URL (Default is 192.168.0.5): " jellyip
      sleep 1
      echo "jellyfin:
        image: lscr.io/linuxserver/jellyfin
        container_name: jellyfin
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=US/Central
          - JELLYFIN_PublishedServerUrl=$jellyip #optional
        volumes:
          - $jellyconfig:/config
          - $jellytv:/data/tvshows
          - $jellymovies:/data/movies
        ports:
          - 8096:8096
          - 8920:8920 #optional
          - 7359:7359/udp #optional
          - 1900:1900/udp #optional
        restart: unless-stopped" >> $jellyanswer
        echo " " >> $jellyanswer
        echo " "
	echo "Done."
        echo " "
    elif [ "$fix" = n ]; then
      echo " "
      echo "Not adding Jellyfin Media Server to any file."
      source arr-installer.sh
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
#############################################################################################

#Plex

echo "Would you like to install Plex Media Server? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
 mkdir /home/$USER/raspi-docker/plex
 mkdir /home/$USER/raspi-docker/plex/config
 echo " "
 read -p "Enter your Plex Claim Token: " plextoken
  sudo docker run \
-d \
--name plex \
--network=host \
-e TZ="America/Chicago" \
-e PLEX_CLAIM="$plextoken" \
-v /home/$USER/raspi-docker/plex/config:/config \
-v /home/$USER/raspi-docker/downloads/movies:/movies \
-v /home/$USER/raspi-docker/downloads/tv:/tv \
plexinc/pms-docker:plexpass
elif [ "$yesorno" = n ]; then
 echo " "
 echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to use a custom Plex Server Setup. Would you like to continue? (y/n) " fix
   if [ "$fix" = y ]; then
     echo " "
    read -p "Enter your Plex Claim Token: " plextoken2
    read -p "Enter your config location: " plexconfig
    read -P "Enter the location of your Movies: " plexmovies
    read -p "Enter the location of your TV Shows: " plextv
    sudo docker run \
  -d \
  --name plex \
  --network=host \
  -e TZ="America/Chicago" \
  -e PLEX_CLAIM="$plextoken2" \
  -v $plexconfig:/config \
  -v $plexmovies:/movies \
  -v $plextv:/tv \
  plexinc/pms-docker:plexpass
   elif [ "$fix" = n ]; then
     echo " "
     echo "Not adding Plex."
     source arr-installer.sh
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

##############################################################

#Emby

echo "Would you like to install Emby? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/emby
  mkdir /home/$USER/raspi-docker/emby/config
	echo "emby:
    image: lscr.io/linuxserver/emby
    container_name: emby
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/emby/config:/config
      - /home/$USER/raspi-docker/downloads/tv:/data/tvshows
      - /home/$USER/raspi-docker/downloads/movies:/data/movies
      - /opt/vc/lib:/opt/vc/lib #optional
    ports:
      - 8096:8096
      - 8920:8920 #optional
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
    echo " "
  	read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " embyanswer
      read -p "Enter the location of config: " embyconfig
      read -p "Enter the location of your TV Shows: " embytv
      read -p "Enter the location of your Movies: " embymovies
			sleep 1
			echo "emby:
    image: lscr.io/linuxserver/emby
    container_name: emby
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $embyconfig:/config
      - $embytv:/data/tvshows
      - $embymovies:/data/movies
      - /opt/vc/lib:/opt/vc/lib #optional
    ports:
      - 8096:8096
      - 8920:8920 #optional
    restart: unless-stopped" >> $embyanswer
  			echo " " >> $embyanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Emby to any file."
			source arr-installer.sh
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

##############################################################

#Install AdGuard

echo "Would you like to install AdGuard (DNS Adblocker)? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/adguard
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
echo " "
echo "Successfully Added"
echo " "
echo "Add - 67:67/udp -p 68:68/tcp -p 68:68/udp to use AdGuard as DHCP Server."
echo "Find on port 3000. IP:3000"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
    echo " "
  	read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " adguardanswer
			sleep 1
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
    restart: unless-stopped" >> $adguardanswer
  			echo " " >> $adguardanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Adguard Home to any file."
			source arr-installer.sh
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


#Podgrab

echo "Would you like to install Podgrab? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/podgrab
    mkdir /home/$USER/raspi-docker/podgrab/config
    mkdir /home/$USER/raspi-docker/podcasts
	echo "podgrab:
    image: akhilrex/podgrab
    container_name: podgrab
    environment:
      - CHECK_FREQUENCY=240
     # - PASSWORD=password     ## Uncomment to enable basic authentication, username = podgrab
    volumes:
      - /home/$USER/raspi-docker/podgrab/config:/config
      - /home/$USER/raspi-docker/podcasts:/assets
    ports:
      - 8080:8080
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " podgrabanswer
			read -p "Enter the new location for config: " podgrabconfig
            read -p "Enter the location you want the podcasts to be saved to: " podgrabsave
			sleep 1
			echo "podgrab:
    image: akhilrex/podgrab
    container_name: podgrab
    environment:
      - CHECK_FREQUENCY=240
     # - PASSWORD=password     ## Uncomment to enable basic authentication, username = podgrab
    volumes:
      - $podgrabconfig:/config
      - $podgrabsave:/assets
    ports:
      - 8080:8080
    restart: unless-stopped" >> $podgrabanswer
  			echo " " >> $podgrabanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Podgrab to any file."
			source arr-installer.sh
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


#Heimdall

echo "Would you like to install Heimdall? (y/n/f/e)"

read -n1 yesorno

if [ "$yesorno" = y ]; then
	mkdir /home/$USER/raspi-docker/heimdall
	echo "heimdall:
    image: lscr.io/linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - /home/$USER/raspi-docker/heimdall:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped" >> /home/$USER/raspi-docker/docker-compose.yml		#replace /home/$USER/raspi-docker/docker-compose.yml with the location of your docker-compose.yml file
echo " " >>/home/$USER/raspi-docker/docker-compose.yml #replace this location with the location docker-compose.yml if needed.
echo " "
echo "Successfully Added"
echo " "
elif [ "$yesorno" = n ]; then
	echo " "
	echo "Skipping..."
elif [ "$yesorno" = f ]; then
        echo " "
        read -n1 -p "You have selected to change the location/volumes of the container. Would you like to continue? (y/n) " fix
		if [ "$fix" = y ]; then
      echo " "
      read -p "Enter the location of the docker-compose.yml file: " heimdallanswer
			read -p "Enter the new location for config: " heimdallconfig
			sleep 1
			echo "heimdall:
    image: lscr.io/linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=US/Central
    volumes:
      - $heimdallconfig:/config
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped" >> $heimdallanswer
  			echo " " >> $heimdallanswer
  			echo " "
			echo "Done."
			echo " "
		elif [ "$fix" = n ]; then
			echo " "
			echo "Not adding Heimdall to any file."
			source arr-installer.sh
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
echo "Installer Complete. Run torrent-clients-installer.sh if you would like to install a torrent client as well."
echo " "
echo "To access Portainer, go to the IP of this device in a web-browser, port 9000. Ex: 192.168.1.18:9000"
echo "Goodbye!"
