# Análise Forense Digital e Resposta a Incidentes

## 1. Cadeia de Custódia

A cadeia de custódia é um processo fundamental na forense digital para garantir a integridade e a autenticidade das evidências digitais desde a sua coleta até a sua apresentação em um tribunal. A metodologia para garantir a cadeia de custódia envolve os seguintes passos:

1.  **Identificação e Coleta:** A primeira etapa é identificar as fontes de evidências digitais, como discos rígidos, logs de servidores, dispositivos de rede, etc. A coleta deve ser feita por pessoal treinado, utilizando ferramentas forenses que garantam a não alteração dos dados originais. É crucial a criação de uma cópia bit a bit (imagem forense) do disco rígido original.

2.  **Hashing:** Após a coleta, um hash (MD5, SHA-256) da imagem forense é gerado. O hash é uma assinatura digital única que representa o conteúdo do disco. Qualquer alteração na cópia, por menor que seja, resultará em um hash diferente. O hash da imagem forense deve ser comparado com o hash do disco original para garantir a integridade da cópia.

3.  **Documentação:** Todos os passos da investigação devem ser meticulosamente documentados. Isso inclui:
    *   Data e hora da coleta.
    *   Pessoas envolvidas na coleta e análise.
    *   Ferramentas e softwares utilizados.
    *   Hashes gerados.
    *   Qualquer anomalia encontrada durante o processo.

4.  **Armazenamento Seguro:** As evidências digitais devem ser armazenadas em um local seguro, com acesso restrito, para evitar adulterações.

5.  **Análise:** A análise forense deve ser feita na cópia da evidência, nunca no original. Todas as descobertas devem ser documentadas.

6.  **Apresentação:** As evidências e a documentação da cadeia de custódia são apresentadas em um relatório final, que pode ser utilizado em um processo judicial.

## 2. Análise de Logs

Os logs são registros de eventos que ocorrem em um sistema ou rede. Em uma investigação de incidente, os logs são cruciais para reconstruir a linha do tempo do ataque e identificar o invasor.

### Logs Cruciais para a Investigação

*   **/var/log/auth.log (ou /var/log/secure em sistemas RHEL/CentOS):** Contém informações sobre autenticação de usuários, incluindo tentativas de login (bem-sucedidas e malsucedidas) via SSH.
*   **/var/log/syslog (ou /var/log/messages):** Contém mensagens gerais do sistema, que podem indicar atividades suspeitas.
*   **Logs de firewall (se configurado):** Podem mostrar conexões de rede de e para o sistema.
*   **Logs de aplicações (ex: web server):** Podem revelar vulnerabilidades exploradas em aplicações.

### Comandos e Ferramentas para Análise de Logs

A seguir, alguns comandos úteis para analisar os logs em um sistema Linux:

*   `grep`: Para buscar por padrões específicos nos arquivos de log.
*   `awk`: Para processar e formatar a saída dos logs.
*   `sort`, `uniq`, `wc`: Para contar e classificar as ocorrências.
*   `last`, `lastb`: Para listar os últimos logins e tentativas de login malsucedidas.
