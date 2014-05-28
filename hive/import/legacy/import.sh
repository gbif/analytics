#!/bin/bash

bls='\033[1m'
ble='\033[0m'

if [ $# -ne 1 ];then
      echo -e $bls"This requires exactly 1 argument: full path to a zipped MySQL dump"$ble
      exit 1
fi

# check if file exists
if [ ! -e $1 ]; then
	echo -e $bls"Source dump file not found: $1"$ble
	exit
fi

# getting date from filename 
currdate="`echo $1 | sed "s/[^0-9]//g"`"

echo -e $bls"Working with date: $currdate"$ble
echo -e $bls"Working with filename: $1\n\n"$ble

WORKPATH=/root/work/scripts/mysql_hive
CDH4PATH=$WORKPATH/cdh4
REMPATH=/user/andrei/etl
REMDB_SNAPSHOT=snapshot
REMDB_ETL=etl
MYSQLTBL_LIST="data_provider data_resource raw_occurrence_record"
##MYSQLTBL_LIST="data_provider data_resource"
HIVETBL_LIST="dataset publisher raw"

source $CDH4PATH/setup.sh
cd $WORKPATH


## will re-use the same DB name
## drop if exists target database
echo -e $bls"\nDropping and recreating Mysql DB\n\n"$ble
mysql -h mogo.gbif.org -pV0try45m << Limit893String
drop database if exists portTablesCurrent;
create database portTablesCurrent;
quit
Limit893String


# clean remote traces
hadoop dfs -rm -r -f $REMPATH/$currdate
# and recreate dir
hadoop dfs -mkdir $REMPATH/$currdate		
# clean all possible tables for this date
for tble in $HIVETBL_LIST; do
	HIVEDROP_ETL="DROP TABLE "$REMDB_ETL.$tble"_"$currdate";"
	echo -e $bls"Hive drop table command is: $HIVEDROP_ETL \n\n"$ble
	hive -e "$HIVEDROP_ETL" && echo -e $bls"\n\nTable sucessfully dropped: $REMDB_ETL.$tble"_"$currdate\n\n"
        HIVEDROP_SNAP="DROP TABLE "$REMDB_SNAPSHOT.$tble"_"$currdate";"
        echo -e $bls"Hive drop table command is: $HIVEDROP_SNAP \n\n"$ble
        hive -e "$HIVEDROP_SNAP" && echo -e $bls"\n\nTable sucessfully dropped: $REMDB_SNAPSHOT.$tble"_"$currdate\n\n"$ble
done
                                

for currtable in $MYSQLTBL_LIST; do
	
	# extract from .zip into mysql
	
	echo -e $bls"\n\nStarting MySQL import for $currtable\n\n"$ble

	zcat $1 | $WORKPATH/extract_sql.pl -t $currtable | mysql portTablesCurrent -h mogo -u root -pV0try45m && echo -e $bls"\n\nMySQL import completed for $currtable and $currdate\n\n"$ble

	if [ "$currtable" == "data_provider" ]; then
        	currhivetable="publisher"
	elif [ "$currtable" == "data_resource" ]; then
        	currhivetable="dataset"
	elif [ "$currtable" == "raw_occurrence_record" ]; then
	##elif [ "$currtable" == "raw_occurrence_record_test" ]; then
        	currhivetable="raw"
	        mysql portTablesCurrent -h mogo -pV0try45m -e "alter table "$currtable" change class class_rank varchar(250);" && echo -e $bls"Altered table structure for $currtable\n\n"$ble
	fi
	
	echo -e $bls"Coresponding Hive table is $currhivetable\n\n"$ble

	# getting MySQL rowcounts
	rcountMySQL="`mysqlshow --count -h mogo.gbif.org -pV0try45m portTablesCurrent $currtable  | grep $currtable | awk {'print $6'}`"


	echo -e $bls"\n\nPreparing to import "$currtable" into Hive\n"$ble
	
	# cleanup existing stuff (check not required, silent anyway)
	# local traces, just in case
	rm -rf $WORKPATH/$currhivetable*	
			
			
	echo -e $bls"\n\nGetting table header for $currhivetable\n\n"$ble
	sqoop import -jt local --connect jdbc:mysql://mogo.gbif.org/portTablesCurrent --username root --password V0try45m --as-avrodatafile -m 1 --split-by id --target-dir file:///$WORKPATH/$currhivetable --table $currtable --where id=0 && echo -e $bls"Got table header"$ble
	
	echo -e $bls"\n\nExtracting schema for $currhivetable\n\n"$ble
	java -jar $CDH4PATH/avro-tools-1.7.6.jar getschema $WORKPATH/$currhivetable/*.avro > $WORKPATH/$currhivetable.avsc && echo -e $bls"Schema extracted for $currhivetable"$ble
	
	echo -e $bls"\n\nUploading schema for $currhivetable\n\n"$ble
	hadoop dfs -put $WORKPATH/$currhivetable.avsc $REMPATH/$currdate/$currhivetable.avsc && echo -e $bls"Schema uploaded for $currhivetable"$ble

	echo -e $bls"\n\nSqooping schema and data for $currhivetable\n\n"$ble
	sqoop import --connect jdbc:mysql://mogo.gbif.org/portTablesCurrent --username root --password V0try45m --as-avrodatafile -m 12 --split-by id --compression-codec snappy --target-dir $REMPATH/$currdate/$currhivetable --table $currtable && echo -e $bls"Schema/Data loaded"$ble

	echo -e $bls"\n\nCreating Hive table for $currhivetable\n\n"$ble
	
	HIVECREATEAVRO="CREATE EXTERNAL TABLE "$REMDB_ETL.$currhivetable"_"$currdate" ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '"$REMPATH/$currdate/$currhivetable"' TBLPROPERTIES ('avro.schema.url'='hdfs://"$REMPATH/$currdate/$currhivetable.avsc"');"
	
	hive -e "$HIVECREATEAVRO" && echo -e $bls"\n\nHive AVRO table created for $currhivetable\n\n"$ble
	
	# convert to RCFile
	HIVECONVERT="SET hive.exec.compress.output=true;SET mapred.max.split.size=256000000;SET mapred.output.compression.type=BLOCK;SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;create table "$REMDB_SNAPSHOT.$currhivetable"_"$currdate" STORED AS rcfile AS SELECT * from "$REMDB_ETL.$currhivetable"_"$currdate";"
	echo -e $bls"\n\n$HIVECONVERT\n\n"$ble
	hive -e "$HIVECONVERT" && echo -e $bls"\n\nTable "$currhivetable"_"$currdate" converted to RCfile\n\n"$ble
	
	# rowcount for hive tables
	echo -e $bls"\n\nCounting rows...\n\n"$ble
	rcountHiveAvro="$(hive -e "select count(*) from "$REMDB_ETL.$currhivetable"_"$currdate";")"
	rcountHiveRCfile="$(hive -e "select count(*) from "$REMDB_SNAPSHOT.$currhivetable"_"$currdate";")"
	rowlog="$currdate $currtable/$currhivetable\t\t$rcountMySQL\t$rcountHiveAvro\t$rcountHiveRCfile"	
	echo -e $bls"\n\nEnd counting rows...\n\n"$ble

	# removing previous counts for this date and table and adding new result
	sed -i "/^$currdate $currtable/ d" $WORKPATH/rowlog.txt
	sed -i '/^$/d' $WORKPATH/rowlog.txt

	echo -e $rowlog >> $WORKPATH/rowlog.txt	


	# remove local traces
	rm -rf $WORKPATH/$currhivetable*
done

echo -e $bls"\n\nImport completed for $currdate"$ble
echo


	
	


