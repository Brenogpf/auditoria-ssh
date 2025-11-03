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
    vim \
    nano \
    net-tools \
    iproute2 \
    iputils-ping \
    curl \
    wget \
    auditd \
    rsyslog \
    systemctl \
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
WORKDIR /root

# Adicionado para diferenciar os setups
ARG SETUP_SCRIPT
COPY setup_*.sh /root/
RUN if [ -n "$SETUP_SCRIPT" ]; then bash "$SETUP_SCRIPT"; fi

# Porta padrão SSH
EXPOSE 22

# Comando padrão: inicia SSH e mantém container ativo
CMD ["/usr/sbin/sshd", "-D"]
