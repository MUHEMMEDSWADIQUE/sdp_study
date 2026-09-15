-- Gold layer: Daily aggregated metrics (Materialized View)
-- Daily summary of events with complete day statistics

CREATE OR REFRESH MATERIALIZED VIEW gold_daily_metrics
COMMENT "Gold layer - Daily event metrics (batch)"
AS
SELECT 
  date(event_timestamp) as event_date,
  event_type,
  COUNT(*) as total_events,
  COUNT(DISTINCT user_id) as unique_users,
  COUNT(DISTINCT event_id) as unique_events,
  ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) as avg_events_per_user
FROM LIVE.silver_clean_events
WHERE event_timestamp >= current_date() - INTERVAL 30 DAYS
GROUP BY 
  date(event_timestamp),
  event_type
ORDER BY event_date DESC, event_type
