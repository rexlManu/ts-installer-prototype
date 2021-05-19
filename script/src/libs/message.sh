#!/usr/bin/env bash

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
