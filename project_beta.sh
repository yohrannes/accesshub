#!/bin/bash
source .accessdata
source .regiondata
source .userdata

REGIONS=( ## Suposed to be the Country...
'Campinas'
'Fortaleza'
)

SUBREGIONS=( ## Suposed to be the State....
    ''
)

SERVERTYPE=(
    'Server'
    'Backup'
)

echo Script started in "$(date)" >> /var/log/accesshub.log from user "$(whoami)"

function menuprincipal {
clear
echo -e '
==============================================
    ____ ____ ____ \e[32m____ ____ _  _\e[0m _  _ ___  
    |__| |    |___ \e[32m[__  [__  |__|\e[0m |  | |__] 
    |  | |___ |___ \e[32m___] ___] |  |\e[0m |__| |__] 
                                            
=============================================='
echo ""
echo "[1] Access Server User" 
echo "[2] Access Server Backup."
echo "[3] New server."
echo "[s] Exit."
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
read -p "Enter the desired option: " OP

case ${OP} in
1) menuregiao;;
2) menuregiao;;
3) newserver;;
s) exit;;
*)
    clear
    loading
    menuprincipal
;;
esac
}

function newserver {
    clear
    echo "Enter the server access data......"
    echo ''
    read -p "Name: " id
    read -p "User: " user
    read -p "Password: " pw
    read -p "Host: " host
    read -p "Port: " port
    read -p "Server type-group: " type
    read -p "Server region-group: " reggp
    read -p "Server sub-region group: " sbreggp
}

function menuregiao {
clear
echo 'Disponible Regions.'
echo '---------------------'
for ((i=0; i<${#REGIONS[@]}; i++));
do
    echo "[$i]${REGIONS[i]}"
done
read -p "Digite a região que deseja acessar (0,1,2,3....), v para voltar:" OPREGUND
case ${OPREGUND} in
0)
    if [[ $OP == 1 ]]
    then
    acessarusernodes
    fi
    if [[ $OP == 2 ]]
    then
    acessarbackupnodes
    fi
;;
1)
    if [[ $OP == 1 ]]
    then
    acessarusernodes
    fi
    if [[ $OP == 2 ]]
    then
    acessarbackupnodes
    fi
;;
v) menuprincipal;;
*)
clear
echo ''
echo "  Região inválida ou indisponível"
echo ''
sleep 1
loading
menuregiao
esac
}

function acessarusernodes {
acessarusernodes=0
while [ "$acessarusernodes" != 1 ];do
case $OPREGUND in
0)
    clear
    echo "Usernodes disponíveis."
    echo "-----------------------------"
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidcampusr"* ]]
        then
            echo ${DATA[$data]}
        fi
    done
    echo ''
	read -p "Digite o número do usernode que deseja logar (0,1...), v para voltar: " OPLOGUSRCAMP
    echo '----------------------------------------------------------------------------'
    case $OPLOGUSRCAMP in
    v) menuregiao;;
    *)
	clear
	echo ...
	echo ACESSANDO
	echo ...
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidcampusr"$OPLOGUSRCAMP ]]
        then
            pwdata=pwcampusr${OPLOGUSRCAMP}
            ipdata=ipcampusr${OPLOGUSRCAMP}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}" 
            clear
            acessarusernodes
        fi
    done
    ;;
    esac
;;
1)
    clear
    echo "Usernodes disponíveis."
    echo "-----------------------------"
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidforusr"* ]]
        then
            echo ${DATA[$data]}
        fi
    done
    echo ''
	read -p "Digite o número do usernode que deseja logar (0,1...), v para voltar: " OPLOGUSRFOR
    echo '----------------------------------------------------------------------------'
    case $OPLOGUSRFOR in
    v) menuregiao;;
    *)
	clear
	echo ...
	echo ACESSANDO
	echo ...
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidforusr"$OPLOGUSRFOR ]]
        then
            pwdata=pwforusr${OPLOGUSRFOR}
            ipdata=ipforusr${OPLOGUSRFOR}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}"
            clear
            acessarusernodes
        fi
    done
    ;;
    esac
;;
*)
acessarusernodes
loading
;;
esac
done
}

function acessarbackupnodes {
acessarbackupnodes=0
while [ "$acessarbackupnodes" != 1 ];do
case $OPREGUND in
0)
    clear
    echo "Backupnodes disponíveis."
    echo "-----------------------------"
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidcampbkp"* ]]
        then
            echo ${data#sidcampbkp}:${DATA[$data]}
        fi
    done
    echo ''
	read -p "Digite o número do backupnode que deseja logar (1,2...), v para voltar: " OPLOGBKPCAMP
    echo '----------------------------------------------------------------------------'
    case $OPLOGBKPCAMP in
    v) menuregiao;;
    *)
	clear
	echo ...
	echo ACESSANDO
	echo ...
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidcampbkp"$OPLOGBKPCAMP ]]
        then
            pwdata=pwcampbkp${OPLOGBKPCAMP}
            ipdata=ipcampbkp${OPLOGBKPCAMP}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}"
            clear
            acessarbackupnodes
        fi
    done
    ;;
    esac
;;
1)
    clear
    echo "Backupnodes disponíveis."
    echo "-----------------------------"
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidforbkp"* ]]
        then
            echo ${data#sidforbkp}:${DATA[$data]}
        fi
    done
    echo ''
	read -p "Digite o número do backupnode que deseja logar (1,2...), v para voltar: " OPLOGBKPFOR
    echo '----------------------------------------------------------------------------'
    case $OPLOGBKPFOR in
    v) menuregiao;;
    *)
	clear
	echo ...
	echo ACESSANDO
	echo ...
    for data in ${!DATA[@]}
    do
        if [[ "$data" == "sidforbkp"$OPLOGBKPFOR ]]
        then
            pwdata=pwforbkp${OPLOGBKPFOR}
            ipdata=ipforbkp${OPLOGBKPFOR}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}"
            clear
            acessarbackupnodes
        fi
    done
    ;;
    esac
;;
*)
loading
acessarbackupnodes
;;
esac
done
}

function loading {
contload=0
while [ "$contload" -lt 20 ]; do
    for X in '-' '/' '|' '\'; do
        echo ''
        ((contload++))
        echo -en " \b[$X]: "
        sleep 0.1
        clear
    done
done
}

menuprincipal
