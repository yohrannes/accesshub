#!/bin/bash

declare -A DADOS

## VARIABLES FOR TEST
TESTPASSWORD=
TESTHOST=
########################

DADOS[nidcampusr1]='server user camp1' # CAMP
DADOS[nidcampusr2]='server user camp2'
DADOS[nidcampusr3]=''
DADOS[nidcampusr4]=''
DADOS[nidcampusr5]=''
DADOS[pwcampusr1]=$TESTPASSWORD
DADOS[pwcampusr2]=''
DADOS[pwcampusr3]=''
DADOS[pwcampusr4]=''
DADOS[pwcampusr5]=''
DADOS[ipcampusr1]=$TESTHOST
DADOS[ipcampusr2]=''
DADOS[ipcampusr3]=''
DADOS[ipcampusr4]=''
DADOS[ipcampusr5]=''

DADOS[nidcampbkp1]='server user camp backup1' # CAMP SUBGRUPO BACKUP
DADOS[nidcampbkp2]=''
DADOS[nidcampbkp3]=''
DADOS[pwcampbkp1]=$TESTPASSWORD
DADOS[pwcampbkp2]=''
DADOS[pwcampbkp3]=''
DADOS[ipcampbkp1]=$TESTHOST
DADOS[ipcampbkp2]=''
DADOS[ipcampbkp3]=''

DADOS[nidforusr1]='server user for1' # FOR
DADOS[nidforusr2]=''
DADOS[nidforusr3]=''
DADOS[nidforusr4]=''
DADOS[nidforusr5]=''
DADOS[pwforusr1]=$TESTPASSWORD
DADOS[pwforusr2]=''
DADOS[pwforusr3]=''
DADOS[pwforusr4]=''
DADOS[pwforusr5]=''
DADOS[ipforusr1]=$TESTHOST
DADOS[ipforusr2]=''
DADOS[ipforusr3]=''
DADOS[ipforusr4]=''
DADOS[ipforusr5]=''

DADOS[nidforbkp1]='server user for backup1' # FOR SUBGRUPO BACKUP
DADOS[pwforbkp1]=$TESTPASSWORD
DADOS[ipforbkp1]=$TESTHOST

USER='root'

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
echo '
==============================================
    ____ ____ ____ ____ ____ _  _ _  _ ___  
    |__| |    |___ [__  [__  |__| |  | |__] 
    |  | |___ |___ ___] ___] |  | |__| |__] 
                                            
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidcampusr"* ]] ## Deveria ser nidusrcamp nessa ordem
        then
            echo ${DADOS[$data]}
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidcampusr"$OPLOGUSRCAMP ]]
        then
            pwdata=pwcampusr${OPLOGUSRCAMP}
            ipdata=ipcampusr${OPLOGUSRCAMP}
            sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}"
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidforusr"* ]] ## Deveria ser nidusrcamp nessa ordem
        then
            echo ${DADOS[$data]}
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidforusr"$OPLOGUSRFOR ]]
        then
            pwdata=pwforusr${OPLOGUSRFOR}
            ipdata=ipforusr${OPLOGUSRFOR}
            sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}"
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidcampbkp"* ]]
        then
            echo ${data#nidcampbkp}:${DADOS[$data]}
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidcampbkp"$OPLOGBKPCAMP ]]
        then
            pwdata=pwcampbkp${OPLOGBKPCAMP}
            ipdata=ipcampbkp${OPLOGBKPCAMP}
            sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}"
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidforbkp"* ]]
        then
            echo ${data#nidforbkp}:${DADOS[$data]}
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
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nidforbkp"$OPLOGBKPFOR ]]
        then
            pwdata=pwforbkp${OPLOGBKPFOR}
            ipdata=ipforbkp${OPLOGBKPFOR}
            sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}"
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
