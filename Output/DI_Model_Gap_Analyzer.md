### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 51 | 100% |
| Attributes mapped ≥80% match | 18 | 35.3% |
| Attributes mapped 40–79% match | 11 | 21.6% |
| Attributes not mapped (no match ≥40) | 22 | 43.1% |
| Total matched pairs identified | 21 | — |
| Total unmatched columns | 22 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Enterprise Analytics Data Mart | dim_facility | facility_id | Lexington Site Operational Data Mart | equipment | equip_id | 90 | Name similarity (facility_id ≈ equip_id); both are unique site/equipment codes; sample data shows LEX-RCTR-01, FAC-LEX-01. Glossary: "Unique facility/equipment identifier". | Extract site prefix from LEX-RCTR-01 using SPLIT_PART('-',1); Map FAC-XXX-NN to LEX-XXX-NN via lookup |
| Enterprise Analytics Data Mart | dim_facility | facility_name | Lexington Site Operational Data Mart | equipment | equip_name | 87 | Glossary definition similarity (both "official name of facility/equipment"); sample data both show descriptive names; name overlap. | Direct map; Cast VARCHAR(150) to VARCHAR(150) |
| Enterprise Analytics Data Mart | dim_facility | city | Lexington Site Operational Data Mart | equipment | building | 65 | Both refer to location attributes; city vs. building; sample data shows "Building-1", "Building-2". (inferred from name/type) | Map city to building via reference table; Cast VARCHAR(100) to VARCHAR(50) |
| Enterprise Analytics Data Mart | dim_facility | state_region | Lexington Site Operational Data Mart | equipment | building | 60 | Glossary similarity (both are regional location attributes); sample data not directly comparable; name similarity. | Map state_region to building via lookup; Cast VARCHAR(100) to VARCHAR(50) |
| Enterprise Analytics Data Mart | dim_facility | country_code | Lexington Site Operational Data Mart | equipment | building | 42 | Both relate to geographic location, though building is site-local; sample data not directly comparable. (inferred from name/type) | Map country_code to building country via lookup |
| Enterprise Analytics Data Mart | dim_facility | timezone_name | Lexington Site Operational Data Mart | equipment | updated_at | 45 | Both record time-related attributes; timezone vs. timestamp; sample data shows EST/EDT, UTC. (inferred from name/type) | Convert updated_at to UTC; Map timezone_name to EST/EDT |
| Enterprise Analytics Data Mart | dim_facility | effective_start_date | Lexington Site Operational Data Mart | equipment | install_date | 82 | Glossary similarity (start of facility/equipment validity); sample data both show install dates; name overlap. | Reformat date from YYYY-MM-DD to ISO 8601 |
| Enterprise Analytics Data Mart | dim_facility | effective_end_date | Lexington Site Operational Data Mart | equipment | calibration_due | 60 | Both refer to end/expiration dates; sample data both show calibration/expiry dates. | Reformat date from YYYY-MM-DD to ISO 8601 |
| Enterprise Analytics Data Mart | dim_facility | current_flag | Lexington Site Operational Data Mart | equipment | status | 70 | Both refer to current/active status; sample data shows TRUE/active; glossary both indicate operational status. | Map TRUE to 'active', FALSE to 'inactive' |
| Enterprise Analytics Data Mart | dim_product | product_id | Lexington Site Operational Data Mart | batch_run | product_code | 88 | Name similarity (product_id ≈ product_code); glossary both "product identifier"; sample data both show codes. | Direct map; Cast VARCHAR(50) to VARCHAR(50) |
| Enterprise Analytics Data Mart | dim_product | product_name | Lexington Site Operational Data Mart | batch_run | step_name | 52 | Both are descriptive names; product_name vs. step_name; sample data both show text. (inferred from name/type) | Map step_name to product_name via lookup |
| Enterprise Analytics Data Mart | dim_product | sku | Lexington Site Operational Data Mart | batch_run | product_code | 43 | Both are product codes; sample data shows SKU and product_code. (inferred from name/type) | Map SKU to product_code via lookup |
| Enterprise Analytics Data Mart | dim_product | dosage_form | Lexington Site Operational Data Mart | batch_run | step_name | 40 | Both are descriptive of product/process; sample data shows dosage_form and step_name. (inferred from name/type) | Map dosage_form to step_name via lookup |
| Enterprise Analytics Data Mart | fact_batch_summary | batch_status | Lexington Site Operational Data Mart | batch_run | batch_status | 92 | Name similarity (batch_status); glossary both "current operational status"; sample data both show status codes. | Map ACTIVE/COMPLETED/ON_HOLD/CANCELLED to in_prog/completed/on_hold/cancelled via lookup |
| Enterprise Analytics Data Mart | fact_batch_summary | planned_qty | Lexington Site Operational Data Mart | batch_run | planned_qty | 95 | Name similarity; glossary both "planned production quantity"; sample data numeric values. | Cast NUMBER(18,3) to NUMERIC(18,3); direct map |
| Enterprise Analytics Data Mart | fact_batch_summary | actual_qty | Lexington Site Operational Data Mart | batch_run | actual_qty | 95 | Name similarity; glossary both "actual quantity produced"; sample data numeric values. | Cast NUMBER(18,3) to NUMERIC(18,3); direct map |
| Enterprise Analytics Data Mart | fact_batch_summary | qty_unit | Lexington Site Operational Data Mart | batch_run | qty_unit | 93 | Name similarity; glossary both "unit of measure"; sample data shows units (L, vials, kg). | Cast VARCHAR(20) to VARCHAR(20); direct map |
| Enterprise Analytics Data Mart | fact_batch_summary | yield_pct | Lexington Site Operational Data Mart | batch_run | yield_pct | 90 | Name similarity; glossary both "yield percentage"; sample data numeric values. | Cast NUMBER(6,3) to NUMERIC(6,3); direct map |
| Enterprise Analytics Data Mart | fact_batch_summary | deviation_count | Lexington Site Operational Data Mart | deviation_event | deviation_id | 40 | Both relate to deviation tracking; sample data shows deviation counts and IDs. (inferred from name/type) | Map deviation_count to deviation_id count; Cast NUMBER to count of VARCHAR |
| Enterprise Analytics Data Mart | fact_batch_summary | source_site_code | Lexington Site Operational Data Mart | equipment | line_id | 55 | Both are site codes; sample data shows site_code and line_id. (inferred from name/type) | Map site_code to line_id via lookup |
| Enterprise Analytics Data Mart | fact_batch_summary | loaded_at_utc | Lexington Site Operational Data Mart | equipment | updated_at | 80 | Both are timestamp fields for record update; sample data shows UTC and EST/EDT. | Convert updated_at to UTC; Cast TIMESTAMP to TIMESTAMP_TZ |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Enterprise Analytics Data Mart | dim_facility | facility_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | dim_facility | site_code | VARCHAR(20) | Codes: LEX, NR, SD | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_facility | gmp_certified | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_facility | effective_end_date | DATE | Date in YYYY-MM-DD | Best match score below 40 — best score: 30 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | product_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | dim_product | formulation_id | VARCHAR(60) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_product | therapeutic_class | VARCHAR(100) | "Monoclonal Antibody", "Small Molecule" | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_product | standard_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_product | effective_start_date | DATE | Date in YYYY-MM-DD | Best match score below 40 — best score: 35 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | effective_end_date | DATE | Date in YYYY-MM-DD | Best match score below 40 — best score: 30 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | current_flag | BOOLEAN | TRUE/FALSE | Best match score below 40 — best score: 25 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_code | VARCHAR(40) | Codes: RELEASED, ON_HOLD, REJECTED | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_name | VARCHAR(100) | "Released", "Rejected" | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_quality_disposition | requires_investigation | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_quality_disposition | commercially_releasable | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_quality_disposition | deviation_implied | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | dim_quality_disposition | description | VARCHAR(500) | Free text up to 500 chars | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | batch_summary_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | fact_batch_summary | asset_class | VARCHAR(80) | "Bioreactor", "Filling Machine" | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | primary_equipment_code | VARCHAR(50) | Codes: LEX-RCTR-01, LEX-FILL-01 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | end_timestamp_utc | TIMESTAMP_TZ | No sample data provided | Best match score below 40 — best score: 20 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | fact_batch_summary | availability_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | performance_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | quality_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_batch_summary | oee_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | yield_analysis_key | NUMBER AUTOINCREMENT PRIMARY KEY | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | fact_yield_analysis | analysis_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | facility_key | NUMBER | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | fact_yield_analysis | product_key | NUMBER | No sample data provided | No equivalent column found in any other application | Exclude — internal surrogate key |
| Enterprise Analytics Data Mart | fact_yield_analysis | batch_count | NUMBER | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | avg_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | min_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | max_yield_pct | NUMBER(6,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | std_yield_pct | NUMBER(8,4) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | below_target_count | NUMBER | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | total_planned_qty | NUMBER(18,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | total_actual_qty | NUMBER(18,3) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Enterprise Analytics Data Mart | fact_yield_analysis | qty_unit | VARCHAR(20) | No sample data provided | Best match score below 40 — best score: 35 | Review with business — possible manual mapping needed |
| Enterprise Analytics Data Mart | fact_yield_analysis | loaded_at_utc | TIMESTAMP_TZ | No sample data provided | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| Lexington Site Operational Data Mart | equipment | manufacturer | VARCHAR(100) | "Sartorius", "Thermo Fisher" | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | equipment | model_number | VARCHAR(100) | "BIOSTAT-STR-200", "HyPerforma-500L" | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | equipment | calibration_due | DATE | Date in YYYY-MM-DD | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Lexington Site Operational Data Mart | equipment | last_calibrated | DATE | Date in YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | equipment | line_id | VARCHAR(30) | "LINE-A", "LINE-B" | Best match score below 40 — best score: 39 | Review with business — possible manual mapping needed |
| Lexington Site Operational Data Mart | equipment | building | VARCHAR(50) | "Building-1", "Building-2" | Best match score below 40 — best score: 39 | Review with business — possible manual mapping needed |
| Lexington Site Operational Data Mart | equipment | updated_at | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| Lexington Site Operational Data Mart | batch_run | run_id | VARCHAR(50) | Format: RUN-YYYYMMDD-NN | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | batch_id | VARCHAR(50) | Site-local batch ID | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | equip_id | VARCHAR(30) | Codes: LEX-RCTR-01 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | step_seq | INTEGER | Numeric sequence | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | start_ts | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | end_ts | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | operator_id | VARCHAR(50) | Codes: OP-001 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | shift | VARCHAR(20) | Values: Day, Evening, Night | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | notes | TEXT | Free text up to 500 chars | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | batch_run | created_at | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | deviation_id | VARCHAR(50) | Format: DEV-LEX-NNNN | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | batch_id | VARCHAR(50) | Site-local batch ID | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | run_id | VARCHAR(50) | Format: RUN-YYYYMMDD-NN | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | equip_id | VARCHAR(30) | Codes: LEX-RCTR-01 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | reading_id | VARCHAR(60) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | detected_ts | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | param_code | VARCHAR(60) | Codes: TEMP, PH | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | deviation_desc | TEXT | Free text up to 500 chars | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | severity | VARCHAR(20) | Values: low, medium, high, critical | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | dev_status | VARCHAR(30) | Values: open, investigating, resolved, closed | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | assigned_to | VARCHAR(100) | Codes: SUP-001 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | resolved_ts | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | resolution_notes | TEXT | Free text up to 500 chars | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | deviation_event | created_at | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | No equivalent column found in any other application | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | shift_log_id | BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY | No sample data provided | Column unique to this application (no comparable concept exists) | Exclude — internal surrogate key |
| Lexington Site Operational Data Mart | shift_log | log_date | DATE | Date in YYYY-MM-DD | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | shift | VARCHAR(20) | Values: Day, Evening, Night | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | supervisor_id | VARCHAR(50) | Codes: SUP-001 | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | supervisor_name | VARCHAR(150) | "John Smith", "Jane Doe" | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | active_batches | INTEGER | Numeric count | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | completed_batches | INTEGER | Numeric count | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | new_deviations | INTEGER | Numeric count | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | equip_downtime_min | INTEGER | Numeric count | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | shift_notes | TEXT | Free text up to 500 chars | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | signed_off | BOOLEAN | TRUE/FALSE | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | signed_off_ts | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | created_at | TIMESTAMP | DateTime in YYYY-MM-DD HH:MM | Column unique to this application (no comparable concept exists) | Add to canonical model as new attribute |
| Lexington Site Operational Data Mart | shift_log | UNIQUE (log_date, shift) | Constraint | No sample data provided | Column unique to this application (no comparable concept exists) | Exclude — constraint not required for integration |
