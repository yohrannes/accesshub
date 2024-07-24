

## Phisical hosts informations
declare -A id
declare -A hostname_alias
declare -A ip_address
declare -A ssh_port
declare -A password
declare -A sub_region
declare -A virtualization_type

getdata () {
    ## Functiond to get ssh data
    logininfo = 'mysql --defaults-file ~/.my.cnf -e "use db_phosts;'
    id = ${logininfo}' SELECT id FROM phosts_region_a;"'

}

connect () {
    # Function to connect from ssh
}

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