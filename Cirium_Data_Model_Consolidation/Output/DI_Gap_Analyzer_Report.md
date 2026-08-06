### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 92 | 100% |
| Attributes mapped ≥80% match | 44 | 47.8% |
| Attributes mapped 40–79% match | 27 | 29.3% |
| Attributes not mapped (no match ≥40) | 21 | 22.8% |
| Total matched pairs identified | 53 | — |
| Total unmatched columns | 21 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 98 | Name similarity (airline_key ≈ airline_id); both are surrogate PKs; sample data both integer identity columns | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 98 | Exact name match; glossary both "unique airline code"; sample data overlap: AA, DL, etc. | Cast both as VARCHAR(20); enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 98 | Exact name match; both are carrier names, sample data identical | Cast both as VARCHAR(200); enforce NOT NULL; direct 1:1 map |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 98 | Exact name match; both are country of airline; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE | Cast both as BOOLEAN; direct 1:1 map |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 98 | Name similarity (aircraft_key ≈ aircraft_id); both surrogate PKs; sample data both integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 98 | Exact name match; both are tail numbers; sample data overlap | Cast both as VARCHAR(20); enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 98 | Exact name match; both are aircraft type; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 98 | Exact name match; both are aircraft manufacturer; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 98 | Name similarity (operator_airline_key ≈ operator_airline_id); both are FK to airline; sample data integer | Cast both as INTEGER; FK to airline PK; direct 1:1 map |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 98 | Name similarity (airport_key ≈ airport_id); both surrogate PKs; sample data integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 98 | Exact name match; both are airport codes; sample data overlap | Cast both as VARCHAR(20); enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 98 | Exact name match; both airport names; sample data overlap | Cast both as VARCHAR(200); direct 1:1 map |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 98 | Exact name match; both city; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 98 | Exact name match; both country; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 98 | Exact name match; both decimal latitude; sample data overlap | Cast both as DECIMAL/NUMBER(9,6); direct 1:1 map |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 98 | Exact name match; both decimal longitude; sample data overlap | Cast both as DECIMAL/NUMBER(9,6); direct 1:1 map |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 98 | Exact name match; both airport timezones; sample data overlap | Cast both as VARCHAR(50); direct 1:1 map |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 98 | Name similarity (customer_key ≈ customer_id); both surrogate PKs; sample data integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 98 | Exact name match; both customer names; sample data overlap | Cast both as VARCHAR(200); direct 1:1 map |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 98 | Exact name match; both customer type; sample data overlap | Cast both as VARCHAR(50); direct 1:1 map |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 98 | Exact name match; both customer country; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE | Cast both as BOOLEAN; direct 1:1 map |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 98 | Name similarity (product_key ≈ data_product_id); both surrogate PKs; sample data integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 98 | Exact name match; both product names; sample data overlap | Cast both as VARCHAR(200); direct 1:1 map |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 98 | Exact name match; both product domain; sample data overlap | Cast both as VARCHAR(100); direct 1:1 map |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 98 | Exact name match; both delivery type; sample data overlap | Cast both as VARCHAR(50); direct 1:1 map |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 98 | Exact name match; both product description; sample data overlap | Cast both as VARCHAR(1000); direct 1:1 map |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 98 | Exact name match; both boolean; sample data TRUE/FALSE | Cast both as BOOLEAN; direct 1:1 map |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 98 | Exact name match; both PKs for flight; sample data integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 98 | Name similarity (airline_key ≈ airline_id); both FK to airline; sample data integer | Cast both as INTEGER; FK to airline PK; direct 1:1 map |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 98 | Name similarity (aircraft_key ≈ aircraft_id); both FK to aircraft; sample data integer | Cast both as INTEGER; FK to aircraft PK; direct 1:1 map |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 98 | Name similarity (origin_airport_key ≈ origin_airport_id); both FK to airport; sample data integer | Cast both as INTEGER; FK to airport PK; direct 1:1 map |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 98 | Name similarity (destination_airport_key ≈ destination_airport_id); both FK to airport; sample data integer | Cast both as INTEGER; FK to airport PK; direct 1:1 map |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 98 | Exact name match; both schedule IDs; sample data overlap | Cast both as VARCHAR(50)/NUMBER; direct 1:1 map |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 98 | Exact name match; both integer minutes; sample data overlap | Cast both as INTEGER; direct 1:1 map |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 90 | Name similarity (cancelled_flag ≈ cancellation_flag); both boolean; sample data TRUE/FALSE | Cast both as BOOLEAN; direct 1:1 map |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 90 | Name similarity (diverted_flag ≈ diversion_flag); both boolean; sample data TRUE/FALSE | Cast both as BOOLEAN; direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 90 | Name similarity (subscription_key ≈ suscription_id); both surrogate PKs; sample data integer | Cast both as INTEGER; enforce NOT NULL + UNIQUE; direct 1:1 map |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 98 | Name similarity (customer_key ≈ customer_id); both FK to customer; sample data integer | Cast both as INTEGER; FK to customer PK; direct 1:1 map |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 98 | Name similarity (product_key ≈ data_product_id); both FK to data product; sample data integer | Cast both as INTEGER; FK to data product PK; direct 1:1 map |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 98 | Exact name match; both dates; sample data overlap | Cast both as DATE; direct 1:1 map |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 98 | Exact name match; both dates; sample data overlap | Cast both as DATE; direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 90 | Name similarity (subscription_tier ≈ tier); both strings for tier; sample data overlap | Map subscription_tier to tier; cast VARCHAR(50) |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 90 | Name similarity (subscription_status ≈ status); both strings for status; sample data overlap | Map subscription_status to status; cast VARCHAR(50) |
| Redshift | dim_aircraft | delivery_year | Snowflake | aircraft_master | delivery_date | 62 | Glossary similarity (both aircraft delivery); Redshift is year (SMALLINT), Snowflake is DATE; sample data both 4-digit years | Transform delivery_year (SMALLINT) to DATE YYYY-01-01 |
| Redshift | dim_aircraft | retirement_year | Snowflake | aircraft_master | retirement_date | 62 | Glossary similarity (both aircraft retirement); Redshift is year (SMALLINT), Snowflake is DATE; sample data both 4-digit years | Transform retirement_year (SMALLINT) to DATE YYYY-12-31 |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_airline | alliance | VARCHAR(100) | Oneworld, SkyTeam, Star Alliance, NULL | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Mainline, Low Cost, Cargo | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | effective_start_date | DATE | YYYY-MM-DD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | effective_end_date | DATE | YYYY-MM-DD, NULL | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | region | VARCHAR(100) | North America, Europe, Asia, etc. | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | iata_code | VARCHAR(10) | ATL, PEK, LAX, etc. | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | icao_code | VARCHAR(10) | KATL, ZBAA, KLAX, etc. | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | segment | VARCHAR(100) | Enterprise, Mid-Market, SMB, Government | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_customer | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Snowflake | airline_master | No unmatched columns | — | — | No unmatched columns | — |