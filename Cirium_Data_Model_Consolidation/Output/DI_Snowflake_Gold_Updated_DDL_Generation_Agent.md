## Change Summary
- Tables affected: 5
- ALTER statements produced: 8 total (additions: 5, renames: 0, casts: 2, constraints: 1)
- Items skipped: 17

## ALTER Statements
```sql
-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET DATA TYPE INTEGER;
ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET NOT NULL;
ALTER TABLE gold.airline_master ADD CONSTRAINT uq_airline_master_airline_id UNIQUE (airline_id);
ALTER TABLE gold.airline_master ADD COLUMN alliance VARCHAR(100);
ALTER TABLE gold.airline_master ADD COLUMN carrier_type VARCHAR(50);

-- TABLE: gold.aircraft_master
ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET DATA TYPE INTEGER;

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ADD COLUMN region VARCHAR(100);
ALTER TABLE gold.airport_master ADD COLUMN iata_code VARCHAR(10);
ALTER TABLE gold.airport_master ADD COLUMN icao_code VARCHAR(10);

-- TABLE: gold.flight_operations
-- SKIPPED: gold.flight_operations.schedule_id — transformation rule is ambiguous ("Cast VARCHAR(50) to NUMBER(38,0) or vice versa, depending on canonical model") and cannot be applied safely.

-- TABLE: gold.customer_subscriptions
-- SKIPPED: gold.customer_subscriptions.tier — gap analysis indicates "Rename column" but destination column is already named "tier" in current DDL.
-- SKIPPED: gold.customer_subscriptions.status — gap analysis indicates "Rename column" but destination column is already named "status" in current DDL.
-- SKIPPED: gold.customer_subscriptions.suscription_id — requested cast to BIGINT conflicts with current PK identity type and Snowflake BIGINT is semantically NUMBER(38,0); no safe change needed.

-- TABLE: gold.aircraft_master
-- SKIPPED: gold.aircraft_master.delivery_year — Suggested Action is "Review with business — possible manual mapping needed".
-- SKIPPED: gold.aircraft_master.retirement_year — Suggested Action is "Review with business — possible manual mapping needed".

-- TABLE: gold.dim_event_type.event_type_key — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_event_type.event_type_name — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_event_type.event_category — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_event_type.description — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.

-- TABLE: gold.dim_route.route_key — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.origin_airport_key — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.destination_airport_key — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.route_distance_miles — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.region — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.route_type — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
-- SKIPPED: gold.dim_route.domestic_international — source table has no corresponding table in current Snowflake Gold DDL; adding a new table is out of scope for ALTER-only changes.
```
