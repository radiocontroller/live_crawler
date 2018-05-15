#!/bin/bash
docker-compose build
docker-compose up -d
docker-compose exec web /etc/init.d/cron start
