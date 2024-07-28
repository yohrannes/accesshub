#!/bin/bash

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

## Getting ssh data
SQL_QUERY="SELECT id FROM phosts_region_a where virtualization_type = 'vzWin' AND hostname_alias = 'australianode1';"
id=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

SQL_QUERY="select password from phosts_region_a where id = ${id};"
password=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

SQL_QUERY="select user from phosts_region_a where id = ${id};"
user=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

SQL_QUERY="select ip_address from phosts_region_a where id = ${id};"
ip_address=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

SQL_QUERY="select ssh_port from phosts_region_a where id = ${id};"
ssh_port=$(mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" "$MYSQL_DATABASE" -e "$SQL_QUERY" 2>/dev/null | tail -n +2)

if [ $? -eq 0 ]; then
    while IFS= read -r line; do
        echo "$line"
    done <<< "$RESULT"
else
    loading
    echo "Erro ao executar a consulta: $RESULT"
fi

echo "SELECTED NODE: ${id}"
echo "sshpass -p ${password} ssh ${user}@${ip_address} -p ${ssh_port}"