FROM ruby:2.5
# Install plugin
RUN apt-get update -qq && apt-get install -y build-essential vim
# Install mysql
RUN apt-get install -y default-libmysqlclient-dev
# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
# Clears out the local repository of retrieved package files
RUN apt-get -q clean

RUN mkdir /chat-app
WORKDIR /chat-app
COPY Gemfile /chat-app/Gemfile
COPY Gemfile.lock /chat-app/Gemfile.lock
ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler
RUN bundle install
COPY . /chat-app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]