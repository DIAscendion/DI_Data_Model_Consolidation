### Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 21 |
| Meaningful transformation rules | 21 / 100% |
| Aligned with inputs | 11 / 52.4% |
| Rows passing both checks | 11 / 52.4% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | Fail |

---

### Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Facility ID | Enterprise Analytics Data Mart.dim_facility.facility_id; Lexington Site Operational Data Mart.equipment.equip_id | "Extract site prefix from LEX-RCTR-01 using SPLIT_PART('-',1); Map FAC-XXX-NN to LEX-XXX-NN via lookup" | Alignment failure | Rule references parsing a sample value (LEX-RCTR-01) and a FAC→LEX pattern lookup, but the row’s inputs are generic column names with no stated format/pattern. Also unclear which input column the SPLIT_PART applies to and whether both sources follow the same pattern. |
| Facility.City | Enterprise Analytics Data Mart.dim_facility.city; Lexington Site Operational Data Mart.equipment.building | "Map city to building via reference table; Cast VARCHAR(100) to VARCHAR(50)" | Alignment failure | City-to-building mapping is not supported by any stated equivalence; “building” is not described as city. The cast details (VARCHAR(100)→VARCHAR(50)) are not justified by any provided source data type/length metadata. |
| Facility.State Region | Enterprise Analytics Data Mart.dim_facility.state_region; Lexington Site Operational Data Mart.equipment.building | "Map state_region to building via lookup; Cast VARCHAR(100) to VARCHAR(50)" | Alignment failure | State/region-to-building mapping is not supported by the stated inputs; building is not described as a state/region. Cast details are not supported by any stated type metadata. |
| Facility.Country Code | Enterprise Analytics Data Mart.dim_facility.country_code; Lexington Site Operational Data Mart.equipment.building | "Map country_code to building country via lookup" | Alignment failure | Mapping a country code from/to “building” is not supported by the stated inputs; no “building country” source column is listed. Lookup logic is introduced without any stated key/join condition in the row. |
| Facility.Timezone Name | Enterprise Analytics Data Mart.dim_facility.timezone_name; Lexington Site Operational Data Mart.equipment.updated_at | "Convert updated_at to UTC; Map timezone_name to EST/EDT" | Both (Meaningfulness + Alignment) | Two separate operations are asserted but do not align with the listed sources: (1) updated_at→UTC conversion does not produce a timezone name; (2) mapping timezone_name→EST/EDT is vague (no mapping table/criteria) and unrelated to updated_at. The rule does not explain how these two inputs combine to produce a single canonical attribute “Timezone Name.” |
| Facility.Effective Start Date | Enterprise Analytics Data Mart.dim_facility.effective_start_date; Lexington Site Operational Data Mart.equipment.install_date | "Reformat date from YYYY-MM-DD to ISO 8601" | Alignment failure | YYYY-MM-DD is already an ISO 8601 date representation (YYYY-MM-DD). Without stated source types/formats, the rule is redundant/unclear and does not specify whether time components/time zones exist or what exact output type is required. |
| Facility.Effective End Date | Enterprise Analytics Data Mart.dim_facility.effective_end_date; Lexington Site Operational Data Mart.equipment.calibration_due | "Reformat date from YYYY-MM-DD to ISO 8601" | Alignment failure | Same issue as above; also, calibration_due is not stated to be an end-date equivalent for facility effectiveness, so the semantic alignment is not supported by the inputs shown in the row. |
| Facility.Current Flag | Enterprise Analytics Data Mart.dim_facility.current_flag; Lexington Site Operational Data Mart.equipment.status | "Map TRUE to 'active', FALSE to 'inactive'" | Alignment failure | Rule assumes boolean TRUE/FALSE inputs, but one source is named “status,” which typically indicates a status code/string. The rule does not specify how non-boolean status values map, nor whether current_flag is boolean/string. |
| Product.Product Name | Enterprise Analytics Data Mart.dim_product.product_name; Lexington Site Operational Data Mart.batch_run.step_name | "Map step_name to product_name via lookup" | Alignment failure | Lookup transformation is asserted with no stated key/join criteria. Also, mapping step_name to product_name is not supported by input semantics; the row provides no evidence that step_name represents product name. |
| Product.SKU | Enterprise Analytics Data Mart.dim_product.sku; Lexington Site Operational Data Mart.batch_run.product_code | "Map SKU to product_code via lookup" | Alignment failure | If sku and product_code are equivalent identifiers, “lookup” may be unnecessary; if they differ, the lookup requires explicit definition (keys, reference table). Row provides no supporting metadata to justify the lookup. |
| Product.Dosage Form | Enterprise Analytics Data Mart.dim_product.dosage_form; Lexington Site Operational Data Mart.batch_run.step_name | "Map dosage_form to step_name via lookup" | Alignment failure | Dosage form mapping from/to step_name is not supported by the stated inputs. Lookup is not defined (no mapping table/logic). |
| Batch.Batch Status | Enterprise Analytics Data Mart.fact_batch_summary.batch_status; Lexington Site Operational Data Mart.batch_run.batch_status | "Map ACTIVE/COMPLETED/ON_HOLD/CANCELLED to in_prog/completed/on_hold/cancelled via lookup" | Alignment failure | A “lookup” is referenced but the mapping is explicitly enumerated in the rule; calling it a lookup is ambiguous. Also, it does not define handling for unexpected/new status values (default/exception). |
| Batch.Planned Quantity | Enterprise Analytics Data Mart.fact_batch_summary.planned_qty; Lexington Site Operational Data Mart.batch_run.planned_qty | "Cast NUMBER(18,3) to NUMERIC(18,3); direct map" | Alignment failure | Specific source/target types (NUMBER vs NUMERIC) are stated without any DDL/type evidence in the row. If types are already compatible, cast is redundant; if they differ, the rule should specify which system uses which type and define rounding/overflow handling. |
| Batch.Actual Quantity | Enterprise Analytics Data Mart.fact_batch_summary.actual_qty; Lexington Site Operational Data Mart.batch_run.actual_qty | "Cast NUMBER(18,3) to NUMERIC(18,3); direct map" | Alignment failure | Same as planned_qty—type assertions are not supported by the row’s stated inputs; no rounding/precision overflow guidance. |
| Batch.Quantity Unit | Enterprise Analytics Data Mart.fact_batch_summary.qty_unit; Lexington Site Operational Data Mart.batch_run.qty_unit | "Cast VARCHAR(20) to VARCHAR(20); direct map" | Alignment failure | Casting VARCHAR(20) to VARCHAR(20) is a no-op and provides no implementable value. If normalization is needed (e.g., KG vs kg), rule should specify it; if not needed, “Direct 1:1 map” is sufficient. |
| Batch.Yield Percentage | Enterprise Analytics Data Mart.fact_batch_summary.yield_pct; Lexington Site Operational Data Mart.batch_run.yield_pct | "Cast NUMBER(6,3) to NUMERIC(6,3); direct map" | Alignment failure | Same type-evidence issue as quantity casts; also lacks guidance on acceptable range (0–100 vs 0–1) if those differ (not stated). |
| Batch.Deviation Count | Enterprise Analytics Data Mart.fact_batch_summary.deviation_count; Lexington Site Operational Data Mart.deviation_event.deviation_id | "Map deviation_count to deviation_id count; Cast NUMBER to count of VARCHAR" | Both (Meaningfulness + Alignment) | “Cast NUMBER to count of VARCHAR” is not implementable as written. The rule implies an aggregation (COUNT of deviation_id) but does not specify grouping keys (e.g., by batch_id) required to compute a count. Also unclear why deviation_count would map from a deviation_id column without join context. |
| Facility.Source Site Code | Enterprise Analytics Data Mart.fact_batch_summary.source_site_code; Lexington Site Operational Data Mart.equipment.line_id | "Map site_code to line_id via lookup" | Alignment failure | Lookup is asserted without a defined mapping table/key. Also, source attribute is “source_site_code” but the rule mentions “site_code,” introducing a naming inconsistency. No evidence that line_id represents a site code. |
| Facility.Loaded At UTC | Enterprise Analytics Data Mart.fact_batch_summary.loaded_at_utc; Lexington Site Operational Data Mart.equipment.updated_at | "Convert updated_at to UTC; Cast TIMESTAMP to TIMESTAMP_TZ" | Alignment failure | Casting/conversion is plausible but not supported by any stated source/target types in the row. Also does not specify the source timezone assumption for updated_at (local vs already UTC) which is required to correctly convert to UTC. |

---

### Recommendations

1. **Facility.Facility ID (dim_facility.facility_id; equipment.equip_id):** Replace the example-driven parsing with a rule that explicitly references the source column(s) and their expected patterns (e.g., "If equip_id matches '<SITE>-<ASSET>-<NN>', derive facility_id as '<SITE>-<ASSET>'"), and document/implement the FAC→LEX crosswalk table including join key, cardinality, and fallback behavior.

2. **Facility.City / Facility.State Region (dim_facility.city/state_region; equipment.building):** Reconfirm semantic mapping. If “building” is a code that implies location attributes, explicitly state the reference dataset (e.g., Building→City/State) and the lookup key. If not, mark as **Ambiguous** or remap to a more appropriate source column.

3. **Facility.Country Code (dim_facility.country_code; equipment.building):** Specify the exact input column that contains country information (if it is not equipment.building). If a building code implies country, define the building master lookup (key, output field, precedence, null handling) and set status to **Inferred/Ambiguous** accordingly.

4. **Facility.Timezone Name (dim_facility.timezone_name; equipment.updated_at):** Split into correct logic: timezone name should be sourced from a timezone attribute (or derived from facility location), not from updated_at. If timezone_name is derived from location, specify the mapping (e.g., State/Region→IANA tz). If loaded_at_utc is derived from updated_at, keep that logic only on the Loaded At UTC attribute.

5. **Facility.Effective Start Date / Effective End Date:** Specify actual input types/formats (DATE vs VARCHAR) and the target type (DATE/TIMESTAMP). If both are already ISO dates, replace with “Direct 1:1 map” and only add conversions when a format mismatch is documented. Also, validate whether equipment.calibration_due truly represents facility effective_end_date; if not, mark **Ambiguous** and identify the correct source.

6. **Facility.Current Flag (dim_facility.current_flag; equipment.status):** Define explicit mapping for equipment.status values (e.g., 'ACTIVE','INACTIVE','RETIRED') to canonical current_flag (boolean) or canonical status. If current_flag is boolean, rule should state output boolean and how to derive it from status.

7. **Product.Product Name / Product.Dosage Form (dim_product.product_name/dosage_form; batch_run.step_name):** Provide the actual reference mapping (step_name→product_name, step_name→dosage_form) with keys and governance owner. If no controlled mapping exists, mark as **Ambiguous** and do not assert a lookup.

8. **Product.SKU (dim_product.sku; batch_run.product_code):** Decide whether this is a true synonym (then “Direct 1:1 map”) or a crosswalk (then document lookup table, keys, and collision/duplicate handling). Avoid “lookup” without specification.

9. **Batch.Batch Status:** If the mapping is hard-coded, list it as a CASE expression and add handling for unmapped statuses (default to 'unknown' and log exception). If it is a lookup table, name the table and specify join key.

10. **Batch.Planned Quantity / Actual Quantity / Yield Percentage:** Only specify casts when source and target DDL types differ and are known. Add rounding/overflow rules (e.g., round half up to 3 decimals; reject values exceeding precision/scale) and document unit/scale conventions if applicable.

11. **Batch.Quantity Unit:** Remove the no-op cast. If unit normalization is required, specify it (trim/upper-case; map synonyms like 'kg'→'KG').

12. **Batch.Deviation Count (fact_batch_summary.deviation_count; deviation_event.deviation_id):** Rewrite rule to an implementable aggregation, e.g., "Deviation Count = COUNT(deviation_event.deviation_id) grouped by {join keys such as batch_id/run_id};" and explicitly state the join between deviation_event and batch_run/fact_batch_summary.

13. **Facility.Source Site Code (fact_batch_summary.source_site_code; equipment.line_id):** Fix naming inconsistency (site_code vs source_site_code) and validate semantics. If a crosswalk is required (line_id→site_code), specify the crosswalk table, join key, and precedence.

14. **Facility.Loaded At UTC (fact_batch_summary.loaded_at_utc; equipment.updated_at):** Specify the source timezone assumption for updated_at (e.g., America/New_York) and the exact conversion (e.g., AT TIME ZONE). Only cast to TIMESTAMP_TZ if the target canonical type requires timezone-aware timestamps.
