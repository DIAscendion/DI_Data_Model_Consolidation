### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 109 | 100% |
| Attributes mapped ≥80% match | 39 | 35.8% |
| Attributes mapped 40–79% match | 34 | 31.2% |
| Attributes not mapped (no match ≥40) | 36 | 33.0% |
| Total matched pairs identified | 54 | — |
| Total unmatched columns | 36 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Name and sample data identical; both represent IATA/ICAO airline codes | Enforce VARCHAR(20), uppercase, NOT NULL, UNIQUE |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Name and sample data identical; both represent carrier name | Enforce VARCHAR(200), NOT NULL |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Name, definition, and sample data identical; both boolean TRUE/FALSE | Cast BOOLEAN; NOT NULL; default TRUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Name and sample data identical; both represent aircraft tail numbers | Enforce VARCHAR(20), NOT NULL, UNIQUE |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 97 | Name similarity (operator_airline_key ≈ operator_airline_id); both link to airline; sample data are integer keys | Cast INTEGER/NUMBER; map key to id via reference mapping |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Name, definition, and sample data identical; both use IATA/ICAO codes | Enforce VARCHAR(20), NOT NULL, UNIQUE |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Name, definition, and sample data identical | Enforce VARCHAR(200), allow NULL |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Name, definition, and sample data identical; decimal values | Cast DECIMAL(9,6) ↔ NUMBER(9,6) |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Name, definition, and sample data identical; decimal values | Cast DECIMAL(9,6) ↔ NUMBER(9,6) |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Name, definition, and sample data identical; Olson TZ format | Enforce VARCHAR(50), allow NULL |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Name, definition, and sample data identical | Enforce VARCHAR(200), NOT NULL |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Name, definition, and sample data identical | Enforce VARCHAR(50), allow NULL |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Name, definition, and sample data identical; both boolean TRUE/FALSE | Cast BOOLEAN; NOT NULL; default TRUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Name, definition, and sample data identical | Enforce VARCHAR(200), NOT NULL |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Name, definition, and sample data identical | Enforce VARCHAR(100), allow NULL |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Name, definition, and sample data identical | Enforce VARCHAR(50), allow NULL |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Name, definition, and sample data identical | Enforce VARCHAR(1000), allow NULL |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Name, definition, and sample data identical; both boolean TRUE/FALSE | Cast BOOLEAN; NOT NULL; default TRUE |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 100 | Name, definition, and sample data identical | Cast BIGINT ↔ NUMBER(38,0); PK |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 100 | Name similarity (airline_key ≈ airline_id); both link to airline | Cast INTEGER ↔ NUMBER(38,0); map key to id |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 100 | Name similarity (aircraft_key ≈ aircraft_id); both link to aircraft | Cast INTEGER ↔ NUMBER(38,0); map key to id |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 100 | Name similarity (origin_airport_key ≈ origin_airport_id); both link to airport | Cast INTEGER ↔ NUMBER(38,0); map key to id |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 100 | Name similarity (destination_airport_key ≈ destination_airport_id); both link to airport | Cast INTEGER ↔ NUMBER(38,0); map key to id |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Name, definition, and sample data identical | Cast VARCHAR(50) ↔ NUMBER(38,0); map via reference |
| Redshift | fact_flight_operations | actual_departure_ts | Snowflake | flight_operations | actual_departure_ts | 100 | Name, definition, and sample data identical; both are timestamps | Cast TIMESTAMP ↔ TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | actual_arrival_ts | Snowflake | flight_operations | actual_arrival_ts | 100 | Name, definition, and sample data identical; both are timestamps | Cast TIMESTAMP ↔ TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Name, definition, and sample data identical; integer minutes | Cast INTEGER ↔ NUMBER(6,0) |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 100 | Name similarity (cancelled_flag ≈ cancellation_flag); both boolean | Cast BOOLEAN; NOT NULL; default FALSE |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 100 | Name similarity (diverted_flag ≈ diversion_flag); both boolean | Cast BOOLEAN; NOT NULL; default FALSE |
| Redshift | fact_flight_operations | route_key | Snowflake | flight_history | route_key | 85 | Name similarity (route_key); both represent route identifier; sample data integer | Cast INTEGER ↔ NUMBER(38,0); not enforced FK |
| Redshift | fact_flight_operations | flight_distance_miles | Snowflake | airline_schedules | scheduled_departure | 44 | Weak match: both relate to schedule/flight, but not direct; sample data both numeric but different context (best score: 44) | Review mapping logic with business |
| Redshift | fact_flight_operations | block_hours | Snowflake | airline_schedules | scheduled_arrival | 42 | Weak match: both relate to scheduled flight duration, different representation (best score: 42) | Calculate duration from timestamps |
| Redshift | fact_flight_operations | scheduled_departure_ts | Snowflake | airline_schedules | scheduled_departure | 98 | Name, definition, and sample data highly similar; both represent scheduled departure timestamp | Cast TIMESTAMP ↔ TIMESTAMP_NTZ |
| Redshift | fact_flight_operations | scheduled_arrival_ts | Snowflake | airline_schedules | scheduled_arrival | 98 | Name, definition, and sample data highly similar; both represent scheduled arrival timestamp | Cast TIMESTAMP ↔ TIMESTAMP_NTZ |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 96 | Name similarity (customer_key ≈ customer_id); both represent customer PK | Cast INTEGER ↔ NUMBER(38,0); PK |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 96 | Name similarity (product_key ≈ data_product_id); both represent product PK | Cast INTEGER ↔ NUMBER(38,0); PK |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 94 | Name similarity (subscription_key ≈ suscription_id); both represent PK | Cast BIGINT ↔ NUMBER(38,0); PK |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 100 | Name, definition, and sample data identical; both represent customer FK | Cast INTEGER ↔ NUMBER(38,0); FK |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 100 | Name, definition, and sample data identical; both represent product FK | Cast INTEGER ↔ NUMBER(38,0); FK |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Name, definition, and sample data identical | Cast DATE ↔ DATE |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Name, definition, and sample data identical | Cast DATE ↔ DATE |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 97 | Name similarity (subscription_tier ≈ tier); both represent subscription level; sample data similar | Map values via lookup; enforce VARCHAR(50) |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 97 | Name similarity (subscription_status ≈ status); both represent subscription state; sample data similar | Map values via lookup; enforce VARCHAR(50) |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|------------------|------------|---------------|---------------|----------------------------------|-------------------------------------------------|---------------------------------------------------|
| Redshift | dim_date | date_key | INTEGER | Numeric YYYYMMDD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | date | DATE | Date YYYY-MM-DD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | day | SMALLINT | 1–31 | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | week | SMALLINT | 1–53 | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | month | SMALLINT | 1–12 | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | quarter | SMALLINT | 1–4 | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | year | SMALLINT | 4-digit year | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | fiscal_year | SMALLINT | 4-digit year | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | fiscal_quarter | SMALLINT | 1–4 | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | is_weekend_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | business_day_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_date | holiday_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | airline_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | alliance | VARCHAR(100) | Alliance names (Oneworld, SkyTeam, etc.) | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Mainline, Low Cost, Cargo, etc. | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | aircraft_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | delivery_year | SMALLINT | 4-digit year | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | retirement_year | SMALLINT | 4-digit year | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | effective_start_date | DATE | Date YYYY-MM-DD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | effective_end_date | DATE | Date YYYY-MM-DD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | event_type_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — reference/event_type not present in Snowflake model |
| Redshift | dim_event_type | event_type_name | VARCHAR(200) | Event type names | No equivalent column found in any other application | Exclude — reference/event_type not present in Snowflake model |
| Redshift | dim_event_type | event_category | VARCHAR(100) | Event category names | No equivalent column found in any other application | Exclude — reference/event_type not present in Snowflake model |
| Redshift | dim_event_type | description | VARCHAR(1000) | Free text | No equivalent column found in any other application | Exclude — reference/event_type not present in Snowflake model |
| Redshift | dim_event_type | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_event_type | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | airport_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | region | VARCHAR(100) | Region names | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | iata_code | VARCHAR(10) | IATA code | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | icao_code | VARCHAR(10) | ICAO code | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_airport | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_airport | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | customer_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | segment | VARCHAR(100) | Free text | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | dim_customer | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_customer | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | product_key | INTEGER | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | dim_data_product | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | date_key | INTEGER | Numeric YYYYMMDD | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | route_key | INTEGER | Surrogate key | Best match score below 40 — best score: 38 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | taxi_out_minutes | INTEGER | Integer minutes | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | taxi_in_minutes | INTEGER | Integer minutes | No equivalent column found in any other application | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | flight_distance_miles | DECIMAL(10,2) | Numeric miles | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | block_hours | DECIMAL(6,2) | Numeric hours | Best match score below 40 — best score: 32 | Review with business — possible manual mapping needed |
| Redshift | fact_flight_operations | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_flight_operations | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | subscription_key | BIGINT | Surrogate key | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | source_system | VARCHAR(100) | Free text system names | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | dw_created_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |
| Redshift | fact_product_subscriptions | dw_updated_ts | TIMESTAMP | Timestamps | No equivalent column found in any other application | Exclude — internal/audit column not required for integration |