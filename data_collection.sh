#!/bin/bash
#put in /etc/rc.local
# Function to check if the Ethernet interface is active
eth_active() {
    if ip link show eth0 up >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

lighton = ‘echo 1 > /sys/class/leds/led1/brightness’
lightoff = ‘echo 0 > /sys/class/leds/led1/brightness’
blink(){
max=10
for (( i=1; i <= $max; ++i ))
do
    lighton
    echo 'on'
    sleep 0.25
    lightoff
    echo 'off'
    sleep 0.25
done
}

dt=$(date '+%Y_%m_%d_%H_%M')
umask 0111
touch $dt.pcap

lightoff
sleep 5

# Main script
if eth_active; then
# Ethernet active, execute the command
    dumpcap -i eth0 -P -w $dt.pcap &
    pid=$!
    if eth_active; then
        echo "working"
        sleep 2
    else
        kill -2 $pid
        echo "Ethernet interface is severed. Exiting..."
        blink
        shutdown -h now
else
# Ethernet interface is severed, exit the script
#fflush CMD
#Check fstab for write permissions
    echo "Not getting data"
    blink
    exit 1

#a test we can do is edit rc local is echo "hi">~/blank.txt

