# Canonical Mapper Quality Review — Transformation Rules Meaningfulness & Input Alignment

## Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 18 |
| Meaningful transformation rules | 18 / 100% |
| Aligned with inputs | 14 / 77.8% |
| Rows passing both checks | 14 / 77.8% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | **Fail** |

Scope note: Evaluation performed on **Section 2 — Canonical Mapping Table** rows that include (a) source column detail and (b) a populated Transformation Rule. Unmapped rows in Section 4 with blank rules were excluded as directed.

---

## Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.Site Code | EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building | "Map site_code to building via lookup table" | Alignment failure | Rule references a lookup but **does not specify directionality/driver** (is `site_code` derived from `building`, or is `building` derived from `site_code`?), nor the lookup key(s). With two sources listed, the rule does not state which source is authoritative or how to reconcile conflicts. |
| Product.Product Name | EnterpriseAnalytics.dim_product.product_name; LexingtonSite.batch_run.step_name | "Map step_name to product_name via business rules" | Alignment failure | Rule introduces "business rules" but is **non-executable as written**: no stated rule logic (e.g., parsing, reference mapping, precedence) and it is unclear how `step_name` (process step) semantically becomes `product_name`. Status is Inferred but rule still lacks explicit constraints/assumptions. |
| Product.Dosage Form | EnterpriseAnalytics.dim_product.dosage_form; LexingtonSite.batch_run.step_name | "Map step_name to dosage_form via business rules" | Alignment failure | Same issue as above: rule depends on unspecified "business rules" and does not describe an implementable mapping from `step_name` to `dosage_form`. Status is Inferred but rule does not document the uncertainty/conditions. |
| Batch.Facility Key | EnterpriseAnalytics.fact_batch_summary.facility_key; LexingtonSite.batch_run.equip_id | "Map facility_key to equip_id via lookup table" | Alignment failure | Rule implies a lookup between a **facility key** and an **equipment id** (different concepts). Without stating the bridging table and join keys (e.g., equipment-to-facility association), the rule does not align clearly with the listed inputs and is not implementable. |
| Batch.Deviation Count | EnterpriseAnalytics.fact_batch_summary.deviation_count; LexingtonSite.deviation_event.deviation_id | "Map deviation_count to deviation_id via aggregation" | **Both** (Meaningfulness + Alignment failure) | The rule conflates a **count** (`deviation_count`) with an **identifier** (`deviation_id`). It does not state the aggregation definition (e.g., `COUNT(DISTINCT deviation_id)` by batch) nor how an ID is transformed into a count. As written, it is semantically misaligned with the inputs. |
| Yield Analytics.Average Yield Pct | EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct; LexingtonSite.batch_run.yield_pct | "Cast NUMBER(6,3) to NUMERIC(6,3); aggregate yield_pct as avg_yield_pct" | Alignment failure | Rule mentions aggregation but **does not specify the grouping grain** for the average (e.g., by product, facility, batch, time window). With an already-aggregated source (`avg_yield_pct`) and a detailed source (`yield_pct`), rule does not state precedence or reconciliation when both are present. |

If a row is not listed above, it passed both checks under the constraint of using only information stated in the mapping output.

---

## Recommendations

1. **Facility.Site Code** (EnterpriseAnalytics.dim_facility.site_code; LexingtonSite.equipment.building):
   - Specify authoritative source and transformation direction, e.g., “Canonical `Site Code` sourced from EnterpriseAnalytics.site_code; derive LexingtonSite.equipment.building by lookup `site_code -> building` using `<lookup_table>` on `<join_key>`; if mismatch, prefer `<system>`.”
   - Document lookup table name, join keys, and expected cardinality.

2. **Product.Product Name** (dim_product.product_name; batch_run.step_name):
   - Replace “via business rules” with explicit, testable logic (e.g., reference table mapping `step_name` (or `product_code`) to canonical product name; or parsing rule if embedded).
   - Because Status is **Inferred**, add conditions/assumptions and a validation step (e.g., “Only map when `step_name` matches pattern/list; otherwise set NULL and raise DQ exception for stewardship”).

3. **Product.Dosage Form** (dim_product.dosage_form; batch_run.step_name):
   - Provide explicit mapping mechanism (reference/lookup table or deterministic parsing).
   - Add a controlled vocabulary/code-set alignment step (if dosage form is enumerated) and document unknown handling.

4. **Batch.Facility Key** (fact_batch_summary.facility_key; batch_run.equip_id):
   - Clarify conceptual linkage: if the intent is “facility_key derived from equip_id”, specify the equipment-to-facility association table and join keys; otherwise, correct the mapped source to a facility identifier rather than an equipment identifier.
   - Add precedence rules when both inputs exist (e.g., prefer EnterpriseAnalytics.facility_key unless null; else derive from equip_id via association).

5. **Batch.Deviation Count** (fact_batch_summary.deviation_count; deviation_event.deviation_id):
   - Correct the rule to an explicit aggregation: e.g., “`deviation_count = COUNT(DISTINCT deviation_event.deviation_id)` grouped by `<batch identifier>` (e.g., batch_id / enterprise_batch_id) within `<time window if applicable>`.”
   - If the canonical attribute is truly a count, remove any implication of mapping to a single ID; if canonical attribute should be an ID/list, rename/reshape the canonical attribute accordingly.

6. **Yield Analytics.Average Yield Pct** (fact_yield_analysis.avg_yield_pct; batch_run.yield_pct):
   - Specify the aggregation grain for `AVG(yield_pct)` (by product, facility, batch, campaign, and/or time period) and the filtering rules (e.g., exclude rework batches).
   - Define source precedence/reconciliation: when `avg_yield_pct` exists in EnterpriseAnalytics, is it used directly, and is LexingtonSite used only to compute missing values? Document this explicitly.

---

## Compliance Log

| Timestamp (UTC) | Action | Detail |
|---|---|---|
| 2026-07-14T00:00:00Z | GitHub File Reader invoked | Source: `Output/DI_Canonical_Mapper_Agent.md` (canonicalMapperOutput) |
| 2026-07-14T00:00:00Z | Rows extracted | Section 2 rows with populated Transformation Rule and source column detail: **18** |
| 2026-07-14T00:00:00Z | Evaluation completed | Meaningfulness + alignment checks applied to all 18 rows |
| 2026-07-14T00:00:00Z | Discrepancies documented | **6** rows flagged (0 PII masking issues) |
| 2026-07-14T00:00:00Z | GitHub File Writer invoked | Destination: `Output/DI_Canonical_Mapper_Review.md` on branch `main` |
