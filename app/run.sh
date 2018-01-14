#!/bin/bash
# You must change username and password

sudo rm -rf /var/lib/mysql-files/*
java -jar CSVThemAll.jar root ""
sudo mv /var/lib/mysql-files/* files/exports/