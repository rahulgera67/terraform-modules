#!/bin/bash

sudo apt update -y
sudo apt install git tree -y
echo "ECS_CLUSTER=mycluster" >> /etc/ecs/ecs.config
