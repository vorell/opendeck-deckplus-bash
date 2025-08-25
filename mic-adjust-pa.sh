#!/bin/bash
#
function get_volume () {
    CURVOL=$(pactl -fjson list sources | jq '.[]|select(.properties[]).volume.[].value_percent' | sed 's/[^0-9]//g' | sort -n | head -1)
    CURVOLPER="$CURVOL""%"
    if [[ ($1 == "out") ]]; then
        echo "$CURVOLPER"
    fi
}
SRCSERIALS=$(pactl -fjson list sources | jq '.[].index')
CURMUTE=$(pactl -fjson list sources | jq '.[].mute')
ALLTRUE="true"  # Assume all are true initially
get_volume
if [[ ($1 == "toggle") ]]
    then for i in $SRCSERIALS; do
        pactl set-source-mute "$i" toggle
    done

    for value in $CURMUTE; do
        if [[ $value != "true" ]]; then
            ALLTRUE="false"  # Set to false if any value is not true
            break  # Exit loop early
        fi
    done

    if $ALLTRUE; then
        echo "on"
    else
        echo "off"
    fi
elif [[ ($1 -lt 0) ]]
    then for i in $SRCSERIALS; do
        pactl set-source-volume "$i" "$CURVOLPER"
        pactl set-source-volume "$i" "$1%"
    done
elif [ $(($CURVOL)) -lt 100 ]
    then for i in $SRCSERIALS; do
        pactl set-source-volume "$i" "$CURVOLPER"
        pactl set-source-volume "$i" +"$1%"
    done
fi
get_volume out
