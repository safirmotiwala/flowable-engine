#!/bin/bash

CODEBASE_NAME=flowable-engine

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

  #cd ~/$CODEBASE_NAME/flowable-engine-flowable-6.8.1/modules/flowable-ui/flowable-ui-app
  #
  ## Start nohup process
  #nohup mvn spring-boot:run > ~/$CODEBASE_NAME/output_ui.log 2>&1 &
  #echo $! > ~/$CODEBASE_NAME/save_ui_pid.txt
  #
  #echo "Started Flowable UI"

  cd ~/$CODEBASE_NAME/flowable-engine-flowable-6.8.1/modules/flowable-app-rest || exit

  # Start nohup process for running maven in daemon
  nohup mvn spring-boot:run > ~/$CODEBASE_NAME/output_rest.log 2>&1 &
  echo $! > ~/$CODEBASE_NAME/save_rest_pid.txt

  echo "Started Flowable REST"
}

set_env_variables
start_postgresql
echo "Waiting for dependencies to start..."
sleep 5
start_server

