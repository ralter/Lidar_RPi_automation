#!/bin/bash

#put in /etc/rc.local

eth_active(){
	ip link show "$1" 2>&1 | grep "state UP" 2>&1 >/dev/null
}

lighton="echo 1 | sudo tee /sys/class/leds/PWR/brightness"
lightoff="echo 0 | sudo tee /sys/class/leds/PWR/brightness"


## Blink Function makes sense
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

mount -t vfat /dev/sda1 /mnt/usb_mnt -o umask=000 #Mount thumbdrive usb
dt=$(date '+%Y_%m_%d_%H_%M') #What day is today
cd ~/mnt/usb_mnt/
umask 011 #Change permissions
touch $dt.pcap #create pcap file labeled with the date
eval $lightoff
sleep 5

#Main script
iface=eth0 #Where lidar data comes from
dumpcap -i "$iface" -q -P -w "$dt.pcap" & #dumpcap data collection command
pid=$!

while eth_active "$iface" #Check if ethernet is still working
do
	sleep 1 #if yes, continue. if no, kill processes
done

echo $pid
cd
sudo umount /mnt/usb_mnt #unmount USB for data hygiene processes
kill "$pid" && ( sleep 3; kill -KILL "$pid" 2>/dev/null ) #end it
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
