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
MKDIR=/bin/mkdir

usage () {
    echo "Usage : drupal-arb.sh <drupal_version> <site_name> <backup_dir>"
	echo "example : drupal-arb.sh 8 example.com /home/raynald/drupal-site-backups"
	echo "example : drupal-arb.sh 8 example.com /User/raynald/drupal-site-backups"
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

backup_dir=${backup_dir}/${site_name}

# check if backup directory exists, if not create it
if [ ! -d ${backup_dir} ]
then
    ${MKDIR} ${backup_dir}
fi

# todo
# check if command is run from drupal root

echo 'creating archive...'
${DRUSH} archive-backup --destination=${backup_dir}/${site_name}-backup.tar \
    --tar-options="--exclude=.git" --overwrite

echo 'creating database...'
${DRUSH} sql-dump --gzip --result-file=${backup_dir}/${site_name}-$(date +%Y-%m-%d-%H-%M-%S).sql

cd ${backup_dir}

if [ -f ${site_name}-backup.tar.gz ]
then
    ${RM} -f ${site_name}-backup.tar.gz
fi

echo "gzip archive..."

${GZIP} ${site_name}-backup.tar
${MV} -f ${site_name}-backup.tar.gz ${site_name}-backup-$(date +%Y-%m-%d-%H-%M-%S).tgz
# ${LN} -sf ${site_name}-backup-$(date +%m-%d-%Y).tgz ${site_name}-backup.tar.gz
${LS} -lh;

echo 'Done!'