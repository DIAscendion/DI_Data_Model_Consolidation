## Check 1.1 — Match Reasons Meaningful and Aligned with Score

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 21 |
| Meaningful reasons | 21 / 100% |
| Aligned with score | 11 / 52.4% |
| Rows passing both checks | 11 / 52.4% |
| Rows with internal contradictions | 5 |
| Overall Check 1.1 result | Fail |

### Gap Analysis Report

**Score bands derived from Section 1 summary:**
- High band: **≥80**
- Mid band: **40–79**
- Not mapped: **<40** (no rows in Section 2)

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| EnterpriseAnalytics.dim_facility.city → LexingtonSite.equipment.building | 48 | Alignment failure (internal contradiction) | Reason claims “facility location,” but maps **city** (geography) to **building** (site structure). This is a cross-domain leap with only generic “free text ≈ free text” support; too generous for the stated evidence. |
| EnterpriseAnalytics.dim_facility.country_code → LexingtonSite.equipment.manufacturer | 45 | Both (internal contradiction) | Reason states “Both reference country/manufacturer” and then relies on “short codes (ISO, OEM)” **inferred from name/type**. The concepts are different (country vs manufacturer), and the evidence is speculative; mid-band score is too high given the contradiction and lack of direct overlap evidence. |
| EnterpriseAnalytics.dim_facility.timezone_name → LexingtonSite.equipment.updated_at | 41 | Both (internal contradiction) | Reason asserts “timezone_name ≈ updated_at” and “time-related fields” inferred from name/type. **Timezone** and **timestamp updated_at** are different semantics; the proposed transformation (“extract TZ info”) is speculative without sample values showing embedded TZ. Score should be lower or match should be rejected pending evidence. |
| EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name | 46 | Alignment failure (internal contradiction) | Reason treats product name and process step name as “descriptive names” inferred from name/type. This is not a direct semantic match; justification is weak and speculative for a mid-band score. |
| EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.batch_id | 42 | Alignment failure (internal contradiction) | Reason claims “sku ≈ batch_id” based only on “both codes” inferred from name/type. SKU (product-level identifier) and batch_id (run/batch identifier) are different entities; insufficient evidence for mid-band score. |
| EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.notes | 44 | Alignment failure | Reason relies on both being “free text” inferred from name/type and suggests regex extraction. This is a weak, extraction-based hypothesis and should be scored lower unless sample notes demonstrate consistent dosage-form embedding. |
| EnterpriseAnalytics.dim_product.therapeutic_class → LexingtonSite.batch_run.shift | 41 | Both | Reason claims categorical similarity inferred from name/type, but therapeutic class (medical/product classification) vs shift (operations schedule) are unrelated. Evidence does not support even a low-mid match; score is too generous. |
| EnterpriseAnalytics.dim_quality_disposition.disposition_name → LexingtonSite.batch_run.batch_status | 81 | Alignment failure | Score is in the high band (≥80) but reason is only “glossary similarity” + “descriptive names” without explicit confirmation that disposition_name values actually equal/align to batch_status codes/names (especially since multiple EA columns map to the same target column). Evidence described is weaker than expected for high-band score. |
| EnterpriseAnalytics.dim_quality_disposition.commercially_releasable → LexingtonSite.batch_run.batch_status | 61 | Alignment failure | A boolean “commercially_releasable” is mapped to a multi-valued status field. Reason says “boolean/status values” but provides no concrete mapping evidence (value set, rules, examples). Mid-band score is too high for a many-to-one semantic conversion without demonstrated business rule. |
| EnterpriseAnalytics.dim_quality_disposition.deviation_implied → LexingtonSite.deviation_event.severity | 44 | Alignment failure | Reason cites “boolean/severity codes” inferred from name/type, but deviation_implied (boolean implication) and severity (multi-level categorical) are not equivalent. Needs explicit mapping logic/evidence; score too generous. |
| EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id | 63 | Alignment failure | Reason is “inferred from name/type” with generic “identifier values.” Facility_key (facility dimension surrogate/key) vs equip_id (equipment identifier) is not clearly the same grain/entity; evidence is insufficient for a 63 score without crosswalk/foreign-key linkage evidence. |

### Recommendations

1. **EnterpriseAnalytics.dim_facility.city → LexingtonSite.equipment.building (48):**
   - Replace the reason with a verifiable basis (e.g., show a controlled-location hierarchy where “building” contains “city,” or provide sample join keys proving a consistent relationship).
   - If no direct semantic equivalence exists, **lower the score** (near-threshold) and label as “needs business review,” or remove as a proposed match.

2. **EnterpriseAnalytics.dim_facility.country_code → LexingtonSite.equipment.manufacturer (45):**
   - Resolve the semantic contradiction: either identify the correct target for country_code or provide evidence that manufacturer stores country-of-origin codes (with sample values showing ISO-like codes).
   - Until evidence is produced, **downgrade score below threshold** or mark as “no match.”

3. **EnterpriseAnalytics.dim_facility.timezone_name → LexingtonSite.equipment.updated_at (41):**
   - Provide sample values demonstrating timezone extraction feasibility (e.g., updated_at includes TZ offsets or named time zones).
   - Otherwise, treat as **no match** (or score <40) because timestamp fields are not time zone attributes.

4. **EnterpriseAnalytics.dim_product.product_name → LexingtonSite.batch_run.step_name (46):**
   - Provide evidence that step_name actually contains product names (e.g., standardized step naming convention embedding product), with examples.
   - If it is a process-step descriptor, **remove the match** and seek the proper product name source (or reduce score significantly).

5. **EnterpriseAnalytics.dim_product.sku → LexingtonSite.batch_run.batch_id (42):**
   - Provide a mapping artifact proving sku is encoded in batch_id (or vice versa) via stable parsing rules and sample overlap.
   - If they represent different entities, **mark as not a match** and do not map across grains.

6. **EnterpriseAnalytics.dim_product.dosage_form → LexingtonSite.batch_run.notes (44):**
   - Require at least several sample notes showing dosage form present in a consistent pattern before keeping the match.
   - If this is only a potential enrichment, **lower the score** and clearly label as “derived attribute from notes; requires NLP/regex validation.”

7. **EnterpriseAnalytics.dim_product.therapeutic_class → LexingtonSite.batch_run.shift (41):**
   - Treat as **incorrect match** unless a documented domain relationship exists (unlikely). Remove or score <40.
   - Re-run matching using domain constraints (clinical/product classification should not map to labor scheduling).

8. **EnterpriseAnalytics.dim_quality_disposition.disposition_name → LexingtonSite.batch_run.batch_status (81):**
   - For a high-band score, strengthen the reason with concrete evidence: explicit value-set alignment (e.g., disposition_name values list equals batch_status values list) or glossary statement that they are synonyms.
   - Consider whether multiple EA fields mapping to batch_status indicates ambiguity; if ambiguous, **reduce score to mid-band** until resolved.

9. **EnterpriseAnalytics.dim_quality_disposition.commercially_releasable → LexingtonSite.batch_run.batch_status (61):**
   - Document and validate the exact business rule (e.g., TRUE → COMPLETED/RELEASED, FALSE → ON_HOLD) with examples.
   - If batch_status has more states than the boolean can represent, reduce score or model commercially_releasable as a separate attribute.

10. **EnterpriseAnalytics.dim_quality_disposition.deviation_implied → LexingtonSite.deviation_event.severity (44):**
   - Provide evidence of how a boolean implies severity levels (mapping table, rules, or sample distributions).
   - If no such rule exists, remove match or score below threshold and request business review.

11. **EnterpriseAnalytics.fact_batch_summary.facility_key → LexingtonSite.batch_run.equip_id (63):**
   - Require a crosswalk demonstrating facility_key corresponds to an equipment/site identifier (or that equip_id is actually a facility/site id despite name).
   - If equip_id is equipment-grain and facility_key is facility-grain, treat as **non-equivalent** and find the correct facility identifier source; otherwise lower score and mark as “join required.”

### Review Process and Findings (Check 1.1)

1. **Extraction (Step 1):** Evaluated all **21** Section 2 match rows, capturing each row’s Source (Application.Table.Column), Target (Application.Table.Column), Match Score, and stated Reason for Matching.

2. **Meaningfulness assessment (Step 2):**
   - All 21 reasons contained at least one specific evidence type (e.g., name similarity, glossary similarity, sample data pattern, explicit example patterns, or an explicit “inferred from name/type” qualifier).
   - Therefore, **no rows failed meaningfulness** outright.

3. **Score alignment assessment (Step 3):**
   - Using the report’s own bands (≥80 high; 40–79 mid), **10 rows** were flagged for alignment issues.
   - Main failure modes:
     - **Cross-domain semantic mismatches** presented with mid-band scores (e.g., SKU vs batch_id; timezone vs updated_at).
     - **High-band score without strong multi-signal evidence** (e.g., 81 with only generic glossary similarity language and ambiguity due to multiple sources mapping to the same target).

4. **Discrepancy compilation (Step 4):**
   - Logged **11** discrepancies total.
   - **5** discrepancies include explicit internal contradictions where the reason itself describes different concepts/domains than the match implies.

5. **Recommendations (Step 5):**
   - Provided row-specific remediation actions: strengthen evidence (glossary/value-set/sample overlap), correct target selection, adjust scoring to reflect uncertainty, or remove incorrect matches.
