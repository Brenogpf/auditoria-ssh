#!/bin/bash

# Script de Validação de Hardening
# Verifica se as mitigações foram aplicadas corretamente

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0

check_pass() {
    echo -e "${GREEN}[✓ SUCESSO]${NC} $1"
    ((PASS_COUNT++))
}

check_fail() {
    echo -e "${RED}[✗ FALHA]${NC} $1"
    ((FAIL_COUNT++))
}

# 1. Validação SSH
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config && check_pass "Autenticação SSH por senha desabilitada" || check_fail "Autenticação SSH por senha habilitada"

# 2. Validação Firewall
ufw status | grep -q "Status: active" && check_pass "Firewall está ativo" || check_fail "Firewall está inativo"

# 3. Validação Serviços Inseguros
! systemctl is-active --quiet vsftpd && check_pass "vsftpd está inativo" || check_fail "vsftpd está ativo"
! systemctl is-active --quiet inetutils-inetd && check_pass "telnetd está inativo" || check_fail "telnetd está ativo"

# 4. Validação Política de Senha
dpkg -l | grep -q libpam-pwquality && check_pass "libpam-pwquality está instalado" || check_fail "libpam-pwquality não está instalado"

# 5. Validação Sudo
! grep -q "professor.*NOPASSWD" /etc/sudoers && check_pass "Sudo sem senha removido" || check_fail "Sudo sem senha ainda existe"

# 6. Validação de Credenciais Expostas
! test -f /home/professor/anotacoes.txt && check_pass "Arquivo de credenciais expostas não encontrado" || check_fail "Arquivo de credenciais expostas encontrado"

# Relatório Final

TOTAL=$((PASS_COUNT + FAIL_COUNT))
PERCENTAGE=$((PASS_COUNT * 100 / TOTAL))

echo "-----------------------------------"
echo "Total de testes: $TOTAL"
echo -e "Aprovados: ${GREEN}$PASS_COUNT${NC}, Falhas: ${RED}$FAIL_COUNT${NC}"
echo "Conformidade: $PERCENTAGE%"

exit $FAIL_COUNT
