
#!/bin/bash

#------------------------------------
#Script: smart_monitor.sh
#Autor: Breno Manoel
#Descrição: 
#Data: 2026-03-27
#Versao: 1.0
#------------------------------------

set -euo pipefail  # Boa prática: tratamento rigoroso de erro

# 1. Configurações
LIMITE_DISCO=80
LIMITE_MEMORIA=90
TOP_PROCESSOS=5
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/monitor_$(date +%Y%m%d).log"

# Cores (Correção de sintaxe)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Criação de diretório de log
mkdir -p "$LOG_DIR"

# 2. Função de Log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Cabeçalho da Saída
echo "========================================="
echo "     MONITOR INTELIGENTE - SERVIDOR      "
echo "     Data: $(date '+%d/%m/%Y %H:%M:%S')  "
echo "========================================="

# 3. Verificação de Disco
# Captura o uso da partição raiz de forma robusta
USO_DISCO=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo -n ">>> DISCO [/]: "
if [ "$USO_DISCO" -ge "$LIMITE_DISCO" ]; then
    echo -e "${RED}ALERTA CRÍTICO: $USO_DISCO% utilizado (Limite: $LIMITE_DISCO%)${NC}"
    log "ERRO: Uso de disco em $USO_DISCO%"
elif [ "$USO_DISCO" -ge 70 ]; then
    echo -e "${YELLOW}ATENÇÃO: $USO_DISCO% utilizado${NC}"
    log "AVISO: Uso de disco em $USO_DISCO%"
else
    echo -e "${GREEN}OK: $USO_DISCO% utilizado${NC}"
    log "INFO: Disco OK ($USO_DISCO%)"
fi

# 4. Verificação de Memória
# Cálculo usando inteiros (Multiplica por 100 antes da divisão para manter precisão)
MEM_TOTAL=$(free -m | awk 'NR==2 {print $2}')
MEM_USADA=$(free -m | awk 'NR==2 {print $3}')
USO_MEM_PERC=$(( MEM_USADA * 100 / MEM_TOTAL ))

echo -n ">>> MEMÓRIA: "
if [ "$USO_MEM_PERC" -ge "$LIMITE_MEMORIA" ]; then
    echo -e "${RED}ALERTA CRÍTICO: $USO_MEM_PERC% utilizado (Limite: $LIMITE_MEMORIA%)${NC}"
    log "ERRO: Uso de memória em $USO_MEM_PERC%"
elif [ "$USO_MEM_PERC" -ge 70 ]; then
    echo -e "${YELLOW}ATENÇÃO: $USO_MEM_PERC% utilizado${NC}"
    log "AVISO: Uso de memória em $USO_MEM_PERC%"
else
    echo -e "${GREEN}OK: $USO_MEM_PERC% utilizado${NC}"
    log "INFO: Memória OK ($USO_MEM_PERC%)"
fi

# 5. Verificação de Processos
echo ">>> TOP $TOP_PROCESSOS PROCESSOS (MEM):"
echo "  PID  USER     %MEM  COMMAND"
# Captura e itera sobre os top processos
ps aux --sort=-%mem | awk -v top="$TOP_PROCESSOS" 'NR>1 && NR<=top+1 {print "  "$2" "$1" "$4"% "$11}'

# Alerta específico para processos > 20%
ALERTAS_PROC=$(ps aux --sort=-%mem | awk 'NR>1 {if($4 > 20.0) print $11" ("$4"%)"}')

echo ">>> ALERTAS:"
if [ -z "$ALERTAS_PROC" ]; then
    echo "- Nenhum processo excedendo 20% de memória."
else
    while read -r line; do
        echo -e "${RED}- PROCESSO CRÍTICO: $line${NC}"
        log "ALERTA: Processo pesado detectado: $line"
    done <<< "$ALERTAS_PROC"
fi

echo "========================================="
echo "Fim do monitoramento"
echo "========================================="

