### Check 1.1 — Match Reasons Meaningful & Aligned with Score (Section 2 Only)

#### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 18 |
| Meaningful reasons | 18 / 100% |
| Aligned with score | 15 / 83.3% |
| Rows passing both checks | 15 / 83.3% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | Fail |

#### Score bands derived from Section 1 summary
- High band: **≥80**
- Mid band: **40–79**
- Unmapped threshold: **<40** (out of scope for Section 2)

---

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalyticsDataMart.dim_facility.site_code → LexingtonSite_DataMart.equipment.line_id | 64 | Alignment failure | Reason is partially evidenced (“both reference site/line assignment”) but remains inferential and does not provide a checkable linkage between site_code and line_id (e.g., sample pattern overlap or a stated site-to-line mapping). 64 may be too high for “inferred from name/type” only; should be lower mid/near-threshold unless evidence is added. |
| EnterpriseAnalyticsDataMart.dim_facility.city → LexingtonSite_DataMart.equipment.building | 43 | Both (Meaningfulness + Alignment) | While it cites “location,” the reason does not reconcile different concepts (city vs building) and provides no concrete evidence (no value patterns, lookup source, or definition alignment). For a mid-band match, the rationale should be clearer and evidence-based; otherwise score is too generous or match should be removed. |
| EnterpriseAnalyticsDataMart.dim_facility.country_code → LexingtonSite_DataMart.equipment.manufacturer | 41 | Both (Meaningfulness + Alignment) | Domain mismatch: country_code (geography code) vs manufacturer (organization name). The reason’s “both reference origin” is not a valid/clear basis and the proposed lookup is effectively a new derivation not evidenced by the reason. Even for 41, this appears mis-matched unless a manufacturer-country field or reference derivation is explicitly stated. |
| EnterpriseAnalyticsDataMart.dim_product.product_name → LexingtonSite_DataMart.batch_run.step_name | 44 | Alignment failure | Reason remains inferential (“both reference process/product”) but doesn’t provide checkable evidence that step_name contains product_name or correlates strongly. 44 is plausible only as a weak/needs-review mapping; the reason should explicitly state weakness and why it was still selected. |
| EnterpriseAnalyticsDataMart.dim_product.sku → LexingtonSite_DataMart.batch_run.batch_id | 45 | Alignment failure | SKU (product identifier) vs batch_id (batch/run identifier) typically represent different entities. The reason is inferential and does not cite a business rule, pattern, or example establishing equivalence/derivation. 45 may be too generous without explicit evidence; should be near-threshold or removed. |

---

### Recommendations

1. **(dim_facility.site_code → equipment.line_id, score 64)** Update the reason to include concrete evidence (e.g., sample values showing site_code prefix equals line_id, or an explicit site↔line mapping table). If evidence cannot be provided, **reduce score** toward near-threshold or mark as unmatched.

2. **(dim_facility.city → equipment.building, score 43)** Either (a) provide a documented lookup that maps building to city (and cite example mappings/value patterns), or (b) **remove the match** as different concepts. If retained as a weak association, update the reason to explicitly state it is **indirect and requires reference mapping**.

3. **(dim_facility.country_code → equipment.manufacturer, score 41)** Correct the target to a manufacturer **country/location** attribute if available. If the intent is manufacturer → country derivation, state the reference dataset and logic in the reason and consider mapping manufacturer to a manufacturer dimension instead. Otherwise **remove/re-score** this match.

4. **(dim_product.product_name → batch_run.step_name, score 44)** Require evidence that Lexington’s step_name contains product names (examples or process dictionary). If not evidenced, **reduce score** and/or treat as unmatched.

5. **(dim_product.sku → batch_run.batch_id, score 45)** Require a documented business rule/pattern (e.g., batch_id embeds SKU) and specify the parsing/validation rule with examples. If not available, **remove the match** or re-score near-threshold with explicit “inferred” language.
