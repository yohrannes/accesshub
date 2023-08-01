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
trap 2 # enable Ctrl+C
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
    read -p "Select the respective value of the region you would like to access [Press v to go back]:" opregion

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
    read -p "Select the respective value of the node type you would like to access [Press v to go back]:" opnodetype

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

    if [ ${accessnodeop} == 1 ]; then
        clear
        echo Disponible nodes on ${dispreg[$opregion]}
        echo '---------------------'

        declare -A cktypesoutput
        declare -A dispntypes
        
        i=0
        for element in "${servertype[@]}"; do
            if [[ -z "${cktypesoutput[$element]}" ]]; then
                cktypesoutput["$element"]=true
                dispntypes["$i"]=$element
                ((i++))
            fi
        done

        echo

        i=0
        countnodes=0
        for index in ${!data[@]}; do
            a=0
            for typeindex in ${!dispntypes[@]}; do
                if [[ "$index" == "sid${dispntypes[$a]}${dispreg[$opregion]}"* ]]; then
                    echo "$countnodes - ${data[$index]}"
                    nodeselected[$countnodes]=$index
                    ((countnodes++))
                fi
                ((a++))
            done
            ((i++))
        done

        echo
        read -p "Select the respective value of the node you would like to access [Press v to go back]:" opnode

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

    elif [ ${accessnodeop} == 2 ]; then
        clear
        echo
        echo Disponible ${dispntypes[$opnodetype]} nodes.
        echo '---------------------'

        i=0
        countndmenu=0
        indexselectndhst=0
        indexselectndprt=0
        indexselectndpw=0
        indexselectndusr=0
        for index in ${!data[@]};do
            if [[ "$index" == "sid${dispntypes[$opnodetype]}"* ]]; then
                echo "$countndmenu - ${data[$index]}"
                ((countndmenu++))
            elif [[ "$index" == "hostid${dispntypes[$opnodetype]}"* ]]; then
                selectndhst[$indexselectndhst]=$index
                ((indexselectndhst++))
            elif [[ "$index" == "portid${dispntypes[$opnodetype]}"* ]]; then
                selectndprt[$indexselectndprt]=$index
                ((indexselectndprt++))
            elif [[ "$index" == "pid${dispntypes[$opnodetype]}"* ]]; then
                selectndpw[$indexselectndpw]=$index
                ((indexselectndpw++))
            elif [[ "$index" == "uid${dispntypes[$opnodetype]}"* ]]; then
                selectndusr[$indexselectndusr]=$index
                ((indexselectndusr++))
            fi
            ((i++))
        done

        echo
        read -p "Select the respective value of the node you would like to access [Press v to go back]:" opnode

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

    test=$opnode
    echo "Connecting"
    echo 
    echo "sshpass -p ${data[${selectndusr[$opnode]}]}"
    echo "sshpass -p ${data[${selectndprt[$test]}]}"
    echo "sshpass -p ${data[${selectndhst[$test]}]}"
    echo "sshpass -p ${data[${selectndpw[$test]}]}"
    read -p "-------------" vdfv

}

function newserver {

trap '' 2 # disable Ctrl+C, dont change that if you don't want problems....

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
            password
        fi
    }

    password(){
    read -r -p "Password [Press v to go back]:" pid
        if [ -n "$pid" ] && { [ "$pid" = "v" ] || [ "$pid" = "V" ]; }; then
            serveruser
        elif [ -z "$pid" ]; then
            clear
            password
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
        done
    done

    echo "data[sid$typeid$regionid$sbregionid$sidtotal]='$sid'" >> ./.sourcedata/accessdata.conf
    data["sid$typeid$regionid$sbregionid$sidtotal"]=$sid
    echo "data[uid$typeid$regionid$sbregionid$uidtotal]='$uid'" >> ./.sourcedata/userdata.conf
    data["uid$typeid$regionid$sbregionid$uidtotal"]=$uid
    echo "data[pid$typeid$regionid$sbregionid$pidtotal]='$pid'" >> ./.sourcedata/userpassword.conf
    data["pid$typeid$regionid$sbregionid$pidtotal"]=$pid
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
