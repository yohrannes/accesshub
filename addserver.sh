#!/bin/bash
source ./.sourcedata/.accessdata
source ./.sourcedata/.userdata
source ./.sourcedata/.userpassword
source ./.sourcedata/.hostaddress

function newserver {
while true; do
    # sid = Server name
    # uid = Server user
    # pid = Server password

    sidtotal=0
    uidtotal=0
    pidtotal=0
    hostidtotal=0
    portidtotal=0

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

        if [[ $indexcount == pid* ]]
        then
            pidtotal=$((pidtotal+1))
        fi

        if [[ $indexcount == hostid* ]]
        then
            hostidtotal=$((hostidtotal+1))
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

    for ((i=0; i<=hostidtotal; i++))
    do
        indexhostid="hostid$i"
        if [[ ! ${DATA[$indexhostid]} ]]
        then
            orderhostid=1
            break
        fi
        orderhostid=0
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

    if [[ $orderhostid == 1 ]]
    then
        for ((i=0; i<=hostidtotal+1; i++))
        do
            indexhostid="hostid$i"
            if [[ ! ${DATA[$indexhostid]} ]]
            then
                hostidtotal=$i
                break
            fi
        done
    else
        hostidtotal=$((hostidtotal+1))
    fi

    read -r -p "Name :" sid
    read -r -p "Server User :" uid
    read -r -p "Password :" pid
    read -r -p "Host: " hostid
    read -r -p "Specify port? (if not default 22) [y/n]" port
    case $port in
    y)
        read -r -p "Port: " portid
    ;;
    esac
    read -r -p "Server type-group [infra,app,backup, etc.]: " typeid
    read -r -p "Server region-group [country]: " regionid
    read -r -p "Server sub-region group [state]: " sbregionid

    # Add the id value array on the next disponible index
    DATA["sid$typeid$regionid$sbregionid$sidtotal"]=$sid
    DATA["uid$typeid$regionid$sbregionid$uidtotal"]=$uid
    DATA["pid$typeid$regionid$sbregionid$pidtotal"]=$pid
    DATA["hostid$typeid$regionid$sbregionid$hostidtotal"]=$hostid
    DATA["portid$typeid$regionid$sbregionid$portidtotal"]=$portid
  
    echo "DATA[sid$typeid$regionid$sbregionid$sidtotal]='$sid'" >> ./.sourcedata/.accessdata
    echo "DATA[uid$typeid$regionid$sbregionid$uidtotal]='$uid'" >> ./.sourcedata/.userdata
    echo "DATA[pid$typeid$regionid$sbregionid$pidtotal]='$pid'" >> ./.sourcedata/.userpassword
    echo "DATA[hostid$typeid$regionid$sbregionid$hostidtotal]='$hostid'" >> ./.sourcedata/.hostaddress
    echo "DATA[portid$typeid$regionid$sbregionid$portidtotal]='$portid'" >> ./.sourcedata/.hostports

    read -r -p "Would you like to add more data? [y/n]: " MOREDATA

    if [[ $MOREDATA != [yY] ]]; then
        break
    fi
done
}

newserver
