#!/bin/bash

declare -A REGIONS
source ./.sourcedata/index/regionid

declare -A SUBREGIONS
source ./.sourcedata/index/sbregionid

declare -A SERVERTYPE
source ./.sourcedata/index/typeid

declare -A DATA

source ./.sourcedata/accessdata
source ./.sourcedata/hostaddress
source ./.sourcedata/hostports
source ./.sourcedata/userdata
source ./.sourcedata/userpassword

function newserver {
while true; do
    clear

    # Variables used for organize the access data
    # DATA[A - A contains sid,uid,pid,hostid,portid

    # sid = Server name
    # uid = Server user
    # pid = Server password
    # hostid = Server ip
    # portid = Server port
    
    # Variables for filter the server type and region

    # DATA[AB - B contains typeid (backup, app, balancer, infra)
    # DATA[ABC - C contains regionid
    # DATA[ABCDN] - D contains sbregionid
    # DATA[ABCDN] - N contains the id number in case of duplicate indexing

    # typeid = Server type
    # regionid = Server region (Coutry or other, it depends of your business reach)
    # sbregionid = Server sub-region (State or other)

    read -r -p "Full name title :" sid

    read -r -p "Server User :" uid

    read -r -p "Password :" pid

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
    if [[ $typeid =~ [A-Z] || ${#typeid} -gt 10 ]]; then
        echo "Please set max 10 small letters (lowercase)."
    else
        break
    fi
    done

    read -r -p "Specify server region? (country) [y/n]" regop
    case $regop in
    y)
    while true; do
        read -r -p "Server region-group : " regionid
    if [[ $regionid =~ [A-Z] || ${#regionid} -gt 10 ]]; then
        echo "Please set max 10 small letters (lowercase)."
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
    if [[ $typeid =~ [A-Z] || ${#typeid} -gt 10 ]]; then
        echo "Please set max 10 small letters (lowercase)."
    else
        break
    fi
    done
    ;;
    esac

    # Add the id value array on the next disponible index

    echo "REGIONS[${#REGIONS[@]}]='$regionid'" >> ./.sourcedata/index/regionid
    REGIONS[${#REGIONS[@]}]=${regionid}

    echo "SUBREGIONS[${#SUBREGIONS[@]}]='$sbregionid'" >> ./.sourcedata/index/sbregionid
    SUBREGIONS[${#SUBREGIONS[@]}]=${sbregionid}

    echo "SERVERTYPE[${#SERVERTYPE[@]}]='$typeid'" >> ./.sourcedata/index/typeid
    SERVERTYPE[${#SERVERTYPE[@]}]=${typeid}

    declare -A dataindex

    sidtotal=0

    for i in ${!DATA[@]}; do ## Transfer data indexing do dataindex array
        dataindex=$i
    done

    if [[ "sid$typeid$regionid$sbregionid$sidtotal" == $dataindex ]]; then
        ((sidtotal++))
    fi

    echo "DATA[sid$typeid$regionid$sbregionid$sidtotal]='$sid'" >> ./.sourcedata/accessdata
    DATA["sid$typeid$regionid$sbregionid$sidtotal"]=$sid

    uidtotal=0
    
    echo "DATA[uid$typeid$regionid$sbregionid$uidtotal]='$uid'" >> ./.sourcedata/userdata
    DATA["uid$typeid$regionid$sbregionid$uidtotal"]=$uid

    pidtotal=0

    echo "DATA[pid$typeid$regionid$sbregionid$pidtotal]='$pid'" >> ./.sourcedata/userpassword
    DATA["pid$typeid$regionid$sbregionid$pidtotal"]=$pid

    hostidtotal=0

    echo "DATA[hostid$typeid$regionid$sbregionid$hostidtotal]='$hostid'" >> ./.sourcedata/hostaddress
    DATA["hostid$typeid$regionid$sbregionid$hostidtotal"]=$hostid

    portidtotal=0

    echo "DATA[portid$typeid$regionid$sbregionid$portidtotal]='$portid'" >> ./.sourcedata/hostports
    DATA["portid$typeid$regionid$sbregionid$portidtotal"]=$portid

    read -r -p "Would you like to add more data? [y/n]: " MOREDATA

    if [[ $MOREDATA != [yY] ]]; then
        break
    fi

    done
}

newserver