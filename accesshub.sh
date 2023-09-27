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
source ./.sourcedata/keyfiles.conf

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

logo() {
    trap 2 # enabling Ctrl+C
    clear
    echo -e '
    ==============================================
        ____ ____ ____ \e[32m____ ____ _  _\e[0m _  _ ___  
        |__| |    |___ \e[32m[__  [__  |__|\e[0m |  | |__] 
        |  | |___ |___ \e[32m___] ___] |  |\e[0m |__| |__] 
                                                
    =============================================='
    echo ""
}

mainmenu() {
    echo "[1] Access Node."
    echo "[2] Manage nodes."
    echo "[q] Quit."
    echo 
    echo 
    echo 
    echo 
    echo 
    echo 
    read -p "Enter the desired option: " op

    case ${op} in
    1) clear; accessnodemenu;;
    2) clear; nodemanager;;
    q) clear; exit;;
    Q) clear; exit;;
    *)
        clear
        logo
        mainmenu
    ;;
    esac
}

accessnodemenu(){
    clear
    logo
    echo 'Select node from:'
    echo
    echo '[1] Node Region.'
    echo '[2] Node Type.'
    echo '[b] Go back.'
    echo ''
    echo ''
    echo ''
    echo ''
    read -p "Enter the desired option: " accessnodeop

    case $accessnodeop in
    1) clear; regionmenu;;
    2) clear; typemenu;;
    b) clear; logo; mainmenu;;
    B) clear; logo; mainmenu;;
    *)
        clear
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
    read -p "Select the value of the region you would like to access, Go back [b]:" opregion

    if [ -n "$opregion" ] && { [ "$opregion" = "b" ] || [ "$opregion" = "B" ]; }; then
        accessnodemenu
    elif [ -n "$opregion" ] && [[ $opregion =~ ^[0-9]+$ ]]; then
        nodemenu
    else
        echo "Wrong value"
        sleep 1
        loading
        clear
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
    read -p "Select the value of the node type you would like to access, Go back [b]:" opnodetype

    if [ -n "$opnodetype" ] && { [ "$opnodetype" = "b" ] || [ "$opnodetype" = "B" ]; }; then
        accessnodemenu
    elif [ -n "$opnodetype" ] && [[ $opnodetype =~ ^[0-9]+$ ]]; then
        clear
        nodemenu
    else
        echo "Wrong value"
        sleep 1
        loading
        typemenu
    fi
}

nodemenu(){

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
        read -p "Select the value of the node you would like to access, Go back [b]:" opnode

        if [ -n "$opnode" ] && { [ "$opnode" = "b" ] || [ "$opnode" = "B" ]; }; then
            regionmenu
        elif [ -n "$opnode" ] && [[ $opnode =~ ^[0-9]+$ ]]; then
            if [ "$findnodes" == "1" ]; then
                clear
            else
                connect
            fi
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
                    if [[ "${selectndname[$i]}" != "$prev_selectndname" ]]; then
                        echo "$countshowntypes - ${data[${selectndname[$i]}]}"
                        ((countshowntypes++))
                    fi
                    prev_selectndname="${selectndname[$i]}"
                fi
            done
        done

        echo
        read -p "Select the value of the node you would like to access, Go back [b]:" opnode

        if [ -n "$opnode" ] && { [ "$opnode" = "b" ] || [ "$opnode" = "B" ]; }; then
            typemenu
        elif [ -n "$opnode" ] && [[ $opnode =~ ^[0-9]+$ ]]; then
            if [ "$findnodes" == "1" ]; then
                clear
            else
                connect
            fi
        else
            echo "Wrong value"
            sleep 1
            loading
            nodemenu
        fi

    fi

}

findnodes(){
    countshowregions=0
    prev_selectndname=""

    for ((i=0;i<=${#selectndname[@]};i++)); do
        for ((a=0;a<=${#servertype[@]};a++)); do
            if [[ "${selectndname[$i]}" == "sid${servertype[$a]}${dispreg[$opregion]}"* ]]; then
                if [[ "${selectndname[$i]}" != "$prev_selectndname" ]];then
                    if [[ $opnode == $countshowregions ]]; then
                        # echo "Node selected $countshowregions - ${data[${selectndname[$i]}]} - ${selectndname[$i]}"
                        nodeindexselected="${selectndname[$i]:3}"
                    fi
                    ((countshowregions++))
                fi
                prev_selectndname="${selectndname[$i]}"
            fi
        done
    done

}

connect(){

    findnodes

    clear

    if [ "${data["keyfile$nodeindexselected"]}" == "" ]; then
        sshpass -p ${data["pid$nodeindexselected"]} ssh -p ${data["portid$nodeindexselected"]} ${data["uid$nodeindexselected"]}@${data["hostid$nodeindexselected"]} 2>&1
        nodemenu
    else
        ssh -i ${data["keyfile$nodeindexselected"]} ${data["uid$nodeindexselected"]}@${data["hostid$nodeindexselected"]} -p ${data["portid$nodeindexselected"]} 2>&1
        nodemenu 
    fi

    nodemenu

}

showserverinfo(){
    logo
    serverinfordataops=''
    echo 'Server informations:'
    echo
    echo ${serverinfordataops[0]} 'Server name:' $sid
    echo ${serverinfordataops[1]} 'User:' $uid
    echo ${serverinfordataops[2]} 'Host:' $hostid
    echo ${serverinfordataops[3]} 'Port:' $portid
    if [ -n "$pid" ];then
        echo ${serverinfordataops[4]} 'Password:' $pid
    elif [ -n "$keyfile" ]; then
        echo ${serverinfordataops[5]} 'Key file directory:' $keyfile
    fi
    echo ${serverinfordataops[6]} 'Server type:' $typeid
    echo ${serverinfordataops[7]} 'Server region:' $regionid
    echo ${serverinfordataops[8]} 'Server sub-region:' $sbregionid
    echo
}

fullname(){
    read -r -p "Server title, Go back [b]:" sid
    if [ -n "$sid" ] && { [ "$sid" = "b" ] || [ "$sid" = "B" ]; }; then
        clear
        nodemanager
    elif [ -z "$sid" ]; then
        clear
        fullname
    else
        clear
    fi
}

serveruser(){
    read -r -p "Server User (lower case), Go back [b]:" uid
    if [ -n "$uid" ] && { [ "$uid" = "b" ] || [ "$uid" = "B" ]; }; then
        clear
        fullname
    elif [ -z "$uid" ]; then
        clear
        serveruser
    elif [[ $uid =~ [A-Z] ]];then
        echo "Wrong value detected (upper case)"
        sleep 3
        clear
        serveruser
    else
        clear
    fi
}

password(){
    read -r -p "Password, Go back [b]:" pid
    if [ -n "$pid" ] && { [ "$pid" = "b" ] || [ "$pid" = "B" ]; }; then
        clear
        connectmethod
    elif [ -z "$pid" ]; then
        echo "No value detected"
        sleep 3
        clear
        password
    else
        clear
    fi
}

privatekeyfile(){
    read -r -p "Paste your key file directory (example: ~/.ssh/id_rsa), Go back [b]:" keyfile
    if [ "$keyfile" = "b" ] || [ "$keyfile" = "B" ]; then
    clear
        connectmethod
    elif [ -z "$keyfile" ]; then
        keyfile="~/.ssh/id_rsa"
        clear
    else
        clear
    fi
}

hostaddress(){
    read -r -p "Host (lower case), Go back [b]: " hostid
    if [ -n "$hostid" ] && { [ "$hostid" = "b" ] || [ "$hostid" = "B" ]; }; then
        clear
        connectmethod
    elif [ -z "$hostid" ]; then
        echo "No value detected"
        sleep 3
        clear
        hostaddress
    elif [[ $hostid =~ [A-Z] ]];then
        echo "Wrong value detected (upper case)"
        sleep 3
        clear
        hostaddress
    else
        clear
    fi
}

port(){
    read -r -p "Port (default 22), Go back [b]: " portid
    if [ -n "$portid" ] && { [ "$portid" = "b" ] || [ "$portid" = "B" ]; }; then
        clear
        hostaddress
    elif ! [[ $portid =~ ^[0-9]+$ ]]; then
        if [ -z "$portid" ]; then
            portid=22
            clear
        else
            echo "Wrong value detected, just numbers"
            sleep 3
            clear
            port
        fi
    else
        clear
    fi
}

servertype(){
    read -r -p "Server type (lower case), Go back [b]: " typeid
    if [ -n "$typeid" ] && { [ "$typeid" = "b" ] || [ "$typeid" = "B" ]; }; then
        clear
        port
    elif [[ "$typeid" =~ [A-Z] || "$typeid" == *" "* ]]; then
        echo "Wrong value detected (uppser case)"
        sleep 3
        clear
        servertype
    elif [ -z "$typeid" ]; then
        echo "No value detected"
        sleep 3
        clear
        servertype 2
    else
        clear
    fi
}

serverregion(){
    read -r -p "Server region (lower case), Go back [b]: " regionid
    if [ -n "$regionid" ] && { [ "$regionid" = "b" ] || [ "$regionid" = "B" ]; }; then
        clear
        servertype
    elif [ -z "$regionid" ];then
        echo "No value detected"
        sleep 3
        clear
        serverregion
    elif [[ "$regionid" =~ [A-Z] || "$regionid" == *" "* ]]; then
        echo "Wrong value detected"
        sleep 3
        clear
        serverregion
    else
        clear
    fi
}

serversubregion(){
    read -r -p "Server sub-region (lower case), Go back [b]: " sbregionid
    if [ -n "$sbregionid" ] && { [ "$sbregionid" = "b" ] || [ "$sbregionid" = "B" ]; }; then
        clear
        serverregion
    elif [[ "$sbregionid" =~ [A-Z] || "$sbregionid" == *" "* ]]; then
        echo "Wrong value detected"
        sleep 3
        clear
        serversubregion
    elif [ -z "$sbregionid" ];then
        echo "No value detected"
        sleep 3
        clear
        serversubregion
    else
        clear
    fi
}

checkdata(){

    showserverinfo

    confirm(){
        
        read -r -p "Confirm? [y], Change values [n], Go back [b]: " recheckdata

        if [ -n "$recheckdata" ] && { [ "$recheckdata" = "b" ] || [ "$recheckdata" = "B" ]; }; then
            clear
            nodemanager
        elif [[ $recheckdata == [yY] ]]; then
            clear
            loading
        elif [[ $recheckdata == [nN] ]]; then
            changeserverinfo(){
                for ((i=0;i<=8;i++)); do
                    ((serverinfordataops[$i]="$i"))
                done
                showserverinfo
                read -r -p "Select the option for the data you want to change [1,2,3...], Go back [b]:" changeserverdata
                if [ -n "$recheckdata" ] && { [ "$recheckdata" = "b" ] || [ "$recheckdata" = "B" ]; }; then
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "0" ]]; then
                    newserver
                    fullname
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "1" ]]; then
                    serveruser
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "2" ]]; then
                    hostaddress
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "3" ]]; then
                    port
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "4" ]]; then
                    password
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "5" ]]; then
                    privatekeyfile
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "6" ]]; then
                    servertype
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "7" ]]; then
                    serverregion
                    clear
                    showserverinfo
                    confirm
                elif [[ "$changeserverdata" == "8" ]]; then
                    serversubregion
                    clear
                    showserverinfo
                    confirm
                else
                    clear
                    showserverinfo
                    confirm
                fi
            }

            changeserverinfo
            
        elif [[ -z "$recheckdata" ]]; then
            showserverinfo
            confirm
        else
            showserverinfo
            confirm
            clear
        fi
    }

    confirm

}

newserver() (
    trap '' 2 # disabling Ctrl+C, dont change that if you don't want problems...

    # Indexing used for organize the access data
    # data[A - A contains sid,uid,pid,hostid,portid

    # sid = Server name
    # uid = Server user
    # pid = Server password
    # hostid = Server ip
    # portid = Server port
    
    # Indexation method for filter the server type and region

    # data[AB - B contains typeid (backup, app, balancer, infra)
    # data[ABC - C contains regionid
    # data[ABCDN] - D contains sbregionid
    # data[ABCDN] - N contains the id number in case of duplicate indexing

    # typeid = Server type
    # regionid = Server region (Coutry or other, it depends of your business reach)
    # sbregionid = Server sub-region (State or other)

    fullname
    serveruser

    connectmethod(){

        echo "[1] Password."
        echo "[2] Private key file."
        read -r -p "How you want to connect?, Go back [b]:" connectop

        if [ -n "$connectop" ] && { [ "$connectop" = "b" ] || [ "$connectop" = "B" ]; }; then
            clear
            serveruser 
        elif [ "$connectop" == "1" ]; then
            clear
            password
        elif [ "$connectop" == "2" ]; then
            clear
            privatekeyfile
        elif ! [[ $connectop =~ ^[1-2]+$ ]];then
            echo "This option doesn't exist"
            sleep 3
            clear
            connectmethod
        elif [ -z "$connectop" ]; then
            echo "No value detected"
            sleep 3
            clear
            connectmethod
        else
            clear
        fi

    }

    connectmethod
    hostaddress
    port
    servertype

    read -r -p "Whould like to specify the server location? [y]" setlocationop

    if [ -n "$setlocationop" ] && { [ "$setlocationop" = "y" ] || [ "$setlocationop" = "Y" ]; }; then
        clear
        serverregion
        serversubregion
    else
        clear
    fi

    checkdata

    addnodedata(){

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

        nodemanager

    }

    addnodedata
    logo
    mainmenu

)

nodemanager() {

    logo
    echo '[1] New node'
    echo '[2] Change node data'
    echo '[b] Go back'
    echo 
    echo
    echo
    echo
    echo
    echo
    read -p 'Select the desired option:' managerop
    case ${managerop} in
    1) clear; newserver;;
    2)
    clear;
    findnodes=1; accessnodemenu;
        findnodes # Calling function to search for specified node

        sid=${data["sid$nodeindexselected"]}
        uid=${data["uid$nodeindexselected"]}
        hostid=${data["hostid$nodeindexselected"]}
        portid=${data["portid$nodeindexselected"]}
        pid=${data["pid$nodeindexselected"]}
        keyfile=${data["keyfile$nodeindexselected"]}

        indexcounter=0

        for ((i=0; i<${#servertype[@]}; i++)); do
            for ((a=0; a<${#regions[@]}; a++)); do
                for ((b=0; b<${#subregions[@]}; b++)); do
                    if [[ "${servertype[$i]}${regions[$a]}${subregions[$b]}$indexcounter" = "${nodeindexselected}" ]]; then
                        typeid=${servertype[$i]}
                        regionid=${regions[$i]}
                        sbregionid=${subregions[$i]}
                    fi
                done
            done
        done

        checkdata

        # find a way to delete the specified string on the source files......

        # echo "regions[${#regions[@]}]='$regionid'" >> ./.sourcedata/index/regionid.conf
        # echo "subregions[${#subregions[@]}]='$sbregionid'" >> ./.sourcedata/index/sbregionid.conf
        # echo "servertype[${#servertype[@]}]='$typeid'" >> ./.sourcedata/index/typeid.conf
        
        data["sid$nodeindexselected"]=$sid
        data["uid$nodeindexselected"]=$uid
        data["hostid$nodeindexselected"]=$hostid
        data["portid$nodeindexselected"]=$portid
        data["pid$nodeindexselected"]=$pid
        data["keyfile$nodeindexselected"]=$keyfile
        data["typeid$nodeindexselected"]=$typeid
        data["regionid$nodeindexselected"]=$regionid
        data["sbregionid$nodeindexselected"]=$sbregionid

    ;;
    b) clear; logo; mainmenu;;
    B) clear; logo; mainmenu;;
    *)
        clear
        nodemanager
    ;;
    esac

}

logo
mainmenu
