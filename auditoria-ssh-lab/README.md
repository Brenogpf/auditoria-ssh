# Auditoria SSH Lab

Este projeto tem como objetivo simular um ambiente vulnerável para fins de auditoria de segurança SSH. Ele inclui scripts para configurar máquinas virtuais (atacante e vítima) com diversas vulnerabilidades intencionais, bem como ferramentas para explorar e validar a mitigação dessas vulnerabilidades.

## Estrutura do Projeto

- `docker-compose.yml`: Define os serviços Docker para o ambiente de laboratório.
- `infra/`: Contém os scripts para configurar as máquinas (Dockerfile, setup_attacker.sh, setup_victim.sh, setup_victim_modified.sh).
- `exploits-safe/`: Contém scripts para demonstrar a exploração das vulnerabilidades.
- `validar_hardening.sh`: Script para validar se as mitigações de hardening foram aplicadas corretamente.
- `docs/`: Documentação detalhada sobre os impactos das vulnerabilidades, plano de treinamento e política de uso aceitável.
- `forensic/`: Scripts e documentação para análise forense.

## Vulnerabilidades Implementadas (e Mitigações)

Este laboratório simula as seguintes vulnerabilidades:

1.  **Engenharia Social (Credenciais Expostas):** Credenciais de acesso anotadas em local de fácil acesso.
    *   *Mitigação:* Remoção do arquivo de anotações.
2.  **SSH com Senha Fraca/Padrão:** Permissão de autenticação via senha e uso de senhas fáceis de adivinhar (atualmente "123456789").
    *   *Mitigação:* Desativação da autenticação por senha e uso de chaves SSH.
3.  **Sudo sem Senha:** Usuário com privilégios de sudo sem a necessidade de senha.
    *   *Mitigação:* Remoção da entrada NOPASSWD do sudoers para o usuário.
4.  **Política de Senhas Fraca:** Ausência de uma política de senhas robusta, permitindo senhas simples.
    *   *Mitigação:* Implementação de `libpam-pwquality` para forçar senhas fortes e expiração da senha do usuário `professor` para que ele seja obrigado a alterá-la no próximo login.
5.  **Sistema sem Hardening:** Ausência de configurações de segurança básicas no sistema operacional.
    *   *Mitigação:* Aplicação de parâmetros de hardening via `sysctl`.

## Como Usar

1.  **Construir e Iniciar o Ambiente:**
    ```bash
    docker-compose up --build
    ```
2.  **Acessar a Máquina Atacante:**
    ```bash
    docker exec -it attacker bash
    ```
3.  **Executar Exploits (na máquina atacante):**
    ```bash
    ./exploits-safe/exploit.sh <IP_DA_VITIMA>
    ```
4.  **Aplicar Hardening (na máquina vítima):**
    ```bash
    docker exec -it victim bash
    /infra/setup_victim_modified.sh
    ```
5.  **Validar Hardening (na máquina atacante ou vítima):**
    ```bash
    ./validar_hardening.sh
    ```

## Contribuição

Sinta-se à vontade para contribuir com novas vulnerabilidades, exploits ou melhorias nas mitigações e documentação.

## Licença

Este projeto está licenciado sob a licença MIT.
