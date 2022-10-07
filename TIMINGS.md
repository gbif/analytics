# Timings

Time taken to produce the Q2-2021 analytics:

* Snapshot time not measured (not long)
* Interpret snapshots stage: 2½ days
  * Interpreting geography (with KVS): 7 hours
  * Interpreting taxonomy (no KVS): 14 hours
* Summarize snapshots stage: 2½ days
* Download CSVs stage: ½ day
* Process CSVs stage: <5 minutes
* Figures stage: 1½ hours

* Generating country reports: 15 minutes

Times for the Q3-2022 analytics:

* Snapshot: 10 minutes
* Interpret snapshots stage: 2½ days
  * Create raw tables: 4½ hours (4¼ hours with rand())
  * Interpreting geography (with shapefiles): 2 minutes
  * Interpreting taxonomy (no KVS): 13 hours, but should be less next time with the ORDER BY rand()
* Summarize snapshots stage: 14 hours
* Download CSVs stage: 15 minutes
* Process CSVs stage: 1 hour
* Figures stage: 1½ hours
