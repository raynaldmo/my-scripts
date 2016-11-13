#!/usr/bin/env bash
# Create archive tarball of Drupal site source code, database contents
# and uploaded files.
#
# Script must be run from drupal root directory

# don't execute any commands just echo
# set -xvn

set -xv

COMPOSER=$HOME/.config/composer
DRUSH=${COMPOSER}/vendor/drush/drush/drush
GZIP=/usr/bin/gzip
MV=/bin/mv
LN=/bin/ln
LS=/bin/ls
RM=/bin/rm

if [ $# -ne 2 ]
then
	echo "Usage : drupal-arb.sh <site_name> <backup_dir>"
	echo "Usage : drupal-arb.sh example.com /home/sites/example.com/Development/backups"
	exit 1
fi

# to do
# check if composer and drush is installed
# check if command is run from drupal root
# check if backup directory exists

site_name=$1
backup_dir=$2

echo 'creating archive...'
${DRUSH} archive-backup --destination=${backup_dir}/${site_name}-backup.tar \
    --tar-options="--exclude=.git" --overwrite

cd ${backup_dir}

if [ -f ${site_name}-backup.tar.gz ]
then
    ${RM} -f ${site_name}-backup.tar.gz
fi

echo "gzip archive..."

${GZIP} ${site_name}-backup.tar
${MV} -f ${site_name}-backup.tar.gz ${site_name}-backup-$(date +%m-%d-%Y).tgz
${LN} -sf ${site_name}-backup-$(date +%m-%d-%Y).tgz ${site_name}-backup.tar.gz
${LS} -lh;

echo 'Done!'