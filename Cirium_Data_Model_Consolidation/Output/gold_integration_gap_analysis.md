### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 94 | 100% |
| Attributes mapped ≥80% match | 43 | 45.7% |
| Attributes mapped 40–79% match | 33 | 35.1% |
| Attributes not mapped (no match ≥40) | 18 | 19.1% |
| Total matched pairs identified | 57 | — |
| Total unmatched columns | 18 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 97 | Name similarity (airline_key ≈ airline_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Exact name match and identical sample data; both unique airline codes | Enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Exact name match and identical sample data; both are airline names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Exact name match and identical sample data; both are country names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Exact name match and identical sample data; both are boolean flags (TRUE/FALSE) | Cast BOOLEAN to BOOLEAN; enforce NOT NULL; direct 1:1 map |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 97 | Name similarity (aircraft_key ≈ aircraft_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Exact name match and identical sample data; both are tail numbers | Enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Exact name match and identical sample data; both are aircraft types | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Exact name match and identical sample data; both are manufacturers | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 93 | Name similarity (operator_airline_key ≈ operator_airline_id); both are foreign keys to airline; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 97 | Name similarity (airport_key ≈ airport_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Exact name match and identical sample data; both are airport codes | Enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Exact name match and identical sample data; both are airport names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Exact name match and identical sample data; both are city names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Exact name match and identical sample data; both are country names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 98 | Name similarity; both are decimal latitude values | Cast DECIMAL(9,6) to NUMBER(9,6); direct map |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 98 | Name similarity; both are decimal longitude values | Cast DECIMAL(9,6) to NUMBER(9,6); direct map |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Exact name match and identical sample data; both are timezone strings | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 97 | Name similarity (customer_key ≈ customer_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Exact name match and identical sample data; both are customer names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Exact name match and identical sample data; both are customer types | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Exact name match and identical sample data; both are country names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Exact name match and identical sample data; both are boolean flags (TRUE/FALSE) | Cast BOOLEAN to BOOLEAN; enforce NOT NULL; direct 1:1 map |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 97 | Name similarity (product_key ≈ data_product_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name match and identical sample data; both are product names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name match and identical sample data; both are domain names | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name match and identical sample data; both are delivery types | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name match and identical sample data; both are descriptions | Enforce NOT NULL; direct 1:1 map |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Exact name match and identical sample data; both are boolean flags (TRUE/FALSE) | Cast BOOLEAN to BOOLEAN; enforce NOT NULL; direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 90 | Name similarity (subscription_key ≈ suscription_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 97 | Name similarity (customer_key ≈ customer_id); both are FKs to customer; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 97 | Name similarity (product_key ≈ data_product_id); both are FKs to product; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Exact name match and identical sample data; both are dates | Cast DATE to DATE; enforce NOT NULL |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Exact name match and identical sample data; both are dates | Cast DATE to DATE; enforce NOT NULL |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 88 | Name similarity (subscription_tier ≈ tier); both are subscription levels; sample data both use similar values | Map values Standard/Premium/Enterprise/Basic as-is; direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 88 | Name similarity (subscription_status ≈ status); both are subscription statuses; sample data both use similar values | Map values Active/Paused/Cancelled/Expired/Trial as-is; direct 1:1 map |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 100 | Exact name match and identical sample data; both are surrogate keys; numeric | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 97 | Name similarity (airline_key ≈ airline_id); both are FKs to airline; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 97 | Name similarity (aircraft_key ≈ aircraft_id); both are FKs to aircraft; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 93 | Name similarity (origin_airport_key ≈ origin_airport_id); both are FKs to airport; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 93 | Name similarity (destination_airport_key ≈ destination_airport_id); both are FKs to airport; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Exact name match and identical sample data; both are schedule references | Cast VARCHAR(50) to NUMBER(38,0); use reference mapping |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Exact name match and identical sample data; both are integer minute values | Cast INTEGER to NUMBER(6,0); enforce NOT NULL |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 97 | Name similarity (cancelled_flag ≈ cancellation_flag); both are boolean flags | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 97 | Name similarity (diverted_flag ≈ diversion_flag); both are boolean flags | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_operations | actual_departure_ts | Snowflake | flight_operations | actual_departure_ts | 100 | Exact name match and identical sample data; both are timestamps | Cast TIMESTAMP to TIMESTAMP_NTZ; enforce NOT NULL |
| Redshift | fact_flight_operations | actual_arrival_ts | Snowflake | flight_operations | actual_arrival_ts | 100 | Exact name match and identical sample data; both are timestamps | Cast TIMESTAMP to TIMESTAMP_NTZ; enforce NOT NULL |
| Redshift | fact_flight_operations | block_hours | Snowflake | flight_operations | (missing) | 45 | Name similarity; both relate to duration of flight, but only Redshift has block_hours; Snowflake uses timestamps | Calculate block_hours as difference between actual_departure_ts and actual_arrival_ts in Snowflake |
| Redshift | fact_flight_history | history_key | Snowflake | flight_history | history_id | 97 | Name similarity (history_key ≈ history_id); both are surrogate keys; sample data both numeric, unique | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_flight_history | flight_key | Snowflake | flight_history | flight_key | 100 | Exact name match and identical sample data; both are FKs to flights | Cast NUMBER(38,0) to BIGINT; enforce FK constraint |
| Redshift | fact_flight_history | airline_key | Snowflake | flight_history | airline_id | 97 | Name similarity (airline_key ≈ airline_id); both are FKs to airline; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_history | route_key | Snowflake | flight_history | route_key | 90 | Name similarity (route_key ≈ route_key); both are numeric route references | Cast INTEGER to NUMBER(38,0); direct map |
| Redshift | fact_flight_history | delay_minutes | Snowflake | flight_history | delay_minutes | 100 | Exact name match and identical sample data; both are integer minute values | Cast INTEGER to NUMBER(6,0); enforce NOT NULL |
| Redshift | fact_flight_history | cancelled_flag | Snowflake | flight_history | cancelled_flag | 100 | Exact name match and identical sample data; both are boolean flags | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_history | load_factor | Snowflake | flight_history | load_factor | 100 | Exact name match and identical sample data; both are decimal (occupancy) | Cast DECIMAL(5,2) to NUMBER(5,2); enforce NOT NULL |
| Redshift | fact_flight_history | data_source | Snowflake | flight_history | data_source | 100 | Exact name match and identical sample data; both are source strings | Enforce NOT NULL; direct 1:1 map |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|------------------|------------|---------------|---------------|----------------------------------|-------------------------------------------------|---------------------------------------------------|
| Redshift | dim_airline | alliance | VARCHAR(100) | Alliance names (Oneworld, Star Alliance, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Carrier types (Mainline, Low Cost, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | delivery_year | SMALLINT | Years (e.g., 2001, 2021) | Best match score below 40 — best score: 37 | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | retirement_year | SMALLINT | Years (e.g., 2023, 2017) | Best match score below 40 — best score: 37 | Review with business — possible manual mapping needed |
| Redshift | dim_airport | region | VARCHAR(100) | Regions (Europe, Asia, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | iata_code | VARCHAR(10) | IATA codes (LHR, JFK, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | icao_code | VARCHAR(10) | ICAO codes (EGLL, KJFK, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_key | INTEGER | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | origin_airport_key | INTEGER | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | destination_airport_key | INTEGER | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | route_distance_miles | DECIMAL(10,2) | Miles (e.g., 8369.35) | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | region | VARCHAR(100) | Regions (e.g., South America-Africa) | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | route_type | VARCHAR(50) | Route types (Long Haul, Short Haul) | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_route | domestic_international | VARCHAR(20) | Domestic/International | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_type_key | INTEGER | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_type_name | VARCHAR(200) | Event names | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_category | VARCHAR(100) | Category names | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_event_type | description | VARCHAR(1000) | Free text | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | fact_flight_operations | flight_distance_miles | DECIMAL(10,2) | Miles (e.g., 3960.84) | Best match score below 40 — best score: 36 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | taxi_out_minutes | INTEGER | Integer (e.g., 28) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | taxi_in_minutes | INTEGER | Integer (e.g., 9) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | scheduled_departure_ts | TIMESTAMP | Timestamp | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | scheduled_arrival_ts | TIMESTAMP | Timestamp | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | date_key | INTEGER | Numeric date key | Best match score below 40 — best score: 35 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | event_key | BIGINT | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | fact_flight_events | event_type_key | INTEGER | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | fact_flight_events | date_key | INTEGER | Numeric date key | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | event_timestamp | TIMESTAMP | Timestamp | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | producer_system | VARCHAR(100) | System names | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | consumer_system | VARCHAR(100) | System names | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | message_size_bytes | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_events | event_count | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | utilization_key | BIGINT | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | fact_aircraft_utilization | date_key | INTEGER | Numeric date key | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | aircraft_key | INTEGER | Numeric IDs | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | flight_count | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | utilization_hours | DECIMAL(10,2) | Decimal hours | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | ground_hours | DECIMAL(10,2) | Decimal hours | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | maintenance_hours | DECIMAL(10,2) | Decimal hours | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_aircraft_utilization | average_delay_minutes | DECIMAL(10,2) | Decimal minutes | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | route_perf_key | BIGINT | Numeric IDs | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | fact_route_performance | date_key | INTEGER | Numeric date key | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | route_key | INTEGER | Numeric IDs | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | flight_count | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | delay_count | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | cancel_count | INTEGER | Integer | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | avg_delay_minutes | DECIMAL(10,2) | Decimal minutes | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_route_performance | otp_percentage | DECIMAL(5,2) | Decimal percent | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | date_key | INTEGER | Numeric date key | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | date | DATE | Date (YYYY-MM-DD) | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | day | SMALLINT | Integer 1–31 | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | week | SMALLINT | Integer 1–53 | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | month | SMALLINT | Integer 1–12 | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | quarter | SMALLINT | Integer 1–4 | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | year | SMALLINT | Integer 4-digit | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | is_weekend_flag | BOOLEAN | TRUE/FALSE | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Redshift | dim_date | holiday_flag | BOOLEAN | TRUE/FALSE | No equivalent table in Snowflake | Add to canonical model as new attribute |
| Snowflake | airline_master | alliance | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | airline_master | carrier_type | VARCHAR(50) | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | aircraft_master | delivery_date | DATE | Date (YYYY-MM-DD) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | aircraft_master | retirement_date | DATE | Date (YYYY-MM-DD) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | flight_status | VARCHAR(30) | Status codes (ON_TIME, DELAYED, etc.) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | flight_date | DATE | Date (YYYY-MM-DD) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | scheduled_departure | TIMESTAMP_NTZ | Timestamp | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | scheduled_arrival | TIMESTAMP_NTZ | Timestamp | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_events | event_type | VARCHAR(50) | Event type codes (e.g., BOARDING_STARTED) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_events | event_payload | VARIANT | JSON payload | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_events | producer_system | VARCHAR(100) | System names | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_history | ingestion_date | DATE | Date (YYYY-MM-DD) | No equivalent column found in any other application | Add to canonical model as new attribute |
| — | — | — | — | — | No unmatched columns | — |