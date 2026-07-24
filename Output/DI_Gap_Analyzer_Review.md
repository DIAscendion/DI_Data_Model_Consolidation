## Check 1.1 — Match Reasons Meaningfulness & Score Alignment Review

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 21 |
| Meaningful reasons | 21 / 100% |
| Aligned with score | 13 / 61.9% |
| Rows passing both checks | 13 / 61.9% |
| Rows with internal contradictions | 6 |
| Overall Check 1.1 result | Fail |

**Score bands derived from Section 1 summary:**
- High band: **≥80%**
- Mid band: **40–79%**
- Below-threshold / not mapped: **<40%** (not in scope for Section 2)

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Enterprise Analytics Data Mart.dim_facility.city → Lexington Site Operational Data Mart.equipment.building | 65 | Alignment failure | Internal contradiction: reason states **“city vs. building”** and only provides an inference from name/type with non-equivalent sample values (“Building-1/2”). This is weak evidence and should not score mid-band without a clear mapping basis.
| Enterprise Analytics Data Mart.dim_facility.state_region → Lexington Site Operational Data Mart.equipment.building | 60 | Both (Meaningfulness + Alignment) | Reason claims “glossary similarity” and “name similarity,” but **does not state any actual shared definition/term** and maps two different concepts (state/region vs building). Contradictory semantics; score appears too generous.
| Enterprise Analytics Data Mart.dim_facility.country_code → Lexington Site Operational Data Mart.equipment.building | 42 | Alignment failure | Reason explicitly notes concepts are not comparable (“building is site-local”) and relies on inference only; borderline mid-band score (42) is too generous given the stated mismatch.
| Enterprise Analytics Data Mart.dim_facility.timezone_name → Lexington Site Operational Data Mart.equipment.updated_at | 45 | Alignment failure | Internal contradiction: timezone name (e.g., EST/EDT) is a **time zone descriptor**, while updated_at is a **timestamp**. “Both time-related” is too generic; evidence supports at best a weak/conditional relationship, not a direct match.
| Enterprise Analytics Data Mart.dim_facility.effective_end_date → Lexington Site Operational Data Mart.equipment.calibration_due | 60 | Alignment failure | Internal contradiction: “effective end date” (record validity) is not necessarily equivalent to “calibration due” (maintenance schedule). Reason provides only broad “end/expiration dates” without confirming semantic equivalence.
| Enterprise Analytics Data Mart.dim_product.product_name → Lexington Site Operational Data Mart.batch_run.step_name | 52 | Alignment failure | Internal contradiction: product name vs process step name are different domains. Reason is inference from type (“both text”) and is insufficient for mid-band without a stated business rule tying step names to product names.
| Enterprise Analytics Data Mart.dim_product.sku → Lexington Site Operational Data Mart.batch_run.product_code | 43 | Alignment failure | Reason is inferential and does not establish equivalence between SKU and product_code (could be different identifiers/granularities). Mid-band score is too generous without code-set overlap or explicit glossary confirmation.
| Enterprise Analytics Data Mart.dim_product.dosage_form → Lexington Site Operational Data Mart.batch_run.step_name | 40 | Alignment failure | Internal contradiction: dosage form (product attribute) vs step name (process attribute). Score is at the minimum mid-band but reason reads as a speculative association; should be treated as near-threshold/needs review rather than an accepted match.

**Rows not flagged (pass both):**
- dim_facility.facility_id → equipment.equip_id (90)
- dim_facility.facility_name → equipment.equip_name (87)
- dim_facility.effective_start_date → equipment.install_date (82)
- dim_facility.current_flag → equipment.status (70)
- dim_product.product_id → batch_run.product_code (88)
- fact_batch_summary.batch_status → batch_run.batch_status (92)
- fact_batch_summary.planned_qty → batch_run.planned_qty (95)
- fact_batch_summary.actual_qty → batch_run.actual_qty (95)
- fact_batch_summary.qty_unit → batch_run.qty_unit (93)
- fact_batch_summary.yield_pct → batch_run.yield_pct (90)
- fact_batch_summary.deviation_count → deviation_event.deviation_id (40) *(weak but explicitly positioned as deviation-related and implies aggregation)*
- fact_batch_summary.source_site_code → equipment.line_id (55) *(mid-band with inference; acceptable but should be validated)*
- fact_batch_summary.loaded_at_utc → equipment.updated_at (80) *(time field alignment with transformation to UTC)*

### Recommendations

1) **For dim_facility.city → equipment.building (65):**
   - Re-score to **near-threshold** unless a **documented reference table** exists that maps cities to specific buildings. Update reason to cite the specific evidence (e.g., “Facility building is stored in `equipment.building`; city is derived from building via ref table X; validated on N sample records”).

2) **For dim_facility.state_region → equipment.building (60):**
   - Replace the current reason with a concrete basis or mark as **not a valid match**. If “glossary similarity” is claimed, include the exact glossary terms/definitions referenced and explain how building represents state/region.
   - If no evidence exists, **remove the match** and leave state_region unmapped or map to a more appropriate target attribute.

3) **For dim_facility.country_code → equipment.building (42):**
   - Treat as **not mapped / needs manual review** unless a separate target attribute (e.g., `country_code`, `site_country`) exists.
   - If the intent is to derive country from facility/site, update the mapping to the correct target column and state the derivation rule explicitly.

4) **For dim_facility.timezone_name → equipment.updated_at (45):**
   - Split into two concepts: timezone_name should map to a **time zone field**, not a timestamp.
   - If updated_at must be converted using a time zone, document the assumption (e.g., “updated_at is stored in local site time; site timezone is derived from facility table; conversion validated”). Otherwise, **remove this as a match**.

5) **For dim_facility.effective_end_date → equipment.calibration_due (60):**
   - Confirm whether effective_end_date represents **equipment retirement/expiry** or **record SCD end-date**. If it is SCD validity, it should **not** map to calibration_due.
   - Only keep mid-band score if the reason provides explicit semantics (definition) and sample value alignment.

6) **For dim_product.product_name → batch_run.step_name (52):**
   - Require explicit evidence: show that step_name values are actually product names or contain product identifiers, and cite examples.
   - If step_name is a process step, remove the match and instead consider mapping product_name to a true product descriptor field.

7) **For dim_product.sku → batch_run.product_code (43):**
   - Add evidence of **code-set overlap** (e.g., same patterns/values, shared master data reference) or glossary confirmation of equivalence.
   - If product_code is broader/narrower than SKU, adjust transformation and score (or mark as needs review).

8) **For dim_product.dosage_form → batch_run.step_name (40):**
   - Mark as **conditional/low-confidence** and adjust reason to explicitly state weakness (e.g., “weak association; requires business confirmation”).
   - Prefer mapping dosage_form to a formulation attribute if present; otherwise, leave unmapped and propose canonical attribute addition.
