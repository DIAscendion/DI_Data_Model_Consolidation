## Change Summary

- Tables affected (ALTER): 5; new tables created (CREATE): 2
- Total ALTER statements: 8 (additions: 3; renames: 3; casts: 0; constraints: 2)
- Total CREATE TABLE statements produced: 2
- Total items skipped: 5
- Tables in original DDL with no changes at all: 5

## SnowflakeDDL Updates - Alter, Create

```sql
-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ADD COLUMN alliance VARCHAR(100);
-- IMPACT: Existing rows will have NULL for ALLIANCE until backfilled; downstream queries can start consuming the attribute without breaking existing pipelines.
-- RECOMMENDATION: Backfill ALLIANCE from the source where available (or leave NULL) and update any semantic layer definitions that should expose airline alliance.

ALTER TABLE gold.airline_master ADD COLUMN carrier_type VARCHAR(50);
-- IMPACT: Existing rows will have NULL for CARRIER_TYPE until populated; no impact to existing constraints.
-- RECOMMENDATION: Populate CARRIER_TYPE during the next Silver->Gold merge and validate allowed values (e.g., Mainline/Low Cost/Cargo) to avoid free-text drift.

ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET NOT NULL;
-- IMPACT: Will fail if any existing AIRLINE_ID values are NULL (unlikely for an IDENTITY PK, but possible if loaded via override); may impact loads that insert explicit NULLs.
-- RECOMMENDATION: Validate no NULL AIRLINE_ID exists (and prevent override inserts) before applying; if any exist, remediate by re-keying or deleting invalid rows.

ALTER TABLE gold.airline_master ADD CONSTRAINT uq_airline_master_airline_id UNIQUE (airline_id);
-- IMPACT: Will fail if duplicates exist in AIRLINE_ID (unlikely for an IDENTITY PK unless manually overridden); adds an additional uniqueness constraint beyond the PK.
-- RECOMMENDATION: Check for duplicate AIRLINE_ID values prior to deployment; if present, deduplicate/re-key and ensure ETL never overrides AIRLINE_ID.

-- TABLE: gold.aircraft_master
-- SKIPPED: gold.aircraft_master.delivery_year — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: gold.aircraft_master.retirement_year — Suggested Action is "Review with business — possible manual mapping needed"

ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET NOT NULL;
-- IMPACT: Will fail if any existing AIRCRAFT_ID values are NULL (unlikely for an IDENTITY PK unless loaded via override).
-- RECOMMENDATION: Validate AIRCRAFT_ID has no NULLs and block/avoid override inserts before applying.

ALTER TABLE gold.aircraft_master ADD CONSTRAINT uq_aircraft_master_aircraft_id UNIQUE (aircraft_id);
-- IMPACT: Will fail if duplicates exist in AIRCRAFT_ID (unlikely for an IDENTITY PK unless manually overridden).
-- RECOMMENDATION: Validate uniqueness of AIRCRAFT_ID prior to deployment and ensure ingestion logic does not set explicit IDs.

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ADD COLUMN region VARCHAR(100);
-- IMPACT: Existing rows will have NULL for REGION until populated; no breaking change to existing consumers.
-- RECOMMENDATION: Backfill REGION from source reference data and standardize region taxonomy (e.g., North America/Asia) in the Silver->Gold merge.

-- SKIPPED: gold.airport_master.iata_code — Gap analysis suggests new attribute, but gold.airport_master already has AIRPORT_CODE; adding IATA_CODE would be ambiguous/duplicative without business confirmation.
-- SKIPPED: gold.airport_master.icao_code — Gap analysis suggests new attribute, but mapping to AIRPORT_CODE vs a distinct field is unclear; requires confirmation.

-- TABLE: gold.customer_master
ALTER TABLE gold.customer_master ALTER COLUMN customer_id SET NOT NULL;
-- IMPACT: Will fail if any existing CUSTOMER_ID values are NULL (unlikely for an IDENTITY PK unless loaded via override).
-- RECOMMENDATION: Validate no NULL CUSTOMER_ID exists and prevent override inserts before applying.

ALTER TABLE gold.customer_master ADD CONSTRAINT uq_customer_master_customer_id UNIQUE (customer_id);
-- IMPACT: Will fail if duplicates exist in CUSTOMER_ID (unlikely for an IDENTITY PK unless manually overridden); adds uniqueness beyond the PK.
-- RECOMMENDATION: Check for duplicates prior to deployment; if present, deduplicate/re-key and enforce that ETL never overrides CUSTOMER_ID.

-- TABLE: gold.customer_subscriptions
ALTER TABLE gold.customer_subscriptions RENAME COLUMN tier TO subscription_tier;
-- IMPACT: Downstream views/queries/jobs referencing TIER will break until updated; historical data remains in-place under the new column name.
-- RECOMMENDATION: Update dependent objects (views, BI models, stored procedures, dbt models) to reference SUBSCRIPTION_TIER and coordinate a cutover window.

ALTER TABLE gold.customer_subscriptions RENAME COLUMN status TO subscription_status;
-- IMPACT: Downstream objects referencing STATUS will break until updated.
-- RECOMMENDATION: Search/replace references to STATUS in dependent SQL and apply changes in the same release as the rename.

-- TABLE: gold.flight_operations
-- SKIPPED: gold.flight_operations.schedule_id — Transformation rule is ambiguous ("Cast VARCHAR(50) to NUMBER(38,0) or vice versa, depending on canonical model") and current DDL is NUMBER(38,0).

ALTER TABLE gold.flight_operations RENAME COLUMN cancellation_flag TO cancelled_flag;
-- IMPACT: Downstream objects referencing CANCELLATION_FLAG will break until updated.
-- RECOMMENDATION: Update all dependent queries/pipelines to reference CANCELLED_FLAG and consider creating a temporary compatibility view/alias during transition.

ALTER TABLE gold.flight_operations RENAME COLUMN diversion_flag TO diverted_flag;
-- IMPACT: Downstream objects referencing DIVERSION_FLAG will break until updated.
-- RECOMMENDATION: Update dependents to reference DIVERTED_FLAG and validate end-to-end tests for any cancellation/diversion KPI logic.


-- TABLE: gold.event_type_master (NEW)
CREATE TABLE gold.event_type_master (
    event_type_id         NUMBER(38,0) IDENTITY(1,1),
    event_type_key        NUMBER(38,0),
    event_type_name       VARCHAR(200),
    event_category        VARCHAR(100),
    description           VARCHAR(1000),
    CONSTRAINT pk_event_type_master PRIMARY KEY (event_type_id)
)
COMMENT = 'Reference Domain: master list of event types and categories';
-- IMPACT: Introduces a new reference entity that could be joined from gold.flight_events.event_type, but the existing model currently stores event_type denormalized.
-- RECOMMENDATION: Confirm whether flight_events.event_type should map to EVENT_TYPE_KEY or EVENT_TYPE_NAME; once confirmed, backfill and optionally add an FK/lookup standardization in Silver->Gold.

-- TABLE: gold.route_master (NEW)
CREATE TABLE gold.route_master (
    route_id                  NUMBER(38,0) IDENTITY(1,1),
    route_key                 NUMBER(38,0),
    origin_airport_key        NUMBER(38,0),
    destination_airport_key   NUMBER(38,0),
    route_distance_miles      NUMBER(10,2),
    region                    VARCHAR(100),
    route_type                VARCHAR(50),
    domestic_international    VARCHAR(20),
    CONSTRAINT pk_route_master PRIMARY KEY (route_id)
)
COMMENT = 'Reference Domain: master data for routes (origin/destination and route attributes)';
-- IMPACT: Adds a route reference table that likely relates to gold.airport_master via origin/destination keys and may overlap with gold.flight_history.route_key, but the relationship is not explicitly defined in the current Gold DDL.
-- RECOMMENDATION: Confirm key semantics (whether *_airport_key maps to gold.airport_master.airport_id and whether flight_history.route_key maps to route_key); then build a deterministic mapping/backfill strategy and add formal FKs once validated.
```

## Other DDL — Unaltered

- gold.data_products — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.airline_schedules — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_events — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_history — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.aircraft_master — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
