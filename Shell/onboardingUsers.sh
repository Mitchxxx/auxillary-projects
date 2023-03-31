#!/bin/bash

CSV_FILE=/home/ubuntu/Shell/names.csv

GROUP_NAME="developers"

AUTHORIZED_KEYS_FILE="authorized_keys"

CURRENT_USER_PUBLIC_KEY=$(cat /home/ubuntu/.ssh/id_rsa.pub)

while IFS=',' read -r name _; do

    sudo useradd -m "$name"


    sudo usermod -a -G "$GROUP_NAME" "$name"

    if [ ! -d "/home/$name/.ssh" ];
    then
        mkdir "/home/$name/.ssh"
        chmod 700 "/home/$name/.ssh"
        touch "/home/$name/.ssh/$AUTHORIZED_KEYS_FILE"
        chmod 600 "/home/$name/.ssh/$AUTHORIZED_KEYS_FILE"
        chown -R $name:$name "/home/$name/.ssh"
    fi

    echo "$CURRENT_USER_PUBLIC_KEY" >> "/home/$name/.ssh/$AUTHORIZED_KEYS_FILE"
    chmod 600 "/home/$name/.ssh/$AUTHORIZED_KEYS_FILE"

    echo "User $name created and added to $GROUP_NAME."
done < "$CSV_FILE"
