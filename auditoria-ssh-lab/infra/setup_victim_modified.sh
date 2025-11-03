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

#!/bin/bash
# setup_victim_modified.sh

# --- MITIGAÇÃO V#1: HARDENING SSH ---
echo "--- 1. Securing SSH Configuration ---"
# Secure SSH configuration
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
# Adicionar outras diretivas de segurança
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
service ssh restart
echo "SSH secured."

# --- MITIGAÇÃO V#2: FIREWALL ---
echo "--- 2. Enabling Firewall ---"
# Enable firewall
ufw allow ssh
ufw deny 21/tcp # FTP
ufw deny 23/tcp # Telnet
ufw --force enable
echo "Firewall enabled and configured."

# --- MITIGAÇÃO V#3: DESABILITAR SERVIÇOS INSEGUROS ---
echo "--- 3. Disabling Insecure Services ---"
systemctl stop vsftpd
systemctl disable vsftpd
systemctl stop inetutils-inetd
systemctl disable inetutils-inetd
echo "Insecure services (vsftpd, telnetd) disabled."

# --- MITIGAÇÃO V#4: POLÍTICA DE SENHAS ---
echo "--- 4. Enforcing Strong Password Policy ---"
apt-get install -y libpam-pwquality
cat > /etc/security/pwquality.conf <<EOF
minlen = 12
minclass = 3
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF
echo "Strong password policy enforced."

# --- MITIGAÇÃO V#5: REMOVER PRIVILÉGIOS EXCESSIVOS ---
echo "--- 5. Removing Excessive Privileges ---"
sed -i '/professor.*NOPASSWD/d' /etc/sudoers
echo "Passwordless sudo for 'professor' removed."

# --- MITIGAÇÃO V#6: REMOÇÃO DE CREDENCIAIS EXPOSTAS ---
echo "--- 6. Removing Exposed Credentials ---"
rm -f /home/professor/anotacoes.txt
echo "Exposed credentials file removed."

# --- MITIGAÇÃO V#7: HARDENING DO SO ---
echo "--- 7. Applying OS Hardening ---"
cat > /etc/sysctl.d/99-hardening.conf <<EOF
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_syncookies = 1
kernel.randomize_va_space = 2
EOF
sysctl -p
echo "OS hardening parameters applied."

# (Optional) Example of removing a suspicious user
# userdel -r alunoperturbador

echo "--- Hardening script complete. ---"