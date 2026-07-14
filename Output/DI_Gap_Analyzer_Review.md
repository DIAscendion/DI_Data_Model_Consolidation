### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 19 |
| Meaningful reasons | 19 / 100% |
| Aligned with score | 11 / 57.9% |
| Rows passing both checks | 11 / 57.9% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | Fail |

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.building | 62 | Alignment failure | Mid-band score but reason is too thin/underspecified: says “glossary similarity” without stating shared definition terms; “sample data shows both as short codes” is vague (no pattern/examples). Evidence level reads closer to low-band and needs explicit uncertainty. |
| EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name | 41 | Alignment failure | Low-band score but reason lacks “weak/speculative” framing and relies on a broad statement (“both descriptive text”) that does not establish semantic equivalence between product name and process step name. Should either strengthen evidence or treat as a tentative candidate with clearer uncertainty. |
| EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.product_code | 80 | Alignment failure | High-band score but reason indicates a conceptual mismatch: SKU is “supply chain code” while product_code is “site-local code.” That reads as related-but-not-equivalent, suggesting the score is too generous unless there is explicit crosswalk/overlap evidence (e.g., code-set mapping coverage). |
| EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.step_name | 45 | Alignment failure | Low-band score but reason is not meaningfully tied to the pair: “dosage_form ≈ step_name” is semantically inconsistent; “both descriptive text” is generic and does not justify even a tentative match without stronger domain explanation. |
| EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id | 60 | Alignment failure | Mid-band score but reason asserts a relationship (“facility_key links to equip_id”) without providing a basis (e.g., foreign key reference, lookup, shared keyspace). Also mixes types (“numeric/site code”) without stating compatibility, so evidence is insufficiently substantiated for mid-band. |
| EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code | 83 | Alignment failure | High-band score but reason is indirect (“product_key links to product_code”) and does not state the linkage evidence (surrogate vs natural key, reference table, or sample overlap). High score needs stronger confirmation than generic “glossary similarity.” |
| EnterpriseAnalytics.fact_batch_summary.deviation_count → LexingtonSite.deviation_event.deviation_id | 48 | Alignment failure | Low/mid score but reason suggests an incorrect conceptual match: deviation_count (a count/measure) versus deviation_id (an identifier). This undermines the mapping logic; if anything, a count would derive from IDs via aggregation, not map to an ID directly. Score should be lower or mapping reframed as derivation rather than column equivalence. |
| EnterpriseAnalytics.fact_batch_summary.source_site_code → LexingtonSite.equipment.building | 53 | Alignment failure | Mid-band score but evidence is weakly stated (“site code/short name”) and does not confirm that “building” is actually a site code rather than a building name. Needs clearer definition alignment or sample value overlap; otherwise score appears generous. |

No rows were flagged for Meaningfulness failure because every reason cites at least one concrete evidence type (name similarity, glossary/definition, sample/format). All flagged rows are Alignment failures where the strength/clarity of stated evidence does not match the assigned score band.

### Recommendations

1. **EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.building (Score 62):** Update the reason to include specific shared definition terms (e.g., “building code,” “site location code”) and provide a concrete sample pattern/example values. If such evidence cannot be provided, downgrade the score toward the low band or mark as “needs business review.”

2. **EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name (Score 41):** Either (a) revise the reason to explicitly state this is a **tentative/weak** match and why (e.g., only both are free-text fields, no semantic confirmation), or (b) provide stronger semantic evidence (process step name list aligning to product names) and then adjust the score accordingly.

3. **EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.product_code (Score 80):** Because the reason states different code systems (SKU vs site-local code), either lower the score into the mid band or add explicit evidence of equivalence (coverage stats from a reference/crosswalk table, sample value overlap rate, or confirmed business rule that product_code is SKU at this site).

4. **EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.step_name (Score 45):** Reassess the mapping: if dosage_form is a product attribute and step_name is a process attribute, treat as **not a direct match**. Replace with an appropriate target (if any) or keep as unmatched. If retained as a candidate, rewrite the reason to explain the domain logic and mark as speculative; adjust score down if evidence remains weak.

5. **EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id (Score 60):** Provide concrete linkage evidence (e.g., documented lookup table, FK relationship, or sample join success rate). If facility_key is a surrogate key and equip_id is a natural key, clarify the bridging mechanism and keep score mid only if the bridge is validated.

6. **EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code (Score 83):** Add evidence demonstrating that product_key can be resolved deterministically to product_code (reference table existence, uniqueness, sample join results). If it is only a surrogate key with no confirmed bridge, reduce the score to mid band.

7. **EnterpriseAnalytics.fact_batch_summary.deviation_count → LexingtonSite.deviation_event.deviation_id (Score 48):** Correct the mapping type: treat deviation_count as a **derived measure** (COUNT of deviation_id by batch/other grain) rather than a column-to-column match. Update Section 2 to reflect a derivation rule and consider removing as a “match pair” if the report intends only direct equivalence mappings.

8. **EnterpriseAnalytics.fact_batch_summary.source_site_code → LexingtonSite.equipment.building (Score 53):** Clarify whether LexingtonSite.equipment.building is a code vs a name. If it is a name, this may require a lookup (code-to-name) or may not be equivalent. Provide sample value overlap/pattern evidence and adjust score down if only loosely related.

### Compliance Log

| Timestamp | Action | Detail |
|---|---|---|
| 2026-07-14T00:00:00Z | GitHub File Reader invoked | Source: `Output/DI_Model_Gap_Analyzer.md` |
| 2026-07-14T00:00:00Z | Section 2 rows extracted | Row count: 19 |
| 2026-07-14T00:00:00Z | Evaluation completed | Meaningfulness + alignment checks applied to all 19 rows using Section 1 bands (≥80 high; 40–79 mid; <40 none) |
| 2026-07-14T00:00:00Z | Discrepancies documented | Count: 8 |
| 2026-07-14T00:00:00Z | GitHub File Writer invoked | Destination: `Output/DI_Gap_Analyzer_Review.md` |