#!/bin/bash

#put in /etc/rc.local

eth_active() {
    ip link show "$1" 2>&1 | grep "state UP" 2>&1 >/dev/null
}

lighton = ‘echo 1 | sudo tee /sys/class/leds/led1/brightness’
lightoff = ‘echo 0 | sudo tee /sys/class/leds/led1/brightness’

blink(){
max=10

for (( i=1; i <= $max; ++i ))
do
    eval $lighton
    echo 'on'
    sleep 0.25
    eval $lightoff
    echo 'off'
    sleep 0.25
done
}
#mounting USB drive on RPi
mount -t vfat /dev/sda1 /mnt/usb_mnt -o umask=000

dt=$(date '+%Y_%m_%d_%H_%M')
umask 011
touch $dt.pcap
eval $lightoff
sleep 5

# Main script
iface=eth0
# Start the packet capture
dumpcap -i "$iface" -q -P -w "$dt.pcap" &
pid=$!  

# Do nothing until either the network cable is pulled or dumpcap dies
while eth_active "$iface"
do
    sleep 1
done
echo $pid
cd
sudo umount /mnt/usb_mnt

# Kill dumpcap if it's still around
kill "$pid" && ( sleep 3; kill -KILL "$pid" 2>/dev/null ) 
