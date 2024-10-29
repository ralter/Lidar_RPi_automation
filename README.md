# Automating data collection for VLP16 via a Raspberry Pi

All work done here is for the Colorado College GIS Center.

## Important information

### Using the Pi
To use with monitor support at the GIS lab.

1. Plug into socket, crestron HDMI, and a keyboard and mouse.
(You essentially just have a computer with it)

2. Lidar: plugged in, use the ethernet to connect the two devices.

3. An aside is that all data collection must be done as root. make sure you know the root information.

## Testing to see if data collection is working
If, for some reason, the Pi gets scrubbbed, Wireshark needs to be downloaded.
CMDS:
sudo apt update && sudo apt upgrade
sudo apt install wireshark


If that is done, "sudo dumpcap -i eth0 -a duration:10 -P -w <pathtofile>"
will collect 10 seconds of data from the ethernet port (the -i eth0) as a .pcap file and send it wherever you choose.



## Run the script
Plug in thumbdrive. it shouldn't work without one.

First run 'chmod +x data_collection.sh'. sudo it if it doesn't work as the standard user

Run the data_collection.sh using 'sudo bash data_collection.sh'
If all goes to according to plan, it will collect data and terminate if you unplug the ethernet.

Once it is referenced in rc.local it will run automatically on boot. 
