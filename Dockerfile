FROM ubuntu:latest

# Configurer les locales
RUN apt update -y && apt upgrade -y && apt install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Installer les outils nécessaires
RUN apt install -y ssh wget unzip curl jq

# Télécharger et installer ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && rm ngrok.zip && mv ngrok /usr/local/bin/ngrok

# Ajouter le token ngrok (assurez-vous que le token est correct)
RUN ngrok config add-authtoken 2qNtOvSgrSPDocCdIRJ6opFcJPi_4Z3uUvTpbj2b6jFeALyHz

# Configurer SSH pour autoriser la connexion root
RUN mkdir /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd

# Créer le script de démarrage
RUN echo "#!/bin/bash\n\
/usr/sbin/sshd &\n\
ngrok tcp 22 > /dev/null &\n\
sleep 5\n\
curl --silent --show-error http://localhost:4040/api/tunnels | jq '.tunnels[0].public_url'" > /start.sh

# Rendre le script exécutable
RUN chmod +x /start.sh

# Exposer les ports nécessaires
EXPOSE 22

# Commande par défaut
CMD ["/bin/bash", "/start.sh"]
