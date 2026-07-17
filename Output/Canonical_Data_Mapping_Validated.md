# Canonical Data Mapping — Validated & Consolidated

## Section 1 — Mapping Summary

| Metric | Count |
|---|---|
| Total Canonical Entities identified | 7 |
| Total Canonical Attributes mapped | 15 |
| Confirmed mappings | 12 |
| Inferred mappings | 3 |
| Ambiguous mappings | 0 |
| Unmapped columns | 54 |
| PII-flagged attributes | 0 |

---

## Section 2 — Canonical Mapping Table

| Entity Name | Attribute Name | App Name 1 | Table Name 1 | Column Name 1 | App Name 2 | Table Name 2 | Column Name 2 | Transformation Rule | Status |
|---|---|---|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalyticsDataMart | dim_facility | facility_id | LexingtonSite | equipment | equip_id | Cast VARCHAR(30) to VARCHAR(30); direct 1:1 map | Confirmed |
| Facility | Facility Name | EnterpriseAnalyticsDataMart | dim_facility | facility_name | LexingtonSite | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct 1:1 map | Confirmed |
| Facility | City | EnterpriseAnalyticsDataMart | dim_facility | city | LexingtonSite | equipment | building | Map city/building via site location reference table | Inferred |
| Facility | Timezone Name | EnterpriseAnalyticsDataMart | dim_facility | timezone_name | LexingtonSite | batch_run | start_ts | Convert US/Eastern to IANA timezone using mapping table | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalyticsDataMart | fact_batch_summary | enterprise_batch_id | LexingtonSite | batch_run | batch_id | Cast VARCHAR(50) to VARCHAR(50); direct 1:1 map | Confirmed |
| Batch | Facility Key | EnterpriseAnalyticsDataMart | fact_batch_summary | facility_key | LexingtonSite | batch_run | equip_id | Map facility_key to equip_id via equipment-facility crosswalk | Inferred |
| Batch | Product Key | EnterpriseAnalyticsDataMart | fact_batch_summary | product_key | LexingtonSite | batch_run | product_code | Map product_key to product_code via product master reference | Confirmed |
| Batch | Batch Status | EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | LexingtonSite | batch_run | batch_status | Map status codes via lookup (ACTIVE/completed/etc) | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | LexingtonSite | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | LexingtonSite | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct 1:1 map | Confirmed |
| Batch | Yield Percentage | EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct 1:1 map | Confirmed |
| Batch | Start Timestamp UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | start_timestamp_utc | LexingtonSite | batch_run | start_ts | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | End Timestamp UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc | LexingtonSite | batch_run | end_ts | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | Loaded At UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | LexingtonSite | batch_run | created_at | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |

---

## Section 3 — Canonical Extension Recommendations

| App Name | Table Name | Column Name | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped |
|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | state_region | Facility | State Region | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_facility | country_code | Facility | Country Code | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_facility | gmp_certified | Facility | GMP Certified | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_facility | effective_start_date | Facility | Effective Start Date | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_facility | effective_end_date | Facility | Effective End Date | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_facility | current_flag | Facility | Current Flag | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | product_id | Product | Product ID | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | sku | Product | SKU | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | product_name | Product | Product Name | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | formulation_id | Product | Formulation ID | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | dosage_form | Product | Dosage Form | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | therapeutic_class | Product | Therapeutic Class | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct | Product | Standard Yield Percentage | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | effective_start_date | Product | Effective Start Date | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | effective_end_date | Product | Effective End Date | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_product | current_flag | Product | Current Flag | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_code | Quality Disposition | Disposition Code | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_name | Quality Disposition | Disposition Name | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | requires_investigation | Quality Disposition | Requires Investigation | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | commercially_releasable | Quality Disposition | Commercially Releasable | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | deviation_implied | Quality Disposition | Deviation Implied | No equivalent found in other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | description | Quality Disposition | Description | No equivalent found in other application |
| LexingtonSite | equipment | asset_type | Equipment | Asset Type | No equivalent found in other application |
| LexingtonSite | equipment | manufacturer | Equipment | Manufacturer | No equivalent found in other application |
| LexingtonSite | equipment | model_number | Equipment | Model Number | No equivalent found in other application |
| LexingtonSite | equipment | install_date | Equipment | Install Date | No equivalent found in other application |
| LexingtonSite | equipment | calibration_due | Equipment | Calibration Due | No equivalent found in other application |
| LexingtonSite | equipment | last_calibrated | Equipment | Last Calibrated | No equivalent found in other application |
| LexingtonSite | equipment | status | Equipment | Status | No equivalent found in other application |
| LexingtonSite | equipment | line_id | Equipment | Line ID | No equivalent found in other application |
| LexingtonSite | equipment | updated_at | Equipment | Updated At | No equivalent found in other application |
| LexingtonSite | batch_run | run_id | Batch | Run ID | No equivalent found in other application |
| LexingtonSite | batch_run | step_name | Batch | Step Name | No equivalent found in other application |
| LexingtonSite | batch_run | step_seq | Batch | Step Sequence | No equivalent found in other application |
| LexingtonSite | batch_run | operator_id | Batch | Operator ID | No equivalent found in other application |
| LexingtonSite | batch_run | shift | Batch | Shift | No equivalent found in other application |
| LexingtonSite | batch_run | notes | Batch | Notes | No equivalent found in other application |
| LexingtonSite | parameter_reading | reading_id | Parameter Reading | Reading ID | No equivalent found in other application |
| LexingtonSite | parameter_reading | equip_id | Parameter Reading | Equipment ID | No equivalent found in other application |
| LexingtonSite | parameter_reading | run_id | Parameter Reading | Run ID | No equivalent found in other application |
| LexingtonSite | parameter_reading | batch_id | Parameter Reading | Batch ID | No equivalent found in other application |
| LexingtonSite | parameter_reading | param_code | Parameter Reading | Parameter Code | No equivalent found in other application |
| LexingtonSite | parameter_reading | reading_ts | Parameter Reading | Reading Timestamp | No equivalent found in other application |
| LexingtonSite | parameter_reading | param_value | Parameter Reading | Parameter Value | No equivalent found in other application |
| LexingtonSite | parameter_reading | uom | Parameter Reading | Unit of Measure | No equivalent found in other application |
| LexingtonSite | parameter_reading | target_val | Parameter Reading | Target Value | No equivalent found in other application |
| LexingtonSite | parameter_reading | lower_limit | Parameter Reading | Lower Limit | No equivalent found in other application |
| LexingtonSite | parameter_reading | upper_limit | Parameter Reading | Upper Limit | No equivalent found in other application |
| LexingtonSite | parameter_reading | in_spec | Parameter Reading | In Spec | No equivalent found in other application |
| LexingtonSite | parameter_reading | aggregation | Parameter Reading | Aggregation | No equivalent found in other application |
| LexingtonSite | parameter_reading | ingested_at | Parameter Reading | Ingested At | No equivalent found in other application |
| LexingtonSite | deviation_event | deviation_id | Deviation Event | Deviation ID | No equivalent found in other application |
| LexingtonSite | deviation_event | batch_id | Deviation Event | Batch ID | No equivalent found in other application |
| LexingtonSite | deviation_event | run_id | Deviation Event | Run ID | No equivalent found in other application |
| LexingtonSite | deviation_event | equip_id | Deviation Event | Equipment ID | No equivalent found in other application |
| LexingtonSite | deviation_event | reading_id | Deviation Event | Reading ID | No equivalent found in other application |
| LexingtonSite | deviation_event | detected_ts | Deviation Event | Detected Timestamp | No equivalent found in other application |
| LexingtonSite | deviation_event | param_code | Deviation Event | Parameter Code | No equivalent found in other application |
| LexingtonSite | deviation_event | deviation_desc | Deviation Event | Deviation Description | No equivalent found in other application |
| LexingtonSite | deviation_event | severity | Deviation Event | Severity | No equivalent found in other application |
| LexingtonSite | deviation_event | dev_status | Deviation Event | Deviation Status | No equivalent found in other application |
| LexingtonSite | deviation_event | assigned_to | Deviation Event | Assigned To | No equivalent found in other application |
| LexingtonSite | deviation_event | resolved_ts | Deviation Event | Resolved Timestamp | No equivalent found in other application |
| LexingtonSite | deviation_event | resolution_notes | Deviation Event | Resolution Notes | No equivalent found in other application |
| LexingtonSite | deviation_event | created_at | Deviation Event | Created At | No equivalent found in other application |
| LexingtonSite | shift_log | shift_log_id | Shift Log | Shift Log ID | No equivalent found in other application |
| LexingtonSite | shift_log | log_date | Shift Log | Log Date | No equivalent found in other application |
| LexingtonSite | shift_log | shift | Shift Log | Shift | No equivalent found in other application |
| LexingtonSite | shift_log | supervisor_id | Shift Log | Supervisor ID | No equivalent found in other application |
| LexingtonSite | shift_log | supervisor_name | Shift Log | Supervisor Name | No equivalent found in other application |
| LexingtonSite | shift_log | active_batches | Shift Log | Active Batches | No equivalent found in other application |
| LexingtonSite | shift_log | completed_batches | Shift Log | Completed Batches | No equivalent found in other application |
| LexingtonSite | shift_log | new_deviations | Shift Log | New Deviations | No equivalent found in other application |
| LexingtonSite | shift_log | equip_downtime_min | Shift Log | Equipment Downtime Minutes | No equivalent found in other application |
| LexingtonSite | shift_log | shift_notes | Shift Log | Shift Notes | No equivalent found in other application |
| LexingtonSite | shift_log | signed_off | Shift Log | Signed Off | No equivalent found in other application |
| LexingtonSite | shift_log | signed_off_ts | Shift Log | Signed Off Timestamp | No equivalent found in other application |
| LexingtonSite | shift_log | created_at | Shift Log | Created At | No equivalent found in other application |

---

## Section 4 — Mapping Table (Per Source Column)

| Entity Name | Attribute Name | Application Name | Table Name | Column Name | Transformation Rule | Status |
|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalyticsDataMart | dim_facility | facility_id | Cast VARCHAR(30) to VARCHAR(30); direct 1:1 map | Confirmed |
| Facility | Facility ID | LexingtonSite | equipment | equip_id | Cast VARCHAR(30) to VARCHAR(30); direct 1:1 map | Confirmed |
| Facility | Facility Name | EnterpriseAnalyticsDataMart | dim_facility | facility_name | Cast VARCHAR(150) to VARCHAR(150); direct 1:1 map | Confirmed |
| Facility | Facility Name | LexingtonSite | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct 1:1 map | Confirmed |
| Facility | City | EnterpriseAnalyticsDataMart | dim_facility | city | Map city/building via site location reference table | Inferred |
| Facility | City | LexingtonSite | equipment | building | Map city/building via site location reference table | Inferred |
| Facility | Timezone Name | EnterpriseAnalyticsDataMart | dim_facility | timezone_name | Convert US/Eastern to IANA timezone using mapping table | Inferred |
| Facility | Timezone Name | LexingtonSite | batch_run | start_ts | Convert US/Eastern to IANA timezone using mapping table | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalyticsDataMart | fact_batch_summary | enterprise_batch_id | Cast VARCHAR(50) to VARCHAR(50); direct 1:1 map | Confirmed |
| Batch | Enterprise Batch ID | LexingtonSite | batch_run | batch_id | Cast VARCHAR(50) to VARCHAR(50); direct 1:1 map | Confirmed |
| Batch | Facility Key | EnterpriseAnalyticsDataMart | fact_batch_summary | facility_key | Map facility_key to equip_id via equipment-facility crosswalk | Inferred |
| Batch | Facility Key | LexingtonSite | batch_run | equip_id | Map facility_key to equip_id via equipment-facility crosswalk | Inferred |
| Batch | Product Key | EnterpriseAnalyticsDataMart | fact_batch_summary | product_key | Map product_key to product_code via product master reference | Confirmed |
| Batch | Product Key | LexingtonSite | batch_run | product_code | Map product_key to product_code via product master reference | Confirmed |
| Batch | Batch Status | EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | Map status codes via lookup (ACTIVE/completed/etc) | Confirmed |
| Batch | Batch Status | LexingtonSite | batch_run | batch_status | Map status codes via lookup (ACTIVE/completed/etc) | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Planned Quantity | LexingtonSite | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Actual Quantity | LexingtonSite | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct 1:1 map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct 1:1 map | Confirmed |
| Batch | Quantity Unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct 1:1 map | Confirmed |
| Batch | Yield Percentage | EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct 1:1 map | Confirmed |
| Batch | Yield Percentage | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct 1:1 map | Confirmed |
| Batch | Start Timestamp UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | start_timestamp_utc | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | Start Timestamp UTC | LexingtonSite | batch_run | start_ts | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | End Timestamp UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | End Timestamp UTC | LexingtonSite | batch_run | end_ts | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | Loaded At UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Batch | Loaded At UTC | LexingtonSite | batch_run | created_at | Convert US/Eastern to UTC; cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Facility | State Region | EnterpriseAnalyticsDataMart | dim_facility | state_region |  | Unmapped |
| Facility | Country Code | EnterpriseAnalyticsDataMart | dim_facility | country_code |  | Unmapped |
| Facility | GMP Certified | EnterpriseAnalyticsDataMart | dim_facility | gmp_certified |  | Unmapped |
| Facility | Effective Start Date | EnterpriseAnalyticsDataMart | dim_facility | effective_start_date |  | Unmapped |
| Facility | Effective End Date | EnterpriseAnalyticsDataMart | dim_facility | effective_end_date |  | Unmapped |
| Facility | Current Flag | EnterpriseAnalyticsDataMart | dim_facility | current_flag |  | Unmapped |
| Product | Product ID | EnterpriseAnalyticsDataMart | dim_product | product_id |  | Unmapped |
| Product | SKU | EnterpriseAnalyticsDataMart | dim_product | sku |  | Unmapped |
| Product | Product Name | EnterpriseAnalyticsDataMart | dim_product | product_name |  | Unmapped |
| Product | Formulation ID | EnterpriseAnalyticsDataMart | dim_product | formulation_id |  | Unmapped |
| Product | Dosage Form | EnterpriseAnalyticsDataMart | dim_product | dosage_form |  | Unmapped |
| Product | Therapeutic Class | EnterpriseAnalyticsDataMart | dim_product | therapeutic_class |  | Unmapped |
| Product | Standard Yield Percentage | EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct |  | Unmapped |
| Product | Effective Start Date | EnterpriseAnalyticsDataMart | dim_product | effective_start_date |  | Unmapped |
| Product | Effective End Date | EnterpriseAnalyticsDataMart | dim_product | effective_end_date |  | Unmapped |
| Product | Current Flag | EnterpriseAnalyticsDataMart | dim_product | current_flag |  | Unmapped |
| Quality Disposition | Disposition Code | EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_code |  | Unmapped |
| Quality Disposition | Disposition Name | EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_name |  | Unmapped |
| Quality Disposition | Requires Investigation | EnterpriseAnalyticsDataMart | dim_quality_disposition | requires_investigation |  | Unmapped |
| Quality Disposition | Commercially Releasable | EnterpriseAnalyticsDataMart | dim_quality_disposition | commercially_releasable |  | Unmapped |
| Quality Disposition | Deviation Implied | EnterpriseAnalyticsDataMart | dim_quality_disposition | deviation_implied |  | Unmapped |
| Quality Disposition | Description | EnterpriseAnalyticsDataMart | dim_quality_disposition | description |  | Unmapped |
| Equipment | Asset Type | LexingtonSite | equipment | asset_type |  | Unmapped |
| Equipment | Manufacturer | LexingtonSite | equipment | manufacturer |  | Unmapped |
| Equipment | Model Number | LexingtonSite | equipment | model_number |  | Unmapped |
| Equipment | Install Date | LexingtonSite | equipment | install_date |  | Unmapped |
| Equipment | Calibration Due | LexingtonSite | equipment | calibration_due |  | Unmapped |
| Equipment | Last Calibrated | LexingtonSite | equipment | last_calibrated |  | Unmapped |
| Equipment | Status | LexingtonSite | equipment | status |  | Unmapped |
| Equipment | Line ID | LexingtonSite | equipment | line_id |  | Unmapped |
| Equipment | Updated At | LexingtonSite | equipment | updated_at |  | Unmapped |
| Batch | Run ID | LexingtonSite | batch_run | run_id |  | Unmapped |
| Batch | Step Name | LexingtonSite | batch_run | step_name |  | Unmapped |
| Batch | Step Sequence | LexingtonSite | batch_run | step_seq |  | Unmapped |
| Batch | Operator ID | LexingtonSite | batch_run | operator_id |  | Unmapped |
| Batch | Shift | LexingtonSite | batch_run | shift |  | Unmapped |
| Batch | Notes | LexingtonSite | batch_run | notes |  | Unmapped |
| Parameter Reading | Reading ID | LexingtonSite | parameter_reading | reading_id |  | Unmapped |
| Parameter Reading | Equipment ID | LexingtonSite | parameter_reading | equip_id |  | Unmapped |
| Parameter Reading | Run ID | LexingtonSite | parameter_reading | run_id |  | Unmapped |
| Parameter Reading | Batch ID | LexingtonSite | parameter_reading | batch_id |  | Unmapped |
| Parameter Reading | Parameter Code | LexingtonSite | parameter_reading | param_code |  | Unmapped |
| Parameter Reading | Reading Timestamp | LexingtonSite | parameter_reading | reading_ts |  | Unmapped |
| Parameter Reading | Parameter Value | LexingtonSite | parameter_reading | param_value |  | Unmapped |
| Parameter Reading | Unit of Measure | LexingtonSite | parameter_reading | uom |  | Unmapped |
| Parameter Reading | Target Value | LexingtonSite | parameter_reading | target_val |  | Unmapped |
| Parameter Reading | Lower Limit | LexingtonSite | parameter_reading | lower_limit |  | Unmapped |
| Parameter Reading | Upper Limit | LexingtonSite | parameter_reading | upper_limit |  | Unmapped |
| Parameter Reading | In Spec | LexingtonSite | parameter_reading | in_spec |  | Unmapped |
| Parameter Reading | Aggregation | LexingtonSite | parameter_reading | aggregation |  | Unmapped |
| Parameter Reading | Ingested At | LexingtonSite | parameter_reading | ingested_at |  | Unmapped |
| Deviation Event | Deviation ID | LexingtonSite | deviation_event | deviation_id |  | Unmapped |
| Deviation Event | Batch ID | LexingtonSite | deviation_event | batch_id |  | Unmapped |
| Deviation Event | Run ID | LexingtonSite | deviation_event | run_id |  | Unmapped |
| Deviation Event | Equipment ID | LexingtonSite | deviation_event | equip_id |  | Unmapped |
| Deviation Event | Reading ID | LexingtonSite | deviation_event | reading_id |  | Unmapped |
| Deviation Event | Detected Timestamp | LexingtonSite | deviation_event | detected_ts |  | Unmapped |
| Deviation Event | Parameter Code | LexingtonSite | deviation_event | param_code |  | Unmapped |
| Deviation Event | Deviation Description | LexingtonSite | deviation_event | deviation_desc |  | Unmapped |
| Deviation Event | Severity | LexingtonSite | deviation_event | severity |  | Unmapped |
| Deviation Event | Deviation Status | LexingtonSite | deviation_event | dev_status |  | Unmapped |
| Deviation Event | Assigned To | LexingtonSite | deviation_event | assigned_to |  | Unmapped |
| Deviation Event | Resolved Timestamp | LexingtonSite | deviation_event | resolved_ts |  | Unmapped |
| Deviation Event | Resolution Notes | LexingtonSite | deviation_event | resolution_notes |  | Unmapped |
| Deviation Event | Created At | LexingtonSite | deviation_event | created_at |  | Unmapped |
| Shift Log | Shift Log ID | LexingtonSite | shift_log | shift_log_id |  | Unmapped |
| Shift Log | Log Date | LexingtonSite | shift_log | log_date |  | Unmapped |
| Shift Log | Shift | LexingtonSite | shift_log | shift |  | Unmapped |
| Shift Log | Supervisor ID | LexingtonSite | shift_log | supervisor_id |  | Unmapped |
| Shift Log | Supervisor Name | LexingtonSite | shift_log | supervisor_name |  | Unmapped |
| Shift Log | Active Batches | LexingtonSite | shift_log | active_batches |  | Unmapped |
| Shift Log | Completed Batches | LexingtonSite | shift_log | completed_batches |  | Unmapped |
| Shift Log | New Deviations | LexingtonSite | shift_log | new_deviations |  | Unmapped |
| Shift Log | Equipment Downtime Minutes | LexingtonSite | shift_log | equip_downtime_min |  | Unmapped |
| Shift Log | Shift Notes | LexingtonSite | shift_log | shift_notes |  | Unmapped |
| Shift Log | Signed Off | LexingtonSite | shift_log | signed_off |  | Unmapped |
| Shift Log | Signed Off Timestamp | LexingtonSite | shift_log | signed_off_ts |  | Unmapped |
| Shift Log | Created At | LexingtonSite | shift_log | created_at |  | Unmapped |
