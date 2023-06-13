#!/bin/bash

declare -A DATA

DATA[sid1]='aaaa'
DATA[sid2]='bbbb'
DATA[sid3]='cccc'

function newserver {
    clear
    
    # sid = Server Name
    # sidcont = Server Name ID counter
    # 
    sidtotal=0
    for indexcount in "${!DATA[@]}"
    do
        if [[ $indexcount == sid* ]]
        then
            sidtotal=$((sidtotal+1))
        fi
    done

    # Adiciona o valor no array com a indexação desejada
    for ((sidcounter=0; sidcounter<=sidtotal; sidcounter++))
    do
        read -p "Name: " id
        DATA["sid$sidcounter"]=$id
        echo "DATA[@]='$sidcounter'"
    done
    read -p "Wold like do add more data?" MOREDATA
}
newserver

echo 'sidtotal: '${sidtotal}