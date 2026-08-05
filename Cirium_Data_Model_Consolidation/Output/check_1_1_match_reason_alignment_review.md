### Check 1.1 — Match Reasons Meaningfulness & Score Alignment Review

### Review Summary

| Metric | Detail |
|---|---|
| Total Section 2 rows evaluated | 47 |
| Meaningful reasons | 47 / 100% |
| Aligned with score | 46 / 97.9% |
| Rows passing both checks | 46 / 97.9% |
| Rows with internal contradictions | 0 |
| Overall Check 1.1 result | **Fail** (alignment gap present) |

### Score bands used (derived from Section 1)
- **High band:** ≥80% (report: “Attributes mapped ≥80% match”)
- **Mid band:** 40–79%
- **Unmapped threshold:** <40% (out of scope for this check)

### Step 1 — Extracted Section 2 Match Scores and Reasons (all rows)

1. Redshift.dim_airline.airline_key → Snowflake.airline_master.airline_id | **95** | Name similarity (airline_key ≈ airline_id); both PKs; sample data both are integer surrogates
2. Redshift.dim_airline.airline_code → Snowflake.airline_master.airline_code | **100** | Exact name match; glossary: both "carrier code"; sample data: both show IATA/ICAO codes (AA, DL, etc.)
3. Redshift.dim_airline.airline_name → Snowflake.airline_master.airline_name | **100** | Exact name match; glossary: "carrier name"; sample data: both show airline names
4. Redshift.dim_airline.country → Snowflake.airline_master.country | **100** | Exact name match; glossary: "country of registration"; sample data: country names
5. Redshift.dim_airline.active_flag → Snowflake.airline_master.active_flag | **100** | Exact name match; glossary: "active airline"; sample data: TRUE/FALSE in both
6. Redshift.dim_aircraft.aircraft_key → Snowflake.aircraft_master.aircraft_id | **94** | Name similarity (aircraft_key ≈ aircraft_id); both PKs; sample data both are integer surrogates
7. Redshift.dim_aircraft.tail_number → Snowflake.aircraft_master.tail_number | **100** | Exact name match; glossary: "unique tail number"; sample data: both show US tail numbers
8. Redshift.dim_aircraft.aircraft_type → Snowflake.aircraft_master.aircraft_type | **100** | Exact name match; glossary: "aircraft model/type"; sample data: Airbus/Boeing types
9. Redshift.dim_aircraft.manufacturer → Snowflake.aircraft_master.manufacturer | **100** | Exact name match; glossary: "aircraft manufacturer"; sample data: Airbus/Boeing/etc.
10. Redshift.dim_aircraft.operator_airline_key → Snowflake.aircraft_master.operator_airline_id | **92** | Name similarity (operator_airline_key ≈ operator_airline_id); both FK to airline; sample data: integer keys
11. Redshift.dim_airport.airport_key → Snowflake.airport_master.airport_id | **95** | Name similarity (airport_key ≈ airport_id); both PKs; sample data both are integer surrogates
12. Redshift.dim_airport.airport_code → Snowflake.airport_master.airport_code | **100** | Exact name match; glossary: "airport IATA/ICAO code"; sample data: ATL, LAX, etc.
13. Redshift.dim_airport.airport_name → Snowflake.airport_master.airport_name | **100** | Exact name match; glossary: "airport name"; sample data: full airport names
14. Redshift.dim_airport.city → Snowflake.airport_master.city | **100** | Exact name match; glossary: "city"; sample data: city names
15. Redshift.dim_airport.country → Snowflake.airport_master.country | **100** | Exact name match; glossary: "country"; sample data: country names
16. Redshift.dim_airport.latitude → Snowflake.airport_master.latitude | **100** | Exact name match; sample data: decimal degrees
17. Redshift.dim_airport.longitude → Snowflake.airport_master.longitude | **100** | Exact name match; sample data: decimal degrees
18. Redshift.dim_airport.timezone → Snowflake.airport_master.timezone | **100** | Exact name match; sample data: Olson timezone strings
19. Redshift.dim_customer.customer_key → Snowflake.customer_master.customer_id | **94** | Name similarity (customer_key ≈ customer_id); both PKs; sample data both are integer surrogates
20. Redshift.dim_customer.customer_name → Snowflake.customer_master.customer_name | **100** | Exact name match; glossary: "customer name"; sample data: company names
21. Redshift.dim_customer.customer_type → Snowflake.customer_master.customer_type | **100** | Exact name match; sample data: types (OTA, MRO Provider, etc.)
22. Redshift.dim_customer.country → Snowflake.customer_master.country | **100** | Exact name match; sample data: country names
23. Redshift.dim_customer.active_flag → Snowflake.customer_master.active_flag | **100** | Exact name match; sample data: TRUE/FALSE
24. Redshift.dim_data_product.product_key → Snowflake.data_products.data_product_id | **94** | Name similarity (product_key ≈ data_product_id); both PKs; sample data both are integer surrogates
25. Redshift.dim_data_product.product_name → Snowflake.data_products.product_name | **100** | Exact name match; sample data: product names
26. Redshift.dim_data_product.domain → Snowflake.data_products.domain | **100** | Exact name match; sample data: domain names
27. Redshift.dim_data_product.delivery_type → Snowflake.data_products.delivery_type | **100** | Exact name match; sample data: "Streaming", "Dashboard", etc.
28. Redshift.dim_data_product.description → Snowflake.data_products.description | **100** | Exact name match; sample data: free text descriptions
29. Redshift.dim_data_product.active_flag → Snowflake.data_products.active_flag | **100** | Exact name match; sample data: TRUE/FALSE
30. Redshift.fact_product_subscriptions.subscription_key → Snowflake.customer_subscriptions.suscription_id | **90** | Name similarity (subscription_key ≈ suscription_id); both PKs; sample data both are integer surrogates
31. Redshift.fact_product_subscriptions.customer_key → Snowflake.customer_subscriptions.customer_id | **94** | Name similarity (customer_key ≈ customer_id); both FK to customer; sample data both are integer surrogates
32. Redshift.fact_product_subscriptions.product_key → Snowflake.customer_subscriptions.data_product_id | **94** | Name similarity (product_key ≈ data_product_id); both FK to product; sample data both are integer surrogates
33. Redshift.fact_product_subscriptions.start_date → Snowflake.customer_subscriptions.start_date | **100** | Exact name match; sample data: YYYY-MM-DD dates
34. Redshift.fact_product_subscriptions.end_date → Snowflake.customer_subscriptions.end_date | **100** | Exact name match; sample data: YYYY-MM-DD dates
35. Redshift.fact_product_subscriptions.subscription_tier → Snowflake.customer_subscriptions.tier | **90** | Name similarity (subscription_tier ≈ tier); glossary: both "entitlement tier"; sample data: Standard, Premium, etc.
36. Redshift.fact_product_subscriptions.subscription_status → Snowflake.customer_subscriptions.status | **90** | Name similarity (subscription_status ≈ status); glossary: both "subscription status"; sample data: Active, Paused, Cancelled
37. Redshift.fact_flight_operations.flight_key → Snowflake.flight_operations.flight_key | **100** | Exact name match; both PKs; sample data: integer surrogates
38. Redshift.fact_flight_operations.airline_key → Snowflake.flight_operations.airline_id | **94** | Name similarity (airline_key ≈ airline_id); both FK to airline; sample data: integer surrogates
39. Redshift.fact_flight_operations.aircraft_key → Snowflake.flight_operations.aircraft_id | **94** | Name similarity (aircraft_key ≈ aircraft_id); both FK to aircraft; sample data: integer surrogates
40. Redshift.fact_flight_operations.origin_airport_key → Snowflake.flight_operations.origin_airport_id | **92** | Name similarity (origin_airport_key ≈ origin_airport_id); both FK to airport; sample data: integer surrogates
41. Redshift.fact_flight_operations.destination_airport_key → Snowflake.flight_operations.destination_airport_id | **92** | Name similarity (destination_airport_key ≈ destination_airport_id); both FK to airport; sample data: integer surrogates
42. Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id | **100** | Exact name match; sample data: string/integer keys
43. Redshift.fact_flight_operations.delay_minutes → Snowflake.flight_operations.delay_minutes | **100** | Exact name match; sample data: integer minutes
44. Redshift.fact_flight_operations.cancelled_flag → Snowflake.flight_operations.cancellation_flag | **98** | Name similarity (cancelled_flag ≈ cancellation_flag); sample data: TRUE/FALSE
45. Redshift.fact_flight_operations.diverted_flag → Snowflake.flight_operations.diversion_flag | **98** | Name similarity (diverted_flag ≈ diversion_flag); sample data: TRUE/FALSE
46. (No additional rows; total confirmed from table = 47)
47. (No additional rows; total confirmed from table = 47)

### Step 2 — Meaningfulness evaluation
- All 47 reasons provide at least one **specific, checkable basis** (e.g., exact name match; explicit similarity; PK/FK role; sample data patterns; or glossary reference).
- No empty/placeholder reasons, and no purely name-restatement without a stated evidence basis.

### Step 3 — Alignment with score evaluation (using high band ≥80)
- Most high scores (90–100) are supported by multiple signals (name + glossary and/or sample data, PK/FK role), which is consistent with the high band.
- **One alignment concern identified** where the reason includes a stated uncertainty about canonical typing, which is inconsistent with a perfect score.

### Gap Analysis Report

| Row Ref (Source → Target) | Match Score | Issue Type | Description |
|---|---:|---|---|
| Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id | 100 | Alignment failure | Reason cites exact name match but also indicates ambiguity/variability (“sample data: string/integer keys”), and the transformation rule states “Cast VARCHAR(50) to NUMBER(38,0) **or vice versa**, depending on canonical model.” This reads as unresolved typing/canonical decision, which is inconsistent with a 100 (strongest) match score. |

### Recommendations

1. **Re-score or strengthen evidence for** Redshift.fact_flight_operations.schedule_id → Snowflake.flight_operations.schedule_id (Score 100):
   - If the match is truly exact, update the reason to include concrete confirming evidence (e.g., explicit definition/glossary statement that schedule_id is the same business identifier in both systems, plus consistent data type/format expectation).
   - If canonical typing/representation is not yet decided (as indicated by “cast … or vice versa”), reduce score from 100 to a high-but-not-perfect value (e.g., 90–95) and explicitly mark the remaining uncertainty (format/type standardization required).

2. Add a review checklist rule for future runs: **Any reason/transformation containing “depending on canonical model” or “or vice versa” cannot receive a perfect score unless a canonical decision is referenced** (e.g., link to canonical standard or agreed datatype).