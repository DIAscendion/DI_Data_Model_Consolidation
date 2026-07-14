# Canonical Data Mapper Output

## Section 1 — Mapping Summary

| Metric | Count |
|---|---|
| Total Canonical Entities identified | 8 |
| Total Canonical Attributes mapped | 19 |
| Confirmed mappings | 15 |
| Inferred mappings | 2 |
| Ambiguous mappings | 1 |
| Unmapped columns | 18 |
| PII-flagged attributes | 0 |

---

## Section 2 — Canonical Mapping Table

| Entity Name | Attribute Name | App Name 1 | Table Name 1 | Column Name 1 | App Name 2 | Table Name 2 | Column Name 2 | Transformation Rule | Status |
|---|---|---|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalytics | dim_facility | facility_id | LexingtonSite | equipment | equip_id | Cast VARCHAR(30) to VARCHAR(30); direct map | Confirmed |
| Facility | Facility Name | EnterpriseAnalytics | dim_facility | facility_name | LexingtonSite | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Site Code | EnterpriseAnalytics | dim_facility | site_code | LexingtonSite | equipment | building | Map site_code to building via lookup table | Confirmed |
| Product | Product ID | EnterpriseAnalytics | dim_product | product_id | LexingtonSite | batch_run | product_code | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product Name | EnterpriseAnalytics | dim_product | product_name | LexingtonSite | batch_run | step_name | Map step_name to product_name via business rules | Ambiguous |
| Product | SKU | EnterpriseAnalytics | dim_product | sku | LexingtonSite | batch_run | product_code | Map sku to product_code via reference table | Confirmed |
| Product | Dosage Form | EnterpriseAnalytics | dim_product | dosage_form | LexingtonSite | batch_run | step_name | Map step_name to dosage_form via business rules | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalytics | fact_batch_summary | enterprise_batch_id | LexingtonSite | batch_run | batch_id | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Batch | Facility Key | EnterpriseAnalytics | fact_batch_summary | facility_key | LexingtonSite | batch_run | equip_id | Map facility_key to equip_id via lookup table | Inferred |
| Batch | Product Key | EnterpriseAnalytics | fact_batch_summary | product_key | LexingtonSite | batch_run | product_code | Map product_key to product_code via reference table | Confirmed |
| Batch | Batch Status | EnterpriseAnalytics | fact_batch_summary | batch_status | LexingtonSite | batch_run | batch_status | Map status values via lookup; direct map for common values | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalytics | fact_batch_summary | planned_qty | LexingtonSite | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalytics | fact_batch_summary | actual_qty | LexingtonSite | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalytics | fact_batch_summary | qty_unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percent | EnterpriseAnalytics | fact_batch_summary | yield_pct | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Deviation Count | EnterpriseAnalytics | fact_batch_summary | deviation_count | LexingtonSite | deviation_event | deviation_id | Map deviation_count to deviation_id via aggregation | Inferred |
| Batch | Source Site Code | EnterpriseAnalytics | fact_batch_summary | source_site_code | LexingtonSite | equipment | building | Map source_site_code to building via lookup table | Confirmed |
| Yield Analytics | Average Yield Percent | EnterpriseAnalytics | fact_yield_analysis | avg_yield_pct | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct | Confirmed |
| Yield Analytics | Quantity Unit | EnterpriseAnalytics | fact_yield_analysis | qty_unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |

---

## Section 3 — Canonical Extension Recommendations

| App Name | Table Name | Column Name | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped |
|---|---|---|---|---|---|
| EnterpriseAnalytics | dim_facility | city | Facility | City | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | state_region | Facility | State/Region | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | country_code | Facility | Country Code | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | timezone_name | Facility | Timezone Name | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | gmp_certified | Facility | GMP Certified | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | effective_start_date | Facility | Effective Start Date | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | effective_end_date | Facility | Effective End Date | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_facility | current_flag | Facility | Current Flag | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | formulation_id | Product | Formulation ID | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | therapeutic_class | Product | Therapeutic Class | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | standard_yield_pct | Product | Standard Yield Percent | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | effective_start_date | Product | Effective Start Date | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | effective_end_date | Product | Effective End Date | No equivalent found in other applications; add to canonical model |
| EnterpriseAnalytics | dim_product | current_flag | Product | Current Flag | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | manufacturer | Equipment | Manufacturer Name | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | model_number | Equipment | Model Number | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | install_date | Equipment | Installation Date | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | calibration_due | Equipment | Calibration Due Date | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | last_calibrated | Equipment | Last Calibration Date | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | status | Equipment | Equipment Status | No equivalent found in other applications; add to canonical model |
| LexingtonSite | equipment | line_id | Equipment | Line ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | run_id | Batch | Run ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | step_seq | Batch | Step Sequence | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | start_ts | Batch | Start Timestamp | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | end_ts | Batch | End Timestamp | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | operator_id | Operator | Operator ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | shift | Batch | Shift | No equivalent found in other applications; add to canonical model |
| LexingtonSite | batch_run | notes | Batch | Notes | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | reading_id | Process Parameter | Reading ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | param_code | Process Parameter | Parameter Code | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | reading_ts | Process Parameter | Reading Timestamp | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | param_value | Process Parameter | Parameter Value | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | uom | Process Parameter | Unit of Measure | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | target_val | Process Parameter | Target Value | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | lower_limit | Process Parameter | Lower Limit | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | upper_limit | Process Parameter | Upper Limit | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | in_spec | Process Parameter | In Spec | No equivalent found in other applications; add to canonical model |
| LexingtonSite | parameter_reading | aggregation | Process Parameter | Aggregation Type | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | deviation_id | Deviation | Deviation ID | Best match score below 40; candidate for manual mapping |
| LexingtonSite | deviation_event | batch_id | Deviation | Batch ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | run_id | Deviation | Run ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | equip_id | Deviation | Equipment ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | reading_id | Deviation | Reading ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | detected_ts | Deviation | Detected Timestamp | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | param_code | Deviation | Parameter Code | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | deviation_desc | Deviation | Deviation Description | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | severity | Deviation | Severity | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | dev_status | Deviation | Deviation Status | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | assigned_to | Deviation | Assigned To | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | resolved_ts | Deviation | Resolved Timestamp | No equivalent found in other applications; add to canonical model |
| LexingtonSite | deviation_event | resolution_notes | Deviation | Resolution Notes | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | shift_log_id | Shift Log | Shift Log ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | log_date | Shift Log | Log Date | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | shift | Shift Log | Shift | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | supervisor_id | Shift Log | Supervisor ID | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | supervisor_name | Shift Log | Supervisor Name | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | active_batches | Shift Log | Active Batches | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | completed_batches | Shift Log | Completed Batches | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | new_deviations | Shift Log | New Deviations | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | equip_downtime_min | Shift Log | Equipment Downtime Minutes | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | shift_notes | Shift Log | Shift Notes | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | signed_off | Shift Log | Signed Off | No equivalent found in other applications; add to canonical model |
| LexingtonSite | shift_log | signed_off_ts | Shift Log | Signed Off Timestamp | No equivalent found in other applications; add to canonical model |

---

## Section 4 — Mapping Table

| Entity Name | Attribute Name | Application Name | Table Name | Column Name | Transformation Rule | Status |
|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalytics | dim_facility | facility_id | Cast VARCHAR(30) to VARCHAR(30); direct map | Confirmed |
| Facility | Facility ID | LexingtonSite | equipment | equip_id | Cast VARCHAR(30) to VARCHAR(30); direct map | Confirmed |
| Facility | Facility Name | EnterpriseAnalytics | dim_facility | facility_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Facility Name | LexingtonSite | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Site Code | EnterpriseAnalytics | dim_facility | site_code | Map site_code to building via lookup table | Confirmed |
| Facility | Site Code | LexingtonSite | equipment | building | Map site_code to building via lookup table | Confirmed |
| Product | Product ID | EnterpriseAnalytics | dim_product | product_id | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product ID | LexingtonSite | batch_run | product_code | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product Name | EnterpriseAnalytics | dim_product | product_name | Map step_name to product_name via business rules | Ambiguous |
| Product | Product Name | LexingtonSite | batch_run | step_name | Map step_name to product_name via business rules | Ambiguous |
| Product | SKU | EnterpriseAnalytics | dim_product | sku | Map sku to product_code via reference table | Confirmed |
| Product | SKU | LexingtonSite | batch_run | product_code | Map sku to product_code via reference table | Confirmed |
| Product | Dosage Form | EnterpriseAnalytics | dim_product | dosage_form | Map step_name to dosage_form via business rules | Inferred |
| Product | Dosage Form | LexingtonSite | batch_run | step_name | Map step_name to dosage_form via business rules | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalytics | fact_batch_summary | enterprise_batch_id | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Batch | Enterprise Batch ID | LexingtonSite | batch_run | batch_id | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Batch | Facility Key | EnterpriseAnalytics | fact_batch_summary | facility_key | Map facility_key to equip_id via lookup table | Inferred |
| Batch | Facility Key | LexingtonSite | batch_run | equip_id | Map facility_key to equip_id via lookup table | Inferred |
| Batch | Product Key | EnterpriseAnalytics | fact_batch_summary | product_key | Map product_key to product_code via reference table | Confirmed |
| Batch | Product Key | LexingtonSite | batch_run | product_code | Map product_key to product_code via reference table | Confirmed |
| Batch | Batch Status | EnterpriseAnalytics | fact_batch_summary | batch_status | Map status values via lookup; direct map for common values | Confirmed |
| Batch | Batch Status | LexingtonSite | batch_run | batch_status | Map status values via lookup; direct map for common values | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalytics | fact_batch_summary | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Planned Quantity | LexingtonSite | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalytics | fact_batch_summary | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | LexingtonSite | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalytics | fact_batch_summary | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Quantity Unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percent | EnterpriseAnalytics | fact_batch_summary | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Yield Percent | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Deviation Count | EnterpriseAnalytics | fact_batch_summary | deviation_count | Map deviation_count to deviation_id via aggregation | Inferred |
| Batch | Deviation Count | LexingtonSite | deviation_event | deviation_id | Map deviation_count to deviation_id via aggregation | Inferred |
| Batch | Source Site Code | EnterpriseAnalytics | fact_batch_summary | source_site_code | Map source_site_code to building via lookup table | Confirmed |
| Batch | Source Site Code | LexingtonSite | equipment | building | Map source_site_code to building via lookup table | Confirmed |
| Yield Analytics | Average Yield Percent | EnterpriseAnalytics | fact_yield_analysis | avg_yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct | Confirmed |
| Yield Analytics | Average Yield Percent | LexingtonSite | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct | Confirmed |
| Yield Analytics | Quantity Unit | EnterpriseAnalytics | fact_yield_analysis | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Yield Analytics | Quantity Unit | LexingtonSite | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Facility | City | EnterpriseAnalytics | dim_facility | city |  | Unmapped |
| Facility | State/Region | EnterpriseAnalytics | dim_facility | state_region |  | Unmapped |
| Facility | Country Code | EnterpriseAnalytics | dim_facility | country_code |  | Unmapped |
| Facility | Timezone Name | EnterpriseAnalytics | dim_facility | timezone_name |  | Unmapped |
| Facility | GMP Certified | EnterpriseAnalytics | dim_facility | gmp_certified |  | Unmapped |
| Facility | Effective Start Date | EnterpriseAnalytics | dim_facility | effective_start_date |  | Unmapped |
| Facility | Effective End Date | EnterpriseAnalytics | dim_facility | effective_end_date |  | Unmapped |
| Facility | Current Flag | EnterpriseAnalytics | dim_facility | current_flag |  | Unmapped |
| Product | Formulation ID | EnterpriseAnalytics | dim_product | formulation_id |  | Unmapped |
| Product | Therapeutic Class | EnterpriseAnalytics | dim_product | therapeutic_class |  | Unmapped |
| Product | Standard Yield Percent | EnterpriseAnalytics | dim_product | standard_yield_pct |  | Unmapped |
| Product | Effective Start Date | EnterpriseAnalytics | dim_product | effective_start_date |  | Unmapped |
| Product | Effective End Date | EnterpriseAnalytics | dim_product | effective_end_date |  | Unmapped |
| Product | Current Flag | EnterpriseAnalytics | dim_product | current_flag |  | Unmapped |
| Equipment | Manufacturer Name | LexingtonSite | equipment | manufacturer |  | Unmapped |
| Equipment | Model Number | LexingtonSite | equipment | model_number |  | Unmapped |
| Equipment | Installation Date | LexingtonSite | equipment | install_date |  | Unmapped |
| Equipment | Calibration Due Date | LexingtonSite | equipment | calibration_due |  | Unmapped |
| Equipment | Last Calibration Date | LexingtonSite | equipment | last_calibrated |  | Unmapped |
| Equipment | Equipment Status | LexingtonSite | equipment | status |  | Unmapped |
| Equipment | Line ID | LexingtonSite | equipment | line_id |  | Unmapped |
| Batch | Run ID | LexingtonSite | batch_run | run_id |  | Unmapped |
| Batch | Step Sequence | LexingtonSite | batch_run | step_seq |  | Unmapped |
| Batch | Start Timestamp | LexingtonSite | batch_run | start_ts |  | Unmapped |
| Batch | End Timestamp | LexingtonSite | batch_run | end_ts |  | Unmapped |
| Operator | Operator ID | LexingtonSite | batch_run | operator_id |  | Unmapped |
| Batch | Shift | LexingtonSite | batch_run | shift |  | Unmapped |
| Batch | Notes | LexingtonSite | batch_run | notes |  | Unmapped |
| Process Parameter | Reading ID | LexingtonSite | parameter_reading | reading_id |  | Unmapped |
| Process Parameter | Parameter Code | LexingtonSite | parameter_reading | param_code |  | Unmapped |
| Process Parameter | Reading Timestamp | LexingtonSite | parameter_reading | reading_ts |  | Unmapped |
| Process Parameter | Parameter Value | LexingtonSite | parameter_reading | param_value |  | Unmapped |
| Process Parameter | Unit of Measure | LexingtonSite | parameter_reading | uom |  | Unmapped |
| Process Parameter | Target Value | LexingtonSite | parameter_reading | target_val |  | Unmapped |
| Process Parameter | Lower Limit | LexingtonSite | parameter_reading | lower_limit |  | Unmapped |
| Process Parameter | Upper Limit | LexingtonSite | parameter_reading | upper_limit |  | Unmapped |
| Process Parameter | In Spec | LexingtonSite | parameter_reading | in_spec |  | Unmapped |
| Process Parameter | Aggregation Type | LexingtonSite | parameter_reading | aggregation |  | Unmapped |
| Deviation | Deviation ID | LexingtonSite | deviation_event | deviation_id |  | Unmapped |
| Deviation | Batch ID | LexingtonSite | deviation_event | batch_id |  | Unmapped |
| Deviation | Run ID | LexingtonSite | deviation_event | run_id |  | Unmapped |
| Deviation | Equipment ID | LexingtonSite | deviation_event | equip_id |  | Unmapped |
| Deviation | Reading ID | LexingtonSite | deviation_event | reading_id |  | Unmapped |
| Deviation | Detected Timestamp | LexingtonSite | deviation_event | detected_ts |  | Unmapped |
| Deviation | Parameter Code | LexingtonSite | deviation_event | param_code |  | Unmapped |
| Deviation | Deviation Description | LexingtonSite | deviation_event | deviation_desc |  | Unmapped |
| Deviation | Severity | LexingtonSite | deviation_event | severity |  | Unmapped |
| Deviation | Deviation Status | LexingtonSite | deviation_event | dev_status |  | Unmapped |
| Deviation | Assigned To | LexingtonSite | deviation_event | assigned_to |  | Unmapped |
| Deviation | Resolved Timestamp | LexingtonSite | deviation_event | resolved_ts |  | Unmapped |
| Deviation | Resolution Notes | LexingtonSite | deviation_event | resolution_notes |  | Unmapped |
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
