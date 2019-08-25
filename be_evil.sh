#!/bin/bash

networkmask=255.255.255.0
networkgw=192.168.0.1

function manualsetup {

    atheros_connected=$(lsusb | grep -i 'Atheros Communications AR9271')
    if [[ "$?" == 0 ]]; then
        
        ipinstalled=$(which ip)
        if [[ "$?" == 0 ]]; then
            interfaces=($(ip link show | grep -v link | awk {'print $2'} | sed s/://g | grep -v lo))
            printf "Select Rogue AP Attack Interface\n"
            for i in "${!interfaces[@]}"
            do
                echo "$i ${interfaces[$i]}";
            done

            read -r -p "> " response
            if ([ "$response" -eq "$response" ] 2>/dev/null) && ([ "$response" -le "$((${#interfaces[@]}-1))" ]);  then
                selectedinterface=(${interfaces[response]})
                echo $selectedinterface
            else
                echo "Nope"
            fi

            eval 'airmon-ng start $selectedinterface'
        fi
    fi
}

manualsetup