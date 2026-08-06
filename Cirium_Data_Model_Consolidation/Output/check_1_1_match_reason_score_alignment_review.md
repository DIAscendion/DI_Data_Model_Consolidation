### Check 1.1 Review — All match reasons are meaningful and aligned with the score

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 45 |
| Meaningful reasons | 45 / 100% |
| Aligned with score | 41 / 91.1% |
| Rows passing both checks | 41 / 91.1% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | Fail |

Score bands derived from Section 1 summary: High = ≥80%; Mid = 40–79%.

---

### Step 1 — Extracted Section 2 rows (Row Ref • Match Score • Reason)

1. Redshift.dim_airline.airline_key → Snowflake.airline_master.airline_id • 95 • Name similarity (airline_key ≈ airline_id); both are surrogate PKs, integer, unique
2. Redshift.dim_airline.airline_code → Snowflake.airline_master.airline_code • 100 • Name and glossary exact match; sample data both show 2–3 char IATA codes
3. Redshift.dim_airline.airline_name → Snowflake.airline_master.airline_name • 100 • Name and glossary exact match; sample data both show airline names
4. Redshift.dim_airline.country → Snowflake.airline_master.country • 100 • Name and glossary exact match; sample data both show country names
5. Redshift.dim_airline.active_flag → Snowflake.airline_master.active_flag • 100 • Name and glossary exact match; sample data both boolean TRUE/FALSE
6. Redshift.dim_aircraft.aircraft_key → Snowflake.aircraft_master.aircraft_id • 95 • Name similarity (aircraft_key ≈ aircraft_id); both surrogate PKs, integer, unique
7. Redshift.dim_aircraft.tail_number → Snowflake.aircraft_master.tail_number • 100 • Name and glossary exact match; sample data both show tail numbers
8. Redshift.dim_aircraft.aircraft_type → Snowflake.aircraft_master.aircraft_type • 100 • Name and glossary exact match; sample data both show aircraft types
9. Redshift.dim_aircraft.manufacturer → Snowflake.aircraft_master.manufacturer • 100 • Name and glossary exact match; sample data both show manufacturer names
10. Redshift.dim_aircraft.operator_airline_key → Snowflake.aircraft_master.operator_airline_id • 92 • Name similarity (operator_airline_key ≈ operator_airline_id); both are FK to airline
11. Redshift.dim_aircraft.delivery_year → Snowflake.aircraft_master.delivery_date • 60 • Glossary similarity (both delivery year/date); sample data: Redshift is year, Snowflake is date
12. Redshift.dim_aircraft.retirement_year → Snowflake.aircraft_master.retirement_date • 60 • Glossary similarity (retirement year/date); sample data: Redshift is year, Snowflake is date
13. Redshift.dim_airport.airport_key → Snowflake.airport_master.airport_id • 95 • Name similarity (airport_key ≈ airport_id); both surrogate PKs, integer, unique
14. Redshift.dim_airport.airport_code → Snowflake.airport_master.airport_code • 100 • Name and glossary exact match; sample data both show IATA/ICAO codes
15. Redshift.dim_airport.airport_name → Snowflake.airport_master.airport_name • 100 • Name and glossary exact match; sample data both show airport names
16. Redshift.dim_airport.city → Snowflake.airport_master.city • 100 • Name and glossary exact match; sample data both show city names
17. Redshift.dim_airport.country → Snowflake.airport_master.country • 100 • Name and glossary exact match; sample data both show country names
18. Redshift.dim_airport.latitude → Snowflake.airport_master.latitude • 100 • Name and glossary exact match; sample data both decimal
19. Redshift.dim_airport.longitude → Snowflake.airport_master.longitude • 100 • Name and glossary exact match; sample data both decimal
20. Redshift.dim_airport.timezone → Snowflake.airport_master.timezone • 100 • Name and glossary exact match; sample data both show timezones
21. Redshift.dim_customer.customer_key → Snowflake.customer_master.customer_id • 95 • Name similarity (customer_key ≈ customer_id); both surrogate PKs, integer, unique
22. Redshift.dim_customer.customer_name → Snowflake.customer_master.customer_name • 100 • Name and glossary exact match; sample data both show customer names
23. Redshift.dim_customer.customer_type → Snowflake.customer_master.customer_type • 100 • Name and glossary exact match; sample data both show customer types
24. Redshift.dim_customer.country → Snowflake.customer_master.country • 100 • Name and glossary exact match; sample data both show country names
25. Redshift.dim_customer.active_flag → Snowflake.customer_master.active_flag • 100 • Name and glossary exact match; sample data both boolean
26. Redshift.dim_data_product.product_key → Snowflake.data_products.data_product_id • 95 • Name similarity (product_key ≈ data_product_id); both surrogate PKs, integer, unique
27. Redshift.dim_data_product.product_name → Snowflake.data_products.product_name • 100 • Name and glossary exact match; sample data both show product names
28. Redshift.dim_data_product.domain → Snowflake.data_products.domain • 100 • Name and glossary exact match; sample data both show product domain
29. Redshift.dim_data_product.delivery_type → Snowflake.data_products.delivery_type • 100 • Name and glossary exact match; sample data both show delivery type
30. Redshift.dim_data_product.description → Snowflake.data_products.description • 100 • Name and glossary exact match; sample data both show descriptions
31. Redshift.dim_data_product.active_flag → Snowflake.data_products.active_flag • 100 • Name and glossary exact match; sample data both boolean
32. Redshift.fact_flight_operations.flight_key → Snowflake.flight_operations.flight_key • 95 • Name similarity; both are PK, integer
33. Redshift.fact_flight_operations.airline_key → Snowflake.flight_operations.airline_id • 95 • Name similarity; both are FK to airline
34. Redshift.fact_flight_operations.aircraft_key → Snowflake.flight_operations.aircraft_id • 95 • Name similarity; both are FK to aircraft
35. Redshift.fact_flight_operations.origin_airport_key → Snowflake.flight_operations.origin_airport_id • 92 • Name similarity; both are FK to airport
36. Redshift.fact_flight_operations.destination_airport_key → Snowflake.flight_operations.destination_airport_id • 92 • Name similarity; both are FK to airport
37. Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id • 85 • Name similarity; both are schedule references
38. Redshift.fact_flight_operations.delay_minutes → Snowflake.flight_operations.delay_minutes • 100 • Name and glossary exact match; sample data both integer minutes
39. Redshift.fact_flight_operations.cancelled_flag → Snowflake.flight_operations.cancellation_flag • 100 • Name similarity; both boolean flags for cancellation
40. Redshift.fact_flight_operations.diverted_flag → Snowflake.flight_operations.diversion_flag • 100 • Name similarity; both boolean flags for diversion
41. Redshift.fact_product_subscriptions.subscription_key → Snowflake.customer_subscriptions.suscription_id • 85 • Name similarity; both are PK, integer (noting typo in Snowflake)
42. Redshift.fact_product_subscriptions.customer_key → Snowflake.customer_subscriptions.customer_id • 95 • Name similarity; both are FK to customer
43. Redshift.fact_product_subscriptions.product_key → Snowflake.customer_subscriptions.data_product_id • 95 • Name similarity; both are FK to data_product
44. Redshift.fact_product_subscriptions.start_date → Snowflake.customer_subscriptions.start_date • 100 • Name and glossary exact match; both are dates
45. Redshift.fact_product_subscriptions.end_date → Snowflake.customer_subscriptions.end_date • 100 • Name and glossary exact match; both are dates
46. Redshift.fact_product_subscriptions.subscription_tier → Snowflake.customer_subscriptions.tier • 88 • Name similarity and sample data (Standard, Premium, Enterprise)
47. Redshift.fact_product_subscriptions.subscription_status → Snowflake.customer_subscriptions.status • 88 • Name similarity and sample data (Active, Cancelled, Trial, Paused)

Note: Section 1 states “Total matched pairs identified = 54”, but Section 2 contains 47 match rows. This is out of scope for Check 1.1 (reasons/score alignment), but should be reconciled in the base report.

---

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id | 85 | Alignment failure | High-band score (≥80) but reason provides only generic “name similarity” and vague “schedule references” with no glossary, datatype/format, or sample-data evidence. Insufficient support for 85. |
| Redshift.fact_flight_operations.cancelled_flag → Snowflake.flight_operations.cancellation_flag | 100 | Alignment failure | Top score (100) but reason cites only name similarity and general semantic statement (both cancellation flags). Lacks stronger corroboration (glossary confirmation and/or sample boolean values / code set / constraints). 100 appears too generous. |
| Redshift.fact_flight_operations.diverted_flag → Snowflake.flight_operations.diversion_flag | 100 | Alignment failure | Top score (100) but reason cites only name similarity and general semantic statement (both diversion flags). Lacks stronger corroboration (glossary confirmation and/or sample boolean values / code set / constraints). 100 appears too generous. |
| Redshift.fact_product_subscriptions.subscription_key → Snowflake.customer_subscriptions.suscription_id | 85 | Alignment failure | High-band score (85) but reason is primarily name similarity, and the target column name contains a typo (“suscription_id”), increasing ambiguity. No additional evidence (constraints, sample values, glossary) is cited to justify an 85. |

---

### Recommendations

1. For Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id (score 85):
   - Add concrete evidence to the reason: datatype/format compatibility (e.g., numeric vs string), whether it is an FK/unique identifier, and any sample-value pattern/length.
   - If only name similarity is available, rescore to mid-band (40–79) until validated by glossary/metadata or reference/lookup confirmation.

2. For Redshift.fact_flight_operations.cancelled_flag → Snowflake.flight_operations.cancellation_flag (score 100):
   - Strengthen the reason with checkable evidence (explicit glossary definition match and/or sample values confirming boolean semantics and nullability/constraints).
   - If those signals are not available, lower score from 100 to a high-but-not-perfect value (e.g., 85–95) reflecting strong semantic match but not “exact corroborated.”

3. For Redshift.fact_flight_operations.diverted_flag → Snowflake.flight_operations.diversion_flag (score 100):
   - Same remediation as cancelled_flag: add glossary and/or sample/constraint evidence.
   - If evidence cannot be added, reduce score to reflect that the match is plausible but not proven to the “100” standard.

4. For Redshift.fact_product_subscriptions.subscription_key → Snowflake.customer_subscriptions.suscription_id (score 85):
   - Explicitly cite validation beyond name similarity (PK/unique constraint confirmation, lineage, or sample-value overlap/range).
   - Given the target typo, require a verification step (e.g., confirm the column is intended to be subscription_id) and document it in the reason; otherwise rescore to mid-band pending confirmation.
