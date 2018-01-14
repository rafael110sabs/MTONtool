#!/bin/bash

sudo service neo4j stop

# Please, just comment the next line if you don't want delete all files
sudo rm -rf /var/lib/neo4j/data/databases/graph.db/*

sudo service neo4j start
sleep 2 

# Please, change the username and password that you set on neo4j
cypher-shell -u neo4j -p intruso < files/EscolaConducao.cyp