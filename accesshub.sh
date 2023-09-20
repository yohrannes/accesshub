#!/bin/bash
declare -A regions
source ./.sourcedata/index/regionid.conf

declare -A subregions
source ./.sourcedata/index/sbregionid.conf

declare -A servertype
source ./.sourcedata/index/typeid.conf

declare -A data
source ./.sourcedata/accessdata.conf
source ./.sourcedata/hostaddress.conf
source ./.sourcedata/hostports.conf
source ./.sourcedata/userdata.conf
source ./.sourcedata/userpassword.conf

echo Script started in "$(date)" >> /var/log/accesshub.log from user "$(whoami)"

if ! command -v sshpass &> /dev/null; then
        echo "Installing sshpass"
        if command -v apt &> /dev/null; then
            sudo apt-get install -y sshpass
            elif command -v yum &> /dev/null; then
            sudo yum install -y sshpass
            else
            echo "Failed, you need to install sshpass manually"
            exit 1
        fi
fi

loading() {
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

mainmenu() {
trap 2 # enabling Ctrl+C
clear
echo -e '
==============================================
    ____ ____ ____ \e[32m____ ____ _  _\e[0m _  _ ___  
    |__| |    |___ \e[32m[__  [__  |__|\e[0m |  | |__] 
    |  | |___ |___ \e[32m___] ___] |  |\e[0m |__| |__] 
                                            
=============================================='
echo ""
echo "[1] Access Node" 
echo "[2] New node."
echo "[e] Exit."
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
read -p "Enter the desired option: " op

case ${op} in
1) clear; accessnodemenu;;
2) clear; newserver;;
e) clear; exit;;
E) clear; exit;;
*)
    clear
    loading
    mainmenu
;;
esac
}

accessnodemenu(){
    clear
    echo 'Select node from...'
    echo '[1] Node Region'
    echo '[2] Node Type'
    echo '[b] Go back'
    echo ''
    echo ''
    echo ''
    echo ''
    echo ''
    read -p "Enter the desired option: " accessnodeop

    case $accessnodeop in
    1) clear; regionmenu;;
    2) clear; typemenu;;
    b) clear; mainmenu;;
    *)
        clear
        loading
        accessnodemenu
    ;;
    esac

}

regionmenu() {
    clear
    echo 'Disponible Regions.'
    echo '---------------------'

    declare -A ckregionsoutput
    declare -A dispreg

    i=0
    for element in "${regions[@]}"; do
        if [[ -z "${ckregionsoutput[$element]}" ]]; then
            echo "$i - $element"
            ckregionsoutput["$element"]=true
            dispreg["$i"]=$element
            ((++i))
        fi
    done

    echo
    read -p "Select the value of the region you would like to access [Press v to go back]:" opregion

    if [ -n "$opregion" ] && { [ "$opregion" = "v" ] || [ "$opregion" = "V" ]; }; then
        accessnodemenu
    elif [ -n "$opregion" ] && [[ $opregion =~ ^[0-9]+$ ]]; then
        nodemenu
    else
        echo "Wrong value"
        sleep 1
        loading
        regionmenu
    fi
}

typemenu(){
    clear
    echo 'Disponible Node types.'
    echo '---------------------'

    declare -A cktypesoutput
    declare -A dispntypes

    i=0
    for element in "${servertype[@]}"; do
        if [[ -z "${cktypesoutput[$element]}" ]]; then
            echo "$i - $element"
            cktypesoutput["$element"]=true
            dispntypes["$i"]=$element
            ((++i))
        fi
    done

    echo
    read -p "Select the value of the node type you would like to access [Press v to go back]:" opnodetype

    if [ -n "$opnodetype" ] && { [ "$opnodetype" = "v" ] || [ "$opnodetype" = "V" ]; }; then
        accessnodemenu
    elif [ -n "$opnodetype" ] && [[ $opnodetype =~ ^[0-9]+$ ]]; then
        nodemenu
    else
        echo "Wrong value"
        sleep 1
        loading
        typemenu
    fi
}

nodemenu(){

    declare -A selectndhst
    declare -A selectndprt
    declare -A selectndpw
    declare -A selectndusr
    declare -A selectndname
    declare -A selectkeyfiledir

    indexselectndhst=0
    indexselectndprt=0
    indexselectndpw=0
    indexselectndusr=0
    indexselectndname=0
    indexselectkeyfiledir=0

    for index in ${!data[@]}; do
        if [[ "$index" == "hostid${dispntypes[$opnodetype]}"* ]]; then
            selectndhst[$indexselectndhst]=$index
            ((indexselectndhst++))
        fi
        if [[ "$index" == "portid${dispntypes[$opnodetype]}"* ]]; then
            selectndprt[$indexselectndprt]=$index
            ((indexselectndprt++))
        fi
        if [[ "$index" == "pid${dispntypes[$opnodetype]}"* ]]; then
            selectndpw[$indexselectndpw]=$index
            ((indexselectndpw++))
        fi
        if [[ "$index" == "uid${dispntypes[$opnodetype]}"* ]]; then
            selectndusr[$indexselectndusr]=$index
            ((indexselectndusr++))
        fi
        if [[ "$index" == "sid${dispntypes[$opnodetype]}"* ]]; then
            selectndname[$indexselectndname]=$index
            ((indexselectndname++))
        fi
        if [[ "$index" == "keyfile${dispntypes[$opnodetype]}"* ]]; then
            selectkeyfiledir[$indexselectkeyfiledir]=$index
            ((indexselectkeyfiledir++))
        fi

    done

    if [ ${accessnodeop} == 1 ]; then
        clear
        echo Disponible nodes on ${dispreg[$opregion]}
        echo '---------------------'

        countshowregions=0
        prev_selectndname=""

        for ((i=0;i<=${#selectndname[@]};i++)); do
            for ((a=0;a<=${#servertype[@]};a++)); do
                if [[ "${selectndname[$i]}" == "sid${servertype[$a]}${dispreg[$opregion]}"* ]]; then
                    if [[ "${selectndname[$i]}" != "$prev_selectndname" ]];then
                        echo "$countshowregions - ${data[${selectndname[$i]}]}"
                        ((countshowregions++))
                    fi
                    prev_selectndname="${selectndname[$i]}"
                fi
            done
        done

        echo
        read -p "Select the value of the node you would like to access [Press v to go back]:" opnode

        if [ -n "$opnode" ] && { [ "$opnode" = "v" ] || [ "$opnode" = "V" ]; }; then
            regionmenu
        elif [ -n "$opnode" ] && [[ $opnode =~ ^[0-9]+$ ]]; then
            connect
        else
            echo "Wrong value"
            sleep 1
            loading
            nodemenu
        fi

    fi
    
    if [ ${accessnodeop} == 2 ]; then
        clear
        echo
        echo Disponible ${dispntypes[$opnodetype]} nodes.
        echo '---------------------'

        countshowntypes=0
        prev_selectndname=""

        for ((i=0;i<=${#selectndname[@]};i++)); do
            for ((a=0;a<=${#servertype[@]};a++)); do
                if [[ "${selectndname[$i]}" == "sid${dispntypes[$opnodetype]}"* ]]; then
                    if [[ "${selectndname[$i]}" != "$prev_selectndname" ]];then
                        echo "$countshowntypes - ${data[${selectndname[$i]}]}"
                        ((countshowntypes++))
                    fi
                    prev_selectndname="${selectndname[$i]}"
                fi
            done
        done

         echo
         read -p "Select the value of the node you would like to access [Press v to go back]:" opnode

         if [ -n "$opnode" ] && { [ "$opnode" = "v" ] || [ "$opnode" = "V" ]; }; then
             typemenu
         elif [ -n "$opnode" ] && [[ $opnode =~ ^[0-9]+$ ]]; then
             connect
         else
             echo "Wrong value"
             sleep 1
             loading
             nodemenu
         fi

    fi

}

connect(){
    countshowregions=0
    prev_selectndname=""

    for ((i=0;i<=${#selectndname[@]};i++)); do
        for ((a=0;a<=${#servertype[@]};a++)); do
            if [[ "${selectndname[$i]}" == "sid${servertype[$a]}${dispreg[$opregion]}"* ]]; then
                if [[ "${selectndname[$i]}" != "$prev_selectndname" ]];then
                    if [[ $opnode == $countshowregions ]]; then
                        echo "Node selected $countshowregions - ${data[${selectndname[$i]}]} - ${selectndname[$i]}"
                        nodeindexselected="${selectndname[$i]:3}"
                    fi
                    ((countshowregions++))
                fi
                prev_selectndname="${selectndname[$i]}"
            fi
        done
    done

    clear

    # Conetion with specifying private key
    # sshpass -p 'mypassword' ssh -i ~/.ssh/id_rsa.pub -p 2222 user@example.com

    sshpass -p ${data["pid$nodeindexselected"]} ssh -p ${data["portid$nodeindexselected"]} ${data["uid$nodeindexselected"]}@${data["hostid$nodeindexselected"]}

    nodemenu

}

newserver() {

# trap '' 2 # disable Ctrl+C, dont change that if you don't want problems....

    # Variables used for organize thse access data
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

    fullname(){
        read -r -p "Full name title, [Press v to go back]:" sid
        if [ -n "$sid" ] && { [ "$sid" = "v" ] || [ "$sid" = "V" ]; }; then
            clear
            mainmenu
        elif [ -z "$sid" ]; then
            clear
            fullname
        else
            serveruser
        fi
    }

    serveruser(){
        read -r -p "Server User [Press v to go back]:" uid
        if [ -n "$uid" ] && { [ "$uid" = "v" ] || [ "$uid" = "V" ]; }; then
            fullname
        elif [ -z "$uid" ]; then
            clear
            serveruser
        elif [[ $uid =~ [A-Z] ]];then
            echo "Wrong value detected"
            serveruser
        else
            connectmethod
        fi
    }

    connectmethod(){
        echo "[1] Password."
        echo "[2] Private key file."
        read -r -p "How you want to connect? [Press v to go back]:" connectop
        if [ "$connectop" == "1" ] && { [ "$pid" = "v" ] || [ "$pid" = "V" ]; }; then
            password
        elif [ "$connectop" == "2" ]; then
            privatekeyfile
        elif ! [[ $connectop =~ ^[1-2]+$ ]];then
            connectmethod
        elif [ -z "$connectop" ]; then
            clear
            connectmethod
        else
            hostaddress
        fi
    }

    password(){
    read -r -p "Password [Press v to go back]:" pid
        if [ -n "$pid" ] && { [ "$pid" = "v" ] || [ "$pid" = "V" ]; }; then
            connectmethod
        elif [ -z "$pid" ]; then
            clear
            password
        else
            hostaddress
        fi
    }

    privatekeyfile(){
    read -r -p "Paste your key file directory (example: ~/.ssh/id_rsa.pub) [Press v to go back]:" keyfile
        if [ "$keyfile" = "v" ] || [ "$keyfile" = "V" ]; then
            connectmethod
        elif [ -z "$keyfile" ]; then
            clear
            privatekeyfile
        else
            hostaddress
        fi
    }

    hostaddress(){
        read -r -p "Host [Press v to go back]: " hostid
        if [ -n "$hostid" ] && { [ "$hostid" = "v" ] || [ "$hostid" = "V" ]; }; then
            password
        elif [ -z "$hostid" ]; then
            clear
            hostaddress
        elif [[ $hostid =~ [A-Z] ]];then
            echo "Wrong value detected"
            serveruser
        else
            port
        fi
    }

    port(){
        read -r -p "Port (default 22) [Press v to go back]: " portid
        if [ -n "$portid" ] && { [ "$portid" = "v" ] || [ "$portid" = "V" ]; }; then
            hostaddress
        elif ! [[ $portid =~ ^[0-9]+$ ]]; then
            if [ -z "$portid" ]; then
                portid=22
                servertype
            else
                echo "Wrong value detected"
                port
            fi
        else
            servertype
        fi
    }
    
    servertype(){
        read -r -p "Server type [Press v to go back]: " typeid
        if [ -n "$typeid" ] && { [ "$typeid" = "v" ] || [ "$typeid" = "V" ]; }; then
            port
        elif [[ $typeid =~ [A-Z] ]]; then
            echo "Wrong value detected"
            servertype
        elif [ -z "$typeid" ]; then
            clear
            servertype
        else
            serverregion
        fi
    }

    serverregion(){
        read -r -p "Server region [Press v to go back]: " regionid
        if [ -n "$regionid" ] && { [ "$regionid" = "v" ] || [ "$regionid" = "V" ]; }; then
            servertype
        elif [ -z "$regionid" ];then
            clear
            serverregion
        elif [[ $regionid =~ [A-Z] ]]; then
            echo "Wrong value detected"
        else
            serversubregion
        fi
    }

    serversubregion(){
        read -r -p "Server sub-region [Press v to go back]: " sbregionid
        if [ -n "$sbregionid" ] && { [ "$sbregionid" = "v" ] || [ "$sbregionid" = "V" ]; }; then
        serverregion
        elif [[ $sbregionid =~ [A-Z] ]]; then
            echo "Wrong value detected"
            serversubregion
        elif [ -z "$sbregionid" ];then
            clear
            serversubregion
        fi
    }

    fullname

    # Add the id value array on the next disponible index
    echo "regions[${#regions[@]}]='$regionid'" >> ./.sourcedata/index/regionid.conf
    regions[${#regions[@]}]=${regionid}

    echo "subregions[${#subregions[@]}]='$sbregionid'" >> ./.sourcedata/index/sbregionid.conf
    subregions[${#subregions[@]}]=${sbregionid}

    echo "servertype[${#servertype[@]}]='$typeid'" >> ./.sourcedata/index/typeid.conf
    servertype[${#servertype[@]}]=${typeid}

    sidtotal=0
    uidtotal=0
    pidtotal=0
    hostidtotal=0
    portidtotal=0
    keyfiletotal=0

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
            if [[ "keyfile$typeid$regionid$sbregionid$i" == $a ]]; then
                ((keyfiletotal++))
            fi
        done
    done

    echo "data[sid$typeid$regionid$sbregionid$sidtotal]='$sid'" >> ./.sourcedata/accessdata.conf
    data["sid$typeid$regionid$sbregionid$sidtotal"]=$sid
    echo "data[uid$typeid$regionid$sbregionid$uidtotal]='$uid'" >> ./.sourcedata/userdata.conf
    data["uid$typeid$regionid$sbregionid$uidtotal"]=$uid
    echo "data[pid$typeid$regionid$sbregionid$pidtotal]='$pid'" >> ./.sourcedata/userpassword.conf
    data["pid$typeid$regionid$sbregionid$pidtotal"]=$pid
    echo "data[keyfile$typeid$regionid$sbregionid$pidtotal]='$keyfile'" >> ./.sourcedata/keyfiles.conf
    data["keyfile$typeid$regionid$sbregionid$pidtotal"]=$keyfile
    echo "data[hostid$typeid$regionid$sbregionid$hostidtotal]='$hostid'" >> ./.sourcedata/hostaddress.conf
    data["hostid$typeid$regionid$sbregionid$hostidtotal"]=$hostid
    echo "data[portid$typeid$regionid$sbregionid$portidtotal]='$portid'" >> ./.sourcedata/hostports.conf
    data["portid$typeid$regionid$sbregionid$portidtotal"]=$portid

    moredata(){
        while true ;do
            read -r -p "Would you like to add more data? [y/n]: " moredata
            if [[ $moredata == [yY] ]]; then
                clear
                newserver
            else
                mainmenu
            fi
        done
    }
    moredata

}

mainmenu
