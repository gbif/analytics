# Process

Scripts run in Hive to process the snapshots and produce the processed occurrence tables.
This requires a build of the GBIF UDFs which are located in https://github.com/gbif/occurrence/tree/master/occurrence-hive.

To build the occurrence-hive the following can be used, paying attention to the URLs used for the service:
```
$ cd git/occurrence/occurrence-hive
$ mvn clean package -Dchecklistbank.match.ws.url=http://api.gbif-uat.org/v0.9/species/match -DskipTests -Dgeocode.ws.url=http://api.gbif-uat.org/v0.9/lookup/reverse_geocode
```

These are run in the following order:
- raw_geo.q
- raw_taxonomy.q
- interp_geo.q
- inter_taxonomy.q
- occurrence.q

Note: These scripts use hard coded paths and file names that could benefit from a refactoring at some future stage.  Additionally, the occurrence.q only prepares a single table, and needs modified and run for each snapshot.