## Change Summary

- Tables affected (ALTER): 6; new tables created (CREATE): 1
- Total ALTER statements: 11 (additions: 6; renames: 0; casts: 0; constraints: 5)
- Total CREATE TABLE statements produced: 1
- Total items skipped: 3
- Tables in original DDL with no changes at all: 4

## SnowflakeDDL Updates - Alter, Create

```sql
-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ADD COLUMN alliance VARCHAR(100);
-- IMPACT: Adds a nullable attribute; existing rows remain valid and no rewrites are required.
-- RECOMMENDATION: Backfill alliance from the source (if available) and ensure downstream semantic models treat it as optional.

ALTER TABLE gold.airline_master ADD COLUMN carrier_type VARCHAR(50);
-- IMPACT: Adds a nullable attribute; no impact to existing data except new column will be NULL for historical rows.
-- RECOMMENDATION: Populate carrier_type during the next load/backfill cycle; validate allowed values (e.g., Mainline/Low Cost/Cargo) for consistency.

ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET NOT NULL;
-- IMPACT: Will fail if any existing rows have airline_id NULL (unlikely for an IDENTITY PK, but possible if loaded with overrides).
-- RECOMMENDATION: Validate `SELECT COUNT(*) FROM gold.airline_master WHERE airline_id IS NULL;` returns 0 before applying.

ALTER TABLE gold.airline_master ADD CONSTRAINT uq_airline_master_airline_id UNIQUE (airline_id);
-- IMPACT: Will fail if duplicate airline_id values exist; typically low risk since airline_id is the PK.
-- RECOMMENDATION: Validate uniqueness (`GROUP BY airline_id HAVING COUNT(*)>1`) prior to applying; keep PK/UNIQUE alignment in load procedures.

-- TABLE: gold.aircraft_master
-- SKIPPED: gold.aircraft_master.delivery_year — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: gold.aircraft_master.retirement_year — Suggested Action is "Review with business — possible manual mapping needed"

ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET NOT NULL;
-- IMPACT: Will fail if any existing rows have aircraft_id NULL (generally not expected for an IDENTITY PK).
-- RECOMMENDATION: Validate no NULLs exist in aircraft_id before applying; if any exist, remediate via backfill/reload.

ALTER TABLE gold.aircraft_master ADD CONSTRAINT uq_aircraft_master_aircraft_id UNIQUE (aircraft_id);
-- IMPACT: Will fail if duplicate aircraft_id values exist; low risk since aircraft_id is the PK.
-- RECOMMENDATION: Validate uniqueness of aircraft_id in current data before applying and ensure ETL never overrides identity values.

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ADD COLUMN region VARCHAR(100);
-- IMPACT: Adds a nullable attribute; existing rows remain valid and queries not selecting region are unaffected.
-- RECOMMENDATION: Backfill region using the source airport dimension; confirm the business definition (geographic vs. operational region).

ALTER TABLE gold.airport_master ADD COLUMN iata_code VARCHAR(10);
-- IMPACT: Adds a nullable attribute; possible semantic duplication with existing airport_code.
-- RECOMMENDATION: Confirm whether airport_code currently stores IATA, ICAO, or mixed; backfill iata_code accordingly and update consumers to prefer explicit columns.

ALTER TABLE gold.airport_master ADD COLUMN icao_code VARCHAR(10);
-- IMPACT: Adds a nullable attribute; possible semantic duplication with existing airport_code.
-- RECOMMENDATION: Backfill icao_code from source and document precedence rules between airport_code/iata_code/icao_code.

ALTER TABLE gold.airport_master ALTER COLUMN airport_id SET NOT NULL;
-- IMPACT: Will fail if any existing rows have airport_id NULL (unexpected for an IDENTITY PK).
-- RECOMMENDATION: Validate `airport_id` has no NULLs prior to applying; remediate via reload if violations exist.

ALTER TABLE gold.airport_master ADD CONSTRAINT uq_airport_master_airport_id UNIQUE (airport_id);
-- IMPACT: Will fail if duplicate airport_id values exist; low risk since airport_id is the PK.
-- RECOMMENDATION: Validate uniqueness before applying and ensure ingestion does not override identity-generated values.

-- TABLE: gold.customer_master
ALTER TABLE gold.customer_master ALTER COLUMN customer_id SET NOT NULL;
-- IMPACT: Will fail if customer_id contains NULLs; typically not expected for an IDENTITY PK but possible if loaded incorrectly.
-- RECOMMENDATION: Validate no NULL customer_id values exist; fix/load-correct data before applying.

ALTER TABLE gold.customer_master ADD CONSTRAINT uq_customer_master_customer_id UNIQUE (customer_id);
-- IMPACT: Will fail if duplicate customer_id values exist; low risk given PK.
-- RECOMMENDATION: Validate uniqueness and ensure any merge logic does not insert explicit duplicate IDs.

-- TABLE: gold.flight_operations
-- SKIPPED: gold.flight_operations.schedule_id — Transformation Rule is ambiguous ("Cast VARCHAR(50) to NUMBER(38,0) or vice versa, depending on canonical model") and cannot be safely applied.

-- TABLE: gold.data_products
-- (No changes required)

-- TABLE: gold.customer_subscriptions
-- (No changes required)

-- TABLE: gold.airline_schedules
-- (No changes required)

-- TABLE: gold.flight_events
-- (No changes required)

-- TABLE: gold.flight_history
-- (No changes required)

-- TABLE: gold.event_type_master (NEW)
CREATE TABLE gold.event_type_master (
    event_type_id     NUMBER(38,0) IDENTITY(1,1),
    event_type_key    NUMBER(38,0),
    event_type_name   VARCHAR(200),
    event_category    VARCHAR(100),
    description       VARCHAR(1000),
    CONSTRAINT pk_event_type_master PRIMARY KEY (event_type_id)
)
COMMENT = 'Reference Domain: master data for flight/event types';
-- IMPACT: Introduces a new reference entity; may logically relate to gold.flight_events.event_type (currently VARCHAR) but cardinality/key mapping is not confirmed.
-- RECOMMENDATION: Confirm whether flight_events.event_type should map to event_type_name or event_type_key; implement a one-time backfill and maintain an incremental upsert pipeline with dedupe rules on event_type_key/name once business mapping is agreed.

```

## Other DDL — Unaltered

- gold.data_products — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.customer_subscriptions — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.airline_schedules — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_events — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
