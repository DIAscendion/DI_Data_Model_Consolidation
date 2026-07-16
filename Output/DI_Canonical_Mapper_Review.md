# Canonical Mapper Quality Review — Transformation Rules Meaningfulness & Input Alignment

Source: `Output/DI_Canonical_Mapper_Agent.md`  
Scope: Evaluate every row in **Section 2 — Canonical Mapping Table** that contains source column detail and a **Transformation Rule**.

---

## Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 21 |
| Meaningful transformation rules | 21 / 100% |
| Aligned with inputs | 14 / 66.7% |
| Rows passing both checks | 14 / 66.7% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | **Fail** |

---

## Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Facility ID | EnterpriseAnalytics.dim_facility.facility_id; LexingtonSite.equipment.equip_id | "Map site prefix; cast VARCHAR; enforce uniqueness" | **Alignment failure** | Rule references adding/mapping a **site prefix**, but neither input column indicates a prefix exists or is required; also no source format/type details are provided to justify the prefix logic. Clarify actual concatenation/parsing logic and which source provides the prefix. |
| Facility.Facility Name | EnterpriseAnalytics.dim_facility.facility_name; LexingtonSite.equipment.equip_name | "Direct map; truncate/pad as needed" | **Alignment failure** | Rule introduces **truncate/pad** behavior but no canonical length/target constraint is stated in the row. “As needed” is non-deterministic without a specified maximum length/padding character and direction. |
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.line_id | "Map site code to line_id via lookup table" | **Alignment failure** | Mapping a **site code** to a **line identifier** via lookup implies a crosswalk between different concepts. The row provides no evidence of a defined lookup/crosswalk, key fields, or cardinality. Rule asserts a confident mapping without stating join keys or lookup source. |
| Facility.Location (City/Building) | EnterpriseAnalytics.dim_facility.city; LexingtonSite.equipment.building | "Concatenate city/building for canonical location" | **Alignment failure** | Rule says concatenate **city + building**, but the row lists **two different sources** (city from one app, building from another). It does not specify delimiter, null-handling, ordering, or whether both values are always available. |
| Facility.Country Code | EnterpriseAnalytics.dim_facility.country_code; LexingtonSite.equipment.manufacturer | "Map country_code to manufacturer; review for business logic" | **Both** | Not aligned: mapping **country_code** to **manufacturer** is conceptually inconsistent with the attribute name (Country Code) and with the listed source column (manufacturer). Also the rule is not implementable as written (“review for business logic”) and does not state the actual transformation/crosswalk. |
| Facility.Timezone Name | EnterpriseAnalytics.dim_facility.timezone_name; LexingtonSite.equipment.updated_at | "Convert updated_at timestamp to timezone_name; extract TZ info" | **Alignment failure** | A timestamp column (`updated_at`) typically does not contain timezone name unless stored with TZ offset/zone. Row provides no type/format; rule assumes timezone derivation that may not be possible. Also direction is unclear because one source already is `timezone_name`—rule should specify precedence (use timezone_name directly, else derive). |
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name | "Map step_name to product_name via lookup; review with business" | **Alignment failure** | `step_name` is a process step descriptor, not obviously a product name. Rule asserts a lookup but does not specify lookup source, keys, or when to use which source. “Review with business” indicates uncertainty but Status is only Inferred; rule should explicitly define interim handling (e.g., null/hold) until confirmed. |
| Product.SKU | EnterpriseAnalytics.dim_product.sku; LexingtonSite.batch_run.batch_id | "Map SKU code to batch_id; review for business logic" | **Both** | SKU and batch_id are different identifiers. Rule is not executable and appears conceptually incorrect for the canonical attribute “SKU”. It also does not define any crosswalk or parsing logic. |
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.notes | "Extract dosage form from notes using regex pattern" | **Alignment failure** | Rule mentions a regex extraction but does not provide the **pattern**, expected token(s), precedence vs. existing `dosage_form`, or validation against an allowed list. With two sources, rule must specify whether to prefer the structured column and only fallback to notes. |
| Product.Therapeutic Class | EnterpriseAnalytics.dim_product.therapeutic_class; LexingtonSite.batch_run.shift | "Map therapeutic_class to shift via lookup; review with business" | **Both** | Therapeutic class and shift are unrelated concepts. Rule is both conceptually misaligned and non-implementable as written; no lookup definition or keys are provided. |
| Quality Disposition.Disposition Name | EnterpriseAnalytics.dim_quality_disposition.disposition_name; LexingtonSite.batch_run.batch_status | "Map disposition_name to batch_status; review with business" | **Alignment failure** | `batch_status` is also used for Disposition Code and Commercially Releasable. Rule does not specify how a single source column (`batch_status`) can simultaneously provide code/name/boolean semantics. Lacks explicit code-set mapping and disambiguation logic. |
| Quality Disposition.Commercially Releasable | EnterpriseAnalytics.dim_quality_disposition.commercially_releasable; LexingtonSite.batch_run.batch_status | "Map TRUE/FALSE to batch_status values (completed/active)" | **Alignment failure** | Rule maps a boolean to `batch_status` values (completed/active) but does not specify which values correspond to TRUE/FALSE, how to treat other statuses, or whether `commercially_releasable` is derived from status vs. a directly stored boolean. |
| Quality Disposition.Deviation Implied | EnterpriseAnalytics.dim_quality_disposition.deviation_implied; LexingtonSite.deviation_event.severity | "Map deviation_implied to severity via lookup; review with business" | **Both** | Deviation implied (boolean/flag) vs severity (ordinal/category) are different measures. Rule is not executable and implies an unsupported conceptual mapping without defined crosswalk and keys. |
| Batch Summary.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id | "Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR" | **Alignment failure** | Facility key vs equipment id suggests mismatched grain. Rule also states “enforce INTEGER/VARCHAR” without specifying which side is which and the exact cast direction/handling of non-numeric values. Lookup table details and join keys are missing. |
| Batch Summary.Product Key | EnterpriseAnalytics.fact_batch_summary.product_key; LexingtonSite.batch_run.product_code | "Map product_key to product_code via lookup; enforce INTEGER/VARCHAR" | **Alignment failure** | Key-to-code mapping may be valid but the rule omits lookup definition (crosswalk source, join keys) and does not state deterministic cast/format handling for INTEGER↔VARCHAR conversion. |
| Batch Summary.Batch Status | EnterpriseAnalytics.fact_batch_summary.batch_status; LexingtonSite.batch_run.batch_status | "Direct map; enforce VARCHAR(30); validate values" | **Alignment failure** | “Validate values” is non-specific: no allowed value set, case normalization, or invalid handling is provided. If validation is required, rule must specify the constraints and remediation (reject, null, map to ‘UNKNOWN’, etc.). |
| Batch Summary.Planned Quantity | EnterpriseAnalytics.fact_batch_summary.planned_qty; LexingtonSite.batch_run.planned_qty | "Direct map; cast NUMERIC(18,3); enforce NOT NULL" | **Alignment failure** | Rule enforces NOT NULL without evidence both sources are non-null; no defaulting/imputation strategy is stated. Also direct map assumes same unit of measure; unit consistency is not referenced in the rule. |
| Batch Summary.Actual Quantity | EnterpriseAnalytics.fact_batch_summary.actual_qty; LexingtonSite.batch_run.actual_qty | "Direct map; cast NUMERIC(18,3); enforce NOT NULL" | **Alignment failure** | Same issue as Planned Quantity: NOT NULL enforcement lacks stated handling for nulls; unit consistency and rounding behavior (scale 3) not specified (round vs. truncate). |
| Batch Summary.Quantity Unit | EnterpriseAnalytics.fact_batch_summary.qty_unit; LexingtonSite.batch_run.qty_unit | "Direct map; cast VARCHAR(20); validate values" | **Alignment failure** | “Validate values” is vague without an explicit allowed UOM set (e.g., kg/g/L) and normalization rules (case, synonyms). Also if quantity fields are numeric, unit standardization should be tied to numeric unit conversion if units differ. |

If no discrepancies were found, this section would state “No gaps identified”. Discrepancies were identified as listed above.

---

## Recommendations

1. **Facility.Facility ID**: Specify the exact prefix rule (source of prefix, delimiter, and whether to concatenate or parse). If `equip_id` already includes a site prefix and `facility_id` does not, define a deterministic parsing/standardization rule; otherwise remove the prefix step.

2. **Facility.Facility Name**: Replace “truncate/pad as needed” with implementable constraints: target max length, padding direction (left/right), pad character, and truncation behavior. If no length constraint exists, remove padding/truncation language.

3. **Facility.Site Code**: Document the required lookup/crosswalk: lookup table name/location, join keys, expected cardinality, and what to do when no match is found. If `line_id` is not truly a site code, remap this attribute or reclassify as Ambiguous.

4. **Facility.Location (City/Building)**: Define concatenation details (delimiter, ordering, trimming, null-handling). Example: `COALESCE(city,'') || ' - ' || COALESCE(building,'')` and whether to suppress delimiter when one side is null.

5. **Facility.Country Code**: Correct the mapping. If the canonical attribute is Country Code, the second source should not be `manufacturer`. Either (a) change the canonical attribute, (b) select a correct source column, or (c) mark the row Ambiguous/Unmapped until a valid country source is identified.

6. **Facility.Timezone Name**: Define precedence and feasibility. Recommended: use `timezone_name` directly when present; only derive from `updated_at` if its datatype includes timezone (e.g., TIMESTAMP WITH TIME ZONE) and specify extraction method. Otherwise remove `updated_at` as a source for timezone.

7. **Product.Product Name**: Provide the lookup design (lookup entity, keys such as product_code/step_id, and when step_name is a proxy). If uncertain, mark as Ambiguous and define interim handling (null or hold-out) rather than asserting the mapping.

8. **Product.SKU**: Reassess the mapping: do not map SKU to batch_id without an explicit, approved crosswalk. Either identify a true SKU source in LexingtonSite, or keep only `dim_product.sku` and treat LexingtonSite as Unmapped for SKU.

9. **Product.Dosage Form**: Add the actual regex/pattern and extraction precedence. Recommended: prefer `dim_product.dosage_form` when non-null; else parse `notes` with a specified regex, then validate against an allowed dosage-form list.

10. **Product.Therapeutic Class**: Correct the conceptual mismatch with `shift`. Identify the proper therapeutic class source or remove `shift` from inputs. If `shift` is genuinely related via an external crosswalk, document it explicitly and mark status accordingly.

11. **Quality Disposition.Disposition Name**: Define the code-set mapping from `batch_status` to both disposition_code and disposition_name, and ensure one source column is not overloaded without clear decoding rules. If `batch_status` cannot support all three attributes, split the mapping or mark affected rows Ambiguous.

12. **Quality Disposition.Commercially Releasable**: Specify explicit TRUE/FALSE derivation rules from `batch_status` (which statuses map to TRUE vs FALSE), plus handling for unexpected statuses. If `commercially_releasable` exists as a boolean in EA, define precedence and reconcile conflicts.

13. **Quality Disposition.Deviation Implied**: Do not map a boolean flag to severity without explicit business rules. Either map `deviation_implied` from a boolean/flag source (e.g., derived from presence of deviations) or rename the canonical attribute to Severity if that is the intent.

14. **Batch Summary.Facility Key**: Validate grain alignment. If `facility_key` should reference Facility and `equip_id` references Equipment, either remap to an equipment key attribute or define an equipment→facility relationship lookup and specify join keys. Also specify deterministic cast direction for INTEGER↔VARCHAR.

15. **Batch Summary.Product Key**: Provide the product crosswalk (product_key↔product_code): lookup source, join keys, and missing/duplicate match handling. Specify cast behavior and any formatting (leading zeros, padding).

16. **Batch Summary.Batch Status**: Replace “validate values” with an explicit allowed value list (or reference table), normalization rules (case/trim), and exception handling (reject, quarantine, map to UNKNOWN).

17. **Batch Summary.Planned Quantity / Actual Quantity**: If NOT NULL is required, define defaulting strategy (e.g., set to 0, reject row, or quarantine) and rounding rule for scale (round half up vs truncate). Also confirm unit consistency; if units may differ, add unit conversion logic tied to `qty_unit`.

18. **Batch Summary.Quantity Unit**: Provide explicit UOM standardization (allowed list, synonym mapping such as “KG”→“kg”), and define what happens on invalid units. If unit conversion is in scope, define canonical unit and conversion factors.

---

## Compliance Log (Process/Inputs Validation)

- Input file successfully read from GitHub: `Output/DI_Canonical_Mapper_Agent.md`.
- Transformation Rule column present in Section 2 and includes source column details required for this check.
- Output written to GitHub path: `Output/DI_Canonical_Mapper_Review.md`.