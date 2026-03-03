# Sysadmin-Grupo-E-Configuracao-e-Gerenciamento-com-SSH

## Integrantes:
• Álex Micaela de Oliveira Fidelis  
• Enzo Diniz Vasconcelos  
• Levi Queiroz de Assunção  
• Victor Jacob Oliveira Rodrigues da Silva  

## Estrutura do Repositório e Descrição dos Arquivos

Este repositório está organizado para fornecer tanto a base teórica exigida para o seminário quanto as demonstrações práticas de configuração, segurança e automação utilizando o protocolo SSH. Abaixo encontra-se a descrição detalhada dos arquivos e diretórios que compõem a entrega.

### Arquivos na Raiz

* **`README.md`**: Arquivo principal de apresentação, contendo a identificação da equipe e o mapeamento de todos os artefatos do projeto.
* **`configuracao_e_gerenciamento_com_ssh.pdf`**: Conjunto de slides utilizado na apresentação oficial do seminário. O documento aborda o contexto histórico, o funcionamento do `ssh-agent`, regras de hardening e exemplos de *port forwarding* (Local, Remote e Dynamic).
* **`tutorial_hardening.md`**: Um guia de laboratório prático focado em segurança. Ele detalha o passo a passo de como aplicar técnicas de *hardening* em um servidor SSH rodando no WSL, demonstrando como alterar a porta padrão, desabilitar o acesso direto do usuário *root* e bloquear a autenticação por senha para mitigar ataques de força bruta.

### Diretório `/cliente-servidor`

Este diretório concentra todos os arquivos necessários para a simulação prática focada em **Automação e Administração Remota via SSH**.

* **`simula_cliente_servidor.md`**: Documento de instruções detalhadas que orienta o usuário sobre como gerar as chaves criptográficas necessárias, instanciar o servidor alvo via Docker e executar a automação de forma segura.
* **`Dockerfile`**: Arquivo de Infraestrutura como Código (IaC) utilizado para construir o contêiner que atua como o servidor remoto da demonstração. Ele utiliza uma imagem do Ubuntu, instala o servidor SSH e injeta automaticamente a chave pública no usuário administrador.
* **`relatorio_saude.sh`**: Script em formato Bash que executa o laço de automação da demonstração. Ele conecta-se remotamente aos servidores listados para extrair dados críticos de saúde do sistema (Uptime, uso de CPU, Memória RAM e armazenamento) sem a necessidade de senhas interativas.
* **`servidores.txt`**: Arquivo de texto auxiliar lido pelo script de automação. Ele contém a lista dos *aliases* dos servidores alvo da infraestrutura, possuindo o registro para o ambiente de demonstração `srv-demo`.
