#!/bin/bash
# infra/setup_victim.sh — Configura o container da vítima com vulnerabilidades intencionais.

set -e

echo "Iniciando configuração do container da vítima com vulnerabilidades..."

# Cria um usuário "professor" com senha fraca e anota as credenciais em um arquivo de texto.
useradd -m -s /bin/bash professor
echo "professor:Prof1234" | chpasswd
cat > /home/professor/anotacoes.txt <<'EOL'
Lembrete:
Usuario: professor
Senha: Prof1234
IP da Maquina: 172.17.0.2
EOL
chown professor:professor /home/professor/anotacoes.txt
echo "Vulnerabilidade 'Engenharia Social' configurada: Credenciais em /home/professor/anotacoes.txt"

# Instala pacotes essenciais para o SSH e outros serviços
apt update
DEBIAN_FRONTEND=noninteractive apt install -y openssh-server rsyslog sshpass vsftpd telnetd

# Garante que o diretório para o SSH esteja presente
mkdir -p /var/run/sshd

# Configura o SSH para permitir autenticação por senha, tornando-o vulnerável.
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
/etc/init.d/ssh restart
echo "Vulnerabilidade 'SSH com Senha' configurada: PasswordAuthentication ativado."

# Configura o usuário 'professor' para ter escalonamento de privilégios sem senha.
echo "professor ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Vulnerabilidade 'Sudo sem Senha' configurada para o usuário 'professor'."

# Instala e inicia serviços inseguros como FTP e Telnet.
echo "telnet stream tcp nowait root /usr/sbin/tcpd /usr/sbin/in.telnetd" > /etc/inetd.conf
/usr/sbin/inetd

# Configura e inicia o vsftpd
echo "listen=YES" >> /etc/vsftpd.conf
/usr/sbin/vsftpd &

echo "Vulnerabilidade 'Serviços Inseguros' configurada: FTP e Telnet ativos."

# O sistema não terá firewall ativo por padrão. (Nenhuma ação necessária aqui, apenas a ausência de configuração de firewall)
echo "Vulnerabilidade 'Firewall Desativado': Nenhum firewall configurado."

# Nenhuma política de senhas fortes será aplicada. (Nenhuma ação necessária aqui)
echo "Vulnerabilidade 'Política de Senhas Fraca': Nenhuma política de senhas fortes aplicada."

# Nenhuma configuração de hardening de SO será aplicada. (Nenhuma ação necessária aqui)
echo "Vulnerabilidade 'Sistema sem Hardening': Nenhuma configuração de hardening aplicada."

# Gera logs para análise forense (simulação de tentativas de login)
sshpass -p "wrongpassword" ssh -o StrictHostKeyChecking=no professor@localhost || echo "Login falhou como esperado (para logs)"
sshpass -p "Prof1234" ssh -o StrictHostKeyChecking=no professor@localhost "echo 'Login bem sucedido (para logs)'"

echo "Configuração do container da vítima concluída. Usuário: professor / senha: Prof1234"