-- ============================================================================
-- MODEL 1 : AVIATION ANALYTICS -- GOLD LAYER DDL
-- Platform : Amazon Redshift  (source diagram states "Redshift = Current State")
-- Layer    : Gold (business-ready star schema -- facts + dimensions)
--
-- Rules applied:
--   * Structure matches the attached Gold ER image EXACTLY -- no renamed or
--     redesigned tables/columns.
--   * Surrogate keys on every dimension, generated via IDENTITY, except
--     DIM_DATE which uses a smart key (YYYYMMDD INTEGER) -- standard
--     practice for date dimensions and still matches the image's
--     "date_key (PK)" column.
--   * SCD strategy: ASSUMPTION -- no SCD tracking columns (effective_date,
--     end_date, is_current) appear anywhere in the Gold image, so every
--     dimension defaults to SCD TYPE 1 (overwrite on change / MERGE-update
--     in place). Flag back if DIM_AIRCRAFT (operator_airline_key) or any
--     other dimension needs SCD TYPE 2 history tracking instead.
--   * PRIMARY KEY / FOREIGN KEY declared as optimizer hints only -- Redshift
--     does not enforce referential integrity, enforcement happens in the
--     Silver->Gold stored procedures.
--   * FACT_AIRCRAFT_UTILIZATION and FACT_ROUTE_PERFORMANCE are pre-aggregated
--     facts with no direct 1:1 Silver source -- populated by aggregation
--     logic in their Silver->Gold load procedures.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- ============================================================================
-- DIMENSIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- DIM_DATE
-- No Bronze/Silver source table -- generated procedurally.
-- Smart key (YYYYMMDD) used instead of IDENTITY so the key is deterministic
-- and human-readable, still satisfies "date_key (PK)" from the image.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_date;
CREATE TABLE gold.dim_date (
    date_key                  INTEGER        NOT NULL,   -- YYYYMMDD smart key
    date                      DATE           NOT NULL,
    day                       SMALLINT       NOT NULL,
    week                      SMALLINT       NOT NULL,
    month                     SMALLINT       NOT NULL,
    quarter                   SMALLINT       NOT NULL,
    year                      SMALLINT       NOT NULL,
    is_weekend_flag           BOOLEAN        NOT NULL,
    holiday_flag              BOOLEAN        NOT NULL DEFAULT FALSE,
    PRIMARY KEY (date_key)
)
DISTSTYLE ALL
SORTKEY (date_key);

-- ----------------------------------------------------------------------------
-- DIM_AIRLINE
-- Source lineage: brz_airline_master -> slv_airline
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_airline;
CREATE TABLE gold.dim_airline (
    airline_key                INTEGER        IDENTITY(1,1),
    airline_code                VARCHAR(20)    NOT NULL,
    airline_name                 VARCHAR(200)   NOT NULL,
    country                      VARCHAR(100),
    alliance                     VARCHAR(100),
    carrier_type                 VARCHAR(50),
    active_flag                  BOOLEAN        NOT NULL DEFAULT TRUE,
    PRIMARY KEY (airline_key)
)
DISTSTYLE ALL
SORTKEY (airline_key);

-- ----------------------------------------------------------------------------
-- DIM_AIRCRAFT
-- Source lineage: brz_aircraft_registry -> slv_aircraft
-- FK: operator_airline_key -> dim_airline
-- SCD: TYPE 1 (ASSUMPTION -- see header notes)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_aircraft;
CREATE TABLE gold.dim_aircraft (
    aircraft_key                INTEGER        IDENTITY(1,1),
    tail_number                  VARCHAR(20)    NOT NULL,
    aircraft_type                VARCHAR(100),
    manufacturer                 VARCHAR(100),
    delivery_year                SMALLINT,
    retirement_year               SMALLINT,
    operator_airline_key          INTEGER,       -- FK -> gold.dim_airline.airline_key
    PRIMARY KEY (aircraft_key),
    FOREIGN KEY (operator_airline_key) REFERENCES gold.dim_airline (airline_key)
)
DISTSTYLE ALL
SORTKEY (aircraft_key);

-- ----------------------------------------------------------------------------
-- DIM_EVENT_TYPE
-- Source lineage: brz_event_type_ref -> slv_event_type
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_event_type;
CREATE TABLE gold.dim_event_type (
    event_type_key               INTEGER        IDENTITY(1,1),
    event_type_name               VARCHAR(200)   NOT NULL,
    event_category                 VARCHAR(100),
    description                    VARCHAR(1000),
    PRIMARY KEY (event_type_key)
)
DISTSTYLE ALL
SORTKEY (event_type_key);

-- ----------------------------------------------------------------------------
-- DIM_AIRPORT
-- Source lineage: brz_airport_master -> slv_airport
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_airport;
CREATE TABLE gold.dim_airport (
    airport_key                  INTEGER        IDENTITY(1,1),
    airport_code                  VARCHAR(20)    NOT NULL,
    airport_name                   VARCHAR(200),
    city                            VARCHAR(100),
    country                         VARCHAR(100),
    region                          VARCHAR(100),
    iata_code                       VARCHAR(10),
    icao_code                       VARCHAR(10),
    latitude                        DECIMAL(9,6),
    longitude                       DECIMAL(9,6),
    timezone                        VARCHAR(50),
    PRIMARY KEY (airport_key)
)
DISTSTYLE ALL
SORTKEY (airport_key);

-- ----------------------------------------------------------------------------
-- DIM_ROUTE
-- Source lineage: brz_route_master -> slv_route
-- FK: origin_airport_key, destination_airport_key -> dim_airport
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_route;
CREATE TABLE gold.dim_route (
    route_key                    INTEGER        IDENTITY(1,1),
    origin_airport_key            INTEGER,       -- FK -> gold.dim_airport.airport_key
    destination_airport_key        INTEGER,       -- FK -> gold.dim_airport.airport_key
    route_distance_miles           DECIMAL(10,2),
    region                          VARCHAR(100),
    route_type                      VARCHAR(50),
    domestic_international          VARCHAR(20),
    PRIMARY KEY (route_key),
    FOREIGN KEY (origin_airport_key) REFERENCES gold.dim_airport (airport_key),
    FOREIGN KEY (destination_airport_key) REFERENCES gold.dim_airport (airport_key)
)
DISTSTYLE ALL
SORTKEY (route_key);

-- ----------------------------------------------------------------------------
-- DIM_CUSTOMER
-- Source lineage: brz_customer -> slv_customer
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_customer;
CREATE TABLE gold.dim_customer (
    customer_key                  INTEGER        IDENTITY(1,1),
    customer_name                  VARCHAR(200)   NOT NULL,
    customer_type                   VARCHAR(50),
    country                         VARCHAR(100),
    segment                         VARCHAR(100),
    active_flag                     BOOLEAN        NOT NULL DEFAULT TRUE,
    PRIMARY KEY (customer_key)
)
DISTSTYLE ALL
SORTKEY (customer_key);

-- ----------------------------------------------------------------------------
-- DIM_DATA_PRODUCT
-- Source lineage: brz_data_product -> slv_data_product
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.dim_data_product;
CREATE TABLE gold.dim_data_product (
    product_key                   INTEGER        IDENTITY(1,1),
    product_name                   VARCHAR(200)   NOT NULL,
    domain                          VARCHAR(100),
    delivery_type                   VARCHAR(50),
    description                     VARCHAR(1000),
    active_flag                     BOOLEAN        NOT NULL DEFAULT TRUE,
    PRIMARY KEY (product_key)
)
DISTSTYLE ALL
SORTKEY (product_key);

-- ============================================================================
-- FACTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FACT_FLIGHT_OPERATIONS
-- Grain: one row per flight leg operated.
-- Source lineage: brz_flight_operations -> slv_flight_operations
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_flight_operations;
CREATE TABLE gold.fact_flight_operations (
    flight_key                     BIGINT         IDENTITY(1,1),
    date_key                        INTEGER        NOT NULL,  -- FK -> dim_date
    airline_key                     INTEGER,                  -- FK -> dim_airline
    aircraft_key                    INTEGER,                  -- FK -> dim_aircraft
    route_key                       INTEGER,                  -- FK -> dim_route
    origin_airport_key               INTEGER,                  -- FK -> dim_airport
    destination_airport_key          INTEGER,                  -- FK -> dim_airport
    schedule_id                       VARCHAR(50),
    scheduled_departure_ts             TIMESTAMP,
    actual_departure_ts                TIMESTAMP,
    scheduled_arrival_ts               TIMESTAMP,
    actual_arrival_ts                  TIMESTAMP,
    delay_minutes                       INTEGER,
    taxi_out_minutes                    INTEGER,
    taxi_in_minutes                     INTEGER,
    flight_distance_miles                DECIMAL(10,2),
    block_hours                         DECIMAL(6,2),
    cancelled_flag                      BOOLEAN        NOT NULL DEFAULT FALSE,
    diverted_flag                       BOOLEAN        NOT NULL DEFAULT FALSE,
    PRIMARY KEY (flight_key),
    FOREIGN KEY (date_key) REFERENCES gold.dim_date (date_key),
    FOREIGN KEY (airline_key) REFERENCES gold.dim_airline (airline_key),
    FOREIGN KEY (aircraft_key) REFERENCES gold.dim_aircraft (aircraft_key),
    FOREIGN KEY (route_key) REFERENCES gold.dim_route (route_key),
    FOREIGN KEY (origin_airport_key) REFERENCES gold.dim_airport (airport_key),
    FOREIGN KEY (destination_airport_key) REFERENCES gold.dim_airport (airport_key)
)
DISTSTYLE KEY
DISTKEY (airline_key)
SORTKEY (date_key);

-- ----------------------------------------------------------------------------
-- FACT_FLIGHT_EVENTS
-- Grain: one row per flight event message emitted on the operational event bus.
-- Source lineage: brz_flight_events -> slv_flight_events
-- FK: flight_key -> fact_flight_operations, event_type_key -> dim_event_type
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_flight_events;
CREATE TABLE gold.fact_flight_events (
    event_key                      BIGINT         IDENTITY(1,1),
    flight_key                      BIGINT,                    -- FK -> fact_flight_operations
    event_type_key                   INTEGER,                   -- FK -> dim_event_type
    date_key                          INTEGER        NOT NULL,  -- FK -> dim_date
    event_timestamp                    TIMESTAMP,
    producer_system                     VARCHAR(100),
    consumer_system                     VARCHAR(100),
    message_size_bytes                   INTEGER,
    event_count                          INTEGER,
    PRIMARY KEY (event_key),
    FOREIGN KEY (flight_key) REFERENCES gold.fact_flight_operations (flight_key),
    FOREIGN KEY (event_type_key) REFERENCES gold.dim_event_type (event_type_key),
    FOREIGN KEY (date_key) REFERENCES gold.dim_date (date_key)
)
DISTSTYLE KEY
DISTKEY (flight_key)
SORTKEY (event_timestamp);

-- ----------------------------------------------------------------------------
-- FACT_AIRCRAFT_UTILIZATION
-- Grain: one row per aircraft per date (pre-aggregated).
-- No direct Bronze/Silver source -- built by aggregating
-- slv_aircraft_maintenance + slv_flight_operations in the Gold load proc.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_aircraft_utilization;
CREATE TABLE gold.fact_aircraft_utilization (
    utilization_key                 BIGINT         IDENTITY(1,1),
    date_key                         INTEGER        NOT NULL,  -- FK -> dim_date
    aircraft_key                      INTEGER,                  -- FK -> dim_aircraft
    flight_count                       INTEGER        NOT NULL DEFAULT 0,
    utilization_hours                   DECIMAL(10,2),
    ground_hours                        DECIMAL(10,2),
    maintenance_hours                    DECIMAL(10,2),
    average_delay_minutes                 DECIMAL(10,2),
    PRIMARY KEY (utilization_key),
    FOREIGN KEY (date_key) REFERENCES gold.dim_date (date_key),
    FOREIGN KEY (aircraft_key) REFERENCES gold.dim_aircraft (aircraft_key)
)
DISTSTYLE KEY
DISTKEY (aircraft_key)
SORTKEY (date_key);

-- ----------------------------------------------------------------------------
-- FACT_ROUTE_PERFORMANCE
-- Grain: one row per route per date (pre-aggregated).
-- No direct Bronze/Silver source -- built by aggregating
-- slv_flight_operations in the Gold load proc.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_route_performance;
CREATE TABLE gold.fact_route_performance (
    route_perf_key                  BIGINT         IDENTITY(1,1),
    date_key                         INTEGER        NOT NULL,  -- FK -> dim_date
    route_key                         INTEGER,                  -- FK -> dim_route
    flight_count                       INTEGER        NOT NULL DEFAULT 0,
    delay_count                        INTEGER        NOT NULL DEFAULT 0,
    cancel_count                       INTEGER        NOT NULL DEFAULT 0,
    avg_delay_minutes                   DECIMAL(10,2),
    otp_percentage                      DECIMAL(5,2),
    PRIMARY KEY (route_perf_key),
    FOREIGN KEY (date_key) REFERENCES gold.dim_date (date_key),
    FOREIGN KEY (route_key) REFERENCES gold.dim_route (route_key)
)
DISTSTYLE KEY
DISTKEY (route_key)
SORTKEY (date_key);

-- ----------------------------------------------------------------------------
-- FACT_FLIGHT_HISTORY
-- Grain: one row per historical flight record (30+ year retention).
-- Source lineage: brz_flight_history_archive -> slv_flight_history
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_flight_history;
CREATE TABLE gold.fact_flight_history (
    history_key                     BIGINT         IDENTITY(1,1),
    flight_key                       BIGINT,                    -- FK -> fact_flight_operations
    airline_key                      INTEGER,                   -- FK -> dim_airline
    route_key                        INTEGER,                   -- FK -> dim_route
    date_key                         INTEGER        NOT NULL,   -- FK -> dim_date
    delay_minutes                     INTEGER,
    cancelled_flag                     BOOLEAN        NOT NULL DEFAULT FALSE,
    load_factor                        DECIMAL(5,2),
    data_source                        VARCHAR(100),
    PRIMARY KEY (history_key),
    FOREIGN KEY (flight_key) REFERENCES gold.fact_flight_operations (flight_key),
    FOREIGN KEY (airline_key) REFERENCES gold.dim_airline (airline_key),
    FOREIGN KEY (route_key) REFERENCES gold.dim_route (route_key),
    FOREIGN KEY (date_key) REFERENCES gold.dim_date (date_key)
)
DISTSTYLE KEY
DISTKEY (flight_key)
SORTKEY (date_key);

-- ----------------------------------------------------------------------------
-- FACT_PRODUCT_SUBSCRIPTIONS
-- Grain: one row per customer product subscription.
-- Source lineage: brz_subscription -> slv_subscription
-- FK: customer_key -> dim_customer, product_key -> dim_data_product
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS gold.fact_product_subscriptions;
CREATE TABLE gold.fact_product_subscriptions (
    subscription_key                 BIGINT         IDENTITY(1,1),
    customer_key                      INTEGER,                   -- FK -> dim_customer
    product_key                       INTEGER,                   -- FK -> dim_data_product
    start_date                         DATE,
    end_date                           DATE,
    subscription_tier                  VARCHAR(50),
    subscription_status                VARCHAR(50),
    PRIMARY KEY (subscription_key),
    FOREIGN KEY (customer_key) REFERENCES gold.dim_customer (customer_key),
    FOREIGN KEY (product_key) REFERENCES gold.dim_data_product (product_key)
)
DISTSTYLE KEY
DISTKEY (customer_key)
SORTKEY (start_date);

-- ============================================================================
-- END OF GOLD LAYER DDL -- MODEL 1
-- Tables created: 8 dimensions + 7 facts = 15
-- ============================================================================
