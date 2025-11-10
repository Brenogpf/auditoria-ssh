# ===================
# Dockerfile base
# ===================

FROM ubuntu:22.04

LABEL maintainer="sua-equipe@universidade.edu"
LABEL description="Imagem base do laboratório de segurança - com sudo, SSH e estrutura de logs"

# Evita prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes e instala utilitários básicos
RUN apt update && apt install -y \
    sudo \
    openssh-server \
    iproute2 \
    rsyslog \
    sshpass \
    nmap \
    whois \
    netcat \
    libpam-pwquality \
 && apt clean && rm -rf /var/lib/apt/lists/*

# Cria estrutura de logs customizada
RUN mkdir -p /var/log/security_lab/ && chmod 755 /var/log/security_lab/

# Cria um usuário padrão para o laboratório 
RUN useradd -m -s /bin/bash aluno && echo "aluno:123456789" | chpasswd && adduser aluno sudo

# Configura SSH básico
RUN mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Define o diretório de trabalho
RUN apt-get update && apt-get install -y sshpass
WORKDIR /root
COPY exploits-safe/exploit.sh /tmp/exploit.sh

# Adicionado para diferenciar os setups
ARG SETUP_SCRIPT
COPY infra/setup_*.sh /root/
COPY validar_hardening.sh /root/
# Durante o build definimos SKIP_NET=1 para evitar que o processo de build tente
# aplicar regras de rede/kernel (iptables/sysctl) — essas operações exigem
# privilégios/capacidades de runtime e falham dentro de um build container.
RUN if [ -n "$SETUP_SCRIPT" ]; then bash "$SETUP_SCRIPT"; fi

# Porta padrão SSH
EXPOSE 22

# Comando padrão: inicia SSH e mantém container ativo
CMD ["/usr/sbin/sshd", "-D"]
