#!/bin/bash

declare -A DADOS

DADOS[nidforusr1]='' # DADOS GRUPO FOR
DADOS[nidforusr2]=''
DADOS[nidforusr3]=''
DADOS[nidforusr4]=''
DADOS[nidforusr5]=''

DADOS[pwforusr1]=''
DADOS[pwforusr2]=''
DADOS[pwforusr3]=''
DADOS[pwforusr4]=''
DADOS[pwforusr5]=''

DADOS[ipforusr1]=''
DADOS[ipforusr2]=''
DADOS[ipforusr3]=''
DADOS[ipforusr4]=''
DADOS[ipforusr5]=''

DADOS[nidforbkp1]='' # DADOS GRUPO FOR SUBGRUPO BACKUP

DADOS[pwforbkp1]=''

DADOS[ipforbkp1]=''

DADOS[nidcampusr3]='' # DADOS GRUPO CAMP
DADOS[nidcampusr4]=''
DADOS[nidcampusr5]=''
DADOS[nidcampusr6]=''
DADOS[nidcampusr7]=''

DADOS[pwcampusr3]=''
DADOS[pwcampusr4]=''
DADOS[pwcampusr5]=''
DADOS[pwcampusr6]=''
DADOS[pwcampusr7]=''

DADOS[ipcampusr3]=''
DADOS[ipcampusr4]=''
DADOS[ipcampusr5]=''
DADOS[ipcampusr6]=''
DADOS[ipcampusr7]=''

DADOS[nidcampbkp3]='' # DADOS GRUPO CAMP SUBGRUPO BACKUP
DADOS[nidcampbkp1]=''
DADOS[nidcampbkp2]=''

DADOS[pwcampbkp3]=''
DADOS[pwcampbkp1]=''
DADOS[pwcampbkp2]=''

DADOS[ipcampbkp3]=''
DADOS[ipcampbkp1]=''
DADOS[ipcampbkp2]=''

DADOS[nidinfusr2]='' # DADOS GRUPO INF
DADOS[nidinfusr3]=''

DADOS[pwinf2]=''
DADOS[pwinf3]=''

DADOS[ipinf2]=''
DADOS[ipinf3]=''

USER='root'

REG=(
'Campinas'
'Fortaleza'
)

data=`/bin/date +%d-%m-%Y-%H-%M`
LOG=/var/log/acesssos.log

function menuprincipal {
clear
echo '
==============================================
    ____ ____ ____ ____ ____ _  _ _  _ ___  
    |__| |    |___ [__  [__  |__| |  | |__] 
    |  | |___ |___ ___] ___] |  | |__| |__] 
                                            
=============================================='
echo ""
echo "[1] Acesss usernodes." 
echo "[2] Acesss infranodes."
echo "[3] Acesss backupnodes."
echo "[4] New node."
echo "[s] Exit."
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
read -p "Digite a opção desejada: " OP

case ${OP} in
1) menuregiao;;
2) acessarinfranodes;;
3) menuregiao;;
s) exit;;
*)
    clear
    loading
    menuprincipal
;;
esac
}

function menuregiao {
clear
echo 'Regiões disponíveis'
echo '---------------------'
for ((i=0; i<${#REG[@]}; i++));
do
    echo "[$i]${REG[i]}"
done
read -p "Digite a região que deseja acessar (0,1,2,3....), v para voltar:" OPREGUND
case ${OPREGUND} in
0)
    if [[ $OP == 1 ]]
    then
    acessarusernodes
    fi
    if [[ $OP == 3 ]]
    then
    acessarbackupnodes
    fi
;;
1)
    if [[ $OP == 1 ]]
    then
    acessarusernodes
    fi
    if [[ $OP == 3 ]]
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

function acessarinfranodes {
acessarinfranodes=0
while [ "$acessarinfranodes" != 1 ];do
clear
echo "Infrandoes disponíveis."
echo "-----------------------------"
for data in ${!DADOS[@]}
do
    if [[ "$data" == "nidinf"* ]]
    then
        echo ${DADOS[$data]}
    fi
done
echo ''
read -p "Digite o número do infranode que deseja logar (0,1...), v para voltar: " OPLOGINFCAMP
echo '----------------------------------------------------------------------------'
case $OPLOGINFCAMP in
v) menuprincipal;;
*)
for data in ${!DADOS[@]}
do
    if [[ "$data" == "nidinf"$OPLOGINFCAMP ]]
    then
        clear
        echo ...
        echo ACESSANDO
        echo ...
        pwdata=pwinfusr${OPLOGINFCAMP}
        ipdata=ipinfusr${OPLOGINFCAMP}
        sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}"
    fi
done
;;
esac
loading
acessarinfranodes
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

function cadastrar {
    read -p "Digite o nome do node: " nid
}

menuprincipal
