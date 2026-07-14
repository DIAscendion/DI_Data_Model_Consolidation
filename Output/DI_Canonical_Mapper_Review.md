# Canonical Mapper Transformation Rule Quality Review

## Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 18 |
| Meaningful transformation rules | 18 / 100% |
| Aligned with inputs | 14 / 77.8% |
| Rows passing both checks | 14 / 77.8% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | **Fail** |

Scope note: Evaluation performed on **Section 2 — Canonical Mapping Table** (18 rows). Rows in Section 3/Section 4 marked **Unmapped** with blank transformation rules were excluded per instructions.

---

## Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building | "Map site_code to building via lookup table" | **Alignment failure** | Rule is directionally ambiguous: it states mapping *site_code → building*, but the canonical attribute is **Site Code** and one listed source is **building**. The rule does not state how **building** is converted to canonical **Site Code** (or whether **site_code** is authoritative and **building** is derived/ignored). |
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name | "Map step_name to product_name via business rules" | **Both** | Meaningfulness: “business rules” is non-specific (no executable logic, no rule/lookup identifier, no precedence). Alignment: rule references only **step_name**, but the row also lists **product_name** as an input and does not state whether it is a direct map / authoritative source / fallback when step_name missing. |
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.step_name | "Map step_name to dosage_form via business rules" | **Both** | Meaningfulness: “business rules” is non-specific. Alignment: rule references only **step_name** and ignores the listed source **dosage_form** (no precedence/fallback/merge rule). |
| Batch.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id | "Map facility_key to equip_id via lookup table" | **Alignment failure** | Canonical attribute is **Facility Key**, but rule describes mapping **facility_key → equip_id**. It does not define how **equip_id** becomes **Facility Key** (key domain mismatch not addressed) and does not clarify which source is authoritative. |
| Batch.Deviation Count | EnterpriseAnalytics.fact_batch_summary.deviation_count; LexingtonSite.deviation_event.deviation_id | "Map deviation_count to deviation_id via aggregation" | **Alignment failure** | Semantics mismatch: **deviation_count** is a count metric, while **deviation_id** is an identifier. Rule says “map … via aggregation” but does not specify the required aggregation (e.g., COUNT of deviation_id grouped by batch) nor the join keys (e.g., batch_id) to relate deviation_event to a batch. As written, it implies mapping an ID to a count without defining how. |
| Yield Analytics.Average Yield Pct | EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct; LexingtonSite.batch_run.yield_pct | "Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct" | **Alignment failure** | Rule does not account for both inputs: it describes aggregating **yield_pct** to produce **avg_yield_pct**, but the row also lists **avg_yield_pct** as a source column. No precedence is stated (use existing avg_yield_pct directly vs recompute from yield_pct), and no grouping grain/window for the average is specified. |

---

## Recommendations

1. **Facility.Site Code** (EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building)
   - Clarify transformation direction and precedence, e.g.:
     - “Canonical Site Code = EnterpriseAnalytics.site_code (authoritative). If LexingtonSite.building is provided, map building → site_code using lookup `<lookup_name>`; if not found, flag as exception.”
   - Name the lookup table/key(s) used for the building-to-site-code mapping.

2. **Product.Product Name** (EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name)
   - Replace “via business rules” with an implementable rule, e.g.:
     - “If EnterpriseAnalytics.product_name is non-null, use it; else derive from step_name using reference table `<table>` keyed by step_name; else set to NULL and log.”
   - Identify the exact rule artifact (reference table, mapping function, or rule ID) and any normalization (trim/upper) required before lookup.

3. **Product.Dosage Form** (EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.step_name)
   - Define precedence and explicit derivation logic, e.g.:
     - “Canonical Dosage Form = EnterpriseAnalytics.dosage_form; else map LexingtonSite.step_name → dosage_form using reference table `<table>`.”
   - Specify allowable target values/code set for dosage_form and how unmapped step_name values are handled.

4. **Batch.Facility Key** (EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id)
   - Correct the rule to describe how **equip_id** relates to a **facility key**, e.g.:
     - “Map equip_id → facility_key using equipment-to-facility bridge `<table>` (equip_id → facility_id → facility_key).”
   - Document authoritative key domain (is canonical Facility Key a surrogate from EnterpriseAnalytics dim_facility, or a natural/site identifier?), and how cross-system key resolution is performed.

5. **Batch.Deviation Count** (EnterpriseAnalytics.fact_batch_summary.deviation_count; LexingtonSite.deviation_event.deviation_id)
   - Specify the aggregation explicitly and the join grain, e.g.:
     - “Deviation Count = COUNT(DISTINCT deviation_event.deviation_id) grouped by deviation_event.batch_id (and/or run_id) and joined to batch on batch_id.”
   - If EnterpriseAnalytics.deviation_count is authoritative, state fallback/validation rules (e.g., reconcile counts, tolerance thresholds).

6. **Yield Analytics.Average Yield Pct** (EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct; LexingtonSite.batch_run.yield_pct)
   - Define precedence and aggregation grain/window, e.g.:
     - “If EnterpriseAnalytics.avg_yield_pct is provided at the same grain as canonical (e.g., product+facility+period), direct map; else compute AVG(LexingtonSite.yield_pct) grouped by `<keys>` over `<time window>`.”
   - Clarify whether the cast applies to both sources and ensure numeric precision/rounding rules are stated (e.g., ROUND(avg,3)).
