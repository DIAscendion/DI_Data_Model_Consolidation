## Check 1.1 — Match Reasons Meaningfulness & Score Alignment Review

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 19 |
| Meaningful reasons | 19 / 100% |
| Aligned with score | 13 / 68.4% |
| Rows passing both checks | 13 / 68.4% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | **Fail** |

**Score bands derived from Section 1 summary:**
- High band: **≥80** ("Attributes mapped ≥80% match")
- Mid band: **40–79** ("Attributes mapped 40–79% match")
- Low/not mapped: **<40** (out of scope for Section 2; Section 2 rows are matched pairs)

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.building | 62 | Alignment failure | Reason claims only broad "glossary similarity" and "short codes" in sample data; this is moderate evidence and also indicates a possible domain mismatch (site_code vs building). Score appears potentially generous for a conceptually different field without explicit confirmation. |
| EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name | 41 | Alignment failure | Reason cites "glossary similarity" and that both are "descriptive text"—this is extremely weak and does not establish semantic equivalence (product name vs process step name). Score is near-threshold; reason should explicitly state speculative/inferred nature and why it is still considered a match candidate. |
| EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.product_code | 80 | Alignment failure | Reason explicitly states **different concepts** ("sku is supply chain code" vs "product_code is site-local code") and implies a crosswalk is needed. That supports a mid-band score (requires reference mapping), not entry into the ≥80 high band unless a proven reference table/crosswalk exists. |
| EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.step_name | 45 | Alignment failure | Reason again relies on generic "glossary similarity" and "descriptive text" while mapping two likely different concepts (dosage form vs step name). Score may be too high given the lack of concrete semantic evidence. |
| EnterpriseAnalytics.fact_batch_summary.enterprise_batch_id → LexingtonSite.batch_run.batch_id | 91 | Alignment failure | Reason provides name similarity + glossary, but no evidence that **enterprise** batch id and local batch id are the same identifier namespace (could be different IDs). High-band score needs explicit confirmation of shared identifier semantics or a demonstrated crosswalk. |
| EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id | 60 | Alignment failure | Reason asserts "facility_key links to equip_id" but gives no basis for that relationship (facility vs equipment). Sample data described as "numeric/site code" is vague. Mid-band score is plausible, but the reason needs explicit linkage evidence (FK relationship, mapping table, or definition) to justify even mid confidence. |
| EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code | 83 | Alignment failure | Reason says product_key "links to" product_code, implying surrogate-to-business-key mapping. Without explicit evidence (surrogate key definition, reference table, or example join), high-band score is likely too generous. |
| EnterpriseAnalytics.fact_batch_summary.deviation_count → LexingtonSite.deviation_event.deviation_id | 48 | Alignment failure | Reason compares a **count** to an **identifier** (deviation_count ≈ deviation_id). These are different measures. Even if aggregation is intended, the reason should state how deviation_count is derived from deviation_id (e.g., COUNT(deviation_id) per batch) and that it is not a direct column equivalence. Score is generous for a non-equivalent pairing. |
| EnterpriseAnalytics.fact_batch_summary.source_site_code → LexingtonSite.equipment.building | 53 | Alignment failure | Reason relies on "glossary similarity" and short code patterns, but does not establish that a site code equals a building field. Needs explicit definition or examples; otherwise score may be too high for a speculative mapping. |
| EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct → LexingtonSite.batch_run.yield_pct | 92 | Alignment failure | Reason cites only "glossary similarity" and both as percentages; however the source is explicitly an **average** while the target is a per-batch yield. High-band score requires explicit confirmation that target is the measure being averaged and that the aggregation context/grain matches. |

### Recommendations

1. **For EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.building (62):**
   - Strengthen the reason with checkable evidence: provide glossary excerpts showing that `equipment.building` is actually a site/building code aligned to `site_code`, plus 3–5 sample value overlaps.
   - If `building` is a physical building name/label rather than a site code, downgrade the score and move this to "needs business review" or "no match".

2. **For EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name (41):**
   - Update the reason to explicitly state this is a **weak/inferential** candidate match and why it was proposed (e.g., limited columns available), or remove it.
   - Re-score as "unmatched" unless there is explicit documentation that `step_name` represents a product name at this site.

3. **For EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.product_code (80):**
   - Either (a) provide evidence of a validated crosswalk/reference table mapping SKU ↔ product_code (and cite it in the reason), or (b) reduce the score to the mid band (40–79) because the reason itself states the codes differ by domain.

4. **For EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.step_name (45):**
   - Replace the generic reason with a concrete semantic basis (definition excerpts or sample values demonstrating step_name contains dosage form values).
   - If no such evidence exists, remove this mapping and treat `dosage_form` as unmatched/new canonical attribute.

5. **For EnterpriseAnalytics.fact_batch_summary.enterprise_batch_id → LexingtonSite.batch_run.batch_id (91):**
   - Confirm identifier equivalence: document whether Lexington `batch_id` is the enterprise-wide identifier or a local identifier.
   - If local vs enterprise differs, add an explicit transformation/crosswalk and reduce score unless crosswalk exists.

6. **For EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id (60):**
   - Provide the specific evidence type missing: ERD/FK relationship, mapping table name, or definition stating facility_key represents equipment at Lexington.
   - If `facility_key` is a surrogate key for `dim_facility` and `equip_id` is an operational equipment identifier, re-map to the correct business key (e.g., `facility_id`) rather than the surrogate.

7. **For EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code (83):**
   - Clarify in the reason whether `product_key` is a surrogate and how it resolves to a business identifier; cite the join path (e.g., fact_batch_summary.product_key → dim_product.product_id → batch_run.product_code).
   - If this is a multi-hop mapping, keep the match but reduce the score unless validated with sample join results.

8. **For EnterpriseAnalytics.fact_batch_summary.deviation_count → LexingtonSite.deviation_event.deviation_id (48):**
   - Correct the mapping intent: this is not a column match; it is a **derived metric** (COUNT of deviation_id). Update Section 2 reason to state aggregation logic and grain explicitly.
   - Consider removing as a "match" and instead document as a transformation/derivation requirement; adjust score downward if it remains listed as a direct match.

9. **For EnterpriseAnalytics.fact_batch_summary.source_site_code → LexingtonSite.equipment.building (53):**
   - Provide a concrete mapping basis: show that `building` contains site codes (not building names) and list overlapping values.
   - If ambiguous, keep in mid band but add "needs validation" language; otherwise lower score/remove.

10. **For EnterpriseAnalytics.fact_yield_analysis.avg_yield_pct → LexingtonSite.batch_run.yield_pct (92):**
   - Update the reason to reflect the aggregation relationship: explicitly state `avg_yield_pct = AVG(batch_run.yield_pct)` over a defined grouping (time period, product, facility, etc.).
   - If the aggregation grouping is unknown or the target yield_pct is not the measure being averaged, reduce the score to mid band and mark as requiring analytical validation.

### Review Process and Findings (Audit Trail)

1. **Extracted Section 1 score bands** from the report summary (≥80 high, 40–79 mid) and used these as the only band definitions.
2. **Reviewed all 19 Section 2 rows** and evaluated:
   - **Meaningfulness:** whether each reason provides specific, checkable evidence types (name similarity, glossary/definition, sample data, type/format).
   - **Alignment:** whether the strength/clarity of the stated evidence supports the assigned score band.
3. **Findings:**
   - All reasons were **present and specific enough** to be considered meaningful (they cite at least one evidence type).
   - 10 rows show **score alignment gaps**, primarily where (a) the reason is speculative/generic despite mid scores, or (b) the reason indicates surrogate/business-key or aggregation relationships yet the score is in the high band without explicit validation.
4. **Compliance note:** No internal contradictions were detected where the reason explicitly states "not a match" while a score is high; however, multiple rows express conceptual differences (e.g., SKU vs product_code) without sufficient validation for high scores.
