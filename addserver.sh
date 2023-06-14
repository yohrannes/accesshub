#!/bin/bash

declare -A DATA

DATA[sid0]='aaaa'
DATA[sid1]='bbbb'
DATA[sid2]='cccc'

function newserver {
# sid = Server Name
# sidcont = Server Name ID counter
# 
sidtotal=0
indexcount=0
for indexcount in "${!DATA[@]}"
do
    if [[ $indexcount == sid* ]]
    then
        echo 'DATA[sid'${sidtotal}']='${DATA[sid$sidtotal]}
        sidtotal=$((sidtotal+1))
    fi
done

read -p "Name: " id

# Add the id value array on desired index
echo $sidtotal
DATA["sid$sidtotal"]=$id

# read -p "Wold like do add more data?" MOREDATA

for indexcount in "${!DATA[@]}"
do
    if [[ $indexcount == sid* ]]
    then
        echo 'DATA[sid'${sidtotal}']='${DATA[sid$sidtotal]}
    fi
done


}
newserver

echo 'sidtotal: '${sidtotal}