# syntax=docker/dockerfile:1
# for Shopify app dev
FROM debian:bullseye-slim
# add to system
RUN apt-get update && apt-get install -y --no-install-recommends curl wget ca-certificates build-essential libssl-dev zlib1g-dev libreadline-dev sqlite3 libsqlite3-dev procps unzip git libpq-dev postgresql-client sudo vim gcc g++ make && rm -rf /var/lib/apt/lists/*

# install standard ruby 3.1
RUN curl -o /tmp/ruby.tar.gz https://cache.ruby-lang.org/pub/ruby/3.1/ruby-3.1.2.tar.gz && tar xvf /tmp/ruby.tar.gz -C /tmp && cd /tmp/ruby-3.1.2 && ./configure && make && make install && make clean
RUN rm -f /tmp/ruby.tar.gz && rm -rf /tmp/ruby-3.1.2

# install needed gems
RUN gem update bundler
RUN bundle init \
    && bundle add rails \
    && bundle add sqlite3-ruby \
    && bundle add shopify-cli \
    && bundle add shopify_app \
    && bundle add dotenv-rails --group "development,test"

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get update && apt-get install -y nodejs  && rm -rf /var/lib/apt/lists/*

# update npm
RUN npm install -g npm@latest

# install yarn
RUN npm install --global yarn

# install ngrok
RUN curl -o /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip && unzip /tmp/ngrok.zip -d /bin

# set working directory
WORKDIR /usr/dev

# prepare git
RUN git config --global user.email "developer@fairknowe.com"
RUN git config --global user.name "Fairknowe Developer"

# create user
ARG USERNAME=developer
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --system --create-home --no-log-init --uid $USER_UID --gid $USER_GID -G sudo --shell /bin/bash -K PASS_MAX_DAYS=-1 -p $(openssl passwd -1 $USERNAME) $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown -R $USERNAME /usr \
    && chmod -R 0754 /usr

# set startup user
USER $USERNAME
# add ngrok token
COPY ./ngrok.yml /home/$USERNAME/.ngrok2/ngrok.yml
# yarn init
RUN yarn init -y
# set shell
RUN echo PS1=\"\\W $ \" >> ~/.bashrc
