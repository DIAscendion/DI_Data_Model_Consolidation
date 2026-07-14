## Canonical Mapper Transformation Rule Quality Review

### Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 18 |
| Meaningful transformation rules | 18 / 100% |
| Aligned with inputs | 14 / 77.8% |
| Rows passing both checks | 14 / 77.8% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | 4 rows require attention — see Gap Analysis below |

Scope note: Evaluation performed on **Section 2 — Canonical Mapping Table** (18 rows). Rows in Section 3 and Section 4 marked Unmapped with blank transformation rules were excluded per instructions.

---

### Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building | Map site_code to building via lookup table | Alignment — direction ambiguous | Rule states mapping site_code to building but does not clarify how building is converted to canonical Site Code, which source is authoritative, or how conflicts are resolved. |
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name | Map step_name to product_name via business rules | Meaningfulness and alignment | Business rules is non-specific with no executable logic, no lookup identifier, and no precedence rule. Rule also references only step_name while product_name is listed as a source with no fallback or authority stated. |
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.step_name | Map step_name to dosage_form via business rules | Meaningfulness and alignment | Business rules is non-specific. Rule references only step_name and ignores the listed source dosage_form with no precedence, fallback, or merge rule defined. |
| Batch.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id | Map facility_key to equip_id via lookup table | Alignment — key domain mismatch | Rule describes facility_key mapping to equip_id but does not define how equip_id becomes the canonical Facility Key, which source is authoritative, or how the key domain difference between a surrogate and an operational equipment identifier is resolved. |
| Batch.Deviation Count | EnterpriseAnalytics.fact_batch_summary.deviation_count; LexingtonSite.deviation_event.deviation_id | Map deviation_count to deviation_id via aggregation | Alignment — semantics mismatch | deviation_count is a count metric and deviation_id is an identifier — these are not equivalent columns. Rule states map via aggregation but does not specify the aggregation function, grouping keys, or join path required to derive the count from deviation_event rows. |
| Yield Analytics.Average Yield Pct | EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct; LexingtonSite.batch_run.yield_pct | Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct | Alignment — aggregation grain missing | Rule does not account for both inputs. It describes aggregating yield_pct to produce avg_yield_pct but avg_yield_pct is also listed as a source. No precedence is stated between using the existing value directly versus recomputing it, and no grouping grain or time window for the average is defined. |

---

### Recommendations

1. **Facility.Site Code** (EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building)
   - Clarify transformation direction and precedence, for example: "Canonical Site Code = EnterpriseAnalytics.site_code (authoritative). If LexingtonSite.building is provided, map building to site_code using lookup table; if not found, flag as exception."
   - Name the lookup table and key columns used for the building-to-site-code mapping.

2. **Product.Product Name** (EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name)
   - Replace business rules with an implementable rule, for example: "If EnterpriseAnalytics.product_name is non-null, use it directly; else derive from step_name using reference table keyed by step_name; else set to NULL and log."
   - Identify the exact reference table or mapping function and any normalization (trim, uppercase) required before lookup.

3. **Product.Dosage Form** (EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.step_name)
   - Define precedence and explicit derivation logic, for example: "Canonical Dosage Form = EnterpriseAnalytics.dosage_form where non-null; else map LexingtonSite.step_name to dosage_form using reference table."
   - Specify the allowable target value set for dosage_form and how unmapped step_name values are handled (null, exception, default).

4. **Batch.Facility Key** (EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id)
   - Correct the rule to describe how equip_id relates to a facility key, for example: "Map equip_id to facility_key using equipment-to-facility bridge table (equip_id → facility_id → facility_key)."
   - Document the authoritative key domain — whether canonical Facility Key is a surrogate from EnterpriseAnalytics dim_facility or a natural site identifier — and how cross-system key resolution is performed.

5. **Batch.Deviation Count** (EnterpriseAnalytics.fact_batch_summary.deviation_count; LexingtonSite.deviation_event.deviation_id)
   - Specify the aggregation and join grain explicitly, for example: "Deviation Count = COUNT(DISTINCT deviation_event.deviation_id) grouped by deviation_event.batch_id joined to batch on batch_id."
   - If EnterpriseAnalytics.deviation_count is authoritative, state fallback and validation rules such as count reconciliation and tolerance thresholds.

6. **Yield Analytics.Average Yield Pct** (EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct; LexingtonSite.batch_run.yield_pct)
   - Define precedence and aggregation grain, for example: "If EnterpriseAnalytics.avg_yield_pct is provided at the same grain as canonical (product + facility + period), map directly; else compute AVG(LexingtonSite.yield_pct) grouped by the defined keys over the defined time window."
   - Confirm whether the cast applies to both sources and state numeric precision and rounding rules explicitly, for example ROUND(avg, 3).

---

### Review Process and Findings

1. Evaluated all 18 rows in Section 2 against two criteria: meaningfulness (whether each transformation rule provides specific, executable logic) and alignment (whether the rule accounts for all listed source columns and resolves conflicts between them).
2. All 18 transformation rules were present and referenced at least one source column, meeting the meaningfulness threshold.
3. 4 rows show alignment gaps across 6 attributes, falling into three categories: directional ambiguity (rule does not state which source is authoritative), non-specific logic (business rules cited without an implementable definition), and semantics mismatch (count metric mapped against an identifier without aggregation logic).
4. No PII rows were found missing a masking or tokenization step.
5. Rows in Section 3 and Section 4 with blank transformation rules were excluded from evaluation as they are unmapped candidates, not active mappings.
