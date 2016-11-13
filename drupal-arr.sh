#!/usr/bin/env bash
# Restore archive tarball of Drupal site source code, database contents
# and uploaded files

# don't execute any commands just echo
# set -xvn

# set -xv

COMPOSER=$HOME/.config/composer
DRUSH=${COMPOSER}/vendor/drush/drush/drush
GZIP=$(which gzip)
CP=/bin/cp
MKDIR=/bin/mkdir
RM=/bin/rm

if [ $# -ne 3 ]; then
    echo "Restore the source code, files and database for a site."
    echo "Usage: drupal-arr.sh <src_dir> <site_name> <web_root>"
    echo "Usage: drupal-arr.sh /home/test/site/backups example.com /var/www/example.com"
    exit 1
fi

# todo
# check if composer and drush is installed
# check if web_root exist. it'll be different for MAMP and Ubuntu etc.
# find a way to use drush to drop and create database.
# we currently need to manually drop and create empty database for the archive
# to work


src_dir=$1
site_name=$2
web_root=$3
# db=$4;

site_root_dir=${web_root}
site_root_path='public_html'

# check if site dir exist if not try to create
if [ ! -d ${site_root_dir} ]
then
    echo "Creating site directory ${site_root_dir}..."
    ${MKDIR} -p ${site_root_dir}
fi

if [ $? -ne 0 ]
then
    echo "Couldn't create site directory ${site_root_dir}"
    exit 2
fi

archive_gz=${site_name}-backup.tar.gz
archive=${site_name}-backup.tar

if [ ! -f ${src_dir}/${archive_gz} ]
then
    echo "File $src_dir/${archive_gz} doesn't exist"
    exit 3
fi

echo "Copying archive to ${site_root_dir}"
${CP} ${src_dir}/${archive_gz} ${site_root_dir}

echo 'Unzip archive...'
${GZIP} -d ${site_root_dir}/${archive_gz}


echo 'Restore archive...'
# ${DRUSH} archive-restore ${site_dir}/${site_name}-backup.tar \
#    --destination="$site_dir" \
#    --db-url=mysql://root:root@127.0.0.1/${db}

# restore source code, files and database.
# database info is extracted from settings.php
${DRUSH} archive-restore ${site_root_dir}/${site_name}-backup.tar \
    --destination="${site_root_dir}/${site_root_path}"

echo "Cleaning up..."
${RM} -f ${site_root_dir}/${archive}

echo "Done!"
