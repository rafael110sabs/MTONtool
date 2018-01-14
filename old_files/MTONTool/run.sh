#!/bin/bash

cd CSVThemAll
mv /var/lib/mysql-files/* .
java -jar CSVThemAll.jar
mkdir exports
mv /var/lib/mysql-files/* ./exports
cd ..
