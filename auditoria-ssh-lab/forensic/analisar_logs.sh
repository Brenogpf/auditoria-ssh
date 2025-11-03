#!/bin/bash
# analisar_logs.sh - Script para análise de logs de autenticação

LOG_FILE="/var/log/auth.log"

echo "Analisando o arquivo de log: $LOG_FILE"
echo "========================================"

# 1. Extrair tentativas de login bem-sucedidas
echo "\n[+] Tentativas de login bem-sucedidas:"
grep "Accepted password for professor" "$LOG_FILE" | awk '{print "Data: " $1 " " $2 ", Hora: " $3 ", Usuário: " $9 ", IP de Origem: " $11}'

# 2. Extrair tentativas de login malsucedidas
echo "\n[+] Tentativas de login malsucedidas:"
grep "Failed password for professor" "$LOG_FILE" | awk '{print "Data: " $1 " " $2 ", Hora: " $3 ", Usuário: " $9 ", IP de Origem: " $11}'

# 3. Identificar os endereços IP que tentaram acessar o sistema
echo "\n[+] Endereços IP que tentaram acesso:"
grep "sshd" "$LOG_FILE" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort | uniq -c | sort -nr

# 4. Resumo de atividades por usuário
echo "\n[+] Resumo de atividades por usuário:"
last

echo "\n[+] Resumo de tentativas de login falhas:"
lastb

echo "\n========================================"
echo "Análise de logs concluída."
