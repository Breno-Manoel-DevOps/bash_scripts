# 🖥️ System Monitor Scripts – Conjunto de Ferramentas para Análise e Monitoramento do Sistema

![Bash](https://img.shields.io/badge/Bash-4.0%2B-green) ![License](https://img.shields.io/badge/License-MIT-blue) ![Linux](https://img.shields.io/badge/Platform-Linux-lightgrey)

> Cinco scripts Bash poderosos para monitoramento em tempo real, análise de disco, verificação inteligente de recursos, saúde do sistema e criação automatizada de novos scripts.

---

## 📦 Scripts incluídos

| Script | Função principal | Execução |
|--------|------------------|----------|
| `monitor.sh` | Monitora CPU, memória e load average em tempo real | `./monitor.sh` |
| `disk-scanner.sh` | Analisa partições, SUID/SGID, inodes e hard links | `sudo ./disk-scanner.sh` |
| `monitor-inteligente.sh` | Verifica discos, memória e processos automaticamente | `./monitor-inteligente.sh` |
| `system-health.sh` | Menu interativo para verificar disco ou uptime | `./system-health.sh` |
| `create_script.sh` | Cria novos scripts bash com estrutura pronta | `./create_script.sh meu_novo_script` |

---

## 🔧 Requisitos

- **Sistema operacional**: Linux (testado em Ubuntu, Debian, CentOS, Fedora)
- **Bash 4.0+** (padrão na maioria das distros)
- Permissão `sudo` para o script `disk-scanner.sh` (necessário para buscar arquivos com SUID/SGID em todo o sistema)
- Comandos padrão: `top`, `ps`, `df`, `du`, `find`, `free`, `uptime`, `ls`, `stat`, `nano`/`vim` (opcional para edição)

---

## 🚀 Instalação e uso

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/system-monitor-scripts.git
cd system-monitor-scripts
