#kill -9 $(cat save_ui_pid.txt)
kill -9 $(cat save_rest_pid.txt)
#rm save_ui_pid.txt
rm save_rest_pid.txt
#rm output_ui.log
rm output_rest.log
#kill -9 $(lsof -t -i:8080)
kill -9 $(lsof -t -i:8081)