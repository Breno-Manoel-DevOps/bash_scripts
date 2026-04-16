
#!/bin/bash

#------------------------------------
# Script: monitor.sh
# Autor: Breno Manoel
# Descrição: Monitora os 5 processos que mais consomem CPU e RAM
#            usando dados do /proc via comando ps
# Data: 2026-03-31
# Versao: 2.0
#------------------------------------

set -euo pipefail  # Sai se houver erro, variável não definida ou erro em pipe

# Função chamada ao receber SIGINT (Ctrl+C)
cleanup() {
    echo ""
    echo "🔴 Encerrando monitoramento..."
    echo "Todos os processos filhos foram finalizados."
    exit 0
}

# Captura o sinal SIGINT (Ctrl+C) e chama a função cleanup
trap cleanup SIGINT

# Loop infinito de monitoramento
while true; do
    clear  # Limpa a tela antes de mostrar novos dados
    
    # Cabeçalho com data e hora
    echo "========================================="
    echo "       MONITOR DE PROCESSOS             "
    echo "       $(date '+%d/%m/%Y %H:%M:%S')       "
    echo "========================================="
    echo ""
    
    # Top 5 processos por uso de CPU
    echo "🔥 TOP 5 PROCESSOS - USO DE CPU 🔥"
    echo "-----------------------------------------"
    # Usando ps para listar, ordenar por CPU decrescente e pegar cabeçalho + 5 primeiros
    ps aux --sort=-%cpu | head -6
    echo ""
    
    # Top 5 processos por uso de MEMÓRIA
    echo "💾 TOP 5 PROCESSOS - USO DE MEMÓRIA 💾"
    echo "-----------------------------------------"
    ps aux --sort=-%mem | head -6
    echo ""
   
   # Uso total de memoria do sistemae
    echo "USO TOTAL DE MEMORIA DO SISTEMA "
    echo "------------------------------------------"
    free -h
    echo ""
  
   #load average
   echo "LOAD AVERAGE"
   echo "-------------------------------------------"
   cat /proc/loadavg
   echo ""


    echo "-----------------------------------------"
    echo "Pressione Ctrl+C para encerrar"
    
    # Aguarda 2 segundos antes da próxima atualização
    sleep 5
done
