#!/bin/bash
source ./.sourcedata/.accessdata
source ./.sourcedata/.userdata
source ./.sourcedata/.userpassword

function newserver {
while true; do
    # sid = Server name
    # uid = Server user
    # pid = Server password

    sidtotal=0
    uidtotal=0
    pidtotal=0

    indexcount=0

    for indexcount in "${!DATA[@]}"
    do
        if [[ $indexcount == sid* ]]
        then
            sidtotal=$((sidtotal+1))
        fi
        if [[ $indexcount == uid* ]]
        then
            uidtotal=$((uidtotal+1))
        fi
        if [[ $indexcount == uid* ]]
        then
            uidtotal=$((pidtotal+1))
        fi
    done

    # Find index out of order

    for ((i=0; i<=sidtotal; i++))
    do
        indexsid="sid$i"
        if [[ ! ${DATA[$indexsid]} ]]
        then
            ordersid=1
            break
        fi
        ordersid=0
    done

    for ((i=0; i<=uidtotal; i++))
    do
        indexuid="uid$i"
        if [[ ! ${DATA[$indexuid]} ]]
        then
            orderuid=1
            break
        fi
        orderuid=0
    done

    for ((i=0; i<=pidtotal; i++))
    do
        indexpid="pid$i"
        if [[ ! ${DATA[$indexpid]} ]]
        then
            orderpid=1
            break
        fi
        orderpid=0
    done

    # Find the value on the next disponible index

    if [[ $ordersid == 1 ]]
    then
        for ((i=0; i<=sidtotal+1; i++))
        do
            indexsid="sid$i"
            if [[ ! ${DATA[$indexsid]} ]]
            then
                sidtotal=$i
                break
            fi
        done
    else
        sidtotal=$((sidtotal+1))
    fi

    if [[ $orderuid == 1 ]]
    then
        for ((i=0; i<=uidtotal+1; i++))
        do
            indexuid="uid$i"
            if [[ ! ${DATA[$indexuid]} ]]
            then
                uidtotal=$i
                break
            fi
        done
    else
        uidtotal=$((uidtotal+1))
    fi

    if [[ $orderpid == 1 ]]
    then
        for ((i=0; i<=pidtotal+1; i++))
        do
            indexpid="pid$i"
            if [[ ! ${DATA[$indexpid]} ]]
            then
                pidtotal=$i
                break
            fi
        done
    else
        pidtotal=$((pidtotal+1))
    fi

    read -r -p "Name :" idsid
    read -r -p "Server User :" iduid
    read -r -p "Password :" idpid
    read -p "Host: " idipid
    read -p "Port: " idpt
    read -p "Server type-group: " idtp
    read -p "Server region-group: " idrg
    read -p "Server sub-region group: " idsbrg

    # Add the id value array on the next disponible index
    DATA["sid$sidtotal"]=$idsid
    DATA["uid$uidtotal"]=$iduid
    DATA["pid$pidtotal"]=$idpid
    echo "DATA[sid$sidtotal]='$idsid'" >> ./.sourcedata/.accessdata
    echo "DATA[uid$uidtotal]='$iduid'" >> ./.sourcedata/.userdata
    echo "DATA[pid$pidtotal]='$idpid'" >> ./.sourcedata/.userpassword

    read -r -p "Would you like to add more data? [y/n]: " MOREDATA

    if [[ $MOREDATA != [yY] ]]; then
        break
    fi
done
}

newserver
