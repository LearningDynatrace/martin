#!/bin/bash

cd /opt; git clone https://github.com/RousselTM/easytrade
cd easytrade; docker-compose up -d

cd /opt; git clone https://github.com/RousselTM/easyTravel-Docker.git
cd easyTravel-Docker; docker-compose up -d