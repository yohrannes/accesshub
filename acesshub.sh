#!/bin/bash

# Informações de conexão com o banco de dados (substitua pelos seus valores)
MYSQL_USER="root"
MYSQL_PASSWORD="jamaica"
MYSQL_DATABASE="db_phosts"
MYSQL_HOST="localhost"

## Phisical hosts informations
declare -A id
declare -A hostname_alias
declare -A ip_address
declare -A ssh_port
declare -A password
declare -A sub_region
declare -A virtualization_type

## Functiond to get ssh data
SQL_QUERY="SELECT id FROM phosts_region_a where virtualization_type = 'vzWin'"
id=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

SQL_QUERY="select user, ip_address, ssh_port from phosts_region_a where id = 2;"
ip_address=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

echo $ip_address $selected_host

if [ $? -eq 0 ]; then
    while IFS= read -r line; do
        echo "$line"
    done <<< "$RESULT"
else
    echo "Erro ao executar a consulta: $RESULT"
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