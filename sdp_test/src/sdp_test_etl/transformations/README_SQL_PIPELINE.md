# SQL-Based SDP Pipeline

This folder contains SQL transformation files for the Spark Declarative Pipeline (SDP). These files demonstrate a medallion architecture (Bronze → Silver → Gold) using SQL syntax.

## Architecture

### Bronze Layer
**File:** `bronze_raw_events.sql`
- **Type:** Streaming Table
- **Purpose:** Raw data ingestion from JSON files
- **Features:** 
  - Auto Loader pattern using `read_files()`
  - Automatic schema inference and evolution
  - Captures ingestion timestamp

### Silver Layer
**File:** `silver_clean_events.sql`
- **Type:** Streaming Table with Expectations
- **Purpose:** Data quality and validation
- **Features:**
  - Filters invalid records
  - Data quality constraints (EXPECT clauses)
  - Type conversions and standardization
  - Streams from bronze layer

### Gold Layer - Real-time
**File:** `gold_event_summary.sql`
- **Type:** Live Table
- **Purpose:** Hourly aggregated metrics
- **Features:**
  - Aggregates by hour and event type
  - Counts unique users
  - Provides business-ready metrics

### Gold Layer - Batch
**File:** `gold_daily_metrics.sql`
- **Type:** Materialized View
- **Purpose:** Daily summary statistics
- **Features:**
  - Rolling 30-day window
  - Per-user metrics
  - Optimized for reporting queries

## Key SDP Concepts Demonstrated

1. **Streaming Tables** - Incremental processing with `STREAMING TABLE`
2. **Data Quality** - Built-in expectations with `CONSTRAINT ... EXPECT`
3. **Materialized Views** - Batch aggregations with `MATERIALIZED VIEW`
4. **Live Tables** - Standard tables updated incrementally
5. **Auto Loader** - Simplified file ingestion with `read_files()`
6. **LIVE Schema** - Reference upstream tables with `LIVE.table_name`

## Pipeline Configuration

The pipeline is configured in `resources/sdp_test_etl.pipeline.yml` with:
- Serverless compute (default)
- Automatic discovery via glob pattern: `../src/sdp_test_etl/transformations/**`
- Variables for catalog and schema

## Running the Pipeline

```bash
# Validate the bundle
databricks bundle validate --target dev

# Deploy the bundle
databricks bundle deploy --target dev

# Run the pipeline
databricks bundle run sdp_test_etl --target dev
```

## Data Flow

```
Source Files (JSON)
    ↓
bronze_raw_events (streaming)
    ↓
silver_clean_events (streaming + quality)
    ├─→ gold_event_summary (live table, hourly)
    └─→ gold_daily_metrics (materialized view, daily)
```

## Notes

- All SQL files are automatically discovered by the pipeline
- Tables are created in the catalog and schema defined in bundle variables
- The pipeline uses serverless compute by default
- Python transformations (`.py` files) can coexist with SQL files
