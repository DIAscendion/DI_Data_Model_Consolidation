# Transformation Rules Review — Meaningfulness & Input Alignment

Scope: Evaluate **all rows in Section 2 — Canonical Mapping Table** from `Output/DI_Canonical_Mapper_Agent.md` that contain source column detail and a **Transformation Rule**. Check that each rule is (1) meaningful (specific/executable) and (2) aligned with its stated inputs (source columns + status).

---

## Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 21 |
| Meaningful transformation rules | 21 / 100% |
| Aligned with inputs | 12 / 57.1% |
| Rows passing both checks | 12 / 57.1% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | **Fail** |

Notes:
- **PII-flagged attributes = 0** in the input, so no masking requirement applies.
- Several rules are *worded as transformations* but are not demonstrably supported by the listed source columns (e.g., converting a timestamp into a timezone name; mapping country codes to manufacturers).

---

## Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Facility ID | EnterpriseAnalytics.dim_facility.facility_id; LexingtonSite.equipment.equip_id | “Map site prefix; cast VARCHAR; enforce uniqueness” | **Alignment failure** | Rule introduces **“site prefix”** logic not supported by the row’s inputs (no indication either identifier contains a site prefix or requires prefix mapping). Uniqueness enforcement is a constraint, not a transformation, and may be fine but does not explain how values align across sources. |
| Facility.Facility Name | EnterpriseAnalytics.dim_facility.facility_name; LexingtonSite.equipment.equip_name | “Direct map; truncate/pad as needed” | **Meaningfulness failure** | “truncate/pad as needed” is not executable without specifying **target length**, truncation direction, padding character, and when padding applies. |
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.line_id | “Map site code to line_id via lookup table” | **Alignment failure** | Lookup is plausible, but the rule does not specify the **authoritative crosswalk** (table name, join keys, precedence) and does not justify semantic equivalence (site vs line). Needs explicit input-driven basis. |
| Facility.Location (City/Building) | EnterpriseAnalytics.dim_facility.city; LexingtonSite.equipment.building | “Concatenate city/building for canonical location” | **Both** | The row lists **one source column per system**, but the rule implies a concatenation of **two values** (“city/building”) without defining delimiter, order, null-handling, or whether both inputs are always available. Also the canonical attribute label implies mixed granularity; rule does not state which input is canonical vs supplemental. |
| Facility.Country Code | EnterpriseAnalytics.dim_facility.country_code; LexingtonSite.equipment.manufacturer | “Map country_code to manufacturer; review for business logic” | **Both** | Country code and manufacturer are different domains. Rule is essentially a placeholder (“review for business logic”) and asserts a mapping not supported by the inputs. |
| Facility.Timezone Name | EnterpriseAnalytics.dim_facility.timezone_name; LexingtonSite.equipment.updated_at | “Convert updated_at timestamp to timezone_name; extract TZ info” | **Both** | A timestamp generally does **not** contain timezone identity unless it is timezone-aware and stored with offset/name; no such detail is provided. “extract TZ info” is vague; rule is not supported by the stated inputs. |
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name | “Map step_name to product_name via lookup; review with business” | **Alignment failure** | Rule assumes a lookup from process step name to product name, but provides no basis (no crosswalk, no keys). Also “review with business” indicates uncertainty but status is **Inferred**; rule still needs concrete implementable logic to be aligned. |
| Product.SKU | EnterpriseAnalytics.dim_product.sku; LexingtonSite.batch_run.batch_id | “Map SKU code to batch_id; review for business logic” | **Both** | SKU (product identifier) vs batch_id (batch/run identifier) mismatch is not addressed. “review for business logic” is a placeholder and not executable. |
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.notes | “Extract dosage form from notes using regex pattern” | **Meaningfulness failure** | “regex pattern” is not specified. Without a concrete regex, extraction rules (case handling), and failure/default behavior, the transformation is not implementable. |
| Product.Therapeutic Class | EnterpriseAnalytics.dim_product.therapeutic_class; LexingtonSite.batch_run.shift | “Map therapeutic_class to shift via lookup; review with business” | **Both** | Therapeutic class (product classification) and shift (work schedule) are semantically unrelated based on inputs. Lookup details are missing; “review with business” is not executable. |
| Quality Disposition.Disposition Name | EnterpriseAnalytics.dim_quality_disposition.disposition_name; LexingtonSite.batch_run.batch_status | “Map disposition_name to batch_status; review with business” | **Meaningfulness failure** | “review with business” is non-executable. If mapping is required, specify code set, mapping table, and default behavior. |
| Quality Disposition.Commercially Releasable | EnterpriseAnalytics.dim_quality_disposition.commercially_releasable; LexingtonSite.batch_run.batch_status | “Map TRUE/FALSE to batch_status values (completed/active)” | **Alignment failure** | Aligns a **boolean** to a **multi-valued status** column; the rule only lists two statuses and does not define handling for other batch_status values (e.g., ON_HOLD/REJECTED). Also direction is unclear: is canonical commercially_releasable derived from batch_status, or is batch_status derived from boolean? |
| Quality Disposition.Deviation Implied | EnterpriseAnalytics.dim_quality_disposition.deviation_implied; LexingtonSite.deviation_event.severity | “Map deviation_implied to severity via lookup; review with business” | **Both** | Boolean-to-severity mapping requires explicit business rules and a mapping table; none is specified. “review with business” is not executable and inputs do not support equivalence. |
| Batch Summary.Enterprise Batch ID | EnterpriseAnalytics.fact_batch_summary.enterprise_batch_id; LexingtonSite.batch_run.batch_id | “Reformat batch_id to enterprise_batch_id (regex transform)” | **Meaningfulness failure** | Regex transform is stated but not defined (pattern, replacement, validation). Also the direction is unclear because both source columns are listed; rule should specify which is the canonical form and how the other is transformed into it. |
| Batch Summary.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id | “Map facility_key to equip_id via lookup; enforce INTEGER/VARCHAR” | **Alignment failure** | Facility key vs equipment ID suggests grain mismatch (facility vs equipment). Lookup table/join logic is not specified, and “enforce INTEGER/VARCHAR” is type-coercion without defined target type/format. |
| Batch Summary.Product Key | EnterpriseAnalytics.fact_batch_summary.product_key; LexingtonSite.batch_run.product_code | “Map product_key to product_code via lookup; enforce INTEGER/VARCHAR” | **Alignment failure** | Surrogate/numeric key vs product code mapping needs explicit reference mapping (dimension join/crosswalk). Rule lacks lookup definition and target typing. |

If a row is not listed above, it passed both checks based strictly on the provided inputs.

---

## Recommendations

1. **Facility.Facility ID:** Either (a) remove “site prefix” from the rule and state a verifiable operation (e.g., direct 1:1 if formats match), or (b) specify the exact prefix rule (pattern, source of site code, examples) and how it applies to `facility_id` and/or `equip_id`.

2. **Facility.Facility Name:** Replace “truncate/pad as needed” with explicit, testable logic: target length, truncation side, padding character, and null/blank handling.

3. **Facility.Site Code:** Document the lookup: crosswalk table name, join keys (e.g., `site_code` → `line_id`), match precedence, and behavior when no match exists. If it is not a true equivalence (site vs line), consider splitting into separate canonical attributes.

4. **Facility.Location (City/Building):** Define a deterministic build rule (delimiter, order, null handling). If the canonical attribute is meant to be a single “facility location label,” rename it accordingly; otherwise map City and Building as separate attributes.

5. **Facility.Country Code:** Remove this mapping as currently stated (country_code ↔ manufacturer). If the intent is to derive country from manufacturer (or vice versa), add the required reference data source and make the direction explicit.

6. **Facility.Timezone Name:** Do not attempt to derive timezone name from `updated_at` unless the timestamp is timezone-aware and stored with offset/name. Prefer: map `timezone_name` from a true timezone field, or derive timezone from a facility/site configuration dimension (explicitly referenced).

7. **Product.Product Name:** Provide an authoritative lookup/crosswalk from `step_name` to `product_name` (table, keys, ownership), or mark the mapping as **Ambiguous/Unmapped** until validated.

8. **Product.SKU:** Remove SKU ↔ batch_id mapping unless a documented rule proves batch IDs embed SKU. If derivation exists, specify the parse logic (regex) and validation.

9. **Product.Dosage Form:** Provide the exact regex (or parsing rules), include examples, and define fallback behavior (null vs “UNKNOWN”) and QA checks (allowed code set).

10. **Product.Therapeutic Class:** Remove therapeutic_class ↔ shift mapping unless a real business rule exists. If the intent is workforce analytics, create a separate canonical workforce/shift classification instead.

11. **Quality Disposition.Disposition Name:** Replace “review with business” with a mapping table or explicit conditional logic (e.g., CASE statement) including coverage of all expected values.

12. **Quality Disposition.Commercially Releasable:** Make the direction explicit:
   - If canonical is boolean `commercially_releasable`, derive it from `batch_status` via an explicit status-to-boolean mapping.
   - If canonical is `batch_status`, do not derive it from a boolean; use status directly or a proper status code mapping.

13. **Quality Disposition.Deviation Implied:** Specify the severity scale and the boolean-to-severity mapping (or remove mapping). Include lookup table details and defaults.

14. **Batch Summary.Enterprise Batch ID:** Provide the exact regex pattern/replacement, state which system’s ID is canonical, and add validation rules (accepted formats, reject/quarantine on mismatch).

15. **Batch Summary.Facility Key / Product Key:** Replace generic “lookup” wording with the specific join path (e.g., `facility_key` joins to `dim_facility` to obtain natural key; then map to `equip_id` via crosswalk). Define data types and cast targets explicitly.

---

## Compliance Log

- Input evaluated: `Output/DI_Canonical_Mapper_Agent.md` (Section 2 — Canonical Mapping Table)
- Rows evaluated: 21 (all rows containing a Transformation Rule)
- Section used: Section 2 present; Section 4 not required for this check.
- PII handling: 0 PII-flagged rows in input; no masking gaps.
- Output written to: `Output/DI_Transformation_Rules_Meaningfulness_Alignment_Review.md`
