## Change Summary

- Tables affected (ALTER): 4; new tables created (CREATE): 2
- Total ALTER statements: 9 (additions: 7; renames: 2; casts: 0; constraints: 0)
- Total CREATE TABLE statements: 2
- Total items skipped: 4
- Tables in the original DDL with no changes at all: 6

## SnowflakeDDL Updates - Alter, Create

```sql
-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ADD COLUMN alliance VARCHAR(100);
-- IMPACT: No impact to existing rows; new column will be NULL for all existing airlines until backfilled.
-- RECOMMENDATION: Backfill from source dim_airline.alliance (or derived logic) during the next Gold MERGE and validate expected cardinality/allowed values.

ALTER TABLE gold.airline_master ADD COLUMN carrier_type VARCHAR(50);
-- IMPACT: No impact to existing rows; new column will be NULL for all existing airlines until backfilled.
-- RECOMMENDATION: Backfill from source dim_airline.carrier_type and standardize values (e.g., Mainline/Low Cost/Cargo) to avoid downstream filtering inconsistencies.

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ADD COLUMN region VARCHAR(100);
-- IMPACT: No impact to existing rows; existing airports will have NULL region until populated.
-- RECOMMENDATION: Define the region taxonomy (e.g., continent vs. sales region) and backfill from source; add data quality checks for unknown/other.

ALTER TABLE gold.airport_master ADD COLUMN iata_code VARCHAR(10);
-- IMPACT: No impact to existing rows; potential redundancy with airport_code depending on how airport_code is populated today.
-- RECOMMENDATION: Confirm whether airport_code currently stores IATA, ICAO, or mixed codes; if mixed, populate iata_code explicitly and update downstream joins to use the appropriate code.

ALTER TABLE gold.airport_master ADD COLUMN icao_code VARCHAR(10);
-- IMPACT: No impact to existing rows; potential redundancy with airport_code depending on current semantics.
-- RECOMMENDATION: Backfill from source and validate format/length (ICAO typically 4 chars); document expected precedence among airport_code/iata_code/icao_code for consumers.

-- TABLE: gold.aircraft_master
-- SKIPPED: gold.aircraft_master.delivery_year — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: gold.aircraft_master.retirement_year — Suggested Action is "Review with business — possible manual mapping needed"

-- TABLE: gold.flight_operations
-- SKIPPED: gold.flight_operations.schedule_id — Transformation Rule is ambiguous ("Cast VARCHAR(50) to NUMBER(38,0) or vice versa") and cannot be applied safely

-- TABLE: gold.customer_subscriptions
ALTER TABLE gold.customer_subscriptions RENAME COLUMN tier TO subscription_tier;
-- IMPACT: Renaming breaks downstream queries/views/pipelines that reference gold.customer_subscriptions.tier.
-- RECOMMENDATION: Perform a coordinated release: update dependent objects to reference subscription_tier (or create a compatibility view) and validate end-to-end after deployment.

ALTER TABLE gold.customer_subscriptions RENAME COLUMN status TO subscription_status;
-- IMPACT: Renaming breaks downstream queries/views/pipelines that reference gold.customer_subscriptions.status.
-- RECOMMENDATION: Update all dependent objects to use subscription_status and run regression tests for reporting/entitlement logic.

-- TABLE: gold.flight_history
-- SKIPPED: gold.flight_history.cancelled_flag — No destination match in gap analysis; flight_operations uses cancellation_flag but changing flight_history would be inventing a rule

-- TABLE: gold.event_type_master (NEW)
CREATE TABLE gold.event_type_master (
    event_type_id       NUMBER(38,0) IDENTITY(1,1),
    event_type_key      NUMBER(38,0),
    event_type_name     VARCHAR(200),
    event_category      VARCHAR(100),
    description         VARCHAR(1000),
    CONSTRAINT pk_event_type_master PRIMARY KEY (event_type_id)
)
COMMENT = 'Reference Domain: master list of event types and categories';
-- IMPACT: Introduces a new reference entity that may logically relate to gold.flight_events.event_type, but existing events are currently denormalized and will not automatically link.
-- RECOMMENDATION: Confirm whether flight_events.event_type should map to event_type_master.event_type_name (or key) and, once confirmed, add a stable mapping in the Silver->Gold merge (optionally add FK after validation).

-- TABLE: gold.route_master (NEW)
CREATE TABLE gold.route_master (
    route_id                 NUMBER(38,0) IDENTITY(1,1),
    route_key                NUMBER(38,0),
    origin_airport_key        NUMBER(38,0),
    destination_airport_key   NUMBER(38,0),
    route_distance_miles      NUMBER(10,2),
    region                   VARCHAR(100),
    route_type               VARCHAR(50),
    domestic_international   VARCHAR(20),
    CONSTRAINT pk_route_master PRIMARY KEY (route_id)
)
COMMENT = 'Reference Domain: master data for routes (origin/destination pair and derived attributes)';
-- IMPACT: Adds a new route dimension that could relate to gold.flight_history.route_key and potentially to gold.flight_operations (via airports), but the current Gold model has no confirmed FK/natural key semantics for route_key.
-- RECOMMENDATION: Confirm route_key definition and how origin/destination airport keys map to gold.airport_master.airport_id; build a deterministic route upsert (dedupe on route_key or on origin/destination pair) and backfill historical route mappings before adding any FK.
```

## Other DDL — Unaltered

- gold.aircraft_master — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.airline_schedules — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.customer_master — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.data_products — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_events — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_history — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
