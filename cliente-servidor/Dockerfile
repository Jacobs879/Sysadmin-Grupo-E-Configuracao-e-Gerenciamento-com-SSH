# Usa o Ubuntu mais recente como base
FROM ubuntu:latest

# Atualiza os pacotes e instala o servidor SSH
RUN apt-get update && apt-get install -y openssh-server sudo

# Cria o diretório necessário para o daemon do SSH
RUN mkdir /var/run/sshd

# Cria o usuário 'admin'
RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo admin

# Prepara a pasta SSH do usuário admin e injeta a chave pública
RUN mkdir -p /home/admin/.ssh
COPY id_ed25519_demo.pub /home/admin/.ssh/authorized_keys

# Ajusta as permissões rigorosas que o SSH exige
RUN chown -R admin:root /home/admin/.ssh && \
    chmod 700 /home/admin/.ssh && \
    chmod 600 /home/admin/.ssh/authorized_keys

# Expõe a porta padrão do SSH e inicia o serviço
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
