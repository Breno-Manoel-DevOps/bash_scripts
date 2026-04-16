#!/bin/bash

#------------------------------------
#Script: create_script.sh
#Autor: Breno Manoel
#Descrição: Cria um novo script bash com estrutura básica
#Data: $(date +%Y-%m-%d)
#Versao: 1.0
#------------------------------------

# Cores para output (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para mostrar uso do script
show_usage() {
    echo "Uso: $0 <nome_do_script>"
    echo "Exemplo: $0 meu_script.sh"
}

# Validar argumentos
if [ $# -eq 0 ]; then
    echo -e "${RED}Erro: Nenhum argumento fornecido${NC}"
    show_usage
    exit 1
fi

SCRIPT_NAME="$1"

# Validar extensão .sh
if [[ ! "$SCRIPT_NAME" =~ \.sh$ ]]; then
    echo -e "${YELLOW}Aviso: O script não tem extensão .sh. Adicionando...${NC}"
    SCRIPT_NAME="${SCRIPT_NAME}.sh"
fi

# Verificar se o arquivo já existe
if [ -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}Erro: O arquivo $SCRIPT_NAME já existe${NC}"
    echo -e "${YELLOW}Deseja sobrescrever? (s/n)${NC}"
    read -r resposta
    if [[ ! "$resposta" =~ ^[Ss]$ ]]; then
        echo "Operação cancelada"
        exit 1
    fi
fi

# Criar o script com estrutura básica
cat > "$SCRIPT_NAME" << EOF
#!/bin/bash

#------------------------------------
#Script: SCRIPT_NAME_PLACEHOLDER
#Autor: Breno Manoel
#Descrição: 
#Data: $(date +%Y-%m-%d)
#Versao: 1.0
#------------------------------------

set -euo pipefail  # Boa prática: tratamento rigoroso de erros

EOF

# Substituir o placeholder pelo nome real do script
sed -i "s/SCRIPT_NAME_PLACEHOLDER/$(basename "$SCRIPT_NAME")/g" "$SCRIPT_NAME"

# Tornar o script executável
chmod +x "$SCRIPT_NAME"

# Verificar se o chmod foi bem-sucedido
if [ -x "$SCRIPT_NAME" ]; then
    echo -e "${GREEN}✓ Script $SCRIPT_NAME criado com sucesso${NC}"
else
    echo -e "${RED}✗ Erro ao tornar o script executável${NC}"
    exit 1
fi

# Perguntar se deseja editar
echo -e "${YELLOW}Deseja editar o script agora? (s/n)${NC}"
read -r resposta

if [[ "$resposta" =~ ^[Ss]$ ]]; then
    # Verificar qual editor está disponível
    if command -v nano &> /dev/null; then
        nano "$SCRIPT_NAME"
    elif command -v vim &> /dev/null; then
        vim "$SCRIPT_NAME"
    elif command -v vi &> /dev/null; then
        vi "$SCRIPT_NAME"
    else
        echo -e "${RED}Nenhum editor encontrado. Use seu editor favorito para editar $SCRIPT_NAME${NC}"
    fi
else
    echo -e "${GREEN}Script criado! Execute com: ./$SCRIPT_NAME${NC}"
fi
