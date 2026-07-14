# Canonical Data Mapping — Pharma Manufacturing Model Consolidation

## Section 1 — Mapping Summary

| Metric                              | Count |
|-------------------------------------|-------|
| Total Canonical Entities identified | 7     |
| Total Canonical Attributes mapped   | 18    |
| Confirmed mappings                  | 14    |
| Inferred mappings                   | 4     |
| Ambiguous mappings                  | 0     |
| Unmapped columns                    | 36    |
| PII-flagged attributes              | 0     |

---

## Section 2 — Canonical Mapping Table

| Entity Name       | Attribute Name        | App Name 1           | Table Name 1         | Column Name 1         | App Name 2      | Table Name 2        | Column Name 2        | Transformation Rule                                                          | Status     |
|------------------|----------------------|----------------------|----------------------|-----------------------|-----------------|---------------------|----------------------|-------------------------------------------------------------------------------|------------|
| Facility         | Facility ID          | EnterpriseAnalytics  | dim_facility         | facility_id           | LexingtonSite   | equipment           | equip_id             | Cast VARCHAR(30) to VARCHAR(30); direct map                                   | Confirmed  |
| Facility         | Facility Name        | EnterpriseAnalytics  | dim_facility         | facility_name         | LexingtonSite   | equipment           | equip_name           | Cast VARCHAR(150) to VARCHAR(150); direct map                                 | Confirmed  |
| Facility         | Site Code            | EnterpriseAnalytics  | dim_facility         | site_code             | LexingtonSite   | equipment           | building             | Map site_code to building via lookup table                                    | Confirmed  |
| Product          | Product ID           | EnterpriseAnalytics  | dim_product          | product_id            | LexingtonSite   | batch_run           | product_code          | Cast VARCHAR(50) to VARCHAR(50); direct map                                   | Confirmed  |
| Product          | Product Name         | EnterpriseAnalytics  | dim_product          | product_name          | LexingtonSite   | batch_run           | step_name            | Map step_name to product_name via business rules                              | Inferred   |
| Product          | SKU                  | EnterpriseAnalytics  | dim_product          | sku                   | LexingtonSite   | batch_run           | product_code          | Map sku to product_code via reference table                                   | Confirmed  |
| Product          | Dosage Form          | EnterpriseAnalytics  | dim_product          | dosage_form           | LexingtonSite   | batch_run           | step_name            | Map step_name to dosage_form via business rules                               | Inferred   |
| Batch            | Batch ID             | EnterpriseAnalytics  | fact_batch_summary   | enterprise_batch_id   | LexingtonSite   | batch_run           | batch_id              | Cast VARCHAR(50) to VARCHAR(50); direct map                                   | Confirmed  |
| Batch            | Facility Key         | EnterpriseAnalytics  | fact_batch_summary   | facility_key          | LexingtonSite   | batch_run           | equip_id              | Map facility_key to equip_id via lookup table                                 | Inferred   |
| Batch            | Product Key          | EnterpriseAnalytics  | fact_batch_summary   | product_key           | LexingtonSite   | batch_run           | product_code          | Map product_key to product_code via reference table                           | Confirmed  |
| Batch            | Batch Status         | EnterpriseAnalytics  | fact_batch_summary   | batch_status          | LexingtonSite   | batch_run           | batch_status          | Map status values via lookup; direct map for common values                    | Confirmed  |
| Batch            | Planned Quantity     | EnterpriseAnalytics  | fact_batch_summary   | planned_qty           | LexingtonSite   | batch_run           | planned_qty           | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                                | Confirmed  |
| Batch            | Actual Quantity      | EnterpriseAnalytics  | fact_batch_summary   | actual_qty            | LexingtonSite   | batch_run           | actual_qty            | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                                | Confirmed  |
| Batch            | Quantity Unit        | EnterpriseAnalytics  | fact_batch_summary   | qty_unit              | LexingtonSite   | batch_run           | qty_unit              | Cast VARCHAR(20) to VARCHAR(20); direct map                                    | Confirmed  |
| Batch            | Yield Percent        | EnterpriseAnalytics  | fact_batch_summary   | yield_pct             | LexingtonSite   | batch_run           | yield_pct             | Cast NUMBER(6,3) to NUMERIC(6,3); direct map                                  | Confirmed  |
| Batch            | Deviation Count      | EnterpriseAnalytics  | fact_batch_summary   | deviation_count       | LexingtonSite   | deviation_event     | deviation_id          | Map deviation_count to deviation_id via aggregation                            | Inferred   |
| Yield Analytics  | Average Yield Pct    | EnterpriseAnalytics  | fact_yield_analysis  | avg_yield_pct         | LexingtonSite   | batch_run           | yield_pct             | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct         | Confirmed  |
| Yield Analytics  | Quantity Unit        | EnterpriseAnalytics  | fact_yield_analysis  | qty_unit              | LexingtonSite   | batch_run           | qty_unit              | Cast VARCHAR(20) to VARCHAR(20); direct map                                    | Confirmed  |

---

## Section 3 — Canonical Extension Recommendations

| App Name           | Table Name             | Column Name           | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped                                             |
|--------------------|-----------------------|-----------------------|---------------------------|------------------------------|------------------------------------------------------------|
| EnterpriseAnalytics| dim_facility           | city                  | Facility                  | City                         | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | state_region          | Facility                  | State/Region                 | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | country_code          | Facility                  | Country Code                 | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | timezone_name         | Facility                  | Timezone Name                | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | gmp_certified         | Facility                  | GMP Certified                | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | effective_start_date  | Facility                  | Effective Start Date          | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | effective_end_date    | Facility                  | Effective End Date            | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_facility           | current_flag          | Facility                  | Current Flag                  | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | formulation_id        | Product                   | Formulation ID                | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | therapeutic_class     | Product                   | Therapeutic Class             | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | standard_yield_pct    | Product                   | Standard Yield Percent         | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | effective_start_date  | Product                   | Effective Start Date           | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | effective_end_date    | Product                   | Effective End Date             | No equivalent column found in any other application         |
| EnterpriseAnalytics| dim_product            | current_flag          | Product                   | Current Flag                   | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | manufacturer          | Equipment                 | Manufacturer                   | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | model_number          | Equipment                 | Model Number                   | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | install_date          | Equipment                 | Installation Date               | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | calibration_due       | Equipment                 | Calibration Due                 | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | last_calibrated       | Equipment                 | Last Calibrated                 | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | status                | Equipment                 | Equipment Status                | No equivalent column found in any other application         |
| LexingtonSite      | equipment              | line_id               | Equipment                 | Line ID                         | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | run_id                | Batch                      | Run ID                         | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | step_seq              | Batch                      | Step Sequence                  | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | start_ts              | Batch                      | Start Timestamp                | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | end_ts                | Batch                      | End Timestamp                  | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | operator_id           | Operator                    | Operator ID                    | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | shift                 | Shift Log                   | Shift                          | No equivalent column found in any other application         |
| LexingtonSite      | batch_run              | notes                 | Batch                       | Notes                          | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | reading_id            | Process Parameter Reading   | Reading ID                     | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | param_code            | Process Parameter Reading   | Parameter Code                 | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | reading_ts            | Process Parameter Reading   | Reading Timestamp              | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | param_value           | Process Parameter Reading   | Parameter Value                | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | uom                   | Process Parameter Reading   | Unit of Measure                | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | target_val            | Process Parameter Reading   | Target Value                   | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | lower_limit           | Process Parameter Reading   | Lower Limit                    | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | upper_limit           | Process Parameter Reading   | Upper Limit                    | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | in_spec               | Process Parameter Reading   | In Spec                        | No equivalent column found in any other application         |
| LexingtonSite      | parameter_reading      | aggregation           | Process Parameter Reading   | Aggregation                    | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | deviation_id          | Deviation Event            | Deviation ID                   | Best match score below 40 — possible manual mapping needed  |
| LexingtonSite      | deviation_event        | batch_id              | Deviation Event            | Batch ID                       | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | run_id                | Deviation Event            | Run ID                         | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | equip_id              | Deviation Event            | Equipment ID                   | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | reading_id            | Deviation Event            | Reading ID                     | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | detected_ts           | Deviation Event            | Detected Timestamp             | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | param_code            | Deviation Event            | Parameter Code                 | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | deviation_desc        | Deviation Event            | Deviation Description          | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | severity              | Deviation Event            | Severity                       | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | dev_status            | Deviation Event            | Deviation Status               | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | assigned_to           | Deviation Event            | Assigned To                    | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | resolved_ts           | Deviation Event            | Resolved Timestamp             | No equivalent column found in any other application         |
| LexingtonSite      | deviation_event        | resolution_notes      | Deviation Event            | Resolution Notes               | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | shift_log_id          | Shift Log                  | Shift Log ID                   | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | log_date              | Shift Log                  | Log Date                       | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | shift                 | Shift Log                  | Shift                          | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | supervisor_id         | Shift Log                  | Supervisor ID                  | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | supervisor_name       | Shift Log                  | Supervisor Name                | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | active_batches        | Shift Log                  | Active Batches                 | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | completed_batches     | Shift Log                  | Completed Batches              | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | new_deviations        | Shift Log                  | New Deviations                 | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | equip_downtime_min    | Shift Log                  | Equipment Downtime Minutes      | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | shift_notes           | Shift Log                  | Shift Notes                    | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | signed_off            | Shift Log                  | Signed Off                     | No equivalent column found in any other application         |
| LexingtonSite      | shift_log              | signed_off_ts         | Shift Log                  | Signed Off Timestamp           | No equivalent column found in any other application         |

---

## Section 4 — Mapping Table (Audit View)

| Entity Name             | Attribute Name            | Application Name      | Table Name              | Column Name            | Transformation Rule                                                      | Status     |
|------------------------|--------------------------|----------------------|------------------------|------------------------|-------------------------------------------------------------------------|------------|
| Facility               | Facility ID              | EnterpriseAnalytics  | dim_facility           | facility_id            | Cast VARCHAR(30) to VARCHAR(30); direct map                             | Confirmed  |
| Facility               | Facility ID              | LexingtonSite        | equipment              | equip_id               | Cast VARCHAR(30) to VARCHAR(30); direct map                             | Confirmed  |
| Facility               | Facility Name            | EnterpriseAnalytics  | dim_facility           | facility_name          | Cast VARCHAR(150) to VARCHAR(150); direct map                           | Confirmed  |
| Facility               | Facility Name            | LexingtonSite        | equipment              | equip_name             | Cast VARCHAR(150) to VARCHAR(150); direct map                           | Confirmed  |
| Facility               | Site Code                | EnterpriseAnalytics  | dim_facility           | site_code              | Map site_code to building via lookup table                              | Confirmed  |
| Facility               | Site Code                | LexingtonSite        | equipment              | building               | Map site_code to building via lookup table                              | Confirmed  |
| Product                | Product ID               | EnterpriseAnalytics  | dim_product            | product_id             | Cast VARCHAR(50) to VARCHAR(50); direct map                             | Confirmed  |
| Product                | Product ID               | LexingtonSite        | batch_run              | product_code           | Cast VARCHAR(50) to VARCHAR(50); direct map                             | Confirmed  |
| Product                | Product Name             | EnterpriseAnalytics  | dim_product            | product_name           | Map step_name to product_name via business rules                        | Inferred   |
| Product                | Product Name             | LexingtonSite        | batch_run              | step_name              | Map step_name to product_name via business rules                        | Inferred   |
| Product                | SKU                      | EnterpriseAnalytics  | dim_product            | sku                    | Map sku to product_code via reference table                             | Confirmed  |
| Product                | SKU                      | LexingtonSite        | batch_run              | product_code           | Map sku to product_code via reference table                             | Confirmed  |
| Product                | Dosage Form              | EnterpriseAnalytics  | dim_product            | dosage_form            | Map step_name to dosage_form via business rules                         | Inferred   |
| Product                | Dosage Form              | LexingtonSite        | batch_run              | step_name              | Map step_name to dosage_form via business rules                         | Inferred   |
| Batch                  | Batch ID                 | EnterpriseAnalytics  | fact_batch_summary     | enterprise_batch_id    | Cast VARCHAR(50) to VARCHAR(50); direct map                             | Confirmed  |
| Batch                  | Batch ID                 | LexingtonSite        | batch_run              | batch_id               | Cast VARCHAR(50) to VARCHAR(50); direct map                             | Confirmed  |
| Batch                  | Facility Key             | EnterpriseAnalytics  | fact_batch_summary     | facility_key           | Map facility_key to equip_id via lookup table                           | Inferred   |
| Batch                  | Facility Key             | LexingtonSite        | batch_run              | equip_id               | Map facility_key to equip_id via lookup table                           | Inferred   |
| Batch                  | Product Key              | EnterpriseAnalytics  | fact_batch_summary     | product_key            | Map product_key to product_code via reference table                     | Confirmed  |
| Batch                  | Product Key              | LexingtonSite        | batch_run              | product_code           | Map product_key to product_code via reference table                     | Confirmed  |
| Batch                  | Batch Status             | EnterpriseAnalytics  | fact_batch_summary     | batch_status           | Map status values via lookup; direct map for common values              | Confirmed  |
| Batch                  | Batch Status             | LexingtonSite        | batch_run              | batch_status           | Map status values via lookup; direct map for common values              | Confirmed  |
| Batch                  | Planned Quantity         | EnterpriseAnalytics  | fact_batch_summary     | planned_qty            | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                          | Confirmed  |
| Batch                  | Planned Quantity         | LexingtonSite        | batch_run              | planned_qty            | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                          | Confirmed  |
| Batch                  | Actual Quantity          | EnterpriseAnalytics  | fact_batch_summary     | actual_qty             | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                          | Confirmed  |
| Batch                  | Actual Quantity          | LexingtonSite        | batch_run              | actual_qty             | Cast NUMBER(18,3) to NUMERIC(18,3); direct map                          | Confirmed  |
| Batch                  | Quantity Unit            | EnterpriseAnalytics  | fact_batch_summary     | qty_unit               | Cast VARCHAR(20) to VARCHAR(20); direct map                              | Confirmed  |
| Batch                  | Quantity Unit            | LexingtonSite        | batch_run              | qty_unit               | Cast VARCHAR(20) to VARCHAR(20); direct map                              | Confirmed  |
| Batch                  | Yield Percent            | EnterpriseAnalytics  | fact_batch_summary     | yield_pct              | Cast NUMBER(6,3) to NUMERIC(6,3); direct map                             | Confirmed  |
| Batch                  | Yield Percent            | LexingtonSite        | batch_run              | yield_pct              | Cast NUMBER(6,3) to NUMERIC(6,3); direct map                             | Confirmed  |
| Batch                  | Deviation Count          | EnterpriseAnalytics  | fact_batch_summary     | deviation_count        | Map deviation_count to deviation_id via aggregation                      | Inferred   |
| Batch                  | Deviation Count          | LexingtonSite        | deviation_event        | deviation_id           | Map deviation_count to deviation_id via aggregation                      | Inferred   |
| Yield Analytics        | Average Yield Pct        | EnterpriseAnalytics  | fact_yield_analysis    | avg_yield_pct          | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct   | Confirmed  |
| Yield Analytics        | Average Yield Pct        | LexingtonSite        | batch_run              | yield_pct              | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct   | Confirmed  |
| Yield Analytics        | Quantity Unit            | EnterpriseAnalytics  | fact_yield_analysis    | qty_unit               | Cast VARCHAR(20) to VARCHAR(20); direct map                              | Confirmed  |
| Yield Analytics        | Quantity Unit            | LexingtonSite        | batch_run              | qty_unit               | Cast VARCHAR(20) to VARCHAR(20); direct map                              | Confirmed  |
| Facility               | City                    | EnterpriseAnalytics  | dim_facility           | city                   |                                                                 | Unmapped   |
| Facility               | State/Region            | EnterpriseAnalytics  | dim_facility           | state_region           |                                                                 | Unmapped   |
| Facility               | Country Code            | EnterpriseAnalytics  | dim_facility           | country_code           |                                                                 | Unmapped   |
| Facility               | Timezone Name           | EnterpriseAnalytics  | dim_facility           | timezone_name          |                                                                 | Unmapped   |
| Facility               | GMP Certified           | EnterpriseAnalytics  | dim_facility           | gmp_certified          |                                                                 | Unmapped   |
| Facility               | Effective Start Date    | EnterpriseAnalytics  | dim_facility           | effective_start_date   |                                                                 | Unmapped   |
| Facility               | Effective End Date      | EnterpriseAnalytics  | dim_facility           | effective_end_date     |                                                                 | Unmapped   |
| Facility               | Current Flag            | EnterpriseAnalytics  | dim_facility           | current_flag           |                                                                 | Unmapped   |
| Product                | Formulation ID          | EnterpriseAnalytics  | dim_product            | formulation_id         |                                                                 | Unmapped   |
| Product                | Therapeutic Class       | EnterpriseAnalytics  | dim_product            | therapeutic_class      |                                                                 | Unmapped   |
| Product                | Standard Yield Percent  | EnterpriseAnalytics  | dim_product            | standard_yield_pct     |                                                                 | Unmapped   |
| Product                | Effective Start Date    | EnterpriseAnalytics  | dim_product            | effective_start_date   |                                                                 | Unmapped   |
| Product                | Effective End Date      | EnterpriseAnalytics  | dim_product            | effective_end_date     |                                                                 | Unmapped   |
| Product                | Current Flag            | EnterpriseAnalytics  | dim_product            | current_flag           |                                                                 | Unmapped   |
| Equipment              | Manufacturer            | LexingtonSite        | equipment              | manufacturer           |                                                                 | Unmapped   |
| Equipment              | Model Number            | LexingtonSite        | equipment              | model_number           |                                                                 | Unmapped   |
| Equipment              | Installation Date       | LexingtonSite        | equipment              | install_date           |                                                                 | Unmapped   |
| Equipment              | Calibration Due         | LexingtonSite        | equipment              | calibration_due        |                                                                 | Unmapped   |
| Equipment              | Last Calibrated         | LexingtonSite        | equipment              | last_calibrated        |                                                                 | Unmapped   |
| Equipment              | Equipment Status        | LexingtonSite        | equipment              | status                 |                                                                 | Unmapped   |
| Equipment              | Line ID                 | LexingtonSite        | equipment              | line_id                |                                                                 | Unmapped   |
| Batch                  | Run ID                  | LexingtonSite        | batch_run              | run_id                 |                                                                 | Unmapped   |
| Batch                  | Step Sequence           | LexingtonSite        | batch_run              | step_seq               |                                                                 | Unmapped   |
| Batch                  | Start Timestamp         | LexingtonSite        | batch_run              | start_ts               |                                                                 | Unmapped   |
| Batch                  | End Timestamp           | LexingtonSite        | batch_run              | end_ts                 |                                                                 | Unmapped   |
| Operator               | Operator ID             | LexingtonSite        | batch_run              | operator_id            |                                                                 | Unmapped   |
| Shift Log              | Shift                   | LexingtonSite        | batch_run              | shift                  |                                                                 | Unmapped   |
| Batch                  | Notes                   | LexingtonSite        | batch_run              | notes                  |                                                                 | Unmapped   |
| Process Parameter Reading | Reading ID           | LexingtonSite        | parameter_reading      | reading_id             |                                                                 | Unmapped   |
| Process Parameter Reading | Parameter Code        | LexingtonSite        | parameter_reading      | param_code             |                                                                 | Unmapped   |
| Process Parameter Reading | Reading Timestamp     | LexingtonSite        | parameter_reading      | reading_ts             |                                                                 | Unmapped   |
| Process Parameter Reading | Parameter Value       | LexingtonSite        | parameter_reading      | param_value            |                                                                 | Unmapped   |
| Process Parameter Reading | Unit of Measure       | LexingtonSite        | parameter_reading      | uom                    |                                                                 | Unmapped   |
| Process Parameter Reading | Target Value          | LexingtonSite        | parameter_reading      | target_val             |                                                                 | Unmapped   |
| Process Parameter Reading | Lower Limit           | LexingtonSite        | parameter_reading      | lower_limit            |                                                                 | Unmapped   |
| Process Parameter Reading | Upper Limit           | LexingtonSite        | parameter_reading      | upper_limit            |                                                                 | Unmapped   |
| Process Parameter Reading | In Spec               | LexingtonSite        | parameter_reading      | in_spec                |                                                                 | Unmapped   |
| Process Parameter Reading | Aggregation           | LexingtonSite        | parameter_reading      | aggregation            |                                                                 | Unmapped   |
| Deviation Event          | Deviation ID           | LexingtonSite        | deviation_event        | deviation_id           |                                                                 | Unmapped   |
| Deviation Event          | Batch ID               | LexingtonSite        | deviation_event        | batch_id               |                                                                 | Unmapped   |
| Deviation Event          | Run ID                 | LexingtonSite        | deviation_event        | run_id                 |                                                                 | Unmapped   |
| Deviation Event          | Equipment ID           | LexingtonSite        | deviation_event        | equip_id               |                                                                 | Unmapped   |
| Deviation Event          | Reading ID             | LexingtonSite        | deviation_event        | reading_id             |                                                                 | Unmapped   |
| Deviation Event          | Detected Timestamp     | LexingtonSite        | deviation_event        | detected_ts            |                                                                 | Unmapped   |
| Deviation Event          | Parameter Code         | LexingtonSite        | deviation_event        | param_code             |                                                                 | Unmapped   |
| Deviation Event          | Deviation Description  | LexingtonSite        | deviation_event        | deviation_desc         |                                                                 | Unmapped   |
| Deviation Event          | Severity               | LexingtonSite        | deviation_event        | severity               |                                                                 | Unmapped   |
| Deviation Event          | Deviation Status       | LexingtonSite        | deviation_event        | dev_status             |                                                                 | Unmapped   |
| Deviation Event          | Assigned To            | LexingtonSite        | deviation_event        | assigned_to            |                                                                 | Unmapped   |
| Deviation Event          | Resolved Timestamp     | LexingtonSite        | deviation_event        | resolved_ts            |                                                                 | Unmapped   |
| Deviation Event          | Resolution Notes       | LexingtonSite        | deviation_event        | resolution_notes        |                                                                | Unmapped   |
| Shift Log                | Shift Log ID           | LexingtonSite        | shift_log              | shift_log_id           |                                                                 | Unmapped   |
| Shift Log                | Log Date               | LexingtonSite        | shift_log              | log_date               |                                                                 | Unmapped   |
| Shift Log                | Shift                  | LexingtonSite        | shift_log              | shift                  |                                                                 | Unmapped   |
| Shift Log                | Supervisor ID          | LexingtonSite        | shift_log              | supervisor_id           |                                                                | Unmapped   |
| Shift Log                | Supervisor Name        | LexingtonSite        | shift_log              | supervisor_name          |                                                               | Unmapped   |
| Shift Log                | Active Batches         | LexingtonSite        | shift_log              | active_batches          |                                                                | Unmapped   |
| Shift Log                | Completed Batches      | LexingtonSite        | shift_log              | completed_batches        |                                                               | Unmapped   |
| Shift Log                | New Deviations         | LexingtonSite        | shift_log              | new_deviations          |                                                                | Unmapped   |
| Shift Log                | Equipment Downtime Minutes | LexingtonSite    | shift_log              | equip_downtime_min      |                                                                | Unmapped   |
| Shift Log                | Shift Notes            | LexingtonSite        | shift_log              | shift_notes             |                                                                | Unmapped   |
| Shift Log                | Signed Off             | LexingtonSite        | shift_log              | signed_off              |                                                                | Unmapped   |
| Shift Log                | Signed Off Timestamp   | LexingtonSite        | shift_log              | signed_off_ts           |                                                                | Unmapped   |
