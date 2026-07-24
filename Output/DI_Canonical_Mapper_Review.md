### Review Summary

| Metric | Detail |
|---|---|
| Total rows evaluated | 19 |
| Meaningful transformation rules | 19 / 100% |
| Aligned with inputs | 12 / 63.2% |
| Rows passing both checks | 12 / 63.2% |
| PII rows missing a masking/tokenization step | 0 |
| Overall check result | Fail |

---

### Gap Analysis Report

| Entity.Attribute | Source Column(s) | Transformation Rule | Issue Type | Description |
|---|---|---|---|---|
| Facility.City | EnterpriseAnalyticsDataMart.dim_facility.city; LexingtonSite_DataMart.equipment.building | "Map city to building via reference table; cast VARCHAR(100) to VARCHAR(50)" | Alignment failure | Source semantics appear mismatched: a source named **city** is being mapped to a source named **building**. The rule relies on an unspecified “reference table” to bridge two conceptually different fields. Without stated evidence that `equipment.building` contains city values (or that the reference table is authoritative for this translation), alignment is not supported by the inputs shown. |
| Facility.Country Code | EnterpriseAnalyticsDataMart.dim_facility.country_code; LexingtonSite_DataMart.equipment.manufacturer | "Map ISO country code to manufacturer country via lookup; cast CHAR(2) to VARCHAR(100)" | Both (Meaningfulness + Alignment failure) | (1) Alignment: mapping **country_code** to **manufacturer** is not supported by the column names; `manufacturer` suggests an organization name, not a country. (2) Meaningfulness: the rule asserts “manufacturer country” but no such source column is listed; the lookup logic and target value being produced are underspecified relative to the provided inputs. |
| Product.Product Name | EnterpriseAnalyticsDataMart.dim_product.product_name; LexingtonSite_DataMart.batch_run.step_name | "Map product_name to step_name via lookup; cast VARCHAR(150) to VARCHAR(100)" | Alignment failure | Source columns appear to represent different concepts (**product name** vs **process step name**). The rule’s lookup is not justified by the inputs shown; no shared key or stated reference dataset is provided in the row to support this mapping.
|
| Product.SKU | EnterpriseAnalyticsDataMart.dim_product.sku; LexingtonSite_DataMart.batch_run.batch_id | "Map sku to batch_id via lookup; cast VARCHAR(60) to VARCHAR(50)" | Alignment failure | Source columns appear to represent different identifiers (**SKU** vs **Batch ID**). The transformation depends on an unspecified lookup that is not supported by the row’s stated inputs.
|
| Batch.Facility Key | EnterpriseAnalyticsDataMart.fact_batch_summary.facility_key; LexingtonSite_DataMart.batch_run.equip_id | "Cast NUMBER to VARCHAR(30); lookup table for mapping" | Both (Meaningfulness + Alignment failure) | (1) Alignment: mapping a **facility** key to an **equipment** id is not supported by the column names; the relationship is unclear from inputs. (2) Meaningfulness: “lookup table for mapping” is too vague to be implementable (no lookup name, join keys, precedence, or cardinality/uniqueness rules).
|
| Batch.Product Key | EnterpriseAnalyticsDataMart.fact_batch_summary.product_key; LexingtonSite_DataMart.batch_run.product_code | "Cast NUMBER to VARCHAR(50); lookup table for mapping" | Meaningfulness failure | The lookup portion is not implementable as stated (“lookup table for mapping” is unspecified). Casting alone does not describe how a numeric surrogate key becomes a product code; the mapping logic (lookup dataset and join keys) is missing.
|
| Deviation.Deviation Count | EnterpriseAnalyticsDataMart.fact_batch_summary.deviation_count; LexingtonSite_DataMart.deviation_event.deviation_id | "Map deviation_count to deviation_id via aggregation; cast NUMBER to VARCHAR(50)" | Both (Meaningfulness + Alignment failure) | (1) Alignment: a **count** does not align to an **id**. (2) Meaningfulness: “via aggregation” is underspecified—missing group-by grain (batch? run? facility?), aggregation function, and how an ID becomes a count (or vice versa). Casting NUMBER to VARCHAR further conflicts with the stated “count” concept.
|
| Batch.Source Site Code | EnterpriseAnalyticsDataMart.fact_batch_summary.source_site_code; LexingtonSite_DataMart.equipment.line_id | "Map site_code to line_id via lookup; cast VARCHAR(20) to VARCHAR(30)" | Alignment failure | Source semantics appear mismatched: **site code** vs **line id**. The rule depends on an unspecified lookup not supported by the inputs shown, and does not explain the relationship (site→line) or the governing reference.
|
| Batch.Loaded At UTC | EnterpriseAnalyticsDataMart.fact_batch_summary.loaded_at_utc; LexingtonSite_DataMart.equipment.updated_at | "Reformat timestamp from UTC to US/Eastern using timezone conversion" | Alignment failure | The rule applies a UTC→US/Eastern conversion, but the input does not state that either source column is in UTC, nor the data types/formats (TIMESTAMP vs VARCHAR). Also, the canonical attribute name is “Loaded At UTC” while the rule converts away from UTC, creating a naming/logic mismatch based solely on the row text.

---

### Recommendations

1. **Facility.City**: Confirm the intended canonical meaning (City vs Building). If canonical is *City*, remap `LexingtonSite_DataMart.equipment.building` only if it truly contains city values; otherwise, change the source to a city-like column or rename the canonical attribute to reflect “Building”. If a reference table is required, specify: reference table name, join key(s), and transformation direction.

2. **Facility.Country Code**: Re-evaluate the second source column. If the intent is “manufacturer country”, replace `equipment.manufacturer` with the correct source column (e.g., `manufacturer_country` if it exists). Update the rule to be executable by stating the exact lookup (table), join keys, and code system (ISO-3166-1 alpha-2 to full country name, etc.).

3. **Product.Product Name**: Do not map `product_name` to `batch_run.step_name` unless the row can cite a governing reference that relates product names to step names. If a lookup is valid, specify lookup dataset and join keys (e.g., `product_code` + `step_sequence`) and whether the mapping is 1:1 or many:1.

4. **Product.SKU**: Remove/replace the mapping to `batch_id`. If SKU must be derived from batch context, specify the derivation (pattern, concatenation, or a concrete lookup keyed by `batch_id`), and confirm that the canonical attribute should be SKU rather than Batch ID.

5. **Batch.Facility Key**: Clarify whether the canonical attribute is a *Facility* identifier or an *Equipment* identifier. If it is facility-related, source it from a facility/site column rather than `equip_id`, or explicitly define the equipment→facility relationship via a named reference table and join keys. Provide lookup table name and ensure the cast aligns to the target datatype.

6. **Batch.Product Key**: Replace the vague “lookup table for mapping” with a concrete, implementable rule: identify the mapping table/view, specify join keys (e.g., `dim_product.product_key` ↔ `dim_product.product_id` ↔ `batch_run.product_code`), and define precedence/null-handling.

7. **Deviation.Deviation Count**: Correct the mapping logic: if canonical is a *count*, derive it as `COUNT(DISTINCT deviation_id)` (or COUNT(*)) from `deviation_event` grouped by the correct grain (e.g., `batch_id`). If canonical is an *id*, rename the canonical attribute to “Deviation ID” and remove the aggregation/casting mismatch.

8. **Batch.Source Site Code**: Validate whether `equipment.line_id` is truly a site code. If a lookup is required (site→line), specify the exact reference, join keys, and whether the mapping is deterministic. Otherwise, map from an actual site/source-system site code column.

9. **Batch.Loaded At UTC**: Align attribute naming and rule: either (a) keep canonical as UTC and ensure both sources are converted/normalized **to UTC** (preferred for auditability), or (b) rename canonical attribute to “Loaded At Local Time”/“Loaded At US/Eastern”. In both cases, specify source datatype/format handling (TIMESTAMP vs string parsing) and explicitly state the assumed source timezone for each input column.
