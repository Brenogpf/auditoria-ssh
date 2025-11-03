#!/bin/bash

# Script de Validação de Hardening
# Verifica se as mitigações foram aplicadas corretamente

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0

check_pass() {
    echo -e "${GREEN}[✓ PASS]${NC} $1"
    ((PASS_COUNT++))
}

check_fail() {
    echo -e "${RED}[✗ FAIL]${NC} $1"
    ((FAIL_COUNT++))
}

# 1. Validação SSH
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config && check_pass "SSH password auth disabled" || check_fail "SSH password auth enabled"

# 2. Validação Firewall
ufw status | grep -q "Status: active" && check_pass "Firewall is active" || check_fail "Firewall is inactive"

# 3. Validação Serviços Inseguros
! systemctl is-active --quiet vsftpd && check_pass "vsftpd is inactive" || check_fail "vsftpd is active"
! systemctl is-active --quiet inetutils-inetd && check_pass "telnetd is inactive" || check_fail "telnetd is active"

# 4. Validação Política de Senha
dpkg -l | grep -q libpam-pwquality && check_pass "libpam-pwquality is installed" || check_fail "libpam-pwquality is not installed"

# 5. Validação Sudo
! grep -q "professor.*NOPASSWD" /etc/sudoers && check_pass "Passwordless sudo removed" || check_fail "Passwordless sudo still exists"

# 6. Validação de Credenciais Expostas
! test -f /home/professor/anotacoes.txt && check_pass "Exposed credentials file not found" || check_fail "Exposed credentials file found"

# Relatório Final

TOTAL=$((PASS_COUNT + FAIL_COUNT))
PERCENTAGE=$((PASS_COUNT * 100 / TOTAL))

echo "-----------------------------------"
echo "Total tests: $TOTAL"
echo -e "Passed: ${GREEN}$PASS_COUNT${NC}, Failed: ${RED}$FAIL_COUNT${NC}"
echo "Compliance: $PERCENTAGE%"

exit $FAIL_COUNT
