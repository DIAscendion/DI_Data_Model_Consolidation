-- ============================================================================
-- MODEL 2 : CIRIUM AVIATION INTELLIGENCE -- GOLD LAYER DDL
-- Platform : Snowflake (target state)
-- Layer    : Gold (business-ready, domain-oriented model -- matches the
--            attached ER image EXACTLY: table/column names, PK/FK, grain)
--
-- Rules applied:
--   * Structure mirrors the MODEL-2.png ER diagram verbatim -- no renamed or
--     redesigned tables/columns, even where naming is inconsistent with
--     Model 1 (this model uses "_id" surrogate keys on masters and a mix of
--     "_key"/"_id" on transactional tables -- kept as-is per the non-
--     negotiable Gold rule).
--   * Surrogate keys generated via Snowflake IDENTITY on every table's PK.
--   * PRIMARY KEY / FOREIGN KEY declared for documentation and query
--     optimization only -- Snowflake does not enforce PK/FK/UNIQUE by
--     default (RELY is not set), enforcement happens in the Silver->Gold
--     MERGE procedures.
--   * CLUSTER BY defined only on the higher-volume transactional tables
--     (flight_operations, flight_events, flight_history, airline_schedules).
--     Reference/master tables are small and left unclustered.
--   * No SCD tracking columns (effective_date/end_date/is_current) appear on
--     any *_MASTER table in the image, so all reference tables default to
--     SCD TYPE 1 (overwrite in place). Flag back if AIRCRAFT_MASTER or
--     AIRLINE_MASTER need SCD TYPE 2 history.
--
-- ASSUMPTIONS / AMBIGUITIES (per your ambiguity-flagging rule -- please
-- confirm or correct before Silver/Bronze are finalized):
--   1. FLIGHT_HISTORY.route_key has NO corresponding ROUTE_MASTER /
--      reference entity anywhere in this diagram (unlike Model 1's
--      DIM_ROUTE). Modeled as an un-enforced NUMBER attribute with no FK
--      constraint. If a route dimension is intended, please confirm and
--      I will add ROUTE_MASTER + FK.
--   2. FLIGHT_EVENTS.event_type is a plain VARCHAR attribute -- the diagram
--      has no EVENT_TYPE reference table for Model 2 (unlike Model 1's
--      DIM_EVENT_TYPE). Kept denormalized as shown.
--   3. FLIGHT_EVENTS.event_payload is modeled as Snowflake VARIANT
--      (semi-structured JSON) since it represents a raw event payload from
--      the legacy Hub -- flag if you intended a fixed VARCHAR instead.
--   4. CUSTOMER_SUBSCRIPTIONS primary key is spelled "suscription_id" in the
--      source diagram (missing "b"). Preserved verbatim per the "do not
--      rename Gold columns" rule -- flag back if this should be corrected
--      to "subscription_id" (I'd recommend fixing it, but won't do so
--      silently).
--   5. AIRLINE_SCHEDULES.aircraft_type is a free-text descriptive attribute,
--      not an FK to AIRCRAFT_MASTER -- kept as shown (schedules reference an
--      aircraft *type*, not a specific tail number).
--   6. FLIGHT_OPERATIONS.origin_airport_id is modeled NULLABLE (diagram
--      shows "0..1" cardinality on that relationship); destination_airport_id
--      is modeled NOT NULL (diagram shows a mandatory "1" side). Confirm if
--      both should be mandatory.
--   7. Diagram gives no explicit data types anywhere -- types below follow
--      the same conventions used in Model 1 (VARCHAR for text/codes, DATE /
--      TIMESTAMP_NTZ for temporal, NUMBER for numeric, BOOLEAN for flags).
--   8. FLIGHT_EVENTS -> FLIGHT_HISTORY dashed (optional) relationship in the
--      image has no natural FK column on either side (events roll up to
--      flight_key, history also carries flight_key -- the two already
--      connect transitively through FLIGHT_OPERATIONS). No direct FK added
--      between them to avoid inventing an unlisted column.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- ============================================================================
-- REFERENCE DOMAIN
-- ============================================================================

-- ----------------------------------------------------------------------------
-- AIRLINE_MASTER
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.airline_master (
    airline_id       NUMBER(38,0)   IDENTITY(1,1),
    airline_code     VARCHAR(20)    NOT NULL,
    airline_name     VARCHAR(200)   NOT NULL,
    country          VARCHAR(100),
    active_flag      BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_airline_master PRIMARY KEY (airline_id),
    CONSTRAINT uq_airline_code UNIQUE (airline_code)
)
COMMENT = 'Reference Domain: master data for airlines';

-- ----------------------------------------------------------------------------
-- AIRCRAFT_MASTER
-- FK: operator_airline_id -> airline_master
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.aircraft_master (
    aircraft_id          NUMBER(38,0)  IDENTITY(1,1),
    tail_number          VARCHAR(20)   NOT NULL,
    aircraft_type        VARCHAR(100),
    manufacturer         VARCHAR(100),
    delivery_date        DATE,
    retirement_date      DATE,
    operator_airline_id  NUMBER(38,0),   -- FK -> gold.airline_master.airline_id
    CONSTRAINT pk_aircraft_master PRIMARY KEY (aircraft_id),
    CONSTRAINT uq_tail_number UNIQUE (tail_number),
    CONSTRAINT fk_aircraft_operator_airline
        FOREIGN KEY (operator_airline_id) REFERENCES gold.airline_master (airline_id)
)
COMMENT = 'Reference Domain: master data for aircraft';

-- ----------------------------------------------------------------------------
-- AIRPORT_MASTER
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.airport_master (
    airport_id       NUMBER(38,0)   IDENTITY(1,1),
    airport_code     VARCHAR(20)    NOT NULL,
    airport_name     VARCHAR(200),
    city             VARCHAR(100),
    country          VARCHAR(100),
    latitude         NUMBER(9,6),
    longitude        NUMBER(9,6),
    timezone         VARCHAR(50),
    CONSTRAINT pk_airport_master PRIMARY KEY (airport_id),
    CONSTRAINT uq_airport_code UNIQUE (airport_code)
)
COMMENT = 'Reference Domain: master data for airports';

-- ============================================================================
-- CUSTOMER DOMAIN
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CUSTOMER_MASTER
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.customer_master (
    customer_id      NUMBER(38,0)   IDENTITY(1,1),
    customer_name    VARCHAR(200)   NOT NULL,
    customer_type    VARCHAR(50),
    country          VARCHAR(100),
    active_flag      BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_customer_master PRIMARY KEY (customer_id)
)
COMMENT = 'Customer Domain: customer master data';

-- ----------------------------------------------------------------------------
-- DATA_PRODUCTS
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.data_products (
    data_product_id  NUMBER(38,0)   IDENTITY(1,1),
    product_name     VARCHAR(200)   NOT NULL,
    domain           VARCHAR(100),
    delivery_type    VARCHAR(50),
    description      VARCHAR(1000),
    active_flag      BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_data_products PRIMARY KEY (data_product_id)
)
COMMENT = 'Customer Domain: catalog of subscribable data products';

-- ----------------------------------------------------------------------------
-- CUSTOMER_SUBSCRIPTIONS
-- FK: customer_id -> customer_master, data_product_id -> data_products
-- PK column name "suscription_id" preserved verbatim from source diagram
-- (see Assumption #4).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.customer_subscriptions (
    suscription_id     NUMBER(38,0)  IDENTITY(1,1),
    customer_id         NUMBER(38,0)  NOT NULL,   -- FK -> gold.customer_master
    data_product_id     NUMBER(38,0)  NOT NULL,   -- FK -> gold.data_products
    start_date           DATE,
    end_date             DATE,
    tier                 VARCHAR(50),
    status                VARCHAR(50),
    CONSTRAINT pk_customer_subscriptions PRIMARY KEY (suscription_id),
    CONSTRAINT fk_subscription_customer
        FOREIGN KEY (customer_id) REFERENCES gold.customer_master (customer_id),
    CONSTRAINT fk_subscription_product
        FOREIGN KEY (data_product_id) REFERENCES gold.data_products (data_product_id)
)
COMMENT = 'Customer Domain: customer subscription entitlements to data products';

-- ============================================================================
-- SCHEDULE DOMAIN
-- ============================================================================

-- ----------------------------------------------------------------------------
-- AIRLINE_SCHEDULES
-- FK: airline_id -> airline_master, origin/destination_airport_id -> airport_master
-- Grain: one row per published schedule version per airline/route/flight number.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.airline_schedules (
    schedule_id             NUMBER(38,0)  IDENTITY(1,1),
    airline_id               NUMBER(38,0)  NOT NULL,   -- FK -> gold.airline_master
    origin_airport_id         NUMBER(38,0)  NOT NULL,   -- FK -> gold.airport_master
    destination_airport_id    NUMBER(38,0)  NOT NULL,   -- FK -> gold.airport_master
    flight_number              VARCHAR(20),
    scheduled_departure         TIMESTAMP_NTZ,
    scheduled_arrival            TIMESTAMP_NTZ,
    aircraft_type                VARCHAR(100),          -- descriptive, not FK (Assumption #5)
    effective_date                DATE,
    expiration_date               DATE,
    schedule_version               NUMBER(5,0),
    CONSTRAINT pk_airline_schedules PRIMARY KEY (schedule_id),
    CONSTRAINT fk_schedule_airline
        FOREIGN KEY (airline_id) REFERENCES gold.airline_master (airline_id),
    CONSTRAINT fk_schedule_origin_airport
        FOREIGN KEY (origin_airport_id) REFERENCES gold.airport_master (airport_id),
    CONSTRAINT fk_schedule_destination_airport
        FOREIGN KEY (destination_airport_id) REFERENCES gold.airport_master (airport_id)
)
CLUSTER BY (effective_date)
COMMENT = 'Schedule Domain: future/planned flight schedules published by airlines';

-- ============================================================================
-- OPERATIONS DOMAIN
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FLIGHT_OPERATIONS
-- FK: airline_id, aircraft_id, origin/destination_airport_id, schedule_id
-- Grain: one row per actual (operated) flight.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.flight_operations (
    flight_key                NUMBER(38,0)  IDENTITY(1,1),
    airline_id                 NUMBER(38,0)  NOT NULL,   -- FK -> gold.airline_master
    aircraft_id                 NUMBER(38,0),             -- FK -> gold.aircraft_master
    origin_airport_id            NUMBER(38,0),             -- FK -> gold.airport_master (nullable, Assumption #6)
    destination_airport_id        NUMBER(38,0)  NOT NULL,   -- FK -> gold.airport_master
    schedule_id                    NUMBER(38,0),             -- FK -> gold.airline_schedules
    flight_date                     DATE          NOT NULL,
    actual_departure_ts              TIMESTAMP_NTZ,
    actual_arrival_ts                 TIMESTAMP_NTZ,
    delay_minutes                      NUMBER(6,0),
    cancellation_flag                   BOOLEAN       NOT NULL DEFAULT FALSE,
    diversion_flag                       BOOLEAN       NOT NULL DEFAULT FALSE,
    flight_status                         VARCHAR(30),
    CONSTRAINT pk_flight_operations PRIMARY KEY (flight_key),
    CONSTRAINT fk_flightops_airline
        FOREIGN KEY (airline_id) REFERENCES gold.airline_master (airline_id),
    CONSTRAINT fk_flightops_aircraft
        FOREIGN KEY (aircraft_id) REFERENCES gold.aircraft_master (aircraft_id),
    CONSTRAINT fk_flightops_origin_airport
        FOREIGN KEY (origin_airport_id) REFERENCES gold.airport_master (airport_id),
    CONSTRAINT fk_flightops_destination_airport
        FOREIGN KEY (destination_airport_id) REFERENCES gold.airport_master (airport_id),
    CONSTRAINT fk_flightops_schedule
        FOREIGN KEY (schedule_id) REFERENCES gold.airline_schedules (schedule_id)
)
CLUSTER BY (flight_date)
COMMENT = 'Operations Domain: actual flight operations and performance data';

-- ============================================================================
-- EVENT DOMAIN (HUB)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FLIGHT_EVENTS
-- FK: flight_key -> flight_operations
-- Grain: one row per event message emitted for a flight (high volume).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.flight_events (
    event_id           NUMBER(38,0)  IDENTITY(1,1),
    flight_key           NUMBER(38,0)  NOT NULL,   -- FK -> gold.flight_operations
    event_type            VARCHAR(50),               -- denormalized attribute (Assumption #2)
    event_timestamp         TIMESTAMP_NTZ,
    producer_system           VARCHAR(100),
    event_payload              VARIANT,             -- semi-structured payload (Assumption #3)
    CONSTRAINT pk_flight_events PRIMARY KEY (event_id),
    CONSTRAINT fk_events_flight
        FOREIGN KEY (flight_key) REFERENCES gold.flight_operations (flight_key)
)
CLUSTER BY (event_timestamp)
COMMENT = 'Event Domain (Hub): high-volume event stream from legacy Hub, migrating to Kafka';

-- ============================================================================
-- HISTORICAL ANALYTICS DOMAIN
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FLIGHT_HISTORY
-- FK: flight_key -> flight_operations, airline_id -> airline_master
-- route_key has no reference table in this model (Assumption #1) --
-- carried as an un-enforced attribute.
-- Grain: one row per historical flight performance record (~30yr retention).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TABLE gold.flight_history (
    history_id        NUMBER(38,0)  IDENTITY(1,1),
    flight_key          NUMBER(38,0),               -- FK -> gold.flight_operations (nullable: archive may predate operational grain)
    airline_id            NUMBER(38,0),               -- FK -> gold.airline_master
    route_key               NUMBER(38,0),             -- no ROUTE_MASTER exists in this model (Assumption #1) -- not FK-enforced
    flight_date               DATE,
    delay_minutes              NUMBER(6,0),
    cancelled_flag               BOOLEAN,
    load_factor                    NUMBER(5,2),
    data_source                      VARCHAR(100),
    ingestion_date                    DATE,
    CONSTRAINT pk_flight_history PRIMARY KEY (history_id),
    CONSTRAINT fk_history_flight
        FOREIGN KEY (flight_key) REFERENCES gold.flight_operations (flight_key),
    CONSTRAINT fk_history_airline
        FOREIGN KEY (airline_id) REFERENCES gold.airline_master (airline_id)
)
CLUSTER BY (flight_date)
COMMENT = 'Historical Analytics Domain: long-term historical flight performance and metrics (~30 years retention)';

-- ============================================================================
-- END OF GOLD LAYER DDL -- MODEL 2
-- Tables created: 10 (3 Reference + 2 Customer masters + 1 subscription +
--                      1 Schedule + 1 Operations + 1 Event + 1 History)
-- 8 open assumptions listed in the header above -- please confirm before
-- I finalize the Bronze/Silver traceability map and DDL for Model 2.
-- ============================================================================
