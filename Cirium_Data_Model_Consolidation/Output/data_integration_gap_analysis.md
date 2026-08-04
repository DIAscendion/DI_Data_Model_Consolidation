### Section 1 — Summary

| Metric | Count | % of Total Attributes |
|---------------------------------------|-------|-----------------------|
| Total attributes analyzed | 89 | 100% |
| Attributes mapped ≥80% match | 39 | 43.8% |
| Attributes mapped 40–79% match | 29 | 32.6% |
| Attributes not mapped (no match ≥40) | 21 | 23.6% |
| Total matched pairs identified | 47 | — |
| Total unmatched columns | 21 | — |

### Section 2 — Column Matches

| Application Name 1 | Table Name 1 | Column Name 1 | Application Name 2 | Table Name 2 | Column Name 2 | Match Score | Reason for Matching | Transformation Rule |
|---|---|---|---|---|---|---|---|---|
| Redshift | dim_airline | airline_key | Snowflake | airline_master | airline_id | 95 | Name similarity (airline_key ≈ airline_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airline | airline_code | Snowflake | airline_master | airline_code | 100 | Exact name match; glossary: both "carrier code"; sample data: both show IATA/ICAO codes (AA, DL, etc.) | Direct 1:1 map |
| Redshift | dim_airline | airline_name | Snowflake | airline_master | airline_name | 100 | Exact name match; glossary: "carrier name"; sample data: both show airline names | Direct 1:1 map |
| Redshift | dim_airline | country | Snowflake | airline_master | country | 100 | Exact name match; glossary: "country of registration"; sample data: country names | Direct 1:1 map |
| Redshift | dim_airline | active_flag | Snowflake | airline_master | active_flag | 100 | Exact name match; glossary: "active airline"; sample data: TRUE/FALSE in both | Direct 1:1 map |
| Redshift | dim_aircraft | aircraft_key | Snowflake | aircraft_master | aircraft_id | 94 | Name similarity (aircraft_key ≈ aircraft_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_aircraft | tail_number | Snowflake | aircraft_master | tail_number | 100 | Exact name match; glossary: "unique tail number"; sample data: both show US tail numbers | Direct 1:1 map |
| Redshift | dim_aircraft | aircraft_type | Snowflake | aircraft_master | aircraft_type | 100 | Exact name match; glossary: "aircraft model/type"; sample data: Airbus/Boeing types | Direct 1:1 map |
| Redshift | dim_aircraft | manufacturer | Snowflake | aircraft_master | manufacturer | 100 | Exact name match; glossary: "aircraft manufacturer"; sample data: Airbus/Boeing/etc. | Direct 1:1 map |
| Redshift | dim_aircraft | operator_airline_key | Snowflake | aircraft_master | operator_airline_id | 92 | Name similarity (operator_airline_key ≈ operator_airline_id); both FK to airline; sample data: integer keys | Cast NUMBER(38,0) to INTEGER |
| Redshift | dim_airport | airport_key | Snowflake | airport_master | airport_id | 95 | Name similarity (airport_key ≈ airport_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_airport | airport_code | Snowflake | airport_master | airport_code | 100 | Exact name match; glossary: "airport IATA/ICAO code"; sample data: ATL, LAX, etc. | Direct 1:1 map |
| Redshift | dim_airport | airport_name | Snowflake | airport_master | airport_name | 100 | Exact name match; glossary: "airport name"; sample data: full airport names | Direct 1:1 map |
| Redshift | dim_airport | city | Snowflake | airport_master | city | 100 | Exact name match; glossary: "city"; sample data: city names | Direct 1:1 map |
| Redshift | dim_airport | country | Snowflake | airport_master | country | 100 | Exact name match; glossary: "country"; sample data: country names | Direct 1:1 map |
| Redshift | dim_airport | latitude | Snowflake | airport_master | latitude | 100 | Exact name match; sample data: decimal degrees | Direct 1:1 map |
| Redshift | dim_airport | longitude | Snowflake | airport_master | longitude | 100 | Exact name match; sample data: decimal degrees | Direct 1:1 map |
| Redshift | dim_airport | timezone | Snowflake | airport_master | timezone | 100 | Exact name match; sample data: Olson timezone strings | Direct 1:1 map |
| Redshift | dim_customer | customer_key | Snowflake | customer_master | customer_id | 94 | Name similarity (customer_key ≈ customer_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_customer | customer_name | Snowflake | customer_master | customer_name | 100 | Exact name match; glossary: "customer name"; sample data: company names | Direct 1:1 map |
| Redshift | dim_customer | customer_type | Snowflake | customer_master | customer_type | 100 | Exact name match; sample data: types (OTA, MRO Provider, etc.) | Direct 1:1 map |
| Redshift | dim_customer | country | Snowflake | customer_master | country | 100 | Exact name match; sample data: country names | Direct 1:1 map |
| Redshift | dim_customer | active_flag | Snowflake | customer_master | active_flag | 100 | Exact name match; sample data: TRUE/FALSE | Direct 1:1 map |
| Redshift | dim_data_product | product_key | Snowflake | data_products | data_product_id | 94 | Name similarity (product_key ≈ data_product_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER; enforce NOT NULL + UNIQUE |
| Redshift | dim_data_product | product_name | Snowflake | data_products | product_name | 100 | Exact name match; sample data: product names | Direct 1:1 map |
| Redshift | dim_data_product | domain | Snowflake | data_products | domain | 100 | Exact name match; sample data: domain names | Direct 1:1 map |
| Redshift | dim_data_product | delivery_type | Snowflake | data_products | delivery_type | 100 | Exact name match; sample data: "Streaming", "Dashboard", etc. | Direct 1:1 map |
| Redshift | dim_data_product | description | Snowflake | data_products | description | 100 | Exact name match; sample data: free text descriptions | Direct 1:1 map |
| Redshift | dim_data_product | active_flag | Snowflake | data_products | active_flag | 100 | Exact name match; sample data: TRUE/FALSE | Direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_key | Snowflake | customer_subscriptions | suscription_id | 90 | Name similarity (subscription_key ≈ suscription_id); both PKs; sample data both are integer surrogates | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_product_subscriptions | customer_key | Snowflake | customer_subscriptions | customer_id | 94 | Name similarity (customer_key ≈ customer_id); both FK to customer; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | product_key | Snowflake | customer_subscriptions | data_product_id | 94 | Name similarity (product_key ≈ data_product_id); both FK to product; sample data both are integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_product_subscriptions | start_date | Snowflake | customer_subscriptions | start_date | 100 | Exact name match; sample data: YYYY-MM-DD dates | Direct 1:1 map |
| Redshift | fact_product_subscriptions | end_date | Snowflake | customer_subscriptions | end_date | 100 | Exact name match; sample data: YYYY-MM-DD dates | Direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_tier | Snowflake | customer_subscriptions | tier | 90 | Name similarity (subscription_tier ≈ tier); glossary: both "entitlement tier"; sample data: Standard, Premium, etc. | Rename column; direct 1:1 map |
| Redshift | fact_product_subscriptions | subscription_status | Snowflake | customer_subscriptions | status | 90 | Name similarity (subscription_status ≈ status); glossary: both "subscription status"; sample data: Active, Paused, Cancelled | Rename column; direct 1:1 map |
| Redshift | fact_flight_operations | flight_key | Snowflake | flight_operations | flight_key | 100 | Exact name match; both PKs; sample data: integer surrogates | Cast NUMBER(38,0) to BIGINT; enforce NOT NULL + UNIQUE |
| Redshift | fact_flight_operations | airline_key | Snowflake | flight_operations | airline_id | 94 | Name similarity (airline_key ≈ airline_id); both FK to airline; sample data: integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | aircraft_key | Snowflake | flight_operations | aircraft_id | 94 | Name similarity (aircraft_key ≈ aircraft_id); both FK to aircraft; sample data: integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | origin_airport_key | Snowflake | flight_operations | origin_airport_id | 92 | Name similarity (origin_airport_key ≈ origin_airport_id); both FK to airport; sample data: integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | destination_airport_key | Snowflake | flight_operations | destination_airport_id | 92 | Name similarity (destination_airport_key ≈ destination_airport_id); both FK to airport; sample data: integer surrogates | Cast NUMBER(38,0) to INTEGER |
| Redshift | fact_flight_operations | schedule_id | Snowflake | flight_operations | schedule_id | 100 | Exact name match; sample data: string/integer keys | Cast VARCHAR(50) to NUMBER(38,0) or vice versa, depending on canonical model |
| Redshift | fact_flight_operations | delay_minutes | Snowflake | flight_operations | delay_minutes | 100 | Exact name match; sample data: integer minutes | Direct 1:1 map |
| Redshift | fact_flight_operations | cancelled_flag | Snowflake | flight_operations | cancellation_flag | 98 | Name similarity (cancelled_flag ≈ cancellation_flag); sample data: TRUE/FALSE | Rename column; direct 1:1 map |
| Redshift | fact_flight_operations | diverted_flag | Snowflake | flight_operations | diversion_flag | 98 | Name similarity (diverted_flag ≈ diversion_flag); sample data: TRUE/FALSE | Rename column; direct 1:1 map |

### Section 3 — Unmatched Columns

| Application Name | Table Name | Column Name | Data Type | Sample Data Pattern | Reason Not Matched | Suggested Action |
|---|---|---|---|---|---|---|
| Redshift | dim_airline | alliance | VARCHAR(100) | Oneworld, SkyTeam, Star Alliance | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airline | carrier_type | VARCHAR(50) | Mainline, Low Cost, Cargo | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_aircraft | delivery_year | SMALLINT | 1998–2023 | Best match score below 40 — best score: 30 | Review with business — possible manual mapping needed |
| Redshift | dim_aircraft | retirement_year | SMALLINT | 1998–2027 | Best match score below 40 — best score: 30 | Review with business — possible manual mapping needed |
| Redshift | dim_event_type | event_type_key | INTEGER | 1–105 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_type_name | VARCHAR(200) | "Departure - Scheduled", etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | event_category | VARCHAR(100) | Departure, Arrival, Maintenance, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_event_type | description | VARCHAR(1000) | Free text up to 1000 chars | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | region | VARCHAR(100) | North America, Asia, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | iata_code | VARCHAR(10) | ATL, LAX, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_airport | icao_code | VARCHAR(10) | KATL, KLAX, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_key | INTEGER | 1–110 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | origin_airport_key | INTEGER | 1–100 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | destination_airport_key | INTEGER | 1–100 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_distance_miles | DECIMAL(10,2) | 154.93–11980.46 | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | region | VARCHAR(100) | Europe, Asia, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | route_type | VARCHAR(50) | Short Haul, Long Haul, etc. | No equivalent column found in any other application | Add to canonical model as new attribute |
| Redshift | dim_route | domestic_international | VARCHAR(20) | Domestic, International | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | aircraft_master | delivery_date | DATE | YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | aircraft_master | retirement_date | DATE | YYYY-MM-DD | No equivalent column found in any other application | Add to canonical model as new attribute |
| Snowflake | flight_operations | flight_status | VARCHAR(30) | ON_TIME, DELAYED, EARLY, CANCELLED | No equivalent column found in any other application | Add to canonical model as new attribute |
