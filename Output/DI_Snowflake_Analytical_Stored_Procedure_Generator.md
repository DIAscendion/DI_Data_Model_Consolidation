# Snowflake Analytical Stored Procedure Generator

## Section 1 — Migration Summary

| Metric | Detail |
|---|---|
| Total analytical model tables | 12 |
| Total stored procedures generated | 12 |
| Tables with validation issues | 0 |
| PII/PHI-handling procedures | 0 |

## Section 2 — Snowflake Stored Procedures

> Assumptions:
> - Canonical tables share the same names as the star schema tables (e.g., canonical `DIM_ORGANIZATION` feeds analytical `DIM_ORGANIZATION`).
> - Surrogate keys (`*_Key` columns) are generated in the analytical tables via Snowflake sequences or IDENTITY; canonical sources contain business/natural keys and numeric foreign keys.
> - Audit logging table exists as `ANALYTICAL_MIGRATION_AUDIT` with the following minimal structure:
>   - PROC_NAME VARCHAR,
>   - TARGET_TABLE VARCHAR,
>   - START_TIME TIMESTAMP_TZ,
>   - END_TIME TIMESTAMP_TZ,
>   - STATUS VARCHAR,
>   - ERROR_MESSAGE VARCHAR,
>   - ROWS_INSERTED NUMBER,
>   - ROWS_UPDATED NUMBER,
>   - ROWS_REJECTED NUMBER,
>   - ATTEMPT_NUMBER NUMBER
> - No PII/PHI columns are present per the mapper (PII column count = 0), so no masking logic is required beyond standard RBAC.
>
> Replace schema names (`CANONICAL`, `ANALYTICAL`) and sequence names as needed for your environment.

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_ORGANIZATION
-- Target table: DIM_ORGANIZATION (ANALYTICAL schema)
-- Source canonical entity: DIM_ORGANIZATION (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_ORGANIZATION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            -- Example strategy: truncate and reload Type 2 dimension from canonical snapshot
            -- Adjust to MERGE-based SCD management if required.
            TRUNCATE TABLE ANALYTICAL.DIM_ORGANIZATION;

            INSERT INTO ANALYTICAL.DIM_ORGANIZATION (
                ORGANIZATIONKEY,
                ORGANIZATIONID,
                ORGANIZATIONNAME,
                ORGANIZATIONTYPE,
                PARENTORGANIZATIONKEY,
                COUNTRYCODE,
                REGULATORYREGION,
                ISACTIVE,
                EFFECTIVESTARTDATE,
                EFFECTIVEENDDATE,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                -- Surrogate key: assume IDENTITY already defined on target; use DEFAULT
                DEFAULT,
                ORGANIZATION_ID,
                ORGANIZATION_NAME,
                ORGANIZATION_TYPE,
                CAST(PARENT_ORGANIZATION_KEY AS INTEGER),
                COUNTRY_CODE,
                REGULATORY_REGION,
                IS_ACTIVE,
                EFFECTIVE_START_DATE,
                EFFECTIVE_END_DATE,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_ORGANIZATION
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_ORGANIZATION', 'DIM_ORGANIZATION',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_ORGANIZATION completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;

                ROLLBACK;

                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_ORGANIZATION', 'DIM_ORGANIZATION',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                -- Simple backoff
                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_ORGANIZATION - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_FACILITY
-- Target table: DIM_FACILITY (ANALYTICAL schema)
-- Source canonical entity: DIM_FACILITY (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_FACILITY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_FACILITY;

            INSERT INTO ANALYTICAL.DIM_FACILITY (
                FACILITYKEY,
                FACILITYID,
                FACILITYNAME,
                FACILITYSHORTNAME,
                ORGANIZATIONKEY,
                SITECODE,
                FACILITYTYPE,
                ADDRESSLINE1,
                ADDRESSLINE2,
                CITY,
                STATEREGION,
                POSTALCODE,
                COUNTRYCODE,
                TIMEZONENAME,
                UTCOFFSETHOURS,
                GMPCERTIFIED,
                GMPCERTIFICATIONDATE,
                GMPEXPIRYDATE,
                REGULATORYAGENCY,
                FDAESTABLISHMENTID,
                EMASITECODE,
                MANUFACTURINGCAPACITY,
                SOURCESITECODEMARTA,
                SOURCEPLANTCODEOPS,
                SOURCEFACCODEMARTB,
                EFFECTIVESTARTDATE,
                EFFECTIVEENDDATE,
                CURRENTFLAG,
                SCDVERSION,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                FACILITY_ID,
                FACILITY_NAME,
                FACILITY_SHORT_NAME,
                CAST(ORGANIZATION_KEY AS INTEGER),
                SITE_CODE,
                FACILITY_TYPE,
                ADDRESS_LINE_1,
                ADDRESS_LINE_2,
                CITY,
                STATE_REGION,
                POSTAL_CODE,
                COUNTRY_CODE,
                TIMEZONE_NAME,
                UTC_OFFSET_HOURS,
                GMP_CERTIFIED,
                GMP_CERTIFICATION_DATE,
                GMP_EXPIRY_DATE,
                REGULATORY_AGENCY,
                FDA_ESTABLISHMENT_ID,
                EMA_SITE_CODE,
                MANUFACTURING_CAPACITY,
                SOURCE_SITE_CODE_MART_A,
                SOURCE_PLANT_CODE_OPS,
                SOURCE_FAC_CODE_MART_B,
                EFFECTIVE_START_DATE,
                EFFECTIVE_END_DATE,
                CURRENT_FLAG,
                SCD_VERSION,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_FACILITY
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_FACILITY', 'DIM_FACILITY',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_FACILITY completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_FACILITY', 'DIM_FACILITY',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_FACILITY - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PRODUCT
-- Target table: DIM_PRODUCT (ANALYTICAL schema)
-- Source canonical entity: DIM_PRODUCT (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PRODUCT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PRODUCT;

            INSERT INTO ANALYTICAL.DIM_PRODUCT (
                PRODUCTKEY,
                PRODUCTID,
                SKU,
                PRODUCTNAME,
                PRODUCTSHORTNAME,
                ORGANIZATIONKEY,
                FORMULATIONID,
                FORMULATIONVERSION,
                DOSAGEFORM,
                DOSAGESTRENGTH,
                ROUTEOFADMINISTRATION,
                THERAPEUTICCLASS,
                THERAPEUTICAREA,
                PRODUCTCATEGORY,
                ISBIOSIMILAR,
                REFERENCEPRODUCTID,
                INNNAME,
                IDMPMPID,
                NDABLANUMBER,
                EMAPRODUCTNUMBER,
                STANDARDYIELDPCT,
                YIELDLOWERALERTPCT,
                YIELDLOWERACTIONPCT,
                SHELFLIFEMONTHS,
                STORAGECONDITION,
                EFFECTIVESTARTDATE,
                EFFECTIVEENDDATE,
                CURRENTFLAG,
                SCDVERSION,
                SOURCEPRODUCTCODEMARTA,
                SOURCEPRODUCTCODEOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                PRODUCT_ID,
                SKU,
                PRODUCT_NAME,
                PRODUCT_SHORT_NAME,
                CAST(ORGANIZATION_KEY AS INTEGER),
                FORMULATION_ID,
                FORMULATION_VERSION,
                DOSAGE_FORM,
                DOSAGE_STRENGTH,
                ROUTE_OF_ADMINISTRATION,
                THERAPEUTIC_CLASS,
                THERAPEUTIC_AREA,
                PRODUCT_CATEGORY,
                IS_BIOSIMILAR,
                REFERENCE_PRODUCT_ID,
                INN_NAME,
                IDMP_MPID,
                NDA_BLA_NUMBER,
                EMA_PRODUCT_NUMBER,
                STANDARD_YIELD_PCT,
                YIELD_LOWER_ALERT_PCT,
                YIELD_LOWER_ACTION_PCT,
                SHELF_LIFE_MONTHS,
                STORAGE_CONDITION,
                EFFECTIVE_START_DATE,
                EFFECTIVE_END_DATE,
                CURRENT_FLAG,
                SCD_VERSION,
                SOURCE_PRODUCT_CODE_MART_A,
                SOURCE_PRODUCT_CODE_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_PRODUCT
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_PRODUCT', 'DIM_PRODUCT',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_PRODUCT completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_PRODUCT', 'DIM_PRODUCT',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_PRODUCT - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_MATERIAL_LOT
-- Target table: DIM_MATERIAL_LOT (ANALYTICAL schema)
-- Source canonical entity: DIM_MATERIAL_LOT (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_MATERIAL_LOT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_MATERIAL_LOT;

            INSERT INTO ANALYTICAL.DIM_MATERIAL_LOT (
                MATERIALLOTKEY,
                LOTNUMBER,
                PRODUCTKEY,
                FACILITYKEY,
                LOTTYPE,
                MANUFACTUREDATE,
                EXPIRYDATE,
                RETESTDATE,
                QUANTITYPRODUCED,
                QUANTITYUNIT,
                LOTSTATUS,
                CERTIFICATEOFANALYSIS,
                VENDORLOTNUMBER,
                VENDORID,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                LOT_NUMBER,
                CAST(PRODUCT_KEY AS INTEGER),
                CAST(FACILITY_KEY AS INTEGER),
                LOT_TYPE,
                MANUFACTURE_DATE,
                EXPIRY_DATE,
                RETEST_DATE,
                QUANTITY_PRODUCED,
                QUANTITY_UNIT,
                LOT_STATUS,
                CERTIFICATE_OF_ANALYSIS,
                VENDOR_LOT_NUMBER,
                VENDOR_ID,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_MATERIAL_LOT
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_MATERIAL_LOT', 'DIM_MATERIAL_LOT',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_MATERIAL_LOT completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_MATERIAL_LOT', 'DIM_MATERIAL_LOT',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_MATERIAL_LOT - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_EQUIPMENT
-- Target table: DIM_EQUIPMENT (ANALYTICAL schema)
-- Source canonical entity: DIM_EQUIPMENT (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_EQUIPMENT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_EQUIPMENT;

            INSERT INTO ANALYTICAL.DIM_EQUIPMENT (
                EQUIPMENTKEY,
                CANONICALEQUIPMENTID,
                EQUIPMENTNAME,
                FACILITYKEY,
                FUNCTIONALAREA,
                PRODUCTIONUNIT,
                EQUIPMENTMODULE,
                ASSETCLASS,
                ASSETSUBCLASS,
                CRITICALITYRATING,
                MANUFACTURERNAME,
                MODELNUMBER,
                SERIALNUMBER,
                WORKINGVOLUMEL,
                INSTALLATIONDATE,
                COMMISSIONINGDATE,
                QUALIFICATIONSTATUS,
                LASTQUALIFICATIONDATE,
                NEXTQUALIFICATIONDATE,
                CALIBRATIONFREQUENCY,
                LASTCALIBRATIONDATE,
                CALIBRATIONDUEDATE,
                CALIBRATIONSTATUS,
                PLANNEDRUNTIMEMINSPERDAY,
                IDEALCYCLETIMESECS,
                EQUIPMENTSTATUS,
                STATUSEFFECTIVEDATE,
                DECOMMISSIONDATE,
                SOURCEEQUIPIDMARTA,
                SOURCEASSETCODEOPS,
                SOURCEEQUIPCODEMARTB,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CANONICAL_EQUIPMENT_ID,
                EQUIPMENT_NAME,
                CAST(FACILITY_KEY AS INTEGER),
                FUNCTIONAL_AREA,
                PRODUCTION_UNIT,
                EQUIPMENT_MODULE,
                ASSET_CLASS,
                ASSET_SUBCLASS,
                CRITICALITY_RATING,
                MANUFACTURER_NAME,
                MODEL_NUMBER,
                SERIAL_NUMBER,
                WORKING_VOLUME_L,
                INSTALLATION_DATE,
                COMMISSIONING_DATE,
                QUALIFICATION_STATUS,
                LAST_QUALIFICATION_DATE,
                NEXT_QUALIFICATION_DATE,
                CALIBRATION_FREQUENCY,
                LAST_CALIBRATION_DATE,
                CALIBRATION_DUE_DATE,
                CALIBRATION_STATUS,
                PLANNED_RUNTIME_MINS_PER_DAY,
                IDEAL_CYCLE_TIME_SECS,
                EQUIPMENT_STATUS,
                STATUS_EFFECTIVE_DATE,
                DECOMMISSION_DATE,
                SOURCE_EQUIP_ID_MART_A,
                SOURCE_ASSET_CODE_OPS,
                SOURCE_EQUIP_CODE_MART_B,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_EQUIPMENT
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_EQUIPMENT', 'DIM_EQUIPMENT',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_EQUIPMENT completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_EQUIPMENT', 'DIM_EQUIPMENT',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_EQUIPMENT - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PROCESS_STEP
-- Target table: DIM_PROCESS_STEP (ANALYTICAL schema)
-- Source canonical entity: DIM_PROCESS_STEP (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PROCESS_STEP()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PROCESS_STEP;

            INSERT INTO ANALYTICAL.DIM_PROCESS_STEP (
                PROCESSSTEPKEY,
                STEPCODE,
                STEPNAME,
                STEPCATEGORY,
                STEPSUBCATEGORY,
                TYPICALSEQUENCEORDER,
                EXPECTEDDURATIONMINHRS,
                EXPECTEDDURATIONMAXHRS,
                APPLICABLEASSETCLASSES,
                ISCCP,
                ISACTIVE,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                STEP_CODE,
                STEP_NAME,
                STEP_CATEGORY,
                STEP_SUBCATEGORY,
                TYPICAL_SEQUENCE_ORDER,
                EXPECTED_DURATION_MIN_HRS,
                EXPECTED_DURATION_MAX_HRS,
                APPLICABLE_ASSET_CLASSES,
                IS_CCP,
                IS_ACTIVE,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_PROCESS_STEP
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_PROCESS_STEP', 'DIM_PROCESS_STEP',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_PROCESS_STEP completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_PROCESS_STEP', 'DIM_PROCESS_STEP',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_PROCESS_STEP - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PROCESS_PARAMETER
-- Target table: DIM_PROCESS_PARAMETER (ANALYTICAL schema)
-- Source canonical entity: DIM_PROCESS_PARAMETER (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PROCESS_PARAMETER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PROCESS_PARAMETER;

            INSERT INTO ANALYTICAL.DIM_PROCESS_PARAMETER (
                PARAMETERKEY,
                PARAMETERCODE,
                PARAMETERNAME,
                PARAMETERCATEGORY,
                CANONICALUOM,
                SOURCEUOMMARTA,
                SOURCEUOMOPS,
                SOURCEUOMMARTB,
                CONVERSIONFORMULAOPS,
                ISCPP,
                ISKPA,
                TYPICALTARGET,
                TYPICALLSL,
                TYPICALUSL,
                MEASUREMENTFREQUENCY,
                INSTRUMENTTYPE,
                ISACTIVE,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                PARAMETER_CODE,
                PARAMETER_NAME,
                PARAMETER_CATEGORY,
                CANONICAL_UOM,
                SOURCE_UOM_MART_A,
                SOURCE_UOM_OPS,
                SOURCE_UOM_MART_B,
                CONVERSION_FORMULA_OPS,
                IS_CPP,
                IS_KPA,
                TYPICAL_TARGET,
                TYPICAL_LSL,
                TYPICAL_USL,
                MEASUREMENT_FREQUENCY,
                INSTRUMENT_TYPE,
                IS_ACTIVE,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_PROCESS_PARAMETER
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_PROCESS_PARAMETER', 'DIM_PROCESS_PARAMETER',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_PROCESS_PARAMETER completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_PROCESS_PARAMETER', 'DIM_PROCESS_PARAMETER',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_PROCESS_PARAMETER - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_QUALITY_DISPOSITION
-- Target table: DIM_QUALITY_DISPOSITION (ANALYTICAL schema)
-- Source canonical entity: DIM_QUALITY_DISPOSITION (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_QUALITY_DISPOSITION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_QUALITY_DISPOSITION;

            INSERT INTO ANALYTICAL.DIM_QUALITY_DISPOSITION (
                DISPOSITIONKEY,
                DISPOSITIONCODE,
                DISPOSITIONNAME,
                REQUIRESINVESTIGATION,
                COMMERCIALLYRELEASABLE,
                DEVIATIONIMPLIED,
                PATIENTRISKLEVEL,
                REGULATORYNOTIFICATIONREQUIRED,
                DISPOSITIONDESCRIPTION,
                ISACTIVE,
                SOURCECODEMARTA,
                SOURCECODEMARTB,
                SOURCECODEOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                DISPOSITION_CODE,
                DISPOSITION_NAME,
                REQUIRES_INVESTIGATION,
                COMMERCIALLY_RELEASABLE,
                DEVIATION_IMPLIED,
                PATIENT_RISK_LEVEL,
                REGULATORY_NOTIFICATION_REQUIRED,
                DISPOSITION_DESCRIPTION,
                IS_ACTIVE,
                SOURCE_CODE_MART_A,
                SOURCE_CODE_MART_B,
                SOURCE_CODE_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_QUALITY_DISPOSITION
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_QUALITY_DISPOSITION', 'DIM_QUALITY_DISPOSITION',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_QUALITY_DISPOSITION completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_QUALITY_DISPOSITION', 'DIM_QUALITY_DISPOSITION',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_QUALITY_DISPOSITION - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_DEVIATION_CATEGORY
-- Target table: DIM_DEVIATION_CATEGORY (ANALYTICAL schema)
-- Source canonical entity: DIM_DEVIATION_CATEGORY (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_DEVIATION_CATEGORY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_DEVIATION_CATEGORY;

            INSERT INTO ANALYTICAL.DIM_DEVIATION_CATEGORY (
                DEVIATIONCATEGORYKEY,
                CATEGORYCODE,
                CATEGORYNAME,
                CATEGORYGROUP,
                DESCRIPTION,
                CAPATYPICALLYREQUIRED,
                ISACTIVE,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CATEGORY_CODE,
                CATEGORY_NAME,
                CATEGORY_GROUP,
                DESCRIPTION,
                CAPA_TYPICALLY_REQUIRED,
                IS_ACTIVE,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_DEVIATION_CATEGORY
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_DEVIATION_CATEGORY', 'DIM_DEVIATION_CATEGORY',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_DEVIATION_CATEGORY completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_DEVIATION_CATEGORY', 'DIM_DEVIATION_CATEGORY',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_DEVIATION_CATEGORY - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_OPERATOR
-- Target table: DIM_OPERATOR (ANALYTICAL schema)
-- Source canonical entity: DIM_OPERATOR (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_OPERATOR()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_OPERATOR;

            INSERT INTO ANALYTICAL.DIM_OPERATOR (
                OPERATORKEY,
                OPERATORID,
                FULLNAME,
                ROLECODE,
                FACILITYKEY,
                DEPARTMENT,
                ISGMPTRAINED,
                TRAININGEXPIRYDATE,
                ESIGNATUREENABLED,
                EMPLOYMENTSTATUS,
                SOURCESYSTEM,
                SOURCEKEY,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                OPERATOR_ID,
                FULL_NAME,
                ROLE_CODE,
                CAST(FACILITY_KEY AS INTEGER),
                DEPARTMENT,
                IS_GMP_TRAINED,
                TRAINING_EXPIRY_DATE,
                ESIGNATURE_ENABLED,
                EMPLOYMENT_STATUS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.DIM_OPERATOR
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_OPERATOR', 'DIM_OPERATOR',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_OPERATOR completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_OPERATOR', 'DIM_OPERATOR',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_OPERATOR - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_DATE
-- Target table: DIM_DATE (ANALYTICAL schema)
-- Source canonical entities: FACT_YIELD_ANALYTICS, FACT_SHIFT_LOG, FACT_PRODUCTION_ORDER (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_DATE()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_DATE;

            -- Build distinct calendar dates from multiple canonical sources
            INSERT INTO ANALYTICAL.DIM_DATE (
                DATEKEY,
                FULLDATE,
                DAY,
                MONTH,
                MONTHNAME,
                QUARTER,
                YEAR,
                WEEKNUMBER,
                DAYOFWEEK,
                DAYNAME,
                ISWEEKEND,
                ISHOLIDAY,
                FISCALYEAR,
                FISCALQUARTER
            )
            WITH ALL_DATES AS (
                SELECT DISTINCT ANALYSIS_DATE AS FULL_DATE
                FROM CANONICAL.FACT_YIELD_ANALYTICS
                WHERE ANALYSIS_DATE IS NOT NULL
                UNION
                SELECT DISTINCT LOG_DATE AS FULL_DATE
                FROM CANONICAL.FACT_SHIFT_LOG
                WHERE LOG_DATE IS NOT NULL
                UNION
                SELECT DISTINCT CAST(PLANNED_START_UTC AS DATE) AS FULL_DATE
                FROM CANONICAL.FACT_PRODUCTION_ORDER
                WHERE PLANNED_START_UTC IS NOT NULL
            ),
            BASE_DATES AS (
                SELECT DISTINCT FULL_DATE
                FROM ALL_DATES
            )
            SELECT
                CAST(TO_CHAR(FULL_DATE, 'YYYYMMDD') AS INTEGER) AS DATEKEY,
                FULL_DATE AS FULLDATE,
                EXTRACT(DAY FROM FULL_DATE) AS DAY,
                EXTRACT(MONTH FROM FULL_DATE) AS MONTH,
                TO_CHAR(FULL_DATE, 'Mon') AS MONTHNAME,
                EXTRACT(QUARTER FROM FULL_DATE) AS QUARTER,
                EXTRACT(YEAR FROM FULL_DATE) AS YEAR,
                TO_NUMBER(TO_CHAR(FULL_DATE, 'IW')) AS WEEKNUMBER,
                EXTRACT(DOW FROM FULL_DATE) AS DAYOFWEEK,
                TO_CHAR(FULL_DATE, 'Dy') AS DAYNAME,
                CASE WHEN EXTRACT(DOW FROM FULL_DATE) IN (6, 7) THEN TRUE ELSE FALSE END AS ISWEEKEND,
                -- Holiday flag derived from external reference table HOLIDAY_CALENDAR
                CASE WHEN EXISTS (
                    SELECT 1
                    FROM REFERENCE.HOLIDAY_CALENDAR H
                    WHERE H.HOLIDAY_DATE = FULL_DATE
                ) THEN TRUE ELSE FALSE END AS ISHOLIDAY,
                -- Fiscal attributes; replace logic with enterprise fiscal calendar rules
                EXTRACT(YEAR FROM FULL_DATE) AS FISCALYEAR,
                EXTRACT(QUARTER FROM FULL_DATE) AS FISCALQUARTER
            FROM BASE_DATES;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_DIM_DATE', 'DIM_DATE',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_DIM_DATE completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_DIM_DATE', 'DIM_DATE',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_DIM_DATE - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_PRODUCTION_ORDER
-- Target table: FACT_PRODUCTION_ORDER (ANALYTICAL schema)
-- Source canonical entity: FACT_PRODUCTION_ORDER (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_PRODUCTION_ORDER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_PRODUCTION_ORDER;

            INSERT INTO ANALYTICAL.FACT_PRODUCTION_ORDER (
                PRODUCTIONORDERKEY,
                CANONICALBATCHID,
                ERPORDERNUMBER,
                MESBATCHREFERENCE,
                GMPLOTNUMBER,
                FACILITYKEY,
                PRODUCTKEY,
                PRIMARYEQUIPMENTKEY,
                DISPOSITIONKEY,
                PLANNEDSTARTUTC,
                PLANNEDENDUTC,
                PLANNEDQUANTITY,
                QUANTITYUOM,
                ACTUALSTARTUTC,
                ACTUALENDUTC,
                ACTUALQUANTITY,
                YIELDPCT,
                YIELDVARIANCEPCT,
                OEEAVAILABILITYPCT,
                OEEPERFORMANCEPCT,
                OEEQUALITYPCT,
                OEEOVERALLPCT,
                BATCHSTATUS,
                DEVIATIONCOUNT,
                ISGOLDENBATCH,
                GOLDENBATCHREFERENCE,
                SHIFTATSTART,
                SHIFTSUPERVISORKEY,
                SOURCEBATCHIDMARTA,
                SOURCEBATCHIDOPS,
                SOURCEORDERNUMOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CANONICAL_BATCH_ID,
                ERP_ORDER_NUMBER,
                MES_BATCH_REFERENCE,
                GMP_LOT_NUMBER,
                CAST(FACILITY_KEY AS INTEGER),
                CAST(PRODUCT_KEY AS INTEGER),
                CAST(PRIMARY_EQUIPMENT_KEY AS INTEGER),
                CAST(DISPOSITION_KEY AS INTEGER),
                PLANNED_START_UTC,
                PLANNED_END_UTC,
                PLANNED_QUANTITY,
                QUANTITY_UOM,
                ACTUAL_START_UTC,
                ACTUAL_END_UTC,
                ACTUAL_QUANTITY,
                YIELD_PCT,
                YIELD_VARIANCE_PCT,
                OEE_AVAILABILITY_PCT,
                OEE_PERFORMANCE_PCT,
                OEE_QUALITY_PCT,
                OEE_OVERALL_PCT,
                BATCH_STATUS,
                DEVIATION_COUNT,
                IS_GOLDEN_BATCH,
                GOLDEN_BATCH_REFERENCE,
                SHIFT_AT_START,
                CAST(SHIFT_SUPERVISOR_KEY AS INTEGER),
                SOURCE_BATCH_ID_MART_A,
                SOURCE_BATCH_ID_OPS,
                SOURCE_ORDER_NUM_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_PRODUCTION_ORDER
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_PRODUCTION_ORDER', 'FACT_PRODUCTION_ORDER',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_PRODUCTION_ORDER completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_PRODUCTION_ORDER', 'FACT_PRODUCTION_ORDER',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_PRODUCTION_ORDER - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_BATCH_STEP
-- Target table: FACT_BATCH_STEP (ANALYTICAL schema)
-- Source canonical entity: FACT_BATCH_STEP (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_BATCH_STEP()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_BATCH_STEP;

            INSERT INTO ANALYTICAL.FACT_BATCH_STEP (
                BATCHSTEPKEY,
                PRODUCTIONORDERKEY,
                CANONICALBATCHID,
                PROCESSSTEPKEY,
                EQUIPMENTKEY,
                STEPSEQUENCE,
                STEPSTARTUTC,
                STEPENDUTC,
                STEPDURATIONHRS,
                INPUTQUANTITY,
                OUTPUTQUANTITY,
                QUANTITYUOM,
                STEPYIELDPCT,
                STEPSTATUS,
                OPERATORKEY,
                VERIFIERKEY,
                ESIGNATURETIMESTAMPUTC,
                ESIGNATUREMEANING,
                HASDEVIATION,
                DEVIATIONCOUNT,
                STEPNOTES,
                SOURCERUNIDMARTA,
                SOURCESTEPIDOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CAST(PRODUCTION_ORDER_KEY AS INTEGER),
                CANONICAL_BATCH_ID,
                CAST(PROCESS_STEP_KEY AS INTEGER),
                CAST(EQUIPMENT_KEY AS INTEGER),
                STEP_SEQUENCE,
                STEP_START_UTC,
                STEP_END_UTC,
                STEP_DURATION_HRS,
                INPUT_QUANTITY,
                OUTPUT_QUANTITY,
                QUANTITY_UOM,
                STEP_YIELD_PCT,
                STEP_STATUS,
                CAST(OPERATOR_KEY AS INTEGER),
                CAST(VERIFIER_KEY AS INTEGER),
                ESIGNATURE_TIMESTAMP_UTC,
                ESIGNATURE_MEANING,
                HAS_DEVIATION,
                DEVIATION_COUNT,
                STEP_NOTES,
                SOURCE_RUN_ID_MART_A,
                SOURCE_STEP_ID_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_BATCH_STEP
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_BATCH_STEP', 'FACT_BATCH_STEP',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_BATCH_STEP completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_BATCH_STEP', 'FACT_BATCH_STEP',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_BATCH_STEP - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_EQUIPMENT_TELEMETRY
-- Target table: FACT_EQUIPMENT_TELEMETRY (ANALYTICAL schema)
-- Source canonical entity: FACT_EQUIPMENT_TELEMETRY (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_EQUIPMENT_TELEMETRY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_EQUIPMENT_TELEMETRY;

            INSERT INTO ANALYTICAL.FACT_EQUIPMENT_TELEMETRY (
                TELEMETRYKEY,
                EQUIPMENTKEY,
                BATCHSTEPKEY,
                PRODUCTIONORDERKEY,
                CANONICALBATCHID,
                PARAMETERKEY,
                READINGTIMESTAMPUTC,
                CANONICALVALUE,
                CANONICALUOM,
                SOURCEVALUE,
                SOURCEUOM,
                CONVERSIONAPPLIED,
                TARGETVALUE,
                LOWERSPECLIMIT,
                UPPERSPECLIMIT,
                LOWERALERTLIMIT,
                UPPERALERTLIMIT,
                WITHINSPECIFICATION,
                WITHINALERT,
                DEVIATIONFROMTARGET,
                GOLDENBATCHVALUE,
                GOLDENBATCHDEVIATION,
                AGGREGATIONTYPE,
                SOURCESYSTEMTYPE,
                SOURCEREADINGIDMARTA,
                SOURCEREADINGIDOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CAST(EQUIPMENT_KEY AS INTEGER),
                CAST(BATCH_STEP_KEY AS INTEGER),
                CAST(PRODUCTION_ORDER_KEY AS INTEGER),
                CANONICAL_BATCH_ID,
                CAST(PARAMETER_KEY AS INTEGER),
                READING_TIMESTAMP_UTC,
                CANONICAL_VALUE,
                CANONICAL_UOM,
                SOURCE_VALUE,
                SOURCE_UOM,
                CONVERSION_APPLIED,
                TARGET_VALUE,
                LOWER_SPEC_LIMIT,
                UPPER_SPEC_LIMIT,
                LOWER_ALERT_LIMIT,
                UPPER_ALERT_LIMIT,
                WITHIN_SPECIFICATION,
                WITHIN_ALERT,
                DEVIATION_FROM_TARGET,
                GOLDEN_BATCH_VALUE,
                GOLDEN_BATCH_DEVIATION,
                AGGREGATION_TYPE,
                SOURCE_SYSTEM_TYPE,
                SOURCE_READING_ID_MART_A,
                SOURCE_READING_ID_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_EQUIPMENT_TELEMETRY
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_EQUIPMENT_TELEMETRY', 'FACT_EQUIPMENT_TELEMETRY',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_EQUIPMENT_TELEMETRY completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_EQUIPMENT_TELEMETRY', 'FACT_EQUIPMENT_TELEMETRY',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_EQUIPMENT_TELEMETRY - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_DEVIATION
-- Target table: FACT_DEVIATION (ANALYTICAL schema)
-- Source canonical entity: FACT_DEVIATION (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_DEVIATION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_DEVIATION;

            INSERT INTO ANALYTICAL.FACT_DEVIATION (
                DEVIATIONKEY,
                CANONICALDEVIATIONID,
                PRODUCTIONORDERKEY,
                BATCHSTEPKEY,
                TELEMETRYKEY,
                EQUIPMENTKEY,
                PARAMETERKEY,
                DEVIATIONCATEGORYKEY,
                FACILITYKEY,
                CANONICALBATCHID,
                DETECTEDTIMESTAMPUTC,
                DETECTEDBYKEY,
                DETECTIONMETHOD,
                SEVERITYCODE,
                POTENTIALIMPACT,
                DEVIATIONDESCRIPTION,
                INVESTIGATIONSTATUS,
                ASSIGNEDTOKEY,
                INVESTIGATIONSTARTUTC,
                INVESTIGATIONENDUTC,
                ROOTCAUSECODE,
                ROOTCAUSEDESCRIPTION,
                CAPAREQUIRED,
                CAPAREFERENCEID,
                CAPADUEDATE,
                CAPACLOSEDDATE,
                CLOSEDTIMESTAMPUTC,
                CLOSEDBYKEY,
                RESOLUTIONSUMMARY,
                REGULATORYNOTIFICATIONREQUIRED,
                REGULATORYNOTIFIEDDATE,
                SOURCEDEVIDMARTA,
                SOURCEDEVNUMOPS,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CANONICAL_DEVIATION_ID,
                CAST(PRODUCTION_ORDER_KEY AS INTEGER),
                CAST(BATCH_STEP_KEY AS INTEGER),
                CAST(TELEMETRY_KEY AS INTEGER),
                CAST(EQUIPMENT_KEY AS INTEGER),
                CAST(PARAMETER_KEY AS INTEGER),
                CAST(DEVIATION_CATEGORY_KEY AS INTEGER),
                CAST(FACILITY_KEY AS INTEGER),
                CANONICAL_BATCH_ID,
                DETECTED_TIMESTAMP_UTC,
                CAST(DETECTED_BY_KEY AS INTEGER),
                DETECTION_METHOD,
                SEVERITY_CODE,
                POTENTIAL_IMPACT,
                DEVIATION_DESCRIPTION,
                INVESTIGATION_STATUS,
                CAST(ASSIGNED_TO_KEY AS INTEGER),
                INVESTIGATION_START_UTC,
                INVESTIGATION_END_UTC,
                ROOT_CAUSE_CODE,
                ROOT_CAUSE_DESCRIPTION,
                CAPA_REQUIRED,
                CAPA_REFERENCE_ID,
                CAPA_DUE_DATE,
                CAPA_CLOSED_DATE,
                CLOSED_TIMESTAMP_UTC,
                CAST(CLOSED_BY_KEY AS INTEGER),
                RESOLUTION_SUMMARY,
                REGULATORY_NOTIFICATION_REQUIRED,
                REGULATORY_NOTIFIED_DATE,
                SOURCE_DEV_ID_MART_A,
                SOURCE_DEV_NUM_OPS,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_DEVIATION
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_DEVIATION', 'FACT_DEVIATION',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_DEVIATION completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_DEVIATION', 'FACT_DEVIATION',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_DEVIATION - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_YIELD_ANALYTICS
-- Target table: FACT_YIELD_ANALYTICS (ANALYTICAL schema)
-- Source canonical entity: FACT_YIELD_ANALYTICS (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_YIELD_ANALYTICS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_YIELD_ANALYTICS;

            INSERT INTO ANALYTICAL.FACT_YIELD_ANALYTICS (
                YIELDANALYTICSKEY,
                ANALYSISDATE,
                FACILITYKEY,
                PRODUCTKEY,
                AGGREGATIONLEVEL,
                BATCHESSTARTED,
                BATCHESCOMPLETED,
                BATCHESONHOLD,
                BATCHESFAILED,
                AVGYIELDPCT,
                MINYIELDPCT,
                MAXYIELDPCT,
                STDYIELDPCT,
                YIELDBELOWTARGETCOUNT,
                YIELDTARGETATTAINMENTPCT,
                TOTALPLANNEDQTY,
                TOTALACTUALQTY,
                QUANTITYUOM,
                AVGOEEPCT,
                AVGAVAILABILITYPCT,
                AVGPERFORMANCEPCT,
                AVGQUALITYPCT,
                TOTALDEVIATIONS,
                HIGHCRITICALDEVIATIONS,
                CPPCOMPLIANCERATEPCT,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                ANALYSIS_DATE,
                CAST(FACILITY_KEY AS INTEGER),
                CAST(PRODUCT_KEY AS INTEGER),
                AGGREGATION_LEVEL,
                BATCHES_STARTED,
                BATCHES_COMPLETED,
                BATCHES_ON_HOLD,
                BATCHES_FAILED,
                AVG_YIELD_PCT,
                MIN_YIELD_PCT,
                MAX_YIELD_PCT,
                STD_YIELD_PCT,
                YIELD_BELOW_TARGET_COUNT,
                YIELD_TARGET_ATTAINMENT_PCT,
                TOTAL_PLANNED_QTY,
                TOTAL_ACTUAL_QTY,
                QUANTITY_UOM,
                AVG_OEE_PCT,
                AVG_AVAILABILITY_PCT,
                AVG_PERFORMANCE_PCT,
                AVG_QUALITY_PCT,
                TOTAL_DEVIATIONS,
                HIGH_CRITICAL_DEVIATIONS,
                CPP_COMPLIANCE_RATE_PCT,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_YIELD_ANALYTICS
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_YIELD_ANALYTICS', 'FACT_YIELD_ANALYTICS',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_YIELD_ANALYTICS completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_YIELD_ANALYTICS', 'FACT_YIELD_ANALYTICS',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_YIELD_ANALYTICS - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```

---

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_SHIFT_LOG
-- Target table: FACT_SHIFT_LOG (ANALYTICAL schema)
-- Source canonical entity: FACT_SHIFT_LOG (CANONICAL schema)
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_SHIFT_LOG()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_attempt            INTEGER := 0;
    v_max_attempts       INTEGER := 3;
    v_rows_inserted      NUMBER := 0;
    v_rows_updated       NUMBER := 0;
    v_rows_rejected      NUMBER := 0;
    v_start_time         TIMESTAMP_TZ;
    v_end_time           TIMESTAMP_TZ;
    v_error_message      STRING;
    v_status             STRING;
BEGIN
    v_start_time := CURRENT_TIMESTAMP();
    v_status := 'IN_PROGRESS';

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_SHIFT_LOG;

            INSERT INTO ANALYTICAL.FACT_SHIFT_LOG (
                SHIFTLOGKEY,
                FACILITYKEY,
                LOGDATE,
                SHIFTNAME,
                SHIFTSTARTUTC,
                SHIFTENDUTC,
                SUPERVISORKEY,
                ACTIVEBATCHES,
                COMPLETEDBATCHES,
                NEWDEVIATIONS,
                CLOSEDDEVIATIONS,
                EQUIPMENTDOWNTIMEMINS,
                EQUIPMENTISSUESCOUNT,
                SIGNEDOFF,
                SIGNEDOFFUTC,
                SHIFTNOTES,
                SOURCELOGIDMARTA,
                SOURCESYSTEM,
                SOURCEKEY,
                LOADEDATUTC,
                CREATEDAT,
                CREATEDBY,
                UPDATEDAT,
                UPDATEDBY,
                ISDELETED,
                DELETEDAT
            )
            SELECT
                DEFAULT,
                CAST(FACILITY_KEY AS INTEGER),
                LOG_DATE,
                SHIFT_NAME,
                SHIFT_START_UTC,
                SHIFT_END_UTC,
                CAST(SUPERVISOR_KEY AS INTEGER),
                ACTIVE_BATCHES,
                COMPLETED_BATCHES,
                NEW_DEVIATIONS,
                CLOSED_DEVIATIONS,
                EQUIPMENT_DOWNTIME_MINS,
                EQUIPMENT_ISSUES_COUNT,
                SIGNED_OFF,
                SIGNED_OFF_UTC,
                SHIFT_NOTES,
                SOURCE_LOG_ID_MART_A,
                _SOURCE_SYSTEM,
                _SOURCE_KEY,
                _LOADED_AT_UTC,
                CREATED_AT,
                CREATED_BY,
                UPDATED_AT,
                UPDATED_BY,
                IS_DELETED,
                DELETED_AT
            FROM CANONICAL.FACT_SHIFT_LOG
            WHERE IS_DELETED = FALSE OR IS_DELETED IS NULL;

            v_rows_inserted := SQLROWCOUNT;

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            v_end_time := CURRENT_TIMESTAMP();

            INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
            )
            VALUES (
                'MIGRATE_FACT_SHIFT_LOG', 'FACT_SHIFT_LOG',
                v_start_time, v_end_time,
                v_status, v_error_message,
                v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
            );

            RETURN 'SUCCESS: MIGRATE_FACT_SHIFT_LOG completed';

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'FAILED_ATTEMPT_' || v_attempt;
                ROLLBACK;
                v_end_time := CURRENT_TIMESTAMP();

                INSERT INTO ANALYTICAL_MIGRATION_AUDIT (
                    PROC_NAME, TARGET_TABLE, START_TIME, END_TIME,
                    STATUS, ERROR_MESSAGE, ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, ATTEMPT_NUMBER
                )
                VALUES (
                    'MIGRATE_FACT_SHIFT_LOG', 'FACT_SHIFT_LOG',
                    v_start_time, v_end_time,
                    v_status, v_error_message,
                    v_rows_inserted, v_rows_updated, v_rows_rejected, v_attempt
                );

                CALL SYSTEM$WAIT(5);
        END;

        IF (v_status = 'SUCCESS') THEN
            EXIT;
        END IF;
    END WHILE;

    IF (v_status <> 'SUCCESS') THEN
        RETURN 'FAILURE: MIGRATE_FACT_SHIFT_LOG - ' || COALESCE(v_error_message, 'UNKNOWN ERROR');
    END IF;
END;
$$;
```
