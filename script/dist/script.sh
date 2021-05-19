#!/usr/bin/env bash

# Languages
languages=('Deutsch' 'English')
language_Deutsch='{"language":"Deutsch","language.selected":"Du hast das Script auf Deutsch gestellt.","slogan":"TS-Installer.de - TeamSpeak Einrichtung einfach gelöst","choose.option":"Bitte wähle eine Option aus:","invalid.option":"Diese Auswahl ist ungültig.","option.installation":"Installation","option.update":"Update","option.remove":"Entfernen","option.quit":"Script schließen","exit":"Danke für das Nutzen des Skripts.","installation.folder":"In welchen Ordner soll die Installation stattfinden? Default: [/opt/teamspeak-server/]","installation.folder.created":"Der Ordner wurde erstellt.","installation.download":"Server Daten werden von TeamSpeak heruntergeladen.","installation.user.create":"TeamSpeak Benutzer wurde angelegt.","installation.setup":"Der Server wird eingerichtet.","installation.started":"Der Server wurde gestartet.","installation.libs":"Es werden zusatz Pakete installiert."}'
language_English='{"language":"English","language.selected":"You have set the script to English."}'

# Libs


echo 'You have the following languages to choose from: '

LANGUAGE="english"
PS3='Please select your language: '
select language in ${languages[@]}; do
    if [[ " ${languages[@]} " =~ " ${language} " ]]; then
        LANGUAGE=$language
        break
    else
        echo "$REPLY is not a valid language."
    fi
done
echo "Language: $LANGUAGE"

function trans() {
    local key=$1
    local json=$"language_$LANGUAGE"
    json=${!json}

    local string_regex='"([^"\]|\\.)*"'
    local number_regex='-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?'
    local value_regex="${string_regex}|${number_regex}|true|false|null"
    local pair_regex="\"${key}\"[[:space:]]*:[[:space:]]*(${value_regex})"

    if [[ ${json} =~ ${pair_regex} ]]; then
        localized_message=$(sed 's/^"\|"$//g' <<<"${BASH_REMATCH[1]}")
    else
        localized_message=$key
    fi
}


Color_Off='\033[0m' # Text Reset
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

localized_message="not set yet"

function sendColoredMessage() {
    trans $2
    local color=$1
    color=${!color}
    printf $color $localized_message
}

function sendCenteredMessage() {
    trans $2
    local color=$1
    color=${!color}

    COLUMNS=$(tput cols)
    title=$localized_message
    printf $color"%*s\n" $(((${#title} + $COLUMNS) / 2)) "$title"
}

function message() {
    sendColoredMessage Color_Off $1
}

function success() {
    sendColoredMessage Green $1
}

function error() {
    sendColoredMessage Red $1
}

function warning() {
    sendColoredMessage Yellow $1
}


# Tasks
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



clear

cat <<"EOF"

 _________   ______        _____                  _          __   __                       __        
|  _   _  |.' ____ \      |_   _|                / |_       [  | [  |                     |  ]       
|_/ | | \_|| (___ \_|______ | |   _ .--.   .--. `| |-',--.   | |  | | .---.  _ .--.   .--.| | .---.  
    | |     _.____`.|______|| |  [ `.-. | ( (`\] | | `'_\ :  | |  | |/ /__\\[ `/'`\]/ /'`\' |/ /__\\ 
   _| |_   | \____) |      _| |_  | | | |  `'.'. | |,// | |, | |  | || \__., | |  _ | \__/  || \__., 
  |_____|   \______.'     |_____|[___||__][\__) )\__/\'-;__/[___][___]'.__.'[___](_) '.__.;__]'.__.' 
                                                                                                 v1.0                 
                                                                                                        
EOF

sendCenteredMessage Color_Off "slogan"

trans 'choose.option'
PS3=$localized_message
options=()
trans 'option.installation'
options[0]=$localized_message
trans 'option.update'
options[1]=$localized_message
trans 'option.remove'
options[2]=$localized_message
trans 'option.quit'
options[3]=$localized_message

select opt in "${options[@]}"; do
    case $REPLY in
    "1")
        taskInstallation
        break
        ;;
    "4")
        break
        ;;
    *)
        trans 'invalid.option'
        echo $localized_message
        ;;
    esac
done

message 'exit'

