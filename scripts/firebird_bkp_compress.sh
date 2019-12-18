#!/bin/bash
#
# This script was created to generate a backup of the database
# Date: July/04 2014
#
set -x
# Initialise dynamic variables
DATE=/bin/date
DATE_STAMP=`$DATE +%d%m%Y%H%M%S`
FBBKP_LOGS="/var/log/backup/FACILITE-"$DATE_STAMP".log"

#
# Command variables
#
CHMOD=/bin/chmod
FIND=/usr/bin/find
GBAK=/opt/firebird/bin/gbak
FBDATABASE="localhost:/var/lib/firebird/2.5/data/FACILITE.FDB"
#FBBKP="/home/administracao/database/bkp/FACILITE-$DATE_STAMP.FBK"
BKPDIR="/home/administracao/database/tmp"
FBBKP=$BKPDIR"/FACILITE-$DATE_STAMP.FBK"
COMPRESSED_FILE=$FBBKP.tar.gz

echo
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo Performing delete for old backup $DATE_STAMP 
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo 

find $BKPDIR*.FBK -mtime +10 -exec rm -rf {} \; >>$FBBKP_LOGS

echo
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo Performing backup for $DATE_STAMP >> $FBBKP_LOGS
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo 

# Backup the database
$GBAK -v -t -user sysdba -password masterkey $FBDATABASE $FBBKP

echo
echo -------------------------------------------------------------------------------------------
echo Compressing file
echo
tar -czvf $COMPRESSED_FILE $FBBKP

echo
echo -------------------------------------------------------------------------------------------
echo Removing file
echo
rm -rf $FBBKP

echo
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo Performing permission for $DATE_STAMP >> $FBBKP_LOGS
echo ------------------------------------------------------------------------------------------ >> $FBBKP_LOGS
echo 

# Gives Permission
$CHMOD -R 777 $COMPRESSED_FILE

