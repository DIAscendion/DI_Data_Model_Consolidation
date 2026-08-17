# Databricks notebook source
# MAGIC %md
# MAGIC # DI Model Gap Analyzer
# MAGIC ## Data Integration Gap Assessment
# MAGIC **Application A (source):** Lexington Site Operational Data Mart (`mart_a`, PostgreSQL 14+)
# MAGIC **Application B (target):** Enterprise Analytics Data Mart (`mart_b`, Snowflake)
# MAGIC
# MAGIC Every column from both applications is classified into exactly one of:
# MAGIC Section 2 (Column Matches, score >= 40) or Section 3 (Unmatched Columns). No column is dropped.
# MAGIC
# MAGIC **Scoring model (0-100):** name similarity (35%) + glossary/semantic similarity (40%) + sample-data pattern match (25%).
# MAGIC **Bands:** 85-100 strong | 60-84 probable | 40-59 possible | below 40 excluded from matches.

# COMMAND ----------

# MAGIC %md
# MAGIC ## Notebook setup
# MAGIC Builds pandas DataFrames for each section. `display()` is used for Databricks rendering, with a print fallback.

# COMMAND ----------

import pandas as pd

def show(df):
    try:
        display(df)          # Databricks native renderer
    except NameError:
        print(df.to_string(index=False))

# COMMAND ----------

# MAGIC %md
# MAGIC # SECTION 1 - Summary Statistics

# COMMAND ----------

# Section 1: Summary statistics for the cross-application gap assessment.
summary_rows = [
    ("Application A tables (Lexington / mart_a)", 5),
    ("Application A columns", 70),
    ("Application B tables (Enterprise / mart_b)", 5),
    ("Application B columns", 65),
    ("Total columns analyzed (A + B)", 135),
    ("Cross-application column pairs scored (70 x 65)", 4550),
    ("Matched pairs (score >= 40) in Section 2", 34),
    ("  - Strong (85-100)", 6),
    ("  - Probable (60-84)", 14),
    ("  - Possible (40-59)", 14),
    ("Distinct App A columns matched", 24),
    ("Distinct App B columns matched", 24),
    ("Unmatched App A columns (Section 3)", 46),
    ("Unmatched App B columns (Section 3)", 41),
    ("Total unmatched columns (Section 3)", 87),
]
summary_df = pd.DataFrame(summary_rows, columns=["Metric", "Value"])
show(summary_df)

# COMMAND ----------

# MAGIC %md
# MAGIC # SECTION 2 - Column Matches (score >= 40)
# MAGIC Each cross-application pair is listed once and sorted by score descending.
# MAGIC `reason` cites the specific signal(s) used: name / glossary-semantic / sample-pattern.
# MAGIC Transformation notes touching PII are prefixed with "PII" (none apply in this dataset:
# MAGIC no email, SSN, DOB, salary, phone, or address columns participate in a match).

# COMMAND ----------

# Columns: score, band, A app/table.column, A type, B app/table.column, B type, reason/signal
matches = [
    (88.5, "strong",
     "A.batch_run.qty_unit", "VARCHAR(20)",
     "B.fact_batch_summary.qty_unit", "VARCHAR(20)",
     "Name identical (qty_unit); glossary both define unit of measure for planned/actual quantities; pattern same VARCHAR(20) code-value domain."),
    (88.5, "strong",
     "A.batch_run.qty_unit", "VARCHAR(20)",
     "B.fact_yield_analysis.qty_unit", "VARCHAR(20)",
     "Name identical (qty_unit); glossary both define unit of measure for quantities (B at aggregated grain); pattern same VARCHAR(20)."),
    (86.5, "strong",
     "A.batch_run.batch_status", "VARCHAR(30)",
     "B.fact_batch_summary.batch_status", "VARCHAR(30)",
     "Name identical (batch_status); glossary both = current operational status of a batch; pattern overlapping value sets (on_hold/cancelled/completed). Transformation: normalize status vocabulary/case (A lowercase in_prog|failed vs B uppercase ACTIVE|COMPLETED)."),
    (86.5, "strong",
     "A.batch_run.planned_qty", "NUMERIC(18,3)",
     "B.fact_batch_summary.planned_qty", "NUMBER(18,3)",
     "Name identical (planned_qty); glossary both = planned production quantity; pattern identical (18,3) decimal. Grain differs (A step vs B batch)."),
    (86.5, "strong",
     "A.batch_run.actual_qty", "NUMERIC(18,3)",
     "B.fact_batch_summary.actual_qty", "NUMBER(18,3)",
     "Name identical (actual_qty); glossary both = actual quantity produced; pattern identical (18,3) decimal. Grain differs (A step vs B batch)."),
    (86.5, "strong",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.fact_batch_summary.yield_pct", "NUMBER(6,3)",
     "Name identical (yield_pct); glossary both = yield percentage (actual/planned*100); pattern identical (6,3). Grain differs (A step vs B batch)."),
    (81.5, "probable",
     "A.equipment.asset_type", "VARCHAR(80)",
     "B.fact_batch_summary.asset_class", "VARCHAR(80)",
     "Name similar (asset_ prefix); glossary both = broad equipment category with identical examples (Bioreactor, Filling Machine, Lyophilizer); sample-data values (Bioreactor, Filling Machine, Lyophilizer, Mixing Tank) match B example set."),
    (69.6, "probable",
     "A.batch_run.planned_qty", "NUMERIC(18,3)",
     "B.fact_yield_analysis.total_planned_qty", "NUMBER(18,3)",
     "Name shares planned_qty stem; glossary B = sum of A planned quantities per date/product/facility; pattern (18,3). Transformation: SUM aggregate."),
    (69.6, "probable",
     "A.batch_run.actual_qty", "NUMERIC(18,3)",
     "B.fact_yield_analysis.total_actual_qty", "NUMBER(18,3)",
     "Name shares actual_qty stem; glossary B = sum of A actual quantities per date/product/facility; pattern (18,3). Transformation: SUM aggregate."),
    (68.8, "probable",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.fact_yield_analysis.avg_yield_pct", "NUMBER(6,3)",
     "Name shares yield_pct stem; glossary B = average of A batch yields; pattern (6,3). Transformation: AVG aggregate."),
    (68.0, "probable",
     "A.batch_run.start_ts", "TIMESTAMP",
     "B.fact_batch_summary.start_timestamp_utc", "TIMESTAMP_TZ",
     "Name shares start + ts/timestamp; glossary both = batch/step start timestamp; pattern timestamp. Transformation: convert US/Eastern local time to UTC."),
    (68.0, "probable",
     "A.batch_run.end_ts", "TIMESTAMP",
     "B.fact_batch_summary.end_timestamp_utc", "TIMESTAMP_TZ",
     "Name shares end + ts/timestamp; glossary both = batch/step end timestamp, null while running; pattern timestamp. Transformation: convert US/Eastern local time to UTC."),
    (67.5, "probable",
     "A.batch_run.product_code", "VARCHAR(50)",
     "B.dim_product.product_id", "VARCHAR(50)",
     "Name shares product_ stem; glossary both = product identifier for what was manufactured (A site-local, B enterprise/MES code); pattern VARCHAR(50). Transformation: crosswalk site-local product_code to enterprise product_id."),
    (67.3, "probable",
     "A.batch_run.batch_id", "VARCHAR(50)",
     "B.fact_batch_summary.enterprise_batch_id", "VARCHAR(50)",
     "Name shares batch_id token; glossary both = batch identifier (A site-local, states it may not match enterprise; B authoritative B-NNNN); pattern format differs. Transformation: map site batch_id to enterprise B-NNNN."),
    (65.3, "probable",
     "A.parameter_reading.batch_id", "VARCHAR(50)",
     "B.fact_batch_summary.enterprise_batch_id", "VARCHAR(50)",
     "Name shares batch_id token; glossary both = batch identifier (A denormalized site-local; B enterprise B-NNNN); format differs. Transformation: map site batch_id to enterprise B-NNNN."),
    (65.3, "probable",
     "A.deviation_event.batch_id", "VARCHAR(50)",
     "B.fact_batch_summary.enterprise_batch_id", "VARCHAR(50)",
     "Name shares batch_id token; glossary both = batch identifier (A site-local deviation context; B enterprise B-NNNN); format differs. Transformation: map site batch_id to enterprise B-NNNN."),
    (63.25, "probable",
     "A.parameter_reading.ingested_at", "TIMESTAMP",
     "B.fact_batch_summary.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = timestamp when record was loaded into the mart; name weakly aligned (load/ingest + _at); pattern timestamp. Transformation: convert to UTC."),
    (63.25, "probable",
     "A.parameter_reading.ingested_at", "TIMESTAMP",
     "B.fact_yield_analysis.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = timestamp when record was loaded/refreshed into the mart; name weakly aligned (load/ingest + _at); pattern timestamp. Transformation: convert to UTC."),
    (62.8, "probable",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.fact_yield_analysis.min_yield_pct", "NUMBER(6,3)",
     "Name shares yield_pct stem; glossary B = minimum of A batch yields on a date; pattern (6,3). Transformation: MIN aggregate."),
    (62.8, "probable",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.fact_yield_analysis.max_yield_pct", "NUMBER(6,3)",
     "Name shares yield_pct stem; glossary B = maximum of A batch yields on a date; pattern (6,3). Transformation: MAX aggregate."),
    (57.6, "possible",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.dim_product.standard_yield_pct", "NUMBER(6,3)",
     "Name shares yield_pct stem; glossary semantic gap - B is the validated target/benchmark yield vs A measured yield; pattern (6,3). Benchmark vs actual, not a direct copy."),
    (56.3, "possible",
     "A.batch_run.yield_pct", "NUMERIC(6,3)",
     "B.fact_yield_analysis.std_yield_pct", "NUMBER(8,4)",
     "Name shares yield_pct stem; glossary B = standard deviation (dispersion) of A yields; pattern decimal (differing scale). Transformation: STDDEV aggregate."),
    (53.5, "possible",
     "A.equipment.updated_at", "TIMESTAMP",
     "B.fact_batch_summary.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = last update/refresh audit timestamp of the record; name weakly aligned (_at suffix); pattern timestamp. Semantic overlap: source update vs mart load."),
    (53.5, "possible",
     "A.batch_run.created_at", "TIMESTAMP",
     "B.fact_batch_summary.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = record creation/load audit timestamp in the mart; name weakly aligned (_at suffix); pattern timestamp. Transformation: convert to UTC."),
    (53.5, "possible",
     "A.deviation_event.created_at", "TIMESTAMP",
     "B.fact_batch_summary.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = record creation/load audit timestamp in the mart; name weakly aligned (_at suffix); pattern timestamp. Transformation: convert to UTC."),
    (53.5, "possible",
     "A.shift_log.created_at", "TIMESTAMP",
     "B.fact_batch_summary.loaded_at_utc", "TIMESTAMP_TZ",
     "Glossary both = record creation/load audit timestamp in the mart; name weakly aligned (_at suffix); pattern timestamp. Transformation: convert to UTC."),
    (53.25, "possible",
     "A.equipment.equip_id", "VARCHAR(30)",
     "B.fact_batch_summary.primary_equipment_code", "VARCHAR(50)",
     "Name shares equip/equipment stem; glossary both identify the equipment used, but B explicitly notes enterprise asset-code format differs from A site-local codes; sample A LEX-RCTR-01 vs B enterprise format mismatch. Transformation: crosswalk site-local to enterprise asset codes."),
    (53.25, "possible",
     "A.batch_run.equip_id", "VARCHAR(30)",
     "B.fact_batch_summary.primary_equipment_code", "VARCHAR(50)",
     "Name shares equip/equipment stem; glossary both identify equipment used for the batch/step, B format differs from A site-local (LEX-) codes; pattern mismatch. Transformation: crosswalk site-local to enterprise asset codes."),
    (53.25, "possible",
     "A.parameter_reading.equip_id", "VARCHAR(30)",
     "B.fact_batch_summary.primary_equipment_code", "VARCHAR(50)",
     "Name shares equip/equipment stem; glossary both identify equipment, B enterprise format differs from A site-local (LEX-) codes; pattern mismatch. Transformation: crosswalk site-local to enterprise asset codes."),
    (53.25, "possible",
     "A.deviation_event.equip_id", "VARCHAR(30)",
     "B.fact_batch_summary.primary_equipment_code", "VARCHAR(50)",
     "Name shares equip/equipment stem; glossary both identify equipment associated with the batch, B format differs from A site-local (LEX-) codes; pattern mismatch. Transformation: crosswalk site-local to enterprise asset codes."),
    (51.25, "possible",
     "A.shift_log.completed_batches", "INTEGER",
     "B.fact_yield_analysis.batch_count", "NUMBER",
     "Name shares batch token; glossary both = count of completed batches (A per shift, B per date/product/facility); pattern integer count. Grain differs. Transformation: COUNT aggregate re-grained."),
    (49.25, "possible",
     "A.shift_log.new_deviations", "INTEGER",
     "B.fact_batch_summary.deviation_count", "NUMBER",
     "Name shares deviation token; glossary both = count of quality deviations (A new per shift, B total per batch); pattern integer count. Grain differs."),
    (47.25, "possible",
     "A.shift_log.active_batches", "INTEGER",
     "B.fact_yield_analysis.batch_count", "NUMBER",
     "Name shares batch token; glossary semantic gap - A counts in-progress batches vs B counts completed batches; pattern integer count."),
    (41.5, "possible",
     "A.batch_run.product_code", "VARCHAR(50)",
     "B.dim_product.sku", "VARCHAR(60)",
     "Glossary cross-reference - A product_code definition explicitly states it 'may differ from enterprise SKU codes in Mart B', directly referencing B.sku; name dissimilar; pattern VARCHAR. Weak link established by the explicit glossary reference."),
]

matches_df = pd.DataFrame(
    matches,
    columns=["score", "band", "app_a_column", "a_type", "app_b_column", "b_type", "reason_signal"],
).sort_values("score", ascending=False, kind="stable").reset_index(drop=True)
show(matches_df)

# COMMAND ----------

# MAGIC %md
# MAGIC # SECTION 3 - Unmatched Columns
# MAGIC Mandatory section. Every column with no cross-application pair scoring >= 40 is listed here
# MAGIC (46 from Application A, 41 from Application B = 87 total). A placeholder row is included so the
# MAGIC section is never empty. Person-identifying columns are flagged with the "PII" prefix in the note.

# COMMAND ----------

# Columns: application, table.column, data_type, reason_unmatched
unmatched = [
    # ---- Placeholder (kept so Section 3 is never empty) ----
    ("PLACEHOLDER", "n/a.n/a", "n/a", "Placeholder row - retained even when no unmatched columns exist."),

    # ================= APPLICATION A (Lexington / mart_a) - 46 unmatched =================
    # equipment (9)
    ("A", "equipment.equip_name", "VARCHAR(150)", "Descriptive equipment name; B has no equipment-name attribute (batch grain only)."),
    ("A", "equipment.manufacturer", "VARCHAR(100)", "Equipment OEM; no equipment dimension exists in B."),
    ("A", "equipment.model_number", "VARCHAR(100)", "Equipment OEM model; no equipment dimension exists in B."),
    ("A", "equipment.install_date", "DATE", "Equipment lifecycle date; no equipment lifecycle tracked in B."),
    ("A", "equipment.calibration_due", "DATE", "Maintenance/calibration attribute; no equivalent in B."),
    ("A", "equipment.last_calibrated", "DATE", "Maintenance/calibration attribute; no equivalent in B."),
    ("A", "equipment.status", "VARCHAR(30)", "Equipment lifecycle status (active|retired); no equipment status in B; batch_status is a different subject (best pair < 40)."),
    ("A", "equipment.line_id", "VARCHAR(30)", "Manufacturing line within site; B has no line concept."),
    ("A", "equipment.building", "VARCHAR(50)", "Physical building/wing within site; B has no building concept."),
    # batch_run (6)
    ("A", "batch_run.run_id", "VARCHAR(50)", "Step-run execution key (RUN-YYYYMMDD-NN); B is batch grain with no step/run identity."),
    ("A", "batch_run.step_name", "VARCHAR(100)", "Process step name (Mixing, Filling); B has no step-level grain."),
    ("A", "batch_run.step_seq", "INTEGER", "Step ordering within batch; B has no step-level grain."),
    ("A", "batch_run.operator_id", "VARCHAR(50)", "PII - operator/technician identifier; no personnel attribute in B."),
    ("A", "batch_run.shift", "VARCHAR(20)", "Shift (Day|Evening|Night); B has no shift concept."),
    ("A", "batch_run.notes", "TEXT", "Free-text operator notes; no equivalent narrative field in B fact tables."),
    # parameter_reading (11)
    ("A", "parameter_reading.reading_id", "VARCHAR(60)", "Sensor-reading key; B has no sensor/parameter grain."),
    ("A", "parameter_reading.run_id", "VARCHAR(50)", "FK to step run; B has no step/run grain."),
    ("A", "parameter_reading.param_code", "VARCHAR(60)", "Parameter code (TEMP, PH); B has no process-parameter data."),
    ("A", "parameter_reading.reading_ts", "TIMESTAMP", "Sensor reading timestamp; B has no sensor grain."),
    ("A", "parameter_reading.param_value", "NUMERIC(18,4)", "Measured parameter value; B has no sensor grain."),
    ("A", "parameter_reading.uom", "VARCHAR(20)", "Unit of measure for parameter value (C, pH, PSI); differs in subject from B qty_unit (best pair < 40)."),
    ("A", "parameter_reading.target_val", "NUMERIC(18,4)", "Recipe target for a parameter; B has no parameter-level target."),
    ("A", "parameter_reading.lower_limit", "NUMERIC(18,4)", "Parameter lower spec limit; no equivalent in B."),
    ("A", "parameter_reading.upper_limit", "NUMERIC(18,4)", "Parameter upper spec limit; no equivalent in B."),
    ("A", "parameter_reading.in_spec", "BOOLEAN", "Parameter in/out of spec flag; no equivalent in B."),
    ("A", "parameter_reading.aggregation", "VARCHAR(30)", "Reading aggregation level (RAW|AVG_1_MIN); no equivalent in B."),
    # deviation_event (11)
    ("A", "deviation_event.deviation_id", "VARCHAR(50)", "Deviation event key (DEV-LEX-NNNN); B stores only a deviation_count, no event grain."),
    ("A", "deviation_event.run_id", "VARCHAR(50)", "FK to step run; B has no step/run grain."),
    ("A", "deviation_event.reading_id", "VARCHAR(60)", "FK to sensor reading; B has no sensor grain."),
    ("A", "deviation_event.detected_ts", "TIMESTAMP", "Deviation detection timestamp; B has no deviation event grain."),
    ("A", "deviation_event.param_code", "VARCHAR(60)", "Out-of-spec parameter code; B has no parameter data."),
    ("A", "deviation_event.deviation_desc", "TEXT", "Free-text deviation description; no event-level narrative in B."),
    ("A", "deviation_event.severity", "VARCHAR(20)", "Deviation severity (low|critical); no severity attribute in B."),
    ("A", "deviation_event.dev_status", "VARCHAR(30)", "Deviation investigation status (open|closed); B disposition/batch_status are different subjects (best pair < 40)."),
    ("A", "deviation_event.assigned_to", "VARCHAR(100)", "PII - name/ID of assigned investigator; no personnel attribute in B."),
    ("A", "deviation_event.resolved_ts", "TIMESTAMP", "Deviation resolution timestamp; B has no deviation event grain."),
    ("A", "deviation_event.resolution_notes", "TEXT", "Free-text resolution notes; no equivalent in B."),
    # shift_log (9)
    ("A", "shift_log.shift_log_id", "BIGINT", "Shift-log key; shift grain has no equivalent in B."),
    ("A", "shift_log.log_date", "DATE", "Shift calendar date; B has no shift grain (analysis_date is a different daily-yield subject)."),
    ("A", "shift_log.shift", "VARCHAR(20)", "Shift name; B has no shift concept."),
    ("A", "shift_log.supervisor_id", "VARCHAR(50)", "PII - shift supervisor identifier; no personnel attribute in B."),
    ("A", "shift_log.supervisor_name", "VARCHAR(150)", "PII - shift supervisor full name; no personnel attribute in B."),
    ("A", "shift_log.equip_downtime_min", "INTEGER", "Unplanned downtime minutes; B OEE availability_pct is a different metric/unit (best pair < 40)."),
    ("A", "shift_log.shift_notes", "TEXT", "Free-text shift narrative; no equivalent in B."),
    ("A", "shift_log.signed_off", "BOOLEAN", "Supervisor sign-off flag; no equivalent in B."),
    ("A", "shift_log.signed_off_ts", "TIMESTAMP", "Supervisor sign-off timestamp; no equivalent in B."),

    # ================= APPLICATION B (Enterprise / mart_b) - 41 unmatched =================
    # dim_facility (12)
    ("B", "dim_facility.facility_key", "NUMBER", "SCD2 surrogate key; A has no facility dimension (single-site)."),
    ("B", "dim_facility.facility_id", "VARCHAR(30)", "Enterprise facility code (FAC-XXX-NN); A has no facility identifier."),
    ("B", "dim_facility.facility_name", "VARCHAR(150)", "Facility official name; A has no facility entity."),
    ("B", "dim_facility.site_code", "VARCHAR(20)", "Multi-site code (LEX, NR, SD); A is single-site with no site_code column."),
    ("B", "dim_facility.city", "VARCHAR(100)", "Facility city; A has no facility/location attributes."),
    ("B", "dim_facility.state_region", "VARCHAR(100)", "Facility state/region; A has no facility/location attributes."),
    ("B", "dim_facility.country_code", "CHAR(2)", "Facility ISO country code; A has no facility/location attributes."),
    ("B", "dim_facility.timezone_name", "VARCHAR(80)", "IANA timezone; A stores no timezone column (US/Eastern implied in notes only)."),
    ("B", "dim_facility.gmp_certified", "BOOLEAN", "Facility GMP certification flag; A has no facility entity."),
    ("B", "dim_facility.effective_start_date", "DATE", "SCD2 version start; A uses overwrite-in-place (no SCD)."),
    ("B", "dim_facility.effective_end_date", "DATE", "SCD2 version end; A uses overwrite-in-place (no SCD)."),
    ("B", "dim_facility.current_flag", "BOOLEAN", "SCD2 current-version flag; A uses overwrite-in-place (no SCD)."),
    # dim_product (8)
    ("B", "dim_product.product_key", "NUMBER", "SCD2 surrogate key; A has no product dimension."),
    ("B", "dim_product.product_name", "VARCHAR(150)", "Official product name; A carries only a product_code, no product name."),
    ("B", "dim_product.formulation_id", "VARCHAR(60)", "Formulation identifier; A has no formulation attribute."),
    ("B", "dim_product.dosage_form", "VARCHAR(80)", "Dosage form; A has no product-attribute dimension."),
    ("B", "dim_product.therapeutic_class", "VARCHAR(100)", "Therapeutic class; A has no product-attribute dimension."),
    ("B", "dim_product.effective_start_date", "DATE", "SCD2 version start; A uses overwrite-in-place (no SCD)."),
    ("B", "dim_product.effective_end_date", "DATE", "SCD2 version end; A uses overwrite-in-place (no SCD)."),
    ("B", "dim_product.current_flag", "BOOLEAN", "SCD2 current-version flag; A uses overwrite-in-place (no SCD)."),
    # dim_quality_disposition (7)
    ("B", "dim_quality_disposition.disposition_key", "NUMBER", "Surrogate key; A has no QA disposition reference table."),
    ("B", "dim_quality_disposition.disposition_code", "VARCHAR(40)", "QA disposition code (RELEASED, REJECTED); A has no QA release disposition (best pair < 40)."),
    ("B", "dim_quality_disposition.disposition_name", "VARCHAR(100)", "QA disposition name; A has no QA disposition entity."),
    ("B", "dim_quality_disposition.requires_investigation", "BOOLEAN", "Disposition policy flag; A has no QA disposition entity."),
    ("B", "dim_quality_disposition.commercially_releasable", "BOOLEAN", "Disposition release-eligibility flag; A has no QA disposition entity."),
    ("B", "dim_quality_disposition.deviation_implied", "BOOLEAN", "Disposition-implies-deviation flag; A has no QA disposition entity."),
    ("B", "dim_quality_disposition.description", "VARCHAR(500)", "Disposition business description; A has no QA disposition entity."),
    # fact_batch_summary (9)
    ("B", "fact_batch_summary.batch_summary_key", "NUMBER", "Surrogate key; A uses natural keys, no batch-summary surrogate."),
    ("B", "fact_batch_summary.facility_key", "NUMBER", "FK to facility dimension; A has no facility dimension."),
    ("B", "fact_batch_summary.product_key", "NUMBER", "FK to product dimension; A has no product dimension."),
    ("B", "fact_batch_summary.disposition_key", "NUMBER", "FK to QA disposition; A has no QA disposition entity."),
    ("B", "fact_batch_summary.availability_pct", "NUMBER(6,3)", "OEE availability component; A does not compute OEE (no equivalent)."),
    ("B", "fact_batch_summary.performance_pct", "NUMBER(6,3)", "OEE performance component; A does not compute OEE (no equivalent)."),
    ("B", "fact_batch_summary.quality_pct", "NUMBER(6,3)", "OEE quality component; A does not compute OEE (no equivalent)."),
    ("B", "fact_batch_summary.oee_pct", "NUMBER(6,3)", "Overall Equipment Effectiveness; A does not compute OEE (no equivalent)."),
    ("B", "fact_batch_summary.source_site_code", "VARCHAR(20)", "Originating site code for multi-site filtering; A is single-site with no site_code column."),
    # fact_yield_analysis (5)
    ("B", "fact_yield_analysis.yield_analysis_key", "NUMBER", "Surrogate key; A has no daily yield-aggregate table."),
    ("B", "fact_yield_analysis.analysis_date", "DATE", "Daily yield-analysis date; A has no daily aggregate grain (shift_log.log_date is a different subject)."),
    ("B", "fact_yield_analysis.facility_key", "NUMBER", "FK to facility dimension; A has no facility dimension."),
    ("B", "fact_yield_analysis.product_key", "NUMBER", "FK to product dimension; A has no product dimension."),
    ("B", "fact_yield_analysis.below_target_count", "NUMBER", "Count of batches below yield target; A has no target-benchmark comparison metric."),
]

unmatched_df = pd.DataFrame(
    unmatched,
    columns=["application", "table_column", "data_type", "reason_unmatched"],
)
show(unmatched_df)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Reconciliation check
# MAGIC Confirms no column was dropped: matched-distinct + unmatched must equal total per application.

# COMMAND ----------

# A: 24 matched-distinct + 46 unmatched = 70 ; B: 24 matched-distinct + 41 unmatched = 65
matched_a_distinct = sorted({m[2] for m in matches})
matched_b_distinct = sorted({m[4] for m in matches})
unmatched_a = [u for u in unmatched if u[0] == "A"]
unmatched_b = [u for u in unmatched if u[0] == "B"]

check_rows = [
    ("Application A", len(matched_a_distinct), len(unmatched_a),
     len(matched_a_distinct) + len(unmatched_a), 70),
    ("Application B", len(matched_b_distinct), len(unmatched_b),
     len(matched_b_distinct) + len(unmatched_b), 65),
]
check_df = pd.DataFrame(
    check_rows,
    columns=["application", "matched_distinct", "unmatched", "accounted_for", "expected_total"],
)
check_df["reconciled"] = check_df["accounted_for"] == check_df["expected_total"]
show(check_df)
