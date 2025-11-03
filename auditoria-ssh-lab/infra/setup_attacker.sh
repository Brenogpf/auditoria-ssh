#!/bin/bash
# infra/setup_attacker.sh — execute no container attacker

set -e
apt update
DEBIAN_FRONTEND=noninteractive apt install -y sshpass nmap whois netcat

# Cria wordlist simples (somente para laboratório)
cat > /tmp/wordlist_small.txt <<'WL'
password
aluno1234
Aluno1234
qwerty
123456789
WL

echo "Setup attacker completo. Wordlist em /tmp/wordlist_small.txt"