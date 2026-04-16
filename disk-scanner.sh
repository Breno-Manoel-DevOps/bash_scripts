#!/bin/bash

#------------------------------------
# Script: scanner_fs.sh
# Autor: Breno Manoel
# Descrição: Scanner de filesystem que analisa discos, permissões perigosas,
#            inodes e hard links no sistema
# Data: 2026-04-01
# Versao: 2.0
#------------------------------------

set -euo pipefail

# Cria diretório para os relatórios
REPORT_DIR="/tmp/scanner"
mkdir -p "$REPORT_DIR"

# Função para mostrar cabeçalho
show_header() {
    echo "========================================"
    echo "   SCANNER DE FILESYSTEM"
    echo "   Host: $(hostname)"
    echo "   Data: $(date '+%d/%m/%Y %H:%M:%S')"
    echo "========================================"
    echo ""
}

# Função: Relatório de discos e partições
report_discos() {
    echo "📀 DISCOS E PARTIÇÕES:"
    echo "----------------------------------------"
    lsblk
    echo ""
    
    echo "💾 USO DE ESPAÇO:"
    echo "----------------------------------------"
    df -hT
    echo ""
    
    # Encontra a partição mais cheia (maior percentual de uso)
    echo "⚠️ PARTIÇÃO MAIS CRÍTICA:"
    echo "----------------------------------------"
    df -hT | awk 'NR>1 {print $1, $7}' | sort -k2 -rn | head -1 | \
        awk '{print $1 " (" $2 " usado)"}'
    echo ""
}

# Função: Scanner de segurança (SUID/SGID e world-writable)
scanner_seguranca() {
    echo "🔒 ARQUIVOS COM SUID/SGID:"
    echo "----------------------------------------"
    
    # Busca arquivos com SUID (4000) ou SGID (2000)
    find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | tee "$REPORT_DIR/suid_sgid_files.txt"
    
    local count=$(wc -l < "$REPORT_DIR/suid_sgid_files.txt")
    echo ""
    echo "✅ Total encontrado: $count arquivos"
    echo "📁 Resultados salvos em: $REPORT_DIR/suid_sgid_files.txt"
    echo ""
    
    echo "📝 ARQUIVOS WORLD-WRITABLE (others podem escrever):"
    echo "----------------------------------------"
    
    # Busca arquivos com permissão de escrita para others (world-writable)
    find / -type f -perm -o=w 2>/dev/null | tee "$REPORT_DIR/world_writable_files.txt"
    
    local count2=$(wc -l < "$REPORT_DIR/world_writable_files.txt")
    echo ""
    echo "✅ Total encontrado: $count2 arquivos"
    echo "📁 Resultados salvos em: $REPORT_DIR/world_writable_files.txt"
    echo ""
}

# Função: Análise de inodes
analise_inodes() {
    echo "📁 TOP 10 DIRETÓRIOS COM MAIS INODES:"
    echo "----------------------------------------"
    
    # Conta arquivos por diretório pai, ignorando filesystems virtuais
    find / -xdev -printf "%h\n" 2>/dev/null | \
        sort | uniq -c | sort -rn | head -10 | \
        awk '{printf "%8d  %s\n", $1, $2}'
    echo ""
}

# Função: Encontrar hard links
encontrar_hardlinks() {
    echo "🔗 HARD LINKS ENCONTRADOS:"
    echo "----------------------------------------"
    
    # Encontra arquivos com link count > 1 (hard links)
    # Cria um arquivo temporário com inodes que aparecem mais de uma vez
    local temp_file=$(mktemp)
    
    # Lista todos os arquivos com seu inode e caminho
    find / -xdev -type f -printf "%i %p\n" 2>/dev/null | sort > "$temp_file"
    
    # Agrupa por inode e mostra apenas aqueles com mais de 1 ocorrência
    awk '{
        inode=$1
        path=substr($0, index($0, " ") + 1)
        count[inode]++
        paths[inode]=paths[inode] "\n  " path
    }
    END {
        for (inode in count) {
            if (count[inode] > 1) {
                print "\nInode: " inode "  Links: " count[inode]
                print paths[inode]
            }
        }
    }' "$temp_file"
    
    rm -f "$temp_file"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Análise de hard links concluída"
    fi
}

# Função principal que executa tudo
main() {
    show_header
    report_discos
    scanner_seguranca
    analise_inodes
    encontrar_hardlinks
    
    echo ""
    echo "========================================"
    echo "✅ SCANNER FINALIZADO"
    echo "📁 Relatórios salvos em: $REPORT_DIR"
    echo "========================================"
}

# Executa o script
main
