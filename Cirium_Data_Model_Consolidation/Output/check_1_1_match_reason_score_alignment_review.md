### Check 1.1 — Match Reason ↔ Score Alignment Review (Gap Analyzer QA)

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 54 |
| Meaningful reasons | 54 / 100% |
| Aligned with score | 50 / 92.6% |
| Rows passing both checks | 50 / 92.6% |
| Rows with internal contradictions | 1 |
| Overall Check 1.1 result | **Fail** |

**Score bands derived from Section 1:**
- **High band:** ≥80 (38 attributes mapped ≥80% match; used as “high” expectation)
- **Mid band:** 40–79
- **Unmapped threshold:** <40 (not in scope for Section 2)

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Redshift.dim_aircraft.delivery_year → Snowflake.aircraft_master.delivery_date | 90 | Alignment failure | Reason states only general “glossary similarity” plus type mismatch (year vs date). Evidence is partial and transformation is inferential (mapping year to 1st Jan). This reads **mid-strength**, not clearly high-band (≥80) certainty. |
| Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date | 90 | Alignment failure | Same pattern as above: conceptually related but granularity/type mismatch (year vs full date) and inferential transformation. Reason supports a **moderate** match; score appears too generous for high band. |
| Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id | 100 | Alignment failure | Score is perfect/exact, but reason indicates **ambiguity in data type/format** (“string/integer schedule IDs”) and transformation requires a lookup to map “schedule codes to integer IDs.” This is not consistent with an “exact match” score without stronger evidence. |
| Redshift.dim_route.region → Snowflake.airline_schedules.aircraft_type | 45 | **Both (Meaningfulness + Alignment) + Internal contradiction** | Reason is specific (“weak name similarity”), but explicitly states **different semantics** (“different semantics (best score: 45)”). That description undermines the match itself; the row reads like a “likely not a match / needs remap,” yet it is still presented as a match at 45 (mid band). If semantics differ, the mapping should be rejected or the target reconsidered. |

### Recommendations

1. **For Redshift.dim_aircraft.delivery_year → Snowflake.aircraft_master.delivery_date (Score 90):**
   - Re-score to the **40–79 band** unless additional evidence is provided (e.g., explicit glossary statement that delivery_date is stored as year-only in one system; sample values showing day/month defaults).
   - Update the reason to include **concrete verification**: sample value examples from both sides and/or a dictionary definition confirming acceptable “year-to-date” coercion.

2. **For Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date (Score 90):**
   - Re-score to **mid band (40–79)** or provide stronger evidence (e.g., lineage documentation or business rule stating retirement_year is derived from retirement_date).
   - If the year-to-date mapping is retained, document it explicitly as a **lossy/assumptive transformation** and require business sign-off.

3. **For Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id (Score 100):**
   - Reduce score to **high but not perfect** (e.g., 85–95) unless there is evidence that IDs are truly identical and stable across systems.
   - Strengthen the reason by stating which evidence confirms equivalence (e.g., **join validation** results, overlap % of IDs, or authoritative glossary statement). If a lookup is required, specify why (code vs ID) and treat as non-exact.

4. **For Redshift.dim_route.region → Snowflake.airline_schedules.aircraft_type (Score 45):**
   - **Reject this mapping** pending review: the reason states “different semantics,” which is an internal contradiction for a proposed match.
   - If “region” should map elsewhere (e.g., a geography/market region field), request the gap analyzer/mapping team to **identify a semantically appropriate target**. If none exists, move to Section 3 “Unmatched Columns” with a clear rationale.
   - If it remains as a candidate match for discussion, revise reason to include an explicit **hypothesis** linking the concepts (currently absent) and keep score **near-threshold** with “needs business review.”

