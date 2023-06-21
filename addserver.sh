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

    #Made a way to show DATA[sidtotal] = id

    echo ${DATA[@]}
    echo ${!DATA[@]}

    read -r -p "Would like do add more data? [y - n]" MOREDATA

    if [ "$MOREDATA" == y ]; then
        newserver
    else
        break
    fi
done
}

newserver
