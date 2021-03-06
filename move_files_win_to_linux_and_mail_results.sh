#!/bin/bash

clear

# Mount windows share and use file for network credentials
# /mnt/win/folder folder created for windows smb mounts. I setup a serarate folder for each share
mount -t cifs -o credentials=/path/to/creds/secret.txt //windows_server/share/folder /mnt/win/folder

sleep 15

echo "mount complete"

# Check to see if file(s) exists. If is is there then run through the if statement
if [ ! -f /mnt/win/folder/file*.xls ]
	then
		echo "file does not exist."
	else
		echo "entering else statement"
		# Move file(s) from mount to local directory
		sudo mv /mnt/win/folder/file*.xls /home/user/arch/server/

		# Email address email will be coming from
		EMAIL="FirstName LastName <sender@domain.com>"
		export EMAIL

		# Use mutt CLI to send message
		mutt -s "Subject" -a /home/user/arch/server/file*.xls -- recipient@domain.com < /home/user/arch/server/message.txt

		# Create directory to archive file to (YYYY/MM/DD)
		mkdir /home/user/arch/server/subfldr/$(date +%Y%m%d)

		# Move file(s) to archive folder
		sudo mv /home/user/arch/server/file*.xls /home/user/arch/server/subfldr/$(date +%Y%m%d)
fi

# Unmount the windows share
sudo umount /mnt/win/folder
