#! /bin/sh

set -m

# wait for database
echo "Wait for database"
until nc -z -v -w30 db 3306
do
  echo "Waiting for database connection..."
  # wait for 5 seconds before check again
  sleep 5
done

echo "Done!! database is ready *_*"

# wait for elastic search
echo "Wait for elastic search"
while ! nc -z elasticsearch 9200
 do
  echo "Waiting for elastic search connection..."
  # wait for 5 seconds before check again
  sleep 5
done


echo "Wait for rabbitMq"
until nc -z -v -w30 rabbitmq 5672
do
  echo "Waiting for rabbitMq connection..."
  # wait for 5 seconds before check again
  sleep 5
done
echo "Done!! rabbitMq is ready *_*"



echo "Wait for redis"
until nc -z -v -w30 redis 6379
do
  echo "Waiting for redis connection..."
  # wait for 5 seconds before check again
  sleep 5
done
echo "Done!! redis is ready *_*"


# check database creation and migration
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate
echo "All is Done! All Services are Up"
#run the server
bundle exec  puma -C config/puma.rb &

echo "Here we Gooooo"
rake sneakers:run

fg %1