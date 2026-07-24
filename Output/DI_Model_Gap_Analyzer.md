### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 62 | 100% |
| Attributes mapped ≥80% match | 21 | 33.9% |
| Attributes mapped 40–79% match | 17 | 27.4% |
| Attributes not mapped (no match ≥40) | 24 | 38.7% |
| Total matched pairs identified | 26 | — |
| Total unmatched columns | 24 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | facility_id | LexingtonSite_DataMart | equipment | equip_id | 95 | Name similarity (facility_id ≈ equip_id); glossary both define as unique identifier for location/equipment; sample data both use prefix codes (FAC-XXX-NN vs LEX-RCTR-01) | Map prefix FAC-XXX-NN to LEX-RCTR-XX using regex replace; enforce uniqueness |
| EnterpriseAnalyticsDataMart | dim_facility | facility_name | LexingtonSite_DataMart | equipment | equip_name | 92 | Name similarity; glossary both as official name; sample data both free text up to 150 chars | Cast VARCHAR(150) to VARCHAR(150); direct map |
| EnterpriseAnalyticsDataMart | dim_facility | asset_class | LexingtonSite_DataMart | equipment | asset_type | 89 | Glossary similarity (both reference equipment class); sample data both show categories like Bioreactor, Filling Machine | Normalize asset_class to asset_type via lookup table |
| EnterpriseAnalyticsDataMart | dim_facility | city | LexingtonSite_DataMart | equipment | building | 68 | Glossary similarity (location context); sample data both reference site location (city vs building) | Map city to building via reference table; cast VARCHAR(100) to VARCHAR(50) |
| EnterpriseAnalyticsDataMart | dim_facility | country_code | LexingtonSite_DataMart | equipment | manufacturer | 55 | Weak semantic match (country_code ≈ manufacturer location); sample data shows US, DE, JP vs manufacturer names | Map ISO country code to manufacturer country via lookup; cast CHAR(2) to VARCHAR(100) |
| EnterpriseAnalyticsDataMart | dim_product | product_id | LexingtonSite_DataMart | batch_run | product_code | 90 | Name similarity; glossary both as product identifier; sample data both alphanumeric codes | Cast VARCHAR(50) to VARCHAR(50); direct map |
| EnterpriseAnalyticsDataMart | dim_product | product_name | LexingtonSite_DataMart | batch_run | step_name | 62 | Glossary similarity (both reference product/process step); sample data both free text | Map product_name to step_name via lookup; cast VARCHAR(150) to VARCHAR(100) |
| EnterpriseAnalyticsDataMart | dim_product | sku | LexingtonSite_DataMart | batch_run | batch_id | 65 | Glossary similarity (sku ≈ batch_id for site-local); sample data both codes | Map sku to batch_id via lookup; cast VARCHAR(60) to VARCHAR(50) |
| EnterpriseAnalyticsDataMart | fact_batch_summary | enterprise_batch_id | LexingtonSite_DataMart | batch_run | batch_id | 87 | Name similarity; glossary both as batch identifier; sample data both codes (B-NNNN vs RUN-YYYYMMDD-NN) | Map enterprise_batch_id to batch_id via regex transform; enforce uniqueness |
| EnterpriseAnalyticsDataMart | fact_batch_summary | facility_key | LexingtonSite_DataMart | batch_run | equip_id | 80 | Glossary similarity (facility_key links to equipment); sample data numeric vs string | Cast NUMBER to VARCHAR(30); lookup table for mapping |
| EnterpriseAnalyticsDataMart | fact_batch_summary | product_key | LexingtonSite_DataMart | batch_run | product_code | 85 | Name similarity; glossary both as product reference; sample data numeric vs string | Cast NUMBER to VARCHAR(50); lookup table for mapping |
| EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | LexingtonSite_DataMart | batch_run | batch_status | 90 | Name similarity; glossary both reference operational status; sample data both show ACTIVE/completed/on_hold | Map ACTIVE/completed/on_hold/cancelled to in_prog/completed/on_hold/cancelled via lookup |
| EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | LexingtonSite_DataMart | batch_run | planned_qty | 93 | Name similarity; glossary both as planned production quantity; sample data both numeric | Cast NUMBER(18,3) to NUMERIC(18,3); direct map |
| EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | LexingtonSite_DataMart | batch_run | actual_qty | 93 | Name similarity; glossary both as actual quantity produced; sample data both numeric | Cast NUMBER(18,3) to NUMERIC(18,3); direct map |
| EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | LexingtonSite_DataMart | batch_run | qty_unit | 92 | Name similarity; glossary both as unit of measure; sample data both text (L, vials, kg) | Cast VARCHAR(20) to VARCHAR(20); direct map |
| EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | LexingtonSite_DataMart | batch_run | yield_pct | 90 | Name similarity; glossary both as yield percentage; sample data both numeric (range 0–100) | Cast NUMBER(6,3) to NUMERIC(6,3); direct map |
| EnterpriseAnalyticsDataMart | fact_batch_summary | deviation_count | LexingtonSite_DataMart | deviation_event | deviation_id | 45 | Weak match (deviation_count ≈ deviation_id for event tracking); sample data numeric vs string | Map deviation_count to deviation_id via aggregation; cast NUMBER to VARCHAR(50) |
| EnterpriseAnalyticsDataMart | fact_batch_summary | source_site_code | LexingtonSite_DataMart | equipment | line_id | 50 | Weak semantic match (source_site_code ≈ line_id for site context); sample data both codes | Map site_code to line_id via lookup; cast VARCHAR(20) to VARCHAR(30) |
| EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | LexingtonSite_DataMart | equipment | updated_at | 88 | Name similarity; glossary both as record load/update timestamp; sample data both timestamps | Reformat timestamp from UTC to US/Eastern using timezone conversion |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_code | LexingtonSite_DataMart | batch_run | batch_status | 70 | Glossary similarity (disposition_code ≈ batch_status for quality state); sample data both codes | Map disposition_code to batch_status via lookup |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_name | LexingtonSite_DataMart | deviation_event | deviation_desc | 60 | Glossary similarity (disposition_name ≈ deviation_desc for description); sample data both free text | Map disposition_name to deviation_desc via lookup; cast VARCHAR(100) to TEXT |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | requires_investigation | LexingtonSite_DataMart | deviation_event | severity | 65 | Glossary similarity (requires_investigation ≈ severity for event escalation); sample data TRUE/critical | Map TRUE to critical via lookup; cast BOOLEAN to VARCHAR(20) |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | commercially_releasable | LexingtonSite_DataMart | batch_run | batch_status | 50 | Weak semantic match (commercially_releasable ≈ batch_status for release eligibility); sample data TRUE/completed | Map TRUE to completed via lookup; cast BOOLEAN to VARCHAR(30) |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | deviation_implied | LexingtonSite_DataMart | deviation_event | dev_status | 55 | Weak semantic match (deviation_implied ≈ dev_status for deviation event); sample data TRUE/open | Map TRUE to open via lookup; cast BOOLEAN to VARCHAR(30) |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | description | LexingtonSite_DataMart | deviation_event | resolution_notes | 42 | Glossary similarity (description ≈ resolution_notes for event description); sample data both free text | Map description to resolution_notes via lookup; cast VARCHAR(500) to TEXT |
| EnterpriseAnalyticsDataMart | fact_yield_analysis | avg_yield_pct | LexingtonSite_DataMart | batch_run | yield_pct | 90 | Name similarity; glossary both as yield metric; sample data numeric | Cast NUMBER(6,3) to NUMERIC(6,3); direct map |
| EnterpriseAnalyticsDataMart | fact_yield_analysis | qty_unit | LexingtonSite_DataMart | batch_run | qty_unit | 92 | Name similarity; glossary both as unit of measure; sample data both text | Cast VARCHAR(20) to VARCHAR(20); direct map |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | state_region | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | timezone_name | VARCHAR(80) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | gmp_certified | BOOLEAN | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | effective_start_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | effective_end_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_facility | current_flag | BOOLEAN | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | formulation_id | VARCHAR(60) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | dosage_form | VARCHAR(80) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | therapeutic_class | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | effective_start_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | effective_end_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_product | current_flag | BOOLEAN | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_key | NUMBER AUTOINCREMENT | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | loaded_at_utc | TIMESTAMP_TZ | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | batch_summary_key | NUMBER AUTOINCREMENT | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc | TIMESTAMP_TZ | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | performance_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | quality_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| EnterpriseAnalyticsDataMart | fact_batch_summary | oee_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | equipment | model_number | VARCHAR(100) | Free text, OEM model codes | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | equipment | calibration_due | DATE | Date format YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | equipment | last_calibrated | DATE | Date format YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |
| LexingtonSite_DataMart | equipment | status | VARCHAR(30) | Codes: active, inactive, under_maintenance, retired | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| LexingtonSite_DataMart | equipment | line_id | VARCHAR(30) | Codes: LINE-A, LINE-B, LINE-C | Best match score below 40 — best score: 34 | Review with business — possible manual mapping needed |
| LexingtonSite_DataMart | equipment | building | VARCHAR(50) | Free text, e.g., Building-1 | Best match score below 40 — best score: 36 | Review with business — possible manual mapping needed |
| LexingtonSite_DataMart | equipment | updated_at | TIMESTAMP | Timestamp format YYYY-MM-DD HH:MM | Best match score below 40 — best score: 37 | Review with business — possible manual mapping needed |
| LexingtonSite_DataMart | equipment | manufacturer | VARCHAR(100) | Manufacturer names | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| LexingtonSite_DataMart | equipment | install_date | DATE | Date format YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |