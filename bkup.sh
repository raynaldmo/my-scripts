#!/usr/bin/env bash

# simple script to back up files

home_dir=/home/raynaldmo
www_dir=/var/www

backup_loc=/run/media/raynaldmo/Seagate500

home_backup=bkup-raynaldmo-home.tgz
var_www_backup=bkup-raynaldmo-var-www.tgz

# remove old backups if any
if [ -f ${backup_loc}/${home_backup} ]
then
    echo "Saving old backup ${backup_loc}/${home_backup}"
    mv -f ${backup_loc}/${home_backup} ${backup_loc}/old/${home_backup}

    echo "Removing old backup ${backup_loc}/${home_backup}"
    rm -f ${backup_loc}/${home_backup}
fi

if [ -f ${backup_loc}/${var_www_backup} ]
then
    echo "Saving old backup ${backup_loc}/${var_www_backup}"
    mv -f ${backup_loc}/${var_www_backup} ${backup_loc}/old/${var_www_backup}

    echo "Removing old backup ${backup_loc}/${var_www_backup}"
    rm -f ${backup_loc}/${var_www_backup}
fi

cd ${backup_loc}

echo "Backing up ${home_dir}..."
tar czf ${backup_loc}/${home_backup} ${home_dir}

echo "Backing up ${www_dir}..."
tar czf ${backup_loc}/${var_www_backup} ${www_dir}

echo "Done!"
