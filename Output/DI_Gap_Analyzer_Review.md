### Check 1.1 — Match Reasons Meaningful & Aligned with Score (Section 2 Only)

#### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 26 |
| Meaningful reasons | 26 / 100% |
| Aligned with score | 16 / 61.5% |
| Rows passing both checks | 16 / 61.5% |
| Rows with internal contradictions | 2 |
| Overall Check 1.1 result | Fail |

#### Score bands derived from Section 1 summary
- High band: **≥80**
- Mid band: **40–79**
- Unmapped threshold: **<40** (out of scope for Section 2)

---

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalyticsDataMart.dim_facility.city → LexingtonSite_DataMart.equipment.building | 68 | Alignment failure | Reason claims “location context” but the mapped concepts differ (city vs building). This is only a loose semantic association and the transformation implies non-trivial reference mapping; mid-band score may be acceptable, but the reason does not explain the relationship clearly enough for a 68 without stronger evidence (e.g., explicit site master mapping or shared location identifier). |
| EnterpriseAnalyticsDataMart.dim_facility.country_code → LexingtonSite_DataMart.equipment.manufacturer | 55 | Both (Meaningfulness + Alignment) | Internal contradiction: reason says “manufacturer location” but cites sample data of **country codes (US/DE/JP)** vs **manufacturer names** (different domains). The evidence presented actually argues against the match; a mid-band score is too generous given the stated mismatch. |
| EnterpriseAnalyticsDataMart.dim_product.product_name → LexingtonSite_DataMart.batch_run.step_name | 62 | Alignment failure | Reason states “product/process step” similarity, which indicates different business concepts. With only generic “free text” similarity, the rationale is weak for a 62; should be near-threshold unless additional evidence (process model mapping) is cited. |
| EnterpriseAnalyticsDataMart.dim_product.sku → LexingtonSite_DataMart.batch_run.batch_id | 65 | Alignment failure | Reason asserts “sku ≈ batch_id for site-local” but provides no checkable basis beyond “both codes.” SKU and batch identifiers are typically different entity keys; without explicit rule (e.g., site uses SKU as batch id), 65 is likely too high.
| EnterpriseAnalyticsDataMart.fact_batch_summary.facility_key → LexingtonSite_DataMart.batch_run.equip_id | 80 | Alignment failure | High-band score but reason is only “facility_key links to equipment” and notes numeric vs string. This is a cross-entity link (facility vs equipment) and needs stronger evidence (FK relationship, mapping table, or definition explicitly equating facility to equipment at Lexington) to justify 80.
| EnterpriseAnalyticsDataMart.fact_batch_summary.deviation_count → LexingtonSite_DataMart.deviation_event.deviation_id | 45 | Both (Meaningfulness + Alignment) | Internal contradiction: deviation_count is a count/measure, deviation_id is an identifier. Reason (“event tracking”) does not reconcile count vs id and the transformation suggests aggregation in the opposite direction. Mid-band score is too generous for a measure→ID mapping.
| EnterpriseAnalyticsDataMart.fact_batch_summary.source_site_code → LexingtonSite_DataMart.equipment.line_id | 50 | Alignment failure | Reason is “site context” but columns represent different grains (site vs production line). “Both codes” is insufficient support for 50 without explicit site-to-line mapping rationale.
| EnterpriseAnalyticsDataMart.dim_quality_disposition.disposition_code → LexingtonSite_DataMart.batch_run.batch_status | 70 | Alignment failure | Disposition code (quality disposition) vs batch operational status are different concepts. Reason provides only “quality state” similarity and “both codes,” which is not strong enough for 70 without a stated business mapping between disposition and status.
| EnterpriseAnalyticsDataMart.dim_quality_disposition.disposition_name → LexingtonSite_DataMart.deviation_event.deviation_desc | 60 | Alignment failure | Disposition name vs deviation description are different domains (disposition master vs event narrative). Reason is generic “description” similarity; 60 appears too high unless an explicit use-case is stated (e.g., disposition name stored as deviation description in Lexington).
| EnterpriseAnalyticsDataMart.dim_quality_disposition.requires_investigation → LexingtonSite_DataMart.deviation_event.severity | 65 | Alignment failure | Boolean “requires investigation” vs categorical “severity” mismatch. Reason cites “event escalation” and sample “TRUE/critical,” which is at best a weak inferred mapping; score likely too high without evidence that severity is derived from investigation flag.
| EnterpriseAnalyticsDataMart.dim_quality_disposition.commercially_releasable → LexingtonSite_DataMart.batch_run.batch_status | 50 | Alignment failure | Release eligibility boolean vs status code. Reason is speculative (“release eligibility”) with limited sample (“TRUE/completed”). Needs explicit business rule; otherwise 50 is too generous.
| EnterpriseAnalyticsDataMart.dim_quality_disposition.deviation_implied → LexingtonSite_DataMart.deviation_event.dev_status | 55 | Alignment failure | “Deviation implied” boolean vs deviation status. Reason is speculative (“for deviation event”) with sample “TRUE/open” but no stated derivation; 55 is likely too high.
| EnterpriseAnalyticsDataMart.dim_quality_disposition.description → LexingtonSite_DataMart.deviation_event.resolution_notes | 42 | Alignment failure | “Description” vs “resolution_notes” are related but not equivalent; reason doesn’t distinguish description-of-what (disposition master?) vs event resolution narrative. Near-threshold score is plausible, but reason should explicitly state the weak/partial nature and the assumed direction to be aligned.

---

### Recommendations

1. **(dim_facility.city → equipment.building, score 68)** Strengthen the reason by stating a concrete linkage (e.g., “Lexington building codes map 1:1 to city for this site” or “building contains city name in sample values”) and cite example values. If such linkage cannot be evidenced, **re-score downward** (near-threshold) or mark as unmatched.

2. **(dim_facility.country_code → equipment.manufacturer, score 55)** Resolve the domain mismatch. Either:
   - Change the target to a manufacturer **country/location** attribute if it exists, or
   - Update the reason to reflect an actual derivation (e.g., manufacturer name → country via reference data) and **re-score based on that evidence**. If only inference is available, **drop score toward threshold**.

3. **(dim_product.product_name → batch_run.step_name, score 62)** Provide explicit process evidence (e.g., step_name is populated with product name in Lexington) or a mapping artifact (process dictionary). If not available, **re-score lower** or remove the match.

4. **(dim_product.sku → batch_run.batch_id, score 65)** Require a documented business rule stating that Lexington’s batch_id equals SKU (or contains it). If the relationship is indirect (batch_id includes SKU), state the parsing rule and examples; otherwise **reduce score** and/or treat as unmatched.

5. **(fact_batch_summary.facility_key → batch_run.equip_id, score 80)** Because this is high band, update the reason to cite **direct evidence**: FK relationship, shared key space, or an authoritative mapping table. If facility_key maps to a facility (not equipment), find the correct Lexington facility field or **reduce score**.

6. **(fact_batch_summary.deviation_count → deviation_event.deviation_id, score 45)** Remove or correct this match: count measures should not map to identifiers. If intent is to derive deviation_count by counting deviation_id rows per batch, then the correct mapping is **deviation_event.deviation_id → deviation_count (aggregation)**; update the pairing and reason accordingly.

7. **(fact_batch_summary.source_site_code → equipment.line_id, score 50)** Clarify grain and mapping: if line_id encodes site, show example patterns and explicitly state the derivation. Otherwise, find a Lexington site column (or add one) and **re-score/replace**.

8. **(dim_quality_disposition.disposition_code → batch_run.batch_status, score 70)** Either provide an explicit crosswalk between disposition codes and batch statuses (with examples), or treat as **partial/indirect mapping** and reduce score substantially.

9. **(dim_quality_disposition.disposition_name → deviation_desc, score 60)** If the match is actually “both are descriptive text,” label it as weak and state the limitation, then **re-score near threshold**. If there is a real business rule (deviation_desc stores disposition name), cite it.

10. **(requires_investigation → severity, score 65)** Document the derivation logic (e.g., TRUE → critical, FALSE → minor) and the allowed severity codes; otherwise **reduce score** and mark as “needs review.”

11. **(commercially_releasable → batch_status, score 50)** Require evidence that batch_status encodes release eligibility; if not, map commercially_releasable to a dedicated release flag/indicator and **remove this match**.

12. **(deviation_implied → dev_status, score 55)** Replace with a target column representing a boolean implied flag if present; otherwise specify the derivation and reduce score.

13. **(description → resolution_notes, score 42)** Update the reason to explicitly state it is a weak/partial text-field mapping and what “description” refers to (disposition master vs event-level). If intended to map event description, locate the proper event description column; otherwise keep near-threshold but make the weakness explicit.
