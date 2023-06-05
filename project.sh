#!/bin/bash

declare -A DADOS

DADOS[nidforusr1]=''
DADOS[nidforusr2]=''
DADOS[nidforusr3]=''
DADOS[nidforusr4]=''
DADOS[nidforusr5]='' 
DADOS[nidforbkp1]=''
DADOS[pwforusr1]=''
DADOS[pwforusr2]=''
DADOS[pwforusr3]=''
DADOS[pwforusr4]=''
DADOS[pwforusr5]=''
DADOS[pwforbkp1]=''
DADOS[ipforusr1]=''
DADOS[ipforusr2]=''
DADOS[ipforusr3]=''
DADOS[ipforusr4]=''
DADOS[ipforusr5]=''
DADOS[ipforbkp1]=''
DADOS[nidcampusr3]=''
DADOS[nidcampusr4]=''
DADOS[nidcampusr5]=''
DADOS[nidcampusr6]=''
DADOS[nidcampusr7]=''
DADOS[nidcampusr8]=''
DADOS[nidcampusr9]=''
DADOS[nidcampusr10]=''
DADOS[nidcampusr11]=''
DADOS[nidcampusr12]=''
DADOS[nidcampusr13]=''
DADOS[nidcampusr14]=''
DADOS[nidcampusr15]=''
DADOS[nidcampusr16]=''
DADOS[nidcampusr17]=''
DADOS[nidcampusr18]=''
DADOS[nidcampusr19]=''
DADOS[nidcampusr20]=''
DADOS[nidcampusr21]=''
DADOS[nidcampusr22]=''
DADOS[nidcampusr23]=''
DADOS[nidcampusr24]=''
DADOS[nidcampusr25]=''
DADOS[nidcampusr26]=''
DADOS[nidcampusr27]=''
DADOS[nidcampusr28]=''
DADOS[nidcampusr29]=''
DADOS[nidcampusr30]=''
DADOS[nidcampusr31]=''
DADOS[nidcampusr32]=''
DADOS[nidcampusr33]=''
DADOS[nidcampusr34]=''
DADOS[nidcampusr35]=''
DADOS[nidcampusr36]=''
DADOS[nidcampusr37]=''
DADOS[nidcampusr38]=''
DADOS[nidcampusr39]=''
DADOS[nidcampusr40]=''
DADOS[nidinfusr2]=''
DADOS[nidinfusr3]=''
DADOS[nidcampbkp3]=''
DADOS[nidcampbkp1]=''
DADOS[nidcampbkp2]=''
DADOS[pwcampusr3]=''
DADOS[pwcampusr4]=''
DADOS[pwcampusr5]=''
DADOS[pwcampusr6]=''
DADOS[pwcampusr7]=''
DADOS[pwcampusr8]=''
DADOS[pwcampusr9]=''
DADOS[pwcampusr10]=''
DADOS[pwcampusr11]=''
DADOS[pwcampusr12]=''
DADOS[pwcampusr13]=''
DADOS[pwcampusr14]=''
DADOS[pwcampusr15]=''
DADOS[pwcampusr16]=''
DADOS[pwcampusr17]=''
DADOS[pwcampusr18]=''
DADOS[pwcampusr19]=''
DADOS[pwcampusr20]=''
DADOS[pwcampusr21]=''
DADOS[pwcampusr22]=''
DADOS[pwcampusr23]=''
DADOS[pwcampusr24]=''
DADOS[pwcampusr25]=''
DADOS[pwcampusr26]=''
DADOS[pwcampusr27]=''
DADOS[pwcampusr28]=''
DADOS[pwcampusr29]=''
DADOS[pwcampusr30]=''
DADOS[pwcampusr31]=''
DADOS[pwcampusr32]=''
DADOS[pwcampusr33]=''
DADOS[pwcampusr34]=''
DADOS[pwcampusr35]=''
DADOS[pwcampusr36]=''
DADOS[pwcampusr37]=''
DADOS[pwcampusr38]=''
DADOS[pwcampusr39]=''
DADOS[pwcampusr40]=''
DADOS[pwinf2]=''
DADOS[pwinf3]=''
DADOS[pwcampbkp3]=''
DADOS[pwcampbkp1]=''
DADOS[pwcampbkp2]=''
DADOS[ipcampusr3]=''
DADOS[ipcampusr4]=''
DADOS[ipcampusr5]=''
DADOS[ipcampusr6]=''
DADOS[ipcampusr7]=''
DADOS[ipcampusr8]=''
DADOS[ipcampusr9]=''
DADOS[ipcampusr10]=''
DADOS[ipcampusr11]=''
DADOS[ipcampusr12]=''
DADOS[ipcampusr13]=''
DADOS[ipcampusr14]=''
DADOS[ipcampusr15]=''
DADOS[ipcampusr16]=''
DADOS[ipcampusr17]=''
DADOS[ipcampusr18]=''
DADOS[ipcampusr19]=''
DADOS[ipcampusr20]=''
DADOS[ipcampusr21]=''
DADOS[ipcampusr22]=''
DADOS[ipcampusr23]=''
DADOS[ipcampusr24]=''
DADOS[ipcampusr25]=''
DADOS[ipcampusr26]=''
DADOS[ipcampusr27]=''
DADOS[ipcampusr28]=''
DADOS[ipcampusr29]=''
DADOS[ipcampusr30]=''
DADOS[ipcampusr31]=''
DADOS[ipcampusr32]=''
DADOS[ipcampusr33]=''
DADOS[ipcampusr34]=''
DADOS[ipcampusr35]=''
DADOS[ipcampusr36]=''
DADOS[ipcampusr37]=''
DADOS[ipcampusr38]=''
DADOS[ipcampusr39]=''
DADOS[ipcampusr40]=''
DADOS[ipinf2]=''
DADOS[ipinf3]=''
DADOS[ipcampbkp3]=''
DADOS[ipcampbkp1]=''
DADOS[ipcampbkp2]=''
DADOS[servhosp1]=''
DADOS[servhosp2]=''
DADOS[servhosp3]=''
DADOS[servhosp4]=''
DADOS[servhosp5]=''
DADOS[servhosp6]=''
DADOS[servhosp7]=''
DADOS[servhosp8]=''
DADOS[servhosp9]=''
DADOS[servhosp10]=''
DADOS[servhosp11]=''
DADOS[servhosp12]=''
DADOS[servhosp13]=''
DADOS[servhosp14]=''
DADOS[servhosp15]=''
DADOS[servhosp16]=''
DADOS[servhosp17]=''
DADOS[servhosp18]=''
DADOS[servhosp19]=''
DADOS[servhosp20]=''
DADOS[servhosp21]=''
DADOS[servhosp22]=''
DADOS[servhosp23]=''
DADOS[servhosp24]=''
DADOS[servhosp25]=''
DADOS[servhosp26]=''
DADOS[servhosp27]=''
DADOS[pwsrhosp1]=''
DADOS[pwsrhosp2]=''
DADOS[pwsrhosp3]=''
DADOS[pwsrhosp4]=''
DADOS[pwsrhosp5]=''
DADOS[pwsrhosp6]=''
DADOS[pwsrhosp7]=''
DADOS[pwsrhosp8]=''
DADOS[pwsrhosp9]=''
DADOS[pwsrhosp10]=''
DADOS[pwsrhosp11]=''
DADOS[pwsrhosp12]=''
DADOS[pwsrhosp13]=''
DADOS[pwsrhosp14]=''
DADOS[pwsrhosp15]=''
DADOS[pwsrhosp16]=''
DADOS[pwsrhosp17]=''
DADOS[pwsrhosp18]=''
DADOS[pwsrhosp19]=''
DADOS[pwsrhosp20]=''
DADOS[pwsrhosp21]=''
DADOS[pwsrhosp22]=''
DADOS[pwsrhosp23]=''
DADOS[pwsrhosp24]=''
DADOS[pwsrhosp25]=''
DADOS[pwsrhosp26]=''
DADOS[pwsrhosp27]=''
DADOS[nmsrvrhosp1]=''
DADOS[nmsrvrhosp2]=''
DADOS[nmsrvrhosp3]=''
DADOS[nmsrvrhosp4]=''
DADOS[nmsrvrhosp5]=''
DADOS[nmsrvrhosp6]=''
DADOS[nmsrvrhosp7]=''
DADOS[nmsrvrhosp8]=''
DADOS[nmsrvrhosp9]=''
DADOS[nmsrvrhosp10]=''
DADOS[nmsrvrhosp11]=''
DADOS[nmsrvrhosp12]=''
DADOS[nmsrvrhosp13]=''
DADOS[nmsrvrhosp14]=''
DADOS[nmsrvrhosp15]=''
DADOS[nmsrvrhosp16]=''
DADOS[nmsrvrhosp17]=''
DADOS[nmsrvrhosp18]=''
DADOS[nmsrvrhosp19]=''
DADOS[nmsrvrhosp20]=''
DADOS[nmsrvrhosp21]=''
DADOS[nmsrvrhosp22]=''
DADOS[nmsrvrhosp23]=''
DADOS[nmsrvrhosp24]=''
DADOS[nmsrvrhosp25]=''
DADOS[nmsrvrhosp26]=''
DADOS[nmsrvrhosp27]=''

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
===============
'
echo "[1] Acessar usernodes." 
echo "[2] Acessar infranodes."
echo "[3] Acessar backupnodes."
echo "[4] Acessar servidores de hospedagem."
echo "[s] Sair."
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
4) acessarhospedagens;;
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


#servhosp
#pwsrhosp
#nmsrvrhosp

function acessarhospedagens {
acessarhospedagens=0
while [ "$acessarhospedagens" != 1 ];do
    clear
    echo "Servidores de hospedagem disponíveis."
    echo "-----------------------------"
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nmsrvrhosp"* ]]
        then
            echo ${data#nmsrvrhosp}:${DADOS[$data]}
        fi
    done
    echo ''
	read -p "Digite o número do Servidor de hospedagem que deseja logar (1,2...), v para voltar: " OPLOGSERVHOSP
    echo '----------------------------------------------------------------------------'
    case $OPLOGSERVHOSP in
    v) menuprincipal;;
    *)
	clear
	echo ...
	echo ACESSANDO
	echo ...
    for data in ${!DADOS[@]}
    do
        if [[ "$data" == "nmsrvrhosp"$OPLOGSERVHOSP ]]
        then
            pwdata=pwsrhosp${OPLOGSERVHOSP}
            ipdata=servhosp${OPLOGSERVHOSP}
            sshpass -p "${DADOS[$pwdata]}" ssh "$USER"@"${DADOS[$ipdata]}" -p 7580
            clear
            acessarhospedagens
        fi
    done
    esac
loading
acessarhospedagens
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
