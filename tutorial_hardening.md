# Tutorial Prático: Hardening e Boas Práticas de SSH

Este tutorial demonstra como aplicar práticas de *hardening* (endurecimento de segurança) num servidor SSH e como validar a eficácia dessas configurações na prática. 

Para facilitar a reprodução e evitar alterações nas configurações principais da máquina do utilizador, este laboratório utiliza o **WSL (Windows Subsystem for Linux)** a atuar como "Servidor", enquanto o Windows (através do PowerShell) atuará como a máquina "Cliente" ou "Atacante".

## Pré-requisitos
* Sistema operacional Windows com WSL instalado.
* Windows Terminal.
* Privilégios de administrador (sudo) no ambiente WSL.

---

## Passo 1: Preparação do Servidor (Ambiente WSL)

Abra o terminal do WSL e instale o SSH.

```bash
# Atualizar repositórios e instalar o OpenSSH Server
sudo apt update
sudo apt install openssh-server
```

Antes de qualquer alteração, é uma boa prática criar uma cópia de segurança da configuração original.

### Criar backup do ficheiro sshd_config
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
```

---

## Passo 2: Aplicação do Hardening

Abra o arquivo de configuração do servidor SSH com um editor de texto. 

```bash
sudo vim /etc/ssh/sshd_config
```

Localize e altere as seguintes configurações para aplicar as regras de segurança. (Remova o símbolo # no início da linha, caso exista).

### 1. Redução da Superfície de Ataque
### Altera a porta padrão para evitar scripts automatizados e conflitos com o Windows

```bash
Port 2222
```

### 2. Gerenciamento de Identidade e Acesso
### Bloqueia o acesso direto do superutilizador (root)

```bash
PermitRootLogin no
```

### 3. Autenticação Forte
### Desativa a autenticação por palavra-passe (vulnerável a brute-force)

```bash
PasswordAuthentication no
```

### Exige autenticação por chaves criptográficas

```bash
PubkeyAuthentication yes
```

salve o arquivo e reinicie o ssh para aplicar as novas regras:
 

```bash
sudo service ssh restart
```

---

## Passo 3: Configuração do Cliente (Ambiente Windows)

Abra uma nova janela do PowerShell no Windows. Vamos gerar um par de chaves criptográficas modernas (Ed25519) para o acesso legítimo.
  

### Gerar a chave Ed25519

```bash
ssh-keygen
```

Agora, precisamos de exportar a chave pública recém-criada para o servidor (WSL), autorizando o nosso acesso.

Nota: O comando abaixo copia a chave diretamente. Altere se necessário caso o seu utilizador no WSL seja diferente do utilizador do Windows.
  

### Enviar a chave pública para o ficheiro authorized_keys no WSL

```bash
cat ~/.ssh/id_ed25519.pub | wsl -e sh -c "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

---

## Passo 4: Demonstração e Validação (O Teste)

Para provar que o hardening é eficaz, divida o seu ecrã em duas partes:

    À esquerda (PowerShell): O terminal do cliente/atacante.

    À direita (WSL): O terminal do servidor.

No terminal do servidor (WSL), inicie a monitorização dos registos de autenticação em tempo real:
 

```bash
sudo tail -f /var/log/auth.log
```

No terminal do cliente (PowerShell), execute os seguintes testes:
### Teste 1: Bloqueio do utilizador Root

Tente aceder ao servidor utilizando o utilizador root.
  

```bash
ssh root@localhost -p 2222
```

    Resultado Esperado: Conexão negada imediatamente. No log do servidor, verá o registo da tentativa bloqueada, provando que a diretiva PermitRootLogin no está ativa.

### Teste 2: Bloqueio de ataques de dicionário (Palavra-passe)

Tente aceder com o seu utilizador legítimo, mas forçando o método de palavra-passe (simulando um atacante sem a chave criptográfica). Substitua seu_utilizador_wsl pelo seu nome de utilizador no Linux.
  

```bash
ssh -o PubkeyAuthentication=no seu_utilizador_wsl@localhost -p 2222
```

    Resultado Esperado: A conexão falha com a mensagem Permission denied (publickey). O servidor recusa-se a pedir a palavra-passe, mitigando totalmente ataques de força bruta, validando o PasswordAuthentication no.

### Teste 3: Acesso Seguro Legítimo

Faça a ligação padrão, que utilizará automaticamente a chave Ed25519 previamente partilhada.
  

```bash
ssh seu_utilizador_wsl@localhost -p 2222
```

    Resultado Esperado: Acesso concedido instantaneamente de forma segura. O log do servidor registará o sucesso da autenticação via chave pública.


***

Este ficheiro cobre todos os aspetos técnicos e a validação prática. Se a tua equipa
