#!/bin/bash
#reg = server region
#nid = server id
#pw = password
#ip =  ipaddress
declare -A DATA

DATA[nidreg1usr1]=''
DATA[nidreg1usr2]=''
DATA[nidreg1usr3]=''
DATA[nidreg1usr4]=''
DATA[nidreg1usr5]=''
DATA[nidreg2usr1]=''
DATA[nidreg2usr2]=''
DATA[nidreg2usr3]=''
DATA[nidreg2usr4]=''
DATA[nidreg2usr5]=''

DATA[pwreg1usr1]=''
DATA[pwreg1usr2]=''
DATA[pwreg1usr3]=''
DATA[pwreg1usr4]=''
DATA[pwreg1usr5]=''
DATA[pwreg2usr1]=''
DATA[pwreg2usr2]=''
DATA[pwreg2usr3]=''
DATA[pwreg2usr4]=''
DATA[pwreg2usr5]=''

DATA[ipreg1usr1]=''
DATA[ipreg1usr2]=''
DATA[ipreg1usr3]=''
DATA[ipreg1usr4]=''
DATA[ipreg1usr5]=''
DATA[ipreg2usr1]=''
DATA[ipreg2usr2]=''
DATA[ipreg2usr3]=''
DATA[ipreg2usr4]=''
DATA[ipreg2usr5]=''

USER='root'

REG=(
'New York'
'Tokio'
)

function startmenu {
clear
echo "[1] Access nodes."
echo "[s] Exit."
echo ''
echo ''
echo ''
echo ''
echo ''
read -p "Tap the option: " OP

case ${OP} in
1) regionmenu;;
s) exit;;
*)
    clear
    loading
    startmenu
;;
esac
}

function regionmenu {
clear
echo 'Available Regions'
echo '---------------------'
reg2 ((i=0; i<${#REG[@]}; i++));
do
    echo "[$i]${REG[i]}"
done
echo ""
read -p "Enter the region you want to access (0,1,2,3....), v to go back: " OPREGUND
case ${OPREGUND} in
1)
    if [[ $OP == 1 ]]
    then
    accessservers
    fi
;;
v) startmenu;;
*)
clear
echo ''
echo "  Invalid or unavailable region"
echo ''
sleep 1
loading
regionmenu
esac
}

function accessservers {
accessservers=0
while [ "$accessservers" != 1 ];do
case $OPREGUND in
0)
    echo ''
        read -p "Enter the region you want to access (0,1,2,3....), v to go back: " OPLOGUSRNY
    echo '----------------------------------------------------------------------------'
    case $OPLOGUSRNY in
    v) regionmenu;;
    *)
        clear
        echo ...
        echo ACCESSING
        echo ...
    reg2 data in ${!DATA[@]}
    do
        if [[ "$data" == "nidreg1usr"$OPLOGUSRNY ]]
        then
            pwdata=pwreg1usr${OPLOGUSRNY}
            ipdata=ipreg1usr${OPLOGUSRNY}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}"
            clear
            accessservers
        fi
    done
    ;;
    esac
;;
1)
    echo ''
        read -p "Enter the region you want to access (0,1,2,3....), v to go back: " OPLOGUSRTK
    echo '----------------------------------------------------------------------------'
    case $OPLOGUSRTK in
    v) regionmenu;;
    *)
        clear
        echo ...
        echo ACCESSING
        echo ...
    reg2 data in ${!DATA[@]}
    do
        if [[ "$data" == "nidreg2usr"$OPLOGUSRTK ]]
        then
            pwdata=pwreg2usr${OPLOGUSRTK}
            ipdata=ipreg2usr${OPLOGUSRTK}
            sshpass -p "${DATA[$pwdata]}" ssh "$USER"@"${DATA[$ipdata]}"
            clear
            accessservers
        fi
    done
    ;;
    esac
;;
*)
accessservers
loading
;;
esac
done
}

function loading {
contload=0
while [ "$contload" -lt 20 ]; do
    reg2 X in '-' '/' '|' '\'; do
        echo ''
        ((contload++))
        echo -en " \b[$X]: "
        sleep 0.1
        clear
    done
done
}

startmenu