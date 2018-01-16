#!/bin/bash

# Please, just comment the next line if you don't want delete all files
sudo rm -rf /var/lib/mysql-files/*

mkdir files/exports
echo ">Starting the conversion"
# You must change username and password
java -jar CSVThemAll.jar appuser appconnection

echo ">Moving generated files"
sudo mv /var/lib/mysql-files/* files/exports/

echo ">Done exporting csvs. Files can be found at files/exports"
