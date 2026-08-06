### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 96 | 100% |
| Attributes mapped ≥80% match | 48 | 50% |
| Attributes mapped 40–79% match | 29 | 30.2% |
| Attributes not mapped (no match ≥40) | 19 | 19.8% |
| Total matched pairs identified | 54 | — |
| Total unmatched columns | 19 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 95 | Name similarity (airline_key ≈ airline_id); both are surrogate PKs, integer, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Name and glossary exact match; sample data both show 2–3 char IATA codes | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Name and glossary exact match; sample data both show airline names | Direct 1:1 map; enforce VARCHAR(200) NOT NULL |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Name and glossary exact match; sample data both show country names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Name and glossary exact match; sample data both boolean TRUE/FALSE | Direct 1:1 map; BOOLEAN |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 95 | Name similarity (aircraft_key ≈ aircraft_id); both surrogate PKs, integer, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Name and glossary exact match; sample data both show tail numbers | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Name and glossary exact match; sample data both show aircraft types | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Name and glossary exact match; sample data both show manufacturer names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 92 | Name similarity (operator_airline_key ≈ operator_airline_id); both are FK to airline | Cast NUMBER(38,0) to INTEGER |
| Redshift | dim_aircraft | delivery_year | Snowflake | aircraft_master | delivery_date | 60 | Glossary similarity (both delivery year/date); sample data: Redshift is year, Snowflake is date | Extract year from DATE; map INTEGER to DATE (YYYY-01-01) |
| Redshift | dim_aircraft | retirement_year | Snowflake | aircraft_master | retirement_date | 60 | Glossary similarity (retirement year/date); sample data: Redshift is year, Snowflake is date | Extract year from DATE; map INTEGER to DATE (YYYY-01-01) |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 95 | Name similarity (airport_key ≈ airport_id); both surrogate PKs, integer, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Name and glossary exact match; sample data both show IATA/ICAO codes | Direct 1:1 map; enforce VARCHAR(20) NOT NULL |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Name and glossary exact match; sample data both show airport names | Direct 1:1 map; enforce VARCHAR(200) |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Name and glossary exact match; sample data both show city names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Name and glossary exact match; sample data both show country names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Name and glossary exact match; sample data both decimal | Cast NUMBER(9,6) to DECIMAL(9,6) |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Name and glossary exact match; sample data both decimal | Cast NUMBER(9,6) to DECIMAL(9,6) |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Name and glossary exact match; sample data both show timezones | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 95 | Name similarity (customer_key ≈ customer_id); both surrogate PKs, integer, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Name and glossary exact match; sample data both show customer names | Direct 1:1 map; enforce VARCHAR(200) |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Name and glossary exact match; sample data both show customer types | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Name and glossary exact match; sample data both show country names | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Name and glossary exact match; sample data both boolean | Direct 1:1 map; BOOLEAN |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 95 | Name similarity (product_key ≈ data_product_id); both surrogate PKs, integer, unique | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Name and glossary exact match; sample data both show product names | Direct 1:1 map; enforce VARCHAR(200) |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Name and glossary exact match; sample data both show product domain | Direct 1:1 map; enforce VARCHAR(100) |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Name and glossary exact match; sample data both show delivery type | Direct 1:1 map; enforce VARCHAR(50) |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Name and glossary exact match; sample data both show descriptions | Direct 1:1 map; enforce VARCHAR(1000) |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Name and glossary exact match; sample data both boolean | Direct 1:1 map; BOOLEAN |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 95 | Name similarity; both are PK, integer | Cast NUMBER(38,0) to BIGINT |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 95 | Name similarity; both are FK to airline | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 95 | Name similarity; both are FK to aircraft | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 92 | Name similarity; both are FK to airport | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 92 | Name similarity; both are FK to airport | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 85 | Name similarity; both are schedule references | Cast VARCHAR(50) to NUMBER(38,0); map via reference lookup |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Name and glossary exact match; sample data both integer minutes | Direct 1:1 map; INTEGER |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 100 | Name similarity; both boolean flags for cancellation | Direct 1:1 map; BOOLEAN |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 100 | Name similarity; both boolean flags for diversion | Direct 1:1 map; BOOLEAN |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 85 | Name similarity; both are PK, integer (noting typo in Snowflake) | Cast NUMBER(38,0) to BIGINT |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 95 | Name similarity; both are FK to customer | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 95 | Name similarity; both are FK to data_product | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Name and glossary exact match; both are dates | Direct 1:1 map; DATE |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Name and glossary exact match; both are dates | Direct 1:1 map; DATE |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 88 | Name similarity and sample data (Standard, Premium, Enterprise) | Map values via lookup table |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 88 | Name similarity and sample data (Active, Cancelled, Trial, Paused) | Map values via lookup table |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|------------------|------------|---------------|---------------|----------------------------------|-------------------------------------------------|---------------------------------------------------|
| Redshift | dim_airline | alliance | VARCHAR(100) | Oneworld, SkyTeam, Star Alliance | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Mainline, Low Cost, Cargo | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | effective_start_date | DATE | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking column not required in Snowflake |
| Redshift | dim_aircraft | effective_end_date | DATE | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking column not required in Snowflake |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking column not required in Snowflake |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | region | VARCHAR(100) | North America, Asia, Europe | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | iata_code | VARCHAR(10) | ATL, PEK, LAX | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | icao_code | VARCHAR(10) | KATL, ZBAA, KLAX | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | segment | VARCHAR(100) | Enterprise, Mid-Market, SMB, Non-Profit | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_customer | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |