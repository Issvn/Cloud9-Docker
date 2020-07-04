# Build a Docker image based on the cloud9/ws-nodejs Docker image.
FROM ubuntu:18.04

# Enable the Docker container to communicate with AWS Cloud9 by
# installing SSH.
RUN apt-get update && apt-get install -y openssh-server sudo python-minimal locales curl

# Ensure that Node.js is installed.
RUN apt install -y nodejs

# Disable password authentication by turning off the
# Pluggable Authentication Module (PAM).
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config


RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     
# Add the AWS Cloud9 SSH public key to the Docker container.
# This assumes a file named authorized_keys containing the
# AWS Cloud9 SSH public key already exists in the same
# directory as the Dockerfile.
RUN useradd -ms /bin/bash ubuntu -g sudo
RUN mkdir -p /home/ubuntu/.ssh
COPY authorized_keys /home/ubuntu/.ssh/authorized_keys
RUN chown ubuntu /home/ubuntu/.ssh /home/ubuntu/.ssh/authorized_keys && \
chmod 700 /home/ubuntu/.ssh && \
chmod 600 /home/ubuntu/.ssh/authorized_keys
RUN mkdir -p /run/sshd

# Start SSH in the Docker container.
CMD /usr/sbin/sshd -D

# Update the password to a random one for the user ubuntu
RUN echo "ubuntu:ubuntu" | chpasswd

RUN chmod u=rwx,g=rx,o=rx ~

EXPOSE 22
