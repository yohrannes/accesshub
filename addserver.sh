#!/bin/bash
source ./.sourcedata/.accessdata
source ./.sourcedata/.userdata
source ./.sourcedata/.userpassword
source ./.sourcedata/.hostaddress

function newserver {
while true; do
    clear
    # sid = Server name
    # uid = Server user
    # pid = Server password
    # hostid = Server ip
    # portid = Server port

    # typeid = Server type (backup, app, balancer, infra)
    # regionid = Server Coutry or other, it depends of your business reach.
    # sbregionid = Server State or other.

    sidtotal=0
    uidtotal=0
    pidtotal=0
    hostidtotal=0
    portidtotal=0

    indexcount=0

    for indexcount in "${!DATA[@]}"
    do
        case $indexcount in
            sid*) ((sidtotal++));;
            uid*) ((uidtotal++));;
            pid*) ((pidtotal++));;
            hostid*) ((hostidtotal++));;
            portid*) ((portidtotal++));;
        esac
    done

    # Find index out of order

    ordersid=0
    orderuid=0
    orderpid=0
    orderhostid=0
    orderportid=0

    for ((i=0; i<=sidtotal; i++)); do
        indexsid="sid$i"
        [[ ! ${DATA[$indexsid]} ]] && ordersid=1 && break
    done

    for ((i=0; i<=uidtotal; i++)); do
        indexuid="uid$i"
        [[ ! ${DATA[$indexuid]} ]] && orderuid=1 && break
    done

    for ((i=0; i<=pidtotal; i++)); do
        indexpid="pid$i"
        [[ ! ${DATA[$indexpid]} ]] && orderpid=1 && break
    done

    for ((i=0; i<=hostidtotal; i++)); do
        indexhostid="hostid$i"
        [[ ! ${DATA[$indexhostid]} ]] && orderhostid=1 && break
    done

    for ((i=0; i<=portidtotal; i++)); do
        indexportid="portid$i"
        [[ ! ${DATA[$indexportid]} ]] && orderportid=1 && break
    done


    # Find the value on the next disponible index

    if [[ $ordersid == 1 ]]; then
    for ((i=0; i<=sidtotal+1; i++)); do
        indexsid="sid$i"
        [[ ! ${DATA[$indexsid]} ]] && sidtotal=$i && break
    done
    else
        sidtotal=$((sidtotal+1))
    fi

    if [[ $orderuid == 1 ]]; then
        for ((i=0; i<=uidtotal+1; i++)); do
            indexuid="uid$i"
            [[ ! ${DATA[$indexuid]} ]] && uidtotal=$i && break
        done
    else
        uidtotal=$((uidtotal+1))
    fi

    if [[ $orderpid == 1 ]]; then
        for ((i=0; i<=pidtotal+1; i++)); do
            indexpid="pid$i"
            [[ ! ${DATA[$indexpid]} ]] && pidtotal=$i && break
        done
    else
        pidtotal=$((pidtotal+1))
    fi

    if [[ $orderhostid == 1 ]]; then
        for ((i=0; i<=hostidtotal+1; i++)); do
            indexhostid="hostid$i"
            [[ ! ${DATA[$indexhostid]} ]] && hostidtotal=$i && break
        done
    else
        hostidtotal=$((hostidtotal+1))
    fi

    if [[ $orderportid == 1 ]]; then
        for ((i=0; i<=portidtotal+1; i++)); do
            indexportid="portid$i"
            [[ ! ${DATA[$indexportid]} ]] && portidtotal=$i && break
        done
    else
        portidtotal=$((portidtotal+1))
    fi

    # Getting access informations

    read -r -p "Full name title :" sid

    read -r -p "Server User :" uid

    read -r -s -p "Password :" pid
    echo

    read -r -p "Host: " hostid

    read -r -p "Specify port? (if not default 22) [y/n]" port
    case $port in
    y)
        read -r -p "Port: " portid
    ;;
    *)
        portid=22
    ;;
    esac

    while true; do
    read -r -p "Server type [infra, app, backup, etc.]: " typeid
    if [[ $typeid =~ [A-Z] || ${#typeid} -gt 8 ]]; then
        echo "Please set max 8 small letters (lowercase)."
    else
        break
    fi
    done

    read -r -p "Specify server region? (country) [y/n]" regop
    case $regop in
    y)
    while true; do
        read -r -p "Server region-group : " regionid
    if [[ $regionid =~ [A-Z] || ${#regionid} -gt 8 ]]; then
        echo "Please set max 8 small letters (lowercase)."
    else
        break
    fi
    done
    ;;
    esac

    read -r -p "Specify server sub-region? (state) [y/n]" subregop
    case $subregop in
    y)
    while true; do
    read -r -p "Server sub-region group : " sbregionid
    if [[ $typeid =~ [A-Z] || ${#typeid} -gt 8 ]]; then
        echo "Please set max 8 small letters (lowercase)."
    else
        break
    fi
    done
    ;;
    esac
    

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