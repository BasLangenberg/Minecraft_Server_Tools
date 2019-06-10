# Minecraft Server Tools
Opinionated way to run a Minecraft Server

## What is this
I've ran a Minecraft server for my wife and kids for some time now. It comes and goes as interest comes and moves away. This repo is an opinionated way to setup a server.

Basically, just a collection of scripts. There are millions of projects like this, this one is mine.

## What is used to set this up
- A 2gb digital ocean droplet using Ubuntu 18.04 LTS
- A non root, sudo enabled user
- Vanilla Minecraft server jar

For a nice checklist to do the initial server setup, (click here)[https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04].

## What is included?
- Service management
- Backup

## How to setup?
Assuming you are using a user called minecraft, with the server being located in /home/minecraft/server

- Git clone this repo
  - git clone git@github.com:BasLangenberg/Minecraft_Server_Tools.git server
- Download the vanilla Minecraft server jar 
  - Find the current version on https://www.minecraft.net/en-us/download/server/
  - Or use a pre release (at the moment I'm running 1.14.3 pre 2)
  - wget https://launcher.mojang.com/v1/objects/64caea4b63611111d775e4558341cb9718a6ff4f/server.jar
  - I like to rename: mv server.jar server_1_14_3_pre2.jar
- Install java and tmux
  - sudo apt install openjdk-8-jdk tmux
- Install the service
  - sudo cp minecraft.service /etc/systemd/system/
  - OPTIONALLY: Change the user in the system file
  - sudo systemctl enable minecraft
  - sudo systemctl start minecraft

Run `tmux a`, check your logs. Your server is no started and stopped by systemd, and will automatically start on boot.
