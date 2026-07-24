### Section 1 — Mapping Summary

| Metric | Count |
|---|---|
| Total Canonical Entities identified | 10 |
| Total Canonical Attributes mapped | 21 |
| Confirmed mappings | 17 |
| Inferred mappings | 4 |
| Ambiguous mappings | 0 |
| Unmapped columns | 22 |
| PII-flagged attributes | 0 |

---

### Section 2 — Canonical Mapping Table

| Entity Name | Attribute Name | App Name 1 | Table Name 1 | Column Name 1 | App Name 2 | Table Name 2 | Column Name 2 | Transformation Rule | Status |
|---|---|---|---|---|---|---|---|---|---|
| Facility | Facility ID | Enterprise Analytics Data Mart | dim_facility | facility_id | Lexington Site Operational Data Mart | equipment | equip_id | Extract site prefix from LEX-RCTR-01 using SPLIT_PART('-',1); Map FAC-XXX-NN to LEX-XXX-NN via lookup | Confirmed |
| Facility | Facility Name | Enterprise Analytics Data Mart | dim_facility | facility_name | Lexington Site Operational Data Mart | equipment | equip_name | Direct map; Cast VARCHAR(150) to VARCHAR(150) | Confirmed |
| Facility | City | Enterprise Analytics Data Mart | dim_facility | city | Lexington Site Operational Data Mart | equipment | building | Map city to building via reference table; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | State Region | Enterprise Analytics Data Mart | dim_facility | state_region | Lexington Site Operational Data Mart | equipment | building | Map state_region to building via lookup; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | Country Code | Enterprise Analytics Data Mart | dim_facility | country_code | Lexington Site Operational Data Mart | equipment | building | Map country_code to building country via lookup | Inferred |
| Facility | Timezone Name | Enterprise Analytics Data Mart | dim_facility | timezone_name | Lexington Site Operational Data Mart | equipment | updated_at | Convert updated_at to UTC; Map timezone_name to EST/EDT | Inferred |
| Facility | Effective Start Date | Enterprise Analytics Data Mart | dim_facility | effective_start_date | Lexington Site Operational Data Mart | equipment | install_date | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Effective End Date | Enterprise Analytics Data Mart | dim_facility | effective_end_date | Lexington Site Operational Data Mart | equipment | calibration_due | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Current Flag | Enterprise Analytics Data Mart | dim_facility | current_flag | Lexington Site Operational Data Mart | equipment | status | Map TRUE to 'active', FALSE to 'inactive' | Confirmed |
| Product | Product ID | Enterprise Analytics Data Mart | dim_product | product_id | Lexington Site Operational Data Mart | batch_run | product_code | Direct map; Cast VARCHAR(50) to VARCHAR(50) | Confirmed |
| Product | Product Name | Enterprise Analytics Data Mart | dim_product | product_name | Lexington Site Operational Data Mart | batch_run | step_name | Map step_name to product_name via lookup | Inferred |
| Product | SKU | Enterprise Analytics Data Mart | dim_product | sku | Lexington Site Operational Data Mart | batch_run | product_code | Map SKU to product_code via lookup | Inferred |
| Product | Dosage Form | Enterprise Analytics Data Mart | dim_product | dosage_form | Lexington Site Operational Data Mart | batch_run | step_name | Map dosage_form to step_name via lookup | Inferred |
| Batch | Batch Status | Enterprise Analytics Data Mart | fact_batch_summary | batch_status | Lexington Site Operational Data Mart | batch_run | batch_status | Map ACTIVE/COMPLETED/ON_HOLD/CANCELLED to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Planned Quantity | Enterprise Analytics Data Mart | fact_batch_summary | planned_qty | Lexington Site Operational Data Mart | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | Enterprise Analytics Data Mart | fact_batch_summary | actual_qty | Lexington Site Operational Data Mart | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | Enterprise Analytics Data Mart | fact_batch_summary | qty_unit | Lexington Site Operational Data Mart | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percentage | Enterprise Analytics Data Mart | fact_batch_summary | yield_pct | Lexington Site Operational Data Mart | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Deviation Count | Enterprise Analytics Data Mart | fact_batch_summary | deviation_count | Lexington Site Operational Data Mart | deviation_event | deviation_id | Map deviation_count to deviation_id count; Cast NUMBER to count of VARCHAR | Confirmed |
| Facility | Source Site Code | Enterprise Analytics Data Mart | fact_batch_summary | source_site_code | Lexington Site Operational Data Mart | equipment | line_id | Map site_code to line_id via lookup | Confirmed |
| Facility | Loaded At UTC | Enterprise Analytics Data Mart | fact_batch_summary | loaded_at_utc | Lexington Site Operational Data Mart | equipment | updated_at | Convert updated_at to UTC; Cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |

---

### Section 3 — Canonical Extension Recommendations

| App Name | Table Name | Column Name | Suggested Canonical Entity | Suggested Canonical Attribute | Reason Unmapped |
|---|---|---|---|---|---|
| Enterprise Analytics Data Mart | dim_facility | facility_key | Facility | Facility Key | Internal surrogate key, not required for canonical mapping |
| Enterprise Analytics Data Mart | dim_facility | site_code | Facility | Site Code | Best match score below 40; possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_facility | gmp_certified | Facility | GMP Certified | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_facility | effective_end_date | Facility | Effective End Date | Best match score below 40; possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | product_key | Product | Product Key | Internal surrogate key, not required for canonical mapping |
| Enterprise Analytics Data Mart | dim_product | formulation_id | Product | Formulation ID | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_product | therapeutic_class | Product | Therapeutic Class | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_product | standard_yield_pct | Product | Standard Yield Percentage | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_product | effective_start_date | Product | Effective Start Date | Best match score below 40; possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | effective_end_date | Product | Effective End Date | Best match score below 40; possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_product | current_flag | Product | Current Flag | Best match score below 40; possible manual mapping needed |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_key | Quality Disposition | Disposition Key | Internal surrogate key, not required for canonical mapping |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_code | Quality Disposition | Disposition Code | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_quality_disposition | disposition_name | Quality Disposition | Disposition Name | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_quality_disposition | requires_investigation | Quality Disposition | Requires Investigation | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_quality_disposition | commercially_releasable | Quality Disposition | Commercially Releasable | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_quality_disposition | deviation_implied | Quality Disposition | Deviation Implied | No equivalent column found in other application |
| Enterprise Analytics Data Mart | dim_quality_disposition | description | Quality Disposition | Description | No equivalent column found in other application |
| Enterprise Analytics Data Mart | fact_batch_summary | batch_summary_key | Batch | Batch Summary Key | Internal surrogate key, not required for canonical mapping |
| Enterprise Analytics Data Mart | fact_batch_summary | asset_class | Equipment | Asset Class | No equivalent column found in other application |
| Enterprise Analytics Data Mart | fact_batch_summary | primary_equipment_code | Equipment | Primary Equipment Code | No equivalent column found in other application |
| Enterprise Analytics Data Mart | fact_batch_summary | end_timestamp_utc | Batch | End Timestamp UTC | Best match score below 40; possible manual mapping needed |

---

### Section 4 — Mapping Table

| Entity Name | Attribute Name | Application Name | Table Name | Column Name | Transformation Rule | Status |
|---|---|---|---|---|---|---|
| Facility | Facility ID | Enterprise Analytics Data Mart | dim_facility | facility_id | Extract site prefix from LEX-RCTR-01 using SPLIT_PART('-',1); Map FAC-XXX-NN to LEX-XXX-NN via lookup | Confirmed |
| Facility | Facility ID | Lexington Site Operational Data Mart | equipment | equip_id | Extract site prefix from LEX-RCTR-01 using SPLIT_PART('-',1); Map FAC-XXX-NN to LEX-XXX-NN via lookup | Confirmed |
| Facility | Facility Name | Enterprise Analytics Data Mart | dim_facility | facility_name | Direct map; Cast VARCHAR(150) to VARCHAR(150) | Confirmed |
| Facility | Facility Name | Lexington Site Operational Data Mart | equipment | equip_name | Direct map; Cast VARCHAR(150) to VARCHAR(150) | Confirmed |
| Facility | City | Enterprise Analytics Data Mart | dim_facility | city | Map city to building via reference table; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | City | Lexington Site Operational Data Mart | equipment | building | Map city to building via reference table; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | State Region | Enterprise Analytics Data Mart | dim_facility | state_region | Map state_region to building via lookup; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | State Region | Lexington Site Operational Data Mart | equipment | building | Map state_region to building via lookup; Cast VARCHAR(100) to VARCHAR(50) | Confirmed |
| Facility | Country Code | Enterprise Analytics Data Mart | dim_facility | country_code | Map country_code to building country via lookup | Inferred |
| Facility | Country Code | Lexington Site Operational Data Mart | equipment | building | Map country_code to building country via lookup | Inferred |
| Facility | Timezone Name | Enterprise Analytics Data Mart | dim_facility | timezone_name | Convert updated_at to UTC; Map timezone_name to EST/EDT | Inferred |
| Facility | Timezone Name | Lexington Site Operational Data Mart | equipment | updated_at | Convert updated_at to UTC; Map timezone_name to EST/EDT | Inferred |
| Facility | Effective Start Date | Enterprise Analytics Data Mart | dim_facility | effective_start_date | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Effective Start Date | Lexington Site Operational Data Mart | equipment | install_date | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Effective End Date | Enterprise Analytics Data Mart | dim_facility | effective_end_date | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Effective End Date | Lexington Site Operational Data Mart | equipment | calibration_due | Reformat date from YYYY-MM-DD to ISO 8601 | Confirmed |
| Facility | Current Flag | Enterprise Analytics Data Mart | dim_facility | current_flag | Map TRUE to 'active', FALSE to 'inactive' | Confirmed |
| Facility | Current Flag | Lexington Site Operational Data Mart | equipment | status | Map TRUE to 'active', FALSE to 'inactive' | Confirmed |
| Product | Product ID | Enterprise Analytics Data Mart | dim_product | product_id | Direct map; Cast VARCHAR(50) to VARCHAR(50) | Confirmed |
| Product | Product ID | Lexington Site Operational Data Mart | batch_run | product_code | Direct map; Cast VARCHAR(50) to VARCHAR(50) | Confirmed |
| Product | Product Name | Enterprise Analytics Data Mart | dim_product | product_name | Map step_name to product_name via lookup | Inferred |
| Product | Product Name | Lexington Site Operational Data Mart | batch_run | step_name | Map step_name to product_name via lookup | Inferred |
| Product | SKU | Enterprise Analytics Data Mart | dim_product | sku | Map SKU to product_code via lookup | Inferred |
| Product | SKU | Lexington Site Operational Data Mart | batch_run | product_code | Map SKU to product_code via lookup | Inferred |
| Product | Dosage Form | Enterprise Analytics Data Mart | dim_product | dosage_form | Map dosage_form to step_name via lookup | Inferred |
| Product | Dosage Form | Lexington Site Operational Data Mart | batch_run | step_name | Map dosage_form to step_name via lookup | Inferred |
| Batch | Batch Status | Enterprise Analytics Data Mart | fact_batch_summary | batch_status | Map ACTIVE/COMPLETED/ON_HOLD/CANCELLED to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Batch Status | Lexington Site Operational Data Mart | batch_run | batch_status | Map ACTIVE/COMPLETED/ON_HOLD/CANCELLED to in_prog/completed/on_hold/cancelled via lookup | Confirmed |
| Batch | Planned Quantity | Enterprise Analytics Data Mart | fact_batch_summary | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Planned Quantity | Lexington Site Operational Data Mart | batch_run | planned_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | Enterprise Analytics Data Mart | fact_batch_summary | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Actual Quantity | Lexington Site Operational Data Mart | batch_run | actual_qty | Cast NUMBER(18,3) to NUMERIC(18,3); direct map | Confirmed |
| Batch | Quantity Unit | Enterprise Analytics Data Mart | fact_batch_summary | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Quantity Unit | Lexington Site Operational Data Mart | batch_run | qty_unit | Cast VARCHAR(20) to VARCHAR(20); direct map | Confirmed |
| Batch | Yield Percentage | Enterprise Analytics Data Mart | fact_batch_summary | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Yield Percentage | Lexington Site Operational Data Mart | batch_run | yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); direct map | Confirmed |
| Batch | Deviation Count | Enterprise Analytics Data Mart | fact_batch_summary | deviation_count | Map deviation_count to deviation_id count; Cast NUMBER to count of VARCHAR | Confirmed |
| Batch | Deviation Count | Lexington Site Operational Data Mart | deviation_event | deviation_id | Map deviation_count to deviation_id count; Cast NUMBER to count of VARCHAR | Confirmed |
| Facility | Source Site Code | Enterprise Analytics Data Mart | fact_batch_summary | source_site_code | Map site_code to line_id via lookup | Confirmed |
| Facility | Source Site Code | Lexington Site Operational Data Mart | equipment | line_id | Map site_code to line_id via lookup | Confirmed |
| Facility | Loaded At UTC | Enterprise Analytics Data Mart | fact_batch_summary | loaded_at_utc | Convert updated_at to UTC; Cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Facility | Loaded At UTC | Lexington Site Operational Data Mart | equipment | updated_at | Convert updated_at to UTC; Cast TIMESTAMP to TIMESTAMP_TZ | Confirmed |
| Facility | Facility Key | Enterprise Analytics Data Mart | dim_facility | facility_key |  | Unmapped |
| Facility | Site Code | Enterprise Analytics Data Mart | dim_facility | site_code |  | Unmapped |
| Facility | GMP Certified | Enterprise Analytics Data Mart | dim_facility | gmp_certified |  | Unmapped |
| Facility | Effective End Date | Enterprise Analytics Data Mart | dim_facility | effective_end_date |  | Unmapped |
| Product | Product Key | Enterprise Analytics Data Mart | dim_product | product_key |  | Unmapped |
| Product | Formulation ID | Enterprise Analytics Data Mart | dim_product | formulation_id |  | Unmapped |
| Product | Therapeutic Class | Enterprise Analytics Data Mart | dim_product | therapeutic_class |  | Unmapped |
| Product | Standard Yield Percentage | Enterprise Analytics Data Mart | dim_product | standard_yield_pct |  | Unmapped |
| Product | Effective Start Date | Enterprise Analytics Data Mart | dim_product | effective_start_date |  | Unmapped |
| Product | Effective End Date | Enterprise Analytics Data Mart | dim_product | effective_end_date |  | Unmapped |
| Product | Current Flag | Enterprise Analytics Data Mart | dim_product | current_flag |  | Unmapped |
| Quality Disposition | Disposition Key | Enterprise Analytics Data Mart | dim_quality_disposition | disposition_key |  | Unmapped |
| Quality Disposition | Disposition Code | Enterprise Analytics Data Mart | dim_quality_disposition | disposition_code |  | Unmapped |
| Quality Disposition | Disposition Name | Enterprise Analytics Data Mart | dim_quality_disposition | disposition_name |  | Unmapped |
| Quality Disposition | Requires Investigation | Enterprise Analytics Data Mart | dim_quality_disposition | requires_investigation |  | Unmapped |
| Quality Disposition | Commercially Releasable | Enterprise Analytics Data Mart | dim_quality_disposition | commercially_releasable |  | Unmapped |
| Quality Disposition | Deviation Implied | Enterprise Analytics Data Mart | dim_quality_disposition | deviation_implied |  | Unmapped |
| Quality Disposition | Description | Enterprise Analytics Data Mart | dim_quality_disposition | description |  | Unmapped |
| Batch | Batch Summary Key | Enterprise Analytics Data Mart | fact_batch_summary | batch_summary_key |  | Unmapped |
| Equipment | Asset Class | Enterprise Analytics Data Mart | fact_batch_summary | asset_class |  | Unmapped |
| Equipment | Primary Equipment Code | Enterprise Analytics Data Mart | fact_batch_summary | primary_equipment_code |  | Unmapped |
| Batch | End Timestamp UTC | Enterprise Analytics Data Mart | fact_batch_summary | end_timestamp_utc |  | Unmapped |
