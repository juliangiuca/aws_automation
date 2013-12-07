#!/bin/bash 
function remove_pid_file {
  rm /data/APP_NAME/shared/tmp/pids/unicorn.pid
}

function start_unicorn {
  echo "starting unicorn"
  bundle exec unicorn -c /data/APP_NAME/current/config/unicorn_config.rb -E production >> /data/APP_NAME/shared/logs/unicorn.log 2>&1
}

while true; do
  # If the PID file exists
  if [ -f /data/APP_NAME/shared/tmp/pids/unicorn.pid ]; then
    PID=`cat /data/APP_NAME/shared/tmp/pids/unicorn.pid`;
    # If the PID is running
    if [ ! -d /proc/$PID ]; then
      # The PID file exists, but the process isn't running
      echo "The pid file exists, but the process is dead"
      remove_pid_file
      start_unicorn
    fi #the check for the running process
  else
    # There is no PID file
    echo "No PID file. Starting unicorn"
    start_unicorn
  fi #the check for the pid file
done
