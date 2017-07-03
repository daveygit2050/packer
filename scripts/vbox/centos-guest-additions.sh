#!/bin/bash

# Create directory
mkdir -p /media/iso

# Mount ISO to directory
mount -t iso9660 -o loop /root/VBoxGuestAdditions.iso /media/iso

# Copy contents to permenant directory
cp -R /media/iso /root/VBoxGuestAdditions

# Unmount, but leave the iso for troubleshooting
umount /media/iso

# Create a script for installing VBoxGuestAdditions at boot and reseting cron
echo '#!/bin/sh' > /root/install-vbox-guestadditions.sh
echo '/root/VBoxGuestAdditions/VBoxLinuxAdditions.run' >> /root/install-vbox-guestadditions.sh
echo 'rm -f /var/spool/cron/root' >> /root/install-vbox-guestadditions.sh
echo 'touch /var/spool/cron/root' >> /root/install-vbox-guestadditions.sh

# Set the script to executable
chmod +x /root/install-vbox-guestadditions.sh

# Add the script to crontab to run at startup
echo "* * * * * sh /root/install-vbox-guestadditions.sh" > /var/spool/cron/root
