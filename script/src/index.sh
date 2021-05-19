#!/usr/bin/env bash

clear
#message 'language.selected'

cat <<"EOF"

 _________   ______        _____                  _          __   __                       __        
|  _   _  |.' ____ \      |_   _|                / |_       [  | [  |                     |  ]       
|_/ | | \_|| (___ \_|______ | |   _ .--.   .--. `| |-',--.   | |  | | .---.  _ .--.   .--.| | .---.  
    | |     _.____`.|______|| |  [ `.-. | ( (`\] | | `'_\ :  | |  | |/ /__\\[ `/'`\]/ /'`\' |/ /__\\ 
   _| |_   | \____) |      _| |_  | | | |  `'.'. | |,// | |, | |  | || \__., | |  _ | \__/  || \__., 
  |_____|   \______.'     |_____|[___||__][\__) )\__/\'-;__/[___][___]'.__.'[___](_) '.__.;__]'.__.' 
                                                                                                 v%version%                 
                                                                                                        
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

# NEEDS: jq wget
