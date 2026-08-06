### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 99 | 100% |
| Attributes mapped ≥80% match | 34 | 34.3% |
| Attributes mapped 40–79% match | 41 | 41.4% |
| Attributes not mapped (no match ≥40) | 24 | 24.2% |
| Total matched pairs identified | 54 | — |
| Total unmatched columns | 24 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 97 | Name similarity (airline_key ≈ airline_id); both are PKs, glossary both define as surrogate key; sample data both numeric in range 1–100 | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Exact name and glossary match; sample data overlap (e.g., AA, DL, BA) | Direct 1:1 map |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Exact name and glossary match; sample data overlap (e.g., American Airlines) | Direct 1:1 map |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 98 | Exact name and glossary match; sample data overlap (e.g., USA, UK) | Direct 1:1 map |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Exact name and glossary match; sample data both boolean TRUE/FALSE | Direct 1:1 map |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 97 | Name similarity (aircraft_key ≈ aircraft_id); both are PKs, glossary both define as surrogate key; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Exact name and glossary match; sample data overlap (e.g., N798HV) | Direct 1:1 map |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 92 | Name similarity (operator_airline_key ≈ operator_airline_id); both reference airline PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 97 | Name similarity (airport_key ≈ airport_id); both are PKs; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Exact name and glossary match; sample data overlap (e.g., ATL, LHR) | Direct 1:1 map |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Exact name and glossary match; sample data both decimal | Direct 1:1 map |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Exact name and glossary match; sample data both decimal | Direct 1:1 map |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 97 | Name similarity (customer_key ≈ customer_id); both are PKs; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Exact name and glossary match; sample data both boolean | Direct 1:1 map |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 97 | Name similarity (product_key ≈ data_product_id); both are PKs; sample data both numeric | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name and glossary match; sample data overlap | Direct 1:1 map |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Exact name and glossary match; sample data both boolean | Direct 1:1 map |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 97 | Name similarity (flight_key ≈ flight_key); both are PKs; sample data both numeric | Cast NUMBER(38,0) to BIGINT |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 92 | Name similarity (airline_key ≈ airline_id); both reference airline PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 92 | Name similarity (aircraft_key ≈ aircraft_id); both reference aircraft PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 92 | Name similarity (origin_airport_key ≈ origin_airport_id); both reference airport PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 92 | Name similarity (destination_airport_key ≈ destination_airport_id); both reference airport PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Exact name and glossary match; sample data overlap | Cast VARCHAR(50) to NUMBER(38,0) |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Exact name and glossary match; sample data both integer | Direct 1:1 map |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 100 | Name similarity (cancelled_flag ≈ cancellation_flag); sample data both boolean | Direct 1:1 map |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 100 | Name similarity (diverted_flag ≈ diversion_flag); sample data both boolean | Direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 92 | Name similarity (subscription_key ≈ suscription_id); both are PKs; sample data both numeric | Cast NUMBER(38,0) to BIGINT |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 92 | Name similarity (customer_key ≈ customer_id); both reference customer PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 92 | Name similarity (product_key ≈ data_product_id); both reference data product PK; sample data both numeric | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Exact name and glossary match; sample data both date | Reformat date if necessary to match YYYY-MM-DD |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Exact name and glossary match; sample data both date | Reformat date if necessary to match YYYY-MM-DD |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 88 | Name similarity (subscription_tier ≈ tier); both reference subscription tier; sample data both string | Map Standard/Enterprise/Premium to tier values |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 88 | Name similarity (subscription_status ≈ status); both reference subscription status; sample data both string | Map Active/Paused/Cancelled/Expired to status values |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_date | date_key | INTEGER | Numeric, range 20240101–20240529 | No equivalent column found in any other application | Exclude — internal surrogate key for date dimension |
| Redshift | dim_date | date | DATE | Date, format YYYY-MM-DD | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | day | SMALLINT | Integer 1–31 | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | week | SMALLINT | Integer 1–53 | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | month | SMALLINT | Integer 1–12 | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | quarter | SMALLINT | Integer 1–4 | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | year | SMALLINT | Four-digit year | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | fiscal_year | SMALLINT | Four-digit year | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | fiscal_quarter | SMALLINT | Integer 1–4 | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | is_weekend_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | business_day_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_date | holiday_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Exclude — internal date dimension |
| Redshift | dim_airline | alliance | VARCHAR(100) | Free text, e.g., "Oneworld" | Best match score below 40 — best score: 18 | Review with business — possible manual mapping needed |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Free text, e.g., "Mainline" | Best match score below 40 — best score: 24 | Review with business — possible manual mapping needed |
| Redshift | dim_airline | source_system | VARCHAR(100) | Free text, e.g., "brz_airline_master" | Best match score below 40 — best score: 18 | Review with business — possible manual mapping needed |
| Redshift | dim_airline | dw_created_ts | TIMESTAMP | Timestamp | Best match score below 40 — best score: 18 | Exclude — audit column not required for integration |
| Redshift | dim_airline | dw_updated_ts | TIMESTAMP | Timestamp | Best match score below 40 — best score: 18 | Exclude — audit column not required for integration |
| Redshift | dim_aircraft | delivery_year | SMALLINT | Four-digit year | Best match score below 40 — best score: 36 | Review with business — possible mapping to delivery_date |
| Redshift | dim_aircraft | retirement_year | SMALLINT | Four-digit year or NULL | Best match score below 40 — best score: 32 | Review with business — possible mapping to retirement_date |
| Redshift | dim_aircraft | effective_start_date | DATE | Date, format YYYY-MM-DD | No equivalent column found in any other application | Exclude — SCD2 tracking column not present in Snowflake |
| Redshift | dim_aircraft | effective_end_date | DATE | Date, format YYYY-MM-DD or NULL | No equivalent column found in any other application | Exclude — SCD2 tracking column not present in Snowflake |
| Redshift | dim_aircraft | is_current_flag | BOOLEAN | TRUE/FALSE | No equivalent column found in any other application | Exclude — SCD2 tracking column not present in Snowflake |
| Redshift | dim_aircraft | source_system | VARCHAR(100) | Free text | Best match score below 40 — best score: 18 | Exclude — audit column not required for integration |
| Redshift | dim_aircraft | dw_created_ts | TIMESTAMP | Timestamp | Best match score below 40 — best score: 18 | Exclude — audit column not required for integration |
| Redshift | dim_aircraft | dw_updated_ts | TIMESTAMP | Timestamp | Best match score below 40 — best score: 18 | Exclude — audit column not required for integration |