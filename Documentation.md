We've tried doing the following things to kill the data collection process in our shell script:
sudo kill
kill
killall
clear
control+C
exit

Some possible things that we could look into:
pkill (I think reuben tried this in may but hasn't done it again since?)
kill -9 <processID> the code had kill -2 and we weren't really sure what the -2 was doing so we took it out. -9 could change? Tried 9 and it didn't change things. We could try kill -15 <PID>
kill -SIGKILL <processID>  essentially the kill 
-9 commands ends a SIGKILL signal indicating to shut down, but any unsaved data will be lost, so we'd have to be careful
xkill <resource> it closes a connection. It is supposed to abort any unwanted precesses
For exit, we could use exit codes. Ex: exit 0. exit 0 means that the script exited without errors, exit code of 1 means that an error occured when exiting. use "echo $? " to see the exit code 
We could also use "end" in the line about exit 0
Another option is kill -SIGTERM <PID>
We could also try using "done" after fi
We could set a maximum run time. This limits the number of minutes the process runs before killing it, so data would only be collected for a certain period of time.
kill -SIGINT is another option


