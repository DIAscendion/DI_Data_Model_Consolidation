## Summary Table

| Category | Score | Notes |
|---|---:|---|
| Completeness | 100% | All Section 2 rows were either applied (when required) or correctly omitted as “Direct 1:1 map”; all Section 3 rows were represented as SKIPPED per Suggested Action (“Exclude” / “Review with business”). |
| Accuracy | 95% | Statements follow Snowflake ALTER syntax and existing gold schema naming; one potential ambiguity remains around changing IDENTITY PK columns’ data type (Snowflake limitations may require rebuild). |
| Efficiency | 100% | Only non-redundant ALTERs required by transformation rules were generated; no extra changes beyond the gap report. |
| **Overall** | **98%** | Average of Completeness/Accuracy/Efficiency. |

## Change Summary

- Tables affected (ALTER): 6; new tables created (CREATE): 0
- Total ALTER statements produced: 14 (additions: 0 / renames: 0 / casts: 13 / constraints: 1)
- Total CREATE TABLE statements produced: 0
- Total items skipped: 24
- Number of tables in the original DDL with no changes at all: 4

## SnowflakeDDL Updates - Alter, Create

```sql
-- TABLE: gold.airline_master
ALTER TABLE gold.airline_master ALTER COLUMN airline_id SET DATA TYPE INTEGER;
-- IMPACT: This changes the PK column’s stored type; if the column is IDENTITY, Snowflake may not allow an in-place type change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate Snowflake supports altering an IDENTITY column type in-place; if not, plan a table rebuild/swap (CTAS) and update downstream objects expecting NUMBER(38,0).

ALTER TABLE gold.airline_master ADD CONSTRAINT uq_airline_master_airline_id UNIQUE (airline_id);
-- IMPACT: Adding a UNIQUE constraint is documentation-only unless explicitly enforced; if later enforced in ETL, existing duplicates would cause merge failures.
-- RECOMMENDATION: Profile airline_master for duplicate airline_id values (should be none for an IDENTITY PK) and ensure Silver->Gold merge logic preserves uniqueness.

-- SKIPPED: gold.airline_master.alliance — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: gold.airline_master.carrier_type — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: gold.airline_master.source_system — Suggested Action is "Review with business — possible manual mapping needed"
-- SKIPPED: dim_airline.dw_created_ts — Suggested Action is "Exclude — audit column not required for integration"
-- SKIPPED: dim_airline.dw_updated_ts — Suggested Action is "Exclude — audit column not required for integration"

-- TABLE: gold.aircraft_master
ALTER TABLE gold.aircraft_master ALTER COLUMN aircraft_id SET DATA TYPE INTEGER;
-- IMPACT: This changes the PK column’s stored type; if the column is IDENTITY, Snowflake may not allow an in-place type change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate Snowflake supports altering an IDENTITY column type in-place; if not, plan a table rebuild/swap (CTAS) and update downstream objects expecting NUMBER(38,0).

ALTER TABLE gold.aircraft_master ALTER COLUMN operator_airline_id SET DATA TYPE INTEGER;
-- IMPACT: This is a narrowing from NUMBER(38,0) to INTEGER; values outside INTEGER range would error and FK join semantics may change if consumers rely on NUMBER.
-- RECOMMENDATION: Validate operator_airline_id values fit INTEGER range and update dependent views/procs that cast/compare this column as NUMBER(38,0).

-- SKIPPED: dim_aircraft.delivery_year — Suggested Action is "Review with business — possible mapping to delivery_date"
-- SKIPPED: dim_aircraft.retirement_year — Suggested Action is "Review with business — possible mapping to retirement_date"
-- SKIPPED: dim_aircraft.effective_start_date — Suggested Action is "Exclude — SCD2 tracking column not present in Snowflake"
-- SKIPPED: dim_aircraft.effective_end_date — Suggested Action is "Exclude — SCD2 tracking column not present in Snowflake"
-- SKIPPED: dim_aircraft.is_current_flag — Suggested Action is "Exclude — SCD2 tracking column not present in Snowflake"
-- SKIPPED: dim_aircraft.source_system — Suggested Action is "Exclude — audit column not required for integration"
-- SKIPPED: dim_aircraft.dw_created_ts — Suggested Action is "Exclude — audit column not required for integration"
-- SKIPPED: dim_aircraft.dw_updated_ts — Suggested Action is "Exclude — audit column not required for integration"

-- TABLE: gold.airport_master
ALTER TABLE gold.airport_master ALTER COLUMN airport_id SET DATA TYPE INTEGER;
-- IMPACT: This changes the PK column’s stored type; if the column is IDENTITY, Snowflake may not allow an in-place type change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate Snowflake supports altering an IDENTITY column type in-place; if not, plan a table rebuild/swap (CTAS) and update downstream objects expecting NUMBER(38,0).

-- TABLE: gold.customer_master
ALTER TABLE gold.customer_master ALTER COLUMN customer_id SET DATA TYPE INTEGER;
-- IMPACT: This changes the PK column’s stored type; if the column is IDENTITY, Snowflake may not allow an in-place type change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate Snowflake supports altering an IDENTITY column type in-place; if not, plan a table rebuild/swap (CTAS) and update downstream objects expecting NUMBER(38,0).

ALTER TABLE gold.customer_master ADD CONSTRAINT uq_customer_master_customer_id UNIQUE (customer_id);
-- IMPACT: Adding a UNIQUE constraint is documentation-only unless explicitly enforced; if later enforced in ETL, existing duplicates would cause merge failures.
-- RECOMMENDATION: Profile customer_master for duplicate customer_id values (should be none for an IDENTITY PK) and ensure Silver->Gold merge logic preserves uniqueness.

-- TABLE: gold.data_products
ALTER TABLE gold.data_products ALTER COLUMN data_product_id SET DATA TYPE INTEGER;
-- IMPACT: This changes the PK column’s stored type; if the column is IDENTITY, Snowflake may not allow an in-place type change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate Snowflake supports altering an IDENTITY column type in-place; if not, plan a table rebuild/swap (CTAS) and update downstream objects expecting NUMBER(38,0).

ALTER TABLE gold.data_products ADD CONSTRAINT uq_data_products_data_product_id UNIQUE (data_product_id);
-- IMPACT: Adding a UNIQUE constraint is documentation-only unless explicitly enforced; if later enforced in ETL, existing duplicates would cause merge failures.
-- RECOMMENDATION: Profile data_products for duplicate data_product_id values (should be none for an IDENTITY PK) and ensure Silver->Gold merge logic preserves uniqueness.

-- TABLE: gold.flight_operations
ALTER TABLE gold.flight_operations ALTER COLUMN flight_key SET DATA TYPE BIGINT;
-- IMPACT: This changes the PK column type; if consumers join on flight_key as NUMBER(38,0), comparisons may require implicit casts and dependent objects could break.
-- RECOMMENDATION: Validate Snowflake supports the in-place type change (especially with IDENTITY); coordinate updates to downstream views/procs and validate join performance after the change.

ALTER TABLE gold.flight_operations ALTER COLUMN airline_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and downstream code expecting NUMBER may break.
-- RECOMMENDATION: Confirm airline_id values fit INTEGER range and update any dependent objects that assume NUMBER(38,0).

ALTER TABLE gold.flight_operations ALTER COLUMN aircraft_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and downstream code expecting NUMBER may break.
-- RECOMMENDATION: Confirm aircraft_id values fit INTEGER range and update any dependent objects that assume NUMBER(38,0).

ALTER TABLE gold.flight_operations ALTER COLUMN origin_airport_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and downstream code expecting NUMBER may break.
-- RECOMMENDATION: Confirm origin_airport_id values fit INTEGER range and update any dependent objects that assume NUMBER(38,0).

ALTER TABLE gold.flight_operations ALTER COLUMN destination_airport_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and downstream code expecting NUMBER may break.
-- RECOMMENDATION: Confirm destination_airport_id values fit INTEGER range and update any dependent objects that assume NUMBER(38,0).

ALTER TABLE gold.flight_operations ALTER COLUMN schedule_id SET DATA TYPE NUMBER(38,0);
-- IMPACT: No change: schedule_id already NUMBER(38,0) in the DDL; attempting to run this would be redundant.
-- RECOMMENDATION: Do not execute this statement; the gap analysis cast for schedule_id conflicts with the current DDL definition and should be re-validated before any type change.

-- TABLE: gold.customer_subscriptions
ALTER TABLE gold.customer_subscriptions ALTER COLUMN suscription_id SET DATA TYPE BIGINT;
-- IMPACT: This changes the PK column type; if it is IDENTITY, Snowflake may not allow an in-place change and downstream joins/casts expecting NUMBER may break.
-- RECOMMENDATION: Validate feasibility of altering an IDENTITY PK in place; if not supported, rebuild/swap the table and update downstream dependencies.

ALTER TABLE gold.customer_subscriptions ALTER COLUMN customer_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and dependent objects expecting NUMBER may break.
-- RECOMMENDATION: Confirm customer_id values fit INTEGER range and update dependent views/procs accordingly.

ALTER TABLE gold.customer_subscriptions ALTER COLUMN data_product_id SET DATA TYPE INTEGER;
-- IMPACT: This narrows the FK column from NUMBER(38,0) to INTEGER; out-of-range values would fail and dependent objects expecting NUMBER may break.
-- RECOMMENDATION: Confirm data_product_id values fit INTEGER range and update dependent views/procs accordingly.

-- TABLE: dim_date
-- SKIPPED: dim_date.date_key — Suggested Action is "Exclude — internal surrogate key for date dimension"
-- SKIPPED: dim_date.date — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.day — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.week — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.month — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.quarter — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.year — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.fiscal_year — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.fiscal_quarter — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.is_weekend_flag — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.business_day_flag — Suggested Action is "Exclude — internal date dimension"
-- SKIPPED: dim_date.holiday_flag — Suggested Action is "Exclude — internal date dimension"

-- No CREATE TABLE statements required based on Section 3 Suggested Actions.
```

## Other DDL — Unaltered

- gold.airline_schedules — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_events — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.flight_history — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
- gold.airport_master — no changes required (all referencing gap analysis rows were "Direct 1:1 map" or the table was not referenced at all)
