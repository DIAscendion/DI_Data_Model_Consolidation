# Canonical Data Mapping — Pharma Manufacturing Data Consolidation

## Section 1 — Mapping Summary

| Metric                               | Count |
|--------------------------------------|-------|
| Total Canonical Entities identified   | 8     |
| Total Canonical Attributes mapped     | 21    |
| Confirmed mappings                   | 13    |
| Inferred mappings                    | 8     |
| Ambiguous mappings                   | 0     |
| Unmapped columns                     | 38    |
| PII-flagged attributes               | 0     |

## Section 2 — Canonical Mapping Table

| Entity Name     | Attribute Name         | App Name 1         | Table Name 1           | Column Name 1           | App Name 2      | Table Name 2     | Column Name 2      | Transformation Rule                                                      | Status     |
|----------------|-----------------------|--------------------|------------------------|-------------------------|-----------------|------------------|--------------------|--------------------------------------------------------------------------|------------|
| Facility        | Facility ID           | EnterpriseAnalytics| dim_facility           | facility_id             | LexingtonSite   | equipment         | equip_id           | Map site prefix; cast VARCHAR; enforce uniqueness                        | Confirmed  |
| Facility        | Facility Name         | EnterpriseAnalytics| dim_facility           | facility_name           | LexingtonSite   | equipment         | equip_name          | Direct map; truncate/pad as needed                                       | Confirmed  |
| Facility        | Site Code             | EnterpriseAnalytics| dim_facility           | site_code               | LexingtonSite   | equipment         | line_id             | Map site code to line_id via lookup table                                | Confirmed  |
| Facility        | Location (City/Building)| EnterpriseAnalytics| dim_facility         | city                    | LexingtonSite   | equipment         | building            | Concatenate city/building for canonical location                         | Inferred   |
| Facility        | Country Code          | EnterpriseAnalytics| dim_facility           | country_code            | LexingtonSite   | equipment         | manufacturer         | Map country_code to manufacturer; review for business logic               | Inferred   |
| Facility        | Timezone Name         | EnterpriseAnalytics| dim_facility           | timezone_name           | LexingtonSite   | equipment         | updated_at           | Convert updated_at timestamp to timezone_name; extract TZ info            | Inferred   |
| Product         | Product ID            | EnterpriseAnalytics| dim_product            | product_id              | LexingtonSite   | batch_run         | product_code         | Direct map; cast VARCHAR; enforce NOT NULL                                | Confirmed  |
| Product         | Product Name          | EnterpriseAnalytics| dim_product            | product_name            | LexingtonSite   | batch_run         | step_name            | Map step_name to product_name via lookup; review with business            | Inferred   |
| Product         | SKU                   | EnterpriseAnalytics| dim_product            | sku                     | LexingtonSite   | batch_run         | batch_id             | Map SKU code to batch_id; review for business logic                       | Inferred   |
| Product         | Dosage Form           | EnterpriseAnalytics| dim_product            | dosage_form             | LexingtonSite   | batch_run         | notes                | Extract dosage form from notes using regex pattern                        | Inferred   |
| Product         | Therapeutic Class     | EnterpriseAnalytics| dim_product            | therapeutic_class        | LexingtonSite   | batch_run         | shift                 | Map therapeutic_class to shift via lookup; review with business           | Inferred   |
| Quality Disposition | Disposition Code   | EnterpriseAnalytics| dim_quality_disposition| disposition_code         | LexingtonSite   | batch_run         | batch_status          | Map status codes via lookup table; enforce VARCHAR(30)                    | Confirmed  |
| Quality Disposition | Disposition Name   | EnterpriseAnalytics| dim_quality_disposition| disposition_name         | LexingtonSite   | batch_run         | batch_status          | Map disposition_name to batch_status; review with business                | Confirmed  |
| Quality Disposition | Commercially Releasable | EnterpriseAnalytics| dim_quality_disposition| commercially_releasable | LexingtonSite   | batch_run         | batch_status          | Map TRUE/FALSE to batch_status values (completed/active)                  | Confirmed  |
| Quality Disposition | Deviation Implied  | EnterpriseAnalytics| dim_quality_disposition| deviation_implied        | LexingtonSite   | deviation_event   | severity              | Map deviation_implied to severity via lookup; review with business        | Inferred   |
| Batch Summary   | Enterprise Batch ID   | EnterpriseAnalytics| fact_batch_summary     | enterprise_batch_id      | LexingtonSite   | batch_run         | batch_id              | Reformat batch_id to enterprise_batch_id (regex transform)                | Confirmed  |
| Batch Summary   | Facility Key          | EnterpriseAnalytics| fact_batch_summary     | facility_key             | LexingtonSite   | batch_run         | equip_id              | Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR          | Confirmed  |
| Batch Summary   | Product Key           | EnterpriseAnalytics| fact_batch_summary     | product_key              | LexingtonSite   | batch_run         | product_code           | Map product_key to product_code via lookup; enforce INTEGER/VARCHAR       | Confirmed  |
| Batch Summary   | Batch Status          | EnterpriseAnalytics| fact_batch_summary     | batch_status             | LexingtonSite   | batch_run         | batch_status           | Direct map; enforce VARCHAR(30); validate values                          | Confirmed  |
| Batch Summary   | Planned Quantity      | EnterpriseAnalytics| fact_batch_summary     | planned_qty              | LexingtonSite   | batch_run         | planned_qty            | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Actual Quantity       | EnterpriseAnalytics| fact_batch_summary     | actual_qty               | LexingtonSite   | batch_run         | actual_qty             | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Quantity Unit         | EnterpriseAnalytics| fact_batch_summary     | qty_unit                 | LexingtonSite   | batch_run         | qty_unit               | Direct map; cast VARCHAR(20); validate values                             | Confirmed  |

## Section 3 — Canonical Extension Recommendations

| App Name           | Table Name           | Column Name             | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped                                      |
|--------------------|---------------------|-------------------------|---------------------------|------------------------------|------------------------------------------------------|
| EnterpriseAnalytics| dim_facility        | state_region            | Facility                  | State/Region                 | No equivalent found in other application             |
| EnterpriseAnalytics| dim_facility        | gmp_certified           | Facility                  | GMP Certified                | No equivalent found in other application             |
| EnterpriseAnalytics| dim_facility        | effective_start_date    | Facility                  | Effective Start Date          | No equivalent found in other application             |
| EnterpriseAnalytics| dim_facility        | effective_end_date      | Facility                  | Effective End Date            | No equivalent found in other application             |
| EnterpriseAnalytics| dim_facility        | current_flag            | Facility                  | Current Flag                  | No equivalent found in other application             |
| EnterpriseAnalytics| dim_product         | formulation_id          | Product                   | Formulation ID                | No equivalent found in other application             |
| EnterpriseAnalytics| dim_product         | standard_yield_pct      | Product                   | Standard Yield Percent        | No equivalent found in other application             |
| EnterpriseAnalytics| dim_product         | effective_start_date    | Product                   | Effective Start Date          | No equivalent found in other application             |
| EnterpriseAnalytics| dim_product         | effective_end_date      | Product                   | Effective End Date            | No equivalent found in other application             |
| EnterpriseAnalytics| dim_product         | current_flag            | Product                   | Current Flag                  | No equivalent found in other application             |
| EnterpriseAnalytics| dim_quality_disposition | requires_investigation | Quality Disposition       | Requires Investigation        | No equivalent found in other application             |
| EnterpriseAnalytics| dim_quality_disposition | description           | Quality Disposition       | Description                   | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | disposition_key         | Quality Disposition       | Disposition Key               | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | asset_class             | Equipment                 | Asset Class                   | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | primary_equipment_code  | Equipment                 | Primary Equipment Code        | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | start_timestamp_utc     | Batch Summary             | Start Timestamp UTC           | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | end_timestamp_utc       | Batch Summary             | End Timestamp UTC             | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | deviation_count         | Batch Summary             | Deviation Count               | No equivalent found in other application             |
| EnterpriseAnalytics| fact_batch_summary  | source_site_code        | Facility                  | Source Site Code              | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | analysis_date           | Yield Analytics           | Analysis Date                 | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | batch_count             | Yield Analytics           | Batch Count                   | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | avg_yield_pct           | Yield Analytics           | Average Yield Percent         | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | min_yield_pct           | Yield Analytics           | Minimum Yield Percent         | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | max_yield_pct           | Yield Analytics           | Maximum Yield Percent         | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | std_yield_pct           | Yield Analytics           | Std Dev Yield Percent         | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | below_target_count      | Yield Analytics           | Below Target Count            | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | total_planned_qty       | Yield Analytics           | Total Planned Quantity        | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | total_actual_qty        | Yield Analytics           | Total Actual Quantity         | No equivalent found in other application             |
| EnterpriseAnalytics| fact_yield_analysis | qty_unit                | Yield Analytics           | Quantity Unit                 | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | equipment           | manufacturer            | Equipment                 | Manufacturer                  | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | equipment           | model_number            | Equipment                 | Model Number                  | No equivalent found in other application             |
| LexingtonSite      | equipment           | install_date            | Equipment                 | Install Date                  | No equivalent found in other application             |
| LexingtonSite      | equipment           | calibration_due         | Equipment                 | Calibration Due Date           | No equivalent found in other application             |
| LexingtonSite      | equipment           | last_calibrated         | Equipment                 | Last Calibrated Date           | No equivalent found in other application             |
| LexingtonSite      | equipment           | status                  | Equipment                 | Status                        | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | equipment           | building                | Facility                  | Building                      | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | equipment           | updated_at              | Facility                  | Updated At                    | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | batch_run           | run_id                  | Batch Summary             | Run ID                        | No equivalent found in other application             |
| LexingtonSite      | batch_run           | step_seq                | Batch Summary             | Step Sequence                 | No equivalent found in other application             |
| LexingtonSite      | batch_run           | operator_id             | Workforce                 | Operator ID                   | No equivalent found in other application             |
| LexingtonSite      | batch_run           | shift                   | Batch Summary             | Shift                         | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | batch_run           | notes                   | Batch Summary             | Notes                         | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | batch_run           | created_at              | Batch Summary             | Created At                    | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | reading_id              | Process Parameter         | Reading ID                    | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | param_code              | Process Parameter         | Parameter Code                | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | reading_ts              | Process Parameter         | Reading Timestamp             | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | param_value             | Process Parameter         | Parameter Value               | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | uom                     | Process Parameter         | Unit of Measure               | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | target_val              | Process Parameter         | Target Value                  | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | lower_limit             | Process Parameter         | Lower Limit                   | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | upper_limit             | Process Parameter         | Upper Limit                   | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | in_spec                 | Process Parameter         | In Spec                       | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | aggregation             | Process Parameter         | Aggregation Type              | No equivalent found in other application             |
| LexingtonSite      | parameter_reading   | ingested_at             | Process Parameter         | Ingested At                   | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | deviation_id            | Quality Event             | Deviation ID                  | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | detected_ts             | Quality Event             | Detected Timestamp            | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | deviation_desc          | Quality Event             | Deviation Description         | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | severity                | Quality Event             | Severity                      | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | deviation_event     | dev_status              | Quality Event             | Deviation Status              | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | assigned_to             | Quality Event             | Assigned To                   | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | resolved_ts             | Quality Event             | Resolved Timestamp            | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | resolution_notes        | Quality Event             | Resolution Notes              | No equivalent found in other application             |
| LexingtonSite      | deviation_event     | created_at              | Quality Event             | Created At                    | No equivalent found in other application             |
| LexingtonSite      | shift_log           | shift_log_id            | Shift Log                | Shift Log ID                  | No equivalent found in other application             |
| LexingtonSite      | shift_log           | log_date                | Shift Log                | Log Date                      | No equivalent found in other application             |
| LexingtonSite      | shift_log           | shift                   | Shift Log                | Shift Name                    | Best match score below 40 — possible manual mapping   |
| LexingtonSite      | shift_log           | supervisor_id           | Shift Log                | Supervisor ID                 | No equivalent found in other application             |
| LexingtonSite      | shift_log           | supervisor_name         | Shift Log                | Supervisor Name               | No equivalent found in other application             |
| LexingtonSite      | shift_log           | active_batches          | Shift Log                | Active Batches                | No equivalent found in other application             |
| LexingtonSite      | shift_log           | completed_batches       | Shift Log                | Completed Batches             | No equivalent found in other application             |
| LexingtonSite      | shift_log           | new_deviations          | Shift Log                | New Deviations                | No equivalent found in other application             |
| LexingtonSite      | shift_log           | equip_downtime_min      | Shift Log                | Equipment Downtime Minutes    | No equivalent found in other application             |
| LexingtonSite      | shift_log           | shift_notes             | Shift Log                | Shift Notes                   | No equivalent found in other application             |
| LexingtonSite      | shift_log           | signed_off              | Shift Log                | Signed Off                    | No equivalent found in other application             |
| LexingtonSite      | shift_log           | signed_off_ts           | Shift Log                | Signed Off Timestamp          | No equivalent found in other application             |
| LexingtonSite      | shift_log           | created_at              | Shift Log                | Created At                    | No equivalent found in other application             |

## Section 4 — Mapping Table (Per-Column Audit)

| Entity Name     | Attribute Name         | Application Name      | Table Name               | Column Name             | Transformation Rule                                                      | Status     |
|----------------|-----------------------|----------------------|--------------------------|-------------------------|--------------------------------------------------------------------------|------------|
| Facility        | Facility ID           | EnterpriseAnalytics   | dim_facility             | facility_id             | Map site prefix; cast VARCHAR; enforce uniqueness                        | Confirmed  |
| Facility        | Facility ID           | LexingtonSite         | equipment                | equip_id                | Map site prefix; cast VARCHAR; enforce uniqueness                        | Confirmed  |
| Facility        | Facility Name         | EnterpriseAnalytics   | dim_facility             | facility_name           | Direct map; truncate/pad as needed                                       | Confirmed  |
| Facility        | Facility Name         | LexingtonSite         | equipment                | equip_name              | Direct map; truncate/pad as needed                                       | Confirmed  |
| Facility        | Site Code             | EnterpriseAnalytics   | dim_facility             | site_code               | Map site code to line_id via lookup table                                | Confirmed  |
| Facility        | Site Code             | LexingtonSite         | equipment                | line_id                 | Map site code to line_id via lookup table                                | Confirmed  |
| Facility        | Location (City/Building)| EnterpriseAnalytics | dim_facility             | city                    | Concatenate city/building for canonical location                         | Inferred   |
| Facility        | Location (City/Building)| LexingtonSite        | equipment                | building                | Concatenate city/building for canonical location                         | Inferred   |
| Facility        | Country Code          | EnterpriseAnalytics   | dim_facility             | country_code            | Map country_code to manufacturer; review for business logic               | Inferred   |
| Facility        | Country Code          | LexingtonSite         | equipment                | manufacturer            | Map country_code to manufacturer; review for business logic               | Inferred   |
| Facility        | Timezone Name         | EnterpriseAnalytics   | dim_facility             | timezone_name           | Convert updated_at timestamp to timezone_name; extract TZ info            | Inferred   |
| Facility        | Timezone Name         | LexingtonSite         | equipment                | updated_at              | Convert updated_at timestamp to timezone_name; extract TZ info            | Inferred   |
| Product         | Product ID            | EnterpriseAnalytics   | dim_product              | product_id              | Direct map; cast VARCHAR; enforce NOT NULL                                | Confirmed  |
| Product         | Product ID            | LexingtonSite         | batch_run                | product_code            | Direct map; cast VARCHAR; enforce NOT NULL                                | Confirmed  |
| Product         | Product Name          | EnterpriseAnalytics   | dim_product              | product_name            | Map step_name to product_name via lookup; review with business            | Inferred   |
| Product         | Product Name          | LexingtonSite         | batch_run                | step_name               | Map step_name to product_name via lookup; review with business            | Inferred   |
| Product         | SKU                   | EnterpriseAnalytics   | dim_product              | sku                     | Map SKU code to batch_id; review for business logic                       | Inferred   |
| Product         | SKU                   | LexingtonSite         | batch_run                | batch_id                | Map SKU code to batch_id; review for business logic                       | Inferred   |
| Product         | Dosage Form           | EnterpriseAnalytics   | dim_product              | dosage_form             | Extract dosage form from notes using regex pattern                        | Inferred   |
| Product         | Dosage Form           | LexingtonSite         | batch_run                | notes                   | Extract dosage form from notes using regex pattern                        | Inferred   |
| Product         | Therapeutic Class     | EnterpriseAnalytics   | dim_product              | therapeutic_class        | Map therapeutic_class to shift via lookup; review with business           | Inferred   |
| Product         | Therapeutic Class     | LexingtonSite         | batch_run                | shift                   | Map therapeutic_class to shift via lookup; review with business           | Inferred   |
| Quality Disposition | Disposition Code   | EnterpriseAnalytics   | dim_quality_disposition  | disposition_code         | Map status codes via lookup table; enforce VARCHAR(30)                    | Confirmed  |
| Quality Disposition | Disposition Code   | LexingtonSite         | batch_run                | batch_status            | Map status codes via lookup table; enforce VARCHAR(30)                    | Confirmed  |
| Quality Disposition | Disposition Name   | EnterpriseAnalytics   | dim_quality_disposition  | disposition_name         | Map disposition_name to batch_status; review with business                | Confirmed  |
| Quality Disposition | Disposition Name   | LexingtonSite         | batch_run                | batch_status            | Map disposition_name to batch_status; review with business                | Confirmed  |
| Quality Disposition | Commercially Releasable | EnterpriseAnalytics| dim_quality_disposition  | commercially_releasable | Map TRUE/FALSE to batch_status values (completed/active)                  | Confirmed  |
| Quality Disposition | Commercially Releasable | LexingtonSite      | batch_run                | batch_status            | Map TRUE/FALSE to batch_status values (completed/active)                  | Confirmed  |
| Quality Disposition | Deviation Implied  | EnterpriseAnalytics   | dim_quality_disposition  | deviation_implied        | Map deviation_implied to severity via lookup; review with business        | Inferred   |
| Quality Disposition | Deviation Implied  | LexingtonSite         | deviation_event          | severity                 | Map deviation_implied to severity via lookup; review with business        | Inferred   |
| Batch Summary   | Enterprise Batch ID   | EnterpriseAnalytics   | fact_batch_summary       | enterprise_batch_id      | Reformat batch_id to enterprise_batch_id (regex transform)                | Confirmed  |
| Batch Summary   | Enterprise Batch ID   | LexingtonSite         | batch_run                | batch_id                 | Reformat batch_id to enterprise_batch_id (regex transform)                | Confirmed  |
| Batch Summary   | Facility Key          | EnterpriseAnalytics   | fact_batch_summary       | facility_key             | Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR          | Confirmed  |
| Batch Summary   | Facility Key          | LexingtonSite         | batch_run                | equip_id                 | Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR          | Confirmed  |
| Batch Summary   | Product Key           | EnterpriseAnalytics   | fact_batch_summary       | product_key              | Map product_key to product_code via lookup; enforce INTEGER/VARCHAR       | Confirmed  |
| Batch Summary   | Product Key           | LexingtonSite         | batch_run                | product_code             | Map product_key to product_code via lookup; enforce INTEGER/VARCHAR       | Confirmed  |
| Batch Summary   | Batch Status          | EnterpriseAnalytics   | fact_batch_summary       | batch_status             | Direct map; enforce VARCHAR(30); validate values                          | Confirmed  |
| Batch Summary   | Batch Status          | LexingtonSite         | batch_run                | batch_status             | Direct map; enforce VARCHAR(30); validate values                          | Confirmed  |
| Batch Summary   | Planned Quantity      | EnterpriseAnalytics   | fact_batch_summary       | planned_qty              | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Planned Quantity      | LexingtonSite         | batch_run                | planned_qty              | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Actual Quantity       | EnterpriseAnalytics   | fact_batch_summary       | actual_qty               | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Actual Quantity       | LexingtonSite         | batch_run                | actual_qty               | Direct map; cast NUMERIC(18,3); enforce NOT NULL                          | Confirmed  |
| Batch Summary   | Quantity Unit         | EnterpriseAnalytics   | fact_batch_summary       | qty_unit                 | Direct map; cast VARCHAR(20); validate values                             | Confirmed  |
| Batch Summary   | Quantity Unit         | LexingtonSite         | batch_run                | qty_unit                 | Direct map; cast VARCHAR(20); validate values                             | Confirmed  |

<!-- End of Canonical Mapping Output -->
