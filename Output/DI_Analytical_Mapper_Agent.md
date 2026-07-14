### Section 1 — Modeling Summary

| Metric | Detail |
|----------------------------|-----------------------------------------------|
| Central Business Process | Batch Production & Execution |
| Fact Table(s) | FactProductionOrder, FactBatchStep, FactEquipmentTelemetry, FactDeviation, FactYieldAnalytics, FactShiftLog |
| Dimension Tables | DimOrganization, DimFacility, DimProduct, DimMaterialLot, DimEquipment, DimProcessStep, DimProcessParameter, DimQualityDisposition, DimDeviationCategory, DimOperator, DimDate |
| Total Fact Measures | 41 |
| Total Dimension Attributes | 129 |
| SCD Type 2 Dimensions | DimFacility (Type 2), DimProduct (Type 2) |
| PII-masked Columns | 0 |

---

### Section 2 — Star Schema Definition

#### Dimension Table: DimOrganization

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OrganizationKey | INTEGER | Primary Key | Surrogate key |
| OrganizationID | VARCHAR(50) | Natural Key | Canonical ORGANIZATION_ID |
| OrganizationName | VARCHAR(200) | Attribute | Canonical ORGANIZATION_NAME |
| OrganizationType | VARCHAR(80) | Attribute | Canonical ORGANIZATION_TYPE |
| ParentOrganizationKey | INTEGER | Foreign Key | Self-referencing organization hierarchy |
| CountryCode | CHAR(2) | Attribute | Canonical COUNTRY_CODE |
| RegulatoryRegion | VARCHAR(80) | Attribute | Canonical REGULATORY_REGION |
| IsActive | BOOLEAN | Attribute | Canonical IS_ACTIVE |
| EffectiveStartDate | DATE | SCD Type 2 | Canonical EFFECTIVE_START_DATE |
| EffectiveEndDate | DATE | SCD Type 2 | Canonical EFFECTIVE_END_DATE |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimFacility

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| FacilityKey | INTEGER | Primary Key | Surrogate key |
| FacilityID | VARCHAR(50) | Natural Key | Canonical FACILITY_ID |
| FacilityName | VARCHAR(200) | Attribute | Canonical FACILITY_NAME |
| FacilityShortName | VARCHAR(80) | Attribute | Canonical FACILITY_SHORT_NAME |
| OrganizationKey | INTEGER | Foreign Key → DimOrganization | Canonical ORGANIZATION_KEY |
| SiteCode | VARCHAR(20) | Attribute | Canonical SITE_CODE |
| FacilityType | VARCHAR(80) | Attribute | Canonical FACILITY_TYPE |
| AddressLine1 | VARCHAR(200) | Attribute | Canonical ADDRESS_LINE_1 |
| AddressLine2 | VARCHAR(200) | Attribute | Canonical ADDRESS_LINE_2 |
| City | VARCHAR(100) | Attribute | Canonical CITY |
| StateRegion | VARCHAR(100) | Attribute | Canonical STATE_REGION |
| PostalCode | VARCHAR(20) | Attribute | Canonical POSTAL_CODE |
| CountryCode | CHAR(2) | Attribute | Canonical COUNTRY_CODE |
| TimezoneName | VARCHAR(80) | Attribute | Canonical TIMEZONE_NAME |
| UtcOffsetHours | DECIMAL(4,2) | Attribute | Canonical UTC_OFFSET_HOURS |
| GmpCertified | BOOLEAN | Attribute | Canonical GMP_CERTIFIED |
| GmpCertificationDate | DATE | Attribute | Canonical GMP_CERTIFICATION_DATE |
| GmpExpiryDate | DATE | Attribute | Canonical GMP_EXPIRY_DATE |
| RegulatoryAgency | VARCHAR(80) | Attribute | Canonical REGULATORY_AGENCY |
| FdaEstablishmentId | VARCHAR(50) | Attribute | Canonical FDA_ESTABLISHMENT_ID |
| EmaSiteCode | VARCHAR(50) | Attribute | Canonical EMA_SITE_CODE |
| ManufacturingCapacity | VARCHAR(80) | Attribute | Canonical MANUFACTURING_CAPACITY |
| SourceSiteCodeMartA | VARCHAR(20) | Attribute | Canonical SOURCE_SITE_CODE_MART_A |
| SourcePlantCodeOps | VARCHAR(30) | Attribute | Canonical SOURCE_PLANT_CODE_OPS |
| SourceFacCodeMartB | VARCHAR(30) | Attribute | Canonical SOURCE_FAC_CODE_MART_B |
| EffectiveStartDate | DATE | SCD Type 2 | Canonical EFFECTIVE_START_DATE |
| EffectiveEndDate | DATE | SCD Type 2 | Canonical EFFECTIVE_END_DATE |
| CurrentFlag | BOOLEAN | SCD Type 2 | Canonical CURRENT_FLAG |
| ScdVersion | NUMBER | SCD Type 2 | Canonical SCD_VERSION |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimProduct

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProductKey | INTEGER | Primary Key | Surrogate key |
| ProductID | VARCHAR(50) | Natural Key | Canonical PRODUCT_ID |
| Sku | VARCHAR(60) | Attribute | Canonical SKU |
| ProductName | VARCHAR(200) | Attribute | Canonical PRODUCT_NAME |
| ProductShortName | VARCHAR(80) | Attribute | Canonical PRODUCT_SHORT_NAME |
| OrganizationKey | INTEGER | Foreign Key → DimOrganization | Canonical ORGANIZATION_KEY |
| FormulationId | VARCHAR(60) | Attribute | Canonical FORMULATION_ID |
| FormulationVersion | VARCHAR(20) | Attribute | Canonical FORMULATION_VERSION |
| DosageForm | VARCHAR(80) | Attribute | Canonical DOSAGE_FORM |
| DosageStrength | VARCHAR(80) | Attribute | Canonical DOSAGE_STRENGTH |
| RouteOfAdministration | VARCHAR(80) | Attribute | Canonical ROUTE_OF_ADMINISTRATION |
| TherapeuticClass | VARCHAR(100) | Attribute | Canonical THERAPEUTIC_CLASS |
| TherapeuticArea | VARCHAR(100) | Attribute | Canonical THERAPEUTIC_AREA |
| ProductCategory | VARCHAR(80) | Attribute | Canonical PRODUCT_CATEGORY |
| IsBiosimilar | BOOLEAN | Attribute | Canonical IS_BIOSIMILAR |
| ReferenceProductId | VARCHAR(50) | Attribute | Canonical REFERENCE_PRODUCT_ID |
| InnName | VARCHAR(200) | Attribute | Canonical INN_NAME |
| IdmpMpid | VARCHAR(100) | Attribute | Canonical IDMP_MPID |
| NdaBlaNumber | VARCHAR(50) | Attribute | Canonical NDA_BLA_NUMBER |
| EmaProductNumber | VARCHAR(50) | Attribute | Canonical EMA_PRODUCT_NUMBER |
| StandardYieldPct | DECIMAL(6,3) | Attribute | Canonical STANDARD_YIELD_PCT |
| YieldLowerAlertPct | DECIMAL(6,3) | Attribute | Canonical YIELD_LOWER_ALERT_PCT |
| YieldLowerActionPct | DECIMAL(6,3) | Attribute | Canonical YIELD_LOWER_ACTION_PCT |
| ShelfLifeMonths | NUMBER | Attribute | Canonical SHELF_LIFE_MONTHS |
| StorageCondition | VARCHAR(80) | Attribute | Canonical STORAGE_CONDITION |
| EffectiveStartDate | DATE | SCD Type 2 | Canonical EFFECTIVE_START_DATE |
| EffectiveEndDate | DATE | SCD Type 2 | Canonical EFFECTIVE_END_DATE |
| CurrentFlag | BOOLEAN | SCD Type 2 | Canonical CURRENT_FLAG |
| ScdVersion | NUMBER | SCD Type 2 | Canonical SCD_VERSION |
| SourceProductCodeMartA | VARCHAR(50) | Attribute | Canonical SOURCE_PRODUCT_CODE_MART_A |
| SourceProductCodeOps | VARCHAR(50) | Attribute | Canonical SOURCE_PRODUCT_CODE_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | CanonICAL _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimMaterialLot

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| MaterialLotKey | INTEGER | Primary Key | Surrogate key |
| LotNumber | VARCHAR(80) | Natural Key | Canonical LOT_NUMBER |
| ProductKey | INTEGER | Foreign Key → DimProduct | Canonical PRODUCT_KEY |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| LotType | VARCHAR(50) | Attribute | Canonical LOT_TYPE |
| ManufactureDate | DATE | Attribute | Canonical MANUFACTURE_DATE |
| ExpiryDate | DATE | Attribute | Canonical EXPIRY_DATE |
| RetestDate | DATE | Attribute | Canonical RETEST_DATE |
| QuantityProduced | DECIMAL(18,3) | Attribute | Canonical QUANTITY_PRODUCED |
| QuantityUnit | VARCHAR(20) | Attribute | Canonical QUANTITY_UNIT |
| LotStatus | VARCHAR(40) | Attribute | Canonical LOT_STATUS |
| CertificateOfAnalysis | VARCHAR(200) | Attribute | Canonical CERTIFICATE_OF_ANALYSIS |
| VendorLotNumber | VARCHAR(80) | Attribute | Canonical VENDOR_LOT_NUMBER |
| VendorId | VARCHAR(80) | Attribute | Canonical VENDOR_ID |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimEquipment

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| EquipmentKey | INTEGER | Primary Key | Surrogate key |
| CanonicalEquipmentID | VARCHAR(50) | Natural Key | Canonical CANONICAL_EQUIPMENT_ID |
| EquipmentName | VARCHAR(200) | Attribute | Canonical EQUIPMENT_NAME |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| FunctionalArea | VARCHAR(80) | Attribute | Canonical FUNCTIONAL_AREA |
| ProductionUnit | VARCHAR(80) | Attribute | Canonical PRODUCTION_UNIT |
| EquipmentModule | VARCHAR(80) | Attribute | Canonical EQUIPMENT_MODULE |
| AssetClass | VARCHAR(80) | Attribute | Canonical ASSET_CLASS |
| AssetSubClass | VARCHAR(80) | Attribute | Canonical ASSET_SUBCLASS |
| CriticalityRating | VARCHAR(20) | Attribute | Canonical CRITICALITY_RATING |
| ManufacturerName | VARCHAR(100) | Attribute | Canonical MANUFACTURER_NAME |
| ModelNumber | VARCHAR(100) | Attribute | Canonical MODEL_NUMBER |
| SerialNumber | VARCHAR(100) | Attribute | Canonical SERIAL_NUMBER |
| WorkingVolumeL | DECIMAL(12,3) | Attribute | Canonical WORKING_VOLUME_L |
| InstallationDate | DATE | Attribute | Canonical INSTALLATION_DATE |
| CommissioningDate | DATE | Attribute | Canonical COMMISSIONING_DATE |
| QualificationStatus | VARCHAR(30) | Attribute | Canonical QUALIFICATION_STATUS |
| LastQualificationDate | DATE | Attribute | Canonical LAST_QUALIFICATION_DATE |
| NextQualificationDate | DATE | Attribute | Canonical NEXT_QUALIFICATION_DATE |
| CalibrationFrequency | VARCHAR(30) | Attribute | Canonical CALIBRATION_FREQUENCY |
| LastCalibrationDate | DATE | Attribute | Canonical LAST_CALIBRATION_DATE |
| CalibrationDueDate | DATE | Attribute | Canonical CALIBRATION_DUE_DATE |
| CalibrationStatus | VARCHAR(30) | Attribute | Canonical CALIBRATION_STATUS |
| PlannedRuntimeMinsPerDay | NUMBER | Attribute | Canonical PLANNED_RUNTIME_MINS_PER_DAY |
| IdealCycleTimeSecs | DECIMAL(12,4) | Attribute | Canonical IDEAL_CYCLE_TIME_SECS |
| EquipmentStatus | VARCHAR(30) | Attribute | Canonical EQUIPMENT_STATUS |
| StatusEffectiveDate | DATE | Attribute | Canonical STATUS_EFFECTIVE_DATE |
| DecommissionDate | DATE | Attribute | Canonical DECOMMISSION_DATE |
| SourceEquipIdMartA | VARCHAR(50) | Attribute | Canonical SOURCE_EQUIP_ID_MART_A |
| SourceAssetCodeOps | VARCHAR(50) | Attribute | Canonical SOURCE_ASSET_CODE_OPS |
| SourceEquipCodeMartB | VARCHAR(50) | Attribute | Canonical SOURCE_EQUIP_CODE_MART_B |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimProcessStep

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessStepKey | INTEGER | Primary Key | Surrogate key |
| StepCode | VARCHAR(40) | Natural Key | Canonical STEP_CODE |
| StepName | VARCHAR(100) | Attribute | Canonical STEP_NAME |
| StepCategory | VARCHAR(60) | Attribute | Canonical STEP_CATEGORY |
| StepSubCategory | VARCHAR(60) | Attribute | Canonical STEP_SUBCATEGORY |
| TypicalSequenceOrder | NUMBER | Attribute | Canonical TYPICAL_SEQUENCE_ORDER |
| ExpectedDurationMinHrs | DECIMAL(8,2) | Attribute | Canonical EXPECTED_DURATION_MIN_HRS |
| ExpectedDurationMaxHrs | DECIMAL(8,2) | Attribute | Canonical EXPECTED_DURATION_MAX_HRS |
| ApplicableAssetClasses | VARCHAR(200) | Attribute | Canonical APPLICABLE_ASSET_CLASSES |
| IsCcp | BOOLEAN | Attribute | Canonical IS_CCP |
| IsActive | BOOLEAN | Attribute | Canonical IS_ACTIVE |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimProcessParameter

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ParameterKey | INTEGER | Primary Key | Surrogate key |
| ParameterCode | VARCHAR(60) | Natural Key | Canonical PARAMETER_CODE |
| ParameterName | VARCHAR(150) | Attribute | Canonical PARAMETER_NAME |
| ParameterCategory | VARCHAR(60) | Attribute | Canonical PARAMETER_CATEGORY |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical CANONICAL_UOM |
| SourceUomMartA | VARCHAR(30) | Attribute | Canonical SOURCE_UOM_MART_A |
| SourceUomOps | VARCHAR(30) | Attribute | Canonical SOURCE_UOM_OPS |
| SourceUomMartB | VARCHAR(30) | Attribute | Canonical SOURCE_UOM_MART_B |
| ConversionFormulaOps | VARCHAR(200) | Attribute | Canonical CONVERSION_FORMULA_OPS |
| IsCpp | BOOLEAN | Attribute | Canonical IS_CPP |
| IsKpa | BOOLEAN | Attribute | Canonical IS_KPA |
| TypicalTarget | DECIMAL(18,4) | Attribute | Canonical TYPICAL_TARGET |
| TypicalLsl | DECIMAL(18,4) | Attribute | Canonical TYPICAL_LSL |
| TypicalUsl | DECIMAL(18,4) | Attribute | Canonical TYPICAL_USL |
| MeasurementFrequency | VARCHAR(50) | Attribute | Canonical MEASUREMENT_FREQUENCY |
| InstrumentType | VARCHAR(100) | Attribute | Canonical INSTRUMENT_TYPE |
| IsActive | BOOLEAN | Attribute | Canonical IS_ACTIVE |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimQualityDisposition

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DispositionKey | INTEGER | Primary Key | Surrogate key |
| DispositionCode | VARCHAR(40) | Natural Key | Canonical DISPOSITION_CODE |
| DispositionName | VARCHAR(100) | Attribute | Canonical DISPOSITION_NAME |
| RequiresInvestigation | BOOLEAN | Attribute | Canonical REQUIRES_INVESTIGATION |
| CommerciallyReleasable | BOOLEAN | Attribute | Canonical COMMERCIALLY_RELEASABLE |
| DeviationImplied | BOOLEAN | Attribute | Canonical DEVIATION_IMPLIED |
| PatientRiskLevel | VARCHAR(20) | Attribute | Canonical PATIENT_RISK_LEVEL |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Canonical REGULATORY_NOTIFICATION_REQUIRED |
| DispositionDescription | VARCHAR(500) | Attribute | Canonical DISPOSITION_DESCRIPTION |
| IsActive | BOOLEAN | Attribute | Canonical IS_ACTIVE |
| SourceCodeMartA | VARCHAR(40) | Attribute | Canonical SOURCE_CODE_MART_A |
| SourceCodeMartB | VARCHAR(40) | Attribute | Canonical SOURCE_CODE_MART_B |
| SourceCodeOps | VARCHAR(10) | Attribute | Canonical SOURCE_CODE_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimDeviationCategory

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DeviationCategoryKey | INTEGER | Primary Key | Surrogate key |
| CategoryCode | VARCHAR(50) | Natural Key | Canonical CATEGORY_CODE |
| CategoryName | VARCHAR(100) | Attribute | Canonical CATEGORY_NAME |
| CategoryGroup | VARCHAR(80) | Attribute | Canonical CATEGORY_GROUP |
| Description | VARCHAR(500) | Attribute | Canonical DESCRIPTION |
| CapaTypicallyRequired | BOOLEAN | Attribute | Canonical CAPA_TYPICALLY_REQUIRED |
| IsActive | BOOLEAN | Attribute | Canonical IS_ACTIVE |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimOperator

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OperatorKey | INTEGER | Primary Key | Surrogate key |
| OperatorID | VARCHAR(50) | Natural Key | Canonical OPERATOR_ID |
| FullName | VARCHAR(200) | Attribute | Canonical FULL_NAME |
| RoleCode | VARCHAR(50) | Attribute | Canonical ROLE_CODE |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| Department | VARCHAR(100) | Attribute | Canonical DEPARTMENT |
| IsGmpTrained | BOOLEAN | Attribute | Canonical IS_GMP_TRAINED |
| TrainingExpiryDate | DATE | Attribute | Canonical TRAINING_EXPIRY_DATE |
| EsignatureEnabled | BOOLEAN | Attribute | Canonical ESIGNATURE_ENABLED |
| EmploymentStatus | VARCHAR(30) | Attribute | Canonical EMPLOYMENT_STATUS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DimDate

| Column Name | Data Type | Role | Description |
|--------------|--------------|-------------|----------------------|
| DateKey | INTEGER | Primary Key | Surrogate (YYYYMMDD) |
| FullDate | DATE | Attribute | Calendar date |
| Day | INTEGER | Attribute | Day of month |
| Month | INTEGER | Attribute | Month number |
| MonthName | VARCHAR(20) | Attribute | Month name |
| Quarter | INTEGER | Attribute | Quarter number |
| Year | INTEGER | Attribute | Calendar year |
| WeekNumber | INTEGER | Attribute | ISO week number |
| DayOfWeek | INTEGER | Attribute | Day of week (1–7) |
| DayName | VARCHAR(20) | Attribute | Day name |
| IsWeekend | BOOLEAN | Attribute | Weekend flag |
| IsHoliday | BOOLEAN | Attribute | Holiday flag |
| FiscalYear | INTEGER | Attribute | Fiscal year |
| FiscalQuarter | INTEGER | Attribute | Fiscal quarter |

---

#### Fact Table: FactProductionOrder

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ProductionOrderKey | INTEGER | Primary Key | Surrogate key |
| CanonicalBatchID | VARCHAR(50) | Business Key | Canonical CANONICAL_BATCH_ID |
| ErpOrderNumber | VARCHAR(50) | Attribute | Canonical ERP_ORDER_NUMBER |
| MesBatchReference | VARCHAR(80) | Attribute | Canonical MES_BATCH_REFERENCE |
| GmpLotNumber | VARCHAR(80) | Attribute | Canonical GMP_LOT_NUMBER |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| ProductKey | INTEGER | Foreign Key → DimProduct | Canonical PRODUCT_KEY |
| PrimaryEquipmentKey | INTEGER | Foreign Key → DimEquipment | Canonical PRIMARY_EQUIPMENT_KEY |
| DispositionKey | INTEGER | Foreign Key → DimQualityDisposition | Canonical DISPOSITION_KEY |
| PlannedStartUTC | TIMESTAMP_TZ | Attribute | Canonical PLANNED_START_UTC |
| PlannedEndUTC | TIMESTAMP_TZ | Attribute | Canonical PLANNED_END_UTC |
| PlannedQuantity | DECIMAL(18,3) | Measure (Additive) | Canonical PLANNED_QUANTITY |
| QuantityUom | VARCHAR(20) | Attribute | Canonical QUANTITY_UOM |
| ActualStartUTC | TIMESTAMP_TZ | Attribute | Canonical ACTUAL_START_UTC |
| ActualEndUTC | TIMESTAMP_TZ | Attribute | Canonical ACTUAL_END_UTC |
| ActualQuantity | DECIMAL(18,3) | Measure (Additive) | Canonical ACTUAL_QUANTITY |
| YieldPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical YIELD_PCT |
| YieldVariancePct | DECIMAL(8,4) | Measure (Non-additive) | Canonical YIELD_VARIANCE_PCT |
| OeeAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical OEE_AVAILABILITY_PCT |
| OeePerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Canonical OEE_PERFORMANCE_PCT |
| OeeQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical OEE_QUALITY_PCT |
| OeeOverallPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical OEE_OVERALL_PCT |
| BatchStatus | VARCHAR(30) | Attribute | Canonical BATCH_STATUS |
| DeviationCount | NUMBER | Measure (Additive) | Canonical DEVIATION_COUNT |
| IsGoldenBatch | BOOLEAN | Attribute | Canonical IS_GOLDEN_BATCH |
| GoldenBatchReference | VARCHAR(50) | Attribute | Canonical GOLDEN_BATCH_REFERENCE |
| ShiftAtStart | VARCHAR(20) | Attribute | Canonical SHIFT_AT_START |
| ShiftSupervisorKey | INTEGER | Foreign Key → DimOperator | Canonical SHIFT_SUPERVISOR_KEY |
| SourceBatchIdMartA | VARCHAR(50) | Attribute | Canonical SOURCE_BATCH_ID_MART_A |
| SourceBatchIdOps | VARCHAR(50) | Attribute | Canonical SOURCE_BATCH_ID_OPS |
| SourceOrderNumOps | VARCHAR(50) | Attribute | Canonical SOURCE_ORDER_NUM_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FactBatchStep

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| BatchStepKey | INTEGER | Primary Key | Surrogate key |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Canonical PRODUCTION_ORDER_KEY |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical CANONICAL_BATCH_ID |
| ProcessStepKey | INTEGER | Foreign Key → DimProcessStep | Canonical PROCESS_STEP_KEY |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Canonical EQUIPMENT_KEY |
| StepSequence | NUMBER | Attribute | Canonical STEP_SEQUENCE |
| StepStartUTC | TIMESTAMP_TZ | Attribute | Canonical STEP_START_UTC |
| StepEndUTC | TIMESTAMP_TZ | Attribute | Canonical STEP_END_UTC |
| StepDurationHrs | DECIMAL(10,4) | Measure (Non-additive) | Canonical STEP_DURATION_HRS |
| InputQuantity | DECIMAL(18,3) | Measure (Additive) | Canonical INPUT_QUANTITY |
| OutputQuantity | DECIMAL(18,3) | Measure (Additive) | Canonical OUTPUT_QUANTITY |
| QuantityUom | VARCHAR(20) | Attribute | Canonical QUANTITY_UOM |
| StepYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical STEP_YIELD_PCT |
| StepStatus | VARCHAR(30) | Attribute | Canonical STEP_STATUS |
| OperatorKey | INTEGER | Foreign Key → DimOperator | Canonical OPERATOR_KEY |
| VerifierKey | INTEGER | Foreign Key → DimOperator | Canonical VERIFIER_KEY |
| EsignatureTimestampUTC | TIMESTAMP_TZ | Attribute | Canonical ESIGNATURE_TIMESTAMP_UTC |
| EsignatureMeaning | VARCHAR(200) | Attribute | Canonical ESIGNATURE_MEANING |
| HasDeviation | BOOLEAN | Attribute | Canonical HAS_DEVIATION |
| DeviationCount | NUMBER | Measure (Additive) | Canonical DEVIATION_COUNT |
| StepNotes | VARCHAR(2000) | Attribute | Canonical STEP_NOTES |
| SourceRunIdMartA | VARCHAR(50) | Attribute | Canonical SOURCE_RUN_ID_MART_A |
| SourceStepIdOps | NUMBER | Attribute | Canonical SOURCE_STEP_ID_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FactEquipmentTelemetry

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| TelemetryKey | INTEGER | Primary Key | Surrogate key |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Canonical EQUIPMENT_KEY |
| BatchStepKey | INTEGER | Foreign Key → FactBatchStep | Canonical BATCH_STEP_KEY |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Canonical PRODUCTION_ORDER_KEY |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical CANONICAL_BATCH_ID |
| ParameterKey | INTEGER | Foreign Key → DimProcessParameter | Canonical PARAMETER_KEY |
| ReadingTimestampUTC | TIMESTAMP_TZ | Attribute | Canonical READING_TIMESTAMP_UTC |
| CanonicalValue | DECIMAL(18,4) | Measure (Additive) | Canonical CANONICAL_VALUE |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical CANONICAL_UOM |
| SourceValue | DECIMAL(18,4) | Measure (Additive) | Canonical SOURCE_VALUE |
| SourceUom | VARCHAR(30) | Attribute | Canonical SOURCE_UOM |
| ConversionApplied | VARCHAR(200) | Attribute | Canonical CONVERSION_APPLIED |
| TargetValue | DECIMAL(18,4) | Measure (Non-additive) | Canonical TARGET_VALUE |
| LowerSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Canonical LOWER_SPEC_LIMIT |
| UpperSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Canonical UPPER_SPEC_LIMIT |
| LowerAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Canonical LOWER_ALERT_LIMIT |
| UpperAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Canonical UPPER_ALERT_LIMIT |
| WithinSpecification | BOOLEAN | Attribute | Canonical WITHIN_SPECIFICATION |
| WithinAlert | BOOLEAN | Attribute | Canonical WITHIN_ALERT |
| DeviationFromTarget | DECIMAL(18,4) | Measure (Non-additive) | Canonical DEVIATION_FROM_TARGET |
| GoldenBatchValue | DECIMAL(18,4) | Measure (Non-additive) | Canonical GOLDEN_BATCH_VALUE |
| GoldenBatchDeviation | DECIMAL(18,4) | Measure (Non-additive) | Canonical GOLDEN_BATCH_DEVIATION |
| AggregationType | VARCHAR(30) | Attribute | Canonical AGGREGATION_TYPE |
| SourceSystemType | VARCHAR(30) | Attribute | Canonical SOURCE_SYSTEM_TYPE |
| SourceReadingIdMartA | VARCHAR(60) | Attribute | Canonical SOURCE_READING_ID_MART_A |
| SourceReadingIdOps | NUMBER | Attribute | Canonical SOURCE_READING_ID_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FactDeviation

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| DeviationKey | INTEGER | Primary Key | Surrogate key |
| CanonicalDeviationID | VARCHAR(60) | Business Key | Canonical CANONICAL_DEVIATION_ID |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Canonical PRODUCTION_ORDER_KEY |
| BatchStepKey | INTEGER | Foreign Key → FactBatchStep | Canonical BATCH_STEP_KEY |
| TelemetryKey | INTEGER | Foreign Key → FactEquipmentTelemetry | Canonical TELEMETRY_KEY |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Canonical EQUIPMENT_KEY |
| ParameterKey | INTEGER | Foreign Key → DimProcessParameter | Canonical PARAMETER_KEY |
| DeviationCategoryKey | INTEGER | Foreign Key → DimDeviationCategory | Canonical DEVIATION_CATEGORY_KEY |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical CANONICAL_BATCH_ID |
| DetectedTimestampUTC | TIMESTAMP_TZ | Attribute | Canonical DETECTED_TIMESTAMP_UTC |
| DetectedByKey | INTEGER | Foreign Key → DimOperator | Canonical DETECTED_BY_KEY |
| DetectionMethod | VARCHAR(80) | Attribute | Canonical DETECTION_METHOD |
| SeverityCode | VARCHAR(20) | Attribute | Canonical SEVERITY_CODE |
| PotentialImpact | VARCHAR(200) | Attribute | Canonical POTENTIAL_IMPACT |
| DeviationDescription | VARCHAR(4000) | Attribute | Canonical DEVIATION_DESCRIPTION |
| InvestigationStatus | VARCHAR(30) | Attribute | Canonical INVESTIGATION_STATUS |
| AssignedToKey | INTEGER | Foreign Key → DimOperator | Canonical ASSIGNED_TO_KEY |
| InvestigationStartUTC | TIMESTAMP_TZ | Attribute | Canonical INVESTIGATION_START_UTC |
| InvestigationEndUTC | TIMESTAMP_TZ | Attribute | Canonical INVESTIGATION_END_UTC |
| RootCauseCode | VARCHAR(80) | Attribute | Canonical ROOT_CAUSE_CODE |
| RootCauseDescription | VARCHAR(2000) | Attribute | Canonical ROOT_CAUSE_DESCRIPTION |
| CapaRequired | BOOLEAN | Attribute | Canonical CAPA_REQUIRED |
| CapaReferenceID | VARCHAR(60) | Attribute | Canonical CAPA_REFERENCE_ID |
| CapaDueDate | DATE | Attribute | Canonical CAPA_DUE_DATE |
| CapaClosedDate | DATE | Attribute | Canonical CAPA_CLOSED_DATE |
| ClosedTimestampUTC | TIMESTAMP_TZ | Attribute | Canonical CLOSED_TIMESTAMP_UTC |
| ClosedByKey | INTEGER | Foreign Key → DimOperator | Canonical CLOSED_BY_KEY |
| ResolutionSummary | VARCHAR(4000) | Attribute | Canonical RESOLUTION_SUMMARY |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Canonical REGULATORY_NOTIFICATION_REQUIRED |
| RegulatoryNotifiedDate | DATE | Attribute | Canonical REGULATORY_NOTIFIED_DATE |
| SourceDevIdMartA | VARCHAR(50) | Attribute | Canonical SOURCE_DEV_ID_MART_A |
| SourceDevNumOps | VARCHAR(50) | Attribute | Canonical SOURCE_DEV_NUM_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FactYieldAnalytics

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| YieldAnalyticsKey | INTEGER | Primary Key | Surrogate key |
| DateKey | INTEGER | Foreign Key → DimDate | Derived from ANALYSIS_DATE |
| AnalysisDate | DATE | Attribute | Canonical ANALYSIS_DATE |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| ProductKey | INTEGER | Foreign Key → DimProduct | Canonical PRODUCT_KEY |
| AggregationLevel | VARCHAR(30) | Attribute | Canonical AGGREGATION_LEVEL |
| BatchesStarted | NUMBER | Measure (Additive) | Canonical BATCHES_STARTED |
| BatchesCompleted | NUMBER | Measure (Additive) | Canonical BATCHES_COMPLETED |
| BatchesOnHold | NUMBER | Measure (Additive) | Canonical BATCHES_ON_HOLD |
| BatchesFailed | NUMBER | Measure (Additive) | Canonical BATCHES_FAILED |
| AvgYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical AVG_YIELD_PCT |
| MinYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical MIN_YIELD_PCT |
| MaxYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical MAX_YIELD_PCT |
| StdYieldPct | DECIMAL(8,4) | Measure (Non-additive) | Canonical STD_YIELD_PCT |
| YieldBelowTargetCount | NUMBER | Measure (Additive) | Canonical YIELD_BELOW_TARGET_COUNT |
| YieldTargetAttainmentPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical YIELD_TARGET_ATTAINMENT_PCT |
| TotalPlannedQty | DECIMAL(18,3) | Measure (Additive) | Canonical TOTAL_PLANNED_QTY |
| TotalActualQty | DECIMAL(18,3) | Measure (Additive) | Canonical TOTAL_ACTUAL_QTY |
| QuantityUom | VARCHAR(20) | Attribute | Canonical QUANTITY_UOM |
| AvgOeePct | DECIMAL(6,3) | Measure (Non-additive) | Canonical AVG_OEE_PCT |
| AvgAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical AVG_AVAILABILITY_PCT |
| AvgPerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Canonical AVG_PERFORMANCE_PCT |
| AvgQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Canonical AVG_QUALITY_PCT |
| TotalDeviations | NUMBER | Measure (Additive) | Canonical TOTAL_DEVIATIONS |
| HighCriticalDeviations | NUMBER | Measure (Additive) | Canonical HIGH_CRITICAL_DEVIATIONS |
| CppComplianceRatePct | DECIMAL(6,3) | Measure (Non-additive) | Canonical CPP_COMPLIANCE_RATE_PCT |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FactShiftLog

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ShiftLogKey | INTEGER | Primary Key | Surrogate key |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Canonical FACILITY_KEY |
| DateKey | INTEGER | Foreign Key → DimDate | Derived from LOG_DATE |
| LogDate | DATE | Attribute | Canonical LOG_DATE |
| ShiftName | VARCHAR(20) | Attribute | Canonical SHIFT_NAME |
| ShiftStartUTC | TIMESTAMP_TZ | Attribute | Canonical SHIFT_START_UTC |
| ShiftEndUTC | TIMESTAMP_TZ | Attribute | Canonical SHIFT_END_UTC |
| SupervisorKey | INTEGER | Foreign Key → DimOperator | Canonical SUPERVISOR_KEY |
| ActiveBatches | NUMBER | Measure (Additive) | Canonical ACTIVE_BATCHES |
| CompletedBatches | NUMBER | Measure (Additive) | Canonical COMPLETED_BATCHES |
| NewDeviations | NUMBER | Measure (Additive) | Canonical NEW_DEVIATIONS |
| ClosedDeviations | NUMBER | Measure (Additive) | Canonical CLOSED_DEVIATIONS |
| EquipmentDowntimeMins | NUMBER | Measure (Additive) | Canonical EQUIPMENT_DOWNTIME_MINS |
| EquipmentIssuesCount | NUMBER | Measure (Additive) | Canonical EQUIPMENT_ISSUES_COUNT |
| SignedOff | BOOLEAN | Attribute | Canonical SIGNED_OFF |
| SignedOffUTC | TIMESTAMP_TZ | Attribute | Canonical SIGNED_OFF_UTC |
| ShiftNotes | VARCHAR(4000) | Attribute | Canonical SHIFT_NOTES |
| SourceLogIdMartA | NUMBER | Attribute | Canonical SOURCE_LOG_ID_MART_A |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUTC | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

---

### Section 3 — Canonical to Star Mapping Table

| Star Table Name | Star Column Name | Canonical Entity | Canonical Attribute | Mapping Rule | Measure Type | SCD Type | PII |
|---|---|---|---|---|---|---|---|
| DimOrganization | OrganizationKey | DIM_ORGANIZATION | ORGANIZATION_KEY | Surrogate Key (system-generated INTEGER; retain canonical key only for lineage) | — | — | — |
| DimOrganization | OrganizationID | DIM_ORGANIZATION | ORGANIZATION_ID | Direct | — | — | — |
| DimOrganization | OrganizationName | DIM_ORGANIZATION | ORGANIZATION_NAME | Direct | — | — | — |
| DimOrganization | OrganizationType | DIM_ORGANIZATION | ORGANIZATION_TYPE | Direct | — | — | — |
| DimOrganization | ParentOrganizationKey | DIM_ORGANIZATION | PARENT_ORGANIZATION_KEY | Direct; FK to DimOrganization.OrganizationKey | — | — | — |
| DimOrganization | CountryCode | DIM_ORGANIZATION | COUNTRY_CODE | Direct | — | — | — |
| DimOrganization | RegulatoryRegion | DIM_ORGANIZATION | REGULATORY_REGION | Direct | — | — | — |
| DimOrganization | IsActive | DIM_ORGANIZATION | IS_ACTIVE | Direct | — | — | — |
| DimOrganization | EffectiveStartDate | DIM_ORGANIZATION | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DimOrganization | EffectiveEndDate | DIM_ORGANIZATION | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DimOrganization | SourceSystem | DIM_ORGANIZATION | _SOURCE_SYSTEM | Direct | — | — | — |
| DimOrganization | SourceKey | DIM_ORGANIZATION | _SOURCE_KEY | Direct | — | — | — |
| DimOrganization | CreatedAt | DIM_ORGANIZATION | CREATED_AT | Direct | — | — | — |
| DimOrganization | CreatedBy | DIM_ORGANIZATION | CREATED_BY | Direct | — | — | — |
| DimOrganization | UpdatedAt | DIM_ORGANIZATION | UPDATED_AT | Direct | — | — | — |
| DimOrganization | UpdatedBy | DIM_ORGANIZATION | UPDATED_BY | Direct | — | — | — |
| DimOrganization | IsDeleted | DIM_ORGANIZATION | IS_DELETED | Direct | — | — | — |
| DimOrganization | DeletedAt | DIM_ORGANIZATION | DELETED_AT | Direct | — | — | — |
| DimFacility | FacilityKey | DIM_FACILITY | FACILITY_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | Type 2 | — |
| DimFacility | FacilityID | DIM_FACILITY | FACILITY_ID | Direct | — | Type 2 | — |
| DimFacility | FacilityName | DIM_FACILITY | FACILITY_NAME | Direct | — | Type 2 | — |
| DimFacility | FacilityShortName | DIM_FACILITY | FACILITY_SHORT_NAME | Direct | — | Type 2 | — |
| DimFacility | OrganizationKey | DIM_FACILITY | ORGANIZATION_KEY | Direct; FK to DimOrganization.OrganizationKey | — | Type 2 | — |
| DimFacility | SiteCode | DIM_FACILITY | SITE_CODE | Direct | — | Type 2 | — |
| DimFacility | FacilityType | DIM_FACILITY | FACILITY_TYPE | Direct | — | Type 2 | — |
| DimFacility | AddressLine1 | DIM_FACILITY | ADDRESS_LINE_1 | Direct | — | Type 2 | — |
| DimFacility | AddressLine2 | DIM_FACILITY | ADDRESS_LINE_2 | Direct | — | Type 2 | — |
| DimFacility | City | DIM_FACILITY | CITY | Direct | — | Type 2 | — |
| DimFacility | StateRegion | DIM_FACILITY | STATE_REGION | Direct | — | Type 2 | — |
| DimFacility | PostalCode | DIM_FACILITY | POSTAL_CODE | Direct | — | Type 2 | — |
| DimFacility | CountryCode | DIM_FACILITY | COUNTRY_CODE | Direct | — | Type 2 | — |
| DimFacility | TimezoneName | DIM_FACILITY | TIMEZONE_NAME | Direct | — | Type 2 | — |
| DimFacility | UtcOffsetHours | DIM_FACILITY | UTC_OFFSET_HOURS | Direct | — | Type 2 | — |
| DimFacility | GmpCertified | DIM_FACILITY | GMP_CERTIFIED | Direct | — | Type 2 | — |
| DimFacility | GmpCertificationDate | DIM_FACILITY | GMP_CERTIFICATION_DATE | Direct | — | Type 2 | — |
| DimFacility | GmpExpiryDate | DIM_FACILITY | GMP_EXPIRY_DATE | Direct | — | Type 2 | — |
| DimFacility | RegulatoryAgency | DIM_FACILITY | REGULATORY_AGENCY | Direct | — | Type 2 | — |
| DimFacility | FdaEstablishmentId | DIM_FACILITY | FDA_ESTABLISHMENT_ID | Direct | — | Type 2 | — |
| DimFacility | EmaSiteCode | DIM_FACILITY | EMA_SITE_CODE | Direct | — | Type 2 | — |
| DimFacility | ManufacturingCapacity | DIM_FACILITY | MANUFACTURING_CAPACITY | Direct | — | Type 2 | — |
| DimFacility | SourceSiteCodeMartA | DIM_FACILITY | SOURCE_SITE_CODE_MART_A | Direct | — | Type 2 | — |
| DimFacility | SourcePlantCodeOps | DIM_FACILITY | SOURCE_PLANT_CODE_OPS | Direct | — | Type 2 | — |
| DimFacility | SourceFacCodeMartB | DIM_FACILITY | SOURCE_FAC_CODE_MART_B | Direct | — | Type 2 | — |
| DimFacility | EffectiveStartDate | DIM_FACILITY | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DimFacility | EffectiveEndDate | DIM_FACILITY | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DimFacility | CurrentFlag | DIM_FACILITY | CURRENT_FLAG | Direct | — | Type 2 | — |
| DimFacility | ScdVersion | DIM_FACILITY | SCD_VERSION | Direct | — | Type 2 | — |
| DimFacility | SourceSystem | DIM_FACILITY | _SOURCE_SYSTEM | Direct | — | Type 2 | — |
| DimFacility | SourceKey | DIM_FACILITY | _SOURCE_KEY | Direct | — | Type 2 | — |
| DimFacility | CreatedAt | DIM_FACILITY | CREATED_AT | Direct | — | Type 2 | — |
| DimFacility | CreatedBy | DIM_FACILITY | CREATED_BY | Direct | — | Type 2 | — |
| DimFacility | UpdatedAt | DIM_FACILITY | UPDATED_AT | Direct | — | Type 2 | — |
| DimFacility | UpdatedBy | DIM_FACILITY | UPDATED_BY | Direct | — | Type 2 | — |
| DimFacility | IsDeleted | DIM_FACILITY | IS_DELETED | Direct | — | Type 2 | — |
| DimFacility | DeletedAt | DIM_FACILITY | DELETED_AT | Direct | — | Type 2 | — |
| DimProduct | ProductKey | DIM_PRODUCT | PRODUCT_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | Type 2 | — |
| DimProduct | ProductID | DIM_PRODUCT | PRODUCT_ID | Direct | — | Type 2 | — |
| DimProduct | Sku | DIM_PRODUCT | SKU | Direct | — | Type 2 | — |
| DimProduct | ProductName | DIM_PRODUCT | PRODUCT_NAME | Direct | — | Type 2 | — |
| DimProduct | ProductShortName | DIM_PRODUCT | PRODUCT_SHORT_NAME | Direct | — | Type 2 | — |
| DimProduct | OrganizationKey | DIM_PRODUCT | ORGANIZATION_KEY | Direct; FK to DimOrganization.OrganizationKey | — | Type 2 | — |
| DimProduct | FormulationId | DIM_PRODUCT | FORMULATION_ID | Direct | — | Type 2 | — |
| DimProduct | FormulationVersion | DIM_PRODUCT | FORMULATION_VERSION | Direct | — | Type 2 | — |
| DimProduct | DosageForm | DIM_PRODUCT | DOSAGE_FORM | Direct | — | Type 2 | — |
| DimProduct | DosageStrength | DIM_PRODUCT | DOSAGE_STRENGTH | Direct | — | Type 2 | — |
| DimProduct | RouteOfAdministration | DIM_PRODUCT | ROUTE_OF_ADMINISTRATION | Direct | — | Type 2 | — |
| DimProduct | TherapeuticClass | DIM_PRODUCT | THERAPEUTIC_CLASS | Direct | — | Type 2 | — |
| DimProduct | TherapeuticArea | DIM_PRODUCT | THERAPEUTIC_AREA | Direct | — | Type 2 | — |
| DimProduct | ProductCategory | DIM_PRODUCT | PRODUCT_CATEGORY | Direct | — | Type 2 | — |
| DimProduct | IsBiosimilar | DIM_PRODUCT | IS_BIOSIMILAR | Direct | — | Type 2 | — |
| DimProduct | ReferenceProductId | DIM_PRODUCT | REFERENCE_PRODUCT_ID | Direct | — | Type 2 | — |
| DimProduct | InnName | DIM_PRODUCT | INN_NAME | Direct | — | Type 2 | — |
| DimProduct | IdmpMpid | DIM_PRODUCT | IDMP_MPID | Direct | — | Type 2 | — |
| DimProduct | NdaBlaNumber | DIM_PRODUCT | NDA_BLA_NUMBER | Direct | — | Type 2 | — |
| DimProduct | EmaProductNumber | DIM_PRODUCT | EMA_PRODUCT_NUMBER | Direct | — | Type 2 | — |
| DimProduct | StandardYieldPct | DIM_PRODUCT | STANDARD_YIELD_PCT | Direct | — | Type 2 | — |
| DimProduct | YieldLowerAlertPct | DIM_PRODUCT | YIELD_LOWER_ALERT_PCT | Direct | — | Type 2 | — |
| DimProduct | YieldLowerActionPct | DIM_PRODUCT | YIELD_LOWER_ACTION_PCT | Direct | — | Type 2 | — |
| DimProduct | ShelfLifeMonths | DIM_PRODUCT | SHELF_LIFE_MONTHS | Direct | — | Type 2 | — |
| DimProduct | StorageCondition | DIM_PRODUCT | STORAGE_CONDITION | Direct | — | Type 2 | — |
| DimProduct | EffectiveStartDate | DIM_PRODUCT | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DimProduct | EffectiveEndDate | DIM_PRODUCT | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DimProduct | CurrentFlag | DIM_PRODUCT | CURRENT_FLAG | Direct | — | Type 2 | — |
| DimProduct | ScdVersion | DIM_PRODUCT | SCD_VERSION | Direct | — | Type 2 | — |
| DimProduct | SourceProductCodeMartA | DIM_PRODUCT | SOURCE_PRODUCT_CODE_MART_A | Direct | — | Type 2 | — |
| DimProduct | SourceProductCodeOps | DIM_PRODUCT | SOURCE_PRODUCT_CODE_OPS | Direct | — | Type 2 | — |
| DimProduct | SourceSystem | DIM_PRODUCT | _SOURCE_SYSTEM | Direct | — | Type 2 | — |
| DimProduct | SourceKey | DIM_PRODUCT | _SOURCE_KEY | Direct | — | Type 2 | — |
| DimProduct | CreatedAt | DIM_PRODUCT | CREATED_AT | Direct | — | Type 2 | — |
| DimProduct | CreatedBy | DIM_PRODUCT | CREATED_BY | Direct | — | Type 2 | — |
| DimProduct | UpdatedAt | DIM_PRODUCT | UPDATED_AT | Direct | — | Type 2 | — |
| DimProduct | UpdatedBy | DIM_PRODUCT | UPDATED_BY | Direct | — | Type 2 | — |
| DimProduct | IsDeleted | DIM_PRODUCT | IS_DELETED | Direct | — | Type 2 | — |
| DimProduct | DeletedAt | DIM_PRODUCT | DELETED_AT | Direct | — | Type 2 | — |
| DimMaterialLot | MaterialLotKey | DIM_MATERIAL_LOT | MATERIAL_LOT_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimMaterialLot | LotNumber | DIM_MATERIAL_LOT | LOT_NUMBER | Direct | — | — | — |
| DimMaterialLot | ProductKey | DIM_MATERIAL_LOT | PRODUCT_KEY | Direct; FK to DimProduct.ProductKey | — | — | — |
| DimMaterialLot | FacilityKey | DIM_MATERIAL_LOT | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| DimMaterialLot | LotType | DIM_MATERIAL_LOT | LOT_TYPE | Direct | — | — | — |
| DimMaterialLot | ManufactureDate | DIM_MATERIAL_LOT | MANUFACTURE_DATE | Direct | — | — | — |
| DimMaterialLot | ExpiryDate | DIM_MATERIAL_LOT | EXPIRY_DATE | Direct | — | — | — |
| DimMaterialLot | RetestDate | DIM_MATERIAL_LOT | RETEST_DATE | Direct | — | — | — |
| DimMaterialLot | QuantityProduced | DIM_MATERIAL_LOT | QUANTITY_PRODUCED | Direct | — | — | — |
| DimMaterialLot | QuantityUnit | DIM_MATERIAL_LOT | QUANTITY_UNIT | Direct | — | — | — |
| DimMaterialLot | LotStatus | DIM_MATERIAL_LOT | LOT_STATUS | Direct | — | — | — |
| DimMaterialLot | CertificateOfAnalysis | DIM_MATERIAL_LOT | CERTIFICATE_OF_ANALYSIS | Direct | — | — | — |
| DimMaterialLot | VendorLotNumber | DIM_MATERIAL_LOT | VENDOR_LOT_NUMBER | Direct | — | — | — |
| DimMaterialLot | VendorId | DIM_MATERIAL_LOT | VENDOR_ID | Direct | — | — | — |
| DimMaterialLot | SourceSystem | DIM_MATERIAL_LOT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimMaterialLot | SourceKey | DIM_MATERIAL_LOT | _SOURCE_KEY | Direct | — | — | — |
| DimMaterialLot | CreatedAt | DIM_MATERIAL_LOT | CREATED_AT | Direct | — | — | — |
| DimMaterialLot | CreatedBy | DIM_MATERIAL_LOT | CREATED_BY | Direct | — | — | — |
| DimMaterialLot | UpdatedAt | DIM_MATERIAL_LOT | UPDATED_AT | Direct | — | — | — |
| DimMaterialLot | UpdatedBy | DIM_MATERIAL_LOT | UPDATED_BY | Direct | — | — | — |
| DimMaterialLot | IsDeleted | DIM_MATERIAL_LOT | IS_DELETED | Direct | — | — | — |
| DimMaterialLot | DeletedAt | DIM_MATERIAL_LOT | DELETED_AT | Direct | — | — | — |
| DimEquipment | EquipmentKey | DIM_EQUIPMENT | EQUIPMENT_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimEquipment | CanonicalEquipmentID | DIM_EQUIPMENT | CANONICAL_EQUIPMENT_ID | Direct | — | — | — |
| DimEquipment | EquipmentName | DIM_EQUIPMENT | EQUIPMENT_NAME | Direct | — | — | — |
| DimEquipment | FacilityKey | DIM_EQUIPMENT | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| DimEquipment | FunctionalArea | DIM_EQUIPMENT | FUNCTIONAL_AREA | Direct | — | — | — |
| DimEquipment | ProductionUnit | DIM_EQUIPMENT | PRODUCTION_UNIT | Direct | — | — | — |
| DimEquipment | EquipmentModule | DIM_EQUIPMENT | EQUIPMENT_MODULE | Direct | — | — | — |
| DimEquipment | AssetClass | DIM_EQUIPMENT | ASSET_CLASS | Direct | — | — | — |
| DimEquipment | AssetSubClass | DIM_EQUIPMENT | ASSET_SUBCLASS | Direct | — | — | — |
| DimEquipment | CriticalityRating | DIM_EQUIPMENT | CRITICALITY_RATING | Direct | — | — | — |
| DimEquipment | ManufacturerName | DIM_EQUIPMENT | MANUFACTURER_NAME | Direct | — | — | — |
| DimEquipment | ModelNumber | DIM_EQUIPMENT | MODEL_NUMBER | Direct | — | — | — |
| DimEquipment | SerialNumber | DIM_EQUIPMENT | SERIAL_NUMBER | Direct | — | — | — |
| DimEquipment | WorkingVolumeL | DIM_EQUIPMENT | WORKING_VOLUME_L | Direct | — | — | — |
| DimEquipment | InstallationDate | DIM_EQUIPMENT | INSTALLATION_DATE | Direct | — | — | — |
| DimEquipment | CommissioningDate | DIM_EQUIPMENT | COMMISSIONING_DATE | Direct | — | — | — |
| DimEquipment | QualificationStatus | DIM_EQUIPMENT | QUALIFICATION_STATUS | Direct | — | — | — |
| DimEquipment | LastQualificationDate | DIM_EQUIPMENT | LAST_QUALIFICATION_DATE | Direct | — | — | — |
| DimEquipment | NextQualificationDate | DIM_EQUIPMENT | NEXT_QUALIFICATION_DATE | Direct | — | — | — |
| DimEquipment | CalibrationFrequency | DIM_EQUIPMENT | CALIBRATION_FREQUENCY | Direct | — | — | — |
| DimEquipment | LastCalibrationDate | DIM_EQUIPMENT | LAST_CALIBRATION_DATE | Direct | — | — | — |
| DimEquipment | CalibrationDueDate | DIM_EQUIPMENT | CALIBRATION_DUE_DATE | Direct | — | — | — |
| DimEquipment | CalibrationStatus | DIM_EQUIPMENT | CALIBRATION_STATUS | Direct | — | — | — |
| DimEquipment | PlannedRuntimeMinsPerDay | DIM_EQUIPMENT | PLANNED_RUNTIME_MINS_PER_DAY | Direct | — | — | — |
| DimEquipment | IdealCycleTimeSecs | DIM_EQUIPMENT | IDEAL_CYCLE_TIME_SECS | Direct | — | — | — |
| DimEquipment | EquipmentStatus | DIM_EQUIPMENT | EQUIPMENT_STATUS | Direct | — | — | — |
| DimEquipment | StatusEffectiveDate | DIM_EQUIPMENT | STATUS_EFFECTIVE_DATE | Direct | — | — | — |
| DimEquipment | DecommissionDate | DIM_EQUIPMENT | DECOMMISSION_DATE | Direct | — | — | — |
| DimEquipment | SourceEquipIdMartA | DIM_EQUIPMENT | SOURCE_EQUIP_ID_MART_A | Direct | — | — | — |
| DimEquipment | SourceAssetCodeOps | DIM_EQUIPMENT | SOURCE_ASSET_CODE_OPS | Direct | — | — | — |
| DimEquipment | SourceEquipCodeMartB | DIM_EQUIPMENT | SOURCE_EQUIP_CODE_MART_B | Direct | — | — | — |
| DimEquipment | SourceSystem | DIM_EQUIPMENT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimEquipment | SourceKey | DIM_EQUIPMENT | _SOURCE_KEY | Direct | — | — | — |
| DimEquipment | CreatedAt | DIM_EQUIPMENT | CREATED_AT | Direct | — | — | — |
| DimEquipment | CreatedBy | DIM_EQUIPMENT | CREATED_BY | Direct | — | — | — |
| DimEquipment | UpdatedAt | DIM_EQUIPMENT | UPDATED_AT | Direct | — | — | — |
| DimEquipment | UpdatedBy | DIM_EQUIPMENT | UPDATED_BY | Direct | — | — | — |
| DimEquipment | IsDeleted | DIM_EQUIPMENT | IS_DELETED | Direct | — | — | — |
| DimEquipment | DeletedAt | DIM_EQUIPMENT | DELETED_AT | Direct | — | — | — |
| DimProcessStep | ProcessStepKey | DIM_PROCESS_STEP | PROCESS_STEP_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimProcessStep | StepCode | DIM_PROCESS_STEP | STEP_CODE | Direct | — | — | — |
| DimProcessStep | StepName | DIM_PROCESS_STEP | STEP_NAME | Direct | — | — | — |
| DimProcessStep | StepCategory | DIM_PROCESS_STEP | STEP_CATEGORY | Direct | — | — | — |
| DimProcessStep | StepSubCategory | DIM_PROCESS_STEP | STEP_SUBCATEGORY | Direct | — | — | — |
| DimProcessStep | TypicalSequenceOrder | DIM_PROCESS_STEP | TYPICAL_SEQUENCE_ORDER | Direct | — | — | — |
| DimProcessStep | ExpectedDurationMinHrs | DIM_PROCESS_STEP | EXPECTED_DURATION_MIN_HRS | Direct | — | — | — |
| DimProcessStep | ExpectedDurationMaxHrs | DIM_PROCESS_STEP | EXPECTED_DURATION_MAX_HRS | Direct | — | — | — |
| DimProcessStep | ApplicableAssetClasses | DIM_PROCESS_STEP | APPLICABLE_ASSET_CLASSES | Direct | — | — | — |
| DimProcessStep | IsCcp | DIM_PROCESS_STEP | IS_CCP | Direct | — | — | — |
| DimProcessStep | IsActive | DIM_PROCESS_STEP | IS_ACTIVE | Direct | — | — | — |
| DimProcessStep | SourceSystem | DIM_PROCESS_STEP | _SOURCE_SYSTEM | Direct | — | — | — |
| DimProcessStep | SourceKey | DIM_PROCESS_STEP | _SOURCE_KEY | Direct | — | — | — |
| DimProcessStep | CreatedAt | DIM_PROCESS_STEP | CREATED_AT | Direct | — | — | — |
| DimProcessStep | CreatedBy | DIM_PROCESS_STEP | CREATED_BY | Direct | — | — | — |
| DimProcessStep | UpdatedAt | DIM_PROCESS_STEP | UPDATED_AT | Direct | — | — | — |
| DimProcessStep | UpdatedBy | DIM_PROCESS_STEP | UPDATED_BY | Direct | — | — | — |
| DimProcessStep | IsDeleted | DIM_PROCESS_STEP | IS_DELETED | Direct | — | — | — |
| DimProcessStep | DeletedAt | DIM_PROCESS_STEP | DELETED_AT | Direct | — | — | — |
| DimProcessParameter | ParameterKey | DIM_PROCESS_PARAMETER | PARAMETER_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimProcessParameter | ParameterCode | DIM_PROCESS_PARAMETER | PARAMETER_CODE | Direct | — | — | — |
| DimProcessParameter | ParameterName | DIM_PROCESS_PARAMETER | PARAMETER_NAME | Direct | — | — | — |
| DimProcessParameter | ParameterCategory | DIM_PROCESS_PARAMETER | PARAMETER_CATEGORY | Direct | — | — | — |
| DimProcessParameter | CanonicalUom | DIM_PROCESS_PARAMETER | CANONICAL_UOM | Direct | — | — | — |
| DimProcessParameter | SourceUomMartA | DIM_PROCESS_PARAMETER | SOURCE_UOM_MART_A | Direct | — | — | — |
| DimProcessParameter | SourceUomOps | DIM_PROCESS_PARAMETER | SOURCE_UOM_OPS | Direct | — | — | — |
| DimProcessParameter | SourceUomMartB | DIM_PROCESS_PARAMETER | SOURCE_UOM_MART_B | Direct | — | — | — |
| DimProcessParameter | ConversionFormulaOps | DIM_PROCESS_PARAMETER | CONVERSION_FORMULA_OPS | Direct | — | — | — |
| DimProcessParameter | IsCpp | DIM_PROCESS_PARAMETER | IS_CPP | Direct | — | — | — |
| DimProcessParameter | IsKpa | DIM_PROCESS_PARAMETER | IS_KPA | Direct | — | — | — |
| DimProcessParameter | TypicalTarget | DIM_PROCESS_PARAMETER | TYPICAL_TARGET | Direct | — | — | — |
| DimProcessParameter | TypicalLsl | DIM_PROCESS_PARAMETER | TYPICAL_LSL | Direct | — | — | — |
| DimProcessParameter | TypicalUsl | DIM_PROCESS_PARAMETER | TYPICAL_USL | Direct | — | — | — |
| DimProcessParameter | MeasurementFrequency | DIM_PROCESS_PARAMETER | MEASUREMENT_FREQUENCY | Direct | — | — | — |
| DimProcessParameter | InstrumentType | DIM_PROCESS_PARAMETER | INSTRUMENT_TYPE | Direct | — | — | — |
| DimProcessParameter | IsActive | DIM_PROCESS_PARAMETER | IS_ACTIVE | Direct | — | — | — |
| DimProcessParameter | SourceSystem | DIM_PROCESS_PARAMETER | _SOURCE_SYSTEM | Direct | — | — | — |
| DimProcessParameter | SourceKey | DIM_PROCESS_PARAMETER | _SOURCE_KEY | Direct | — | — | — |
| DimProcessParameter | CreatedAt | DIM_PROCESS_PARAMETER | CREATED_AT | Direct | — | — | — |
| DimProcessParameter | CreatedBy | DIM_PROCESS_PARAMETER | CREATED_BY | Direct | — | — | — |
| DimProcessParameter | UpdatedAt | DIM_PROCESS_PARAMETER | UPDATED_AT | Direct | — | — | — |
| DimProcessParameter | UpdatedBy | DIM_PROCESS_PARAMETER | UPDATED_BY | Direct | — | — | — |
| DimProcessParameter | IsDeleted | DIM_PROCESS_PARAMETER | IS_DELETED | Direct | — | — | — |
| DimProcessParameter | DeletedAt | DIM_PROCESS_PARAMETER | DELETED_AT | Direct | — | — | — |
| DimQualityDisposition | DispositionKey | DIM_QUALITY_DISPOSITION | DISPOSITION_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimQualityDisposition | DispositionCode | DIM_QUALITY_DISPOSITION | DISPOSITION_CODE | Direct | — | — | — |
| DimQualityDisposition | DispositionName | DIM_QUALITY_DISPOSITION | DISPOSITION_NAME | Direct | — | — | — |
| DimQualityDisposition | RequiresInvestigation | DIM_QUALITY_DISPOSITION | REQUIRES_INVESTIGATION | Direct | — | — | — |
| DimQualityDisposition | CommerciallyReleasable | DIM_QUALITY_DISPOSITION | COMMERCIALLY_RELEASABLE | Direct | — | — | — |
| DimQualityDisposition | DeviationImplied | DIM_QUALITY_DISPOSITION | DEVIATION_IMPLIED | Direct | — | — | — |
| DimQualityDisposition | PatientRiskLevel | DIM_QUALITY_DISPOSITION | PATIENT_RISK_LEVEL | Direct | — | — | — |
| DimQualityDisposition | RegulatoryNotificationRequired | DIM_QUALITY_DISPOSITION | REGULATORY_NOTIFICATION_REQUIRED | Direct | — | — | — |
| DimQualityDisposition | DispositionDescription | DIM_QUALITY_DISPOSITION | DISPOSITION_DESCRIPTION | Direct | — | — | — |
| DimQualityDisposition | IsActive | DIM_QUALITY_DISPOSITION | IS_ACTIVE | Direct | — | — | — |
| DimQualityDisposition | SourceCodeMartA | DIM_QUALITY_DISPOSITION | SOURCE_CODE_MART_A | Direct | — | — | — |
| DimQualityDisposition | SourceCodeMartB | DIM_QUALITY_DISPOSITION | SOURCE_CODE_MART_B | Direct | — | — | — |
| DimQualityDisposition | SourceCodeOps | DIM_QUALITY_DISPOSITION | SOURCE_CODE_OPS | Direct | — | — | — |
| DimQualityDisposition | SourceSystem | DIM_QUALITY_DISPOSITION | _SOURCE_SYSTEM | Direct | — | — | — |
| DimQualityDisposition | SourceKey | DIM_QUALITY_DISPOSITION | _SOURCE_KEY | Direct | — | — | — |
| DimQualityDisposition | CreatedAt | DIM_QUALITY_DISPOSITION | CREATED_AT | Direct | — | — | — |
| DimQualityDisposition | CreatedBy | DIM_QUALITY_DISPOSITION | CREATED_BY | Direct | — | — | — |
| DimQualityDisposition | UpdatedAt | DIM_QUALITY_DISPOSITION | UPDATED_AT | Direct | — | — | — |
| DimQualityDisposition | UpdatedBy | DIM_QUALITY_DISPOSITION | UPDATED_BY | Direct | — | — | — |
| DimQualityDisposition | IsDeleted | DIM_QUALITY_DISPOSITION | IS_DELETED | Direct | — | — | — |
| DimQualityDisposition | DeletedAt | DIM_QUALITY_DISPOSITION | DELETED_AT | Direct | — | — | — |
| DimDeviationCategory | DeviationCategoryKey | DIM_DEVIATION_CATEGORY | DEVIATION_CATEGORY_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimDeviationCategory | CategoryCode | DIM_DEVIATION_CATEGORY | CATEGORY_CODE | Direct | — | — | — |
| DimDeviationCategory | CategoryName | DIM_DEVIATION_CATEGORY | CATEGORY_NAME | Direct | — | — | — |
| DimDeviationCategory | CategoryGroup | DIM_DEVIATION_CATEGORY | CATEGORY_GROUP | Direct | — | — | — |
| DimDeviationCategory | Description | DIM_DEVIATION_CATEGORY | DESCRIPTION | Direct | — | — | — |
| DimDeviationCategory | CapaTypicallyRequired | DIM_DEVIATION_CATEGORY | CAPA_TYPICALLY_REQUIRED | Direct | — | — | — |
| DimDeviationCategory | IsActive | DIM_DEVIATION_CATEGORY | IS_ACTIVE | Direct | — | — | — |
| DimDeviationCategory | CreatedAt | DIM_DEVIATION_CATEGORY | CREATED_AT | Direct | — | — | — |
| DimDeviationCategory | CreatedBy | DIM_DEVIATION_CATEGORY | CREATED_BY | Direct | — | — | — |
| DimDeviationCategory | UpdatedAt | DIM_DEVIATION_CATEGORY | UPDATED_AT | Direct | — | — | — |
| DimDeviationCategory | UpdatedBy | DIM_DEVIATION_CATEGORY | UPDATED_BY | Direct | — | — | — |
| DimDeviationCategory | IsDeleted | DIM_DEVIATION_CATEGORY | IS_DELETED | Direct | — | — | — |
| DimDeviationCategory | DeletedAt | DIM_DEVIATION_CATEGORY | DELETED_AT | Direct | — | — | — |
| DimOperator | OperatorKey | DIM_OPERATOR | OPERATOR_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| DimOperator | OperatorID | DIM_OPERATOR | OPERATOR_ID | Direct | — | — | — |
| DimOperator | FullName | DIM_OPERATOR | FULL_NAME | Direct | — | — | — |
| DimOperator | RoleCode | DIM_OPERATOR | ROLE_CODE | Direct | — | — | — |
| DimOperator | FacilityKey | DIM_OPERATOR | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| DimOperator | Department | DIM_OPERATOR | DEPARTMENT | Direct | — | — | — |
| DimOperator | IsGmpTrained | DIM_OPERATOR | IS_GMP_TRAINED | Direct | — | — | — |
| DimOperator | TrainingExpiryDate | DIM_OPERATOR | TRAINING_EXPIRY_DATE | Direct | — | — | — |
| DimOperator | EsignatureEnabled | DIM_OPERATOR | ESIGNATURE_ENABLED | Direct | — | — | — |
| DimOperator | EmploymentStatus | DIM_OPERATOR | EMPLOYMENT_STATUS | Direct | — | — | — |
| DimOperator | SourceSystem | DIM_OPERATOR | _SOURCE_SYSTEM | Direct | — | — | — |
| DimOperator | SourceKey | DIM_OPERATOR | _SOURCE_KEY | Direct | — | — | — |
| DimOperator | CreatedAt | DIM_OPERATOR | CREATED_AT | Direct | — | — | — |
| DimOperator | CreatedBy | DIM_OPERATOR | CREATED_BY | Direct | — | — | — |
| DimOperator | UpdatedAt | DIM_OPERATOR | UPDATED_AT | Direct | — | — | — |
| DimOperator | UpdatedBy | DIM_OPERATOR | UPDATED_BY | Direct | — | — | — |
| DimOperator | IsDeleted | DIM_OPERATOR | IS_DELETED | Direct | — | — | — |
| DimOperator | DeletedAt | DIM_OPERATOR | DELETED_AT | Direct | — | — | — |
| FactProductionOrder | ProductionOrderKey | FACT_PRODUCTION_ORDER | PRODUCTION_ORDER_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactProductionOrder | CanonicalBatchID | FACT_PRODUCTION_ORDER | CANONICAL_BATCH_ID | Direct | — | — | — |
| FactProductionOrder | ErpOrderNumber | FACT_PRODUCTION_ORDER | ERP_ORDER_NUMBER | Direct | — | — | — |
| FactProductionOrder | MesBatchReference | FACT_PRODUCTION_ORDER | MES_BATCH_REFERENCE | Direct | — | — | — |
| FactProductionOrder | GmpLotNumber | FACT_PRODUCTION_ORDER | GMP_LOT_NUMBER | Direct | — | — | — |
| FactProductionOrder | FacilityKey | FACT_PRODUCTION_ORDER | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| FactProductionOrder | ProductKey | FACT_PRODUCTION_ORDER | PRODUCT_KEY | Direct; FK to DimProduct.ProductKey | — | — | — |
| FactProductionOrder | PrimaryEquipmentKey | FACT_PRODUCTION_ORDER | PRIMARY_EQUIPMENT_KEY | Direct; FK to DimEquipment.EquipmentKey | — | — | — |
| FactProductionOrder | DispositionKey | FACT_PRODUCTION_ORDER | DISPOSITION_KEY | Direct; FK to DimQualityDisposition.DispositionKey | — | — | — |
| FactProductionOrder | PlannedStartUTC | FACT_PRODUCTION_ORDER | PLANNED_START_UTC | Direct | — | — | — |
| FactProductionOrder | PlannedEndUTC | FACT_PRODUCTION_ORDER | PLANNED_END_UTC | Direct | — | — | — |
| FactProductionOrder | PlannedQuantity | FACT_PRODUCTION_ORDER | PLANNED_QUANTITY | Direct | Additive | — | — |
| FactProductionOrder | QuantityUom | FACT_PRODUCTION_ORDER | QUANTITY_UOM | Direct | — | — | — |
| FactProductionOrder | ActualStartUTC | FACT_PRODUCTION_ORDER | ACTUAL_START_UTC | Direct | — | — | — |
| FactProductionOrder | ActualEndUTC | FACT_PRODUCTION_ORDER | ACTUAL_END_UTC | Direct | — | — | — |
| FactProductionOrder | ActualQuantity | FACT_PRODUCTION_ORDER | ACTUAL_QUANTITY | Direct | Additive | — | — |
| FactProductionOrder | YieldPct | FACT_PRODUCTION_ORDER | YIELD_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | YieldVariancePct | FACT_PRODUCTION_ORDER | YIELD_VARIANCE_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeAvailabilityPct | FACT_PRODUCTION_ORDER | OEE_AVAILABILITY_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeePerformancePct | FACT_PRODUCTION_ORDER | OEE_PERFORMANCE_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeQualityPct | FACT_PRODUCTION_ORDER | OEE_QUALITY_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeOverallPct | FACT_PRODUCTION_ORDER | OEE_OVERALL_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | BatchStatus | FACT_PRODUCTION_ORDER | BATCH_STATUS | Direct | — | — | — |
| FactProductionOrder | DeviationCount | FACT_PRODUCTION_ORDER | DEVIATION_COUNT | Direct | Additive | — | — |
| FactProductionOrder | IsGoldenBatch | FACT_PRODUCTION_ORDER | IS_GOLDEN_BATCH | Direct | — | — | — |
| FactProductionOrder | GoldenBatchReference | FACT_PRODUCTION_ORDER | GOLDEN_BATCH_REFERENCE | Direct | — | — | — |
| FactProductionOrder | ShiftAtStart | FACT_PRODUCTION_ORDER | SHIFT_AT_START | Direct | — | — | — |
| FactProductionOrder | ShiftSupervisorKey | FACT_PRODUCTION_ORDER | SHIFT_SUPERVISOR_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactProductionOrder | SourceBatchIdMartA | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_MART_A | Direct | — | — | — |
| FactProductionOrder | SourceBatchIdOps | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_OPS | Direct | — | — | — |
| FactProductionOrder | SourceOrderNumOps | FACT_PRODUCTION_ORDER | SOURCE_ORDER_NUM_OPS | Direct | — | — | — |
| FactProductionOrder | SourceSystem | FACT_PRODUCTION_ORDER | _SOURCE_SYSTEM | Direct | — | — | — |
| FactProductionOrder | SourceKey | FACT_PRODUCTION_ORDER | _SOURCE_KEY | Direct | — | — | — |
| FactProductionOrder | LoadedAtUTC | FACT_PRODUCTION_ORDER | _LOADED_AT_UTC | Direct | — | — | — |
| FactProductionOrder | CreatedAt | FACT_PRODUCTION_ORDER | CREATED_AT | Direct | — | — | — |
| FactProductionOrder | CreatedBy | FACT_PRODUCTION_ORDER | CREATED_BY | Direct | — | — | — |
| FactProductionOrder | UpdatedAt | FACT_PRODUCTION_ORDER | UPDATED_AT | Direct | — | — | — |
| FactProductionOrder | UpdatedBy | FACT_PRODUCTION_ORDER | UPDATED_BY | Direct | — | — | — |
| FactProductionOrder | IsDeleted | FACT_PRODUCTION_ORDER | IS_DELETED | Direct | — | — | — |
| FactProductionOrder | DeletedAt | FACT_PRODUCTION_ORDER | DELETED_AT | Direct | — | — | — |
| FactBatchStep | BatchStepKey | FACT_BATCH_STEP | BATCH_STEP_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactBatchStep | ProductionOrderKey | FACT_BATCH_STEP | PRODUCTION_ORDER_KEY | Direct; FK to FactProductionOrder.ProductionOrderKey | — | — | — |
| FactBatchStep | CanonicalBatchID | FACT_BATCH_STEP | CANONICAL_BATCH_ID | Direct | — | — | — |
| FactBatchStep | ProcessStepKey | FACT_BATCH_STEP | PROCESS_STEP_KEY | Direct; FK to DimProcessStep.ProcessStepKey | — | — | — |
| FactBatchStep | EquipmentKey | FACT_BATCH_STEP | EQUIPMENT_KEY | Direct; FK to DimEquipment.EquipmentKey | — | — | — |
| FactBatchStep | StepSequence | FACT_BATCH_STEP | STEP_SEQUENCE | Direct | — | — | — |
| FactBatchStep | StepStartUTC | FACT_BATCH_STEP | STEP_START_UTC | Direct | — | — | — |
| FactBatchStep | StepEndUTC | FACT_BATCH_STEP | STEP_END_UTC | Direct | — | — | — |
| FactBatchStep | StepDurationHrs | FACT_BATCH_STEP | STEP_DURATION_HRS | Direct | Non-additive | — | — |
| FactBatchStep | InputQuantity | FACT_BATCH_STEP | INPUT_QUANTITY | Direct | Additive | — | — |
| FactBatchStep | OutputQuantity | FACT_BATCH_STEP | OUTPUT_QUANTITY | Direct | Additive | — | — |
| FactBatchStep | QuantityUom | FACT_BATCH_STEP | QUANTITY_UOM | Direct | — | — | — |
| FactBatchStep | StepYieldPct | FACT_BATCH_STEP | STEP_YIELD_PCT | Direct | Non-additive | — | — |
| FactBatchStep | StepStatus | FACT_BATCH_STEP | STEP_STATUS | Direct | — | — | — |
| FactBatchStep | OperatorKey | FACT_BATCH_STEP | OPERATOR_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactBatchStep | VerifierKey | FACT_BATCH_STEP | VERIFIER_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactBatchStep | EsignatureTimestampUTC | FACT_BATCH_STEP | ESIGNATURE_TIMESTAMP_UTC | Direct | — | — | — |
| FactBatchStep | EsignatureMeaning | FACT_BATCH_STEP | ESIGNATURE_MEANING | Direct | — | — | — |
| FactBatchStep | HasDeviation | FACT_BATCH_STEP | HAS_DEVIATION | Direct | — | — | — |
| FactBatchStep | DeviationCount | FACT_BATCH_STEP | DEVIATION_COUNT | Direct | Additive | — | — |
| FactBatchStep | StepNotes | FACT_BATCH_STEP | STEP_NOTES | Direct | — | — | — |
| FactBatchStep | SourceRunIdMartA | FACT_BATCH_STEP | SOURCE_RUN_ID_MART_A | Direct | — | — | — |
| FactBatchStep | SourceStepIdOps | FACT_BATCH_STEP | SOURCE_STEP_ID_OPS | Direct | — | — | — |
| FactBatchStep | SourceSystem | FACT_BATCH_STEP | _SOURCE_SYSTEM | Direct | — | — | — |
| FactBatchStep | SourceKey | FACT_BATCH_STEP | _SOURCE_KEY | Direct | — | — | — |
| FactBatchStep | LoadedAtUTC | FACT_BATCH_STEP | _LOADED_AT_UTC | Direct | — | — | — |
| FactBatchStep | CreatedAt | FACT_BATCH_STEP | CREATED_AT | Direct | — | — | — |
| FactBatchStep | CreatedBy | FACT_BATCH_STEP | CREATED_BY | Direct | — | — | — |
| FactBatchStep | UpdatedAt | FACT_BATCH_STEP | UPDATED_AT | Direct | — | — | — |
| FactBatchStep | UpdatedBy | FACT_BATCH_STEP | UPDATED_BY | Direct | — | — | — |
| FactBatchStep | IsDeleted | FACT_BATCH_STEP | IS_DELETED | Direct | — | — | — |
| FactBatchStep | DeletedAt | FACT_BATCH_STEP | DELETED_AT | Direct | — | — | — |
| FactEquipmentTelemetry | TelemetryKey | FACT_EQUIPMENT_TELEMETRY | TELEMETRY_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactEquipmentTelemetry | EquipmentKey | FACT_EQUIPMENT_TELEMETRY | EQUIPMENT_KEY | Direct; FK to DimEquipment.EquipmentKey | — | — | — |
| FactEquipmentTelemetry | BatchStepKey | FACT_EQUIPMENT_TELEMETRY | BATCH_STEP_KEY | Direct; FK to FactBatchStep.BatchStepKey | — | — | — |
| FactEquipmentTelemetry | ProductionOrderKey | FACT_EQUIPMENT_TELEMETRY | PRODUCTION_ORDER_KEY | Direct; FK to FactProductionOrder.ProductionOrderKey | — | — | — |
| FactEquipmentTelemetry | CanonicalBatchID | FACT_EQUIPMENT_TELEMETRY | CANONICAL_BATCH_ID | Direct | — | — | — |
| FactEquipmentTelemetry | ParameterKey | FACT_EQUIPMENT_TELEMETRY | PARAMETER_KEY | Direct; FK to DimProcessParameter.ParameterKey | — | — | — |
| FactEquipmentTelemetry | ReadingTimestampUTC | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Direct | — | — | — |
| FactEquipmentTelemetry | CanonicalValue | FACT_EQUIPMENT_TELEMETRY | CANONICAL_VALUE | Direct | Additive | — | — |
| FactEquipmentTelemetry | CanonicalUom | FACT_EQUIPMENT_TELEMETRY | CANONICAL_UOM | Direct | — | — | — |
| FactEquipmentTelemetry | SourceValue | FACT_EQUIPMENT_TELEMETRY | SOURCE_VALUE | Direct | Additive | — | — |
| FactEquipmentTelemetry | SourceUom | FACT_EQUIPMENT_TELEMETRY | SOURCE_UOM | Direct | — | — | — |
| FactEquipmentTelemetry | ConversionApplied | FACT_EQUIPMENT_TELEMETRY | CONVERSION_APPLIED | Direct | — | — | — |
| FactEquipmentTelemetry | TargetValue | FACT_EQUIPMENT_TELEMETRY | TARGET_VALUE | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | LowerSpecLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_SPEC_LIMIT | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | UpperSpecLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_SPEC_LIMIT | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | LowerAlertLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_ALERT_LIMIT | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | UpperAlertLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_ALERT_LIMIT | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | WithinSpecification | FACT_EQUIPMENT_TELEMETRY | WITHIN_SPECIFICATION | Direct | — | — | — |
| FactEquipmentTelemetry | WithinAlert | FACT_EQUIPMENT_TELEMETRY | WITHIN_ALERT | Direct | — | — | — |
| FactEquipmentTelemetry | DeviationFromTarget | FACT_EQUIPMENT_TELEMETRY | DEVIATION_FROM_TARGET | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | GoldenBatchValue | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_VALUE | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | GoldenBatchDeviation | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_DEVIATION | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | AggregationType | FACT_EQUIPMENT_TELEMETRY | AGGREGATION_TYPE | Direct | — | — | — |
| FactEquipmentTelemetry | SourceSystemType | FACT_EQUIPMENT_TELEMETRY | SOURCE_SYSTEM_TYPE | Direct | — | — | — |
| FactEquipmentTelemetry | SourceReadingIdMartA | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_MART_A | Direct | — | — | — |
| FactEquipmentTelemetry | SourceReadingIdOps | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_OPS | Direct | — | — | — |
| FactEquipmentTelemetry | SourceSystem | FACT_EQUIPMENT_TELEMETRY | _SOURCE_SYSTEM | Direct | — | — | — |
| FactEquipmentTelemetry | SourceKey | FACT_EQUIPMENT_TELEMETRY | _SOURCE_KEY | Direct | — | — | — |
| FactEquipmentTelemetry | LoadedAtUTC | FACT_EQUIPMENT_TELEMETRY | _LOADED_AT_UTC | Direct | — | — | — |
| FactEquipmentTelemetry | CreatedAt | FACT_EQUIPMENT_TELEMETRY | CREATED_AT | Direct | — | — | — |
| FactEquipmentTelemetry | CreatedBy | FACT_EQUIPMENT_TELEMETRY | CREATED_BY | Direct | — | — | — |
| FactEquipmentTelemetry | IsDeleted | FACT_EQUIPMENT_TELEMETRY | IS_DELETED | Direct | — | — | — |
| FactEquipmentTelemetry | DeletedAt | FACT_EQUIPMENT_TELEMETRY | DELETED_AT | Direct | — | — | — |
| FactDeviation | DeviationKey | FACT_DEVIATION | DEVIATION_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactDeviation | CanonicalDeviationID | FACT_DEVIATION | CANONICAL_DEVIATION_ID | Direct | — | — | — |
| FactDeviation | ProductionOrderKey | FACT_DEVIATION | PRODUCTION_ORDER_KEY | Direct; FK to FactProductionOrder.ProductionOrderKey | — | — | — |
| FactDeviation | BatchStepKey | FACT_DEVIATION | BATCH_STEP_KEY | Direct; FK to FactBatchStep.BatchStepKey | — | — | — |
| FactDeviation | TelemetryKey | FACT_DEVIATION | TELEMETRY_KEY | Direct; FK to FactEquipmentTelemetry.TelemetryKey | — | — | — |
| FactDeviation | EquipmentKey | FACT_DEVIATION | EQUIPMENT_KEY | Direct; FK to DimEquipment.EquipmentKey | — | — | — |
| FactDeviation | ParameterKey | FACT_DEVIATION | PARAMETER_KEY | Direct; FK to DimProcessParameter.ParameterKey | — | — | — |
| FactDeviation | DeviationCategoryKey | FACT_DEVIATION | DEVIATION_CATEGORY_KEY | Direct; FK to DimDeviationCategory.DeviationCategoryKey | — | — | — |
| FactDeviation | FacilityKey | FACT_DEVIATION | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| FactDeviation | CanonicalBatchID | FACT_DEVIATION | CANONICAL_BATCH_ID | Direct | — | — | — |
| FactDeviation | DetectedTimestampUTC | FACT_DEVIATION | DETECTED_TIMESTAMP_UTC | Direct | — | — | — |
| FactDeviation | DetectedByKey | FACT_DEVIATION | DETECTED_BY_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactDeviation | DetectionMethod | FACT_DEVIATION | DETECTION_METHOD | Direct | — | — | — |
| FactDeviation | SeverityCode | FACT_DEVIATION | SEVERITY_CODE | Direct | — | — | — |
| FactDeviation | PotentialImpact | FACT_DEVIATION | POTENTIAL_IMPACT | Direct | — | — | — |
| FactDeviation | DeviationDescription | FACT_DEVIATION | DEVIATION_DESCRIPTION | Direct | — | — | — |
| FactDeviation | InvestigationStatus | FACT_DEVIATION | INVESTIGATION_STATUS | Direct | — | — | — |
| FactDeviation | AssignedToKey | FACT_DEVIATION | ASSIGNED_TO_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactDeviation | InvestigationStartUTC | FACT_DEVIATION | INVESTIGATION_START_UTC | Direct | — | — | — |
| FactDeviation | InvestigationEndUTC | FACT_DEVIATION | INVESTIGATION_END_UTC | Direct | — | — | — |
| FactDeviation | RootCauseCode | FACT_DEVIATION | ROOT_CAUSE_CODE | Direct | — | — | — |
| FactDeviation | RootCauseDescription | FACT_DEVIATION | ROOT_CAUSE_DESCRIPTION | Direct | — | — | — |
| FactDeviation | CapaRequired | FACT_DEVIATION | CAPA_REQUIRED | Direct | — | — | — |
| FactDeviation | CapaReferenceID | FACT_DEVIATION | CAPA_REFERENCE_ID | Direct | — | — | — |
| FactDeviation | CapaDueDate | FACT_DEVIATION | CAPA_DUE_DATE | Direct | — | — | — |
| FactDeviation | CapaClosedDate | FACT_DEVIATION | CAPA_CLOSED_DATE | Direct | — | — | — |
| FactDeviation | ClosedTimestampUTC | FACT_DEVIATION | CLOSED_TIMESTAMP_UTC | Direct | — | — | — |
| FactDeviation | ClosedByKey | FACT_DEVIATION | CLOSED_BY_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactDeviation | ResolutionSummary | FACT_DEVIATION | RESOLUTION_SUMMARY | Direct | — | — | — |
| FactDeviation | RegulatoryNotificationRequired | FACT_DEVIATION | REGULATORY_NOTIFICATION_REQUIRED | Direct | — | — | — |
| FactDeviation | RegulatoryNotifiedDate | FACT_DEVIATION | REGULATORY_NOTIFIED_DATE | Direct | — | — | — |
| FactDeviation | SourceDevIdMartA | FACT_DEVIATION | SOURCE_DEV_ID_MART_A | Direct | — | — | — |
| FactDeviation | SourceDevNumOps | FACT_DEVIATION | SOURCE_DEV_NUM_OPS | Direct | — | — | — |
| FactDeviation | SourceSystem | FACT_DEVIATION | _SOURCE_SYSTEM | Direct | — | — | — |
| FactDeviation | SourceKey | FACT_DEVIATION | _SOURCE_KEY | Direct | — | — | — |
| FactDeviation | LoadedAtUTC | FACT_DEVIATION | _LOADED_AT_UTC | Direct | — | — | — |
| FactDeviation | CreatedAt | FACT_DEVIATION | CREATED_AT | Direct | — | — | — |
| FactDeviation | CreatedBy | FACT_DEVIATION | CREATED_BY | Direct | — | — | — |
| FactDeviation | UpdatedAt | FACT_DEVIATION | UPDATED_AT | Direct | — | — | — |
| FactDeviation | UpdatedBy | FACT_DEVIATION | UPDATED_BY | Direct | — | — | — |
| FactDeviation | IsDeleted | FACT_DEVIATION | IS_DELETED | Direct | — | — | — |
| FactDeviation | DeletedAt | FACT_DEVIATION | DELETED_AT | Direct | — | — | — |
| FactYieldAnalytics | YieldAnalyticsKey | FACT_YIELD_ANALYTICS | YIELD_ANALYTICS_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactYieldAnalytics | DateKey | FACT_YIELD_ANALYTICS | ANALYSIS_DATE | Derived; cast ANALYSIS_DATE to INTEGER YYYYMMDD | — | — | — |
| FactYieldAnalytics | AnalysisDate | FACT_YIELD_ANALYTICS | ANALYSIS_DATE | Direct | — | — | — |
| FactYieldAnalytics | FacilityKey | FACT_YIELD_ANALYTICS | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| FactYieldAnalytics | ProductKey | FACT_YIELD_ANALYTICS | PRODUCT_KEY | Direct; FK to DimProduct.ProductKey | — | — | — |
| FactYieldAnalytics | AggregationLevel | FACT_YIELD_ANALYTICS | AGGREGATION_LEVEL | Direct | — | — | — |
| FactYieldAnalytics | BatchesStarted | FACT_YIELD_ANALYTICS | BATCHES_STARTED | Direct | Additive | — | — |
| FactYieldAnalytics | BatchesCompleted | FACT_YIELD_ANALYTICS | BATCHES_COMPLETED | Direct | Additive | — | — |
| FactYieldAnalytics | BatchesOnHold | FACT_YIELD_ANALYTICS | BATCHES_ON_HOLD | Direct | Additive | — | — |
| FactYieldAnalytics | BatchesFailed | FACT_YIELD_ANALYTICS | BATCHES_FAILED | Direct | Additive | — | — |
| FactYieldAnalytics | AvgYieldPct | FACT_YIELD_ANALYTICS | AVG_YIELD_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | MinYieldPct | FACT_YIELD_ANALYTICS | MIN_YIELD_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | MaxYieldPct | FACT_YIELD_ANALYTICS | MAX_YIELD_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | StdYieldPct | FACT_YIELD_ANALYTICS | STD_YIELD_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | YieldBelowTargetCount | FACT_YIELD_ANALYTICS | YIELD_BELOW_TARGET_COUNT | Direct | Additive | — | — |
| FactYieldAnalytics | YieldTargetAttainmentPct | FACT_YIELD_ANALYTICS | YIELD_TARGET_ATTAINMENT_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | TotalPlannedQty | FACT_YIELD_ANALYTICS | TOTAL_PLANNED_QTY | Direct | Additive | — | — |
| FactYieldAnalytics | TotalActualQty | FACT_YIELD_ANALYTICS | TOTAL_ACTUAL_QTY | Direct | Additive | — | — |
| FactYieldAnalytics | QuantityUom | FACT_YIELD_ANALYTICS | QUANTITY_UOM | Direct | — | — | — |
| FactYieldAnalytics | AvgOeePct | FACT_YIELD_ANALYTICS | AVG_OEE_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | AvgAvailabilityPct | FACT_YIELD_ANALYTICS | AVG_AVAILABILITY_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | AvgPerformancePct | FACT_YIELD_ANALYTICS | AVG_PERFORMANCE_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | AvgQualityPct | FACT_YIELD_ANALYTICS | AVG_QUALITY_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | TotalDeviations | FACT_YIELD_ANALYTICS | TOTAL_DEVIATIONS | Direct | Additive | — | — |
| FactYieldAnalytics | HighCriticalDeviations | FACT_YIELD_ANALYTICS | HIGH_CRITICAL_DEVIATIONS | Direct | Additive | — | — |
| FactYieldAnalytics | CppComplianceRatePct | FACT_YIELD_ANALYTICS | CPP_COMPLIANCE_RATE_PCT | Direct | Non-additive | — | — |
| FactYieldAnalytics | SourceSystem | FACT_YIELD_ANALYTICS | _SOURCE_SYSTEM | Direct | — | — | — |
| FactYieldAnalytics | SourceKey | FACT_YIELD_ANALYTICS | _SOURCE_KEY | Direct | — | — | — |
| FactYieldAnalytics | LoadedAtUTC | FACT_YIELD_ANALYTICS | _LOADED_AT_UTC | Direct | — | — | — |
| FactYieldAnalytics | CreatedAt | FACT_YIELD_ANALYTICS | CREATED_AT | Direct | — | — | — |
| FactYieldAnalytics | CreatedBy | FACT_YIELD_ANALYTICS | CREATED_BY | Direct | — | — | — |
| FactYieldAnalytics | UpdatedAt | FACT_YIELD_ANALYTICS | UPDATED_AT | Direct | — | — | — |
| FactYieldAnalytics | UpdatedBy | FACT_YIELD_ANALYTICS | UPDATED_BY | Direct | — | — | — |
| FactYieldAnalytics | IsDeleted | FACT_YIELD_ANALYTICS | IS_DELETED | Direct | — | — | — |
| FactYieldAnalytics | DeletedAt | FACT_YIELD_ANALYTICS | DELETED_AT | Direct | — | — | — |
| FactShiftLog | ShiftLogKey | FACT_SHIFT_LOG | SHIFT_LOG_KEY | Surrogate Key (system-generated INTEGER; replaces canonical PK) | — | — | — |
| FactShiftLog | FacilityKey | FACT_SHIFT_LOG | FACILITY_KEY | Direct; FK to DimFacility.FacilityKey | — | — | — |
| FactShiftLog | DateKey | FACT_SHIFT_LOG | LOG_DATE | Derived; cast LOG_DATE to INTEGER YYYYMMDD | — | — | — |
| FactShiftLog | LogDate | FACT_SHIFT_LOG | LOG_DATE | Direct | — | — | — |
| FactShiftLog | ShiftName | FACT_SHIFT_LOG | SHIFT_NAME | Direct | — | — | — |
| FactShiftLog | ShiftStartUTC | FACT_SHIFT_LOG | SHIFT_START_UTC | Direct | — | — | — |
| FactShiftLog | ShiftEndUTC | FACT_SHIFT_LOG | SHIFT_END_UTC | Direct | — | — | — |
| FactShiftLog | SupervisorKey | FACT_SHIFT_LOG | SUPERVISOR_KEY | Direct; FK to DimOperator.OperatorKey | — | — | — |
| FactShiftLog | ActiveBatches | FACT_SHIFT_LOG | ACTIVE_BATCHES | Direct | Additive | — | — |
| FactShiftLog | CompletedBatches | FACT_SHIFT_LOG | COMPLETED_BATCHES | Direct | Additive | — | — |
| FactShiftLog | NewDeviations | FACT_SHIFT_LOG | NEW_DEVIATIONS | Direct | Additive | — | — |
| FactShiftLog | ClosedDeviations | FACT_SHIFT_LOG | CLOSED_DEVIATIONS | Direct | Additive | — | — |
| FactShiftLog | EquipmentDowntimeMins | FACT_SHIFT_LOG | EQUIPMENT_DOWNTIME_MINS | Direct | Additive | — | — |
| FactShiftLog | EquipmentIssuesCount | FACT_SHIFT_LOG | EQUIPMENT_ISSUES_COUNT | Direct | Additive | — | — |
| FactShiftLog | SignedOff | FACT_SHIFT_LOG | SIGNED_OFF | Direct | — | — | — |
| FactShiftLog | SignedOffUTC | FACT_SHIFT_LOG | SIGNED_OFF_UTC | Direct | — | — | — |
| FactShiftLog | ShiftNotes | FACT_SHIFT_LOG | SHIFT_NOTES | Direct | — | — | — |
| FactShiftLog | SourceLogIdMartA | FACT_SHIFT_LOG | SOURCE_LOG_ID_MART_A | Direct | — | — | — |
| FactShiftLog | SourceSystem | FACT_SHIFT_LOG | _SOURCE_SYSTEM | Direct | — | — | — |
| FactShiftLog | SourceKey | FACT_SHIFT_LOG | _SOURCE_KEY | Direct | — | — | — |
| FactShiftLog | LoadedAtUTC | FACT_SHIFT_LOG | _LOADED_AT_UTC | Direct | — | — | — |
| FactShiftLog | CreatedAt | FACT_SHIFT_LOG | CREATED_AT | Direct | — | — | — |
| FactShiftLog | CreatedBy | FACT_SHIFT_LOG | CREATED_BY | Direct | — | — | — |
| FactShiftLog | UpdatedAt | FACT_SHIFT_LOG | UPDATED_AT | Direct | — | — | — |
| FactShiftLog | UpdatedBy | FACT_SHIFT_LOG | UPDATED_BY | Direct | — | — | — |
| FactShiftLog | IsDeleted | FACT_SHIFT_LOG | IS_DELETED | Direct | — | — | — |
| FactShiftLog | DeletedAt | FACT_SHIFT_LOG | DELETED_AT | Direct | — | — | — |
| DimDate | DateKey | — | — | Surrogate Key (system-generated INTEGER in YYYYMMDD) | — | — | — |
| DimDate | FullDate | — | — | Derived from DateKey; cast to DATE | — | — | — |
| DimDate | Day | — | — | Derived; EXTRACT day from FullDate | — | — | — |
| DimDate | Month | — | — | Derived; EXTRACT month from FullDate | — | — | — |
| DimDate | MonthName | — | — | Derived via calendar lookup | — | — | — |
| DimDate | Quarter | — | — | Derived; EXTRACT quarter from FullDate | — | — | — |
| DimDate | Year | — | — | Derived; EXTRACT year from FullDate | — | — | — |
| DimDate | WeekNumber | — | — | Derived; ISO week from FullDate | — | — | — |
| DimDate | DayOfWeek | — | — | Derived; EXTRACT dow from FullDate | — | — | — |
| DimDate | DayName | — | — | Derived via calendar lookup | — | — | — |
| DimDate | IsWeekend | — | — | Derived; TRUE if DayOfWeek in (6,7) | — | — | — |
| DimDate | IsHoliday | — | — | Derived via holiday reference | — | — | — |
| DimDate | FiscalYear | — | — | Derived via fiscal calendar | — | — | — |
| DimDate | FiscalQuarter | — | — | Derived via fiscal calendar | — | — | — |
