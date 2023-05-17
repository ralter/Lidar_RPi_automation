#!/bin/bash

# Function to check if the Ethernet interface is active
eth_active() {
    if ip link show eth0 up >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}
#dt=(date '+%Y_%m_%d_%H_%M')
#touch $dt.pcap
#lighton = ‘echo 1 | tee /sys/class/leds/led1/brightness’
#lightoff = ‘echo 0 | tee /sys/class/leds/led1/brightness’
blink(){
max=10
for (( i=1; i <= $max; ++i ))
do
    #lighton
    echo 'on'
    sleep 0.25
    #lightoff
    echo 'off'
    sleep 0.25
done
}
blink
# Main script
while true; do
    if eth_active; then
        # Ethernet active, execute the command
        echo "Ethernet is active"
        exit
    else
        # Ethernet interface is severed, exit the script
        echo "Ethernet interface is severed. Exiting..."
        exit
    fi
done

