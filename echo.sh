#!/bin/bash
source data.sh

previndex=""
lastsid=0

for indexcount in "${!DATA[@]}"
do
    if [[ $indexcount == sid* ]]
    then
        sid="${indexcount#sid}"  # Extrai apenas o número do sid
        if [[ $sid -ne $lastsid+1 ]]
        then
            echo "Conflito detectado: $previndex"
        fi
        lastsid=$sid
        previndex=$indexcount
    fi
done
