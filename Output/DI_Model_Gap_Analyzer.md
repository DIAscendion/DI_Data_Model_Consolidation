### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 46 | 100% |
| Attributes mapped ≥80% match | 14 | 30.4% |
| Attributes mapped 40–79% match | 11 | 23.9% |
| Attributes not mapped (no match ≥40) | 21 | 45.7% |
| Total matched pairs identified | 18 | — |
| Total unmatched columns | 21 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | facility_id | LexingtonSite_DataMart | equipment | equip_id | 92 | Name similarity (facility_id ≈ equip_id); glossary both define as "unique facility/equipment identifier"; both VARCHAR(30) format | Cast both as VARCHAR(30); enforce NOT NULL + UNIQUE |
| EnterpriseAnalyticsDataMart | dim_facility | facility_name | LexingtonSite_DataMart | equipment | equip_name | 90 | Name similarity (facility_name ≈ equip_name); glossary both define as "official name"; both VARCHAR(150) | Cast both as VARCHAR(150); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | dim_facility | site_code | LexingtonSite_DataMart | equipment | line_id | 64 | Glossary similarity (site_code ≈ line_id); both reference site/line assignment; inferred from name/type | Map site_code alpha prefix to line_id; Cast VARCHAR(20) to VARCHAR(30) |
| EnterpriseAnalyticsDataMart | dim_facility | city | LexingtonSite_DataMart | equipment | building | 43 | Glossary similarity (city ≈ building); both reference location; inferred from name/type | Map city to building via lookup; Cast VARCHAR(100) to VARCHAR(50) |
| EnterpriseAnalyticsDataMart | dim_facility | country_code | LexingtonSite_DataMart | equipment | manufacturer | 41 | Glossary similarity (country_code ≈ manufacturer); both reference origin; inferred from name/type | Map country_code to manufacturer via lookup; Cast CHAR(2) to VARCHAR(100) |
| EnterpriseAnalyticsDataMart | dim_product | product_id | LexingtonSite_DataMart | batch_run | product_code | 89 | Name similarity (product_id ≈ product_code); glossary both define as "product identifier"; both VARCHAR(50) | Cast both as VARCHAR(50); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | dim_product | product_name | LexingtonSite_DataMart | batch_run | step_name | 44 | Glossary similarity (product_name ≈ step_name); both reference process/product; inferred from name/type | Map product_name to step_name via lookup; Cast VARCHAR(150) to VARCHAR(100) |
| EnterpriseAnalyticsDataMart | dim_product | sku | LexingtonSite_DataMart | batch_run | batch_id | 45 | Glossary similarity (sku ≈ batch_id); both reference product/batch assignment; inferred from name/type | Map sku to batch_id via lookup; Cast VARCHAR(60) to VARCHAR(50) |
| EnterpriseAnalyticsDataMart | dim_product | dosage_form | LexingtonSite_DataMart | batch_run | step_name | 41 | Glossary similarity (dosage_form ≈ step_name); both reference process form; inferred from name/type | Map dosage_form to step_name via lookup; Cast VARCHAR(80) to VARCHAR(100) |
| EnterpriseAnalyticsDataMart | dim_product | effective_start_date | LexingtonSite_DataMart | batch_run | start_ts | 85 | Name similarity (effective_start_date ≈ start_ts); glossary both reference start date; both date/timestamp types | Reformat date from DATE to TIMESTAMP; enforce NOT NULL |
| EnterpriseAnalyticsDataMart | dim_product | effective_end_date | LexingtonSite_DataMart | batch_run | end_ts | 85 | Name similarity (effective_end_date ≈ end_ts); glossary both reference end date; both date/timestamp types | Reformat date from DATE to TIMESTAMP; allow NULL |
| EnterpriseAnalyticsDataMart | dim_product | current_flag | LexingtonSite_DataMart | batch_run | batch_status | 68 | Glossary similarity (current_flag ≈ batch_status); both reference current/active status; inferred from name/type | Map TRUE/FALSE to in_prog/completed via lookup; Cast BOOLEAN to VARCHAR(30) |
| EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | LexingtonSite_DataMart | batch_run | planned_qty | 100 | Name similarity; glossary both define as "planned production quantity"; both numeric types | Cast both as NUMERIC(18,3); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | LexingtonSite_DataMart | batch_run | actual_qty | 100 | Name similarity; glossary both define as "actual quantity produced"; both numeric types | Cast both as NUMERIC(18,3); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | LexingtonSite_DataMart | batch_run | qty_unit | 100 | Name similarity; glossary both define as "unit of measure"; both VARCHAR(20) | Cast both as VARCHAR(20); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | LexingtonSite_DataMart | batch_run | yield_pct | 100 | Name similarity; glossary both define as "yield percentage"; both numeric types | Cast both as NUMERIC(6,3); allow NULL |
| EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | LexingtonSite_DataMart | batch_run | batch_status | 93 | Name similarity; glossary both define as "batch operational status"; values overlap (ACTIVE/completed, ON_HOLD/on_hold) | Map status codes via lookup; Cast VARCHAR(30); enforce NOT NULL |
| EnterpriseAnalyticsDataMart | fact_batch_summary | start_timestamp_utc | LexingtonSite_DataMart | batch_run | start_ts | 87 | Name similarity; glossary both reference batch start time; both timestamp types | Reformat timestamp from UTC to US/Eastern; Cast TIMESTAMP_TZ to TIMESTAMP |
| EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc | LexingtonSite_DataMart | batch_run | end_ts | 87 | Name similarity; glossary both reference batch end time; both timestamp types | Reformat timestamp from UTC to US/Eastern; Cast TIMESTAMP_TZ to TIMESTAMP |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | facility_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| EnterpriseAnalyticsDataMart | dim_facility | state_region | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | timezone_name | VARCHAR(80) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | gmp_certified | BOOLEAN NOT NULL DEFAULT TRUE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | current_flag | BOOLEAN NOT NULL DEFAULT TRUE | No sample data provided | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| EnterpriseAnalyticsDataMart | dim_product | product_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| EnterpriseAnalyticsDataMart | dim_product | formulation_id | VARCHAR(60) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | therapeutic_class | VARCHAR(100) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_code | VARCHAR(40) NOT NULL UNIQUE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_name | VARCHAR(100) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | requires_investigation | BOOLEAN NOT NULL DEFAULT FALSE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | commercially_releasable | BOOLEAN NOT NULL DEFAULT FALSE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | deviation_implied | BOOLEAN NOT NULL DEFAULT FALSE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | description | VARCHAR(500) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | batch_summary_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| EnterpriseAnalyticsDataMart | fact_batch_summary | deviation_count | NUMBER NOT NULL DEFAULT 0 | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | source_site_code | VARCHAR(20) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| EnterpriseAnalyticsDataMart | fact_yield_analysis | yield_analysis_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| LexingtonSite_DataMart | equipment | updated_at | TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | batch_run | run_id | VARCHAR(50) PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| LexingtonSite_DataMart | batch_run | operator_id | VARCHAR(50) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | batch_run | shift | VARCHAR(20) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | batch_run | notes | TEXT | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | batch_run | created_at | TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | parameter_reading | reading_id | VARCHAR(60) PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| LexingtonSite_DataMart | parameter_reading | param_code | VARCHAR(60) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | reading_ts | TIMESTAMP NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | param_value | NUMERIC(18,4) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | uom | VARCHAR(20) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | target_val | NUMERIC(18,4) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | lower_limit | NUMERIC(18,4) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | upper_limit | NUMERIC(18,4) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | in_spec | BOOLEAN NOT NULL DEFAULT TRUE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | aggregation | VARCHAR(30) DEFAULT 'RAW' | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | parameter_reading | ingested_at | TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | deviation_event | deviation_id | VARCHAR(50) PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| LexingtonSite_DataMart | deviation_event | batch_id | VARCHAR(50) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | run_id | VARCHAR(50) REFERENCES mart_a.batch_run(run_id) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | equip_id | VARCHAR(30) REFERENCES mart_a.equipment(equip_id) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | reading_id | VARCHAR(60) REFERENCES mart_a.parameter_reading(reading_id) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | detected_ts | TIMESTAMP NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | param_code | VARCHAR(60) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | deviation_desc | TEXT NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | severity | VARCHAR(20) NOT NULL DEFAULT 'medium' | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | dev_status | VARCHAR(30) NOT NULL DEFAULT 'open' | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | assigned_to | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | resolved_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | resolution_notes | TEXT | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | deviation_event | created_at | TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | shift_log | shift_log_id | BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key not required for integration |
| LexingtonSite_DataMart | shift_log | log_date | DATE NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | shift | VARCHAR(20) NOT NULL | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | supervisor_id | VARCHAR(50) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | supervisor_name | VARCHAR(150) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | active_batches | INTEGER NOT NULL DEFAULT 0 | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | completed_batches | INTEGER NOT NULL DEFAULT 0 | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | new_deviations | INTEGER NOT NULL DEFAULT 0 | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | equip_downtime_min | INTEGER NOT NULL DEFAULT 0 | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | shift_notes | TEXT | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| LexingtonSite_DataMart | shift_log | signed_off | BOOLEAN NOT NULL DEFAULT FALSE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | signed_off_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | shift_log | created_at | TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
