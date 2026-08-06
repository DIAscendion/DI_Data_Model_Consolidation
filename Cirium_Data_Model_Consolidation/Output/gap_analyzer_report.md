### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 98 | 100% |
| Attributes mapped ≥80% match | 46 | 46.9% |
| Attributes mapped 40–79% match | 29 | 29.6% |
| Attributes not mapped (no match ≥40) | 23 | 23.5% |
| Total matched pairs identified | 56 | — |
| Total unmatched columns | 23 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Name and glossary identical; sample data both show airline IATA/ICAO codes | Cast VARCHAR(20) to VARCHAR(20); enforce UNIQUE |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Name and glossary identical; sample data both show airline names | Cast VARCHAR(200) to VARCHAR(200) |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Name and glossary identical; sample data both show countries | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Name and glossary identical; sample data both boolean TRUE/FALSE | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Name and glossary identical; both show aircraft tail numbers | Cast VARCHAR(20) to VARCHAR(20); enforce UNIQUE |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Name and glossary identical; both show aircraft type text | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Name and glossary identical; both show manufacturer names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 98 | Name similarity (operator_airline_key ≈ operator_airline_id); both link to airline; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | dim_aircraft | delivery_year | Snowflake | aircraft_master | delivery_date | 70 | Glossary match (delivery year/date); sample data both represent delivery time; Redshift is SMALLINT year, Snowflake is DATE | Transform SMALLINT year to DATE (YYYY-01-01) |
| Redshift | dim_aircraft | retirement_year | Snowflake | aircraft_master | retirement_date | 70 | Glossary match (retirement year/date); sample data both represent retirement time; Redshift is SMALLINT year, Snowflake is DATE | Transform SMALLINT year to DATE (YYYY-12-31) |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Name and glossary identical; both show airport codes | Cast VARCHAR(20) to VARCHAR(20); enforce UNIQUE |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Name and glossary identical; both show airport names | Cast VARCHAR(200) to VARCHAR(200) |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Name and glossary identical; both show city names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Name and glossary identical; both show country names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Name and glossary identical; both show decimal latitude | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Name and glossary identical; both show decimal longitude | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Name and glossary identical; both show time zone names | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Name and glossary identical; both show customer names | Cast VARCHAR(200) to VARCHAR(200) |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Name and glossary identical; both show customer type text | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Name and glossary identical; both show country names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Name and glossary identical; both boolean TRUE/FALSE | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Name and glossary identical; both show product names | Cast VARCHAR(200) to VARCHAR(200) |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Name and glossary identical; both show domain names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Name and glossary identical; both show delivery type text | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Name and glossary identical; both show product descriptions | Cast VARCHAR(1000) to VARCHAR(1000) |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Name and glossary identical; both boolean TRUE/FALSE | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 95 | Name similarity (customer_key ≈ customer_id); both glossary: customer reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 95 | Name similarity (product_key ≈ data_product_id); both glossary: product reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Name and glossary identical; both show subscription start date | Cast DATE to DATE |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Name and glossary identical; both show subscription end date | Cast DATE to DATE |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 90 | Name similarity (subscription_tier ≈ tier); both glossary: subscription level; sample data both show Standard/Premium/Enterprise | Map values 1:1; Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 90 | Name similarity (subscription_status ≈ status); both glossary: subscription status; sample data both show Active/Trial/Paused/Cancelled | Map values 1:1; Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 100 | Name and glossary identical; both show unique flight identifier | Cast BIGINT to NUMBER(38,0); enforce NOT NULL + UNIQUE |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 98 | Name similarity (airline_key ≈ airline_id); both glossary: airline reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 98 | Name similarity (aircraft_key ≈ aircraft_id); both glossary: aircraft reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 98 | Name similarity (origin_airport_key ≈ origin_airport_id); both glossary: airport reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 98 | Name similarity (destination_airport_key ≈ destination_airport_id); both glossary: airport reference; sample data both integer foreign keys | Cast INTEGER to NUMBER(38,0); maintain referential integrity |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Name and glossary identical; both show schedule identifier | Cast VARCHAR(50) to NUMBER(38,0) (if needed: map string ID to numeric) |
| Redshift | fact_flight_operations | actual_departure_ts | Snowflake | flight_operations | actual_departure_ts | 100 | Name and glossary identical; both show actual departure timestamp | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | actual_arrival_ts | Snowflake | flight_operations | actual_arrival_ts | 100 | Name and glossary identical; both show actual arrival timestamp | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Name and glossary identical; both show delay in minutes | Cast INTEGER to NUMBER(6,0) |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 95 | Name similarity (cancelled_flag ≈ cancellation_flag); both glossary: flight cancellation; sample data both boolean | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 95 | Name similarity (diverted_flag ≈ diversion_flag); both glossary: flight diversion; sample data both boolean | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_operations | block_hours | Snowflake | flight_operations | flight_status | 45 | Weak match: block_hours (duration) ≈ flight_status (derived status); sample data: Redshift numeric hours, Snowflake status code | Map block_hours to ON_TIME/DELAYED/EARLY using business logic (best score: 45) |
| Redshift | dim_event_type | event_type_name | Snowflake | flight_events | event_type | 75 | Glossary similarity (event_type_name ≈ event_type); sample data: Redshift event types, Snowflake denormalized event text | Map event_type_name to event_type via lookup table |
| Redshift | fact_flight_events | flight_key | Snowflake | flight_events | flight_key | 100 | Name and glossary identical; both show flight identifier | Cast BIGINT to NUMBER(38,0) |
| Redshift | fact_flight_events | event_type_key | Snowflake | flight_events | event_type | 45 | Weak match: event_type_key (FK) ≈ event_type (text); sample data: Redshift integer FK, Snowflake text | Map event_type_key to event_type using Redshift event type reference |
| Redshift | fact_flight_events | event_timestamp | Snowflake | flight_events | event_timestamp | 100 | Name and glossary identical; both show event timestamp | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_events | producer_system | Snowflake | flight_events | producer_system | 100 | Name and glossary identical; both show producer system | Cast VARCHAR(100) to VARCHAR(100) |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_airline | alliance | VARCHAR(100) | Alliance names (e.g., Oneworld, SkyTeam) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Carrier type (e.g., Mainline, Low Cost) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | region | VARCHAR(100) | Region names (e.g., North America, Asia) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | iata_code | VARCHAR(10) | IATA code (e.g., ATL) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | icao_code | VARCHAR(10) | ICAO code (e.g., KATL) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | segment | VARCHAR(100) | Segment names (e.g., Enterprise, Mid-Market) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_customer | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |