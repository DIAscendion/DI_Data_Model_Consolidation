### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 130 | 100% |
| Attributes mapped ≥80% match | 49 | 37.7% |
| Attributes mapped 40–79% match | 41 | 31.5% |
| Attributes not mapped (no match ≥40) | 40 | 30.8% |
| Total matched pairs identified | 58 | — |
| Total unmatched columns | 40 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 95 | Name similarity (airline_key ≈ airline_id); both PKs, sample data both numeric, unique, incremental | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Exact name and glossary match; sample data both show airline IATA/ICAO codes | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Exact name and glossary match; sample data both show airline names | Direct 1:1 map; enforce VARCHAR(200) NOT NULL |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Exact name and glossary match; country values match in both sample sets | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Exact name and glossary match; sample data both boolean TRUE/FALSE | Direct 1:1 map; enforce BOOLEAN NOT NULL |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 95 | Name similarity (aircraft_key ≈ aircraft_id); both PKs, sample data both numeric, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Exact name and glossary match; sample data both show tail numbers | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Exact name and glossary match; sample data both show aircraft types | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Exact name and glossary match; sample data both show manufacturers | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 90 | Name similarity (operator_airline_key ≈ operator_airline_id); both are FKs to airline, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 95 | Name similarity (airport_key ≈ airport_id); both PKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Exact name and glossary match; sample data both show airport codes | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Exact name and glossary match; sample data both show airport names | Direct 1:1 map; enforce VARCHAR(200) |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Exact name and glossary match; sample data both show city names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Exact name and glossary match; sample data both show country names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Exact name and glossary match; sample data both show decimal latitude | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Exact name and glossary match; sample data both show decimal longitude | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Exact name and glossary match; sample data both show timezones | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 95 | Name similarity (customer_key ≈ customer_id); both PKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Exact name and glossary match; sample data both show customer names | Direct 1:1 map; enforce VARCHAR(200) NOT NULL |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Exact name and glossary match; sample data both show customer types | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Exact name and glossary match; sample data both show country names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Exact name and glossary match; sample data both boolean TRUE/FALSE | Direct 1:1 map; enforce BOOLEAN NOT NULL |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 95 | Name similarity (product_key ≈ data_product_id); both PKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name and glossary match; sample data both show product names | Direct 1:1 map; enforce VARCHAR(200) NOT NULL |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name and glossary match; sample data both show product domains | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name and glossary match; sample data both show delivery types | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name and glossary match; sample data both show product descriptions | Direct 1:1 map; enforce VARCHAR(1000) |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Exact name and glossary match; sample data both boolean TRUE/FALSE | Direct 1:1 map; enforce BOOLEAN NOT NULL |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 90 | Name similarity (subscription_key ≈ suscription_id); both PKs, sample data both numeric | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 95 | Name similarity (customer_key ≈ customer_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 95 | Name similarity (product_key ≈ data_product_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Exact name and glossary match; sample data both dates | Reformat to ISO 8601 YYYY-MM-DD |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Exact name and glossary match; sample data both dates | Reformat to ISO 8601 YYYY-MM-DD |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 90 | Name similarity (subscription_tier ≈ tier); both sample data show similar values | Map column names; direct value map |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 90 | Name similarity (subscription_status ≈ status); both sample data show similar values | Map column names; direct value map |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 100 | Exact name and glossary match; both PKs, sample data both numeric | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 90 | Name similarity (airline_key ≈ airline_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 90 | Name similarity (aircraft_key ≈ aircraft_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 85 | Name similarity (origin_airport_key ≈ origin_airport_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 85 | Name similarity (destination_airport_key ≈ destination_airport_id); both FKs, sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce FK constraint |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 90 | Exact name and glossary match; both are FKs, sample data both numeric | Cast NUMBER(38,0) to VARCHAR(50) or BIGINT as per Snowflake |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Exact name and glossary match; sample data both integer | Direct 1:1 map; enforce INTEGER |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 90 | Name similarity (cancelled_flag ≈ cancellation_flag); both boolean, sample data TRUE/FALSE | Map column names; direct value map |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 90 | Name similarity (diverted_flag ≈ diversion_flag); both boolean, sample data TRUE/FALSE | Map column names; direct value map |
| Redshift | fact_flight_operations | block_hours | Snowflake | flight_operations | actual_arrival_ts | 40 | Possible match; both relate to flight duration but require business review (best score: 40) | Review with business; possible mapping needed |
| Redshift | fact_flight_operations | scheduled_departure_ts | Snowflake | flight_operations | actual_departure_ts | 60 | Probable match; both are timestamps, sample data similar | Map Redshift scheduled_departure_ts to Snowflake actual_departure_ts with timestamp conversion |
| Redshift | fact_flight_operations | scheduled_arrival_ts | Snowflake | flight_operations | actual_arrival_ts | 60 | Probable match; both are timestamps, sample data similar | Map Redshift scheduled_arrival_ts to Snowflake actual_arrival_ts with timestamp conversion |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name and glossary match; sample data both show product names | Direct 1:1 map; enforce VARCHAR(200) NOT NULL |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name and glossary match; sample data both show product domains | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name and glossary match; sample data both show delivery types | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name and glossary match; sample data both show product descriptions | Direct 1:1 map; enforce VARCHAR(1000) |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_airline | alliance | VARCHAR(100) | Free text (Oneworld, SkyTeam, Star Alliance) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Free text (Mainline, Low Cost, Cargo) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airline | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | delivery_year | SMALLINT | Years (e.g., 2001–2023) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | retirement_year | SMALLINT | Years (e.g., 2017–2025) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | effective_start_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | effective_end_date | DATE | No sample data provided | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | event_type_key | INTEGER | Sequential numeric IDs | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_type_name | VARCHAR(200) | Event names (e.g., Departure - Scheduled) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_category | VARCHAR(100) | Event categories (e.g., Departure, Arrival) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | description | VARCHAR(1000) | Free text | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | region | VARCHAR(100) | Free text (e.g., North America) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | iata_code | VARCHAR(10) | 3-letter codes | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | icao_code | VARCHAR(10) | 4-letter codes | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_route | route_key | INTEGER | Sequential numeric IDs | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | origin_airport_key | INTEGER | Numeric FK | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | destination_airport_key | INTEGER | Numeric FK | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_distance_miles | DECIMAL(10,2) | Numeric (e.g., 8369.35) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | region | VARCHAR(100) | Free text | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_type | VARCHAR(50) | Free text | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | domestic_international | VARCHAR(20) | Free text | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_route | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_route | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | block_hours | DECIMAL(6,2) | Numeric (e.g., 8.02) | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | taxi_out_minutes | INTEGER | Numeric | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | fact_flight_operations | taxi_in_minutes | INTEGER | Numeric | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | fact_flight_operations | flight_distance_miles | DECIMAL(10,2) | Numeric | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | fact_flight_operations | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Snowflake | flight_operations | flight_status | VARCHAR(30) | Codes (ON_TIME, DELAYED, CANCELLED, EARLY, DIVERTED) | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | actual_departure_ts | TIMESTAMP_NTZ | Datetime | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Snowflake | flight_operations | actual_arrival_ts | TIMESTAMP_NTZ | Datetime | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Snowflake | flight_operations | schedule_id | NUMBER(38,0) | Numeric | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Snowflake | flight_operations | origin_airport_id | NUMBER(38,0) | Numeric | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
