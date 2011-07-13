# Xen Sever Backup

Backup Xen Virtual Machines from the xenserver to another machine.

# Usage

...

Our modifications to this script are the ability to backup virtual machines minus one or more of the hard drives, so that the backups don't include data drives etc...

To prevent a disk from being backed up by this script place 'nobackup' at the end of is description.

For the script to log errors to xencenter you need to set your host uuid in vm_backup.cfg. The priority of the alert can also be set in the config file.

# Credits

Based on [Andy Burtons vm_backup](http://www.andy-burton.co.uk/blog/ "Andy-Buton.co.uk")