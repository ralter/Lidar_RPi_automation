We've tried doing the following things to kill the data collection process in our shell script:
sudo kill
kill
killall
clear
control+C
exit

Some possible things that we could look into:
pkill (I think reuben tried this in may but hasn't done it again since?)
kill -9 <processID> the code had kill -2 and we weren't really sure what the -2 was doing so we took it out. -9 could change? Tried 9 and it didn't change things
kill -SIGKILL <processID>  essentially the kill -9 commands ends a SIGKILL signal indicating to shut down, but any unsaved data will be lost, so we'd have to be careful
xkill <resource> it closes a connection. It is supposed to abort any unwanted precesses
