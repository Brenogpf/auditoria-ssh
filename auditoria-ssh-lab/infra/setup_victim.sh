#!/bin/bash
# infra/setup_victim.sh — executa dentro do container victim como root

set -e

# cria usuário "professor" com senha fraca
useradd -m -s /bin/bash professor
echo "professor:Prof1234" | chpasswd

# instala ssh server
apt update
DEBIAN_FRONTEND=noninteractive apt install -y openssh-server rsyslog sshpass

# garante diretórios
mkdir -p /var/run/sshd

# configura sshd para permitir password (vulnerável para simulação)
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
cat >/etc/ssh/sshd_config <<'EOF'
Port 22
PermitRootLogin no
PasswordAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
PermitEmptyPasswords no
MaxAuthTries 6
AllowUsers professor
EOF

# Reinicia o SSH
service ssh restart
service rsyslog restart

# Instala servicos inseguros adicionais
apt-get install -y vsftpd telnetd

# Configure sudo for passwordless privilege escalation
echo "professor ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Start insecure services
service vsftpd restart
service inetutils-inetd restart

# VULNERABILIDADE DE ENGENHARIA SOCIAL: Credenciais expostas
cat > /home/professor/anotacoes.txt <<'EOL'
Lembrete:
Usuario: professor
Senha: Prof1234
IP da Maquina: 172.17.0.2
EOL
chown professor:professor /home/professor/anotacoes.txt

# Gera logs para analise forense
sshpass -p "wrongpassword" ssh -o StrictHostKeyChecking=no professor@localhost || echo "Login falhou como esperado"
sshpass -p "Prof1234" ssh -o StrictHostKeyChecking=no professor@localhost "echo 'Login bem sucedido'"

echo "Setup victim completo. Usuário: professor / senha: Prof1234"