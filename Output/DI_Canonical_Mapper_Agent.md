### Section 1 — Mapping Summary

| Metric | Count |
|---|---|
| Total Canonical Entities identified | 6 |
| Total Canonical Attributes mapped | 19 |
| Confirmed mappings | 16 |
| Inferred mappings | 3 |
| Ambiguous mappings | 0 |
| Unmapped columns | 24 |
| PII-flagged attributes | 0 |

---

### Section 2 — Canonical Mapping Table

| Entity Name | Attribute Name | App Name 1 | Table Name 1 | Column Name 1 | App Name 2 | Table Name 2 | Column Name 2 | Transformation Rule | Status |
|---|---|---|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalyticsDataMart | dim_facility | facility_id | LexingtonSite_DataMart | equipment | equip_id | Map prefix FAC-XXX-NN to LEX-RCTR-XX using regex replace; enforce uniqueness | Confirmed |
| Facility | Facility Name | EnterpriseAnalyticsDataMart | dim_facility | facility_name | LexingtonSite_DataMart | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Asset Class | EnterpriseAnalyticsDataMart | dim_facility | asset_class | LexingtonSite_DataMart | equipment | asset_type | Normalize asset_class to asset_type via lookup table | Confirmed |
| Facility | City | EnterpriseAnalyticsDataMart | dim_facility | city | LexingtonSite_DataMart | equipment | building | Map city to building via reference table; cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | Country Code | EnterpriseAnalyticsDataMart | dim_facility | country_code | LexingtonSite_DataMart | equipment | manufacturer | Map ISO country code to manufacturer country via lookup; cast CHAR(2) to VARCHAR(100) | Inferred |
| Product | Product ID | EnterpriseAnalyticsDataMart | dim_product | product_id | LexingtonSite_DataMart | batch_run | product_code | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product Name | EnterpriseAnalyticsDataMart | dim_product | product_name | LexingtonSite_DataMart | batch_run | step_name | Map product_name to step_name via lookup; cast VARCHAR(150) to VARCHAR(100) | Inferred |
| Product | SKU | EnterpriseAnalyticsDataMart | dim_product | sku | LexingtonSite_DataMart | batch_run | batch_id | Map sku to batch_id via lookup; cast VARCHAR(60) to VARCHAR(50) | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalyticsDataMart | fact_batch_summary | enterprise_batch_id | LexingtonSite_DataMart | batch_run | batch_id | Map enterprise_batch_id to batch_id via regex transform; enforce uniqueness | Confirmed |
| Batch | Facility Key | EnterpriseAnalyticsDataMart | fact_batch_summary | facility_key | LexingtonSite_DataMart | batch_run | equip_id | Cast NUMBER to VARCHAR(30); lookup table for mapping | Confirmed |
| Batch | Product Key | EnterpriseAnalyticsDataMart | fact_batch_summary | product_key | LexingtonSite_DataMart | batch_run | product_code | Cast NUMBER to VARCHAR(50); lookup table for mapping | Confirmed |
| Batch | Batch Status | EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | LexingtonSite_DataMart | batch_run | batch_status | Map ACTIVE/completed/on_hold/cancelled to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | LexingtonSite_DataMart | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | LexingtonSite_DataMart | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | LexingtonSite_DataMart | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percent | EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | LexingtonSite_DataMart | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Deviation | Deviation Count | EnterpriseAnalyticsDataMart | fact_batch_summary | deviation_count | LexingtonSite_DataMart | deviation_event | deviation_id | Map deviation_count to deviation_id via aggregation; cast NUMBER to VARCHAR(50) | Confirmed |
| Batch | Source Site Code | EnterpriseAnalyticsDataMart | fact_batch_summary | source_site_code | LexingtonSite_DataMart | equipment | line_id | Map site_code to line_id via lookup; cast VARCHAR(20) to VARCHAR(30) | Confirmed |
| Batch | Loaded At UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | LexingtonSite_DataMart | equipment | updated_at | Reformat timestamp from UTC to US/Eastern using timezone conversion | Confirmed |

---

### Section 3 — Canonical Extension Recommendations

| App Name | Table Name | Column Name | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped |
|---|---|---|---|---|---|
| EnterpriseAnalyticsDataMart | dim_facility | state_region | Facility | State Region | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_facility | timezone_name | Facility | Timezone Name | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_facility | gmp_certified | Facility | GMP Certified | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_facility | effective_start_date | Facility | Effective Start Date | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_facility | effective_end_date | Facility | Effective End Date | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_facility | current_flag | Facility | Current Flag | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | formulation_id | Product | Formulation ID | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | dosage_form | Product | Dosage Form | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | therapeutic_class | Product | Therapeutic Class | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct | Product | Standard Yield Percent | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | effective_start_date | Product | Effective Start Date | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | effective_end_date | Product | Effective End Date | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_product | current_flag | Product | Current Flag | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_key | Quality Disposition | Disposition Key | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | dim_quality_disposition | loaded_at_utc | Quality Disposition | Loaded At UTC | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | fact_batch_summary | batch_summary_key | Batch | Batch Summary Key | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc | Batch | End Timestamp UTC | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | fact_batch_summary | performance_pct | Batch | Performance Percent | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | fact_batch_summary | quality_pct | Batch | Quality Percent | No equivalent column found in any other application |
| EnterpriseAnalyticsDataMart | fact_batch_summary | oee_pct | Batch | OEE Percent | No equivalent column found in any other application |
| LexingtonSite_DataMart | equipment | model_number | Equipment | Model Number | No equivalent column found in any other application |
| LexingtonSite_DataMart | equipment | calibration_due | Equipment | Calibration Due Date | No equivalent column found in any other application |
| LexingtonSite_DataMart | equipment | last_calibrated | Equipment | Last Calibrated Date | No equivalent column found in any other application |
| LexingtonSite_DataMart | equipment | status | Equipment | Equipment Status | Best match score below 40 — best score: 38 |
| LexingtonSite_DataMart | equipment | line_id | Equipment | Line ID | Best match score below 40 — best score: 34 |
| LexingtonSite_DataMart | equipment | building | Equipment | Building | Best match score below 40 — best score: 36 |
| LexingtonSite_DataMart | equipment | updated_at | Equipment | Updated At | Best match score below 40 — best score: 37 |
| LexingtonSite_DataMart | equipment | manufacturer | Equipment | Manufacturer | Best match score below 40 — best score: 32 |
| LexingtonSite_DataMart | equipment | install_date | Equipment | Install Date | No equivalent column found in any other application |

---

### Section 4 — Mapping Table

| Entity Name | Attribute Name | Application Name | Table Name | Column Name | Transformation Rule | Status |
|---|---|---|---|---|---|---|
| Facility | Facility ID | EnterpriseAnalyticsDataMart | dim_facility | facility_id | Map prefix FAC-XXX-NN to LEX-RCTR-XX using regex replace; enforce uniqueness | Confirmed |
| Facility | Facility ID | LexingtonSite_DataMart | equipment | equip_id | Map prefix FAC-XXX-NN to LEX-RCTR-XX using regex replace; enforce uniqueness | Confirmed |
| Facility | Facility Name | EnterpriseAnalyticsDataMart | dim_facility | facility_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Facility Name | LexingtonSite_DataMart | equipment | equip_name | Cast VARCHAR(150) to VARCHAR(150); direct map | Confirmed |
| Facility | Asset Class | EnterpriseAnalyticsDataMart | dim_facility | asset_class | Normalize asset_class to asset_type via lookup table | Confirmed |
| Facility | Asset Class | LexingtonSite_DataMart | equipment | asset_type | Normalize asset_class to asset_type via lookup table | Confirmed |
| Facility | City | EnterpriseAnalyticsDataMart | dim_facility | city | Map city to building via reference table; cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | City | LexingtonSite_DataMart | equipment | building | Map city to building via reference table; cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | Country Code | EnterpriseAnalyticsDataMart | dim_facility | country_code | Map ISO country code to manufacturer country via lookup; cast CHAR(2) to VARCHAR(100) | Inferred |
| Facility | Country Code | LexingtonSite_DataMart | equipment | manufacturer | Map ISO country code to manufacturer country via lookup; cast CHAR(2) to VARCHAR(100) | Inferred |
| Product | Product ID | EnterpriseAnalyticsDataMart | dim_product | product_id | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product ID | LexingtonSite_DataMart | batch_run | product_code | Cast VARCHAR(50) to VARCHAR(50); direct map | Confirmed |
| Product | Product Name | EnterpriseAnalyticsDataMart | dim_product | product_name | Map product_name to step_name via lookup; cast VARCHAR(150) to VARCHAR(100) | Inferred |
| Product | Product Name | LexingtonSite_DataMart | batch_run | step_name | Map product_name to step_name via lookup; cast VARCHAR(150) to VARCHAR(100) | Inferred |
| Product | SKU | EnterpriseAnalyticsDataMart | dim_product | sku | Map sku to batch_id via lookup; cast VARCHAR(60) to VARCHAR(50) | Inferred |
| Product | SKU | LexingtonSite_DataMart | batch_run | batch_id | Map sku to batch_id via lookup; cast VARCHAR(60) to VARCHAR(50) | Inferred |
| Batch | Enterprise Batch ID | EnterpriseAnalyticsDataMart | fact_batch_summary | enterprise_batch_id | Map enterprise_batch_id to batch_id via regex transform; enforce uniqueness | Confirmed |
| Batch | Enterprise Batch ID | LexingtonSite_DataMart | batch_run | batch_id | Map enterprise_batch_id to batch_id via regex transform; enforce uniqueness | Confirmed |
| Batch | Facility Key | EnterpriseAnalyticsDataMart | fact_batch_summary | facility_key | Cast NUMBER to VARCHAR(30); lookup table for mapping | Confirmed |
| Batch | Facility Key | LexingtonSite_DataMart | batch_run | equip_id | Cast NUMBER to VARCHAR(30); lookup table for mapping | Confirmed |
| Batch | Product Key | EnterpriseAnalyticsDataMart | fact_batch_summary | product_key | Cast NUMBER to VARCHAR(50); lookup table for mapping | Confirmed |
| Batch | Product Key | LexingtonSite_DataMart | batch_run | product_code | Cast NUMBER to VARCHAR(50); lookup table for mapping | Confirmed |
| Batch | Batch Status | EnterpriseAnalyticsDataMart | fact_batch_summary | batch_status | Map ACTIVE/completed/on_hold/cancelled to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Batch Status | LexingtonSite_DataMart | batch_run | batch_status | Map ACTIVE/completed/on_hold/cancelled to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Planned Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Planned Quantity | LexingtonSite_DataMart | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | EnterpriseAnalyticsDataMart | fact_batch_summary | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | LexingtonSite_DataMart | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | EnterpriseAnalyticsDataMart | fact_batch_summary | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Quantity Unit | LexingtonSite_DataMart | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percent | EnterpriseAnalyticsDataMart | fact_batch_summary | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Yield Percent | LexingtonSite_DataMart | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Deviation | Deviation Count | EnterpriseAnalyticsDataMart | fact_batch_summary | deviation_count | Map deviation_count to deviation_id via aggregation; cast NUMBER to VARCHAR(50) | Confirmed |
| Deviation | Deviation Count | LexingtonSite_DataMart | deviation_event | deviation_id | Map deviation_count to deviation_id via aggregation; cast NUMBER to VARCHAR(50) | Confirmed |
| Batch | Source Site Code | EnterpriseAnalyticsDataMart | fact_batch_summary | source_site_code | Map site_code to line_id via lookup; cast VARCHAR(20) to VARCHAR(30) | Confirmed |
| Batch | Source Site Code | LexingtonSite_DataMart | equipment | line_id | Map site_code to line_id via lookup; cast VARCHAR(20) to VARCHAR(30) | Confirmed |
| Batch | Loaded At UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | loaded_at_utc | Reformat timestamp from UTC to US/Eastern using timezone conversion | Confirmed |
| Batch | Loaded At UTC | LexingtonSite_DataMart | equipment | updated_at | Reformat timestamp from UTC to US/Eastern using timezone conversion | Confirmed |
| Facility | State Region | EnterpriseAnalyticsDataMart | dim_facility | state_region |  | Unmapped |
| Facility | Timezone Name | EnterpriseAnalyticsDataMart | dim_facility | timezone_name |  | Unmapped |
| Facility | GMP Certified | EnterpriseAnalyticsDataMart | dim_facility | gmp_certified |  | Unmapped |
| Facility | Effective Start Date | EnterpriseAnalyticsDataMart | dim_facility | effective_start_date |  | Unmapped |
| Facility | Effective End Date | EnterpriseAnalyticsDataMart | dim_facility | effective_end_date |  | Unmapped |
| Facility | Current Flag | EnterpriseAnalyticsDataMart | dim_facility | current_flag |  | Unmapped |
| Product | Formulation ID | EnterpriseAnalyticsDataMart | dim_product | formulation_id |  | Unmapped |
| Product | Dosage Form | EnterpriseAnalyticsDataMart | dim_product | dosage_form |  | Unmapped |
| Product | Therapeutic Class | EnterpriseAnalyticsDataMart | dim_product | therapeutic_class |  | Unmapped |
| Product | Standard Yield Percent | EnterpriseAnalyticsDataMart | dim_product | standard_yield_pct |  | Unmapped |
| Product | Effective Start Date | EnterpriseAnalyticsDataMart | dim_product | effective_start_date |  | Unmapped |
| Product | Effective End Date | EnterpriseAnalyticsDataMart | dim_product | effective_end_date |  | Unmapped |
| Product | Current Flag | EnterpriseAnalyticsDataMart | dim_product | current_flag |  | Unmapped |
| Quality Disposition | Disposition Key | EnterpriseAnalyticsDataMart | dim_quality_disposition | disposition_key |  | Unmapped |
| Quality Disposition | Loaded At UTC | EnterpriseAnalyticsDataMart | dim_quality_disposition | loaded_at_utc |  | Unmapped |
| Batch | Batch Summary Key | EnterpriseAnalyticsDataMart | fact_batch_summary | batch_summary_key |  | Unmapped |
| Batch | End Timestamp UTC | EnterpriseAnalyticsDataMart | fact_batch_summary | end_timestamp_utc |  | Unmapped |
| Batch | Performance Percent | EnterpriseAnalyticsDataMart | fact_batch_summary | performance_pct |  | Unmapped |
| Batch | Quality Percent | EnterpriseAnalyticsDataMart | fact_batch_summary | quality_pct |  | Unmapped |
| Batch | OEE Percent | EnterpriseAnalyticsDataMart | fact_batch_summary | oee_pct |  | Unmapped |
| Equipment | Model Number | LexingtonSite_DataMart | equipment | model_number |  | Unmapped |
| Equipment | Calibration Due Date | LexingtonSite_DataMart | equipment | calibration_due |  | Unmapped |
| Equipment | Last Calibrated Date | LexingtonSite_DataMart | equipment | last_calibrated |  | Unmapped |
| Equipment | Equipment Status | LexingtonSite_DataMart | equipment | status |  | Unmapped |
| Equipment | Line ID | LexingtonSite_DataMart | equipment | line_id |  | Unmapped |
| Equipment | Building | LexingtonSite_DataMart | equipment | building |  | Unmapped |
| Equipment | Updated At | LexingtonSite_DataMart | equipment | updated_at |  | Unmapped |
| Equipment | Manufacturer | LexingtonSite_DataMart | equipment | manufacturer |  | Unmapped |
| Equipment | Install Date | LexingtonSite_DataMart | equipment | install_date |  | Unmapped |
