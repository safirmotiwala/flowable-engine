#!/bin/bash

CODEBASE_NAME=flowable-engine
SOURCE_PATH=~/$CODEBASE_NAME

set_env_variables() {
    if [ -f .env ]; then
        while IFS='=' read -r key value; do
            if [[ $key != \#* ]] && [[ -n $key ]]; then
                key=$(echo $key | xargs)
                value=$(echo $value | xargs)
                export "$key=$value"
            fi
        done < .env
        echo -e "${GREEN}${GREEN_CIRCLE}  Environment variables set sucessfully⚡ ${GREEN_NC}"
    else
        echo -e "${RED}🚨 .env file not found ${RED_NC}"
    fi
}

start_postgresql() {
  if [ "$(docker ps -q -f name=postgres-db)" ]; then
      echo "Postgres container is already running."
  else
      if [ "$(docker ps -aq -f status=exited -f name=postgres-db)" ]; then
          echo "Starting existing Postgres container."
          docker start postgres-db
      else
          echo "Creating a new Postgres container."
          docker run -d \
            --name postgres-db \
            -e POSTGRES_DB=flowabledb1 \
            -e POSTGRES_USER=postgres \
            -e POSTGRES_PASSWORD=postgres \
            -p 5432:5432 \
            --network flowable-engine_flowable-network \
            --restart always \
            postgres:latest
      fi
  fi
}

start_server() {
  # Start Flowable UI app

  #cd $SOURCE_PATH/modules/flowable-ui/flowable-ui-app
  #
  ## Start nohup process
  #nohup mvn spring-boot:run > $SOURCE_PATH/output_ui.log 2>&1 &
  #echo $! > $SOURCE_PATH/save_ui_pid.txt
  #
  #echo "Started Flowable UI"

  cd $SOURCE_PATH/modules/flowable-app-rest || exit

  # Start nohup process for running maven in daemon
  nohup mvn spring-boot:run > $SOURCE_PATH/output_rest.log 2>&1 &
  echo $! > $SOURCE_PATH/save_rest_pid.txt

  echo "Started Flowable REST" $SOURCE_PATH/output_rest.log

  sleep 2

  tail -n 100 -f $SOURCE_PATH/output_rest.log
}

#set_env_variables
start_postgresql
echo "Waiting for dependencies to start..."
sleep 5
start_server

