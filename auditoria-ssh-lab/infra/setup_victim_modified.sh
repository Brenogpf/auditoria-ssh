#!/bin/bash
# infra/setup_victim.sh — execute dentro do container victim como root

set -e

# cria usuário "professor" com senha fraca (simulação)
useradd -m -s /bin/bash professor
echo "professor:Prof1234" | chpasswd

# instala ssh server
apt update
DEBIAN_FRONTEND=noninteractive apt install -y openssh-server

# garante diretórios
mkdir -p /var/run/sshd

# configura sshd para permitir password (intencionalmente vulnerável para simulação)
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

echo "Setup victim completo. Usuário: professor / senha: Prof1234"

# --- MITIGAÇÃO V#1: HARDENING SSH ---
echo "--- 1. Protegendo a configuração SSH ---"
# Secure SSH configuration
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config || true
# Adicionar outras diretivas de segurança de forma idempotente
grep -q '^PermitRootLogin no' /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config
grep -q '^PubkeyAuthentication yes' /etc/ssh/sshd_config || echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
grep -q '^MaxAuthTries' /etc/ssh/sshd_config || echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart || true
echo "SSH seguro!."

# --- MITIGAÇÃO V#2: FIREWALL ---
echo "--- 2. Habilitando Firewall ---"
if [ "$SKIP_NET" != "1" ]; then
	# Enable firewall (only if networking modifications are allowed)
	apt-get update && apt-get install -y ufw || true
	ufw allow ssh || true
	ufw deny 21/tcp || true # FTP
	ufw deny 23/tcp || true # Telnet
	ufw --force enable || true
	echo "Firewall habilitado e configurado."
else
	echo "SKIP_NET=1: Pulando configuração de firewall/iptables/sysctl (build-time)."
fi

# --- MITIGAÇÃO V#3: DESABILITAR SERVIÇOS INSEGUROS ---
echo "--- 3. Desabilitando Serviços inseguros ---"
pkill vsftpd || true
pkill inetd || true
echo "Serviços inseguros(vsftpd, telnetd) desabilitados."

# --- MITIGAÇÃO V#4: POLÍTICA DE SENHAS ---
echo "--- 4. Implementar uma política de senhas fortes ---"
apt-get install -y libpam-pwquality || true
cat > /etc/security/pwquality.conf <<EOF
minlen = 12
minclass = 3
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF
echo "Política de senhas fortes em vigor."

# --- MITIGAÇÃO V#5: REMOVER PRIVILÉGIOS EXCESSIVOS ---
echo "--- 5. Removendo Privilegios Excessivos ---"
sed -i '/professor.*NOPASSWD/d' /etc/sudoers || true
echo "Sudo sem senha para 'professor' removido."

# --- MITIGAÇÃO V#6: REMOÇÃO DE CREDENCIAIS EXPOSTAS ---
echo "--- 6. Removendo Credenciais Expostas ---"
rm -f /home/professor/anotacoes.txt || true
echo "Arquivo com credenciais removido."

# --- MITIGAÇÃO V#7: HARDENING DO SO ---
echo "--- 7. Aplicando Hardening no Sistema Operacional ---"
cat > /etc/sysctl.d/99-hardening.conf <<EOF
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_syncookies = 1
kernel.randomize_va_space = 2
EOF
if [ "$SKIP_NET" != "1" ]; then
	# sysctl may be unavailable or read-only during image build; guard it
	sysctl -p || echo "sysctl falhou (possivelmente read-only durante build); pulei." 
else
	echo "SKIP_NET=1: Pulando aplicação de sysctl durante o build."
fi
echo "Parametros de hardening aplicados no SO (quando aplicável)."
echo "--- Script de Hardening completo. ---"