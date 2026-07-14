## Check 1.1 — Match Reasons Meaningfulness & Score Alignment Review

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 19 |
| Meaningful reasons | 19 / 100% |
| Aligned with score | 13 / 68.4% |
| Rows passing both checks | 13 / 68.4% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | 10 rows require attention — see Gap Analysis below |

**Score bands derived from Section 1 summary:**
- High band: **≥80** ("Attributes mapped ≥80% match")
- Mid band: **40–79** ("Attributes mapped 40–79% match")
- Low/not mapped: **<40** (out of scope for Section 2)

---

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.building | 62 | Alignment — strengthen evidence | Reason claims only broad glossary similarity and short codes in sample data; possible domain mismatch (site_code vs building). Provide glossary excerpts or sample value overlaps to confirm. |
| EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name | 41 | Alignment — weak evidence | Reason cites glossary similarity and both being descriptive text, which does not establish semantic equivalence between product name and process step name. Reason should explicitly state inferential/speculative nature. |
| EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.product_code | 80 | Alignment — score review needed | Reason explicitly states different concepts (supply chain code vs site-local code) and implies a crosswalk is needed. Mid-band score is more appropriate unless a validated reference table exists. |
| EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.step_name | 45 | Alignment — weak evidence | Reason relies on generic glossary similarity and descriptive text without concrete semantic evidence linking dosage form to step name. |
| EnterpriseAnalytics.fact_batch_summary.enterprise_batch_id → LexingtonSite.batch_run.batch_id | 91 | Alignment — identifier scope unconfirmed | Reason provides name and glossary similarity but no evidence that enterprise batch ID and local batch ID share the same identifier namespace. High-band score requires explicit confirmation. |
| EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id | 60 | Alignment — linkage evidence missing | Reason asserts facility_key links to equip_id with no stated basis (FK relationship, mapping table, or definition). Sample data described as numeric/site code is vague. |
| EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code | 83 | Alignment — surrogate key path not stated | Reason says product_key links to product_code without explicit evidence of the join path (e.g., fact_batch_summary.product_key → dim_product.product_id → batch_run.product_code). High-band score requires this to be documented. |
| EnterpriseAnalytics.fact_batch_summary.deviation_count → LexingtonSite.deviation_event.deviation_id | 48 | Alignment — derived metric not a direct match | Reason compares a count to an identifier. These are not equivalent columns. The reason should state the derivation logic explicitly (e.g., COUNT(deviation_id) per batch_id) rather than treating this as a direct column match. |
| EnterpriseAnalytics.fact_batch_summary.source_site_code → LexingtonSite.equipment.building | 53 | Alignment — strengthen evidence | Reason relies on glossary similarity and short code patterns without establishing that a site code equals a building field. Concrete definition or sample value overlaps needed. |
| EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct → LexingtonSite.batch_run.yield_pct | 92 | Alignment — aggregation context missing | Reason cites glossary similarity and both being percentages, but source is an average while target is a per-batch value. High-band score requires explicit confirmation that avg_yield_pct = AVG(yield_pct) over a defined grouping. |

---

### Recommendations

1. **dim_facility.site_code → equipment.building (62):** Provide glossary excerpts showing building is a site/building code aligned to site_code, plus 3–5 overlapping sample values. If building is a physical name/label rather than a code, downgrade the score and move to needs business review.

2. **dim_product.product_name → batch_run.step_name (41):** Update the reason to explicitly state this is a weak inferential candidate, or remove it. Re-score as unmatched unless documentation confirms step_name represents a product name at this site.

3. **dim_product.sku → batch_run.product_code (80):** Either provide evidence of a validated crosswalk mapping SKU to product_code and cite it in the reason, or reduce the score to mid band because the reason itself states the codes differ by domain.

4. **dim_product.dosage_form → batch_run.step_name (45):** Replace the generic reason with a concrete semantic basis using definition excerpts or sample values. If no such evidence exists, remove this mapping and treat dosage_form as an unmatched new canonical attribute candidate.

5. **fact_batch_summary.enterprise_batch_id → batch_run.batch_id (91):** Confirm whether Lexington batch_id is the enterprise-wide identifier or a local one. If local vs enterprise differs, add an explicit crosswalk to the transformation rule and review the score accordingly.

6. **fact_batch_summary.facility_key → batch_run.equip_id (60):** Provide the specific missing evidence: ERD/FK relationship, mapping table name, or definition. If facility_key is a surrogate for dim_facility, re-map to the correct business key (e.g., facility_id) rather than the surrogate.

7. **fact_batch_summary.product_key → batch_run.product_code (83):** Document the full join path in the reason. If this is a multi-hop mapping, keep the match but reduce the score unless validated with sample join results.

8. **fact_batch_summary.deviation_count → deviation_event.deviation_id (48):** Correct the mapping intent — this is a derived metric not a column match. Update the reason to state the aggregation logic and grain explicitly (COUNT of deviation_id grouped by batch_id). Consider documenting as a transformation requirement rather than a direct match.

9. **fact_batch_summary.source_site_code → equipment.building (53):** Show that building contains site codes rather than building names with overlapping sample values. If ambiguous, add needs validation language or lower the score.

10. **fact_yield_analysis.avg_yield_pct → batch_run.yield_pct (92):** Update the reason to state avg_yield_pct = AVG(batch_run.yield_pct) over a defined grouping (time period, product, facility). If the aggregation grouping is unknown, reduce to mid band and mark as requiring analytical validation.

---

### Review Process and Findings

1. Extracted Section 1 score bands from the report summary (≥80 high, 40–79 mid) and used these as the only band definitions.
2. Reviewed all 19 Section 2 rows and evaluated meaningfulness (whether each reason provides specific, checkable evidence) and alignment (whether the evidence strength supports the assigned score band).
3. All 19 reasons were present and specific enough to be considered meaningful — each cites at least one evidence type.
4. 10 rows show score alignment gaps, primarily where the reason is speculative or generic despite a mid or high score, or where the reason indicates surrogate/business-key or aggregation relationships without explicit validation for a high-band score.
5. No internal contradictions were detected where a reason explicitly states no match while a high score is assigned; however, multiple rows express conceptual differences without sufficient validation to justify high-band placement.
