#!/bin/bash

#put in /etc/rc.local
#a test we can do is edit rc local is echo "hi">~/blank.txt
# Function to check if the Ethernet interface is active
eth_active() {
    ip link show "${1:-eth0}" up 2>&1 | grep -qF "state UP"
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
iface=eth0
# Start the packet capture
dumpcap -i "$iface" -P -w "$(date +'%Y-%m-%d_%H%M').pcap" &
pid=$!  

# Do nothing until either the network cable is pulled or dumpcap dies
while eth_active "$iface" && kill -0 "$pid" 2>/dev/null
do
    sleep 3
done

# Kill dumpcap if it's still around
kill "$pid" 2>/dev/null && ( sleep 3; kill -KILL "$pid" 2>/dev/null ) &
