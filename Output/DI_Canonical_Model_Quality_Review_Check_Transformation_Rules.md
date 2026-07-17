# Check — Transformation Rules Meaningfulness & Input Alignment Review

## Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 21 |
| Meaningful transformation rules | 17 / 81.0% |
| Aligned with inputs | 12 / 57.1% |
| Rows passing both checks | 12 / 57.1% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | **Fail** |

## Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Facility ID | EnterpriseAnalytics.dim_facility.facility_id, LexingtonSite.equipment.equip_id | Map site prefix; cast VARCHAR; enforce uniqueness | **Both** | Rule introduces **“Map site prefix”** and **“enforce uniqueness”** but the row provides no evidence that either source contains a site prefix to map, nor what the canonical format should be. “Enforce uniqueness” is a data quality constraint, not a transformation, and is not defined (dedupe? reject? select latest?). |
| Facility.Facility Name | EnterpriseAnalytics.dim_facility.facility_name, LexingtonSite.equipment.equip_name | Direct map; truncate/pad as needed | **Both** | “truncate/pad as needed” is non-executable without a stated canonical length and padding direction/character. Also implies type/length mismatch that is not stated in the row (no source lengths provided). |
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code, LexingtonSite.equipment.line_id | Map site code to line_id via lookup table | **Alignment failure** | Inputs are **site_code** vs **line_id** (different concepts/grain). Rule assumes a lookup exists but does not name it, join keys, or whether mapping is 1:1 vs many:1. As **Confirmed**, the rule should cite the authoritative crosswalk to justify semantic alignment. |
| Facility.Location (City/Building) | EnterpriseAnalytics.dim_facility.city, LexingtonSite.equipment.building | Concatenate city/building for canonical location | **Both** | Row is framed as mapping a single canonical attribute from two different source attributes, but the transformation **creates a composite string** without specifying delimiter, ordering, null-handling, or whether the canonical attribute is intended to be composite. Also city vs building are different granularities; concatenation is a derivation, not equivalence. |
| Facility.Country Code | EnterpriseAnalytics.dim_facility.country_code, LexingtonSite.equipment.manufacturer | Map country_code to manufacturer; review for business logic | **Both** | Country code and manufacturer are unrelated domains. Rule itself signals uncertainty (“review for business logic”) and is not a concrete operation. This is misaligned with the listed inputs.
|
| Facility.Timezone Name | EnterpriseAnalytics.dim_facility.timezone_name, LexingtonSite.equipment.updated_at | Convert updated_at timestamp to timezone_name; extract TZ info | **Both** | A timestamp typically does not contain timezone identifier unless it is timezone-aware; the row provides no type/format evidence. Rule invents extraction of TZ from updated_at without stating it is TIMESTAMP WITH TIME ZONE or includes an offset. Also, mapping a timezone name from an event timestamp is semantically misaligned.
|
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name, LexingtonSite.batch_run.step_name | Map step_name to product_name via lookup; review with business | **Both** | step_name (process step) is not evidenced as a product name. Rule is vague (no lookup name/keys) and includes “review with business,” indicating non-final logic while status is Inferred (acceptable) but still non-executable.
|
| Product.SKU | EnterpriseAnalytics.dim_product.sku, LexingtonSite.batch_run.batch_id | Map SKU code to batch_id; review for business logic | **Both** | SKU (product identifier) vs batch_id (batch/run identifier) are different identifiers; rule is non-executable and signals uncertainty. No crosswalk/derivation basis is stated.
|
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form, LexingtonSite.batch_run.notes | Extract dosage form from notes using regex pattern | **Meaningfulness failure** | Regex extraction is potentially valid, but the rule omits the actual regex, expected vocabulary/code set, case sensitivity, and ambiguity handling. Without these, it is not implementable and cannot be verified against inputs.
|
| Product.Therapeutic Class | EnterpriseAnalytics.dim_product.therapeutic_class, LexingtonSite.batch_run.shift | Map therapeutic_class to shift via lookup; review with business | **Both** | Therapeutic class (product classification) vs shift (staffing schedule) are unrelated. Rule assumes a lookup with no basis and is non-executable.
|
| Quality Disposition.Disposition Name | EnterpriseAnalytics.dim_quality_disposition.disposition_name, LexingtonSite.batch_run.batch_status | Map disposition_name to batch_status; review with business | **Alignment failure** | disposition_name (quality disposition) and batch_status (operational run status) are not evidenced as equivalent. Rule suggests mapping by business review but the row is **Confirmed**, which should not depend on “review.”
|
| Quality Disposition.Commercially Releasable | EnterpriseAnalytics.dim_quality_disposition.commercially_releasable, LexingtonSite.batch_run.batch_status | Map TRUE/FALSE to batch_status values (completed/active) | **Alignment failure** | Input is a boolean-like flag mapped to a multi-valued status. Rule also **invents specific mappings** (TRUE/FALSE → completed/active) without any stated code-set evidence in the row.
|
| Quality Disposition.Deviation Implied | EnterpriseAnalytics.dim_quality_disposition.deviation_implied, LexingtonSite.deviation_event.severity | Map deviation_implied to severity via lookup; review with business | **Both** | Boolean deviation_implied mapped to severity (ordinal/categorical) is conceptually misaligned without a clear business rule. Rule is also vague (no lookup definition) and signals uncertainty.
|
| Batch Summary.Enterprise Batch ID | EnterpriseAnalytics.fact_batch_summary.enterprise_batch_id, LexingtonSite.batch_run.batch_id | Reformat batch_id to enterprise_batch_id (regex transform) | **Meaningfulness failure** | “regex transform” is a placeholder without the regex, capture groups, or examples. Cannot validate direction (is batch_id being expanded/prefixed?) or ensure deterministic transformation.
|
| Batch Summary.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key, LexingtonSite.batch_run.equip_id | Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR | **Both** | facility_key implies facility-level key (often numeric surrogate) while equip_id is equipment identifier (often string). Rule lacks lookup/crosswalk details and mixes transformation with a vague type enforcement (“enforce INTEGER/VARCHAR”) without specifying canonical type or cast direction.
|
| Batch Summary.Product Key | EnterpriseAnalytics.fact_batch_summary.product_key, LexingtonSite.batch_run.product_code | Map product_key to product_code via lookup; enforce INTEGER/VARCHAR | **Both** | product_key vs product_code likely differ (surrogate vs natural). Rule needs explicit mapping table and cast direction; “enforce INTEGER/VARCHAR” is ambiguous and non-executable.
|
## Recommendations

1. **Facility.Facility ID:** Replace “Map site prefix” with an explicit, testable rule (e.g., `canonical_facility_id = equip_id` OR `canonical_facility_id = REGEXP_REPLACE(equip_id,'^LEX-','')`) and provide the expected canonical format. Move “enforce uniqueness” to a separate data quality constraint section (define whether duplicates are rejected, deduped by latest timestamp, or quarantined).

2. **Facility.Facility Name:** State the canonical max length and behavior explicitly (e.g., “truncate to 150 characters; no padding” or “right-pad with spaces to 150”). If no truncation/padding is required, change to “Direct 1:1 map; cast to VARCHAR(150).”

3. **Facility.Site Code:** If this mapping is truly **Confirmed**, cite the authoritative crosswalk (table name, owner, join keys, and cardinality). If it is not a stable 1:1 mapping (site vs line), reclassify as **Inferred** or remove the mapping and keep as separate attributes.

4. **Facility.Location (City/Building):** Decide whether the canonical attribute is a composite “Location Label.” If yes, specify delimiter, order, trimming rules, and null handling (e.g., `COALESCE(city,'') || ' - ' || COALESCE(building,'')`). If no, split into separate canonical attributes (City, Building).

5. **Facility.Country Code:** Remove this mapping; country_code should not map to manufacturer. Keep **country_code** as its own canonical attribute (as already suggested in extension recommendations) and map manufacturer separately if/when a true source exists.

6. **Facility.Timezone Name:** Do not attempt to derive timezone_name from updated_at unless updated_at is explicitly timezone-aware. Correct approach: map timezone_name from a site configuration/source column or a facility reference table; document the lookup and expected IANA timezone values.

7. **Product.Product Name:** Replace step_name mapping with a legitimate product-name source column, or provide a named lookup that maps step_name → product_name with keys and governance owner. If the lookup is heuristic, keep status as **Inferred** and add validation steps.

8. **Product.SKU:** Do not map SKU to batch_id without explicit evidence. Either (a) map SKU to product_code/product_id via master data, or (b) mark unmapped and add SKU to canonical Product.

9. **Product.Dosage Form:** Provide the exact regex (or parsing logic), the controlled vocabulary output (e.g., TABLET/CAPSULE/LIQUID), and collision rules (multiple matches, no match). Otherwise, this should be recorded as “Manual derivation required” rather than a transformation rule.

10. **Product.Therapeutic Class:** Remove therapeutic_class → shift mapping. Treat them as unrelated attributes; keep therapeutic_class as a Product attribute and shift as an Operations/Batch attribute.

11. **Quality Disposition.Disposition Name:** If disposition_name is intended to drive batch_status, formalize it as a **derivation**: name the mapping table, specify precedence rules, and change status to **Inferred** unless glossary/SME confirms equivalence.

12. **Quality Disposition.Commercially Releasable:** Model commercially_releasable as its own boolean canonical attribute. If batch_status is derived from it, document the full truth table and confirm the batch_status domain; otherwise remove the mapping.

13. **Quality Disposition.Deviation Implied:** If a business rule exists to infer severity from deviation_implied, document it explicitly (e.g., TRUE → 'LOW' else NULL) and name the mapping/threshold logic. Otherwise, keep these as separate attributes.

14. **Batch Summary.Enterprise Batch ID:** Replace “regex transform” with the exact pattern and output format, plus examples. If enterprise_batch_id is already present in EnterpriseAnalytics, confirm whether Lexington batch_id is identical; if so, switch to “Direct map; cast VARCHAR(n).”

15. **Batch Summary.Facility Key / Product Key:** Specify (a) canonical data type, (b) cast direction, and (c) the authoritative crosswalk tables (facility_key→equip_id, product_key→product_code). If keys are surrogates, document the dimension join required (e.g., join fact_batch_summary → dim_facility to get site_code/equip_id).
