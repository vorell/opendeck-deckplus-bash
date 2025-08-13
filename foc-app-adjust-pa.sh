#!/bin/bash
#
function get_volume () {
    CURVOL=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.id"] == '"$CURAPP"').volume."front-left".value_percent' | sed 's/[^0-9]//g' | head -1)
    CURVOLPER="$CURVOL""%"
    if [[ ($1 == "out") ]]; then
        echo "$CURVOLPER"
    fi
}
CURAPP='"'$(xdotool getwindowpid "$(xdotool getwindowfocus)")'"'
PSERIAL=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.id"] == '"$CURAPP"').index')
CURMUTE=$(pactl -fjson list sink-inputs | jq '.[]|select(.properties["application.process.id"] == '"$CURAPP"').mute' | head -1)
get_volume
if [ "$1" == "toggle" ]
    then pactl set-sink-input-mute "$PSERIAL" toggle
    if [ "$CURMUTE" == "true" ]; then echo "on"
    else echo "off"
    fi
elif [ "$1" -lt 0 ]
    then pactl set-sink-input-volume "$PSERIAL" "$1%"
elif [ $(($CURVOL)) -lt 100 ]
    then pactl set-sink-input-volume "$PSERIAL" +"$1%"
fi
get_volume out
echo "$CURAPP"
