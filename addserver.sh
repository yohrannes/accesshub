#!/bin/bash
source .accessdata
source .regiondata

function newserver {
while true; do
    # sid = Server Name
    # rid = Region Name

    sidtotal=0
    ridtotal=0

    indexcount=0

    for indexcount in "${!DATA[@]}"
    do
        if [[ $indexcount == sid* ]]
        then
            sidtotal=$((sidtotal+1))
        fi
    done

    # Find index out of order
    for ((i=0; i<=sidtotal; i++))
    do
        index="sid$i"
        if [[ ! ${DATA[$index]} ]]
        then
            order_status=1
            break
        fi
        order_status=0
    done

    # Find the value on the next disponible index
    if [[ $order_status == 1 ]]
    then
        for ((i=0; i<=sidtotal+1; i++))
        do
            index="sid$i"
            if [[ ! ${DATA[$index]} ]]
            then
                sidtotal=$i
                break
            fi
        done
    else
        sidtotal=$((sidtotal+1))
    fi

    read -r -p "Name: " id

    # Add the id value array on the next disponible index
    DATA["sid$sidtotal"]=$id
    echo "DATA[sid$sidtotal]='$id'" >> .accessdata

    read -r -p "Would you like to add more data? [y/n]: " MOREDATA

    if [[ $MOREDATA != [yY] ]]; then
        break
    fi
done
}

newserver
