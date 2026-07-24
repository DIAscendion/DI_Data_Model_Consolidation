### Section 1 — Modeling Summary

| Metric | Detail |
|----------------------------|-----------------------------------------------|
| Central Business Process | Batch Production & Execution |
| Fact Table(s) | FACT_PRODUCTION_ORDER, FACT_BATCH_STEP, FACT_EQUIPMENT_TELEMETRY, FACT_DEVIATION, FACT_YIELD_ANALYTICS, FACT_SHIFT_LOG |
| Dimension Tables | DIM_ORGANIZATION, DIM_FACILITY, DIM_PRODUCT, DIM_MATERIAL_LOT, DIM_EQUIPMENT, DIM_PROCESS_STEP, DIM_PROCESS_PARAMETER, DIM_QUALITY_DISPOSITION, DIM_DEVIATION_CATEGORY, DIM_OPERATOR, DIM_DATE |
| Total Fact Measures | 52 |
| Total Dimension Attributes | 153 |
| SCD Type 2 Dimensions | DIM_FACILITY, DIM_PRODUCT, DIM_EQUIPMENT (qualification/status attributes treated as Type 2 in analytics view), DIM_DATE (slowly changing calendar attributes handled via reload strategy) |
| PII-masked Columns | 0 |

---

### Section 2 — Star Schema Definition

#### Dimension Table: DIM_ORGANIZATION

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OrganizationKey | INTEGER | Primary Key | Surrogate key (from ORGANIZATION_KEY) |
| OrganizationID | VARCHAR(50) | Natural Key | From canonical ORGANIZATION_ID |
| OrganizationName | VARCHAR(200) | Attribute | Full legal name |
| OrganizationType | VARCHAR(80) | Attribute | COMPANY, DIVISION, BUSINESS_UNIT, SUBSIDIARY |
| ParentOrganizationKey | INTEGER | Attribute | Hierarchy parent (PARENT_ORGANIZATION_KEY) |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 |
| RegulatoryRegion | VARCHAR(80) | Attribute | Regulatory jurisdiction |
| IsActive | BOOLEAN | Attribute | Active flag |
| EffectiveStartDate | DATE | SCD Type 2 | Start date of record version |
| EffectiveEndDate | DATE | SCD Type 2 | End date of record version |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_FACILITY

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| FacilityKey | INTEGER | Primary Key | Surrogate key (from FACILITY_KEY) |
| FacilityID | VARCHAR(50) | Natural Key | Enterprise facility code |
| FacilityName | VARCHAR(200) | Attribute | Official facility name |
| FacilityShortName | VARCHAR(80) | Attribute | Common short name |
| OrganizationKey | INTEGER | Foreign Key → DIM_ORGANIZATION | Parent organization |
| SiteCode | VARCHAR(20) | Attribute | Short site code |
| FacilityType | VARCHAR(80) | Attribute | MANUFACTURING, PACKAGING, QC_LAB, etc. |
| AddressLine1 | VARCHAR(200) | Attribute | Street address line 1 |
| AddressLine2 | VARCHAR(200) | Attribute | Street address line 2 |
| City | VARCHAR(100) | Attribute | City |
| StateRegion | VARCHAR(100) | Attribute | State or region |
| PostalCode | VARCHAR(20) | Attribute | Postal or ZIP code |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 |
| TimezoneName | VARCHAR(80) | Attribute | IANA timezone |
| UtcOffsetHours | DECIMAL(4,2) | Attribute | UTC offset in hours |
| GmpCertified | BOOLEAN | Attribute | GMP certification flag |
| GmpCertificationDate | DATE | Attribute | GMP certification date |
| GmpExpiryDate | DATE | Attribute | GMP expiry date |
| RegulatoryAgency | VARCHAR(80) | Attribute | Primary regulatory agency |
| FdaEstablishmentId | VARCHAR(50) | Attribute | FDA Establishment ID |
| EmaSiteCode | VARCHAR(50) | Attribute | EMA site code |
| ManufacturingCapacity | VARCHAR(80) | Attribute | CLINICAL, COMMERCIAL, BOTH |
| SourceSiteCodeMartA | VARCHAR(20) | Attribute | Site code in Mart A |
| SourcePlantCodeOps | VARCHAR(30) | Attribute | Plant code in Operational System |
| SourceFacCodeMartB | VARCHAR(30) | Attribute | Facility code in Mart B |
| EffectiveStartDate | DATE | SCD Type 2 | Start of record version |
| EffectiveEndDate | DATE | SCD Type 2 | End of record version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Current version flag |
| ScdVersion | NUMBER | SCD Type 2 | Version number |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_PRODUCT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProductKey | INTEGER | Primary Key | Surrogate key (from PRODUCT_KEY) |
| ProductID | VARCHAR(50) | Natural Key | Enterprise product ID |
| Sku | VARCHAR(60) | Attribute | Stock Keeping Unit |
| ProductName | VARCHAR(200) | Attribute | Official product name |
| ProductShortName | VARCHAR(80) | Attribute | Abbreviated name |
| OrganizationKey | INTEGER | Foreign Key → DIM_ORGANIZATION | Owning organization |
| FormulationId | VARCHAR(60) | Attribute | Formulation specification ID |
| FormulationVersion | VARCHAR(20) | Attribute | Formulation version |
| DosageForm | VARCHAR(80) | Attribute | Pharmaceutical form |
| DosageStrength | VARCHAR(80) | Attribute | Strength descriptor |
| RouteOfAdministration | VARCHAR(80) | Attribute | Route of administration |
| TherapeuticClass | VARCHAR(100) | Attribute | Therapeutic category |
| TherapeuticArea | VARCHAR(100) | Attribute | Disease area |
| ProductCategory | VARCHAR(80) | Attribute | Product category |
| IsBiosimilar | BOOLEAN | Attribute | Biosimilar flag |
| ReferenceProductId | VARCHAR(50) | Attribute | Reference originator product ID |
| InnName | VARCHAR(200) | Attribute | International Nonproprietary Name |
| IdmpMpid | VARCHAR(100) | Attribute | IDMP Medicinal Product Identifier |
| NdaBlaNumber | VARCHAR(50) | Attribute | FDA NDA/BLA number |
| EmaProductNumber | VARCHAR(50) | Attribute | EMA product number |
| StandardYieldPct | DECIMAL(6,3) | Attribute | Target yield percentage |
| YieldLowerAlertPct | DECIMAL(6,3) | Attribute | Yield alert threshold |
| YieldLowerActionPct | DECIMAL(6,3) | Attribute | Yield action limit |
| ShelfLifeMonths | NUMBER | Attribute | Shelf life in months |
| StorageCondition | VARCHAR(80) | Attribute | Storage condition |
| EffectiveStartDate | DATE | SCD Type 2 | Start of record version |
| EffectiveEndDate | DATE | SCD Type 2 | End of record version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Current version flag |
| ScdVersion | NUMBER | SCD Type 2 | Version number |
| SourceProductCodeMartA | VARCHAR(50) | Attribute | Product code in Mart A |
| SourceProductCodeOps | VARCHAR(50) | Attribute | Product code in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_MATERIAL_LOT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| MaterialLotKey | INTEGER | Primary Key | Surrogate key (from MATERIAL_LOT_KEY) |
| LotNumber | VARCHAR(80) | Natural Key | GMP lot number |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Finished product or intermediate |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility where lot is manufactured or received |
| LotType | VARCHAR(50) | Attribute | FINISHED_GOOD, INTERMEDIATE, RAW_MATERIAL, etc. |
| ManufactureDate | DATE | Attribute | Manufacture or receipt date |
| ExpiryDate | DATE | Attribute | Expiry date |
| RetestDate | DATE | Attribute | Retest date |
| QuantityProduced | DECIMAL(18,3) | Attribute | Quantity produced or received |
| QuantityUnit | VARCHAR(20) | Attribute | Unit of measure |
| LotStatus | VARCHAR(40) | Attribute | Lot status |
| CertificateOfAnalysis | VARCHAR(200) | Attribute | COA document reference |
| VendorLotNumber | VARCHAR(80) | Attribute | Supplier lot number |
| VendorID | VARCHAR(80) | Attribute | Supplier identifier |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_EQUIPMENT

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| EquipmentKey | INTEGER | Primary Key | Surrogate key (from EQUIPMENT_KEY) |
| CanonicalEquipmentID | VARCHAR(50) | Natural Key | Canonical enterprise equipment ID |
| EquipmentName | VARCHAR(200) | Attribute | Full descriptive name |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility where equipment is located |
| FunctionalArea | VARCHAR(80) | Attribute | ISA-95 area |
| ProductionUnit | VARCHAR(80) | Attribute | ISA-95 production unit |
| EquipmentModule | VARCHAR(80) | Attribute | ISA-95 equipment module |
| AssetClass | VARCHAR(80) | Attribute | Broad asset class |
| AssetSubClass | VARCHAR(80) | Attribute | Asset subclass |
| CriticalityRating | VARCHAR(20) | Attribute | GMP criticality rating |
| ManufacturerName | VARCHAR(100) | Attribute | Manufacturer name |
| ModelNumber | VARCHAR(100) | Attribute | Equipment model number |
| SerialNumber | VARCHAR(100) | Attribute | Manufacturer serial number |
| WorkingVolumeL | DECIMAL(12,3) | Attribute | Working volume (litres) |
| InstallationDate | DATE | Attribute | Installation date |
| CommissioningDate | DATE | Attribute | Commissioning date |
| QualificationStatus | VARCHAR(30) | Attribute | QUALIFIED, PENDING, etc. |
| LastQualificationDate | DATE | Attribute | Last qualification date |
| NextQualificationDate | DATE | Attribute | Next qualification date |
| CalibrationFrequency | VARCHAR(30) | Attribute | Calibration frequency |
| LastCalibrationDate | DATE | Attribute | Last calibration completion date |
| CalibrationDueDate | DATE | Attribute | Next calibration due date |
| CalibrationStatus | VARCHAR(30) | Attribute | Calibration compliance status |
| PlannedRuntimeMinsPerDay | NUMBER | Attribute | Planned runtime per day |
| IdealCycleTimeSecs | DECIMAL(12,4) | Attribute | Ideal cycle time in seconds |
| EquipmentStatus | VARCHAR(30) | Attribute | ACTIVE, UNDER_MAINTENANCE, INACTIVE, RETIRED |
| StatusEffectiveDate | DATE | Attribute | Status effective date |
| DecommissionDate | DATE | Attribute | Decommission date |
| SourceEquipIdMartA | VARCHAR(50) | Attribute | Equipment ID in Mart A |
| SourceAssetCodeOps | VARCHAR(50) | Attribute | Asset code in Operational System |
| SourceEquipCodeMartB | VARCHAR(50) | Attribute | Equipment code in Mart B |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_PROCESS_STEP

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessStepKey | INTEGER | Primary Key | Surrogate key (from PROCESS_STEP_KEY) |
| StepCode | VARCHAR(40) | Natural Key | Canonical step code |
| StepName | VARCHAR(100) | Attribute | Full step name |
| StepCategory | VARCHAR(60) | Attribute | Step category |
| StepSubcategory | VARCHAR(60) | Attribute | Step subcategory |
| TypicalSequenceOrder | NUMBER | Attribute | Typical sequence position |
| ExpectedDurationMinHrs | DECIMAL(8,2) | Attribute | Minimum expected duration |
| ExpectedDurationMaxHrs | DECIMAL(8,2) | Attribute | Maximum expected duration |
| ApplicableAssetClasses | VARCHAR(200) | Attribute | Applicable asset classes |
| IsCcp | BOOLEAN | Attribute | Critical Control Point flag |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_PROCESS_PARAMETER

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ParameterKey | INTEGER | Primary Key | Surrogate key (from PARAMETER_KEY) |
| ParameterCode | VARCHAR(60) | Natural Key | Canonical parameter code |
| ParameterName | VARCHAR(150) | Attribute | Full parameter name |
| ParameterCategory | VARCHAR(60) | Attribute | Parameter category |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceUomMartA | VARCHAR(30) | Attribute | Source UOM in Mart A |
| SourceUomOps | VARCHAR(30) | Attribute | Source UOM in Operational System |
| SourceUomMartB | VARCHAR(30) | Attribute | Source UOM in Mart B |
| ConversionFormulaOps | VARCHAR(200) | Attribute | UOM conversion formula from Ops to canonical |
| IsCpp | BOOLEAN | Attribute | Critical Process Parameter flag |
| IsKpa | BOOLEAN | Attribute | Key Process Attribute flag |
| TypicalTarget | DECIMAL(18,4) | Attribute | Typical target value |
| TypicalLsl | DECIMAL(18,4) | Attribute | Typical lower spec limit |
| TypicalUsl | DECIMAL(18,4) | Attribute | Typical upper spec limit |
| MeasurementFrequency | VARCHAR(50) | Attribute | Measurement frequency |
| InstrumentType | VARCHAR(100) | Attribute | Instrument type |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_QUALITY_DISPOSITION

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DispositionKey | INTEGER | Primary Key | Surrogate key (from DISPOSITION_KEY) |
| DispositionCode | VARCHAR(40) | Natural Key | Canonical disposition code |
| DispositionName | VARCHAR(100) | Attribute | Full disposition name |
| RequiresInvestigation | BOOLEAN | Attribute | Investigation required flag |
| CommerciallyReleasable | BOOLEAN | Attribute | Commercial release eligibility |
| DeviationImplied | BOOLEAN | Attribute | Deviation implied flag |
| PatientRiskLevel | VARCHAR(20) | Attribute | Patient risk level |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification flag |
| DispositionDescription | VARCHAR(500) | Attribute | Disposition description |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceCodeMartA | VARCHAR(40) | Attribute | Equivalent code in Mart A |
| SourceCodeMartB | VARCHAR(40) | Attribute | Equivalent code in Mart B |
| SourceCodeOps | VARCHAR(10) | Attribute | Equivalent code in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_DEVIATION_CATEGORY

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DeviationCategoryKey | INTEGER | Primary Key | Surrogate key (from DEVIATION_CATEGORY_KEY) |
| CategoryCode | VARCHAR(50) | Natural Key | Deviation category code |
| CategoryName | VARCHAR(100) | Attribute | Full category name |
| CategoryGroup | VARCHAR(80) | Attribute | High-level grouping |
| Description | VARCHAR(500) | Attribute | Category description |
| CapaTypicallyRequired | BOOLEAN | Attribute | CAPA typically required flag |
| IsActive | BOOLEAN | Attribute | Active flag |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Dimension Table: DIM_OPERATOR

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OperatorKey | INTEGER | Primary Key | Surrogate key (from OPERATOR_KEY) |
| OperatorID | VARCHAR(50) | Natural Key | System operator ID |
| FullName | VARCHAR(200) | Attribute | Full legal name |
| RoleCode | VARCHAR(50) | Attribute | Role code |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Primary facility |
| Department | VARCHAR(100) | Attribute | Department |
| IsGmpTrained | BOOLEAN | Attribute | GMP training flag |
| TrainingExpiryDate | DATE | Attribute | Training expiry date |
| EsignatureEnabled | BOOLEAN | Attribute | Electronic signature enabled flag |
| EmploymentStatus | VARCHAR(30) | Attribute | Employment status |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

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
| DayOfWeek | INTEGER | Attribute | Day of week (1-7) |
| DayName | VARCHAR(20) | Attribute | Day name |
| IsWeekend | BOOLEAN | Attribute | Weekend flag |
| IsHoliday | BOOLEAN | Attribute | Holiday flag |
| FiscalYear | INTEGER | Attribute | Fiscal year |
| FiscalQuarter | INTEGER | Attribute | Fiscal quarter |

---

#### Fact Table: FACT_PRODUCTION_ORDER

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ProductionOrderKey | INTEGER | Primary Key | Surrogate key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier |
| ErpOrderNumber | VARCHAR(50) | Attribute | ERP production order number |
| MesBatchReference | VARCHAR(80) | Attribute | MES internal batch reference |
| GmpLotNumber | VARCHAR(80) | Attribute | GMP lot number |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility dimension key |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Product dimension key |
| PrimaryEquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Primary equipment dimension key |
| DispositionKey | INTEGER | Foreign Key → DIM_QUALITY_DISPOSITION | Quality disposition dimension key |
| PlannedStartDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from PLANNED_START_UTC |
| PlannedEndDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from PLANNED_END_UTC |
| ActualStartDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from ACTUAL_START_UTC |
| ActualEndDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from ACTUAL_END_UTC |
| PlannedQuantity | DECIMAL(18,3) | Measure (Additive) | Planned output quantity |
| QuantityUom | VARCHAR(20) | Attribute | Unit of measure |
| ActualQuantity | DECIMAL(18,3) | Measure (Additive) | Actual quantity produced |
| YieldPct | DECIMAL(6,3) | Measure (Non-additive) | Overall batch yield percentage |
| YieldVariancePct | DECIMAL(8,4) | Measure (Non-additive) | Variance vs standard yield |
| OeeAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Availability component |
| OeePerformancePct | DECIMAL(6,3) | Measure (Non-additive) | OEE Performance component |
| OeeQualityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Quality component |
| OeeOverallPct | DECIMAL(6,3) | Measure (Non-additive) | Overall equipment effectiveness |
| BatchStatus | VARCHAR(30) | Attribute | Canonical batch status |
| DeviationCount | NUMBER | Measure (Additive) | Total deviations for the batch |
| IsGoldenBatch | BOOLEAN | Attribute | Golden batch flag |
| GoldenBatchReference | VARCHAR(50) | Attribute | Reference golden batch ID |
| ShiftAtStart | VARCHAR(20) | Attribute | Shift at start |
| ShiftSupervisorKey | INTEGER | Foreign Key → DIM_OPERATOR | Supervisor for the start shift |
| SourceBatchIdMartA | VARCHAR(50) | Attribute | Batch ID in Mart A |
| SourceBatchIdOps | VARCHAR(50) | Attribute | Batch ID in Operational System |
| SourceOrderNumOps | VARCHAR(50) | Attribute | Production order in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Fact Table: FACT_BATCH_STEP

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| BatchStepKey | INTEGER | Primary Key | Surrogate key |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order fact key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Denormalized batch ID |
| ProcessStepKey | INTEGER | Foreign Key → DIM_PROCESS_STEP | Process step dimension key |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment dimension key |
| StepSequence | NUMBER | Attribute | Execution order within batch |
| StepStartDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from STEP_START_UTC |
| StepEndDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from STEP_END_UTC |
| StepDurationHrs | DECIMAL(10,4) | Measure (Non-additive) | Step duration in hours |
| InputQuantity | DECIMAL(18,3) | Measure (Additive) | Input quantity |
| OutputQuantity | DECIMAL(18,3) | Measure (Additive) | Output quantity |
| QuantityUom | VARCHAR(20) | Attribute | Unit of measure |
| StepYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Step-level yield percentage |
| StepStatus | VARCHAR(30) | Attribute | Canonical step status |
| OperatorKey | INTEGER | Foreign Key → DIM_OPERATOR | Executing operator |
| VerifierKey | INTEGER | Foreign Key → DIM_OPERATOR | Verification operator |
| EsignatureTimestampUtc | TIMESTAMP_TZ | Attribute | Electronic signature timestamp |
| EsignatureMeaning | VARCHAR(200) | Attribute | Electronic signature meaning |
| HasDeviation | BOOLEAN | Attribute | Deviation linked flag |
| DeviationCount | NUMBER | Measure (Additive) | Number of deviations linked |
| StepNotes | VARCHAR(2000) | Attribute | Step narrative notes |
| SourceRunIdMartA | VARCHAR(50) | Attribute | Run ID in Mart A |
| SourceStepIdOps | NUMBER | Attribute | Step ID in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Fact Table: FACT_EQUIPMENT_TELEMETRY

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| TelemetryKey | INTEGER | Primary Key | Surrogate key |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment dimension key |
| BatchStepKey | INTEGER | Foreign Key → FACT_BATCH_STEP | Batch step fact key |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order fact key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Denormalized canonical batch ID |
| ParameterKey | INTEGER | Foreign Key → DIM_PROCESS_PARAMETER | Process parameter dimension key |
| ReadingDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from READING_TIMESTAMP_UTC |
| ReadingTimestampUtc | TIMESTAMP_TZ | Attribute | Reading timestamp in UTC |
| CanonicalValue | DECIMAL(18,4) | Measure (Semi-additive) | Value in canonical UOM |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceValue | DECIMAL(18,4) | Measure (Semi-additive) | Original source value |
| SourceUom | VARCHAR(30) | Attribute | Original source UOM |
| ConversionApplied | VARCHAR(200) | Attribute | Conversion formula applied |
| TargetValue | DECIMAL(18,4) | Measure (Semi-additive) | Target value |
| LowerSpecLimit | DECIMAL(18,4) | Measure (Semi-additive) | Lower spec limit |
| UpperSpecLimit | DECIMAL(18,4) | Measure (Semi-additive) | Upper spec limit |
| LowerAlertLimit | DECIMAL(18,4) | Measure (Semi-additive) | Lower alert limit |
| UpperAlertLimit | DECIMAL(18,4) | Measure (Semi-additive) | Upper alert limit |
| WithinSpecification | BOOLEAN | Attribute | Within specification flag |
| WithinAlert | BOOLEAN | Attribute | Within alert flag |
| DeviationFromTarget | DECIMAL(18,4) | Measure (Non-additive) | Deviation from target |
| GoldenBatchValue | DECIMAL(18,4) | Measure (Semi-additive) | Golden batch comparison value |
| GoldenBatchDeviation | DECIMAL(18,4) | Measure (Non-additive) | Deviation from golden batch |
| AggregationType | VARCHAR(30) | Attribute | RAW or aggregation indicator |
| SourceSystemType | VARCHAR(30) | Attribute | Source system type |
| SourceReadingIdMartA | VARCHAR(60) | Attribute | Reading ID in Mart A |
| SourceReadingIdOps | NUMBER | Attribute | Reading ID in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Fact Table: FACT_DEVIATION

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| DeviationKey | INTEGER | Primary Key | Surrogate key |
| CanonicalDeviationID | VARCHAR(60) | Attribute | Canonical deviation number |
| ProductionOrderKey | INTEGER | Foreign Key → FACT_PRODUCTION_ORDER | Production order fact key |
| BatchStepKey | INTEGER | Foreign Key → FACT_BATCH_STEP | Batch step fact key |
| TelemetryKey | INTEGER | Foreign Key → FACT_EQUIPMENT_TELEMETRY | Triggering telemetry fact key |
| EquipmentKey | INTEGER | Foreign Key → DIM_EQUIPMENT | Equipment dimension key |
| ParameterKey | INTEGER | Foreign Key → DIM_PROCESS_PARAMETER | Process parameter dimension key |
| DeviationCategoryKey | INTEGER | Foreign Key → DIM_DEVIATION_CATEGORY | Deviation category dimension key |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility dimension key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Denormalized canonical batch ID |
| DetectedDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from DETECTED_TIMESTAMP_UTC |
| DetectedTimestampUtc | TIMESTAMP_TZ | Attribute | Deviation detection timestamp |
| DetectedByKey | INTEGER | Foreign Key → DIM_OPERATOR | Detecting operator |
| DetectionMethod | VARCHAR(80) | Attribute | Detection method |
| SeverityCode | VARCHAR(20) | Attribute | Severity code |
| PotentialImpact | VARCHAR(200) | Attribute | Potential impact description |
| DeviationDescription | VARCHAR(4000) | Attribute | Full deviation description |
| InvestigationStatus | VARCHAR(30) | Attribute | Investigation status |
| AssignedToKey | INTEGER | Foreign Key → DIM_OPERATOR | Assigned investigator |
| InvestigationStartUtc | TIMESTAMP_TZ | Attribute | Investigation start timestamp |
| InvestigationEndUtc | TIMESTAMP_TZ | Attribute | Investigation end timestamp |
| RootCauseCode | VARCHAR(80) | Attribute | Root cause category |
| RootCauseDescription | VARCHAR(2000) | Attribute | Root cause description |
| CapaRequired | BOOLEAN | Attribute | CAPA required flag |
| CapaReferenceID | VARCHAR(60) | Attribute | CAPA reference ID |
| CapaDueDate | DATE | Attribute | CAPA due date |
| CapaClosedDate | DATE | Attribute | CAPA closed date |
| ClosedTimestampUtc | TIMESTAMP_TZ | Attribute | Deviation closed timestamp |
| ClosedByKey | INTEGER | Foreign Key → DIM_OPERATOR | Closing operator |
| ResolutionSummary | VARCHAR(4000) | Attribute | Resolution summary |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification required flag |
| RegulatoryNotifiedDate | DATE | Attribute | Regulatory notified date |
| SourceDevIdMartA | VARCHAR(50) | Attribute | Deviation ID in Mart A |
| SourceDevNumOps | VARCHAR(50) | Attribute | Deviation number in Operational System |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Fact Table: FACT_YIELD_ANALYTICS

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| YieldAnalyticsKey | INTEGER | Primary Key | Surrogate key |
| AnalysisDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from ANALYSIS_DATE |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility dimension key |
| ProductKey | INTEGER | Foreign Key → DIM_PRODUCT | Product dimension key |
| AggregationLevel | VARCHAR(30) | Attribute | DAILY, WEEKLY, MONTHLY, QUARTERLY |
| BatchesStarted | NUMBER | Measure (Additive) | Batches started |
| BatchesCompleted | NUMBER | Measure (Additive) | Batches completed |
| BatchesOnHold | NUMBER | Measure (Additive) | Batches placed on hold |
| BatchesFailed | NUMBER | Measure (Additive) | Batches failed or rejected |
| AvgYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Average yield percentage |
| MinYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Minimum yield percentage |
| MaxYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Maximum yield percentage |
| StdYieldPct | DECIMAL(8,4) | Measure (Non-additive) | Standard deviation of yield |
| YieldBelowTargetCount | NUMBER | Measure (Additive) | Batches below target yield |
| YieldTargetAttainmentPct | DECIMAL(6,3) | Measure (Non-additive) | Percent of batches meeting/exceeding target |
| TotalPlannedQty | DECIMAL(18,3) | Measure (Additive) | Total planned quantity |
| TotalActualQty | DECIMAL(18,3) | Measure (Additive) | Total actual quantity |
| QuantityUom | VARCHAR(20) | Attribute | Unit of measure |
| AvgOeePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE percentage |
| AvgAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Average availability component |
| AvgPerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Average performance component |
| AvgQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Average quality component |
| TotalDeviations | NUMBER | Measure (Additive) | Total deviations |
| HighCriticalDeviations | NUMBER | Measure (Additive) | High or critical deviations |
| CppComplianceRatePct | DECIMAL(6,3) | Measure (Non-additive) | CPP compliance rate percentage |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

#### Fact Table: FACT_SHIFT_LOG

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ShiftLogKey | INTEGER | Primary Key | Surrogate key |
| FacilityKey | INTEGER | Foreign Key → DIM_FACILITY | Facility dimension key |
| LogDateKey | INTEGER | Foreign Key → DIM_DATE | DateKey derived from LOG_DATE |
| ShiftName | VARCHAR(20) | Attribute | Shift identifier |
| ShiftStartUtc | TIMESTAMP_TZ | Attribute | Shift start time |
| ShiftEndUtc | TIMESTAMP_TZ | Attribute | Shift end time |
| SupervisorKey | INTEGER | Foreign Key → DIM_OPERATOR | Supervisor operator key |
| ActiveBatches | NUMBER | Measure (Additive) | Batches in progress during shift |
| CompletedBatches | NUMBER | Measure (Additive) | Batches completed during shift |
| NewDeviations | NUMBER | Measure (Additive) | New deviations raised |
| ClosedDeviations | NUMBER | Measure (Additive) | Deviations closed |
| EquipmentDowntimeMins | NUMBER | Measure (Additive) | Equipment downtime minutes |
| EquipmentIssuesCount | NUMBER | Measure (Additive) | Equipment issues count |
| SignedOff | BOOLEAN | Attribute | Shift signed off flag |
| SignedOffUtc | TIMESTAMP_TZ | Attribute | Sign-off timestamp |
| ShiftNotes | VARCHAR(4000) | Attribute | Supervisor shift notes |
| SourceLogIdMartA | NUMBER | Attribute | Shift log ID in Mart A |
| SourceSystem | VARCHAR(50) | Audit | From _SOURCE_SYSTEM |
| SourceKey | VARCHAR(100) | Audit | From _SOURCE_KEY |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | From _LOADED_AT_UTC |
| CreatedAt | TIMESTAMP_TZ | Audit | From CREATED_AT |
| CreatedBy | VARCHAR(100) | Audit | From CREATED_BY |
| UpdatedAt | TIMESTAMP_TZ | Audit | From UPDATED_AT |
| UpdatedBy | VARCHAR(100) | Audit | From UPDATED_BY |
| IsDeleted | BOOLEAN | Audit | From IS_DELETED |
| DeletedAt | TIMESTAMP_TZ | Audit | From DELETED_AT |

---

### Section 3 — Canonical to Star Mapping Table

| Star Table Name | Star Column Name | Canonical Entity | Canonical Attribute | Mapping Rule | Measure Type | SCD Type | PII |
|---|---|---|---|---|---|---|---|
| DIM_ORGANIZATION | OrganizationKey | DIM_ORGANIZATION | ORGANIZATION_KEY | Surrogate Key (system-generated INTEGER; direct from canonical ORGANIZATION_KEY) | — | Type 2 | — |
| DIM_ORGANIZATION | OrganizationID | DIM_ORGANIZATION | ORGANIZATION_ID | Direct | — | — | — |
| DIM_ORGANIZATION | OrganizationName | DIM_ORGANIZATION | ORGANIZATION_NAME | Direct | — | — | — |
| DIM_ORGANIZATION | OrganizationType | DIM_ORGANIZATION | ORGANIZATION_TYPE | Direct | — | — | — |
| DIM_ORGANIZATION | ParentOrganizationKey | DIM_ORGANIZATION | PARENT_ORGANIZATION_KEY | Direct | — | — | — |
| DIM_ORGANIZATION | CountryCode | DIM_ORGANIZATION | COUNTRY_CODE | Direct | — | — | — |
| DIM_ORGANIZATION | RegulatoryRegion | DIM_ORGANIZATION | REGULATORY_REGION | Direct | — | — | — |
| DIM_ORGANIZATION | IsActive | DIM_ORGANIZATION | IS_ACTIVE | Direct | — | — | — |
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
| DIM_FACILITY | FacilityKey | DIM_FACILITY | FACILITY_KEY | Surrogate Key (system-generated INTEGER; direct from canonical FACILITY_KEY) | — | Type 2 | — |
| DIM_FACILITY | FacilityID | DIM_FACILITY | FACILITY_ID | Direct | — | — | — |
| DIM_FACILITY | FacilityName | DIM_FACILITY | FACILITY_NAME | Direct | — | — | — |
| DIM_FACILITY | FacilityShortName | DIM_FACILITY | FACILITY_SHORT_NAME | Direct | — | — | — |
| DIM_FACILITY | OrganizationKey | DIM_FACILITY | ORGANIZATION_KEY | Direct | — | Type 2 | — |
| DIM_FACILITY | SiteCode | DIM_FACILITY | SITE_CODE | Direct | — | — | — |
| DIM_FACILITY | FacilityType | DIM_FACILITY | FACILITY_TYPE | Direct | — | — | — |
| DIM_FACILITY | AddressLine1 | DIM_FACILITY | ADDRESS_LINE_1 | Direct | — | — | — |
| DIM_FACILITY | AddressLine2 | DIM_FACILITY | ADDRESS_LINE_2 | Direct | — | — | — |
| DIM_FACILITY | City | DIM_FACILITY | CITY | Direct | — | — | — |
| DIM_FACILITY | StateRegion | DIM_FACILITY | STATE_REGION | Direct | — | — | — |
| DIM_FACILITY | PostalCode | DIM_FACILITY | POSTAL_CODE | Direct | — | — | — |
| DIM_FACILITY | CountryCode | DIM_FACILITY | COUNTRY_CODE | Direct | — | — | — |
| DIM_FACILITY | TimezoneName | DIM_FACILITY | TIMEZONE_NAME | Direct | — | — | — |
| DIM_FACILITY | UtcOffsetHours | DIM_FACILITY | UTC_OFFSET_HOURS | Direct | — | — | — |
| DIM_FACILITY | GmpCertified | DIM_FACILITY | GMP_CERTIFIED | Direct | — | — | — |
| DIM_FACILITY | GmpCertificationDate | DIM_FACILITY | GMP_CERTIFICATION_DATE | Direct | — | — | — |
| DIM_FACILITY | GmpExpiryDate | DIM_FACILITY | GMP_EXPIRY_DATE | Direct | — | — | — |
| DIM_FACILITY | RegulatoryAgency | DIM_FACILITY | REGULATORY_AGENCY | Direct | — | — | — |
| DIM_FACILITY | FdaEstablishmentId | DIM_FACILITY | FDA_ESTABLISHMENT_ID | Direct | — | — | — |
| DIM_FACILITY | EmaSiteCode | DIM_FACILITY | EMA_SITE_CODE | Direct | — | — | — |
| DIM_FACILITY | ManufacturingCapacity | DIM_FACILITY | MANUFACTURING_CAPACITY | Direct | — | — | — |
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
| DIM_PRODUCT | ProductKey | DIM_PRODUCT | PRODUCT_KEY | Surrogate Key (system-generated INTEGER; direct from canonical PRODUCT_KEY) | — | Type 2 | — |
| DIM_PRODUCT | ProductID | DIM_PRODUCT | PRODUCT_ID | Direct | — | — | — |
| DIM_PRODUCT | Sku | DIM_PRODUCT | SKU | Direct | — | — | — |
| DIM_PRODUCT | ProductName | DIM_PRODUCT | PRODUCT_NAME | Direct | — | — | — |
| DIM_PRODUCT | ProductShortName | DIM_PRODUCT | PRODUCT_SHORT_NAME | Direct | — | — | — |
| DIM_PRODUCT | OrganizationKey | DIM_PRODUCT | ORGANIZATION_KEY | Direct | — | Type 2 | — |
| DIM_PRODUCT | FormulationId | DIM_PRODUCT | FORMULATION_ID | Direct | — | — | — |
| DIM_PRODUCT | FormulationVersion | DIM_PRODUCT | FORMULATION_VERSION | Direct | — | — | — |
| DIM_PRODUCT | DosageForm | DIM_PRODUCT | DOSAGE_FORM | Direct | — | — | — |
| DIM_PRODUCT | DosageStrength | DIM_PRODUCT | DOSAGE_STRENGTH | Direct | — | — | — |
| DIM_PRODUCT | RouteOfAdministration | DIM_PRODUCT | ROUTE_OF_ADMINISTRATION | Direct | — | — | — |
| DIM_PRODUCT | TherapeuticClass | DIM_PRODUCT | THERAPEUTIC_CLASS | Direct | — | — | — |
| DIM_PRODUCT | TherapeuticArea | DIM_PRODUCT | THERAPEUTIC_AREA | Direct | — | — | — |
| DIM_PRODUCT | ProductCategory | DIM_PRODUCT | PRODUCT_CATEGORY | Direct | — | — | — |
| DIM_PRODUCT | IsBiosimilar | DIM_PRODUCT | IS_BIOSIMILAR | Direct | — | — | — |
| DIM_PRODUCT | ReferenceProductId | DIM_PRODUCT | REFERENCE_PRODUCT_ID | Direct | — | — | — |
| DIM_PRODUCT | InnName | DIM_PRODUCT | INN_NAME | Direct | — | — | — |
| DIM_PRODUCT | IdmpMpid | DIM_PRODUCT | IDMP_MPID | Direct | — | — | — |
| DIM_PRODUCT | NdaBlaNumber | DIM_PRODUCT | NDA_BLA_NUMBER | Direct | — | — | — |
| DIM_PRODUCT | EmaProductNumber | DIM_PRODUCT | EMA_PRODUCT_NUMBER | Direct | — | — | — |
| DIM_PRODUCT | StandardYieldPct | DIM_PRODUCT | STANDARD_YIELD_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | YieldLowerAlertPct | DIM_PRODUCT | YIELD_LOWER_ALERT_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | YieldLowerActionPct | DIM_PRODUCT | YIELD_LOWER_ACTION_PCT | Direct | — | Type 2 | — |
| DIM_PRODUCT | ShelfLifeMonths | DIM_PRODUCT | SHELF_LIFE_MONTHS | Direct | — | — | — |
| DIM_PRODUCT | StorageCondition | DIM_PRODUCT | STORAGE_CONDITION | Direct | — | — | — |
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
| DIM_MATERIAL_LOT | MaterialLotKey | DIM_MATERIAL_LOT | MATERIAL_LOT_KEY | Surrogate Key (system-generated INTEGER; direct from canonical MATERIAL_LOT_KEY) | — | — | — |
| DIM_MATERIAL_LOT | LotNumber | DIM_MATERIAL_LOT | LOT_NUMBER | Direct | — | — | — |
| DIM_MATERIAL_LOT | ProductKey | DIM_MATERIAL_LOT | PRODUCT_KEY | Direct | — | — | — |
| DIM_MATERIAL_LOT | FacilityKey | DIM_MATERIAL_LOT | FACILITY_KEY | Direct | — | — | — |
| DIM_MATERIAL_LOT | LotType | DIM_MATERIAL_LOT | LOT_TYPE | Direct | — | — | — |
| DIM_MATERIAL_LOT | ManufactureDate | DIM_MATERIAL_LOT | MANUFACTURE_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | ExpiryDate | DIM_MATERIAL_LOT | EXPIRY_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | RetestDate | DIM_MATERIAL_LOT | RETEST_DATE | Direct | — | — | — |
| DIM_MATERIAL_LOT | QuantityProduced | DIM_MATERIAL_LOT | QUANTITY_PRODUCED | Direct | — | — | — |
| DIM_MATERIAL_LOT | QuantityUnit | DIM_MATERIAL_LOT | QUANTITY_UNIT | Direct | — | — | — |
| DIM_MATERIAL_LOT | LotStatus | DIM_MATERIAL_LOT | LOT_STATUS | Direct | — | — | — |
| DIM_MATERIAL_LOT | CertificateOfAnalysis | DIM_MATERIAL_LOT | CERTIFICATE_OF_ANALYSIS | Direct | — | — | — |
| DIM_MATERIAL_LOT | VendorLotNumber | DIM_MATERIAL_LOT | VENDOR_LOT_NUMBER | Direct | — | — | — |
| DIM_MATERIAL_LOT | VendorID | DIM_MATERIAL_LOT | VENDOR_ID | Direct | — | — | — |
| DIM_MATERIAL_LOT | SourceSystem | DIM_MATERIAL_LOT | _SOURCE_SYSTEM | Direct | — | — | — |
| DIM_MATERIAL_LOT | SourceKey | DIM_MATERIAL_LOT | _SOURCE_KEY | Direct | — | — | — |
| DIM_MATERIAL_LOT | CreatedAt | DIM_MATERIAL_LOT | CREATED_AT | Direct | — | — | — |
| DIM_MATERIAL_LOT | CreatedBy | DIM_MATERIAL_LOT | CREATED_BY | Direct | — | — | — |
| DIM_MATERIAL_LOT | UpdatedAt | DIM_MATERIAL_LOT | UPDATED_AT | Direct | — | — | — |
| DIM_MATERIAL_LOT | UpdatedBy | DIM_MATERIAL_LOT | UPDATED_BY | Direct | — | — | — |
| DIM_MATERIAL_LOT | IsDeleted | DIM_MATERIAL_LOT | IS_DELETED | Direct | — | — | — |
| DIM_MATERIAL_LOT | DeletedAt | DIM_MATERIAL_LOT | DELETED_AT | Direct | — | — | — |
| DIM_EQUIPMENT | EquipmentKey | DIM_EQUIPMENT | EQUIPMENT_KEY | Surrogate Key (system-generated INTEGER; direct from canonical EQUIPMENT_KEY) | — | Type 2 | — |
| DIM_EQUIPMENT | CanonicalEquipmentID | DIM_EQUIPMENT | CANONICAL_EQUIPMENT_ID | Direct | — | — | — |
| DIM_EQUIPMENT | EquipmentName | DIM_EQUIPMENT | EQUIPMENT_NAME | Direct | — | — | — |
| DIM_EQUIPMENT | FacilityKey | DIM_EQUIPMENT | FACILITY_KEY | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | FunctionalArea | DIM_EQUIPMENT | FUNCTIONAL_AREA | Direct | — | — | — |
| DIM_EQUIPMENT | ProductionUnit | DIM_EQUIPMENT | PRODUCTION_UNIT | Direct | — | — | — |
| DIM_EQUIPMENT | EquipmentModule | DIM_EQUIPMENT | EQUIPMENT_MODULE | Direct | — | — | — |
| DIM_EQUIPMENT | AssetClass | DIM_EQUIPMENT | ASSET_CLASS | Direct | — | — | — |
| DIM_EQUIPMENT | AssetSubClass | DIM_EQUIPMENT | ASSET_SUBCLASS | Direct | — | — | — |
| DIM_EQUIPMENT | CriticalityRating | DIM_EQUIPMENT | CRITICALITY_RATING | Direct | — | — | — |
| DIM_EQUIPMENT | ManufacturerName | DIM_EQUIPMENT | MANUFACTURER_NAME | Direct | — | — | — |
| DIM_EQUIPMENT | ModelNumber | DIM_EQUIPMENT | MODEL_NUMBER | Direct | — | — | — |
| DIM_EQUIPMENT | SerialNumber | DIM_EQUIPMENT | SERIAL_NUMBER | Direct | — | — | — |
| DIM_EQUIPMENT | WorkingVolumeL | DIM_EQUIPMENT | WORKING_VOLUME_L | Direct | — | — | — |
| DIM_EQUIPMENT | InstallationDate | DIM_EQUIPMENT | INSTALLATION_DATE | Direct | — | — | — |
| DIM_EQUIPMENT | CommissioningDate | DIM_EQUIPMENT | COMMISSIONING_DATE | Direct | — | — | — |
| DIM_EQUIPMENT | QualificationStatus | DIM_EQUIPMENT | QUALIFICATION_STATUS | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | LastQualificationDate | DIM_EQUIPMENT | LAST_QUALIFICATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | NextQualificationDate | DIM_EQUIPMENT | NEXT_QUALIFICATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationFrequency | DIM_EQUIPMENT | CALIBRATION_FREQUENCY | Direct | — | — | — |
| DIM_EQUIPMENT | LastCalibrationDate | DIM_EQUIPMENT | LAST_CALIBRATION_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationDueDate | DIM_EQUIPMENT | CALIBRATION_DUE_DATE | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | CalibrationStatus | DIM_EQUIPMENT | CALIBRATION_STATUS | Direct | — | Type 2 | — |
| DIM_EQUIPMENT | PlannedRuntimeMinsPerDay | DIM_EQUIPMENT | PLANNED_RUNTIME_MINS_PER_DAY | Direct | — | — | — |
| DIM_EQUIPMENT | IdealCycleTimeSecs | DIM_EQUIPMENT | IDEAL_CYCLE_TIME_SECS | Direct | — | — | — |
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
| DIM_PROCESS_STEP | ProcessStepKey | DIM_PROCESS_STEP | PROCESS_STEP_KEY | Surrogate Key (system-generated INTEGER; direct from canonical PROCESS_STEP_KEY) | — | — | — |
| DIM_PROCESS_STEP | StepCode | DIM_PROCESS_STEP | STEP_CODE | Direct | — | — | — |
| DIM_PROCESS_STEP | StepName | DIM_PROCESS_STEP | STEP_NAME | Direct | — | — | — |
| DIM_PROCESS_STEP | StepCategory | DIM_PROCESS_STEP | STEP_CATEGORY | Direct | — | — | — |
| DIM_PROCESS_STEP | StepSubcategory | DIM_PROCESS_STEP | STEP_SUBCATEGORY | Direct | — | — | — |
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
| DIM_PROCESS_PARAMETER | ParameterKey | DIM_PROCESS_PARAMETER | PARAMETER_KEY | Surrogate Key (system-generated INTEGER; direct from canonical PARAMETER_KEY) | — | — | — |
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
| DIM_QUALITY_DISPOSITION | DispositionKey | DIM_QUALITY_DISPOSITION | DISPOSITION_KEY | Surrogate Key (system-generated INTEGER; direct from canonical DISPOSITION_KEY) | — | — | — |
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
| DIM_DEVIATION_CATEGORY | DeviationCategoryKey | DIM_DEVIATION_CATEGORY | DEVIATION_CATEGORY_KEY | Surrogate Key (system-generated INTEGER; direct from canonical DEVIATION_CATEGORY_KEY) | — | — | — |
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
| DIM_OPERATOR | OperatorKey | DIM_OPERATOR | OPERATOR_KEY | Surrogate Key (system-generated INTEGER; direct from canonical OPERATOR_KEY) | — | — | — |
| DIM_OPERATOR | OperatorID | DIM_OPERATOR | OPERATOR_ID | Direct | — | — | — |
| DIM_OPERATOR | FullName | DIM_OPERATOR | FULL_NAME | Direct | — | — | — |
| DIM_OPERATOR | RoleCode | DIM_OPERATOR | ROLE_CODE | Direct | — | — | — |
| DIM_OPERATOR | FacilityKey | DIM_OPERATOR | FACILITY_KEY | Direct | — | — | — |
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
| FACT_PRODUCTION_ORDER | ProductionOrderKey | FACT_PRODUCTION_ORDER | PRODUCTION_ORDER_KEY | Surrogate Key (system-generated INTEGER; direct from canonical PRODUCTION_ORDER_KEY) | — | — | — |
| FACT_PRODUCTION_ORDER | CanonicalBatchID | FACT_PRODUCTION_ORDER | CANONICAL_BATCH_ID | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ErpOrderNumber | FACT_PRODUCTION_ORDER | ERP_ORDER_NUMBER | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | MesBatchReference | FACT_PRODUCTION_ORDER | MES_BATCH_REFERENCE | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | GmpLotNumber | FACT_PRODUCTION_ORDER | GMP_LOT_NUMBER | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | FacilityKey | FACT_PRODUCTION_ORDER | FACILITY_KEY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | ProductKey | FACT_PRODUCTION_ORDER | PRODUCT_KEY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | PrimaryEquipmentKey | FACT_PRODUCTION_ORDER | PRIMARY_EQUIPMENT_KEY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | DispositionKey | FACT_PRODUCTION_ORDER | DISPOSITION_KEY | Direct | — | — | — |
| FACT_PRODUCTION_ORDER | PlannedStartDateKey | FACT_PRODUCTION_ORDER | PLANNED_START_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_PRODUCTION_ORDER | PlannedEndDateKey | FACT_PRODUCTION_ORDER | PLANNED_END_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_PRODUCTION_ORDER | ActualStartDateKey | FACT_PRODUCTION_ORDER | ACTUAL_START_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_PRODUCTION_ORDER | ActualEndDateKey | FACT_PRODUCTION_ORDER | ACTUAL_END_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_PRODUCTION_ORDER | PlannedQuantity | FACT_PRODUCTION_ORDER | PLANNED_QUANTITY | Direct | Additive | — | — |
| FACT_PRODUCTION_ORDER | QuantityUom | FACT_PRODUCTION_ORDER | QUANTITY_UOM | Direct | — | — | — |
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
| FACT_PRODUCTION_ORDER | ShiftSupervisorKey | FACT_PRODUCTION_ORDER | SHIFT_SUPERVISOR_KEY | Direct | — | — | — |
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
| FACT_BATCH_STEP | BatchStepKey | FACT_BATCH_STEP | BATCH_STEP_KEY | Surrogate Key (system-generated INTEGER; direct from canonical BATCH_STEP_KEY) | — | — | — |
| FACT_BATCH_STEP | ProductionOrderKey | FACT_BATCH_STEP | PRODUCTION_ORDER_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | CanonicalBatchID | FACT_BATCH_STEP | CANONICAL_BATCH_ID | Direct | — | — | — |
| FACT_BATCH_STEP | ProcessStepKey | FACT_BATCH_STEP | PROCESS_STEP_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | EquipmentKey | FACT_BATCH_STEP | EQUIPMENT_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | StepSequence | FACT_BATCH_STEP | STEP_SEQUENCE | Direct | — | — | — |
| FACT_BATCH_STEP | StepStartDateKey | FACT_BATCH_STEP | STEP_START_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_BATCH_STEP | StepEndDateKey | FACT_BATCH_STEP | STEP_END_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_BATCH_STEP | StepDurationHrs | FACT_BATCH_STEP | STEP_DURATION_HRS | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | InputQuantity | FACT_BATCH_STEP | INPUT_QUANTITY | Direct | Additive | — | — |
| FACT_BATCH_STEP | OutputQuantity | FACT_BATCH_STEP | OUTPUT_QUANTITY | Direct | Additive | — | — |
| FACT_BATCH_STEP | QuantityUom | FACT_BATCH_STEP | QUANTITY_UOM | Direct | — | — | — |
| FACT_BATCH_STEP | StepYieldPct | FACT_BATCH_STEP | STEP_YIELD_PCT | Direct | Non-additive | — | — |
| FACT_BATCH_STEP | StepStatus | FACT_BATCH_STEP | STEP_STATUS | Direct | — | — | — |
| FACT_BATCH_STEP | OperatorKey | FACT_BATCH_STEP | OPERATOR_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | VerifierKey | FACT_BATCH_STEP | VERIFIER_KEY | Direct | — | — | — |
| FACT_BATCH_STEP | EsignatureTimestampUtc | FACT_BATCH_STEP | ESIGNATURE_TIMESTAMP_UTC | Direct | — | — | — |
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
| FACT_EQUIPMENT_TELEMETRY | TelemetryKey | FACT_EQUIPMENT_TELEMETRY | TELEMETRY_KEY | Surrogate Key (system-generated INTEGER; direct from canonical TELEMETRY_KEY) | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | EquipmentKey | FACT_EQUIPMENT_TELEMETRY | EQUIPMENT_KEY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | BatchStepKey | FACT_EQUIPMENT_TELEMETRY | BATCH_STEP_KEY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ProductionOrderKey | FACT_EQUIPMENT_TELEMETRY | PRODUCTION_ORDER_KEY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalBatchID | FACT_EQUIPMENT_TELEMETRY | CANONICAL_BATCH_ID | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ParameterKey | FACT_EQUIPMENT_TELEMETRY | PARAMETER_KEY | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ReadingDateKey | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ReadingTimestampUtc | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalValue | FACT_EQUIPMENT_TELEMETRY | CANONICAL_VALUE | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | CanonicalUom | FACT_EQUIPMENT_TELEMETRY | CANONICAL_UOM | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceValue | FACT_EQUIPMENT_TELEMETRY | SOURCE_VALUE | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | SourceUom | FACT_EQUIPMENT_TELEMETRY | SOURCE_UOM | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | ConversionApplied | FACT_EQUIPMENT_TELEMETRY | CONVERSION_APPLIED | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | TargetValue | FACT_EQUIPMENT_TELEMETRY | TARGET_VALUE | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | LowerSpecLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_SPEC_LIMIT | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | UpperSpecLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_SPEC_LIMIT | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | LowerAlertLimit | FACT_EQUIPMENT_TELEMETRY | LOWER_ALERT_LIMIT | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | UpperAlertLimit | FACT_EQUIPMENT_TELEMETRY | UPPER_ALERT_LIMIT | Direct | Semi-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | WithinSpecification | FACT_EQUIPMENT_TELEMETRY | WITHIN_SPECIFICATION | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | WithinAlert | FACT_EQUIPMENT_TELEMETRY | WITHIN_ALERT | Direct | — | — | — |
| FACT_EQUIPMENT_TELEMETRY | DeviationFromTarget | FACT_EQUIPMENT_TELEMETRY | DEVIATION_FROM_TARGET | Direct | Non-additive | — | — |
| FACT_EQUIPMENT_TELEMETRY | GoldenBatchValue | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_VALUE | Direct | Semi-additive | — | — |
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
| FACT_DEVIATION | DeviationKey | FACT_DEVIATION | DEVIATION_KEY | Surrogate Key (system-generated INTEGER; direct from canonical DEVIATION_KEY) | — | — | — |
| FACT_DEVIATION | CanonicalDeviationID | FACT_DEVIATION | CANONICAL_DEVIATION_ID | Direct | — | — | — |
| FACT_DEVIATION | ProductionOrderKey | FACT_DEVIATION | PRODUCTION_ORDER_KEY | Direct | — | — | — |
| FACT_DEVIATION | BatchStepKey | FACT_DEVIATION | BATCH_STEP_KEY | Direct | — | — | — |
| FACT_DEVIATION | TelemetryKey | FACT_DEVIATION | TELEMETRY_KEY | Direct | — | — | — |
| FACT_DEVIATION | EquipmentKey | FACT_DEVIATION | EQUIPMENT_KEY | Direct | — | — | — |
| FACT_DEVIATION | ParameterKey | FACT_DEVIATION | PARAMETER_KEY | Direct | — | — | — |
| FACT_DEVIATION | DeviationCategoryKey | FACT_DEVIATION | DEVIATION_CATEGORY_KEY | Direct | — | — | — |
| FACT_DEVIATION | FacilityKey | FACT_DEVIATION | FACILITY_KEY | Direct | — | — | — |
| FACT_DEVIATION | CanonicalBatchID | FACT_DEVIATION | CANONICAL_BATCH_ID | Direct | — | — | — |
| FACT_DEVIATION | DetectedDateKey | FACT_DEVIATION | DETECTED_TIMESTAMP_UTC | Cast timestamp to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_DEVIATION | DetectedTimestampUtc | FACT_DEVIATION | DETECTED_TIMESTAMP_UTC | Direct | — | — | — |
| FACT_DEVIATION | DetectedByKey | FACT_DEVIATION | DETECTED_BY_KEY | Direct | — | — | — |
| FACT_DEVIATION | DetectionMethod | FACT_DEVIATION | DETECTION_METHOD | Direct | — | — | — |
| FACT_DEVIATION | SeverityCode | FACT_DEVIATION | SEVERITY_CODE | Direct | — | — | — |
| FACT_DEVIATION | PotentialImpact | FACT_DEVIATION | POTENTIAL_IMPACT | Direct | — | — | — |
| FACT_DEVIATION | DeviationDescription | FACT_DEVIATION | DEVIATION_DESCRIPTION | Direct | — | — | — |
| FACT_DEVIATION | InvestigationStatus | FACT_DEVIATION | INVESTIGATION_STATUS | Direct | — | — | — |
| FACT_DEVIATION | AssignedToKey | FACT_DEVIATION | ASSIGNED_TO_KEY | Direct | — | — | — |
| FACT_DEVIATION | InvestigationStartUtc | FACT_DEVIATION | INVESTIGATION_START_UTC | Direct | — | — | — |
| FACT_DEVIATION | InvestigationEndUtc | FACT_DEVIATION | INVESTIGATION_END_UTC | Direct | — | — | — |
| FACT_DEVIATION | RootCauseCode | FACT_DEVIATION | ROOT_CAUSE_CODE | Direct | — | — | — |
| FACT_DEVIATION | RootCauseDescription | FACT_DEVIATION | ROOT_CAUSE_DESCRIPTION | Direct | — | — | — |
| FACT_DEVIATION | CapaRequired | FACT_DEVIATION | CAPA_REQUIRED | Direct | — | — | — |
| FACT_DEVIATION | CapaReferenceID | FACT_DEVIATION | CAPA_REFERENCE_ID | Direct | — | — | — |
| FACT_DEVIATION | CapaDueDate | FACT_DEVIATION | CAPA_DUE_DATE | Direct | — | — | — |
| FACT_DEVIATION | CapaClosedDate | FACT_DEVIATION | CAPA_CLOSED_DATE | Direct | — | — | — |
| FACT_DEVIATION | ClosedTimestampUtc | FACT_DEVIATION | CLOSED_TIMESTAMP_UTC | Direct | — | — | — |
| FACT_DEVIATION | ClosedByKey | FACT_DEVIATION | CLOSED_BY_KEY | Direct | — | — | — |
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
| FACT_YIELD_ANALYTICS | YieldAnalyticsKey | FACT_YIELD_ANALYTICS | YIELD_ANALYTICS_KEY | Surrogate Key (system-generated INTEGER; direct from canonical YIELD_ANALYTICS_KEY) | — | — | — |
| FACT_YIELD_ANALYTICS | AnalysisDateKey | FACT_YIELD_ANALYTICS | ANALYSIS_DATE | Cast DATE to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_YIELD_ANALYTICS | FacilityKey | FACT_YIELD_ANALYTICS | FACILITY_KEY | Direct | — | — | — |
| FACT_YIELD_ANALYTICS | ProductKey | FACT_YIELD_ANALYTICS | PRODUCT_KEY | Direct | — | — | — |
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
| FACT_SHIFT_LOG | ShiftLogKey | FACT_SHIFT_LOG | SHIFT_LOG_KEY | Surrogate Key (system-generated INTEGER; direct from canonical SHIFT_LOG_KEY) | — | — | — |
| FACT_SHIFT_LOG | FacilityKey | FACT_SHIFT_LOG | FACILITY_KEY | Direct | — | — | — |
| FACT_SHIFT_LOG | LogDateKey | FACT_SHIFT_LOG | LOG_DATE | Cast DATE to INTEGER YYYYMMDD (DateKey) | — | — | — |
| FACT_SHIFT_LOG | ShiftName | FACT_SHIFT_LOG | SHIFT_NAME | Direct | — | — | — |
| FACT_SHIFT_LOG | ShiftStartUtc | FACT_SHIFT_LOG | SHIFT_START_UTC | Direct | — | — | — |
| FACT_SHIFT_LOG | ShiftEndUtc | FACT_SHIFT_LOG | SHIFT_END_UTC | Direct | — | — | — |
| FACT_SHIFT_LOG | SupervisorKey | FACT_SHIFT_LOG | SUPERVISOR_KEY | Direct | — | — | — |
| FACT_SHIFT_LOG | ActiveBatches | FACT_SHIFT_LOG | ACTIVE_BATCHES | Direct | Additive | — | — |
| FACT_SHIFT_LOG | CompletedBatches | FACT_SHIFT_LOG | COMPLETED_BATCHES | Direct | Additive | — | — |
| FACT_SHIFT_LOG | NewDeviations | FACT_SHIFT_LOG | NEW_DEVIATIONS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | ClosedDeviations | FACT_SHIFT_LOG | CLOSED_DEVIATIONS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | EquipmentDowntimeMins | FACT_SHIFT_LOG | EQUIPMENT_DOWNTIME_MINS | Direct | Additive | — | — |
| FACT_SHIFT_LOG | EquipmentIssuesCount | FACT_SHIFT_LOG | EQUIPMENT_ISSUES_COUNT | Direct | Additive | — | — |
| FACT_SHIFT_LOG | SignedOff | FACT_SHIFT_LOG | SIGNED_OFF | Direct | — | — | — |
| FACT_SHIFT_LOG | SignedOffUtc | FACT_SHIFT_LOG | SIGNED_OFF_UTC | Direct | — | — | — |
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
| DIM_DATE | DateKey | — | — | Surrogate Key (system-generated INTEGER in YYYYMMDD format derived from FullDate) | — | Type 2 | — |
| DIM_DATE | FullDate | — | — | Derived from calendar generation; no direct canonical source | — | Type 2 | — |
| DIM_DATE | Day | — | — | Derived: DAY(FullDate) | — | Type 2 | — |
| DIM_DATE | Month | — | — | Derived: MONTH(FullDate) | — | Type 2 | — |
| DIM_DATE | MonthName | — | — | Derived: to_char(FullDate,'Month') | — | Type 2 | — |
| DIM_DATE | Quarter | — | — | Derived: QUARTER(FullDate) | — | Type 2 | — |
| DIM_DATE | Year | — | — | Derived: YEAR(FullDate) | — | Type 2 | — |
| DIM_DATE | WeekNumber | — | — | Derived: ISO week number from FullDate | — | Type 2 | — |
| DIM_DATE | DayOfWeek | — | — | Derived: day of week integer | — | Type 2 | — |
| DIM_DATE | DayName | — | — | Derived: day name | — | Type 2 | — |
| DIM_DATE | IsWeekend | — | — | Derived: TRUE if DayOfWeek in (6,7) | — | Type 2 | — |
| DIM_DATE | IsHoliday | — | — | Derived via holiday calendar lookup | — | Type 2 | — |
| DIM_DATE | FiscalYear | — | — | Derived via fiscal calendar mapping | — | Type 2 | — |
| DIM_DATE | FiscalQuarter | — | — | Derived via fiscal calendar mapping | — | Type 2 | — |