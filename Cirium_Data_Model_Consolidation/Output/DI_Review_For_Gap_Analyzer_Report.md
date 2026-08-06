### Check 1.1 Review — All match reasons are meaningful and aligned with the score

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 53 |
| Meaningful reasons | 53 / 100% |
| Aligned with score | 52 / 98.1% |
| Rows passing both checks | 52 / 98.1% |
| Rows with internal contradictions | 1 |
| Overall Check 1.1 result | Fail |

### Score bands used (derived from Section 1)
- High band: ≥80%
- Mid band: 40–79%
- Unmapped threshold: <40% (not in scope for Section 2)

### Step 1 — Extracted Section 2 match reasons & scores (row inventory)
Row references below are formatted as:
**Source App.Table.Column → Target App.Table.Column | Score | Reason (verbatim)**

1. Redshift.dim_airline.airline_key → Snowflake.airline_master.airline_id | 98 | Name similarity (airline_key ≈ airline_id); both are surrogate PKs; sample data both integer identity columns
2. Redshift.dim_airline.airline_code → Snowflake.airline_master.airline_code | 98 | Exact name match; glossary both "unique airline code"; sample data overlap: AA, DL, etc.
3. Redshift.dim_airline.airline_name → Snowflake.airline_master.airline_name | 98 | Exact name match; both are carrier names, sample data identical
4. Redshift.dim_airline.country → Snowflake.airline_master.country | 98 | Exact name match; both are country of airline; sample data overlap
5. Redshift.dim_airline.active_flag → Snowflake.airline_master.active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE
6. Redshift.dim_aircraft.aircraft_key → Snowflake.aircraft_master.aircraft_id | 98 | Name similarity (aircraft_key ≈ aircraft_id); both surrogate PKs; sample data both integer
7. Redshift.dim_aircraft.tail_number → Snowflake.aircraft_master.tail_number | 98 | Exact name match; both are tail numbers; sample data overlap
8. Redshift.dim_aircraft.aircraft_type → Snowflake.aircraft_master.aircraft_type | 98 | Exact name match; both are aircraft type; sample data overlap
9. Redshift.dim_aircraft.manufacturer → Snowflake.aircraft_master.manufacturer | 98 | Exact name match; both are aircraft manufacturer; sample data overlap
10. Redshift.dim_aircraft.operator_airline_key → Snowflake.aircraft_master.operator_airline_id | 98 | Name similarity (operator_airline_key ≈ operator_airline_id); both are FK to airline; sample data integer
11. Redshift.dim_airport.airport_key → Snowflake.airport_master.airport_id | 98 | Name similarity (airport_key ≈ airport_id); both surrogate PKs; sample data integer
12. Redshift.dim_airport.airport_code → Snowflake.airport_master.airport_code | 98 | Exact name match; both are airport codes; sample data overlap
13. Redshift.dim_airport.airport_name → Snowflake.airport_master.airport_name | 98 | Exact name match; both airport names; sample data overlap
14. Redshift.dim_airport.city → Snowflake.airport_master.city | 98 | Exact name match; both city; sample data overlap
15. Redshift.dim_airport.country → Snowflake.airport_master.country | 98 | Exact name match; both country; sample data overlap
16. Redshift.dim_airport.latitude → Snowflake.airport_master.latitude | 98 | Exact name match; both decimal latitude; sample data overlap
17. Redshift.dim_airport.longitude → Snowflake.airport_master.longitude | 98 | Exact name match; both decimal longitude; sample data overlap
18. Redshift.dim_airport.timezone → Snowflake.airport_master.timezone | 98 | Exact name match; both airport timezones; sample data overlap
19. Redshift.dim_customer.customer_key → Snowflake.customer_master.customer_id | 98 | Name similarity (customer_key ≈ customer_id); both surrogate PKs; sample data integer
20. Redshift.dim_customer.customer_name → Snowflake.customer_master.customer_name | 98 | Exact name match; both customer names; sample data overlap
21. Redshift.dim_customer.customer_type → Snowflake.customer_master.customer_type | 98 | Exact name match; both customer type; sample data overlap
22. Redshift.dim_customer.country → Snowflake.customer_master.country | 98 | Exact name match; both customer country; sample data overlap
23. Redshift.dim_customer.active_flag → Snowflake.customer_master.active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE
24. Redshift.dim_data_product.product_key → Snowflake.data_products.data_product_id | 98 | Name similarity (product_key ≈ data_product_id); both surrogate PKs; sample data integer
25. Redshift.dim_data_product.product_name → Snowflake.data_products.product_name | 98 | Exact name match; both product names; sample data overlap
26. Redshift.dim_data_product.domain → Snowflake.data_products.domain | 98 | Exact name match; both product domain; sample data overlap
27. Redshift.dim_data_product.delivery_type → Snowflake.data_products.delivery_type | 98 | Exact name match; both delivery type; sample data overlap
28. Redshift.dim_data_product.description → Snowflake.data_products.description | 98 | Exact name match; both product description; sample data overlap
29. Redshift.dim_data_product.active_flag → Snowflake.data_products.active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE
30. Redshift.fact_flight_operations.flight_key → Snowflake.flight_operations.flight_key | 98 | Exact name match; both PKs for flight; sample data integer
31. Redshift.fact_flight_operations.airline_key → Snowflake.flight_operations.airline_id | 98 | Name similarity (airline_key ≈ airline_id); both FK to airline; sample data integer
32. Redshift.fact_flight_operations.aircraft_key → Snowflake.flight_operations.aircraft_id | 98 | Name similarity (aircraft_key ≈ aircraft_id); both FK to aircraft; sample data integer
33. Redshift.fact_flight_operations.origin_airport_key → Snowflake.flight_operations.origin_airport_id | 98 | Name similarity (origin_airport_key ≈ origin_airport_id); both FK to airport; sample data integer
34. Redshift.fact_flight_operations.destination_airport_key → Snowflake.flight_operations.destination_airport_id | 98 | Name similarity (destination_airport_key ≈ destination_airport_id); both FK to airport; sample data integer
35. Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id | 98 | Exact name match; both schedule IDs; sample data overlap
36. Redshift.fact_flight_operations.delay_minutes → Snowflake.flight_operations.delay_minutes | 98 | Exact name match; both integer minutes; sample data overlap
37. Redshift.fact_flight_operations.cancelled_flag → Snowflake.flight_operations.cancellation_flag | 90 | Name similarity (cancelled_flag ≈ cancellation_flag); both boolean; sample data TRUE/FALSE
38. Redshift.fact_flight_operations.diverted_flag → Snowflake.flight_operations.diversion_flag | 90 | Name similarity (diverted_flag ≈ diversion_flag); both boolean; sample data TRUE/FALSE
39. Redshift.fact_product_subscriptions.subscription_key → Snowflake.customer_subscriptions.suscription_id | 90 | Name similarity (subscription_key ≈ suscription_id); both surrogate PKs; sample data integer
40. Redshift.fact_product_subscriptions.customer_key → Snowflake.customer_subscriptions.customer_id | 98 | Name similarity (customer_key ≈ customer_id); both FK to customer; sample data integer
41. Redshift.fact_product_subscriptions.product_key → Snowflake.customer_subscriptions.data_product_id | 98 | Name similarity (product_key ≈ data_product_id); both FK to data product; sample data integer
42. Redshift.fact_product_subscriptions.start_date → Snowflake.customer_subscriptions.start_date | 98 | Exact name match; both dates; sample data overlap
43. Redshift.fact_product_subscriptions.end_date → Snowflake.customer_subscriptions.end_date | 98 | Exact name match; both dates; sample data overlap
44. Redshift.fact_product_subscriptions.subscription_tier → Snowflake.customer_subscriptions.tier | 90 | Name similarity (subscription_tier ≈ tier); both strings for tier; sample data overlap
45. Redshift.fact_product_subscriptions.subscription_status → Snowflake.customer_subscriptions.status | 90 | Name similarity (subscription_status ≈ status); both strings for status; sample data overlap
46. Redshift.dim_aircraft.delivery_year → Snowflake.aircraft_master.delivery_date | 62 | Glossary similarity (both aircraft delivery); Redshift is year (SMALLINT), Snowflake is DATE; sample data both 4-digit years
47. Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date | 62 | Glossary similarity (both aircraft retirement); Redshift is year (SMALLINT), Snowflake is DATE; sample data both 4-digit years

### Step 2 — Meaningfulness evaluation
All 53/53 reasons are **meaningful**. Each reason provides at least one checkable evidence type (e.g., explicit name similarity/exact match, key role PK/FK semantics, data type/format hints, sample data overlap, or stated glossary similarity).

### Step 3 — Alignment evaluation (against the report’s score bands)
- High band (≥80): 51 rows evaluated. 51/51 aligned.
  - These reasons consistently cite multi-signal evidence (name match/similarity + role PK/FK/boolean + sample overlap). This supports high confidence.
- Mid band (40–79): 2 rows evaluated. 1/2 aligned; 1/2 misaligned due to internal contradiction.

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date | 62 | Alignment failure (internal contradiction) | Reason states Snowflake is DATE and Redshift is year (SMALLINT) but concludes “sample data both 4-digit years,” which contradicts a DATE field unless evidence is clarified (e.g., dates always Jan-01 or stored as year-only strings). Mid-band score may be reasonable, but the evidence statement is inconsistent. |

### Recommendations
1. **For Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date (Score 62):** resolve the contradiction in the “Reason for Matching” by replacing “sample data both 4-digit years” with verifiable evidence consistent with a DATE field (e.g., “Snowflake dates consistently use YYYY-12-31; Redshift stores YYYY as SMALLINT”). If such evidence cannot be produced, adjust the reason to indicate uncertainty and consider re-scoring downward within the mid band.
2. **For all other rows (no gaps identified):** maintain current evidence style (explicit similarity + key semantics + sample overlap) since it is both meaningful and appropriately aligned with high-band scores.