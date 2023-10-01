#!/bin/bash

nodeindexselected="databasebrasilsao-paulo0"
sid="'pizzaria'"
file="./.sourcedata/accessdata.conf"
while IFS= read -r linha; do
  if [[ "$linha" == "data[sid$nodeindexselected]=$sid" ]]; then
    echo "String found!: $linha"
    read -p 'test' test
    break
  fi
done < "$file"