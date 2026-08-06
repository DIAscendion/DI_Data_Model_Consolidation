### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 108 | 100% |
| Attributes mapped ≥80% match | 38 | 35.2% |
| Attributes mapped 40–79% match | 41 | 38.0% |
| Attributes not mapped (no match ≥40) | 29 | 26.9% |
| Total matched pairs identified | 54 | — |
| Total unmatched columns | 29 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Exact name match; glossary and sample data both show IATA/ICAO codes (e.g., 'AA', 'DL') | Cast VARCHAR(20) to VARCHAR(20); enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Exact name match; glossary and sample data both show airline names | Cast VARCHAR(200) to VARCHAR(200); enforce NOT NULL |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Exact name match; glossary and sample data both country names | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Exact name match; both define as active status; sample data TRUE/FALSE | Cast BOOLEAN to BOOLEAN; enforce NOT NULL; map TRUE/FALSE as is |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Exact name match; both define as aircraft registration; sample data shows strings like 'N798HV' | Cast VARCHAR(20) to VARCHAR(20); enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 97 | Name similarity (operator_airline_key ≈ operator_airline_id); both link to airline; sample data both integer keys | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | dim_aircraft | delivery_year | Snowflake | aircraft_master | delivery_date | 90 | Glossary similarity (both reference delivery); sample data: Redshift year (SMALLINT), Snowflake date (DATE) | Cast SMALLINT to DATE by mapping year to 1st Jan (YYYY-01-01) |
| Redshift | dim_aircraft | retirement_year | Snowflake | aircraft_master | retirement_date | 90 | Glossary similarity (both reference retirement); sample data: Redshift year (SMALLINT), Snowflake date (DATE) | Cast SMALLINT to DATE by mapping year to 1st Jan (YYYY-01-01) |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Exact name match; both glossary and sample data match (e.g., 'ATL') | Cast VARCHAR(20) to VARCHAR(20); enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(200) to VARCHAR(200) |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Exact name match; both glossary and sample data show decimal latitudes | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Exact name match; both glossary and sample data show decimal longitudes | Cast DECIMAL(9,6) to NUMBER(9,6) |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(200) to VARCHAR(200); enforce NOT NULL |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Exact name match; both glossary and sample data match | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(200) to VARCHAR(200); enforce NOT NULL |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(100) to VARCHAR(100) |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name match; both glossary and sample data match | Cast VARCHAR(1000) to VARCHAR(1000) |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Exact name match; both glossary and sample data match | Cast BOOLEAN to BOOLEAN; enforce NOT NULL |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 95 | Name similarity (airline_key ≈ airline_id); both are integer keys to airline; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 95 | Name similarity (aircraft_key ≈ aircraft_id); both are integer keys to aircraft; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 95 | Name similarity (origin_airport_key ≈ origin_airport_id); both are integer keys to airport; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 95 | Name similarity (destination_airport_key ≈ destination_airport_id); both are integer keys to airport; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Exact name match; both glossary and sample data show string/integer schedule IDs | Cast VARCHAR(50) to NUMBER(38,0); map schedule codes to integer IDs via lookup |
| Redshift | fact_flight_operations | scheduled_departure_ts | Snowflake | airline_schedules | scheduled_departure | 92 | Name similarity (scheduled_departure_ts ≈ scheduled_departure); both sample data in timestamp format | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | scheduled_arrival_ts | Snowflake | airline_schedules | scheduled_arrival | 92 | Name similarity (scheduled_arrival_ts ≈ scheduled_arrival); both sample data in timestamp format | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | actual_departure_ts | Snowflake | flight_operations | actual_departure_ts | 100 | Exact name match; both glossary and sample data match | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | actual_arrival_ts | Snowflake | flight_operations | actual_arrival_ts | 100 | Exact name match; both glossary and sample data match | Cast TIMESTAMP to TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Exact name match; both glossary and sample data match | Cast INTEGER to NUMBER(6,0) |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 98 | Name similarity (cancelled_flag ≈ cancellation_flag); both glossary and sample data TRUE/FALSE | Cast BOOLEAN to BOOLEAN; map field names |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 98 | Name similarity (diverted_flag ≈ diversion_flag); both glossary and sample data TRUE/FALSE | Cast BOOLEAN to BOOLEAN; map field names |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 95 | Name similarity (customer_key ≈ customer_id); both are integer keys to customer; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 95 | Name similarity (product_key ≈ data_product_id); both are integer keys to product; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK constraint |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Exact name match; both glossary and sample data match | Cast DATE to DATE |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Exact name match; both glossary and sample data match | Cast DATE to DATE |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 92 | Name similarity (subscription_tier ≈ tier); both glossary and sample data match (e.g., 'Standard', 'Premium') | Map field name; Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 92 | Name similarity (subscription_status ≈ status); both glossary and sample data match (e.g., 'Active', 'Paused') | Map field name; Cast VARCHAR(50) to VARCHAR(50) |
| Redshift | dim_date | date | Snowflake | flight_operations | flight_date | 90 | Glossary similarity (both refer to flight date); sample data both show dates | Cast DATE to DATE |
| Redshift | dim_date | date_key | Snowflake | flight_operations | flight_date | 85 | Name similarity (date_key ≈ flight_date); sample data both show dates, but Redshift is integer key (YYYYMMDD), Snowflake is date | Convert INTEGER (YYYYMMDD) to DATE using TO_DATE(CHAR(date_key),'YYYYMMDD') |
| Redshift | dim_airport | iata_code | Snowflake | airport_master | airport_code | 85 | Glossary similarity (IATA code ≈ airport_code); sample data both show codes like 'ATL' | Map iata_code to airport_code; Cast VARCHAR(10) to VARCHAR(20) |
| Redshift | dim_airport | icao_code | Snowflake | airport_master | airport_code | 80 | Glossary similarity (ICAO code ≈ airport_code); sample data both show codes like 'KATL' | Map icao_code to airport_code; Cast VARCHAR(10) to VARCHAR(20) |
| Redshift | dim_customer | segment | Snowflake | customer_master | customer_type | 60 | Glossary similarity (segment ≈ customer_type); both describe customer classification; sample data similar | Map segment values to customer_type via lookup |
| Redshift | dim_route | origin_airport_key | Snowflake | airline_schedules | origin_airport_id | 60 | Glossary similarity (origin_airport_key ≈ origin_airport_id); both reference airports; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK |
| Redshift | dim_route | destination_airport_key | Snowflake | airline_schedules | destination_airport_id | 60 | Glossary similarity (destination_airport_key ≈ destination_airport_id); both reference airports; sample data both integer | Cast INTEGER to NUMBER(38,0); enforce FK |
| Redshift | dim_route | region | Snowflake | airline_schedules | aircraft_type | 45 | Weak name similarity (region ≈ aircraft_type); both describe aspects of route/schedule, but different semantics (best score: 45) | Review mapping; possible business review needed |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_airline | alliance | VARCHAR(100) | Alliance names (e.g., 'Oneworld') | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Carrier types (e.g., 'Mainline', 'Low Cost') | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | effective_start_date | DATE | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking not present in Snowflake |
| Redshift | dim_aircraft | effective_end_date | DATE | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking not present in Snowflake |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | No sample data provided | No equivalent column found in any other application | Exclude — SCD2 tracking not present in Snowflake |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | event_type_key | INTEGER | Numeric IDs 1–105 | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | event_type_name | VARCHAR(200) | Event names (e.g., 'Departure - Scheduled') | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | event_category | VARCHAR(100) | Event categories (e.g., 'Departure') | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | description | VARCHAR(1000) | Event descriptions | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_event_type | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — event type reference not present in Snowflake |
| Redshift | dim_airport | region | VARCHAR(100) | Region names (e.g., 'North America') | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | iata_code | VARCHAR(10) | IATA codes (e.g., 'ATL') | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| Redshift | dim_airport | icao_code | VARCHAR(10) | ICAO codes (e.g., 'KATL') | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| Redshift | dim_airport | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | segment | VARCHAR(100) | Segment types (e.g., 'Non-Profit') | Best match score below 40 — best score: 35 | Review with business — possible manual mapping needed |
| Redshift | dim_customer | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | source_system | VARCHAR(100) | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_created_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_updated_ts | TIMESTAMP | No sample data provided | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |