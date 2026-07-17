### Check 1.1 — Match Reasons Meaningfulness & Score Alignment Review

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 21 |
| Meaningful reasons | 21 / 100% |
| Aligned with score | 12 / 57.1% |
| Rows passing both checks | 12 / 57.1% |
| Rows with internal contradictions | 4 |
| Overall Check 1.1 result | Fail |

**Score bands derived from Section 1:**
- High band: **≥ 80**
- Mid band: **40–79**

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.line_id | 65 | Alignment failure | Reason cites “site/line codes” but concepts differ (site code vs production line ID). Evidence is not strong enough to justify a mid-score without an explicit crosswalk/business rule stating site_code maps to line_id. Contains an implicit contradiction risk (site vs line). |
| EnterpriseAnalytics.dim_facility.city → LexingtonSite.equipment.building | 48 | Alignment failure | Reason claims “facility location” similarity, but city and building are different granularities; transformation suggests concatenation, which implies not a like-for-like match. Score is likely too generous for a non-equivalent attribute unless canonical “location” field is explicitly defined. |
| EnterpriseAnalytics.dim_facility.country_code → LexingtonSite.equipment.manufacturer | 45 | Both (Meaningfulness + Alignment) | Reason states “Both reference country/manufacturer” which mixes unrelated concepts; cited “short codes” is not evidence of semantic match. Internal contradiction: country code (ISO) vs manufacturer (OEM) are different domains. |
| EnterpriseAnalytics.dim_facility.timezone_name → LexingtonSite.equipment.updated_at | 41 | Both (Meaningfulness + Alignment) | Reason asserts “timezone_name ≈ updated_at” and “both time-related” but does not explain how a timestamp maps to a timezone identifier; transformation implies extracting TZ info that is not indicated by the reason. Internal contradiction: timezone identifier vs event timestamp. |
| EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name | 46 | Alignment failure | Reason relies on both being “descriptive names” but does not justify mapping product name to a process step name; requires a business relationship (step name includes product) that is not evidenced. Internal contradiction risk (different entities). |
| EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.batch_id | 42 | Alignment failure | Reason says both are “codes” but SKU and batch/run ID are typically different identifiers; no evidence (pattern overlap, crosswalk, glossary equivalence) is provided to justify even a low-mid score. Internal contradiction risk (product vs batch). |
| EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.notes | 44 | Alignment failure | Reason says both are free text; that is weak and does not support a mapped attribute. Transformation proposes regex extraction, implying derivation rather than direct equivalence; score should reflect speculative/derived nature. |
| EnterpriseAnalytics.dim_product.therapeutic_class → LexingtonSite.batch_run.shift | 41 | Both (Meaningfulness + Alignment) | Reason claims both categorical but provides no semantic link; therapeutic class and shift are unrelated. Internal contradiction: product classification vs staffing schedule category. |
| EnterpriseAnalytics.dim_quality_disposition.disposition_code → LexingtonSite.batch_run.batch_status | 89 | Alignment failure | High score requires strong evidence; reason cites “status codes” and sample values overlap, but does not state that disposition_code is the same concept as operational batch status (quality disposition vs run status). Possible domain mismatch makes 89 too high without explicit glossary confirmation. |
| EnterpriseAnalytics.dim_quality_disposition.commercially_releasable → LexingtonSite.batch_run.batch_status | 61 | Alignment failure | Reason suggests “boolean/status values” but mapping a boolean releasable flag to multi-valued batch status is not equivalent. Needs explicit rule; otherwise score should be near-threshold or treated as derived. |
| EnterpriseAnalytics.dim_quality_disposition.deviation_implied → LexingtonSite.deviation_event.severity | 44 | Alignment failure | Reason acknowledges inference; mapping boolean “deviation implied” to severity levels is conceptually weak and requires business rule. Score should reflect speculative nature and/or contradiction (boolean vs ordinal severity). |
| EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id | 63 | Alignment failure | Reason is generic (“identifier values”) and does not establish that a facility surrogate key maps to an equipment ID. Without a declared crosswalk and grain alignment (facility vs equipment), score appears too high. |
| EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code | 84 | Alignment failure | High score is not supported: reason claims name similarity and glossary, but also indicates different key types (product_key suggests surrogate/integer vs product_code is code). Without explicit master-data key mapping evidence, 84 is too high. |

### Recommendations

1. **EnterpriseAnalytics.dim_facility.site_code → LexingtonSite.equipment.line_id (65):** Add explicit evidence (reference/crosswalk table, documented business rule) stating how site_code maps to line_id. If mapping is conditional or indirect, reduce score toward the low end of the mid band and label as “derived via lookup.”

2. **EnterpriseAnalytics.dim_facility.city → LexingtonSite.equipment.building (48):** Clarify the intended canonical attribute (e.g., “facility_location_label”). If the target is a building name and source is a city, treat as separate attributes or redesign as a derived composite; adjust score downward if not true equivalence.

3. **EnterpriseAnalytics.dim_facility.country_code → LexingtonSite.equipment.manufacturer (45):** Mark as **not a valid match** unless a documented rule exists (e.g., manufacturer codes encode country—which is not stated). Correct the reason to reflect the real domain relationship or remove the match; re-score to 0/unmatched if no evidence.

4. **EnterpriseAnalytics.dim_facility.timezone_name → LexingtonSite.equipment.updated_at (41):** Replace with a correct target column (e.g., a timezone field) or mark unmatched. If timezone must be inferred from site configuration rather than timestamp, update the reason to state that and change transformation accordingly.

5. **EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name (46):** Provide concrete evidence (examples showing step_name contains/derives product name, or a lookup tying steps to products). If not supported, remove/replace the match.

6. **EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.batch_id (42):** Require code-set/pattern overlap evidence or a mapping table. If sku and batch_id are distinct identifiers (likely), mark unmatched and eliminate the mapping.

7. **EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.notes (44):** Reclassify as an **attribute derivation** (text extraction) rather than a match. Lower the score and update the reason to explicitly state extraction is heuristic and needs validation.

8. **EnterpriseAnalytics.dim_product.therapeutic_class → LexingtonSite.batch_run.shift (41):** Remove as a match unless there is a stated business relationship; otherwise mark unmatched. Update matching logic to avoid mapping unrelated categorical fields.

9. **EnterpriseAnalytics.dim_quality_disposition.disposition_code → LexingtonSite.batch_run.batch_status (89):** Confirm via glossary/SME whether quality disposition codes are intended to equal operational batch status. If only partially related, lower score to mid band and specify mapping table and governance owner.

10. **EnterpriseAnalytics.dim_quality_disposition.commercially_releasable → LexingtonSite.batch_run.batch_status (61):** Split into a separate boolean attribute in the canonical model (commercially_releasable) and map batch_status through a derived rule only if defined. Otherwise mark unmatched.

11. **EnterpriseAnalytics.dim_quality_disposition.deviation_implied → LexingtonSite.deviation_event.severity (44):** Require an explicit rule (e.g., deviation_implied TRUE maps to severity ≥ medium) with examples; otherwise remove/mark unmatched and avoid boolean-to-severity mapping.

12. **EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id (63):** Provide the facility↔equipment grain alignment and the crosswalk source. If facility_key is a surrogate key without external meaning, match should be treated as derived via dimension join and scored lower.

13. **EnterpriseAnalytics.fact_batch_summary.product_key → LexingtonSite.batch_run.product_code (84):** Document the key mapping (surrogate-to-natural key relationship) and show sample join success or reference master data mapping. If not available, downgrade to mid band and explicitly state it is a lookup-based mapping.

### Review Process & Findings

- Evaluated **all 21 rows** in Section 2 by comparing each row’s **Match Score** to the specificity/strength of its **Reason for Matching**, using score bands derived from Section 1 (≥80 high; 40–79 mid).
- **Meaningfulness check:** All reasons contained at least one concrete evidence type claim (name similarity, glossary similarity, sample pattern/value references, or explicit inference). However, **3 reasons** were flagged under “Both” because their wording was conceptually incoherent (mixing unrelated domains) even though text existed.
- **Alignment check:** Many mid-band scores were assigned to mappings that are **derivations** (regex extraction, concatenation, lookups without cited authoritative crosswalk) or appear to link **different business entities** (product vs step, country vs manufacturer). These were flagged as alignment failures.
- **Internal contradictions (4 rows):** country_code→manufacturer, timezone_name→updated_at, therapeutic_class→shift, and (risk-level) product/step mappings where the reason implies equivalence but the attributes represent different domains.
