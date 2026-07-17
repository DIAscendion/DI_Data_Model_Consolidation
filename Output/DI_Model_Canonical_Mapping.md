# Canonical Data Model Mapping and Audit Log

## Section 1 — Mapping Summary

| Metric | Count |
|---|---|
| Total Canonical Entities identified | 7 |
| Total Canonical Attributes mapped | 17 |
| Confirmed mappings | 12 |
| Inferred mappings | 4 |
| Ambiguous mappings | 1 |
| Unmapped columns | 54 |
| PII-flagged attributes | 0 |

---

## Section 2 — Canonical Mapping Table

| Entity Name | Attribute Name | App Name 1 | Table Name 1 | Column Name 1 | App Name 2 | Table Name 2 | Column Name 2 | Transformation Rule | Status |
|---|---|---|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalytics | dim_facility | facility_id | LexingtonSite | equipment | equip_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Facility | Facility Name | EnterpriseAnalytics | dim_facility | facility_name | LexingtonSite | equipment | equip_name | Map VARCHAR(150) to VARCHAR(150); trim trailing spaces | Confirmed |
| Facility | City | EnterpriseAnalytics | dim_facility | city | LexingtonSite | equipment | building | Map city to building name; VARCHAR(100) to VARCHAR(50) | Inferred |
| Facility | State/Region | EnterpriseAnalytics | dim_facility | state_region | LexingtonSite | equipment | building | Map state_region to building; truncate to VARCHAR(50) | Inferred |
| Facility | Country Code | EnterpriseAnalytics | dim_facility | country_code | LexingtonSite | equipment | building | Map country_code to building; manual mapping required | Ambiguous |
| Facility | Timezone Name | EnterpriseAnalytics | dim_facility | timezone_name | LexingtonSite | batch_run | start_ts | Convert start_ts from US/Eastern to UTC using timezone_name | Confirmed |
| Facility | GMP Certified | EnterpriseAnalytics | dim_facility | gmp_certified | LexingtonSite | equipment | status | Map TRUE to 'active', FALSE to 'inactive'; cast BOOLEAN to VARCHAR(30) | Inferred |
| Product | Product ID | EnterpriseAnalytics | dim_product | product_id | LexingtonSite | batch_run | product_code | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Product | SKU | EnterpriseAnalytics | dim_product | sku | LexingtonSite | batch_run | product_code | Map via reference table; VARCHAR(60) to VARCHAR(50) | Confirmed |
| Product | Dosage Form | EnterpriseAnalytics | dim_product | dosage_form | LexingtonSite | batch_run | step_name | Map dosage_form to step_name; manual mapping | Inferred |
| Quality Disposition | Disposition Code | EnterpriseAnalytics | dim_quality_disposition | disposition_code | LexingtonSite | batch_run | batch_status | Map codes: RELEASED/ACTIVE/ON_HOLD/REJECTED; VARCHAR(40) to VARCHAR(30) | Confirmed |
| Quality Disposition | Disposition Name | EnterpriseAnalytics | dim_quality_disposition | disposition_name | LexingtonSite | batch_run | batch_status | Map descriptive status to code; manual mapping | Confirmed |
| Quality Disposition | Requires Investigation | EnterpriseAnalytics | dim_quality_disposition | requires_investigation | LexingtonSite | deviation_event | dev_status | Map TRUE to 'investigating', FALSE to 'open' or 'resolved'; BOOLEAN to VARCHAR(30) | Confirmed |
| Quality Disposition | Description | EnterpriseAnalytics | dim_quality_disposition | description | LexingtonSite | deviation_event | deviation_desc | Map VARCHAR(500) to TEXT | Confirmed |
| Batch | Enterprise Batch ID | EnterpriseAnalytics | fact_batch_summary | enterprise_batch_id | LexingtonSite | batch_run | batch_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Batch | Batch Status | EnterpriseAnalytics | fact_batch_summary | batch_status | LexingtonSite | batch_run | batch_status | Map status codes; direct 1:1 mapping; VARCHAR(30) | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalytics | fact_batch_summary | planned_qty | LexingtonSite | batch_run | planned_qty | Direct 1:1 map; enforce NOT NULL | Confirmed |

---

## Section 3 — Canonical Extension Recommendations

| App Name | Table Name | Column Name | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped |
|---|---|---|---|---|---|
| EnterpriseAnalytics | dim_facility | site_code | Facility | Site Code | No equivalent found in other application |
| EnterpriseAnalytics | dim_facility | effective_start_date | Facility | Effective Start Date | No equivalent found in other application |
| EnterpriseAnalytics | dim_facility | effective_end_date | Facility | Effective End Date | No equivalent found in other application |
| EnterpriseAnalytics | dim_facility | current_flag | Facility | Current Flag | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | product_key | Product | Product Key | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | formulation_id | Product | Formulation ID | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | standard_yield_pct | Product | Standard Yield Percent | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | effective_start_date | Product | Effective Start Date | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | effective_end_date | Product | Effective End Date | No equivalent found in other application |
| EnterpriseAnalytics | dim_product | current_flag | Product | Current Flag | No equivalent found in other application |
| EnterpriseAnalytics | dim_quality_disposition | disposition_key | Quality Disposition | Disposition Key | No equivalent found in other application |
| EnterpriseAnalytics | dim_quality_disposition | commercially_releasable | Quality Disposition | Commercially Releasable | No equivalent found in other application |
| EnterpriseAnalytics | dim_quality_disposition | deviation_implied | Quality Disposition | Deviation Implied | No equivalent found in other application |
| EnterpriseAnalytics | dim_quality_disposition | description | Quality Disposition | Description | Best score: 37 — too weak to include |
| EnterpriseAnalytics | fact_batch_summary | batch_summary_key | Batch | Batch Summary Key | No equivalent found in other application |
| EnterpriseAnalytics | fact_batch_summary | end_timestamp_utc | Batch | End Timestamp UTC | No equivalent found in other application |
| EnterpriseAnalytics | fact_batch_summary | performance_pct | Batch | Performance Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_batch_summary | quality_pct | Batch | Quality Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_batch_summary | oee_pct | Batch | OEE Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_batch_summary | loaded_at_utc | Batch | Loaded At UTC | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | yield_analysis_key | Yield Analytics | Yield Analysis Key | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | analysis_date | Yield Analytics | Analysis Date | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | batch_count | Yield Analytics | Batch Count | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | avg_yield_pct | Yield Analytics | Average Yield Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | min_yield_pct | Yield Analytics | Minimum Yield Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | max_yield_pct | Yield Analytics | Maximum Yield Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | std_yield_pct | Yield Analytics | Std Yield Percent | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | below_target_count | Yield Analytics | Below Target Count | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | total_planned_qty | Yield Analytics | Total Planned Qty | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | total_actual_qty | Yield Analytics | Total Actual Qty | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | qty_unit | Yield Analytics | Quantity Unit | No equivalent found in other application |
| EnterpriseAnalytics | fact_yield_analysis | loaded_at_utc | Yield Analytics | Loaded At UTC | No equivalent found in other application |
| LexingtonSite | equipment | asset_type | Equipment | Asset Type | No equivalent found in other application |
| LexingtonSite | equipment | manufacturer | Equipment | Manufacturer | No equivalent found in other application |
| LexingtonSite | equipment | model_number | Equipment | Model Number | No equivalent found in other application |
| LexingtonSite | equipment | install_date | Equipment | Install Date | No equivalent found in other application |
| LexingtonSite | equipment | calibration_due | Equipment | Calibration Due | No equivalent found in other application |
| LexingtonSite | equipment | last_calibrated | Equipment | Last Calibrated | No equivalent found in other application |
| LexingtonSite | equipment | line_id | Equipment | Line ID | No equivalent found in other application |
| LexingtonSite | equipment | updated_at | Equipment | Updated At | No equivalent found in other application |
| LexingtonSite | batch_run | run_id | Batch Run | Run ID | No equivalent found in other application |
| LexingtonSite | batch_run | step_seq | Batch Run | Step Sequence | No equivalent found in other application |
| LexingtonSite | batch_run | operator_id | Batch Run | Operator ID | No equivalent found in other application |
| LexingtonSite | batch_run | shift | Batch Run | Shift | No equivalent found in other application |
| LexingtonSite | batch_run | notes | Batch Run | Notes | No equivalent found in other application |
| LexingtonSite | batch_run | created_at | Batch Run | Created At | No equivalent found in other application |
| LexingtonSite | parameter_reading | reading_id | Parameter Reading | Reading ID | No equivalent found in other application |
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
| LexingtonSite | deviation_event | deviation_id | Deviation Event | Deviation ID | Best score: 51 — too weak to include |
| LexingtonSite | deviation_event | batch_id | Deviation Event | Batch ID | No equivalent found in other application |
| LexingtonSite | deviation_event | run_id | Deviation Event | Run ID | No equivalent found in other application |
| LexingtonSite | deviation_event | equip_id | Deviation Event | Equipment ID | No equivalent found in other application |
| LexingtonSite | deviation_event | reading_id | Deviation Event | Reading ID | No equivalent found in other application |
| LexingtonSite | deviation_event | detected_ts | Deviation Event | Detected Timestamp | No equivalent found in other application |
| LexingtonSite | deviation_event | param_code | Deviation Event | Parameter Code | No equivalent found in other application |
| LexingtonSite | deviation_event | severity | Deviation Event | Severity | No equivalent found in other application |
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

## Section 4 — Mapping Table (Per-Column Audit View)

| Entity Name | Attribute Name | Application Name | Table Name | Column Name | Transformation Rule | Status |
|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalytics | dim_facility | facility_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Facility | Facility ID | LexingtonSite | equipment | equip_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Facility | Facility Name | EnterpriseAnalytics | dim_facility | facility_name | Map VARCHAR(150) to VARCHAR(150); trim trailing spaces | Confirmed |
| Facility | Facility Name | LexingtonSite | equipment | equip_name | Map VARCHAR(150) to VARCHAR(150); trim trailing spaces | Confirmed |
| Facility | City | EnterpriseAnalytics | dim_facility | city | Map city to building name; VARCHAR(100) to VARCHAR(50) | Inferred |
| Facility | City | LexingtonSite | equipment | building | Map city to building name; VARCHAR(100) to VARCHAR(50) | Inferred |
| Facility | State/Region | EnterpriseAnalytics | dim_facility | state_region | Map state_region to building; truncate to VARCHAR(50) | Inferred |
| Facility | State/Region | LexingtonSite | equipment | building | Map state_region to building; truncate to VARCHAR(50) | Inferred |
| Facility | Country Code | EnterpriseAnalytics | dim_facility | country_code | Map country_code to building; manual mapping required | Ambiguous |
| Facility | Country Code | LexingtonSite | equipment | building | Map country_code to building; manual mapping required | Ambiguous |
| Facility | Timezone Name | EnterpriseAnalytics | dim_facility | timezone_name | Convert start_ts from US/Eastern to UTC using timezone_name | Confirmed |
| Facility | Timezone Name | LexingtonSite | batch_run | start_ts | Convert start_ts from US/Eastern to UTC using timezone_name | Confirmed |
| Facility | GMP Certified | EnterpriseAnalytics | dim_facility | gmp_certified | Map TRUE to 'active', FALSE to 'inactive'; cast BOOLEAN to VARCHAR(30) | Inferred |
| Facility | GMP Certified | LexingtonSite | equipment | status | Map TRUE to 'active', FALSE to 'inactive'; cast BOOLEAN to VARCHAR(30) | Inferred |
| Product | Product ID | EnterpriseAnalytics | dim_product | product_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Product | Product ID | LexingtonSite | batch_run | product_code | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Product | SKU | EnterpriseAnalytics | dim_product | sku | Map via reference table; VARCHAR(60) to VARCHAR(50) | Confirmed |
| Product | SKU | LexingtonSite | batch_run | product_code | Map via reference table; VARCHAR(60) to VARCHAR(50) | Confirmed |
| Product | Dosage Form | EnterpriseAnalytics | dim_product | dosage_form | Map dosage_form to step_name; manual mapping | Inferred |
| Product | Dosage Form | LexingtonSite | batch_run | step_name | Map dosage_form to step_name; manual mapping | Inferred |
| Quality Disposition | Disposition Code | EnterpriseAnalytics | dim_quality_disposition | disposition_code | Map codes: RELEASED/ACTIVE/ON_HOLD/REJECTED; VARCHAR(40) to VARCHAR(30) | Confirmed |
| Quality Disposition | Disposition Code | LexingtonSite | batch_run | batch_status | Map codes: RELEASED/ACTIVE/ON_HOLD/REJECTED; VARCHAR(40) to VARCHAR(30) | Confirmed |
| Quality Disposition | Disposition Name | EnterpriseAnalytics | dim_quality_disposition | disposition_name | Map descriptive status to code; manual mapping | Confirmed |
| Quality Disposition | Disposition Name | LexingtonSite | batch_run | batch_status | Map descriptive status to code; manual mapping | Confirmed |
| Quality Disposition | Requires Investigation | EnterpriseAnalytics | dim_quality_disposition | requires_investigation | Map TRUE to 'investigating', FALSE to 'open' or 'resolved'; BOOLEAN to VARCHAR(30) | Confirmed |
| Quality Disposition | Requires Investigation | LexingtonSite | deviation_event | dev_status | Map TRUE to 'investigating', FALSE to 'open' or 'resolved'; BOOLEAN to VARCHAR(30) | Confirmed |
| Quality Disposition | Description | EnterpriseAnalytics | dim_quality_disposition | description | Map VARCHAR(500) to TEXT | Confirmed |
| Quality Disposition | Description | LexingtonSite | deviation_event | deviation_desc | Map VARCHAR(500) to TEXT | Confirmed |
| Batch | Enterprise Batch ID | EnterpriseAnalytics | fact_batch_summary | enterprise_batch_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Batch | Enterprise Batch ID | LexingtonSite | batch_run | batch_id | Direct 1:1 map; enforce NOT NULL + UNIQUE | Confirmed |
| Batch | Batch Status | EnterpriseAnalytics | fact_batch_summary | batch_status | Map status codes; direct 1:1 mapping; VARCHAR(30) | Confirmed |
| Batch | Batch Status | LexingtonSite | batch_run | batch_status | Map status codes; direct 1:1 mapping; VARCHAR(30) | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalytics | fact_batch_summary | planned_qty | Direct 1:1 map; enforce NOT NULL | Confirmed |
| Batch | Planned Quantity | LexingtonSite | batch_run | planned_qty | Direct 1:1 map; enforce NOT NULL | Confirmed |
| Facility | Site Code | EnterpriseAnalytics | dim_facility | site_code |  | Unmapped |
| Facility | Effective Start Date | EnterpriseAnalytics | dim_facility | effective_start_date |  | Unmapped |
| Facility | Effective End Date | EnterpriseAnalytics | dim_facility | effective_end_date |  | Unmapped |
| Facility | Current Flag | EnterpriseAnalytics | dim_facility | current_flag |  | Unmapped |
| Product | Product Key | EnterpriseAnalytics | dim_product | product_key |  | Unmapped |
| Product | Formulation ID | EnterpriseAnalytics | dim_product | formulation_id |  | Unmapped |
| Product | Standard Yield Percent | EnterpriseAnalytics | dim_product | standard_yield_pct |  | Unmapped |
| Product | Effective Start Date | EnterpriseAnalytics | dim_product | effective_start_date |  | Unmapped |
| Product | Effective End Date | EnterpriseAnalytics | dim_product | effective_end_date |  | Unmapped |
| Product | Current Flag | EnterpriseAnalytics | dim_product | current_flag |  | Unmapped |
| Quality Disposition | Disposition Key | EnterpriseAnalytics | dim_quality_disposition | disposition_key |  | Unmapped |
| Quality Disposition | Commercially Releasable | EnterpriseAnalytics | dim_quality_disposition | commercially_releasable |  | Unmapped |
| Quality Disposition | Deviation Implied | EnterpriseAnalytics | dim_quality_disposition | deviation_implied |  | Unmapped |
| Quality Disposition | Description | EnterpriseAnalytics | dim_quality_disposition | description |  | Unmapped |
| Batch | Batch Summary Key | EnterpriseAnalytics | fact_batch_summary | batch_summary_key |  | Unmapped |
| Batch | End Timestamp UTC | EnterpriseAnalytics | fact_batch_summary | end_timestamp_utc |  | Unmapped |
| Batch | Performance Percent | EnterpriseAnalytics | fact_batch_summary | performance_pct |  | Unmapped |
| Batch | Quality Percent | EnterpriseAnalytics | fact_batch_summary | quality_pct |  | Unmapped |
| Batch | OEE Percent | EnterpriseAnalytics | fact_batch_summary | oee_pct |  | Unmapped |
| Batch | Loaded At UTC | EnterpriseAnalytics | fact_batch_summary | loaded_at_utc |  | Unmapped |
| Yield Analytics | Yield Analysis Key | EnterpriseAnalytics | fact_yield_analysis | yield_analysis_key |  | Unmapped |
| Yield Analytics | Analysis Date | EnterpriseAnalytics | fact_yield_analysis | analysis_date |  | Unmapped |
| Yield Analytics | Batch Count | EnterpriseAnalytics | fact_yield_analysis | batch_count |  | Unmapped |
| Yield Analytics | Average Yield Percent | EnterpriseAnalytics | fact_yield_analysis | avg_yield_pct |  | Unmapped |
| Yield Analytics | Minimum Yield Percent | EnterpriseAnalytics | fact_yield_analysis | min_yield_pct |  | Unmapped |
| Yield Analytics | Maximum Yield Percent | EnterpriseAnalytics | fact_yield_analysis | max_yield_pct |  | Unmapped |
| Yield Analytics | Std Yield Percent | EnterpriseAnalytics | fact_yield_analysis | std_yield_pct |  | Unmapped |
| Yield Analytics | Below Target Count | EnterpriseAnalytics | fact_yield_analysis | below_target_count |  | Unmapped |
| Yield Analytics | Total Planned Qty | EnterpriseAnalytics | fact_yield_analysis | total_planned_qty |  | Unmapped |
| Yield Analytics | Total Actual Qty | EnterpriseAnalytics | fact_yield_analysis | total_actual_qty |  | Unmapped |
| Yield Analytics | Quantity Unit | EnterpriseAnalytics | fact_yield_analysis | qty_unit |  | Unmapped |
| Yield Analytics | Loaded At UTC | EnterpriseAnalytics | fact_yield_analysis | loaded_at_utc |  | Unmapped |
| Equipment | Asset Type | LexingtonSite | equipment | asset_type |  | Unmapped |
| Equipment | Manufacturer | LexingtonSite | equipment | manufacturer |  | Unmapped |
| Equipment | Model Number | LexingtonSite | equipment | model_number |  | Unmapped |
| Equipment | Install Date | LexingtonSite | equipment | install_date |  | Unmapped |
| Equipment | Calibration Due | LexingtonSite | equipment | calibration_due |  | Unmapped |
| Equipment | Last Calibrated | LexingtonSite | equipment | last_calibrated |  | Unmapped |
| Equipment | Line ID | LexingtonSite | equipment | line_id |  | Unmapped |
| Equipment | Updated At | LexingtonSite | equipment | updated_at |  | Unmapped |
| Batch Run | Run ID | LexingtonSite | batch_run | run_id |  | Unmapped |
| Batch Run | Step Sequence | LexingtonSite | batch_run | step_seq |  | Unmapped |
| Batch Run | Operator ID | LexingtonSite | batch_run | operator_id |  | Unmapped |
| Batch Run | Shift | LexingtonSite | batch_run | shift |  | Unmapped |
| Batch Run | Notes | LexingtonSite | batch_run | notes |  | Unmapped |
| Batch Run | Created At | LexingtonSite | batch_run | created_at |  | Unmapped |
| Parameter Reading | Reading ID | LexingtonSite | parameter_reading | reading_id |  | Unmapped |
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
| Deviation Event | Severity | LexingtonSite | deviation_event | severity |  | Unmapped |
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