#!/bin/bash

# Please, just comment the next line if you don't want delete all files
sudo rm -rf /var/lib/mysql-files/*

# You must change username and password
java -jar CSVThemAll.jar root ""

sudo mv /var/lib/mysql-files/* files/exports/