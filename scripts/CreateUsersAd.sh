#!/bin/bash

sudo sh -c  'groupadd deployG &>> /var/log/deploy_user_creation.log'

for USER in Devo Testo Prodo
do
    if ! id "$USER" &> /dev/null; then

	sudo sh -c "useradd \"$USER\" -b /opt/deploy_users/ -s /bin/rbash -G deployG -p '*' &>> /var/log/deploy_user_creation.log"
        echo "[$(date '+%F %T')] User $USER was created" | sudo tee -a /var/log/deploy_user_creation.log > /dev/null

    else
        echo "[$(date '+%F %T')] User $USER already exists" | sudo tee -a /var/log/deploy_user_creation.log > /dev/null
    fi
done

