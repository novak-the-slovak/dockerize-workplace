# Use the official Ubuntu 16.04 LTS image
FROM ubuntu:16.04

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    sudo \
    curl \
    build-essential \
    libssl-dev

# Install NVM (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Set up NVM environment variables
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 6.17.1

# Install Node.js v6
RUN . "$NVM_DIR/nvm.sh" && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION
# Add NVM environment variables to the shell configuration
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# Install MongoDB 3.4.2
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    sudo apt-get update && \
    sudo apt-get install -y mongodb-org=3.4.2 mongodb-org-server=3.4.2 mongodb-org-shell=3.4.2 mongodb-org-mongos=3.4.2 mongodb-org-tools=3.4.2 && \
    echo "mongodb-org hold" | sudo dpkg --set-selections && \
    echo "mongodb-org-server hold" | sudo dpkg --set-selections && \
    echo "mongodb-org-shell hold" | sudo dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | sudo dpkg --set-selections && \
    echo "mongodb-org-tools hold" | sudo dpkg --set-selections
    
# Install Redis 3.2.8
RUN wget http://download.redis.io/releases/redis-3.2.8.tar.gz && \
    tar xzf redis-3.2.8.tar.gz && \
    cd redis-3.2.8 && \
    make && \
    make install && \
    cd .. && \
    rm -rf redis-3.2.8 redis-3.2.8.tar.gz

# Installing more necessary dev packages
RUN apt-get install -y \
    git \
    vim \
    htop

# Set the working directory
WORKDIR /root

# Provide a command to keep the container running
CMD ["bash"]
