#!/bin/bash

#------------------------------------
#Script: sysrem_health.sh
#Autor: Breno Manoel
#Descrição: 
#Data: 2026-03-30
#Versao: 1.0
#------------------------------------

set -euo pipefail  # Boa prática: tratamento rigoroso de erros

NAME=$1

if [[ -z "${1:-}" ]]; then
    echo "Erro: Forneça o nome do técnico como argumento."
    exit 1
fi

check_disk(){
echo "Espaço em disco: "
echo
df -h
}

check_uptime(){
echo
echo "O servidor está ligado a $(uptime -p)"
}

send_report(){
echo 
echo "Relátorio gerado por $NAME."
}

echo -e "Qual opçao deseja voce deseja verificar?\n1) DISCO\n2) UPTIME\n3) AMBOS" 

read INPUT

case "$INPUT" in 
	1)
		check_disk
		;;
	2)
		check_uptime
		;;
	3)
		check_disk
		check_uptime
		;;
	*)
	echo "Opção inválida."
	;;
esac

send_report
exit 0


