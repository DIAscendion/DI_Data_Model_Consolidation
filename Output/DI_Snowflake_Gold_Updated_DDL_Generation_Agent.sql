-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET DATA TYPE INTEGER;
ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET NOT NULL;
ALTER TABLE gold.airline_master ADD CONSTRAINT uq_airline_master_airline_id UNIQUE (airline_id);
ALTER TABLE gold.airline_master ADD COLUMN alliance VARCHAR(100);
ALTER TABLE gold.airline_master ADD COLUMN carrier_type VARCHAR(50);

-- TABLE: gold.aircraft_master
ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET DATA TYPE INTEGER;
ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET NOT NULL;
ALTER TABLE gold.aircraft_master ADD CONSTRAINT uq_aircraft_master_aircraft_id UNIQUE (aircraft_id);
ALTER TABLE gold.aircraft_master ALTER COLUMN operator_airline_id SET DATA TYPE INTEGER;
-- SKIPPED: gold.aircraft_master.delivery_year — Review with business — possible manual mapping needed
-- SKIPPED: gold.aircraft_master.retirement_year — Review with business — possible manual mapping needed

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ALTER COLUMN airport_id SET DATA TYPE INTEGER;
ALTER TABLE gold.airport_master ALTER COLUMN airport_id SET NOT NULL;
ALTER TABLE gold.airport_master ADD CONSTRAINT uq_airport_master_airport_id UNIQUE (airport_id);
ALTER TABLE gold.airport_master ADD COLUMN region VARCHAR(100);
ALTER TABLE gold.airport_master ADD COLUMN iata_code VARCHAR(10);
ALTER TABLE gold.airport_master ADD COLUMN icao_code VARCHAR(10);

-- TABLE: gold.customer_master
ALTER TABLE gold.customer_master ALTER COLUMN customer_id SET DATA TYPE INTEGER;
ALTER TABLE gold.customer_master ALTER COLUMN customer_id SET NOT NULL;
ALTER TABLE gold.customer_master ADD CONSTRAINT uq_customer_master_customer_id UNIQUE (customer_id);

-- TABLE: gold.data_products
ALTER TABLE gold.data_products ALTER COLUMN data_product_id SET DATA TYPE INTEGER;
ALTER TABLE gold.data_products ALTER COLUMN data_product_id SET NOT NULL;
ALTER TABLE gold.data_products ADD CONSTRAINT uq_data_products_data_product_id UNIQUE (data_product_id);

-- TABLE: gold.customer_subscriptions
ALTER TABLE gold.customer_subscriptions ALTER COLUMN suscription_id SET DATA TYPE BIGINT;
ALTER TABLE gold.customer_subscriptions ALTER COLUMN suscription_id SET NOT NULL;
ALTER TABLE gold.customer_subscriptions ADD CONSTRAINT uq_customer_subscriptions_suscription_id UNIQUE (suscription_id);
ALTER TABLE gold.customer_subscriptions ALTER COLUMN customer_id SET DATA TYPE INTEGER;
ALTER TABLE gold.customer_subscriptions ALTER COLUMN data_product_id SET DATA TYPE INTEGER;
ALTER TABLE gold.customer_subscriptions RENAME COLUMN tier TO subscription_tier;
ALTER TABLE gold.customer_subscriptions RENAME COLUMN status TO subscription_status;

-- TABLE: gold.flight_operations
ALTER TABLE gold.flight_operations ALTER COLUMN flight_key SET DATA TYPE BIGINT;
ALTER TABLE gold.flight_operations ALTER COLUMN flight_key SET NOT NULL;
ALTER TABLE gold.flight_operations ADD CONSTRAINT uq_flight_operations_flight_key UNIQUE (flight_key);
ALTER TABLE gold.flight_operations ALTER COLUMN airline_id SET DATA TYPE INTEGER;
ALTER TABLE gold.flight_operations ALTER COLUMN aircraft_id SET DATA TYPE INTEGER;
ALTER TABLE gold.flight_operations ALTER COLUMN origin_airport_id SET DATA TYPE INTEGER;
ALTER TABLE gold.flight_operations ALTER COLUMN destination_airport_id SET DATA TYPE INTEGER;
-- SKIPPED: gold.flight_operations.schedule_id — Transformation rule ambiguous: "Cast VARCHAR(50) to NUMBER(38,0) or vice versa, depending on canonical model"
ALTER TABLE gold.flight_operations RENAME COLUMN cancellation_flag TO cancelled_flag;
ALTER TABLE gold.flight_operations RENAME COLUMN diversion_flag TO diverted_flag;

-- SKIPPED: gold.dim_event_type.event_type_key — Table dim_event_type not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_event_type.event_type_name — Table dim_event_type not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_event_type.event_category — Table dim_event_type not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_event_type.description — Table dim_event_type not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.route_key — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.origin_airport_key — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.destination_airport_key — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.route_distance_miles — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.region — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.route_type — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only
-- SKIPPED: gold.dim_route.domestic_international — Table dim_route not present in current DDL; would require new table, out of scope for ALTER-only