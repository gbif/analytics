# Import

Script to import historical snapshots of the GBIF index from zipped MySQL dump file format into a Hive table.
The script unzips, extracts the data_provider, data_resource and raw_occurrence_record tables (only) and then imports them as Avro backed compressed (Snappy) format tables which are afterwards converted to RCF. The script uses a single argument (the filename of the dump) and cleans up traces of a previous run for the same date (locally, in Hive and HDFS), in case re-runs are needed. Extracting the tables from the mysql dump is done using a Perl script written by Jared Cheney (published under GNU GPL).
To execute a single import:
```
$ import.sh /tmp/GBIFPortalDB_2009-12-16.dump.gz
```

The following may help system administrators who are managing multiple imports - use at your own risk
```
$ for k in GBIFPortalDB_2009-12-16.dump.gz GBIFPortalDB_2009-09-25.dump.gz GBIFPortalDB_2009-06-17.dump.gz; do ./import.sh /mnt/external/$k; echo -e '\n';printf '=%.0s' {1..100}; echo -e '\n'; done
```

Note: These scripts were developed for a single run, and would benefit from some refactoring should these be needed regularly.