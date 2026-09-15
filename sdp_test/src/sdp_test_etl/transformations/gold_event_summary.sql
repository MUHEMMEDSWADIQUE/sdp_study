-- Gold layer: Business-ready aggregated metrics
-- Hourly event statistics by event type

CREATE OR REFRESH LIVE TABLE gold_event_summary
COMMENT "Gold layer - Hourly event statistics by event type"
AS
SELECT 
  date_trunc('hour', event_timestamp) as event_hour,
  event_type,
  COUNT(*) as event_count,
  COUNT(DISTINCT user_id) as unique_users,
  MIN(event_timestamp) as first_event_time,
  MAX(event_timestamp) as last_event_time
FROM LIVE.silver_clean_events
GROUP BY 
  date_trunc('hour', event_timestamp),
  event_type
