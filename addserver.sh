#!/bin/bash

declare -A regions
source ./.sourcedata/index/regionid

declare -A subregions
source ./.sourcedata/index/sbregionid

declare -A servertype
source ./.sourcedata/index/typeid

declare -A data
source ./.sourcedata/accessdata
source ./.sourcedata/hostaddress
source ./.sourcedata/hostports
source ./.sourcedata/userdata
source ./.sourcedata/userpassword

function newserver {
while true; do
    clear

    # Variables used for organize the access data
    # data[A - A contains sid,uid,pid,hostid,portid

    # sid = Server name
    # uid = Server user
    # pid = Server password
    # hostid = Server ip
    # portid = Server port
    
    # Variables for filter the server type and region

    # data[AB - B contains typeid (backup, app, balancer, infra)
    # data[ABC - C contains regionid
    # data[ABCDN] - D contains sbregionid
    # data[ABCDN] - N contains the id number in case of duplicate indexing

    # typeid = Server type
    # regionid = Server region (Coutry or other, it depends of your business reach)
    # sbregionid = Server sub-region (State or other)

    read -r -p "Full name title :" sid

    read -r -p "Server User :" uid

    read -r -p "Password :" pid

    read -r -p "Host: " hostid

    read -r -p "Port (default 22): " portid
    if [ -z "$portid" ]; then
        portid=22
    fi

    while true; do
        read -r -p "Server type [infra, app, backup, etc.]: " typeid
        if [[ $typeid =~ [A-Z] || ${#typeid} -gt 10 ]]; then
            echo "Max 10 small letters (lowercase)."
        else
            break
        fi
    done

    while true; do
        read -r -p "Server region : " regionid
        if [[ $regionid =~ [A-Z] || ${#regionid} -gt 10 ]]; then
            echo "Max 10 small letters (lowercase)."
        else
            break
        fi
    done

    while true; do
        read -r -p "Server sub-region group : " sbregionid
        if [[ $typeid =~ [A-Z] || ${#typeid} -gt 10 ]]; then
            echo "Max 10 small letters (lowercase)."
        else
            break
        fi
    done

    # Add the id value array on the next disponible index

    echo "regions[${#regions[@]}]='$regionid'" >> ./.sourcedata/index/regionid
    regions[${#regions[@]}]=${regionid}

    echo "subregions[${#subregions[@]}]='$sbregionid'" >> ./.sourcedata/index/sbregionid
    subregions[${#subregions[@]}]=${sbregionid}

    echo "servertype[${#servertype[@]}]='$typeid'" >> ./.sourcedata/index/typeid
    servertype[${#servertype[@]}]=${typeid}

    sidtotal=0
    uidtotal=0
    pidtotal=0
    hostidtotal=0
    portidtotal=0

    declare -A dataindex=${!data[@]}

    for a in "${!data[@]}"; do # Check duplicate indexes...
        for ((i=0;i<=${#data[@]};i++)); do
            if [[ "sid$typeid$regionid$sbregionid$i" == $a ]]; then
                ((sidtotal++))
            fi
            if [[ "uid$typeid$regionid$sbregionid$i" == $a ]]; then
                ((uidtotal++))
            fi
            if [[ "pid$typeid$regionid$sbregionid$i" == $a ]]; then
                ((pidtotal++))
            fi
            if [[ "hostid$typeid$regionid$sbregionid$i" == $a ]]; then
                ((hostidtotal++))
            fi
            if [[ "portid$typeid$regionid$sbregionid$i" == $a ]]; then
                ((portidtotal++))
            fi
        done
    done

    echo "data[sid$typeid$regionid$sbregionid$sidtotal]='$sid'" >> ./.sourcedata/accessdata
    data["sid$typeid$regionid$sbregionid$sidtotal"]=$sid
    echo "data[uid$typeid$regionid$sbregionid$uidtotal]='$uid'" >> ./.sourcedata/userdata
    data["uid$typeid$regionid$sbregionid$uidtotal"]=$uid
    echo "data[pid$typeid$regionid$sbregionid$pidtotal]='$pid'" >> ./.sourcedata/userpassword
    data["pid$typeid$regionid$sbregionid$pidtotal"]=$pid
    echo "data[hostid$typeid$regionid$sbregionid$hostidtotal]='$hostid'" >> ./.sourcedata/hostaddress
    data["hostid$typeid$regionid$sbregionid$hostidtotal"]=$hostid
    echo "data[portid$typeid$regionid$sbregionid$portidtotal]='$portid'" >> ./.sourcedata/hostports
    data["portid$typeid$regionid$sbregionid$portidtotal"]=$portid
    
    read -r -p "Would you like to add more data? [y/n]: " moredata

    if [[ $moredata != [yY] ]]; then
        break
    fi

    done
}
newserver

