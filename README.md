# arr-installer
This script installs several "Arr" programs. Such as sonarr, radarr, etc.

# General Info
This project is to assist in setting up programs such as sonarr, radarr, and other "arr" type programs.
Its a basic bash script that will isntall these into the docker-compose.yml file for you.
Feel free to contact me to add more programs to the list!

This project is scripted to install in the directory of my docker setup repo, however you will need to change the location of your docker-compose.yml in the script if you are using a different location.

To install Docker and Mullvad VPN, check out my other repo, which this one coordinates with.

```
https://github.com/LordZeuss/raspi-docker
```

## Table of Contents
* [General Info](#general-info)
* [Programs Included](#programs-included)
* [Pre-Requirements](#pre-requirements)
* [Installation](#installation)
* [Execution](#execution)
* [Modification](#modification)
* [Running the Containers](#running-the-containers)
* [Conclusion](#conclusion)
* [Donations](#donations)

# Disclaimer
I am not responsible for how you use these programs, I just wanted to write a script to see if it was possible to do so. Do not download any illegal content.

# Programs Included
* Sonarr  -for TV shows
* Radarr  -for Movies
* Jackett -indexing for Sonarr/Radarr
* Portainer -interface to manage containers (This is an essential)
* Qbittorrent -torrent program

# Pre-Requirements
You need to have docker and docker-compose installed. 
I recommend you use my other repo to install docker and docker-compose, since this script defaults to the paths/location of that script.

# Installation
To install and run the scripts, first you must install git and clone the repo.

NOTE: you only need to install git if you haven't before, but since you have docker installed, you can probably skip that step.

```
$ sudo apt-get install git
$ git clone https://github.com/LordZeuss/arr-installer
```
Then, navigate to the folder where the scripts are downloaded.

```
$ cd arr-installer
```

Allowing the scripts to run:

Copy and paste the following commands into the terminal

```
$ sed -i -e 's/\r$//' arr-installer.sh
$ sed -i -e 's/\r$//' qbittorrent.sh
```
The purpose of the above commands is to fix the /bin/bash^m: bad interpreter: no such file or directory error

Now to make the scripts executeable

```
$ chmod +x arr-installer
$ chmod +x qbittorrent.sh
```

# Execution
To run the scripts, run these commands:

```
$ ./arr-installer.sh
$ ./qbittorrent.sh
```

# Modification
If you need to edit the script, you can do so by running the commands

```
$ nano arr-installer.sh
$ nano qbittorrent.sh
```

Things you may want to change:
* Timezone
* Location/Paths of Docker files

Inside of the script, navigate to the section for the container you want to edit. They are listed by name. Ex: #Jackett install

Find the line that you want to edit. For example, you may want to change US/Eastern to US/Central.
Example of change:
```
-TZ=US/Eastern
```
Changed:
```
-TZ=US/Central
```

To change locations of your docker files:
Under where it lists the image (will be the last line of the docker-compose file, it then by default, it directs it to /home/$USER/raspi-docker/docker-compose.yml

Example: 
```
image: linuxserver/sonarr" >> /home/$USER/raspi-docker/docker-compose.yml
 ```
 To change the location, you'll want to change the second part.
 Changed to a diffent path:
 ```
 image: linuxserver/sonarr" >> /home/$USER/docker/docker-compose.yml
```

What is $USER? 
* This is just a variable that stands for the name of the user profile. You can change this to the username of the account, but I recommend you use $USER so it automatically uses the correct name.

Example: Your username is Bob. /home/Bob/docker is the same as /home/$USER/docker. $USER just represents the username.

You can usually change these settings inside of portainer as well. There is also many videos about docker-compose if you need to edit more or if you need more help.

# Running the Containers
How do you access portainer to see your containers?
Run the command 
```
$ hostname -I
```
This will show you your system IP (local IP)

You can then open a web-browser, type in the IP with port 9000 and hit enter
* Example: 192.168.1.10:9000
```
IP:9000 click enter
```

Navigate to the folder where your docker-compose.yml file is located
* Default is /home/$USER/raspi-docker

To install the containers you have added to Docker run the command
```
$ docker-compose up -d
```
For whatever reason, if you want to turn off/recreate the docker containers run the command
```
$ docker-compose down
```

# Conclusion
I hope you find this script useful! Once again, this script is designed to be ran after running my docker setup that is in my other repo. You can modify the script to your needs and run it, but using my docker setup may just be less of a hassle. I hope this works for you!

Link to my Docker/Mullvad Install Script Repo:
```
https://github.com/LordZeuss/raspi-docker
```
  
# Donations
Feel free to use these scripts as much as you want, edit it as much as you need to, fork them into your own projects, have fun with it! That's the purpose for open source!

You ABSOLUTELY do NOT need to donate. I'm just a university student trying to learn how to code and make programs. If you decide to donate and support me and this project, thank you! I appreciate your support!

If you are feeling kind enough to donate to me here is my bitcoin address. 

```
bc1q4srmsq9mhkswerxw7vz68fpnvzs34wrutx9fdm
```





















