-- Silver layer: Cleaned and validated events
-- Filters out invalid records and applies data quality constraints

CREATE OR REFRESH STREAMING TABLE silver_clean_events (
  CONSTRAINT valid_event_id EXPECT (event_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_timestamp EXPECT (event_timestamp IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Silver layer - Cleaned and validated events"
AS
SELECT 
  event_id,
  event_type,
  user_id,
  to_timestamp(event_timestamp) as event_timestamp,
  event_data,
  ingestion_time
FROM STREAM(LIVE.bronze_raw_events)
WHERE event_id IS NOT NULL
  AND event_type IN ('click', 'view', 'purchase', 'signup')
