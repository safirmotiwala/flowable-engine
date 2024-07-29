#!/bin/bash

CODEBASE_NAME=flowable-engine
SOURCE_PATH=~/$CODEBASE_NAME
UI_PORT=8080
REST_PORT=8081

stop_flowable_ui() {
  kill -9 $(cat $SOURCE_PATH/save_ui_pid.txt)
  rm $SOURCE_PATH/save_ui_pid.txt
  rm $SOURCE_PATH/output_ui.log
  kill -9 $(lsof -t -i:$UI_PORT)
}

stop_flowable_rest() {
  kill -9 $(cat $SOURCE_PATH/save_rest_pid.txt)
  rm $SOURCE_PATH/save_rest_pid.txt
  rm $SOURCE_PATH/output_rest.log
  kill -9 $(lsof -t -i:$REST_PORT)
}

#stop_flowable_ui
stop_flowable_rest
