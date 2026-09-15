-- Bronze layer: Raw event ingestion
-- This streaming table ingests raw JSON events from a source

CREATE OR REFRESH STREAMING TABLE bronze_raw_events
COMMENT "Bronze layer - Raw events ingested from source"
AS
SELECT 
  current_timestamp() as ingestion_time,
  *
FROM STREAM read_files(
  'dbfs:/tmp/sample_events/',
  format => 'json',
  schemaLocation => 'dbfs:/tmp/sample_events/_schema'
)
