# Snowflake Analytical Stored Procedure Generator

## Section 1 — Migration Summary

| Metric | Detail |
|---|---|
| Total analytical model tables | 12 |
| Total stored procedures generated | 12 |
| Tables with validation issues | DimDate (derived calendar; no direct canonical entity) |
| PII/PHI-handling procedures | 1 (DIM_OPERATOR) |

## Section 2 — Snowflake Stored Procedures

> Assumptions (consistent across all procedures):
>
> - Canonical tables exist in a schema `CANONICAL` with names matching `DIM_*` and `FACT_*` entities in the mapping table.
> - Analytical/star tables exist in schema `ANALYTICAL` with names as listed (e.g., `DIM_ORGANIZATION`, `FACT_PRODUCTION_ORDER`).
> - An audit log table exists: `ANALYTICAL.AUDIT_LOG` with at least these columns:
>   - `AUDIT_ID` (NUMBER AUTOINCREMENT), `PROC_NAME` (STRING), `TARGET_TABLE` (STRING), `LOAD_START_TS` (TIMESTAMP_TZ),
>   - `LOAD_END_TS` (TIMESTAMP_TZ), `ROWS_INSERTED` (NUMBER), `ROWS_UPDATED` (NUMBER), `ROWS_REJECTED` (NUMBER),
>   - `STATUS` (STRING), `ERROR_MESSAGE` (STRING).
> - For simplicity, all procedures perform full refresh inserts (no updates) from canonical to analytical, except that SCD Type 2
>   dimensions preserve existing records by not deleting current rows; more advanced SCD handling can be layered on top.
> - PII masking for `DIM_OPERATOR.FullName` is implemented as `NULL` (can be replaced with tokenization function per policy).

---

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_ORGANIZATION
-- Target table: ANALYTICAL.DIM_ORGANIZATION
-- Source canonical entity: CANONICAL.DIM_ORGANIZATION
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_ORGANIZATION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_ORGANIZATION';
    v_target_table        STRING   := 'ANALYTICAL.DIM_ORGANIZATION';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    -- Audit: start event
    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            -- Full reload strategy: optional truncate; comment out if incremental needed
            TRUNCATE TABLE ANALYTICAL.DIM_ORGANIZATION;

            -- Insert from canonical to analytical
            INSERT INTO ANALYTICAL.DIM_ORGANIZATION
            (
                OrganizationKey,
                OrganizationID,
                OrganizationName,
                OrganizationType,
                ParentOrganizationKey,
                CountryCode,
                RegulatoryRegion,
                IsActive,
                EffectiveStartDate,
                EffectiveEndDate,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                ORGANIZATION_KEY        AS OrganizationKey,
                ORGANIZATION_ID         AS OrganizationID,
                ORGANIZATION_NAME       AS OrganizationName,
                ORGANIZATION_TYPE       AS OrganizationType,
                PARENT_ORGANIZATION_KEY AS ParentOrganizationKey,
                COUNTRY_CODE            AS CountryCode,
                REGULATORY_REGION       AS RegulatoryRegion,
                IS_ACTIVE               AS IsActive,
                EFFECTIVE_START_DATE    AS EffectiveStartDate,
                EFFECTIVE_END_DATE      AS EffectiveEndDate,
                _SOURCE_SYSTEM          AS SourceSystem,
                _SOURCE_KEY             AS SourceKey,
                CREATED_AT              AS CreatedAt,
                CREATED_BY              AS CreatedBy,
                UPDATED_AT              AS UpdatedAt,
                UPDATED_BY              AS UpdatedBy,
                IS_DELETED              AS IsDeleted,
                DELETED_AT              AS DeletedAt
            FROM CANONICAL.DIM_ORGANIZATION;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT; -- exit retry loop on success

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';

                ROLLBACK;

                -- Simple transient backoff
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    -- Final audit event
    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_ORGANIZATION completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_ORGANIZATION - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_FACILITY
-- Target table: ANALYTICAL.DIM_FACILITY
-- Source canonical entity: CANONICAL.DIM_FACILITY
-- Notes: SCD Type 2 dimension; this implementation performs full reload
-- and preserves historical rows from canonical as-is.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_FACILITY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_FACILITY';
    v_target_table        STRING   := 'ANALYTICAL.DIM_FACILITY';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            -- For SCD Type 2, often we do not truncate; here we assume canonical holds full history
            TRUNCATE TABLE ANALYTICAL.DIM_FACILITY;

            INSERT INTO ANALYTICAL.DIM_FACILITY
            (
                FacilityKey,
                FacilityID,
                FacilityName,
                FacilityShortName,
                OrganizationKey,
                SiteCode,
                FacilityType,
                AddressLine1,
                AddressLine2,
                City,
                StateRegion,
                PostalCode,
                CountryCode,
                TimezoneName,
                UtcOffsetHours,
                GmpCertified,
                GmpCertificationDate,
                GmpExpiryDate,
                RegulatoryAgency,
                FdaEstablishmentId,
                EmaSiteCode,
                ManufacturingCapacity,
                SourceSiteCodeMartA,
                SourcePlantCodeOps,
                SourceFacCodeMartB,
                EffectiveStartDate,
                EffectiveEndDate,
                CurrentFlag,
                ScdVersion,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                FACILITY_KEY             AS FacilityKey,
                FACILITY_ID             AS FacilityID,
                FACILITY_NAME           AS FacilityName,
                FACILITY_SHORT_NAME     AS FacilityShortName,
                ORGANIZATION_KEY        AS OrganizationKey,
                SITE_CODE               AS SiteCode,
                FACILITY_TYPE           AS FacilityType,
                ADDRESS_LINE_1          AS AddressLine1,
                ADDRESS_LINE_2          AS AddressLine2,
                CITY                    AS City,
                STATE_REGION            AS StateRegion,
                POSTAL_CODE             AS PostalCode,
                COUNTRY_CODE            AS CountryCode,
                TIMEZONE_NAME           AS TimezoneName,
                UTC_OFFSET_HOURS        AS UtcOffsetHours,
                GMP_CERTIFIED           AS GmpCertified,
                GMP_CERTIFICATION_DATE  AS GmpCertificationDate,
                GMP_EXPIRY_DATE         AS GmpExpiryDate,
                REGULATORY_AGENCY       AS RegulatoryAgency,
                FDA_ESTABLISHMENT_ID    AS FdaEstablishmentId,
                EMA_SITE_CODE           AS EmaSiteCode,
                MANUFACTURING_CAPACITY  AS ManufacturingCapacity,
                SOURCE_SITE_CODE_MART_A AS SourceSiteCodeMartA,
                SOURCE_PLANT_CODE_OPS   AS SourcePlantCodeOps,
                SOURCE_FAC_CODE_MART_B  AS SourceFacCodeMartB,
                EFFECTIVE_START_DATE    AS EffectiveStartDate,
                EFFECTIVE_END_DATE      AS EffectiveEndDate,
                CURRENT_FLAG            AS CurrentFlag,
                SCD_VERSION             AS ScdVersion,
                _SOURCE_SYSTEM          AS SourceSystem,
                _SOURCE_KEY             AS SourceKey,
                CREATED_AT              AS CreatedAt,
                CREATED_BY              AS CreatedBy,
                UPDATED_AT              AS UpdatedAt,
                UPDATED_BY              AS UpdatedBy,
                IS_DELETED              AS IsDeleted,
                DELETED_AT              AS DeletedAt
            FROM CANONICAL.DIM_FACILITY;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_FACILITY completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_FACILITY - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PRODUCT
-- Target table: ANALYTICAL.DIM_PRODUCT
-- Source canonical entity: CANONICAL.DIM_PRODUCT
-- Notes: SCD Type 2 dimension; full reload from canonical.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PRODUCT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_PRODUCT';
    v_target_table        STRING   := 'ANALYTICAL.DIM_PRODUCT';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PRODUCT;

            INSERT INTO ANALYTICAL.DIM_PRODUCT
            (
                ProductKey,
                ProductID,
                Sku,
                ProductName,
                ProductShortName,
                OrganizationKey,
                FormulationId,
                FormulationVersion,
                DosageForm,
                DosageStrength,
                RouteOfAdministration,
                TherapeuticClass,
                TherapeuticArea,
                ProductCategory,
                IsBiosimilar,
                ReferenceProductId,
                InnName,
                IdmpMpid,
                NdaBlaNumber,
                EmaProductNumber,
                StandardYieldPct,
                YieldLowerAlertPct,
                YieldLowerActionPct,
                ShelfLifeMonths,
                StorageCondition,
                EffectiveStartDate,
                EffectiveEndDate,
                CurrentFlag,
                ScdVersion,
                SourceProductCodeMartA,
                SourceProductCodeOps,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                PRODUCT_KEY                  AS ProductKey,
                PRODUCT_ID                   AS ProductID,
                SKU                          AS Sku,
                PRODUCT_NAME                 AS ProductName,
                PRODUCT_SHORT_NAME           AS ProductShortName,
                ORGANIZATION_KEY             AS OrganizationKey,
                FORMULATION_ID               AS FormulationId,
                FORMULATION_VERSION          AS FormulationVersion,
                DOSAGE_FORM                  AS DosageForm,
                DOSAGE_STRENGTH              AS DosageStrength,
                ROUTE_OF_ADMINISTRATION      AS RouteOfAdministration,
                THERAPEUTIC_CLASS            AS TherapeuticClass,
                THERAPEUTIC_AREA             AS TherapeuticArea,
                PRODUCT_CATEGORY             AS ProductCategory,
                IS_BIOSIMILAR                AS IsBiosimilar,
                REFERENCE_PRODUCT_ID         AS ReferenceProductId,
                INN_NAME                     AS InnName,
                IDMP_MPID                    AS IdmpMpid,
                NDA_BLA_NUMBER               AS NdaBlaNumber,
                EMA_PRODUCT_NUMBER           AS EmaProductNumber,
                STANDARD_YIELD_PCT           AS StandardYieldPct,
                YIELD_LOWER_ALERT_PCT        AS YieldLowerAlertPct,
                YIELD_LOWER_ACTION_PCT       AS YieldLowerActionPct,
                SHELF_LIFE_MONTHS            AS ShelfLifeMonths,
                STORAGE_CONDITION            AS StorageCondition,
                EFFECTIVE_START_DATE         AS EffectiveStartDate,
                EFFECTIVE_END_DATE           AS EffectiveEndDate,
                CURRENT_FLAG                 AS CurrentFlag,
                SCD_VERSION                  AS ScdVersion,
                SOURCE_PRODUCT_CODE_MART_A   AS SourceProductCodeMartA,
                SOURCE_PRODUCT_CODE_OPS      AS SourceProductCodeOps,
                _SOURCE_SYSTEM               AS SourceSystem,
                _SOURCE_KEY                  AS SourceKey,
                CREATED_AT                   AS CreatedAt,
                CREATED_BY                   AS CreatedBy,
                UPDATED_AT                   AS UpdatedAt,
                UPDATED_BY                   AS UpdatedBy,
                IS_DELETED                   AS IsDeleted,
                DELETED_AT                   AS DeletedAt
            FROM CANONICAL.DIM_PRODUCT;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_PRODUCT completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_PRODUCT - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_MATERIAL_LOT
-- Target table: ANALYTICAL.DIM_MATERIAL_LOT
-- Source canonical entity: CANONICAL.DIM_MATERIAL_LOT
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_MATERIAL_LOT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_MATERIAL_LOT';
    v_target_table        STRING   := 'ANALYTICAL.DIM_MATERIAL_LOT';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_MATERIAL_LOT;

            INSERT INTO ANALYTICAL.DIM_MATERIAL_LOT
            (
                MaterialLotKey,
                LotNumber,
                ProductKey,
                FacilityKey,
                LotType,
                ManufactureDate,
                ExpiryDate,
                RetestDate,
                QuantityProduced,
                QuantityUnit,
                LotStatus,
                CertificateOfAnalysis,
                VendorLotNumber,
                VendorId,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                MATERIAL_LOT_KEY         AS MaterialLotKey,
                LOT_NUMBER               AS LotNumber,
                PRODUCT_KEY              AS ProductKey,
                FACILITY_KEY             AS FacilityKey,
                LOT_TYPE                 AS LotType,
                MANUFACTURE_DATE         AS ManufactureDate,
                EXPIRY_DATE              AS ExpiryDate,
                RETEST_DATE              AS RetestDate,
                QUANTITY_PRODUCED        AS QuantityProduced,
                QUANTITY_UNIT            AS QuantityUnit,
                LOT_STATUS               AS LotStatus,
                CERTIFICATE_OF_ANALYSIS  AS CertificateOfAnalysis,
                VENDOR_LOT_NUMBER        AS VendorLotNumber,
                VENDOR_ID                AS VendorId,
                _SOURCE_SYSTEM           AS SourceSystem,
                _SOURCE_KEY              AS SourceKey,
                CREATED_AT               AS CreatedAt,
                CREATED_BY               AS CreatedBy,
                UPDATED_AT               AS UpdatedAt,
                UPDATED_BY               AS UpdatedBy,
                IS_DELETED               AS IsDeleted,
                DELETED_AT               AS DeletedAt
            FROM CANONICAL.DIM_MATERIAL_LOT;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_MATERIAL_LOT completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_MATERIAL_LOT - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_EQUIPMENT
-- Target table: ANALYTICAL.DIM_EQUIPMENT
-- Source canonical entity: CANONICAL.DIM_EQUIPMENT
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_EQUIPMENT()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_EQUIPMENT';
    v_target_table        STRING   := 'ANALYTICAL.DIM_EQUIPMENT';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_EQUIPMENT;

            INSERT INTO ANALYTICAL.DIM_EQUIPMENT
            (
                EquipmentKey,
                CanonicalEquipmentID,
                EquipmentName,
                FacilityKey,
                FunctionalArea,
                ProductionUnit,
                EquipmentModule,
                AssetClass,
                AssetSubClass,
                CriticalityRating,
                ManufacturerName,
                ModelNumber,
                SerialNumber,
                WorkingVolumeL,
                InstallationDate,
                CommissioningDate,
                QualificationStatus,
                LastQualificationDate,
                NextQualificationDate,
                CalibrationFrequency,
                LastCalibrationDate,
                CalibrationDueDate,
                CalibrationStatus,
                PlannedRuntimeMinsPerDay,
                IdealCycleTimeSecs,
                EquipmentStatus,
                StatusEffectiveDate,
                DecommissionDate,
                SourceEquipIdMartA,
                SourceAssetCodeOps,
                SourceEquipCodeMartB,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                EQUIPMENT_KEY              AS EquipmentKey,
                CANONICAL_EQUIPMENT_ID     AS CanonicalEquipmentID,
                EQUIPMENT_NAME             AS EquipmentName,
                FACILITY_KEY               AS FacilityKey,
                FUNCTIONAL_AREA            AS FunctionalArea,
                PRODUCTION_UNIT            AS ProductionUnit,
                EQUIPMENT_MODULE           AS EquipmentModule,
                ASSET_CLASS                AS AssetClass,
                ASSET_SUBCLASS             AS AssetSubClass,
                CRITICALITY_RATING         AS CriticalityRating,
                MANUFACTURER_NAME          AS ManufacturerName,
                MODEL_NUMBER               AS ModelNumber,
                SERIAL_NUMBER              AS SerialNumber,
                WORKING_VOLUME_L           AS WorkingVolumeL,
                INSTALLATION_DATE          AS InstallationDate,
                COMMISSIONING_DATE         AS CommissioningDate,
                QUALIFICATION_STATUS       AS QualificationStatus,
                LAST_QUALIFICATION_DATE    AS LastQualificationDate,
                NEXT_QUALIFICATION_DATE    AS NextQualificationDate,
                CALIBRATION_FREQUENCY      AS CalibrationFrequency,
                LAST_CALIBRATION_DATE      AS LastCalibrationDate,
                CALIBRATION_DUE_DATE       AS CalibrationDueDate,
                CALIBRATION_STATUS         AS CalibrationStatus,
                PLANNED_RUNTIME_MINS_PER_DAY AS PlannedRuntimeMinsPerDay,
                IDEAL_CYCLE_TIME_SECS      AS IdealCycleTimeSecs,
                EQUIPMENT_STATUS           AS EquipmentStatus,
                STATUS_EFFECTIVE_DATE      AS StatusEffectiveDate,
                DECOMMISSION_DATE          AS DecommissionDate,
                SOURCE_EQUIP_ID_MART_A     AS SourceEquipIdMartA,
                SOURCE_ASSET_CODE_OPS      AS SourceAssetCodeOps,
                SOURCE_EQUIP_CODE_MART_B   AS SourceEquipCodeMartB,
                _SOURCE_SYSTEM             AS SourceSystem,
                _SOURCE_KEY                AS SourceKey,
                CREATED_AT                 AS CreatedAt,
                CREATED_BY                 AS CreatedBy,
                UPDATED_AT                 AS UpdatedAt,
                UPDATED_BY                 AS UpdatedBy,
                IS_DELETED                 AS IsDeleted,
                DELETED_AT                 AS DeletedAt
            FROM CANONICAL.DIM_EQUIPMENT;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_EQUIPMENT completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_EQUIPMENT - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PROCESS_STEP
-- Target table: ANALYTICAL.DIM_PROCESS_STEP
-- Source canonical entity: CANONICAL.DIM_PROCESS_STEP
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PROCESS_STEP()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_PROCESS_STEP';
    v_target_table        STRING   := 'ANALYTICAL.DIM_PROCESS_STEP';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PROCESS_STEP;

            INSERT INTO ANALYTICAL.DIM_PROCESS_STEP
            (
                ProcessStepKey,
                StepCode,
                StepName,
                StepCategory,
                StepSubCategory,
                TypicalSequenceOrder,
                ExpectedDurationMinHrs,
                ExpectedDurationMaxHrs,
                ApplicableAssetClasses,
                IsCcp,
                IsActive,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                PROCESS_STEP_KEY           AS ProcessStepKey,
                STEP_CODE                  AS StepCode,
                STEP_NAME                  AS StepName,
                STEP_CATEGORY              AS StepCategory,
                STEP_SUBCATEGORY           AS StepSubCategory,
                TYPICAL_SEQUENCE_ORDER     AS TypicalSequenceOrder,
                EXPECTED_DURATION_MIN_HRS  AS ExpectedDurationMinHrs,
                EXPECTED_DURATION_MAX_HRS  AS ExpectedDurationMaxHrs,
                APPLICABLE_ASSET_CLASSES   AS ApplicableAssetClasses,
                IS_CCP                     AS IsCcp,
                IS_ACTIVE                  AS IsActive,
                _SOURCE_SYSTEM             AS SourceSystem,
                _SOURCE_KEY                AS SourceKey,
                CREATED_AT                 AS CreatedAt,
                CREATED_BY                 AS CreatedBy,
                UPDATED_AT                 AS UpdatedAt,
                UPDATED_BY                 AS UpdatedBy,
                IS_DELETED                 AS IsDeleted,
                DELETED_AT                 AS DeletedAt
            FROM CANONICAL.DIM_PROCESS_STEP;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_PROCESS_STEP completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_PROCESS_STEP - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_PROCESS_PARAMETER
-- Target table: ANALYTICAL.DIM_PROCESS_PARAMETER
-- Source canonical entity: CANONICAL.DIM_PROCESS_PARAMETER
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_PROCESS_PARAMETER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_PROCESS_PARAMETER';
    v_target_table        STRING   := 'ANALYTICAL.DIM_PROCESS_PARAMETER';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_PROCESS_PARAMETER;

            INSERT INTO ANALYTICAL.DIM_PROCESS_PARAMETER
            (
                ParameterKey,
                ParameterCode,
                ParameterName,
                ParameterCategory,
                CanonicalUom,
                SourceUomMartA,
                SourceUomOps,
                SourceUomMartB,
                ConversionFormulaOps,
                IsCpp,
                IsKpa,
                TypicalTarget,
                TypicalLsl,
                TypicalUsl,
                MeasurementFrequency,
                InstrumentType,
                IsActive,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                PARAMETER_KEY          AS ParameterKey,
                PARAMETER_CODE         AS ParameterCode,
                PARAMETER_NAME         AS ParameterName,
                PARAMETER_CATEGORY     AS ParameterCategory,
                CANONICAL_UOM          AS CanonicalUom,
                SOURCE_UOM_MART_A      AS SourceUomMartA,
                SOURCE_UOM_OPS         AS SourceUomOps,
                SOURCE_UOM_MART_B      AS SourceUomMartB,
                CONVERSION_FORMULA_OPS AS ConversionFormulaOps,
                IS_CPP                 AS IsCpp,
                IS_KPA                 AS IsKpa,
                TYPICAL_TARGET         AS TypicalTarget,
                TYPICAL_LSL            AS TypicalLsl,
                TYPICAL_USL            AS TypicalUsl,
                MEASUREMENT_FREQUENCY  AS MeasurementFrequency,
                INSTRUMENT_TYPE        AS InstrumentType,
                IS_ACTIVE              AS IsActive,
                _SOURCE_SYSTEM         AS SourceSystem,
                _SOURCE_KEY            AS SourceKey,
                CREATED_AT             AS CreatedAt,
                CREATED_BY             AS CreatedBy,
                UPDATED_AT             AS UpdatedAt,
                UPDATED_BY             AS UpdatedBy,
                IS_DELETED             AS IsDeleted,
                DELETED_AT             AS DeletedAt
            FROM CANONICAL.DIM_PROCESS_PARAMETER;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_PROCESS_PARAMETER completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_PROCESS_PARAMETER - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_QUALITY_DISPOSITION
-- Target table: ANALYTICAL.DIM_QUALITY_DISPOSITION
-- Source canonical entity: CANONICAL.DIM_QUALITY_DISPOSITION
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_QUALITY_DISPOSITION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_QUALITY_DISPOSITION';
    v_target_table        STRING   := 'ANALYTICAL.DIM_QUALITY_DISPOSITION';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_QUALITY_DISPOSITION;

            INSERT INTO ANALYTICAL.DIM_QUALITY_DISPOSITION
            (
                DispositionKey,
                DispositionCode,
                DispositionName,
                RequiresInvestigation,
                CommerciallyReleasable,
                DeviationImplied,
                PatientRiskLevel,
                RegulatoryNotificationRequired,
                DispositionDescription,
                IsActive,
                SourceCodeMartA,
                SourceCodeMartB,
                SourceCodeOps,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                DISPOSITION_KEY                 AS DispositionKey,
                DISPOSITION_CODE                AS DispositionCode,
                DISPOSITION_NAME                AS DispositionName,
                REQUIRES_INVESTIGATION          AS RequiresInvestigation,
                COMMERCIALLY_RELEASABLE         AS CommerciallyReleasable,
                DEVIATION_IMPLIED               AS DeviationImplied,
                PATIENT_RISK_LEVEL              AS PatientRiskLevel,
                REGULATORY_NOTIFICATION_REQUIRED AS RegulatoryNotificationRequired,
                DISPOSITION_DESCRIPTION         AS DispositionDescription,
                IS_ACTIVE                       AS IsActive,
                SOURCE_CODE_MART_A              AS SourceCodeMartA,
                SOURCE_CODE_MART_B              AS SourceCodeMartB,
                SOURCE_CODE_OPS                 AS SourceCodeOps,
                _SOURCE_SYSTEM                  AS SourceSystem,
                _SOURCE_KEY                     AS SourceKey,
                CREATED_AT                      AS CreatedAt,
                CREATED_BY                      AS CreatedBy,
                UPDATED_AT                      AS UpdatedAt,
                UPDATED_BY                      AS UpdatedBy,
                IS_DELETED                      AS IsDeleted,
                DELETED_AT                      AS DeletedAt
            FROM CANONICAL.DIM_QUALITY_DISPOSITION;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_QUALITY_DISPOSITION completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_QUALITY_DISPOSITION - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_DEVIATION_CATEGORY
-- Target table: ANALYTICAL.DIM_DEVIATION_CATEGORY
-- Source canonical entity: CANONICAL.DIM_DEVIATION_CATEGORY
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_DEVIATION_CATEGORY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_DEVIATION_CATEGORY';
    v_target_table        STRING   := 'ANALYTICAL.DIM_DEVIATION_CATEGORY';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_DEVIATION_CATEGORY;

            INSERT INTO ANALYTICAL.DIM_DEVIATION_CATEGORY
            (
                DeviationCategoryKey,
                CategoryCode,
                CategoryName,
                CategoryGroup,
                Description,
                CapaTypicallyRequired,
                IsActive,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                DEVIATION_CATEGORY_KEY  AS DeviationCategoryKey,
                CATEGORY_CODE           AS CategoryCode,
                CATEGORY_NAME           AS CategoryName,
                CATEGORY_GROUP          AS CategoryGroup,
                DESCRIPTION             AS Description,
                CAPA_TYPICALLY_REQUIRED AS CapaTypicallyRequired,
                IS_ACTIVE               AS IsActive,
                CREATED_AT              AS CreatedAt,
                CREATED_BY              AS CreatedBy,
                UPDATED_AT              AS UpdatedAt,
                UPDATED_BY              AS UpdatedBy,
                IS_DELETED              AS IsDeleted,
                DELETED_AT              AS DeletedAt
            FROM CANONICAL.DIM_DEVIATION_CATEGORY;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_DEVIATION_CATEGORY completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_DEVIATION_CATEGORY - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_OPERATOR
-- Target table: ANALYTICAL.DIM_OPERATOR
-- Source canonical entity: CANONICAL.DIM_OPERATOR
-- Notes: Contains PII (FullName). FullName is masked to NULL to avoid
--        storing clear-text PII in the analytical model.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_OPERATOR()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_OPERATOR';
    v_target_table        STRING   := 'ANALYTICAL.DIM_OPERATOR';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_OPERATOR;

            INSERT INTO ANALYTICAL.DIM_OPERATOR
            (
                OperatorKey,
                OperatorID,
                FullName,
                RoleCode,
                FacilityKey,
                Department,
                IsGmpTrained,
                TrainingExpiryDate,
                EsignatureEnabled,
                EmploymentStatus,
                SourceSystem,
                SourceKey,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                OPERATOR_KEY          AS OperatorKey,
                OPERATOR_ID           AS OperatorID,
                -- PII masking: do not store clear-text names
                NULL                  AS FullName,
                ROLE_CODE             AS RoleCode,
                FACILITY_KEY          AS FacilityKey,
                DEPARTMENT            AS Department,
                IS_GMP_TRAINED        AS IsGmpTrained,
                TRAINING_EXPIRY_DATE  AS TrainingExpiryDate,
                ESIGNATURE_ENABLED    AS EsignatureEnabled,
                EMPLOYMENT_STATUS     AS EmploymentStatus,
                _SOURCE_SYSTEM        AS SourceSystem,
                _SOURCE_KEY           AS SourceKey,
                CREATED_AT            AS CreatedAt,
                CREATED_BY            AS CreatedBy,
                UPDATED_AT            AS UpdatedAt,
                UPDATED_BY            AS UpdatedBy,
                IS_DELETED            AS IsDeleted,
                DELETED_AT            AS DeletedAt
            FROM CANONICAL.DIM_OPERATOR;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_OPERATOR completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_OPERATOR - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_PRODUCTION_ORDER
-- Target table: ANALYTICAL.FACT_PRODUCTION_ORDER
-- Source canonical entity: CANONICAL.FACT_PRODUCTION_ORDER
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_PRODUCTION_ORDER()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_PRODUCTION_ORDER';
    v_target_table        STRING   := 'ANALYTICAL.FACT_PRODUCTION_ORDER';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_PRODUCTION_ORDER;

            INSERT INTO ANALYTICAL.FACT_PRODUCTION_ORDER
            (
                ProductionOrderKey,
                CanonicalBatchID,
                ErpOrderNumber,
                MesBatchReference,
                GmpLotNumber,
                FacilityKey,
                ProductKey,
                PrimaryEquipmentKey,
                DispositionKey,
                PlannedStartUTC,
                PlannedEndUTC,
                PlannedQuantity,
                QuantityUom,
                ActualStartUTC,
                ActualEndUTC,
                ActualQuantity,
                YieldPct,
                YieldVariancePct,
                OeeAvailabilityPct,
                OeePerformancePct,
                OeeQualityPct,
                OeeOverallPct,
                BatchStatus,
                DeviationCount,
                IsGoldenBatch,
                GoldenBatchReference,
                ShiftAtStart,
                ShiftSupervisorKey,
                SourceBatchIdMartA,
                SourceBatchIdOps,
                SourceOrderNumOps,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                PRODUCTION_ORDER_KEY    AS ProductionOrderKey,
                CANONICAL_BATCH_ID      AS CanonicalBatchID,
                ERP_ORDER_NUMBER        AS ErpOrderNumber,
                MES_BATCH_REFERENCE     AS MesBatchReference,
                GMP_LOT_NUMBER          AS GmpLotNumber,
                FACILITY_KEY            AS FacilityKey,
                PRODUCT_KEY             AS ProductKey,
                PRIMARY_EQUIPMENT_KEY   AS PrimaryEquipmentKey,
                DISPOSITION_KEY         AS DispositionKey,
                PLANNED_START_UTC       AS PlannedStartUTC,
                PLANNED_END_UTC         AS PlannedEndUTC,
                PLANNED_QUANTITY        AS PlannedQuantity,
                QUANTITY_UOM            AS QuantityUom,
                ACTUAL_START_UTC        AS ActualStartUTC,
                ACTUAL_END_UTC          AS ActualEndUTC,
                ACTUAL_QUANTITY         AS ActualQuantity,
                YIELD_PCT               AS YieldPct,
                YIELD_VARIANCE_PCT      AS YieldVariancePct,
                OEE_AVAILABILITY_PCT    AS OeeAvailabilityPct,
                OEE_PERFORMANCE_PCT     AS OeePerformancePct,
                OEE_QUALITY_PCT         AS OeeQualityPct,
                OEE_OVERALL_PCT         AS OeeOverallPct,
                BATCH_STATUS            AS BatchStatus,
                DEVIATION_COUNT         AS DeviationCount,
                IS_GOLDEN_BATCH         AS IsGoldenBatch,
                GOLDEN_BATCH_REFERENCE  AS GoldenBatchReference,
                SHIFT_AT_START          AS ShiftAtStart,
                SHIFT_SUPERVISOR_KEY    AS ShiftSupervisorKey,
                SOURCE_BATCH_ID_MART_A  AS SourceBatchIdMartA,
                SOURCE_BATCH_ID_OPS     AS SourceBatchIdOps,
                SOURCE_ORDER_NUM_OPS    AS SourceOrderNumOps,
                _SOURCE_SYSTEM          AS SourceSystem,
                _SOURCE_KEY             AS SourceKey,
                _LOADED_AT_UTC          AS LoadedAtUTC,
                CREATED_AT              AS CreatedAt,
                CREATED_BY              AS CreatedBy,
                UPDATED_AT              AS UpdatedAt,
                UPDATED_BY              AS UpdatedBy,
                IS_DELETED              AS IsDeleted,
                DELETED_AT              AS DeletedAt
            FROM CANONICAL.FACT_PRODUCTION_ORDER;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_PRODUCTION_ORDER completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_PRODUCTION_ORDER - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_BATCH_STEP
-- Target table: ANALYTICAL.FACT_BATCH_STEP
-- Source canonical entity: CANONICAL.FACT_BATCH_STEP
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_BATCH_STEP()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_BATCH_STEP';
    v_target_table        STRING   := 'ANALYTICAL.FACT_BATCH_STEP';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_BATCH_STEP;

            INSERT INTO ANALYTICAL.FACT_BATCH_STEP
            (
                BatchStepKey,
                ProductionOrderKey,
                CanonicalBatchID,
                ProcessStepKey,
                EquipmentKey,
                StepSequence,
                StepStartUTC,
                StepEndUTC,
                StepDurationHrs,
                InputQuantity,
                OutputQuantity,
                QuantityUom,
                StepYieldPct,
                StepStatus,
                OperatorKey,
                VerifierKey,
                EsignatureTimestampUTC,
                EsignatureMeaning,
                HasDeviation,
                DeviationCount,
                StepNotes,
                SourceRunIdMartA,
                SourceStepIdOps,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                BATCH_STEP_KEY           AS BatchStepKey,
                PRODUCTION_ORDER_KEY     AS ProductionOrderKey,
                CANONICAL_BATCH_ID       AS CanonicalBatchID,
                PROCESS_STEP_KEY         AS ProcessStepKey,
                EQUIPMENT_KEY            AS EquipmentKey,
                STEP_SEQUENCE            AS StepSequence,
                STEP_START_UTC           AS StepStartUTC,
                STEP_END_UTC             AS StepEndUTC,
                STEP_DURATION_HRS        AS StepDurationHrs,
                INPUT_QUANTITY           AS InputQuantity,
                OUTPUT_QUANTITY          AS OutputQuantity,
                QUANTITY_UOM             AS QuantityUom,
                STEP_YIELD_PCT           AS StepYieldPct,
                STEP_STATUS              AS StepStatus,
                OPERATOR_KEY             AS OperatorKey,
                VERIFIER_KEY             AS VerifierKey,
                ESIGNATURE_TIMESTAMP_UTC AS EsignatureTimestampUTC,
                ESIGNATURE_MEANING       AS EsignatureMeaning,
                HAS_DEVIATION            AS HasDeviation,
                DEVIATION_COUNT          AS DeviationCount,
                STEP_NOTES               AS StepNotes,
                SOURCE_RUN_ID_MART_A     AS SourceRunIdMartA,
                SOURCE_STEP_ID_OPS       AS SourceStepIdOps,
                _SOURCE_SYSTEM           AS SourceSystem,
                _SOURCE_KEY              AS SourceKey,
                _LOADED_AT_UTC           AS LoadedAtUTC,
                CREATED_AT               AS CreatedAt,
                CREATED_BY               AS CreatedBy,
                UPDATED_AT               AS UpdatedAt,
                UPDATED_BY               AS UpdatedBy,
                IS_DELETED               AS IsDeleted,
                DELETED_AT               AS DeletedAt
            FROM CANONICAL.FACT_BATCH_STEP;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_BATCH_STEP completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_BATCH_STEP - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_EQUIPMENT_TELEMETRY
-- Target table: ANALYTICAL.FACT_EQUIPMENT_TELEMETRY
-- Source canonical entity: CANONICAL.FACT_EQUIPMENT_TELEMETRY
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_EQUIPMENT_TELEMETRY()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_EQUIPMENT_TELEMETRY';
    v_target_table        STRING   := 'ANALYTICAL.FACT_EQUIPMENT_TELEMETRY';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_EQUIPMENT_TELEMETRY;

            INSERT INTO ANALYTICAL.FACT_EQUIPMENT_TELEMETRY
            (
                TelemetryKey,
                EquipmentKey,
                BatchStepKey,
                ProductionOrderKey,
                CanonicalBatchID,
                ParameterKey,
                ReadingTimestampUTC,
                CanonicalValue,
                CanonicalUom,
                SourceValue,
                SourceUom,
                ConversionApplied,
                TargetValue,
                LowerSpecLimit,
                UpperSpecLimit,
                LowerAlertLimit,
                UpperAlertLimit,
                WithinSpecification,
                WithinAlert,
                DeviationFromTarget,
                GoldenBatchValue,
                GoldenBatchDeviation,
                AggregationType,
                SourceSystemType,
                SourceReadingIdMartA,
                SourceReadingIdOps,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                TELEMETRY_KEY           AS TelemetryKey,
                EQUIPMENT_KEY           AS EquipmentKey,
                BATCH_STEP_KEY          AS BatchStepKey,
                PRODUCTION_ORDER_KEY    AS ProductionOrderKey,
                CANONICAL_BATCH_ID      AS CanonicalBatchID,
                PARAMETER_KEY           AS ParameterKey,
                READING_TIMESTAMP_UTC   AS ReadingTimestampUTC,
                CANONICAL_VALUE         AS CanonicalValue,
                CANONICAL_UOM           AS CanonicalUom,
                SOURCE_VALUE            AS SourceValue,
                SOURCE_UOM              AS SourceUom,
                CONVERSION_APPLIED      AS ConversionApplied,
                TARGET_VALUE            AS TargetValue,
                LOWER_SPEC_LIMIT        AS LowerSpecLimit,
                UPPER_SPEC_LIMIT        AS UpperSpecLimit,
                LOWER_ALERT_LIMIT       AS LowerAlertLimit,
                UPPER_ALERT_LIMIT       AS UpperAlertLimit,
                WITHIN_SPECIFICATION    AS WithinSpecification,
                WITHIN_ALERT            AS WithinAlert,
                DEVIATION_FROM_TARGET   AS DeviationFromTarget,
                GOLDEN_BATCH_VALUE      AS GoldenBatchValue,
                GOLDEN_BATCH_DEVIATION  AS GoldenBatchDeviation,
                AGGREGATION_TYPE        AS AggregationType,
                SOURCE_SYSTEM_TYPE      AS SourceSystemType,
                SOURCE_READING_ID_MART_A AS SourceReadingIdMartA,
                SOURCE_READING_ID_OPS   AS SourceReadingIdOps,
                _SOURCE_SYSTEM          AS SourceSystem,
                _SOURCE_KEY             AS SourceKey,
                _LOADED_AT_UTC          AS LoadedAtUTC,
                CREATED_AT              AS CreatedAt,
                CREATED_BY              AS CreatedBy,
                IS_DELETED              AS IsDeleted,
                DELETED_AT              AS DeletedAt
            FROM CANONICAL.FACT_EQUIPMENT_TELEMETRY;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_EQUIPMENT_TELEMETRY completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_EQUIPMENT_TELEMETRY - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_DEVIATION
-- Target table: ANALYTICAL.FACT_DEVIATION
-- Source canonical entity: CANONICAL.FACT_DEVIATION
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_DEVIATION()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_DEVIATION';
    v_target_table        STRING   := 'ANALYTICAL.FACT_DEVIATION';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_DEVIATION;

            INSERT INTO ANALYTICAL.FACT_DEVIATION
            (
                DeviationKey,
                CanonicalDeviationID,
                ProductionOrderKey,
                BatchStepKey,
                TelemetryKey,
                EquipmentKey,
                ParameterKey,
                DeviationCategoryKey,
                FacilityKey,
                CanonicalBatchID,
                DetectedTimestampUTC,
                DetectedByKey,
                DetectionMethod,
                SeverityCode,
                PotentialImpact,
                DeviationDescription,
                InvestigationStatus,
                AssignedToKey,
                InvestigationStartUTC,
                InvestigationEndUTC,
                RootCauseCode,
                RootCauseDescription,
                CapaRequired,
                CapaReferenceID,
                CapaDueDate,
                CapaClosedDate,
                ClosedTimestampUTC,
                ClosedByKey,
                ResolutionSummary,
                RegulatoryNotificationRequired,
                RegulatoryNotifiedDate,
                SourceDevIdMartA,
                SourceDevNumOps,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                DEVIATION_KEY                 AS DeviationKey,
                CANONICAL_DEVIATION_ID       AS CanonicalDeviationID,
                PRODUCTION_ORDER_KEY         AS ProductionOrderKey,
                BATCH_STEP_KEY               AS BatchStepKey,
                TELEMETRY_KEY                AS TelemetryKey,
                EQUIPMENT_KEY                AS EquipmentKey,
                PARAMETER_KEY                AS ParameterKey,
                DEVIATION_CATEGORY_KEY       AS DeviationCategoryKey,
                FACILITY_KEY                 AS FacilityKey,
                CANONICAL_BATCH_ID           AS CanonicalBatchID,
                DETECTED_TIMESTAMP_UTC       AS DetectedTimestampUTC,
                DETECTED_BY_KEY              AS DetectedByKey,
                DETECTION_METHOD             AS DetectionMethod,
                SEVERITY_CODE                AS SeverityCode,
                POTENTIAL_IMPACT             AS PotentialImpact,
                DEVIATION_DESCRIPTION        AS DeviationDescription,
                INVESTIGATION_STATUS         AS InvestigationStatus,
                ASSIGNED_TO_KEY              AS AssignedToKey,
                INVESTIGATION_START_UTC      AS InvestigationStartUTC,
                INVESTIGATION_END_UTC        AS InvestigationEndUTC,
                ROOT_CAUSE_CODE             AS RootCauseCode,
                ROOT_CAUSE_DESCRIPTION      AS RootCauseDescription,
                CAPA_REQUIRED               AS CapaRequired,
                CAPA_REFERENCE_ID           AS CapaReferenceID,
                CAPA_DUE_DATE               AS CapaDueDate,
                CAPA_CLOSED_DATE            AS CapaClosedDate,
                CLOSED_TIMESTAMP_UTC        AS ClosedTimestampUTC,
                CLOSED_BY_KEY               AS ClosedByKey,
                RESOLUTION_SUMMARY          AS ResolutionSummary,
                REGULATORY_NOTIFICATION_REQUIRED AS RegulatoryNotificationRequired,
                REGULATORY_NOTIFIED_DATE    AS RegulatoryNotifiedDate,
                SOURCE_DEV_ID_MART_A        AS SourceDevIdMartA,
                SOURCE_DEV_NUM_OPS          AS SourceDevNumOps,
                _SOURCE_SYSTEM              AS SourceSystem,
                _SOURCE_KEY                 AS SourceKey,
                _LOADED_AT_UTC              AS LoadedAtUTC,
                CREATED_AT                  AS CreatedAt,
                CREATED_BY                  AS CreatedBy,
                UPDATED_AT                  AS UpdatedAt,
                UPDATED_BY                  AS UpdatedBy,
                IS_DELETED                  AS IsDeleted,
                DELETED_AT                  AS DeletedAt
            FROM CANONICAL.FACT_DEVIATION;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_DEVIATION completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_DEVIATION - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_YIELD_ANALYTICS
-- Target table: ANALYTICAL.FACT_YIELD_ANALYTICS
-- Source canonical entity: CANONICAL.FACT_YIELD_ANALYTICS
-- Notes: DateKey is derived from ANALYSIS_DATE as YYYYMMDD integer.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_YIELD_ANALYTICS()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_YIELD_ANALYTICS';
    v_target_table        STRING   := 'ANALYTICAL.FACT_YIELD_ANALYTICS';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_YIELD_ANALYTICS;

            INSERT INTO ANALYTICAL.FACT_YIELD_ANALYTICS
            (
                YieldAnalyticsKey,
                DateKey,
                AnalysisDate,
                FacilityKey,
                ProductKey,
                AggregationLevel,
                BatchesStarted,
                BatchesCompleted,
                BatchesOnHold,
                BatchesFailed,
                AvgYieldPct,
                MinYieldPct,
                MaxYieldPct,
                StdYieldPct,
                YieldBelowTargetCount,
                YieldTargetAttainmentPct,
                TotalPlannedQty,
                TotalActualQty,
                QuantityUom,
                AvgOeePct,
                AvgAvailabilityPct,
                AvgPerformancePct,
                AvgQualityPct,
                TotalDeviations,
                HighCriticalDeviations,
                CppComplianceRatePct,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                YIELD_ANALYTICS_KEY        AS YieldAnalyticsKey,
                TO_NUMBER(TO_CHAR(ANALYSIS_DATE, 'YYYYMMDD')) AS DateKey,
                ANALYSIS_DATE              AS AnalysisDate,
                FACILITY_KEY               AS FacilityKey,
                PRODUCT_KEY                AS ProductKey,
                AGGREGATION_LEVEL          AS AggregationLevel,
                BATCHES_STARTED            AS BatchesStarted,
                BATCHES_COMPLETED          AS BatchesCompleted,
                BATCHES_ON_HOLD            AS BatchesOnHold,
                BATCHES_FAILED             AS BatchesFailed,
                AVG_YIELD_PCT              AS AvgYieldPct,
                MIN_YIELD_PCT              AS MinYieldPct,
                MAX_YIELD_PCT              AS MaxYieldPct,
                STD_YIELD_PCT              AS StdYieldPct,
                YIELD_BELOW_TARGET_COUNT   AS YieldBelowTargetCount,
                YIELD_TARGET_ATTAINMENT_PCT AS YieldTargetAttainmentPct,
                TOTAL_PLANNED_QTY          AS TotalPlannedQty,
                TOTAL_ACTUAL_QTY           AS TotalActualQty,
                QUANTITY_UOM               AS QuantityUom,
                AVG_OEE_PCT                AS AvgOeePct,
                AVG_AVAILABILITY_PCT       AS AvgAvailabilityPct,
                AVG_PERFORMANCE_PCT        AS AvgPerformancePct,
                AVG_QUALITY_PCT            AS AvgQualityPct,
                TOTAL_DEVIATIONS           AS TotalDeviations,
                HIGH_CRITICAL_DEVIATIONS   AS HighCriticalDeviations,
                CPP_COMPLIANCE_RATE_PCT    AS CppComplianceRatePct,
                _SOURCE_SYSTEM             AS SourceSystem,
                _SOURCE_KEY                AS SourceKey,
                _LOADED_AT_UTC             AS LoadedAtUTC,
                CREATED_AT                 AS CreatedAt,
                CREATED_BY                 AS CreatedBy,
                UPDATED_AT                 AS UpdatedAt,
                UPDATED_BY                 AS UpdatedBy,
                IS_DELETED                 AS IsDeleted,
                DELETED_AT                 AS DeletedAt
            FROM CANONICAL.FACT_YIELD_ANALYTICS;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_YIELD_ANALYTICS completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_YIELD_ANALYTICS - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_FACT_SHIFT_LOG
-- Target table: ANALYTICAL.FACT_SHIFT_LOG
-- Source canonical entity: CANONICAL.FACT_SHIFT_LOG
-- Notes: DateKey is derived from LOG_DATE as YYYYMMDD integer.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_FACT_SHIFT_LOG()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_FACT_SHIFT_LOG';
    v_target_table        STRING   := 'ANALYTICAL.FACT_SHIFT_LOG';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.FACT_SHIFT_LOG;

            INSERT INTO ANALYTICAL.FACT_SHIFT_LOG
            (
                ShiftLogKey,
                FacilityKey,
                DateKey,
                LogDate,
                ShiftName,
                ShiftStartUTC,
                ShiftEndUTC,
                SupervisorKey,
                ActiveBatches,
                CompletedBatches,
                NewDeviations,
                ClosedDeviations,
                EquipmentDowntimeMins,
                EquipmentIssuesCount,
                SignedOff,
                SignedOffUTC,
                ShiftNotes,
                SourceLogIdMartA,
                SourceSystem,
                SourceKey,
                LoadedAtUTC,
                CreatedAt,
                CreatedBy,
                UpdatedAt,
                UpdatedBy,
                IsDeleted,
                DeletedAt
            )
            SELECT
                SHIFT_LOG_KEY              AS ShiftLogKey,
                FACILITY_KEY               AS FacilityKey,
                TO_NUMBER(TO_CHAR(LOG_DATE, 'YYYYMMDD')) AS DateKey,
                LOG_DATE                   AS LogDate,
                SHIFT_NAME                 AS ShiftName,
                SHIFT_START_UTC            AS ShiftStartUTC,
                SHIFT_END_UTC              AS ShiftEndUTC,
                SUPERVISOR_KEY             AS SupervisorKey,
                ACTIVE_BATCHES             AS ActiveBatches,
                COMPLETED_BATCHES          AS CompletedBatches,
                NEW_DEVIATIONS             AS NewDeviations,
                CLOSED_DEVIATIONS          AS ClosedDeviations,
                EQUIPMENT_DOWNTIME_MINS    AS EquipmentDowntimeMins,
                EQUIPMENT_ISSUES_COUNT     AS EquipmentIssuesCount,
                SIGNED_OFF                 AS SignedOff,
                SIGNED_OFF_UTC             AS SignedOffUTC,
                SHIFT_NOTES                AS ShiftNotes,
                SOURCE_LOG_ID_MART_A       AS SourceLogIdMartA,
                _SOURCE_SYSTEM             AS SourceSystem,
                _SOURCE_KEY                AS SourceKey,
                _LOADED_AT_UTC             AS LoadedAtUTC,
                CREATED_AT                 AS CreatedAt,
                CREATED_BY                 AS CreatedBy,
                UPDATED_AT                 AS UpdatedAt,
                UPDATED_BY                 AS UpdatedBy,
                IS_DELETED                 AS IsDeleted,
                DELETED_AT                 AS DeletedAt
            FROM CANONICAL.FACT_SHIFT_LOG;

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_FACT_SHIFT_LOG completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_FACT_SHIFT_LOG - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```

```sql
-- ============================================================
-- Procedure: MIGRATE_DIM_DATE
-- Target table: ANALYTICAL.DIM_DATE
-- Source: Derived calendar (no direct canonical entity)
-- Notes: Generates a date dimension for a configurable range.
--        This procedure assumes parameters for start/end dates
--        are configured inside the procedure for simplicity.
-- ============================================================
CREATE OR REPLACE PROCEDURE MIGRATE_DIM_DATE()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_proc_name           STRING   := 'MIGRATE_DIM_DATE';
    v_target_table        STRING   := 'ANALYTICAL.DIM_DATE';
    v_start_ts            TIMESTAMP_TZ;
    v_end_ts              TIMESTAMP_TZ;
    v_rows_inserted       NUMBER   := 0;
    v_rows_updated        NUMBER   := 0;
    v_rows_rejected       NUMBER   := 0;
    v_attempt             NUMBER   := 0;
    v_max_attempts        NUMBER   := 3;
    v_sleep_seconds       NUMBER   := 5;
    v_status              STRING;
    v_error_message       STRING;

    v_date_start          DATE     := DATE '2020-01-01';
    v_date_end            DATE     := DATE '2030-12-31';
BEGIN
    v_start_ts := CURRENT_TIMESTAMP();

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, STATUS)
    VALUES
    (v_proc_name, v_target_table, v_start_ts, 'STARTED');

    WHILE (v_attempt < v_max_attempts) DO
        v_attempt := v_attempt + 1;
        BEGIN
            BEGIN TRANSACTION;

            TRUNCATE TABLE ANALYTICAL.DIM_DATE;

            INSERT INTO ANALYTICAL.DIM_DATE
            (
                DateKey,
                FullDate,
                Day,
                Month,
                MonthName,
                Quarter,
                Year,
                WeekNumber,
                DayOfWeek,
                DayName,
                IsWeekend,
                IsHoliday,
                FiscalYear,
                FiscalQuarter
            )
            SELECT
                TO_NUMBER(TO_CHAR(d, 'YYYYMMDD'))                           AS DateKey,
                d                                                           AS FullDate,
                EXTRACT(DAY    FROM d)                                      AS Day,
                EXTRACT(MONTH  FROM d)                                      AS Month,
                TO_CHAR(d, 'Month')                                         AS MonthName,
                EXTRACT(QUARTER FROM d)                                     AS Quarter,
                EXTRACT(YEAR   FROM d)                                      AS Year,
                TO_NUMBER(TO_CHAR(d, 'IW'))                                 AS WeekNumber,
                EXTRACT(DAYOFWEEK FROM d)                                   AS DayOfWeek,
                TO_CHAR(d, 'DY')                                            AS DayName,
                CASE WHEN EXTRACT(DAYOFWEEK FROM d) IN (6,7) THEN TRUE ELSE FALSE END AS IsWeekend,
                FALSE                                                       AS IsHoliday,
                EXTRACT(YEAR FROM d)                                        AS FiscalYear,
                EXTRACT(QUARTER FROM d)                                     AS FiscalQuarter
            FROM TABLE(GENERATOR(ROWCOUNT => DATEDIFF('day', v_date_start, v_date_end) + 1)) g
            CROSS JOIN LATERAL (
                SELECT v_date_start + g.SEQ4() AS d
            );

            v_rows_inserted := SQLROWCOUNT();

            COMMIT;

            v_status := 'SUCCESS';
            v_error_message := NULL;
            EXIT;

        EXCEPTION
            WHEN OTHER THEN
                v_error_message := SQLERRM;
                v_status := 'RETRY_' || v_attempt || '_FAILED';
                ROLLBACK;
                CALL SYSTEM$SLEEP(v_sleep_seconds);
        END;
    END WHILE;

    v_end_ts := CURRENT_TIMESTAMP();

    IF v_status != 'SUCCESS' THEN
        v_status := 'FAILED';
    END IF;

    INSERT INTO ANALYTICAL.AUDIT_LOG
    (PROC_NAME, TARGET_TABLE, LOAD_START_TS, LOAD_END_TS,
     ROWS_INSERTED, ROWS_UPDATED, ROWS_REJECTED, STATUS, ERROR_MESSAGE)
    VALUES
    (
        v_proc_name,
        v_target_table,
        v_start_ts,
        v_end_ts,
        v_rows_inserted,
        v_rows_updated,
        v_rows_rejected,
        v_status,
        v_error_message
    );

    IF v_status = 'SUCCESS' THEN
        RETURN 'SUCCESS: MIGRATE_DIM_DATE completed. Rows inserted=' || v_rows_inserted;
    ELSE
        RETURN 'FAILURE: MIGRATE_DIM_DATE - ' || COALESCE(v_error_message, 'Unknown error');
    END IF;

END;
$$;
```
