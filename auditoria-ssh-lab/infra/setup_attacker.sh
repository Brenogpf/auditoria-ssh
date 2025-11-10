#!/bin/bash
# infra/setup_attacker.sh — execute no container attacker

set -e

# Cria wordlist simples (somente para laboratório)
cat > /tmp/wordlist_small.txt <<'WL'
password
aluno1234
Aluno1234
senha
Senha
12345
123456789
Prof1234
WL

echo "Setup attacker completo. Wordlist em /tmp/wordlist_small.txt"