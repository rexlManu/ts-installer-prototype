#!/usr/bin/env bash
function taskInstallation() {

    message 'installation.libs'
    apt install jq wget -y
    clear
    trans 'installation.folder'

    read -p "$localized_message" path

    if [ -z "$path" ]; then
        path='/opt/teamspeak-server/'
    fi

    if [ ! -d "$path" ]; then
        mkdir "$path"
        message 'installation.folder.created'
    fi

    user="teamspeak-server"
    adduser --disabled-password --no-create-home --gecos "" "$user"
    message 'installation.user.create'

    cd "$path" || exit

    output=$(curl -s https://api.ts-installer.de)
    #version=$(echo "${output}" | jq -c -r '.version')
    download=$(echo "${output}" | jq -c -r '.downloads.amd64')

    message 'installation.download'
    wget "$download" -O "$path/teamspeak.tar.bz2"
    message 'installation.setup'
    tar -jxf teamspeak.tar.bz2
    rm teamspeak.tar.bz2
    mv teamspeak3-server_linux_amd64/* .

    echo 'accepted by ts-installer.de' >ts3server_license_accepted

    chown -R "$user:$user" "$path"
    clear
    su -s /bin/bash -c "$path/ts3server_startscript.sh start license_accepted=1" "$user"
    message 'installation.started'
}
