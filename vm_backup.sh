#!/bin/bash

#
# Citrix XenServer 5.5 VM Backup Script
# This script provides online backup for Citrix Xenserver 5.5 virtual machines
#
# @version	3.01
# @created	24/11/2009
# @lastupdated	01/12/2009
#
# @author	Andy Burton
# @url		http://www.andy-burton.co.uk/blog/
# @email	andy@andy-burton.co.uk
#



# Get current directory

dir=`dirname $0`

# Load functions and config

. $dir"/vm_backup.lib"
. $dir"/vm_backup.cfg"

touch $log_path


# Switch backup_vms to set the VM uuids we are backing up in vm_backup_list

case $backup_vms in
	
	"all")
		if [ $vm_log_enabled ]; then
			log_message "Backup All VMs"
		fi
		set_all_vms
		;;	
		
	"running")
		if [ $vm_log_enabled ]; then
			log_message "Backup running VMs"
		fi
		set_running_vms
		;;
		
	"list")
		if [ $vm_log_enabled ]; then
			log_message "Backup list VMs"
		fi
		;;
		
	*)
		if [ $vm_log_enabled ]; then
			log_message "Backup no VMs"
		fi
		reset_backup_list
		;;
	
esac

# Check backup_dir exists if not create it
if [ ! -d $backup_dir ];
then
   `mkdir -p $backup_dir`
fi

# Check if backing to CIFS share
# if not run backups
# else mount share and if successful run backups

if [ -z $cifs_share ]; then
	backup_vm_list
else
	`mount -t cifs "$cifs_share" $backup_dir -o username=$cifs_username,password="$cifs_password"`
	if [ $? -eq 0 ]; then
		backup_vm_list
	else
		`xe message-create name="Backups Error" body="Unable to mount share" priority=$alert_priority host-uuid=$host_uuid`
		exit
	fi
fi

if [ -n "$keep_backups_for" ]; then
remove_old_backups $keep_backups_for
fi 

# End

if [ $vm_log_enabled ]; then
	log_disable
fi
