#!/usr/bin/env bash

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
