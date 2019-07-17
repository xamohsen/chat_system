FROM ruby:2.5

RUN apt-get update && \
    apt-get install -y nodejs \
    netcat \
    vim \
    --no-install-recommends && \
    apt-cache search mysql-server &&\
    rm -rf /var/lib/apt/lists/*

RUN mkdir /chat_system
WORKDIR /chat_system
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

ENTRYPOINT ["sh", "./config/docker/startup.sh"]
