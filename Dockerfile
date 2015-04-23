FROM debian:latest

MAINTAINER Bjoern Rennhak bjoern@greylon.com

# make sure we don't rely on locally filtered dns
ADD build/docker/resolv.conf /etc/resolv.conf

# make sure the package repository is up to date
RUN printf "deb     http://ftp.uk.debian.org/debian stable main contrib non-free\n" > /etc/apt/sources.list
RUN printf "deb     http://ftp.uk.debian.org/debian wheezy-proposed-updates main contrib non-free\n" >> /etc/apt/sources.list
RUN apt-get update

# House keeping & shell
RUN apt-get install -y apt-utils
RUN apt-get install -y vim screen less zsh iftop htop strace
ADD build/docker/zshrc /root/.zshrc

# Locale
RUN apt-get install -y wamerican locales

# SSH + Keys + Security tweak
RUN apt-get install -y ssh

RUN mkdir /var/run/sshd
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
ADD build/docker/authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/*
RUN chown -Rf root:root /root/.ssh
RUN sed -i.bak 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN rm /etc/ssh/sshd_config.bak

# FIXME: If used as dev env, add id_{dsa|rsa}{|.pub}

RUN apt-get install -y supervisor
ADD build/docker/supervisord.conf /etc/supervisord.conf
EXPOSE 22
CMD ["/usr/local/bin/supervisord","-n"]

# Build env
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y libxslt-dev libxml2-dev
RUN apt-get install -y wget git-core
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev

# Setup Ruby Version Manager
RUN apt-get -y install curl
RUN curl -sSL https://get.rvm.io | bash -s stable

# Setup deploy env
RUN mkdir -p /var/www

# Handle meta files
# ADD .rvmrc /var/www/.rvmrc
# ADD Gemfile /var/www/Gemfile
# ADD Gemfile.lock /var/www/Gemfile.lock

# Setup Ruby VM
# RUN /bin/bash -l -c "rvm requirements"
# RUN /bin/bash -l -c "rvm install 2.1.1"
# RUN /bin/bash -l -c "rvm --create use 2.1.1@retina_project"
# RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
# 
# # Gem specific libs
# RUN apt-get install -y libmagic-dev libmagic1
# RUN apt-get install -y redis-server
# RUN apt-get install -y libxml2 libxml2-dev
# RUN apt-get install -y libxslt1-dev libxslt1.1
# RUN apt-get install -y libmysqlclient-dev libmysqlclient18
# RUN apt-get install -y libmagickcore-dev libmagickwand-dev imagemagick
# 
# 
# # Install project gems
# RUN /bin/bash -l -c "cd /var/www && rvm all do bundle install"


