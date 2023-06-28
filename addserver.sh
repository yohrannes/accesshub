#!/bin/bash
. data.sh
function newserver {
while true; do
    # sid = Server Name
    # sidcont = Server Name ID counter
    # 

    sidtotal=0
    indexcount=0

    for indexcount in "${!DATA[@]}"
    do
        if [[ $indexcount == sid* ]]
        then
            sidtotal=$((sidtotal+1))
        fi
    done
    read -r -p "Name: " id

    # Add the id value array on desired index
    DATA["sid$((sidtotal))"]=$id
    echo "DATA[sid"$sidtotal"]='"$id"'" >> data.sh
    
    echo "DATA[sid"$sidtotal"]='"$id"'"
    read -r -p "Would like do add more data? [y - n]" MOREDATA

    # Add the index of the next value
    sidtotal=$((sidtotal+1))

    if [ "$MOREDATA" == y ]; then
        continue
    else
        break
    fi
done
}

newserver
