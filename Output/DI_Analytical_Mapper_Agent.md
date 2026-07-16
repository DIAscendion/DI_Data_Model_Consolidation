### Section 1 — Modeling Summary

| Metric | Detail |
|----------------------------|-----------------------------------------------|
| Central Business Process | Pharma batch production and execution |
| Fact Table(s) | FACT_PRODUCTION_ORDER, FACT_BATCH_STEP, FACT_EQUIPMENT_TELEMETRY, FACT_DEVIATION, FACT_YIELD_ANALYTICS, FACT_SHIFT_LOG |
| Dimension Tables | DIM_ORGANIZATION, DIM_FACILITY, DIM_PRODUCT, DIM_MATERIAL_LOT, DIM_EQUIPMENT, DIM_PROCESS_STEP, DIM_PROCESS_PARAMETER, DIM_QUALITY_DISPOSITION, DIM_DEVIATION_CATEGORY, DIM_OPERATOR, DIM_DATE |
| Total Fact Measures | 55 |
| Total Dimension Attributes | 145 |
| SCD Type 2 Dimensions | DIM_FACILITY, DIM_PRODUCT, DIM_EQUIPMENT (status & qualification changes modeled, but table designed Type 1+2), DIM_DATE (implicit via Effective/Expiry if implemented) |
| PII-masked Columns | 0 (no PII attributes present in canonical or mapped entities) |

### Section 2 — Star Schema Definition

#### Dimension Table: DIM_ORGANIZATION

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OrganizationKey | INTEGER | Primary Key | Surrogate key for organization |
| OrganizationID | VARCHAR(50) | Natural Key | Canonical ORGANIZATION_ID |
| OrganizationName | VARCHAR(200) | Attribute | Canonical ORGANIZATION_NAME |
| OrganizationType | VARCHAR(80) | Attribute | Canonical ORGANIZATION_TYPE |
| ParentOrganizationKey | INTEGER | Attribute | Parent organization surrogate key |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 country code |
| RegulatoryRegion | VARCHAR(80) | Attribute | Regulatory jurisdiction |
| IsActive | BOOLEAN | Attribute | Active organization flag |
| EffectiveStartDate | DATE | SCD Type 2 | Start of organization record validity |
| EffectiveEndDate | DATE | SCD Type 2 | End of organization record validity |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DIM_FACILITY

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| FacilityKey | INTEGER | Primary Key | Surrogate key for facility |
| FacilityID | VARCHAR(50) | Natural Key | Canonical FACILITY_ID |
| FacilityName | VARCHAR(200) | Attribute | Canonical FACILITY_NAME |
| FacilityShortName | VARCHAR(80) | Attribute | Canonical FACILITY_SHORT_NAME |
| OrganizationKey | INTEGER | Foreign Key → DIM_ORGANIZATION | Parent organization |
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
| SourceFacCodeMartB | VARCHAR(30) | Attribute | CanonICAL SOURCE_FAC_CODE_MART_B |
| EffectiveStartDate | DATE | SCD Type 2 | Canonical EFFECTIVE_START_DATE |
| EffectiveEndDate | DATE | SCD Type 2 | Canonical EFFECTIVE_END_DATE |
| CurrentFlag | BOOLEAN | SCD Type 2 | Canonical CURRENT_FLAG |
| ScdVersion | INTEGER | SCD Type 2 | Canonical SCD_VERSION |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DIM_PRODUCT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProductKey | INTEGER | Primary Key | Surrogate key for product |
| ProductID | VARCHAR(50) | Natural Key | Canonical PRODUCT_ID |
| SKU | VARCHAR(60) | Natural Key | Canonical SKU |
| ProductName | VARCHAR(200) | Attribute | Canonical PRODUCT_NAME |
| ProductShortName | VARCHAR(80) | Attribute | Canonical PRODUCT_SHORT_NAME |
| OrganizationKey | INTEGER | Foreign Key → DIM_ORGANIZATION | Owning organization |
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
| ShelfLifeMonths | INTEGER | Attribute | Canonical SHELF_LIFE_MONTHS |
| StorageCondition | VARCHAR(80) | Attribute | Canonical STORAGE_CONDITION |
| EffectiveStartDate | DATE | SCD Type 2 | Canonical EFFECTIVE_START_DATE |
| EffectiveEndDate | DATE | SCD Type 2 | Canonical EFFECTIVE_END_DATE |
| CurrentFlag | BOOLEAN | SCD Type 2 | Canonical CURRENT_FLAG |
| ScdVersion | INTEGER | SCD Type 2 | Canonical SCD_VERSION |
| SourceProductCodeMartA | VARCHAR(50) | Attribute | Canonical SOURCE_PRODUCT_CODE_MART_A |
| SourceProductCodeOps | VARCHAR(50) | Attribute | Canonical SOURCE_PRODUCT_CODE_OPS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DIM_MATERIAL_LOT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| MaterialLotKey | INTEGER | Primary Key | Surrogate key for material lot |
| LotNumber | VARCHAR(80) | Natural Key | Canonical LOT_NUMBER |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Product associated with the lot |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility associated with the lot |
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

#### Dimension Table: DIM_EQUIPMENT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| EquipmentKey | INTEGER | Primary Key | Surrogate key for equipment |
| CanonicalEquipmentID | VARCHAR(50) | Natural Key | Canonical CANONICAL_EQUIPMENT_ID |
| EquipmentName | VARCHAR(200) | Attribute | Canonical EQUIPMENT_NAME |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Linked facility |
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
| PlannedRuntimeMinsPerDay | INTEGER | Attribute | Canonical PLANNED_RUNTIME_MINS_PER_DAY |
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

#### Dimension Table: DIM_PROCESS_STEP

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessStepKey | INTEGER | Primary Key | Surrogate key for process step |
| StepCode | VARCHAR(40) | Natural Key | Canonical STEP_CODE |
| StepName | VARCHAR(100) | Attribute | Canonical STEP_NAME |
| StepCategory | VARCHAR(60) | Attribute | Canonical STEP_CATEGORY |
| StepSubCategory | VARCHAR(60) | Attribute | Canonical STEP_SUBCATEGORY |
| TypicalSequenceOrder | INTEGER | Attribute | Canonical TYPICAL_SEQUENCE_ORDER |
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

#### Dimension Table: DIM_PROCESS_PARAMETER

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ParameterKey | INTEGER | Primary Key | Surrogate key for process parameter |
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

#### Dimension Table: DIM_QUALITY_DISPOSITION

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DispositionKey | INTEGER | Primary Key | Surrogate key for quality disposition |
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

#### Dimension Table: DIM_DEVIATION_CATEGORY

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DeviationCategoryKey | INTEGER | Primary Key | Surrogate key for deviation category |
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

#### Dimension Table: DIM_OPERATOR

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OperatorKey | INTEGER | Primary Key | Surrogate key for operator |
| OperatorID | VARCHAR(50) | Natural Key | Canonical OPERATOR_ID |
| FullName | VARCHAR(200) | Attribute | Canonical FULL_NAME |
| RoleCode | VARCHAR(50) | Attribute | Canonical ROLE_CODE |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Canonical FACILITY_KEY |
| Department | VARCHAR(100) | Attribute | Canonical DEPARTMENT |
| IsGmpTrained | BOOLEAN | Attribute | Canonical IS_GMP_TRAINED |
| TrainingExpiryDate | DATE | Attribute | Canonical TRAINING_EXPIRY_DATE |
| EsignatureEnabled | BOOLEAN | Attribute | CanonICAL ESIGNATURE_ENABLED |
| EmploymentStatus | VARCHAR(30) | Attribute | Canonical EMPLOYMENT_STATUS |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Dimension Table: DIM_DATE

| Column Name | Data Type | Role | Description |
|--------------|--------------|-------------|----------------------|
| DateKey | INTEGER | Primary Key | Surrogate (YYYYMMDD) |
| FullDate | DATE | Attribute | Calendar date |
| Day | INTEGER | Attribute | Day of month |
| Month | INTEGER | Attribute | Month number |
| MonthName | VARCHAR(20) | Attribute | Month name |
| Quarter | INTEGER | Attribute | Calendar quarter |
| Year | INTEGER | Attribute | Calendar year |
| WeekNumber | INTEGER | Attribute | ISO week number |
| DayOfWeek | INTEGER | Attribute | Day of week (1–7) |
| DayName | VARCHAR(20) | Attribute | Day of week name |
| IsWeekend | BOOLEAN | Attribute | Weekend flag |
| IsHoliday | BOOLEAN | Attribute | Holiday flag |
| FiscalYear | INTEGER | Attribute | Fiscal year |
| FiscalQuarter | INTEGER | Attribute | Fiscal quarter |

#### Fact Table: FACT_PRODUCTION_ORDER

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ProductionOrderKey | INTEGER | Primary Key | Surrogate key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier |
| ErpOrderNumber | VARCHAR(50) | Attribute | ERP production order number |
| MesBatchReference | VARCHAR(80) | Attribute | MES internal batch reference |
| GmpLotNumber | VARCHAR(80) | Attribute | GMP lot number |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility for batch |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Product manufactured |
| PrimaryEquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Primary equipment |
| DispositionKey | INTEGER | Foreign Key → DIM_QUALITY_DISPOSITION | Batch disposition |
| PlannedStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned batch start time |
| PlannedEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned batch end time |
| PlannedQuantity | DECIMAL(18,3) | Measure (Additive) | Planned output quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit of measure |
| ActualStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual batch start time |
| ActualEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual batch end time |
| ActualQuantity | DECIMAL(18,3) | Measure (Additive) | Actual produced quantity |
| YieldPct | DECIMAL(6,3) | Measure (Non-additive) | Overall batch yield percentage |
| YieldVariancePct | DECIMAL(8,4) | Measure (Non-additive) | Yield variance from target |
| OeeAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Availability component |
| OeePerformancePct | DECIMAL(6,3) | Measure (Non-additive) | OEE Performance component |
| OeeQualityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Quality component |
| OeeOverallPct | DECIMAL(6,3) | Measure (Non-additive) | Overall OEE |
| BatchStatus | VARCHAR(30) | Attribute | Canonical batch status |
| DeviationCount | INTEGER | Measure (Additive) | Deviation count per batch |
| IsGoldenBatch | BOOLEAN | Attribute | Golden batch flag |
| GoldenBatchReference | VARCHAR(50) | Attribute | Reference to golden batch |
| ShiftAtStart | VARCHAR(20) | Attribute | Shift name at batch start |
| ShiftSupervisorKey | INTEGER | Foreign Key → DIM_OPERATOR | Supervisor for starting shift |
| SourceBatchIdMartA | VARCHAR(50) | Attribute | Source batch ID from Mart A |
| SourceBatchIdOps | VARCHAR(50) | Attribute | Source batch ID from Operational system |
| SourceOrderNumOps | VARCHAR(50) | Attribute | Source order number from Operational system |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FACT_BATCH_STEP

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| BatchStepKey | INTEGER | Primary Key | Surrogate key |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order for step |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier |
| ProcessStepKey | INTEGER | Foreign Key → DIM_PROCESS_STEP | Process step |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment used |
| StepSequence | INTEGER | Attribute | Execution order of step |
| StepStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step start time |
| StepEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step end time |
| StepDurationHrs | DECIMAL(10,4) | Measure (Non-additive) | Step duration in hours |
| InputQuantity | DECIMAL(18,3) | Measure (Additive) | Input quantity to step |
| OutputQuantity | DECIMAL(18,3) | Measure (Additive) | Output quantity from step |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit of measure |
| StepYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Step-level yield percentage |
| StepStatus | VARCHAR(30) | Attribute | Canonical step status |
| OperatorKey | INTEGER | Foreign Key → DIM_OPERATOR | Executing operator |
| VerifierKey | INTEGER | Foreign Key → DIM_OPERATOR | Verification operator |
| EsignatureTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Electronic signature timestamp |
| EsignatureMeaning | VARCHAR(200) | Attribute | Meaning of signature |
| HasDeviation | BOOLEAN | Attribute | Deviation presence flag |
| DeviationCount | INTEGER | Measure (Additive) | Deviations count linked to this step |
| StepNotes | VARCHAR(2000) | Attribute | Free-text step notes |
| SourceRunIdMartA | VARCHAR(50) | Attribute | Source run ID from Mart A |
| SourceStepIdOps | INTEGER | Attribute | Source step ID from Operational system |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FACT_EQUIPMENT_TELEMETRY

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| TelemetryKey | INTEGER | Primary Key | Surrogate key |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment from which telemetry is captured |
| BatchStepKey | INTEGER | Foreign Key → FACT_BATCH_STEP | Batch step related to telemetry |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order related to telemetry |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier |
| ParameterKey | INTEGER | Foreign Key → DIM_PROCESS_PARAMETER | Process parameter |
| ReadingTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Reading timestamp |
| CanonicalValue | DECIMAL(18,4) | Measure (Additive) | Canonical value in canonical UOM |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceValue | DECIMAL(18,4) | Measure (Additive) | Source value before conversion |
| SourceUom | VARCHAR(30) | Attribute | Source unit of measure |
| ConversionApplied | VARCHAR(200) | Attribute | Conversion formula used |
| TargetValue | DECIMAL(18,4) | Measure (Non-additive) | Target value |
| LowerSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower specification limit |
| UpperSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper specification limit |
| LowerAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower alert limit |
| UpperAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper alert limit |
| WithinSpecification | BOOLEAN | Attribute | Flag indicating value within specification |
| WithinAlert | BOOLEAN | Attribute | Flag indicating value within alert limits |
| DeviationFromTarget | DECIMAL(18,4) | Measure (Non-additive) | Deviation from target |
| GoldenBatchValue | DECIMAL(18,4) | Measure (Non-additive) | Corresponding golden batch value |
| GoldenBatchDeviation | DECIMAL(18,4) | Measure (Non-additive) | Deviation from golden batch value |
| AggregationType | VARCHAR(30) | Attribute | Aggregation type |
| SourceSystemType | VARCHAR(30) | Attribute | Source system type |
| SourceReadingIdMartA | VARCHAR(60) | Attribute | Source reading ID from Mart A |
| SourceReadingIdOps | INTEGER | Attribute | Source reading ID from Operational system |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FACT_DEVIATION

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| DeviationKey | INTEGER | Primary Key | Surrogate key |
| CanonicalDeviationID | VARCHAR(60) | Attribute | Canonical deviation ID |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order reference |
| BatchStepKey | INTEGER | Foreign Key → FACT_BATCH_STEP | Batch step reference |
| TelemetryKey | INTEGER | Foreign Key → FACT_EQUIPMENT_TELEMETRY | Triggering telemetry record |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment |
| ParameterKey | INTEGER | Foreign Key → DIM_PROCESS_PARAMETER | Parameter |
| DeviationCategoryKey | INTEGER | Foreign Key → DIM_DEVIATION_CATEGORY | Deviation category |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch ID |
| DetectedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Detection timestamp |
| DetectedByKey | INTEGER | Foreign Key → DIM_OPERATOR | Detected by operator |
| DetectionMethod | VARCHAR(80) | Attribute | Detection method |
| SeverityCode | VARCHAR(20) | Attribute | Severity code |
| PotentialImpact | VARCHAR(200) | Attribute | Potential impact description |
| DeviationDescription | VARCHAR(4000) | Attribute | Full deviation description |
| InvestigationStatus | VARCHAR(30) | Attribute | Investigation status |
| AssignedToKey | INTEGER | Foreign Key → DIM_OPERATOR | Assigned investigator |
| InvestigationStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation start time |
| InvestigationEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation end time |
| RootCauseCode | VARCHAR(80) | Attribute | Root cause code |
| RootCauseDescription | VARCHAR(2000) | Attribute | Root cause description |
| CapaRequired | BOOLEAN | Attribute | CAPA requirement flag |
| CapaReferenceId | VARCHAR(60) | Attribute | CAPA reference ID |
| CapaDueDate | DATE | Attribute | CAPA due date |
| CapaClosedDate | DATE | Attribute | CAPA closure date |
| ClosedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Deviation closure timestamp |
| ClosedByKey | INTEGER | Foreign Key → DIM_OPERATOR | Closure operator |
| ResolutionSummary | VARCHAR(4000) | Attribute | Resolution summary |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification requirement flag |
| RegulatoryNotifiedDate | DATE | Attribute | Date regulatory agency notified |
| SourceDevIdMartA | VARCHAR(50) | Attribute | Source deviation ID from Mart A |
| SourceDevNumOps | VARCHAR(50) | Attribute | Source deviation number from Operational system |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FACT_YIELD_ANALYTICS

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| YieldAnalyticsKey | INTEGER | Primary Key | Surrogate key |
| AnalysisDate | DATE | Foreign Key → DIM_DATE | Analysis calendar date |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Product |
| AggregationLevel | VARCHAR(30) | Attribute | Aggregation granularity |
| BatchesStarted | INTEGER | Measure (Additive) | Count of batches started |
| BatchesCompleted | INTEGER | Measure (Additive) | Count of batches completed |
| BatchesOnHold | INTEGER | Measure (Additive) | Count of batches on hold |
| BatchesFailed | INTEGER | Measure (Additive) | Count of failed batches |
| AvgYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Average yield percentage |
| MinYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Minimum yield percentage |
| MaxYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Maximum yield percentage |
| StdYieldPct | DECIMAL(8,4) | Measure (Non-additive) | Yield standard deviation |
| YieldBelowTargetCount | INTEGER | Measure (Additive) | Count of batches below target |
| YieldTargetAttainmentPct | DECIMAL(6,3) | Measure (Non-additive) | Percentage of batches meeting target |
| TotalPlannedQty | DECIMAL(18,3) | Measure (Additive) | Total planned quantity |
| TotalActualQty | DECIMAL(18,3) | Measure (Additive) | Total actual quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit of measure |
| AvgOeePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE |
| AvgAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Average availability |
| AvgPerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Average performance |
| AvgQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Average quality |
| TotalDeviations | INTEGER | Measure (Additive) | Total deviations in period |
| HighCriticalDeviations | INTEGER | Measure (Additive) | Count of high/critical deviations |
| CppComplianceRatePct | DECIMAL(6,3) | Measure (Non-additive) | CPP compliance rate |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

#### Fact Table: FACT_SHIFT_LOG

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ShiftLogKey | INTEGER | Primary Key | Surrogate key |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility |
| LogDate | DATE | Foreign Key → DIM_DATE | Log date |
| ShiftName | VARCHAR(20) | Attribute | Shift identifier |
| ShiftStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift start time |
| ShiftEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift end time |
| SupervisorKey | INTEGER | Foreign Key → DIM_OPERATOR | Supervisor |
| ActiveBatches | INTEGER | Measure (Additive) | Batches active during shift |
| CompletedBatches | INTEGER | Measure (Additive) | Batches completed during shift |
| NewDeviations | INTEGER | Measure (Additive) | New deviations raised |
| ClosedDeviations | INTEGER | Measure (Additive) | Deviations closed |
| EquipmentDowntimeMins | INTEGER | Measure (Additive) | Equipment downtime minutes |
| EquipmentIssuesCount | INTEGER | Measure (Additive) | Equipment issues count |
| SignedOff | BOOLEAN | Attribute | Shift sign-off flag |
| SignedOffUtc | TIMESTAMP_TZ | Measure (Non-additive) | Sign-off timestamp |
| ShiftNotes | VARCHAR(4000) | Attribute | Shift notes |
| SourceLogIdMartA | INTEGER | Attribute | Source log ID from Mart A |
| SourceSystem | VARCHAR(50) | Audit | Canonical _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | Canonical _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Canonical _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | Canonical CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | Canonical CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | Canonical UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | Canonical UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | Canonical IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | Canonical DELETED_AT |

### Section 3 — Canonical to Star Mapping Table

| Star Table Name | Star Column Name | Canonical Entity | Canonical Attribute | Mapping Rule | Measure Type | SCD Type | PII |
|---|---|---|---|---|---|---|---|
| DIM_ORGANIZATION | OrganizationKey | DIM_ORGANIZATION | ORGANIZATION_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | Type 2 | — |
| DIM_ORGANIZATION | OrganizationID | DIM_ORGANIZATION | ORGANIZATION_ID | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | OrganizationName | DIM_ORGANIZATION | ORGANIZATION_NAME | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | OrganizationType | DIM_ORGANIZATION | ORGANIZATION_TYPE | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | ParentOrganizationKey | DIM_ORGANIZATION | PARENT_ORGANIZATION_KEY | Direct; cast NUMBER to INTEGER | — | Type 2 | — |
| DIM_ORGANIZATION | CountryCode | DIM_ORGANIZATION | COUNTRY_CODE | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | RegulatoryRegion | DIM_ORGANIZATION | REGULATORY_REGION | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | IsActive | DIM_ORGANIZATION | IS_ACTIVE | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | EffectiveStartDate | DIM_ORGANIZATION | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | EffectiveEndDate | DIM_ORGANIZATION | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DIM_ORGANIZATION | SourceSystem | DIM_ORGANIZATION | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_ORGANIZATION | SourceKey | DIM_ORGANIZATION | _SOURCE_KEY | Direct | — | — | — |
| DIM_ORGANIZATION | CreatedAt | DIM_ORGANIZATION | CREATED_AT | Direct | — | — | — |
| DIM_ORGANIZATION | CreatedBy | DIM_ORGANIZATION | CREATED_BY | Direct | — | — | — |
| DIM_ORGANIZATION | UpdatedAt | DIM_ORGANIZATION | UPDATED_AT | Direct | — | — | — |
| DIM_ORGANIZATION | UpdatedBy | DIM_ORGANIZATION | UPDATED_BY | Direct | — | — | — |
| DIM_ORGANIZATION | IsDeleted | DIM_ORGANIZATION | IS_DELETED | Direct | — | — | — |
| DIM_ORGANIZATION | DeletedAt | DIM_ORGANIZATION | DELETED_AT | Direct | — | — | — |
| DIM_FACILITY | FacilityKey | DIM_FACILITY | FACILITY_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | Type 2 | — |
| DIM_FACILITY | FacilityID | DIM_FACILITY | FACILITY_ID | Direct | — | Type 2 | — |
| DIM_FACILITY | FacilityName | DIM_FACILITY | FACILITY_NAME | Direct | — | Type 2 | — |
| DIM_FACILITY | FacilityShortName | DIM_FACILITY | FACILITY_SHORT_NAME | Direct | — | Type 2 | — |
| DIM_FACILITY | OrganizationKey | DIM_FACILITY | ORGANIZATION_KEY | Direct; cast NUMBER to INTEGER | — | Type 2 | — |
| DIM_FACILITY | SiteCode | DIM_FACILITY | SITE_CODE | Direct | — | Type 2 | — |
| DIM_FACILITY | FacilityType | DIM_FACILITY | FACILITY_TYPE | Direct | — | Type 2 | — |
| DIM_FACILITY | AddressLine1 | DIM_FACILITY | ADDRESS_LINE_1 | Direct | — | Type 2 | — |
| DIM_FACILITY | AddressLine2 | DIM_FACILITY | ADDRESS_LINE_2 | Direct | — | Type 2 | — |
| DIM_FACILITY | City | DIM_FACILITY | CITY | Direct | — | Type 2 | — |
| DIM_FACILITY | StateRegion | DIM_FACILITY | STATE_REGION | Direct | — | Type 2 | — |
| DIM_FACILITY | PostalCode | DIM_FACILITY | POSTAL_CODE | Direct | — | Type 2 | — |
| DIM_FACILITY | CountryCode | DIM_FACILITY | COUNTRY_CODE | Direct | — | Type 2 | — |
| DIM_FACILITY | TimezoneName | DIM_FACILITY | TIMEZONE_NAME | Direct | — | Type 2 | — |
| DIM_FACILITY | UtcOffsetHours | DIM_FACILITY | UTC_OFFSET_HOURS | Direct | — | Type 2 | — |
| DIM_FACILITY | GmpCertified | DIM_FACILITY | GMP_CERTIFIED | Direct | — | Type 2 | — |
| DIM_FACILITY | GmpCertificationDate | DIM_FACILITY | GMP_CERTIFICATION_DATE | Direct | — | Type 2 | — |
| DIM_FACILITY | GmpExpiryDate | DIM_FACILITY | GMP_EXPIRY_DATE | Direct | — | Type 2 | — |
| DIM_FACILITY | RegulatoryAgency | DIM_FACILITY | REGULATORY_AGENCY | Direct | — | Type 2 | — |
| DIM_FACILITY | FdaEstablishmentId | DIM_FACILITY | FDA_ESTABLISHMENT_ID | Direct | — | Type 2 | — |
| DIM_FACILITY | EmaSiteCode | DIM_FACILITY | EMA_SITE_CODE | Direct | — | Type 2 | — |
| DIM_FACILITY | ManufacturingCapacity | DIM_FACILITY | MANUFACTURING_CAPACITY | Direct | — | Type 2 | — |
| DIM_FACILITY | SourceSiteCodeMartA | DIM_FACILITY | SOURCE_SITE_CODE_MART_A | Direct | — | — | — |
| DIM_FACILITY | SourcePlantCodeOps | DIM_FACILITY | SOURCE_PLANT_CODE_OPS | Direct | — | — | — |
| DIM_FACILITY | SourceFacCodeMartB | DIM_FACILITY | SOURCE_FAC_CODE_MART_B | Direct | — | — | — |
| DIM_FACILITY | EffectiveStartDate | DIM_FACILITY | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DIM_FACILITY | EffectiveEndDate | DIM_FACILITY | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DIM_FACILITY | CurrentFlag | DIM_FACILITY | CURRENT_FLAG | Direct | — | Type 2 | — |
| DIM_FACILITY | ScdVersion | DIM_FACILITY | SCD_VERSION | Direct | — | Type 2 | — |
| DIM_FACILITY | SourceSystem | DIM_FACILITY | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_FACILITY | SourceKey | DIM_FACILITY | _SOURCE_KEY | Direct | — | — | — |
| DIM_FACILITY | CreatedAt | DIM_FACILITY | CREATED_AT | Direct | — | — | — |
| DIM_FACILITY | CreatedBy | DIM_FACILITY | CREATED_BY | Direct | — | — | — |
| DIM_FACILITY | UpdatedAt | DIM_FACILITY | UPDATED_AT | Direct | — | — | — |
| DIM_FACILITY | UpdatedBy | DIM_FACILITY | UPDATED_BY | Direct | — | — | — |
| DIM_FACILITY | IsDeleted | DIM_FACILITY | IS_DELETED | Direct | — | — | — |
| DIM_FACILITY | DeletedAt | DIM_FACILITY | DELETED_AT | Direct | — | — | — |
| DIM_PRODUCT | ProductKey | DIM_PRODUCT | PRODUCT_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | Type 2 | — |
| DIM_PRODUCT | ProductID | DIM_PRODUCT | PRODUCT_ID | Direct | — | Type 2 | — |
| DIM_PRODUCT | SKU | DIM_PRODUCT | SKU | Direct | — | Type 2 | — |
| DIM_PRODUCT | ProductName | DIM_PRODUCT | PRODUCT_NAME | Direct | — | Type 2 | — |
| DIM_PRODUCT | ProductShortName | DIM_PRODUCT | PRODUCT_SHORT_NAME | Direct | — | Type 2 | — |
| DIM_PRODUCT | OrganizationKey | DIM_PRODUCT | ORGANIZATION_KEY | Direct; cast NUMBER to INTEGER | — | Type 2 | — |
| DIM_PRODUCT | FormulationId | DIM_PRODUCT | FORMULATION_ID | Direct | — | Type 2 | — |
| DIM_PRODUCT | FormulationVersion | DIM_PRODUCT | FORMULATION_VERSION | Direct | — | Type 2 | — |
| DIM_PRODUCT | DosageForm | DIM_PRODUCT | DOSAGE_FORM | Direct | — | Type 2 | — |
| DIM_PRODUCT | DosageStrength | DIM_PRODUCT | DOSAGE_STRENGTH | Direct | — | Type 2 | — |
| DIM_PRODUCT | RouteOfAdministration | DIM_PRODUCT | ROUTE_OF_ADMINISTRATION | Direct | — | Type 2 | — |
| DIM_PRODUCT | TherapeuticClass | DIM_PRODUCT | THERAPEUTIC_CLASS | Direct | — | Type 2 | — |
| DIM_PRODUCT | TherapeuticArea | DIM_PRODUCT | THERAPEUTIC_AREA | Direct | — | Type 2 | — |
| DIM_PRODUCT | ProductCategory | DIM_PRODUCT | PRODUCT_CATEGORY | Direct | — | Type 2 | — |
| DIM_PRODUCT | IsBiosimilar | DIM_PRODUCT | IS_BIOSIMILAR | Direct | — | Type 2 | — |
| DIM_PRODUCT | ReferenceProductId | DIM_PRODUCT | REFERENCE_PRODUCT_ID | Direct | — | Type 2 | — |
| DIM_PRODUCT | InnName | DIM_PRODUCT | INN_NAME | Direct | — | Type 2 | — |
| DIM_PRODUCT | IdmpMpid | DIM_PRODUCT | IDMP_MPID | Direct | — | Type 2 | — |
| DIM_PRODUCT | NdaBlaNumber | DIM_PRODUCT | NDA_BLA_NUMBER | Direct | — | Type 2 | — |
| DIM_PRODUCT | EmaProductNumber | DIM_PRODUCT | EMA_PRODUCT_NUMBER | Direct | — | Type 2 | — |
| DIM_PRODUCT | StandardYieldPct | DIM_PRODUCT | STANDARD_YIELD_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | YieldLowerAlertPct | DIM_PRODUCT | YIELD_LOWER_ALERT_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | YieldLowerActionPct | DIM_PRODUCT | YIELD_LOWER_ACTION_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | ShelfLifeMonths | DIM_PRODUCT | SHELF_LIFE_MONTHS | Direct | — | Type 2 | — |
| DIM_PRODUCT | StorageCondition | DIM_PRODUCT | STORAGE_CONDITION | Direct | — | Type 2 | — |
| DIM_PRODUCT | EffectiveStartDate | DIM_PRODUCT | EFFECTIVE_START_DATE | Direct | — | Type 2 | — |
| DIM_PRODUCT | EffectiveEndDate | DIM_PRODUCT | EFFECTIVE_END_DATE | Direct | — | Type 2 | — |
| DIM_PRODUCT | CurrentFlag | DIM_PRODUCT | CURRENT_FLAG | Direct | — | Type 2 | — |
| DIM_PRODUCT | ScdVersion | DIM_PRODUCT | SCD_VERSION | Direct | — | Type 2 | — |
| DIM_PRODUCT | SourceProductCodeMartA | DIM_PRODUCT | SOURCE_PRODUCT_CODE_MART_A | Direct | — | — | — |
| DIM_PRODUCT | SourceProductCodeOps | DIM_PRODUCT | SOURCE_PRODUCT_CODE_OPS | Direct | — | — | — |
| DIM_PRODUCT | SourceSystem | DIM_PRODUCT | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_PRODUCT | SourceKey | DIM_PRODUCT | _SOURCE_KEY | Direct | — | — | — |
| DIM_PRODUCT | CreatedAt | DIM_PRODUCT | CREATED_AT | Direct | — | — | — |
| DIM_PRODUCT | CreatedBy | DIM_PRODUCT | CREATED_BY | Direct | — | — | — |
| DIM_PRODUCT | UpdatedAt | DIM_PRODUCT | UPDATED_AT | Direct | — | — | — |
| DIM_PRODUCT | UpdatedBy | DIM_PRODUCT | UPDATED_BY | Direct | — | — | — |
| DIM_PRODUCT | IsDeleted | DIM_PRODUCT | IS_DELETED | Direct | — | — | — |
| DIM_PRODUCT | DeletedAt | DIM_PRODUCT | DELETED_AT | Direct | — | — | — |
| DIM_MATERIAL_LOT | MaterialLotKey | DIM_MATERIAL_LOT | MATERIAL_LOT_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_MATERIAL_LOT | LotNumber | DIM_MATERIAL_LOT | LOT_NUMBER | Direct | — | — | — |
| DIM_MATERIAL_LOT | ProductKey | DIM_MATERIAL_LOT | PRODUCT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| DIM_MATERIAL_LOT | FacilityKey | DIM_MATERIAL_LOT | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| DIM_MATERIAL_LOT | LotType | DIM_MATERIAL_LOT | LOT_TYPE | Direct | — | — | — |
| DIM_MATERIAL_LOT | ManufactureDate | DIM_MATERIAL_LOT | MANUFACTURE_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | ExpiryDate | DIM_MATERIAL_LOT | EXPIRY_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | RetestDate | DIM_MATERIAL_LOT | RETEST_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | QuantityProduced | DIM_MATERIAL_LOT | QUANTITY_PRODUCED | Direct | — | — | — |
| DIM_MATERIAL_LOT | QuantityUnit | DIM_MATERIAL_LOT | QUANTITY_UNIT | Direct | — | — | — |
| DIM_MATERIAL_LOT | LotStatus | DIM_MATERIAL_LOT | LOT_STATUS | Direct | — | — | — |
| DIM_MATERIAL_LOT | CertificateOfAnalysis | DIM_MATERIAL_LOT | CERTIFICATE_OF_ANALYSIS | Direct | — | — | — |
| DIM_MATERIAL_LOT | VendorLotNumber | DIM_MATERIAL_LOT | VENDOR_LOT_NUMBER | Direct | — | — | — |
| DIM_MATERIAL_LOT | VendorId | DIM_MATERIAL_LOT | VENDOR_ID | Direct | — | — | — |
| DIM_MATERIAL_LOT | SourceSystem | DIM_MATERIAL_LOT | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_MATERIAL_LOT | SourceKey | DIM_MATERIAL_LOT | _SOURCE_KEY | Direct | — | — | — |
| DIM_MATERIAL_LOT | CreatedAt | DIM_MATERIAL_LOT | CREATED_AT | Direct | — | — | — |
| DIM_MATERIAL_LOT | CreatedBy | DIM_MATERIAL_LOT | CREATED_BY | Direct | — | — | — |
| DIM_MATERIAL_LOT | UpdatedAt | DIM_MATERIAL_LOT | UPDATED_AT | Direct | — | — | — |
| DIM_MATERIAL_LOT | UpdatedBy | DIM_MATERIAL_LOT | UPDATED_BY | Direct | — | — | — |
| DIM_MATERIAL_LOT | IsDeleted | DIM_MATERIAL_LOT | IS_DELETED | Direct | — | — | — |
| DIM_MATERIAL_LOT | DeletedAt | DIM_MATERIAL_LOT | DELETED_AT | Direct | — | — | — |
| DIM_EQUIPMENT | EquipmentKey | DIM_EQUIPMENT | EQUIPMENT_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | Type 1+2 | — |
| DIM_EQUIPMENT | CanonicalEquipmentID | DIM_EQUIPMENT | CANONICAL_EQUIPMENT_ID | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | EquipmentName | DIM_EQUIPMENT | EQUIPMENT_NAME | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | FacilityKey | DIM_EQUIPMENT | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | Type 1+2 | — |
| DIM_EQUIPMENT | FunctionalArea | DIM_EQUIPMENT | FUNCTIONAL_AREA | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | ProductionUnit | DIM_EQUIPMENT | PRODUCTION_UNIT | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | EquipmentModule | DIM_EQUIPMENT | EQUIPMENT_MODULE | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | AssetClass | DIM_EQUIPMENT | ASSET_CLASS | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | AssetSubClass | DIM_EQUIPMENT | ASSET_SUBCLASS | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | CriticalityRating | DIM_EQUIPMENT | CRITICALITY_RATING | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | ManufacturerName | DIM_EQUIPMENT | MANUFACTURER_NAME | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | ModelNumber | DIM_EQUIPMENT | MODEL_NUMBER | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | SerialNumber | DIM_EQUIPMENT | SERIAL_NUMBER | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | WorkingVolumeL | DIM_EQUIPMENT | WORKING_VOLUME_L | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | InstallationDate | DIM_EQUIPMENT | INSTALLATION_DATE | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | CommissioningDate | DIM_EQUIPMENT | COMMISSIONING_DATE | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | QualificationStatus | DIM_EQUIPMENT | QUALIFICATION_STATUS | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | LastQualificationDate | DIM_EQUIPMENT | LAST_QUALIFICATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | NextQualificationDate | DIM_EQUIPMENT | NEXT_QUALIFICATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationFrequency | DIM_EQUIPMENT | CALIBRATION_FREQUENCY | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | LastCalibrationDate | DIM_EQUIPMENT | LAST_CALIBRATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationDueDate | DIM_EQUIPMENT | CALIBRATION_DUE_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationStatus | DIM_EQUIPMENT | CALIBRATION_STATUS | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | PlannedRuntimeMinsPerDay | DIM_EQUIPMENT | PLANNED_RUNTIME_MINS_PER_DAY | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | IdealCycleTimeSecs | DIM_EQUIPMENT | IDEAL_CYCLE_TIME_SECS | Direct | — | Type 1+2 | — |
| DIM_EQUIPMENT | EquipmentStatus | DIM_EQUIPMENT | EQUIPMENT_STATUS | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | StatusEffectiveDate | DIM_EQUIPMENT | STATUS_EFFECTIVE_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | DecommissionDate | DIM_EQUIPMENT | DECOMMISSION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | SourceEquipIdMartA | DIM_EQUIPMENT | SOURCE_EQUIP_ID_MART_A | Direct | — | — | — |
| DIM_EQUIPMENT | SourceAssetCodeOps | DIM_EQUIPMENT | SOURCE_ASSET_CODE_OPS | Direct | — | — | — |
| DIM_EQUIPMENT | SourceEquipCodeMartB | DIM_EQUIPMENT | SOURCE_EQUIP_CODE_MART_B | Direct | — | — | — |
| DIM_EQUIPMENT | SourceSystem | DIM_EQUIPMENT | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_EQUIPMENT | SourceKey | DIM_EQUIPMENT | _SOURCE_KEY | Direct | — | — | — |
| DIM_EQUIPMENT | CreatedAt | DIM_EQUIPMENT | CREATED_AT | Direct | — | — | — |
| DIM_EQUIPMENT | CreatedBy | DIM_EQUIPMENT | CREATED_BY | Direct | — | — | — |
| DIM_EQUIPMENT | UpdatedAt | DIM_EQUIPMENT | UPDATED_AT | Direct | — | — | — |
| DIM_EQUIPMENT | UpdatedBy | DIM_EQUIPMENT | UPDATED_BY | Direct | — | — | — |
| DIM_EQUIPMENT | IsDeleted | DIM_EQUIPMENT | IS_DELETED | Direct | — | — | — |
| DIM_EQUIPMENT | DeletedAt | DIM_EQUIPMENT | DELETED_AT | Direct | — | — | — |
| DIM_PROCESS_STEP | ProcessStepKey | DIM_PROCESS_STEP | PROCESS_STEP_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_PROCESS_STEP | StepCode | DIM_PROCESS_STEP | STEP_CODE | Direct | — | — | — |
| DIM_PROCESS_STEP | StepName | DIM_PROCESS_STEP | STEP_NAME | Direct | — | — | — |
| DIM_PROCESS_STEP | StepCategory | DIM_PROCESS_STEP | STEP_CATEGORY | Direct | — | — | — |
| DIM_PROCESS_STEP | StepSubCategory | DIM_PROCESS_STEP | STEP_SUBCATEGORY | Direct | — | — | — |
| DIM_PROCESS_STEP | TypicalSequenceOrder | DIM_PROCESS_STEP | TYPICAL_SEQUENCE_ORDER | Direct | — | — | — |
| DIM_PROCESS_STEP | ExpectedDurationMinHrs | DIM_PROCESS_STEP | EXPECTED_DURATION_MIN_HRS | Direct | — | — | — |
| DIM_PROCESS_STEP | ExpectedDurationMaxHrs | DIM_PROCESS_STEP | EXPECTED_DURATION_MAX_HRS | Direct | — | — | — |
| DIM_PROCESS_STEP | ApplicableAssetClasses | DIM_PROCESS_STEP | APPLICABLE_ASSET_CLASSES | Direct | — | — | — |
| DIM_PROCESS_STEP | IsCcp | DIM_PROCESS_STEP | IS_CCP | Direct | — | — | — |
| DIM_PROCESS_STEP | IsActive | DIM_PROCESS_STEP | IS_ACTIVE | Direct | — | — | — |
| DIM_PROCESS_STEP | SourceSystem | DIM_PROCESS_STEP | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_PROCESS_STEP | SourceKey | DIM_PROCESS_STEP | _SOURCE_KEY | Direct | — | — | — |
| DIM_PROCESS_STEP | CreatedAt | DIM_PROCESS_STEP | CREATED_AT | Direct | — | — | — |
| DIM_PROCESS_STEP | CreatedBy | DIM_PROCESS_STEP | CREATED_BY | Direct | — | — | — |
| DIM_PROCESS_STEP | UpdatedAt | DIM_PROCESS_STEP | UPDATED_AT | Direct | — | — | — |
| DIM_PROCESS_STEP | UpdatedBy | DIM_PROCESS_STEP | UPDATED_BY | Direct | — | — | — |
| DIM_PROCESS_STEP | IsDeleted | DIM_PROCESS_STEP | IS_DELETED | Direct | — | — | — |
| DIM_PROCESS_STEP | DeletedAt | DIM_PROCESS_STEP | DELETED_AT | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | ParameterKey | DIM_PROCESS_PARAMETER | PARAMETER_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_PROCESS_PARAMETER | ParameterCode | DIM_PROCESS_PARAMETER | PARAMETER_CODE | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | ParameterName | DIM_PROCESS_PARAMETER | PARAMETER_NAME | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | ParameterCategory | DIM_PROCESS_PARAMETER | PARAMETER_CATEGORY | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | CanonicalUom | DIM_PROCESS_PARAMETER | CANONICAL_UOM | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | SourceUomMartA | DIM_PROCESS_PARAMETER | SOURCE_UOM_MART_A | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | SourceUomOps | DIM_PROCESS_PARAMETER | SOURCE_UOM_OPS | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | SourceUomMartB | DIM_PROCESS_PARAMETER | SOURCE_UOM_MART_B | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | ConversionFormulaOps | DIM_PROCESS_PARAMETER | CONVERSION_FORMULA_OPS | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | IsCpp | DIM_PROCESS_PARAMETER | IS_CPP | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | IsKpa | DIM_PROCESS_PARAMETER | IS_KPA | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | TypicalTarget | DIM_PROCESS_PARAMETER | TYPICAL_TARGET | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | TypicalLsl | DIM_PROCESS_PARAMETER | TYPICAL_LSL | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | TypicalUsl | DIM_PROCESS_PARAMETER | TYPICAL_USL | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | MeasurementFrequency | DIM_PROCESS_PARAMETER | MEASUREMENT_FREQUENCY | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | InstrumentType | DIM_PROCESS_PARAMETER | INSTRUMENT_TYPE | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | IsActive | DIM_PROCESS_PARAMETER | IS_ACTIVE | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | SourceSystem | DIM_PROCESS_PARAMETER | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | SourceKey | DIM_PROCESS_PARAMETER | _SOURCE_KEY | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | CreatedAt | DIM_PROCESS_PARAMETER | CREATED_AT | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | CreatedBy | DIM_PROCESS_PARAMETER | CREATED_BY | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | UpdatedAt | DIM_PROCESS_PARAMETER | UPDATED_AT | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | UpdatedBy | DIM_PROCESS_PARAMETER | UPDATED_BY | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | IsDeleted | DIM_PROCESS_PARAMETER | IS_DELETED | Direct | — | — | — |
| DIM_PROCESS_PARAMETER | DeletedAt | DIM_PROCESS_PARAMETER | DELETED_AT | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | DispositionKey | DIM_QUALITY_DISPOSITION | DISPOSITION_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_QUALITY_DISPOSITION | DispositionCode | DIM_QUALITY_DISPOSITION | DISPOSITION_CODE | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | DispositionName | DIM_QUALITY_DISPOSITION | DISPOSITION_NAME | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | RequiresInvestigation | DIM_QUALITY_DISPOSITION | REQUIRES_INVESTIGATION | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | CommerciallyReleasable | DIM_QUALITY_DISPOSITION | COMMERCIALLY_RELEASABLE | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | DeviationImplied | DIM_QUALITY_DISPOSITION | DEVIATION_IMPLIED | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | PatientRiskLevel | DIM_QUALITY_DISPOSITION | PATIENT_RISK_LEVEL | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | RegulatoryNotificationRequired | DIM_QUALITY_DISPOSITION | REGULATORY_NOTIFICATION_REQUIRED | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | DispositionDescription | DIM_QUALITY_DISPOSITION | DISPOSITION_DESCRIPTION | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | IsActive | DIM_QUALITY_DISPOSITION | IS_ACTIVE | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | SourceCodeMartA | DIM_QUALITY_DISPOSITION | SOURCE_CODE_MART_A | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | SourceCodeMartB | DIM_QUALITY_DISPOSITION | SOURCE_CODE_MART_B | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | SourceCodeOps | DIM_QUALITY_DISPOSITION | SOURCE_CODE_OPS | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | SourceSystem | DIM_QUALITY_DISPOSITION | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | SourceKey | DIM_QUALITY_DISPOSITION | _SOURCE_KEY | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | CreatedAt | DIM_QUALITY_DISPOSITION | CREATED_AT | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | CreatedBy | DIM_QUALITY_DISPOSITION | CREATED_BY | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | UpdatedAt | DIM_QUALITY_DISPOSITION | UPDATED_AT | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | UpdatedBy | DIM_QUALITY_DISPOSITION | UPDATED_BY | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | IsDeleted | DIM_QUALITY_DISPOSITION | IS_DELETED | Direct | — | — | — |
| DIM_QUALITY_DISPOSITION | DeletedAt | DIM_QUALITY_DISPOSITION | DELETED_AT | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | DeviationCategoryKey | DIM_DEVIATION_CATEGORY | DEVIATION_CATEGORY_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_DEVIATION_CATEGORY | CategoryCode | DIM_DEVIATION_CATEGORY | CATEGORY_CODE | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | CategoryName | DIM_DEVIATION_CATEGORY | CATEGORY_NAME | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | CategoryGroup | DIM_DEVIATION_CATEGORY | CATEGORY_GROUP | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | Description | DIM_DEVIATION_CATEGORY | DESCRIPTION | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | CapaTypicallyRequired | DIM_DEVIATION_CATEGORY | CAPA_TYPICALLY_REQUIRED | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | IsActive | DIM_DEVIATION_CATEGORY | IS_ACTIVE | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | CreatedAt | DIM_DEVIATION_CATEGORY | CREATED_AT | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | CreatedBy | DIM_DEVIATION_CATEGORY | CREATED_BY | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | UpdatedAt | DIM_DEVIATION_CATEGORY | UPDATED_AT | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | UpdatedBy | DIM_DEVIATION_CATEGORY | UPDATED_BY | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | IsDeleted | DIM_DEVIATION_CATEGORY | IS_DELETED | Direct | — | — | — |
| DIM_DEVIATION_CATEGORY | DeletedAt | DIM_DEVIATION_CATEGORY | DELETED_AT | Direct | — | — | — |
| DIM_OPERATOR | OperatorKey | DIM_OPERATOR | OPERATOR_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| DIM_OPERATOR | OperatorID | DIM_OPERATOR | OPERATOR_ID | Direct | — | — | — |
| DIM_OPERATOR | FullName | DIM_OPERATOR | FULL_NAME | Direct | — | — | — |
| DIM_OPERATOR | RoleCode | DIM_OPERATOR | ROLE_CODE | Direct | — | — | — |
| DIM_OPERATOR | FacilityKey | DIM_OPERATOR | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| DIM_OPERATOR | Department | DIM_OPERATOR | DEPARTMENT | Direct | — | — | — |
| DIM_OPERATOR | IsGmpTrained | DIM_OPERATOR | IS_GMP_TRAINED | Direct | — | — | — |
| DIM_OPERATOR | TrainingExpiryDate | DIM_OPERATOR | TRAINING_EXPIRY_DATE | Direct | — | — | — |
| DIM_OPERATOR | EsignatureEnabled | DIM_OPERATOR | ESIGNATURE_ENABLED | Direct | — | — | — |
| DIM_OPERATOR | EmploymentStatus | DIM_OPERATOR | EMPLOYMENT_STATUS | Direct | — | — | — |
| DIM_OPERATOR | SourceSystem | DIM_OPERATOR | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_OPERATOR | SourceKey | DIM_OPERATOR | _SOURCE_KEY | Direct | — | — | — |
| DIM_OPERATOR | CreatedAt | DIM_OPERATOR | CREATED_AT | Direct | — | — | — |
| DIM_OPERATOR | CreatedBy | DIM_OPERATOR | CREATED_BY | Direct | — | — | — |
| DIM_OPERATOR | UpdatedAt | DIM_OPERATOR | UPDATED_AT | Direct | — | — | — |
| DIM_OPERATOR | UpdatedBy | DIM_OPERATOR | UPDATED_BY | Direct | — | — | — |
| DIM_OPERATOR | IsDeleted | DIM_OPERATOR | IS_DELETED | Direct | — | — | — |
| DIM_OPERATOR | DeletedAt | DIM_OPERATOR | DELETED_AT | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ProductionOrderKey | FACT_PRODUCTION_ORDER | PRODUCTION_ORDER_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_PRODUCTION_ORDER | CanonicalBatchID | FACT_PRODUCTION_ORDER | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | ErpOrderNumber | FACT_PRODUCTION_ORDER | ERP_ORDER_NUMBER | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | MesBatchReference | FACT_PRODUCTION_ORDER | MES_BATCH_REFERENCE | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | GmpLotNumber | FACT_PRODUCTION_ORDER | GMP_LOT_NUMBER | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | FacilityKey | FACT_PRODUCTION_ORDER | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_PRODUCTION_ORDER | ProductKey | FACT_PRODUCTION_ORDER | PRODUCT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_PRODUCTION_ORDER | PrimaryEquipmentKey | FACT_PRODUCTION_ORDER | PRIMARY_EQUIPMENT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_PRODUCTION_ORDER | DispositionKey | FACT_PRODUCTION_ORDER | DISPOSITION_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_PRODUCTION_ORDER | PlannedStartUtc | FACT_PRODUCTION_ORDER | PLANNED_START_UTC | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | PlannedEndUtc | FACT_PRODUCTION_ORDER | PLANNED_END_UTC | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | PlannedQuantity | FACT_PRODUCTION_ORDER | PLANNED_QUANTITY | Direct | Additive | — | — |
| FACT_PRODUCTION_ORDER | QuantityUom | FACT_PRODUCTION_ORDER | QUANTITY_UOM | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ActualStartUtc | FACT_PRODUCTION_ORDER | ACTUAL_START_UTC | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | ActualEndUtc | FACT_PRODUCTION_ORDER | ACTUAL_END_UTC | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | ActualQuantity | FACT_PRODUCTION_ORDER | ACTUAL_QUANTITY | Direct | Additive | — | — |
| FACT_PRODUCTION_ORDER | YieldPct | FACT_PRODUCTION_ORDER | YIELD_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | YieldVariancePct | FACT_PRODUCTION_ORDER | YIELD_VARIANCE_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | OeeAvailabilityPct | FACT_PRODUCTION_ORDER | OEE_AVAILABILITY_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | OeePerformancePct | FACT_PRODUCTION_ORDER | OEE_PERFORMANCE_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | OeeQualityPct | FACT_PRODUCTION_ORDER | OEE_QUALITY_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | OeeOverallPct | FACT_PRODUCTION_ORDER | OEE_OVERALL_PCT | Direct | Non-additive | — | — |
| FACT_PRODUCTION_ORDER | BatchStatus | FACT_PRODUCTION_ORDER | BATCH_STATUS | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | DeviationCount | FACT_PRODUCTION_ORDER | DEVIATION_COUNT | Direct | Additive | — | — |
| FACT_PRODUCTION_ORDER | IsGoldenBatch | FACT_PRODUCTION_ORDER | IS_GOLDEN_BATCH | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | GoldenBatchReference | FACT_PRODUCTION_ORDER | GOLDEN_BATCH_REFERENCE | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ShiftAtStart | FACT_PRODUCTION_ORDER | SHIFT_AT_START | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ShiftSupervisorKey | FACT_PRODUCTION_ORDER | SHIFT_SUPERVISOR_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_PRODUCTION_ORDER | SourceBatchIdMartA | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_MART_A | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | SourceBatchIdOps | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_OPS | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | SourceOrderNumOps | FACT_PRODUCTION_ORDER | SOURCE_ORDER_NUM_OPS | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | SourceSystem | FACT_PRODUCTION_ORDER | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | SourceKey | FACT_PRODUCTION_ORDER | _SOURCE_KEY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | LoadedAtUtc | FACT_PRODUCTION_ORDER | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | CreatedAt | FACT_PRODUCTION_ORDER | CREATED_AT | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | CreatedBy | FACT_PRODUCTION_ORDER | CREATED_BY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | UpdatedAt | FACT_PRODUCTION_ORDER | UPDATED_AT | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | UpdatedBy | FACT_PRODUCTION_ORDER | UPDATED_BY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | IsDeleted | FACT_PRODUCTION_ORDER | IS_DELETED | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | DeletedAt | FACT_PRODUCTION_ORDER | DELETED_AT | Direct | — | — | — |
| FACT_BATCH_STEP | BatchStepKey | FACT_BATCH_STEP | BATCH_STEP_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_BATCH_STEP | ProductionOrderKey | FACT_BATCH_STEP | PRODUCTION_ORDER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_BATCH_STEP | CanonicalBatchID | FACT_BATCH_STEP | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | ProcessStepKey | FACT_BATCH_STEP | PROCESS_STEP_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_BATCH_STEP | EquipmentKey | FACT_BATCH_STEP | EQUIPMENT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_BATCH_STEP | StepSequence | FACT_BATCH_STEP | STEP_SEQUENCE | Direct | — | — | — |
| FACT_BATCH_STEP | StepStartUtc | FACT_BATCH_STEP | STEP_START_UTC | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | StepEndUtc | FACT_BATCH_STEP | STEP_END_UTC | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | StepDurationHrs | FACT_BATCH_STEP | STEP_DURATION_HRS | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | InputQuantity | FACT_BATCH_STEP | INPUT_QUANTITY | Direct | Additive | — | — |
| FACT_BATCH_STEP | OutputQuantity | FACT_BATCH_STEP | OUTPUT_QUANTITY | Direct | Additive | — | — |
| FACT_BATCH_STEP | QuantityUom | FACT_BATCH_STEP | QUANTITY_UOM | Direct | — | — | — |
| FACT_BATCH_STEP | StepYieldPct | FACT_BATCH_STEP | STEP_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | StepStatus | FACT_BATCH_STEP | STEP_STATUS | Direct | — | — | — |
| FACT_BATCH_STEP | OperatorKey | FACT_BATCH_STEP | OPERATOR_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_BATCH_STEP | VerifierKey | FACT_BATCH_STEP | VERIFIER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_BATCH_STEP | EsignatureTimestampUtc | FACT_BATCH_STEP | ESIGNATURE_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | EsignatureMeaning | FACT_BATCH_STEP | ESIGNATURE_MEANING | Direct | — | — | — |
| FACT_BATCH_STEP | HasDeviation | FACT_BATCH_STEP | HAS_DEVIATION | Direct | — | — | — |
| FACT_BATCH_STEP | DeviationCount | FACT_BATCH_STEP | DEVIATION_COUNT | Direct | Additive | — | — |
| FACT_BATCH_STEP | StepNotes | FACT_BATCH_STEP | STEP_NOTES | Direct | — | — | — |
| FACT_BATCH_STEP | SourceRunIdMartA | FACT_BATCH_STEP | SOURCE_RUN_ID_MART_A | Direct | — | — | — |
| FACT_BATCH_STEP | SourceStepIdOps | FACT_BATCH_STEP | SOURCE_STEP_ID_OPS | Direct | — | — | — |
| FACT_BATCH_STEP | SourceSystem | FACT_BATCH_STEP | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_BATCH_STEP | SourceKey | FACT_BATCH_STEP | _SOURCE_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | LoadedAtUtc | FACT_BATCH_STEP | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_BATCH_STEP | CreatedAt | FACT_BATCH_STEP | CREATED_AT | Direct | — | — | — |
| FACT_BATCH_STEP | CreatedBy | FACT_BATCH_STEP | CREATED_BY | Direct | — | — | — |
| FACT_BATCH_STEP | UpdatedAt | FACT_BATCH_STEP | UPDATED_AT | Direct | — | — | — |
| FACT_BATCH_STEP | UpdatedBy | FACT_BATCH_STEP | UPDATED_BY | Direct | — | — | — |
| FACT_BATCH_STEP | IsDeleted | FACT_BATCH_STEP | IS_DELETED | Direct | — | — | — |
| FACT_BATCH_STEP | DeletedAt | FACT_BATCH_STEP | DELETED_AT | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | TelemetryKey | FACT_EQUIPMENT_TELEMETRY | TELEMETRY_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | EquipmentKey | FACT_EQUIPMENT_TELEMETRY | EQUIPMENT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | BatchStepKey | FACT_EQUIPMENT_TELEMETRY | BATCH_STEP_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ProductionOrderKey | FACT_EQUIPMENT_TELEMETRY | PRODUCTION_ORDER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalBatchID | FACT_EQUIPMENT_TELEMETRY | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | ParameterKey | FACT_EQUIPMENT_TELEMETRY | PARAMETER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ReadingTimestampUtc | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalValue | FACT_EQUIPMENT_TELEMETRY | CANONICAL_VALUE | Direct | Additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalUom | FACT_EQUIPMENT_TELEMETRY | CANONICAL_UOM | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceValue | FACT_EQUIPMENT_TELEMETRY | SOURCE_VALUE | Direct | Additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceUom | FACT_EQUIPMENT_TELEMETRY | SOURCE_UOM | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ConversionApplied | FACT_EQUIPMENT_TELEMETRY | CONVERSION_APPLIED | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | TargetValue | FACT_EQUIPMENT_TELEMETRY | TARGET_VALUE | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | LowerSpecLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_SPEC_LIMIT | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | UpperSpecLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_SPEC_LIMIT | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | LowerAlertLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_ALERT_LIMIT | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | UpperAlertLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_ALERT_LIMIT | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | WithinSpecification | FACT_EQUIPMENT_TELEMETRY | WITHIN_SPECIFICATION | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | WithinAlert | FACT_EQUIPMENT_TELEMETRY | WITHIN_ALERT | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | DeviationFromTarget | FACT_EQUIPMENT_TELEMETRY | DEVIATION_FROM_TARGET | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | GoldenBatchValue | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_VALUE | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | GoldenBatchDeviation | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_DEVIATION | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | AggregationType | FACT_EQUIPMENT_TELEMETRY | AGGREGATION_TYPE | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceSystemType | FACT_EQUIPMENT_TELEMETRY | SOURCE_SYSTEM_TYPE | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceReadingIdMartA | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_MART_A | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceReadingIdOps | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_OPS | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceSystem | FACT_EQUIPMENT_TELEMETRY | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceKey | FACT_EQUIPMENT_TELEMETRY | _SOURCE_KEY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | LoadedAtUtc | FACT_EQUIPMENT_TELEMETRY | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | CreatedAt | FACT_EQUIPMENT_TELEMETRY | CREATED_AT | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | CreatedBy | FACT_EQUIPMENT_TELEMETRY | CREATED_BY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | IsDeleted | FACT_EQUIPMENT_TELEMETRY | IS_DELETED | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | DeletedAt | FACT_EQUIPMENT_TELEMETRY | DELETED_AT | Direct | — | — | — |
| FACT_DEVIATION | DeviationKey | FACT_DEVIATION | DEVIATION_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_DEVIATION | CanonicalDeviationID | FACT_DEVIATION | CANONICAL_DEVIATION_ID | Direct | Non-additive | — | — |
| FACT_DEVIATION | ProductionOrderKey | FACT_DEVIATION | PRODUCTION_ORDER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | BatchStepKey | FACT_DEVIATION | BATCH_STEP_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | TelemetryKey | FACT_DEVIATION | TELEMETRY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | EquipmentKey | FACT_DEVIATION | EQUIPMENT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | ParameterKey | FACT_DEVIATION | PARAMETER_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | DeviationCategoryKey | FACT_DEVIATION | DEVIATION_CATEGORY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | FacilityKey | FACT_DEVIATION | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | CanonicalBatchID | FACT_DEVIATION | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FACT_DEVIATION | DetectedTimestampUtc | FACT_DEVIATION | DETECTED_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FACT_DEVIATION | DetectedByKey | FACT_DEVIATION | DETECTED_BY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | DetectionMethod | FACT_DEVIATION | DETECTION_METHOD | Direct | — | — | — |
| FACT_DEVIATION | SeverityCode | FACT_DEVIATION | SEVERITY_CODE | Direct | — | — | — |
| FACT_DEVIATION | PotentialImpact | FACT_DEVIATION | POTENTIAL_IMPACT | Direct | — | — | — |
| FACT_DEVIATION | DeviationDescription | FACT_DEVIATION | DEVIATION_DESCRIPTION | Direct | — | — | — |
| FACT_DEVIATION | InvestigationStatus | FACT_DEVIATION | INVESTIGATION_STATUS | Direct | — | — | — |
| FACT_DEVIATION | AssignedToKey | FACT_DEVIATION | ASSIGNED_TO_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | InvestigationStartUtc | FACT_DEVIATION | INVESTIGATION_START_UTC | Direct | Non-additive | — | — |
| FACT_DEVIATION | InvestigationEndUtc | FACT_DEVIATION | INVESTIGATION_END_UTC | Direct | Non-additive | — | — |
| FACT_DEVIATION | RootCauseCode | FACT_DEVIATION | ROOT_CAUSE_CODE | Direct | — | — | — |
| FACT_DEVIATION | RootCauseDescription | FACT_DEVIATION | ROOT_CAUSE_DESCRIPTION | Direct | — | — | — |
| FACT_DEVIATION | CapaRequired | FACT_DEVIATION | CAPA_REQUIRED | Direct | — | — | — |
| FACT_DEVIATION | CapaReferenceId | FACT_DEVIATION | CAPA_REFERENCE_ID | Direct | — | — | — |
| FACT_DEVIATION | CapaDueDate | FACT_DEVIATION | CAPA_DUE_DATE | Direct | — | — | — |
| FACT_DEVIATION | CapaClosedDate | FACT_DEVIATION | CAPA_CLOSED_DATE | Direct | — | — | — |
| FACT_DEVIATION | ClosedTimestampUtc | FACT_DEVIATION | CLOSED_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FACT_DEVIATION | ClosedByKey | FACT_DEVIATION | CLOSED_BY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_DEVIATION | ResolutionSummary | FACT_DEVIATION | RESOLUTION_SUMMARY | Direct | — | — | — |
| FACT_DEVIATION | RegulatoryNotificationRequired | FACT_DEVIATION | REGULATORY_NOTIFICATION_REQUIRED | Direct | — | — | — |
| FACT_DEVIATION | RegulatoryNotifiedDate | FACT_DEVIATION | REGULATORY_NOTIFIED_DATE | Direct | — | — | — |
| FACT_DEVIATION | SourceDevIdMartA | FACT_DEVIATION | SOURCE_DEV_ID_MART_A | Direct | — | — | — |
| FACT_DEVIATION | SourceDevNumOps | FACT_DEVIATION | SOURCE_DEV_NUM_OPS | Direct | — | — | — |
| FACT_DEVIATION | SourceSystem | FACT_DEVIATION | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_DEVIATION | SourceKey | FACT_DEVIATION | _SOURCE_KEY | Direct | — | — | — |
| FACT_DEVIATION | LoadedAtUtc | FACT_DEVIATION | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_DEVIATION | CreatedAt | FACT_DEVIATION | CREATED_AT | Direct | — | — | — |
| FACT_DEVIATION | CreatedBy | FACT_DEVIATION | CREATED_BY | Direct | — | — | — |
| FACT_DEVIATION | UpdatedAt | FACT_DEVIATION | UPDATED_AT | Direct | — | — | — |
| FACT_DEVIATION | UpdatedBy | FACT_DEVIATION | UPDATED_BY | Direct | — | — | — |
| FACT_DEVIATION | IsDeleted | FACT_DEVIATION | IS_DELETED | Direct | — | — | — |
| FACT_DEVIATION | DeletedAt | FACT_DEVIATION | DELETED_AT | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | YieldAnalyticsKey | FACT_YIELD_ANALYTICS | YIELD_ANALYTICS_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_YIELD_ANALYTICS | AnalysisDate | FACT_YIELD_ANALYTICS | ANALYSIS_DATE | Direct; also mapped to DIM_DATE.DateKey via YYYYMMDD cast | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | FacilityKey | FACT_YIELD_ANALYTICS | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_YIELD_ANALYTICS | ProductKey | FACT_YIELD_ANALYTICS | PRODUCT_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_YIELD_ANALYTICS | AggregationLevel | FACT_YIELD_ANALYTICS | AGGREGATION_LEVEL | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | BatchesStarted | FACT_YIELD_ANALYTICS | BATCHES_STARTED | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | BatchesCompleted | FACT_YIELD_ANALYTICS | BATCHES_COMPLETED | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | BatchesOnHold | FACT_YIELD_ANALYTICS | BATCHES_ON_HOLD | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | BatchesFailed | FACT_YIELD_ANALYTICS | BATCHES_FAILED | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | AvgYieldPct | FACT_YIELD_ANALYTICS | AVG_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | MinYieldPct | FACT_YIELD_ANALYTICS | MIN_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | MaxYieldPct | FACT_YIELD_ANALYTICS | MAX_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | StdYieldPct | FACT_YIELD_ANALYTICS | STD_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | YieldBelowTargetCount | FACT_YIELD_ANALYTICS | YIELD_BELOW_TARGET_COUNT | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | YieldTargetAttainmentPct | FACT_YIELD_ANALYTICS | YIELD_TARGET_ATTAINMENT_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | TotalPlannedQty | FACT_YIELD_ANALYTICS | TOTAL_PLANNED_QTY | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | TotalActualQty | FACT_YIELD_ANALYTICS | TOTAL_ACTUAL_QTY | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | QuantityUom | FACT_YIELD_ANALYTICS | QUANTITY_UOM | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | AvgOeePct | FACT_YIELD_ANALYTICS | AVG_OEE_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | AvgAvailabilityPct | FACT_YIELD_ANALYTICS | AVG_AVAILABILITY_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | AvgPerformancePct | FACT_YIELD_ANALYTICS | AVG_PERFORMANCE_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | AvgQualityPct | FACT_YIELD_ANALYTICS | AVG_QUALITY_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | TotalDeviations | FACT_YIELD_ANALYTICS | TOTAL_DEVIATIONS | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | HighCriticalDeviations | FACT_YIELD_ANALYTICS | HIGH_CRITICAL_DEVIATIONS | Direct | Additive | — | — |
| FACT_YIELD_ANALYTICS | CppComplianceRatePct | FACT_YIELD_ANALYTICS | CPP_COMPLIANCE_RATE_PCT | Direct | Non-additive | — | — |
| FACT_YIELD_ANALYTICS | SourceSystem | FACT_YIELD_ANALYTICS | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | SourceKey | FACT_YIELD_ANALYTICS | _SOURCE_KEY | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | LoadedAtUtc | FACT_YIELD_ANALYTICS | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | CreatedAt | FACT_YIELD_ANALYTICS | CREATED_AT | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | CreatedBy | FACT_YIELD_ANALYTICS | CREATED_BY | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | UpdatedAt | FACT_YIELD_ANALYTICS | UPDATED_AT | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | UpdatedBy | FACT_YIELD_ANALYTICS | UPDATED_BY | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | IsDeleted | FACT_YIELD_ANALYTICS | IS_DELETED | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | DeletedAt | FACT_YIELD_ANALYTICS | DELETED_AT | Direct | — | — | — |
| FACT_SHIFT_LOG | ShiftLogKey | FACT_SHIFT_LOG | SHIFT_LOG_KEY | Surrogate Key (system-generated INTEGER, auto-increment in warehouse) | — | — | — |
| FACT_SHIFT_LOG | FacilityKey | FACT_SHIFT_LOG | FACILITY_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_SHIFT_LOG | LogDate | FACT_SHIFT_LOG | LOG_DATE | Direct; also mapped to DIM_DATE.DateKey via YYYYMMDD cast | Non-additive | — | — |
| FACT_SHIFT_LOG | ShiftName | FACT_SHIFT_LOG | SHIFT_NAME | Direct | — | — | — |
| FACT_SHIFT_LOG | ShiftStartUtc | FACT_SHIFT_LOG | SHIFT_START_UTC | Direct | Non-additive | — | — |
| FACT_SHIFT_LOG | ShiftEndUtc | FACT_SHIFT_LOG | SHIFT_END_UTC | Direct | Non-additive | — | — |
| FACT_SHIFT_LOG | SupervisorKey | FACT_SHIFT_LOG | SUPERVISOR_KEY | Direct; cast NUMBER to INTEGER | — | — | — |
| FACT_SHIFT_LOG | ActiveBatches | FACT_SHIFT_LOG | ACTIVE_BATCHES | Direct | Additive | — | — |
| FACT_SHIFT_LOG | CompletedBatches | FACT_SHIFT_LOG | COMPLETED_BATCHES | Direct | Additive | — | — |
| FACT_SHIFT_LOG | NewDeviations | FACT_SHIFT_LOG | NEW_DEVIATIONS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | ClosedDeviations | FACT_SHIFT_LOG | CLOSED_DEVIATIONS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | EquipmentDowntimeMins | FACT_SHIFT_LOG | EQUIPMENT_DOWNTIME_MINS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | EquipmentIssuesCount | FACT_SHIFT_LOG | EQUIPMENT_ISSUES_COUNT | Direct | Additive | — | — |
| FACT_SHIFT_LOG | SignedOff | FACT_SHIFT_LOG | SIGNED_OFF | Direct | — | — | — |
| FACT_SHIFT_LOG | SignedOffUtc | FACT_SHIFT_LOG | SIGNED_OFF_UTC | Direct | Non-additive | — | — |
| FACT_SHIFT_LOG | ShiftNotes | FACT_SHIFT_LOG | SHIFT_NOTES | Direct | — | — | — |
| FACT_SHIFT_LOG | SourceLogIdMartA | FACT_SHIFT_LOG | SOURCE_LOG_ID_MART_A | Direct | — | — | — |
| FACT_SHIFT_LOG | SourceSystem | FACT_SHIFT_LOG | _SOURCE_SYSTEM | Direct | — | — | — |
| FACT_SHIFT_LOG | SourceKey | FACT_SHIFT_LOG | _SOURCE_KEY | Direct | — | — | — |
| FACT_SHIFT_LOG | LoadedAtUtc | FACT_SHIFT_LOG | _LOADED_AT_UTC | Direct | — | — | — |
| FACT_SHIFT_LOG | CreatedAt | FACT_SHIFT_LOG | CREATED_AT | Direct | — | — | — |
| FACT_SHIFT_LOG | CreatedBy | FACT_SHIFT_LOG | CREATED_BY | Direct | — | — | — |
| FACT_SHIFT_LOG | UpdatedAt | FACT_SHIFT_LOG | UPDATED_AT | Direct | — | — | — |
| FACT_SHIFT_LOG | UpdatedBy | FACT_SHIFT_LOG | UPDATED_BY | Direct | — | — | — |
| FACT_SHIFT_LOG | IsDeleted | FACT_SHIFT_LOG | IS_DELETED | Direct | — | — | — |
| FACT_SHIFT_LOG | DeletedAt | FACT_SHIFT_LOG | DELETED_AT | Direct | — | — | — |
| DIM_DATE | DateKey | — | — | Surrogate Key (system-generated INTEGER; derived from FullDate as YYYYMMDD) | — | Type 2 | — |
| DIM_DATE | FullDate | FACT_YIELD_ANALYTICS / FACT_SHIFT_LOG / FACT_PRODUCTION_ORDER (date component of timestamps) | ANALYSIS_DATE / LOG_DATE / PLANNED_START_UTC | Derived: truncate timestamps to DATE | — | Type 2 | — |
| DIM_DATE | Day | DIM_DATE | (from FullDate) | Derived: EXTRACT(DAY FROM FullDate) | — | Type 2 | — |
| DIM_DATE | Month | DIM_DATE | (from FullDate) | Derived: EXTRACT(MONTH FROM FullDate) | — | Type 2 | — |
| DIM_DATE | MonthName | DIM_DATE | (from FullDate) | Derived: TO_CHAR(FullDate,'Mon') | — | Type 2 | — |
| DIM_DATE | Quarter | DIM_DATE | (from FullDate) | Derived: EXTRACT(QUARTER FROM FullDate) | — | Type 2 | — |
| DIM_DATE | Year | DIM_DATE | (from FullDate) | Derived: EXTRACT(YEAR FROM FullDate) | — | Type 2 | — |
| DIM_DATE | WeekNumber | DIM_DATE | (from FullDate) | Derived: ISO week number | — | Type 2 | — |
| DIM_DATE | DayOfWeek | DIM_DATE | (from FullDate) | Derived: EXTRACT(DOW FROM FullDate) | — | Type 2 | — |
| DIM_DATE | DayName | DIM_DATE | (from FullDate) | Derived: TO_CHAR(FullDate,'Dy') | — | Type 2 | — |
| DIM_DATE | IsWeekend | DIM_DATE | (from FullDate) | Derived: CASE WHEN DayOfWeek IN (6,7) THEN TRUE ELSE FALSE END | — | Type 2 | — |
| DIM_DATE | IsHoliday | DIM_DATE | (external calendar) | — | Lookup from holiday reference table | — | Type 2 | — |
| DIM_DATE | FiscalYear | DIM_DATE | (from FullDate) | Derived per enterprise fiscal calendar | — | Type 2 | — |
| DIM_DATE | FiscalQuarter | DIM_DATE | (from FullDate) | Derived per enterprise fiscal calendar | — | Type 2 | — |