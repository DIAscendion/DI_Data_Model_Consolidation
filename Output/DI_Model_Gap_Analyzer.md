# Section 1 - Summary Statistics

| Metric | Value |
|---|---|
| Applications compared | 2 (Mart A: Lexington Site Operational Data Mart / PostgreSQL; Mart B: Enterprise Analytics Data Mart / Snowflake) |
| Mart A tables / columns | 5 tables / 70 columns |
| Mart B tables / columns | 5 tables / 65 columns |
| Total columns analyzed | 135 |
| Cross-application column pairs scored | 4,550 (70 x 65) |
| Matched pairs (score >= 40) | 34 |
| - Strong (85-100) | 6 |
| - Probable (60-84) | 14 |
| - Possible (40-59) | 14 |
| Distinct Mart A columns matched | 25 of 70 (35.7%) |
| Distinct Mart B columns matched | 25 of 65 (38.5%) |
| Unmatched columns (Section 3) | 85 (Mart A: 45; Mart B: 40) |
| Scoring weights | Name similarity 35% + Glossary/semantic 40% + Sample data pattern 25% |

# Section 2 - Column Matches (score >= 40, sorted descending)

| # | Score | Band | Mart A column (Lexington) | Mart B column (Enterprise) | Reason (signal cited) |
|---|---|---|---|---|---|
| 1 | 93 | Strong | batch_run.qty_unit | fact_batch_summary.qty_unit | Name: identical column name. Semantic: both are unit of measure for batch quantities. Pattern: identical VARCHAR(20) with shared value domain (L, vials, kg). |
| 2 | 90 | Strong | batch_run.yield_pct | fact_batch_summary.yield_pct | Name: identical. Semantic: same yield formula (actual/planned x 100), differing only in grain (step vs batch). Pattern: identical NUMERIC/NUMBER(6,3). |
| 3 | 90 | Strong | batch_run.qty_unit | fact_yield_analysis.qty_unit | Name: identical. Semantic: unit of measure for aggregated quantities. Pattern: VARCHAR(20), same value domain. |
| 4 | 88 | Strong | batch_run.planned_qty | fact_batch_summary.planned_qty | Name: identical. Semantic: planned production quantity (step vs batch grain). Pattern: identical (18,3) numeric. |
| 5 | 88 | Strong | batch_run.actual_qty | fact_batch_summary.actual_qty | Name: identical. Semantic: actual produced quantity. Pattern: identical (18,3) numeric. |
| 6 | 87 | Strong | equipment.asset_type | fact_batch_summary.asset_class | Name: shared "asset_" root, type vs class synonyms. Semantic: broad equipment category. Pattern: identical enumerated values (Bioreactor, Filling Machine, Lyophilizer), VARCHAR(80). |
| 7 | 82 | Probable | batch_run.batch_status | fact_batch_summary.batch_status | Name: identical. Semantic: current batch operational status. Pattern: enum overlap (COMPLETED/ON_HOLD/CANCELLED) but A is lowercase and adds failed/in_prog vs B uppercase ACTIVE; value normalization required. |
| 8 | 70 | Probable | batch_run.planned_qty | fact_yield_analysis.total_planned_qty | Name: shared "planned_qty" token. Semantic: step planned qty vs daily sum of planned qty (aggregation). Pattern: identical (18,3) numeric. |
| 9 | 70 | Probable | batch_run.actual_qty | fact_yield_analysis.total_actual_qty | Name: shared "actual_qty" token. Semantic: step actual qty vs daily sum (aggregation). Pattern: identical (18,3) numeric. |
| 10 | 69 | Probable | batch_run.start_ts | fact_batch_summary.start_timestamp_utc | Name: shared start + ts/timestamp. Semantic: batch/step start time. Pattern: A naive US/Eastern TIMESTAMP vs B TIMESTAMP_TZ UTC; timezone conversion required. |
| 11 | 69 | Probable | batch_run.end_ts | fact_batch_summary.end_timestamp_utc | Name: shared end + ts/timestamp. Semantic: batch/step end, NULL while running. Pattern: local vs UTC TZ conversion required. |
| 12 | 68 | Probable | batch_run.batch_id | fact_batch_summary.enterprise_batch_id | Name: shared "batch_id" token. Semantic: batch identifier; A site-local (may not match enterprise), B authoritative. Pattern: B format B-NNNN vs A site-local format; crosswalk required. |
| 13 | 68 | Probable | batch_run.yield_pct | fact_yield_analysis.avg_yield_pct | Name: shared "yield_pct" token. Semantic: single batch/step yield vs daily average of batch yields. Pattern: identical (6,3) numeric. |
| 14 | 66 | Probable | parameter_reading.batch_id | fact_batch_summary.enterprise_batch_id | Name: shared "batch_id" token. Semantic: denormalized batch id at reading time vs enterprise batch id. Pattern: site-local vs B-NNNN remap required. |
| 15 | 66 | Probable | deviation_event.batch_id | fact_batch_summary.enterprise_batch_id | Name: shared "batch_id" token. Semantic: batch on which deviation occurred vs enterprise batch id. Pattern: site-local vs B-NNNN remap required. |
| 16 | 66 | Probable | batch_run.yield_pct | fact_yield_analysis.min_yield_pct | Name: shared "yield_pct" token. Semantic: single yield vs per-day minimum of batch yields. Pattern: identical (6,3) numeric. |
| 17 | 66 | Probable | batch_run.yield_pct | fact_yield_analysis.max_yield_pct | Name: shared "yield_pct" token. Semantic: single yield vs per-day maximum of batch yields. Pattern: identical (6,3) numeric. |
| 18 | 63 | Probable | batch_run.product_code | dim_product.product_id | Name: shared "product_" root. Semantic: identifier of the product manufactured; A site-local code vs B enterprise product id. Pattern: differing code schemes require crosswalk. |
| 19 | 62 | Probable | shift_log.completed_batches | fact_yield_analysis.batch_count | Name: shared batch token (completed vs count). Semantic: both count completed batches (shift grain vs product-day grain). Pattern: integer counts. |
| 20 | 62 | Probable | batch_run.yield_pct | dim_product.standard_yield_pct | Name: shared "yield_pct" token. Semantic: actual yield vs validated target/benchmark yield (same metric family, target vs actual role). Pattern: identical (6,3) numeric. |
| 21 | 58 | Possible | shift_log.new_deviations | fact_batch_summary.deviation_count | Name: shared "deviation" token. Semantic: count of deviations; A per-shift new vs B per-batch total. Pattern: integer counts. |
| 22 | 57 | Possible | parameter_reading.ingested_at | fact_batch_summary.loaded_at_utc | Name: shared "_at" timestamp token. Semantic: mart ingest/load timestamp. Pattern: local TIMESTAMP vs UTC TIMESTAMP_TZ conversion. |
| 23 | 57 | Possible | batch_run.yield_pct | fact_yield_analysis.std_yield_pct | Name: shared "yield_pct" token. Semantic: single yield vs standard deviation of batch yields. Pattern: (8,4) vs (6,3) numeric. |
| 24 | 56 | Possible | shift_log.log_date | fact_yield_analysis.analysis_date | Name: shared "_date" token. Semantic: calendar date of a per-day summary record. Pattern: identical DATE type. |
| 25 | 54 | Possible | shift_log.active_batches | fact_yield_analysis.batch_count | Name: shared "batch" token. Semantic: count of batches; A in-progress-in-shift vs B completed-in-day. Pattern: integer counts. |
| 26 | 51 | Possible | batch_run.created_at | fact_batch_summary.loaded_at_utc | Name: shared "_at" token. Semantic: record creation vs mart load/refresh timestamp. Pattern: local vs UTC TZ conversion. |
| 27 | 51 | Possible | deviation_event.created_at | fact_yield_analysis.loaded_at_utc | Name: shared "_at" token. Semantic: record creation vs mart load/refresh timestamp. Pattern: local vs UTC TZ conversion. |
| 28 | 51 | Possible | shift_log.created_at | fact_yield_analysis.loaded_at_utc | Name: shared "_at" token. Semantic: record creation vs mart load/refresh timestamp. Pattern: local vs UTC TZ conversion. |
| 29 | 49 | Possible | equipment.equip_id | fact_batch_summary.primary_equipment_code | Name: shared equip + id/code. Semantic: equipment identifier; A site-local vs B enterprise asset code. Pattern: A LEX- prefix vs B enterprise asset-code format; remap required. |
| 30 | 49 | Possible | batch_run.equip_id | fact_batch_summary.primary_equipment_code | Name: shared equip + id/code. Semantic: equipment used for the step vs primary equipment of the batch. Pattern: LEX- prefix vs enterprise code; remap required. |
| 31 | 49 | Possible | parameter_reading.equip_id | fact_batch_summary.primary_equipment_code | Name: shared equip + id/code. Semantic: equipment that produced the reading vs primary batch equipment. Pattern: LEX- prefix vs enterprise code; remap required. |
| 32 | 49 | Possible | deviation_event.equip_id | fact_batch_summary.primary_equipment_code | Name: shared equip + id/code. Semantic: equipment associated with deviation vs primary batch equipment. Pattern: LEX- prefix vs enterprise code; remap required. |
| 33 | 49 | Possible | equipment.updated_at | fact_batch_summary.loaded_at_utc | Name: shared "_at" token. Semantic: source-record update timestamp vs mart load/refresh timestamp. Pattern: local TIMESTAMP vs UTC TIMESTAMP_TZ. |
| 34 | 43 | Possible | batch_run.product_code | dim_product.sku | Name: low overlap. Semantic: DDL explicitly notes product_code "may differ from enterprise SKU codes"; both are product identifiers. Pattern: differing code schemes require crosswalk. |

# Section 3 - Unmatched Columns (no cross-application match >= 40)

| Application | Table.Column | Type | Reason unmatched |
|---|---|---|---|
| A - Lexington | equipment.equip_name | VARCHAR(150) | Equipment descriptive name; Mart B has no equipment name attribute. |
| A - Lexington | equipment.manufacturer | VARCHAR(100) | OEM name; Mart B stores no equipment attributes. |
| A - Lexington | equipment.model_number | VARCHAR(100) | OEM model; Mart B stores no equipment attributes. |
| A - Lexington | equipment.install_date | DATE | Equipment install date; Mart B has no equipment lifecycle dates. |
| A - Lexington | equipment.calibration_due | DATE | Calibration schedule; Mart B has no calibration data. |
| A - Lexington | equipment.last_calibrated | DATE | Calibration history; Mart B has no calibration data. |
| A - Lexington | equipment.status | VARCHAR(30) | Equipment lifecycle status (active/inactive/under_maintenance/retired); different entity than batch_status, semantic score below 40. |
| A - Lexington | equipment.line_id | VARCHAR(30) | Manufacturing line; Mart B has no line dimension. |
| A - Lexington | equipment.building | VARCHAR(50) | Site building/wing; Mart B has no sub-site location. |
| A - Lexington | batch_run.run_id | VARCHAR(50) | Step-execution primary key; Mart B is batch grain with no step/run identifier. |
| A - Lexington | batch_run.step_name | VARCHAR(100) | Process step name; Mart B has no step-level data. |
| A - Lexington | batch_run.step_seq | INTEGER | Step sequence order; Mart B has no step-level data. |
| A - Lexington | batch_run.operator_id | VARCHAR(50) | Operator identifier; Mart B has no personnel data. |
| A - Lexington | batch_run.shift | VARCHAR(20) | Shift indicator; Mart B has no shift concept. |
| A - Lexington | batch_run.notes | TEXT | Operator free-text notes; Mart B has no batch notes. |
| A - Lexington | parameter_reading.reading_id | VARCHAR(60) | Sensor reading primary key; Mart B is batch grain with no sensor data. |
| A - Lexington | parameter_reading.run_id | VARCHAR(50) | FK to step run; Mart B has no step/run. |
| A - Lexington | parameter_reading.param_code | VARCHAR(60) | Parameter code (TEMP/PH/PRESSURE); Mart B has no parameter data. |
| A - Lexington | parameter_reading.reading_ts | TIMESTAMP | Sensor reading time; Mart B has no sensor timestamps. |
| A - Lexington | parameter_reading.param_value | NUMERIC(18,4) | Measured parameter value; Mart B has no sensor data. |
| A - Lexington | parameter_reading.uom | VARCHAR(20) | Unit for parameter values (C/pH/PSI/RPM); value domain disjoint from qty_unit, score below 40. |
| A - Lexington | parameter_reading.target_val | NUMERIC(18,4) | Recipe target value; Mart B has no parameter targets. |
| A - Lexington | parameter_reading.lower_limit | NUMERIC(18,4) | Lower spec limit; Mart B has no parameter limits. |
| A - Lexington | parameter_reading.upper_limit | NUMERIC(18,4) | Upper spec limit; Mart B has no parameter limits. |
| A - Lexington | parameter_reading.in_spec | BOOLEAN | Out-of-spec flag; Mart B has no parameter spec evaluation. |
| A - Lexington | parameter_reading.aggregation | VARCHAR(30) | Reading aggregation level (RAW/AVG_x); Mart B has no sensor data. |
| A - Lexington | deviation_event.deviation_id | VARCHAR(50) | Deviation event key (DEV-LEX-NNNN); Mart B holds only a deviation_count, no deviation records. |
| A - Lexington | deviation_event.run_id | VARCHAR(50) | FK to step run; Mart B has no step/run. |
| A - Lexington | deviation_event.reading_id | VARCHAR(60) | FK to sensor reading; Mart B has no sensor data. |
| A - Lexington | deviation_event.detected_ts | TIMESTAMP | Deviation detection time; Mart B has no deviation records. |
| A - Lexington | deviation_event.param_code | VARCHAR(60) | Out-of-spec parameter; Mart B has no parameter data. |
| A - Lexington | deviation_event.deviation_desc | TEXT | Per-event free-text; disposition.description is unrelated static reference text, score below 40. |
| A - Lexington | deviation_event.severity | VARCHAR(20) | Deviation severity (low/medium/high/critical); Mart B has no deviation severity. |
| A - Lexington | deviation_event.dev_status | VARCHAR(30) | Investigation status (open/investigating/resolved/closed); Mart B has no deviation workflow. |
| A - Lexington | deviation_event.assigned_to | VARCHAR(100) | Investigation assignee; Mart B has no personnel data. |
| A - Lexington | deviation_event.resolved_ts | TIMESTAMP | Resolution time; Mart B has no deviation workflow. |
| A - Lexington | deviation_event.resolution_notes | TEXT | Resolution narrative; Mart B has no deviation workflow. |
| A - Lexington | shift_log.shift_log_id | BIGINT | Shift log primary key; Mart B has no shift concept. |
| A - Lexington | shift_log.shift | VARCHAR(20) | Shift name; Mart B has no shift concept. |
| A - Lexington | shift_log.supervisor_id | VARCHAR(50) | Supervisor identifier; Mart B has no personnel data. |
| A - Lexington | shift_log.supervisor_name | VARCHAR(150) | Supervisor full name; Mart B has no personnel data. |
| A - Lexington | shift_log.equip_downtime_min | INTEGER | Downtime minutes; Mart B OEE availability_pct uses a different unit and definition, score below 40. |
| A - Lexington | shift_log.shift_notes | TEXT | Shift narrative notes; Mart B has no shift data. |
| A - Lexington | shift_log.signed_off | BOOLEAN | Supervisor sign-off flag; Mart B has no shift data. |
| A - Lexington | shift_log.signed_off_ts | TIMESTAMP | Sign-off timestamp; Mart B has no shift data. |
| B - Enterprise | dim_facility.facility_key | NUMBER | Surrogate key; Mart A has no facility dimension. |
| B - Enterprise | dim_facility.facility_id | VARCHAR(30) | Facility code (FAC-XXX-NN); Mart A (single-site) has no facility identifier. |
| B - Enterprise | dim_facility.facility_name | VARCHAR(150) | Facility name; none in Mart A. |
| B - Enterprise | dim_facility.site_code | VARCHAR(20) | Site code (LEX/NR/SD); Mart A is implicitly single-site with no site column. |
| B - Enterprise | dim_facility.city | VARCHAR(100) | Facility city; none in Mart A. |
| B - Enterprise | dim_facility.state_region | VARCHAR(100) | Facility state/region; none in Mart A. |
| B - Enterprise | dim_facility.country_code | CHAR(2) | ISO country code; none in Mart A. |
| B - Enterprise | dim_facility.timezone_name | VARCHAR(80) | IANA timezone; Mart A timestamps are implicitly US/Eastern with no timezone column. |
| B - Enterprise | dim_facility.gmp_certified | BOOLEAN | GMP certification flag; none in Mart A. |
| B - Enterprise | dim_facility.effective_start_date | DATE | SCD2 validity start; Mart A overwrites in place (no versioning). |
| B - Enterprise | dim_facility.effective_end_date | DATE | SCD2 validity end; Mart A has no versioning. |
| B - Enterprise | dim_facility.current_flag | BOOLEAN | SCD2 current-version flag; Mart A has no versioning. |
| B - Enterprise | dim_product.product_key | NUMBER | Surrogate key; Mart A has no product dimension. |
| B - Enterprise | dim_product.product_name | VARCHAR(150) | Registered product name; Mart A stores only a product_code, no name. |
| B - Enterprise | dim_product.formulation_id | VARCHAR(60) | Formulation identifier; Mart A has no product attributes. |
| B - Enterprise | dim_product.dosage_form | VARCHAR(80) | Dosage form; Mart A has no product attributes. |
| B - Enterprise | dim_product.therapeutic_class | VARCHAR(100) | Therapeutic class; Mart A has no product attributes. |
| B - Enterprise | dim_product.effective_start_date | DATE | SCD2 validity start; Mart A has no versioning. |
| B - Enterprise | dim_product.effective_end_date | DATE | SCD2 validity end; Mart A has no versioning. |
| B - Enterprise | dim_product.current_flag | BOOLEAN | SCD2 current-version flag; Mart A has no versioning. |
| B - Enterprise | dim_quality_disposition.disposition_key | NUMBER | Surrogate key; Mart A has no QA disposition reference. |
| B - Enterprise | dim_quality_disposition.disposition_code | VARCHAR(40) | QA disposition code (RELEASED/REJECTED/PENDING_QA); Mart A has no QA release disposition (operational statuses differ), score below 40. |
| B - Enterprise | dim_quality_disposition.disposition_name | VARCHAR(100) | Disposition descriptive name; none in Mart A. |
| B - Enterprise | dim_quality_disposition.requires_investigation | BOOLEAN | QA policy flag; none in Mart A. |
| B - Enterprise | dim_quality_disposition.commercially_releasable | BOOLEAN | Commercial-release eligibility; none in Mart A. |
| B - Enterprise | dim_quality_disposition.deviation_implied | BOOLEAN | Disposition-implies-deviation flag; none in Mart A. |
| B - Enterprise | dim_quality_disposition.description | VARCHAR(500) | Static disposition description; no equivalent reference text in Mart A. |
| B - Enterprise | fact_batch_summary.batch_summary_key | NUMBER | Surrogate key; none in Mart A. |
| B - Enterprise | fact_batch_summary.facility_key | NUMBER | FK to facility dimension; Mart A has no facility dimension. |
| B - Enterprise | fact_batch_summary.product_key | NUMBER | FK to product dimension; Mart A has no product surrogate. |
| B - Enterprise | fact_batch_summary.disposition_key | NUMBER | FK to disposition dimension; none in Mart A. |
| B - Enterprise | fact_batch_summary.availability_pct | NUMBER(6,3) | OEE availability component; Mart A has no OEE metrics. |
| B - Enterprise | fact_batch_summary.performance_pct | NUMBER(6,3) | OEE performance component; Mart A has no OEE metrics. |
| B - Enterprise | fact_batch_summary.quality_pct | NUMBER(6,3) | OEE quality component; Mart A has no OEE metrics. |
| B - Enterprise | fact_batch_summary.oee_pct | NUMBER(6,3) | Overall OEE; Mart A has no OEE metrics. |
| B - Enterprise | fact_batch_summary.source_site_code | VARCHAR(20) | Originating site code; Mart A is single-site with no site column. |
| B - Enterprise | fact_yield_analysis.yield_analysis_key | NUMBER | Surrogate key; none in Mart A. |
| B - Enterprise | fact_yield_analysis.facility_key | NUMBER | FK to facility dimension; none in Mart A. |
| B - Enterprise | fact_yield_analysis.product_key | NUMBER | FK to product dimension; none in Mart A. |
| B - Enterprise | fact_yield_analysis.below_target_count | NUMBER | Count of batches below standard yield; Mart A has no pre-aggregated yield-vs-target metric. |
