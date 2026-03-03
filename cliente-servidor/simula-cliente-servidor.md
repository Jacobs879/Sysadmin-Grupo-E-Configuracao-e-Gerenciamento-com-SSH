# Instruções para Execução da Simulação Cliente-Servidor via SSH

Este documento detalha os procedimentos necessários para executar a simulação prática de automação e administração remota. Presume-se que o terminal esteja aberto no diretório `cliente-servidor` e que os arquivos `Dockerfile`, `relatorio_saude.sh` e `servidores.txt` já estejam presentes no local.

Siga os passos abaixo rigorosamente na ordem apresentada.

## 1. Geração e Configuração da Identidade SSH

O primeiro passo consiste em criar a base de segurança (o par de chaves criptográficas) e carregá-la na memória para permitir a automação sem a exigência de senhas interativas.

Gere a chave SSH utilizando o algoritmo Ed25519:

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_demo

```

*(Observação: Ao ser questionado sobre a "passphrase", pressione `Enter` duas vezes para deixá-la em branco, facilitando a execução do script automatizado).*

Inicie o gerenciador de chaves em segundo plano (`ssh-agent`):

```bash
eval "$(ssh-agent -s)"

```

Adicione a chave privada recém-criada ao agente:

```bash
ssh-add ~/.ssh/id_ed25519_demo

```

Copie a chave pública para o diretório atual (`cliente-servidor`). Este passo é crucial, pois o arquivo será injetado no servidor durante a sua construção:

```bash
cp ~/.ssh/id_ed25519_demo.pub .

```

## 2. Provisionamento do Servidor Alvo (Docker)

Com a chave pública no diretório, o próximo passo é utilizar o Docker para construir e iniciar o ambiente que simulará o servidor remoto.

Construa a imagem do servidor a partir do `Dockerfile`:

```bash
docker build -t ssh-server-demo .

```

Inicie o contêiner em segundo plano, mapeando a porta 22 do servidor para a porta 2222 da máquina local:

```bash
docker run -d -p 2222:22 --name meu_servidor ssh-server-demo

```

## 3. Execução da Automação Remota

Com o servidor em execução e a infraestrutura de chaves devidamente configurada, proceda com a execução do script administrativo.

Conceda permissão de execução ao arquivo do script:

```bash
chmod +x relatorio_saude.sh

```

Execute o script para extrair o relatório de saúde do servidor alvo:

```bash
./relatorio_saude.sh

```

O terminal exibirá imediatamente as métricas de uso de CPU, memória RAM e espaço em disco do servidor remoto, demonstrando a eficácia do uso do protocolo SSH para tarefas de automação em escala.
