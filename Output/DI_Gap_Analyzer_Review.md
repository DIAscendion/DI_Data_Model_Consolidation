## Check 1.1 — Match Reasons Meaningful and Aligned with Score

### Review Summary

| Metric | Detail |
|---|---|
| Input reviewed | `Output/DI_Model_Gap_Analyzer.md` (Section 2 — Column Matches) |
| Total Section 2 rows evaluated | 39 |
| Meaningful reasons | 39 / 39 (100%) |
| Band label matches numeric score range | 39 / 39 (100%) |
| Reasons aligned with score | 38 / 39 (97.4%) |
| Rows passing both checks | 38 / 39 (97.4%) |
| Rows with internal contradictions | 0 |
| Advisory observations (aligned but low-confidence) | 5 items (rows 6; 21-22; 24; 31-38) |
| Overall Check 1.1 result | Pass (with minor recommendations) |

### Gap Analysis Report

**Score bands (from Section 1 of the Gap Analyzer report):**
- **Strong: 85-100**
- **Probable: 60-84**
- **Possible: 40-59**
- **Excluded: <40** (not present in Section 2)

All 39 reasons cite concrete, multi-signal evidence (Name, Semantic, Pattern, and — where relevant — Transform), so none fail the meaningfulness test. All 39 band labels correctly match their numeric scores, and the 7 Strong / 13 Probable / 19 Possible split matches Section 1. The rows below are the only ones where the reason and the score are not fully aligned or warrant a caution for downstream consumers.

| Row Ref (Mart A Lexington → Mart B Enterprise) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Row 16 — batch_run.yield_pct → dim_product.standard_yield_pct | 64 | Alignment concern | The reason concedes the columns share a metric family but play "different roles": batch_run.yield_pct is an actual/observed fact measure, while dim_product.standard_yield_pct is a validated target/benchmark stored on a dimension. A 64 (mid-Probable) implies the pair is probably the same consolidatable attribute, which overstates a relationship the reason itself qualifies and which rests mainly on the shared "yield_pct" token plus identical NUMERIC(6,3) type. The score is optimistic relative to the stated evidence. |
| Row 6 — equipment.asset_type → fact_batch_summary.asset_class | 87 | Advisory (weakest Strong) | Placed in the Strong band (>=85) though the name signal is a synonym match ("asset_" root + type/class), not identical. Strong semantic agreement and genuine value overlap (Bioreactor, Filling Machine, Lyophilizer) justify a high score, but 87 assumes near-full name credit the reason does not fully substantiate. Aligned, but the weakest Strong. |
| Rows 21-22 — parameter_reading.ingested_at → fact_batch_summary.loaded_at_utc / fact_yield_analysis.loaded_at_utc | 58 | Advisory (narrative vs score) | The reason labels the semantic "near-identical glossary" (the strongest semantic signal) yet both rows sit at 58, just under the Probable threshold. The Possible placement is correct given weak name overlap ("_at" only) and the timezone/type difference, but the "near-identical" wording overstates the pair's overall strength. |
| Row 24 — batch_run.yield_pct → fact_yield_analysis.std_yield_pct | 57 | Advisory (name-driven) | A single batch/step yield is not the semantic equivalent of a standard-deviation statistic across many yields. The reason states this honestly and the low-Possible score is appropriate, but the match is carried by the shared "yield_pct" token rather than by semantics. |
| Rows 31-38 — equipment.updated_at / batch_run.created_at / deviation_event.created_at / shift_log.created_at → *.loaded_at_utc | 44-48 | Advisory (low-confidence cluster) | Eight audit-timestamp pairs match source record update/creation times to mart load/refresh times, driven by the shared "_at" token and TIMESTAMP type. The reasons correctly note the semantic divergence (source event time vs mart-load time) and all sit in the low Possible band, so they are aligned, but the volume of weak name-plus-type timestamp matches should be surfaced so they are not treated as semantic equivalences. |

### Recommendations

1. **Row 16 — batch_run.yield_pct → dim_product.standard_yield_pct (64):** Reclassify this pair to reflect the acknowledged role difference. Either lower the score into the low-Possible band or annotate it explicitly as a "benchmark/reference relationship, not a consolidation match," so the actual measure is not merged with the target/standard. If an actual-vs-standard comparison use case exists, model it as a derived KPI rather than a column equivalence.

2. **Row 6 — equipment.asset_type → fact_batch_summary.asset_class (87):** Document the name-similarity contribution for a synonym pair (type vs class) or recompute the name component so the Strong-band placement is fully evidenced. If the name signal is only partial, confirm the score is carried by the semantic + value-overlap evidence and consider whether the pair belongs at the top of Probable versus low Strong.

3. **Rows 21-22 — parameter_reading.ingested_at → *.loaded_at_utc (58):** Align the reason narrative with the sub-Probable score by stating that a strong semantic is offset by weak name overlap and a required timezone conversion. Avoid "near-identical" phrasing for a pair that lands in Possible, to prevent readers from over-trusting the match.

4. **Row 24 — batch_run.yield_pct → fact_yield_analysis.std_yield_pct (57):** Annotate as a name-driven candidate that is not a true semantic counterpart (individual value vs dispersion statistic). Confirm it should remain a proposed match at all, or drop it below threshold if a value-vs-statistic pairing is not useful for consolidation.

5. **Rows 31-38 — audit timestamps → *.loaded_at_utc (44-48):** Group these low-confidence audit-vs-load timestamp matches under an explicit caveat so downstream consumers do not treat "created_at/updated_at" as equivalent to "loaded_at_utc." Where a genuine load-time counterpart exists (e.g., parameter_reading.ingested_at, rows 21-22), prefer it and consider demoting the pure audit-field pairs.

### Review Process and Findings (Check 1.1)

1. **Extraction (Step 1):** Read `Output/DI_Model_Gap_Analyzer.md` fresh from branch `main` and extracted all 39 Section 2 rows, capturing each row's number, Score, Band, Mart A column (Lexington), Mart B column (Enterprise), and stated Reason.

2. **Meaningfulness assessment (Step 2):** Every reason cites at least two concrete signals (Name, Semantic, Pattern) with specifics — identical/shared tokens, glossary semantics, data-type/enumeration/value-domain evidence, and transform notes where applicable. No reason is empty, generic, or a placeholder. Result: 39/39 meaningful.

3. **Band-label verification (Step 3):** Confirmed every row's Band label matches the Section 1 bands (Strong 85-100, Probable 60-84, Possible 40-59). Rows 1-7 (94-86) are Strong, rows 8-20 (76-60) are Probable, and rows 21-39 (58-42) are Possible. The 7/13/19 counts match Section 1. Result: 39/39 correct.

4. **Score-alignment assessment (Step 4):** Judged whether each reason's evidence justifies its score without overstatement. 38 of 39 are aligned. One row (16) is optimistic: the reason concedes an actual-vs-benchmark role difference yet carries a mid-Probable score. No reason directly contradicts its own score (0 internal contradictions).

5. **Advisory observations (Step 5):** Flagged 5 aligned-but-noteworthy items (rows 6; 21-22; 24; 31-38) where the score sits correctly within band but the match is borderline, name-driven, or where narrative wording overstates a low-band pair. These are cautions, not failures.

6. **Outcome (Step 6):** Overall Check 1.1 result is **Pass (with minor recommendations)**. The Section 2 reasons are meaningful and, with one exception, aligned with their scores; the recommendations above tighten the single alignment concern and label the low-confidence matches.

### Compliance Log

- Input evaluated: `Output/DI_Model_Gap_Analyzer.md` (Section 2 — Column Matches), read from branch `main`.
- Rows evaluated: 39 (all Section 2 rows with a Score and Reason).
- Bands used: taken from the report's own Section 1 (Strong 85-100; Probable 60-84; Possible 40-59; excluded <40).
- Note: the prior version of this review file described a different, 21-row input and is superseded by this evaluation of the current 39-row report.
- Output written to: `Output/DI_Gap_Analyzer_Review.md`
