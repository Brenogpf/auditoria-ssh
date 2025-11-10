# 🛡️ Projeto de Auditoria SSH: De Vulnerável a Fortificado 🛡️

**Um Laboratório Prático de Análise, Exploração e Mitigação de Ameaças de Segurança**

---

## 🎯 O Que é Este Projeto?

Bem-vindo a um campo de treinamento de segurança cibernética! Este repositório é um ambiente de simulação completo, projetado para fins educacionais, onde demonstramos um ciclo de segurança do mundo real:

1.  **🕵️‍♂️ Investigar:** Identificar falhas de segurança em um sistema.
2.  **🔓 Explorar:** Atacar ativamente essas falhas para provar que são um risco real.
3.  **🧱 Fortificar:** Aplicar correções técnicas (*hardening*) para neutralizar as ameaças.
4.  **✅ Validar:** Verificar se as defesas funcionam e se o sistema está seguro.

O objetivo é transformar teoria em prática, mostrando como um sistema vulnerável pode ser comprometido e, mais importante, como protegê-lo de forma eficaz.

---

## 🎬 O Cenário: Incidente no Laboratório

Nossa simulação é baseada em uma história comum e perigosa:

> Em um laboratório universitário, um professor anota suas credenciais de acesso em um arquivo de texto no próprio computador. Um aluno mal-intencionado encontra essa "nota digital", usa as credenciais para acessar o sistema remotamente via SSH e ganha controle total da máquina, acessando provas, notas e outros dados sensíveis.

Este projeto recria esse ambiente com duas máquinas virtuais: a **Vítima** (o computador do professor) e o **Atacante** (o computador do aluno).

---

## 🏗️ Arquitetura do Laboratório

O ambiente é orquestrado com Docker, consistindo em dois contêineres que atuam como máquinas independentes na mesma rede, simulando o ambiente do laboratório.

```
      +-------------------------------------------------+
      |         Rede Isolada do Lab (172.18.0.0/16)     |
      |                                                 |
      | +---------------------+      +----------------+ |
      | |      ATACANTE       |      |     VÍTIMA     | |
      | | (Ubuntu c/ Ferram.) |----->| (Ubuntu 22.04) | |
      | | IP: 172.18.0.3      |      | IP: 172.18.0.2 | |
      | +---------------------+      +----------------+ |
      |                                                 |
      +-------------------------------------------------+
```

---

## 🔑 As 6 Chaves da (In)Segurança

Neste laboratório, a segurança do sistema pode ser quebrada através de 6 vulnerabilidades principais, que exploramos e corrigimos em uma ordem lógica de ataque:

1.  **🔑 Chave 1: Engenharia Social (A Nota Adesiva Digital)**
    *   **A Falha:** Credenciais (usuário e senha) deixadas em um arquivo de texto simples no computador da vítima. É o ponto de partida perfeito para um invasor.

2.  **🔑 Chave 2: A Porta da Frente Aberta (SSH com Senha)**
    *   **A Falha:** O serviço SSH aceita login com senha. Combinado com as credenciais vazadas, o acesso é imediato.

3.  **🔑 Chave 3: Privilégios de Super-Herói (Sudo sem Senha)**
    *   **A Falha:** O usuário comprometido pode executar qualquer comando como superusuário (`root`) sem precisar digitar a senha novamente. O invasor se torna o dono do sistema.

4.  **🔑 Chave 4: Senhas Padronizadas**
    *   **A Falha:** O uso de senhas padrão ou fracas em múltiplos sistemas facilita a exploração, permitindo que um atacante use credenciais conhecidas para obter acesso.

5.  **🔑 Chave 5: Política de Senhas Fraca**
    *   **A Falha:** O sistema não força os usuários a criarem senhas fortes. Isso torna ataques de força bruta muito mais fáceis e rápidos.

6.  **🔑 Chave 6: Sistema sem Hardening**
    *   **A Falha:** O sistema operacional está com suas configurações de fábrica, que não são otimizadas para segurança, deixando brechas que podem ser exploradas.

---

## 🚀 Guia de Batalha: Simulação Passo a Passo

Siga as etapas para executar a simulação completa.

### Pré-requisitos

-   **Docker** e **Docker Compose**
-   **Git**

### Etapa 1: Prepare o Campo de Batalha

Clone o repositório (substitua pelo seu fork, se aplicável) e entre na pasta do laboratório.

```bash
git clone https://github.com/Victor-S-Augusto/auditoria-ssh.git
cd auditoria-ssh/auditoria-ssh-lab
```

### Etapa 2: Construa os Contêineres

Este comando montará as máquinas do Atacante e da Vítima.

```bash
docker-compose up -d --build
```

### Etapa 3: ⚔️ ATAQUE!

Acesse o terminal do atacante e execute o script de exploração.

```bash
# 1. Entre no contêiner do atacante
docker exec -it attacker /bin/bash

# 2. Execute o script de ataque (informando o IP da vítima)
./exploits-safe/exploit.sh 172.18.0.2
```
Durante a execução você verá demonstrações das vulnerabilidades listadas acima; os scripts foram construídos para uso didático em ambiente isolado.

### Etapa 4: 🛡️ DEFESA (Hardening)!

Agora, vamos fortalecer a máquina da vítima.

```bash
# 1. Entre no contêiner da vítima
docker exec -it victim /bin/bash

# 2. Execute o script de hardening com permissão de superusuário
sudo ./infra/setup_victim_modified.sh
```
O script aplicará as correções de segurança previstas nas etapas anteriores. Leia a saída para ver o status de cada mitigação.

### Etapa 5: ✅ VERIFICAÇÃO!

Vamos confirmar que nossas defesas estão funcionando.

1.  **Na máquina da VÍTIMA, rode o script de validação:**
    ```bash
    sudo ./validar_hardening.sh
    ```
    Você verá um relatório de conformidade mostrando que as correções foram aplicadas.

2.  **Na máquina do ATACANTE, tente atacar novamente:**
    ```bash
    # Se você saiu, entre novamente no atacante
    docker exec -it attacker /bin/bash
    
    # Execute o mesmo script de ataque de antes
    ./exploits-safe/exploit.sh 172.18.0.2
    ```
    Agora, os ataques devem falhar. A documentação do laboratório descreve os controles aplicados.

### Etapa 6: Desligue o Laboratório

Quando terminar, desligue e remova os contêineres.

```bash
docker-compose down
```

---

## 📚 Documentação do Projeto

Para uma análise mais aprofundada, consulte os documentos teóricos na pasta `auditoria-ssh-lab/docs/`:

-   **Análise de Riscos e Impactos:** `impacto_institucional.md` e `impacto_humano.md`.
-   **Propostas de Melhoria:** `politica_de_uso_aceitavel.md` e `plano_de_treinamento.md`.

---

## ⚠️ Aviso Ético e Legal

Este projeto é **estritamente para fins educacionais**. O uso das técnicas e scripts aqui apresentados em sistemas para os quais você não tenha autorização explícita é **ilegal** (Art. 154-A do Código Penal Brasileiro) e antiético.

---

## 👥 Autores

- **Victor Augusto Soares de Paula**
- **Breno Giovani Pimenta Ferreira**

**Disciplina:** Segurança da Informação
**Professor:** Roitier Campos

---