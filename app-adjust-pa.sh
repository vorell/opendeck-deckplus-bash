#!/bin/bash
# Pass the application.process.binary name of your discord client as the second parameter.
# get it by running "pactl list sink-inputs" and looking for your discord client.
APPNAME='"'$2'"'
PSERIAL=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.binary"] == '$APPNAME').index')
CURMUTE=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.binary"] == '$APPNAME').mute' | head -1)
function get_volume () {
    CURVOL=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.binary"] == '$APPNAME').volume."front-left".value_percent' | sed 's/[^0-9]//g' | head -1)
    CURVOLPER="$CURVOL""%"
    if [[ ($1 == "out") ]]; then
        echo "$CURVOLPER"
    fi
}
get_volume
if [[ ($1 == "toggle") ]]
    then for i in $PSERIAL; do
        pactl set-sink-input-mute $i toggle
    done
    if [ $CURMUTE == "true" ]; then echo "on"
    else echo "off"
    fi
elif [[ ($1 != "toggle") && ($1 -lt 0)]]
    then for i in $PSERIAL; do
        pactl set-sink-input-volume "$i" "$1%"
    done
elif [ $(($CURVOL)) -lt 100 ]
    then for i in $PSERIAL; do
        pactl set-sink-input-volume "$i" +"$1%"
    done
fi
get_volume out
