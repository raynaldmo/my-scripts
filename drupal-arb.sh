#!/usr/bin/env bash
# Create archive tarball of Drupal site source code, database contents
# and uploaded files.
#
# Script must be run from drupal root directory

# don't execute any commands just echo
# set -xvn

# echo and execute commands
# set -xv

GZIP=/usr/bin/gzip
MV=/bin/mv
LN=/bin/ln
LS=/bin/ls
RM=/bin/rm

function usage () {
    echo "Usage : drupal-arb.sh <drupal_version> <site_name> <backup_dir>"
	echo "Usage : drupal-arb.sh 8 example.com /home/sites/example.com/Development/backups"
	exit 1
}

if [ $# -ne 3 ]
then
	usage
fi

drupal_version=$1
site_name=$2
backup_dir=$3


# check if appropriate drush is installed
case "$drupal_version" in
    8) DRUSH=$HOME/drush8/vendor/bin/drush ;;
    7) DRUSH=$HOME/drush7/vendor/bin/drush ;;
    6) DRUSH=$HOME/drush6/vendor/bin/drush ;;
    *) usage ;;
esac

echo "$($DRUSH --version)"

# check if backup directory exists
if [ ! -d $backup_dir ]
then
    echo "Backup directory $backup_dir doesn't exist. Please specify a valid backup directory."
    exit 2;
fi

# todo
# check if command is run from drupal root

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