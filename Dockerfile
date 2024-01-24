FROM debian:10.10

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget curl apache2 -y

RUN wget https://github.com/erebe/wstunnel/releases/download/v9.2.1/wstunnel_9.2.1_linux_amd64.tar.gz
RUN tar -zxvf wstunnel_9.2.1_linux_amd64.tar.gz && chmod +x wstunnel && mv wstunnel /usr/bin/wstunnel
RUN mkdir /run/sshd
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod rewrite
RUN rm /etc/apache2/sites-available/000-default.conf
ADD 000-default.conf /etc/apache2/sites-available
RUN echo 'the scanner node is deploy successful!' >/var/www/html/index.html

RUN mkdir -p ~/.ssh
RUN echo 'wstunnel server ws://0.0.0.0:8989 &' >>/Run.sh
RUN echo 'service apache2 restart' >>/Run.sh

RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkVhN9UuCk+Lz+mrBA/B7rcTWVV8v0FPiNgGMdhDx3wVbToiIVNT2T4lgwve9w8SEjKtmw1OVqBMYp/JMOCax9sk914qeqUMEsto1dobhQ85XzSf0bh/q4P9fUiuSdtZ9G3t1zEgKOuos0lEuHWUFtnIPBBspTQ7Yd9JTF7tFtJ+6GBJG+ZTDG/1K3OwUJ5PTsNlOKX9d+Zn2di7PUQU0/MOtxvJoiITpRydpVc0HJS46Ld7w3GQxXKSgxUDeuqBmf844dkRtmQ2W543Oyy0PijB+dUj/SdFH/itv7Pwq7fCe1P3y8siiz2Ysy4tnPf5K61IQde5hKrrIvnPXpKbP5979E1cLVM4jGwQk7zXDI2QoNRq1xfwuoRstc+lC0xhY0DA1AMlzGsRUQm+fki5n5yU5V8ePnuw5QXBNpmPSyw9+RVK7bdguwF5+bakRN3xqIJjDj61n6W/ePJuI8R5FWTDmkiYnHP5PQlXELw0XY+RdzH/uQQe3ZzDB7ZhixZtM= taroballz@52-0A90441-81.local' >> ~/.ssh/authorized_keys
RUN echo '/usr/sbin/sshd -D' >>/Run.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN chmod 755 /Run.sh

EXPOSE 80
CMD  /Run.sh