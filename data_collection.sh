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

PWR_STAT=0
exitscript(){
	echo"$(date): SIGINT or SIGTERM detected"
	trap -SIGINT SIGTERM
	if ! [-z ${CHILD+x}]
	then
		echo "Terminating data logging"
		kill $CHILD
		wait $CHILD
	fi
	blink()
	if [ $PWR_STAT -eq 1]
	then
		echo "powering off computer"
#poweroff
	fi
	exit 1
}
trap exitscript SIGINT SIGTERM

dt=$(date '+%Y_%m_%d_%H_%M')
umask 0111
touch $dt.pcap

lightoff
sleep 5

# Main script
# Ethernet active, execute the command
    dumpcap -i eth0 -P -w $dt.pcap &
    pid=$!
    if eth_active; then
        echo "working"
        sleep 2
    else
        kill -9 $pid
        echo "Ethernet interface is severed. Exiting..."
        blink
        shutdown -h now
    fi
else
# Ethernet interface is severed, exit the script
    echo "Not getting data"
    blink
    exit 0
fi
#fflush CMD
#Check fstab for write permissions
#a test we can do is edit rc local is echo "hi">~/blank.txt

#TEST FOR EXITING SCRIPT WHEN ETHERNET IS UNPLUGGED
if eth_active; then
	dumpcap -i eth0 -P -w "$dt.pcap" &
    	pid=$!
else
    # Ethernet interface is severed, exit the script
    echo "Not getting data"
    blink
    exit 0
fi

## run until eth_active is false
while eth_active; do
    echo "working"
    sleep 2
done

## Only kill the PID if the $pid variable is not empty
[ -n "$pid" ] && kill -9 "$pid"

echo "Ethernet interface is severed. Exiting..."
blink
shutdown -h now

#ANOTHER OPTION FOR EXITING SCRIPT
#test is ethernet is active
iface=eth0    # Interface name
while sleep 3; do date; ip link show "$iface" up; echo SS=$?; echo; done
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
