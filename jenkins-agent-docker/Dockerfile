FROM jenkins/inbound-agent:latest
USER root

# Biarkan Jenkins user mengakses Docker socket
RUN groupadd -g 989 docker \
 && usermod -aG docker jenkins

# Pasang Docker CLI
RUN apt-get update \
 && apt-get install -y curl \
 && curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.0.tgz \
     | tar zxvf - --strip-components=1 -C /usr/local/bin docker/docker \
 && chmod +x /usr/local/bin/docker \
 && apt-get clean

USER jenkins
