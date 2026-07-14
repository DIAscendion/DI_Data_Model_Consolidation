### Section 1 — Modeling Summary

| Metric | Detail |
|----------------------------|-----------------------------------------------|
| Central Business Process | GMP Batch Execution & Monitoring |
| Fact Table(s) | FactProductionOrder, FactBatchStep, FactEquipmentTelemetry, FactDeviation, FactYieldAnalytics, FactShiftLog |
| Dimension Tables | DimOrganization, DimFacility, DimProduct, DimMaterialLot, DimEquipment, DimProcessStep, DimProcessParameter, DimQualityDisposition, DimDeviationCategory, DimOperator, DimDate |
| Total Fact Measures | 67 |
| Total Dimension Attributes | 156 |
| SCD Type 2 Dimensions | DimFacility, DimProduct |
| PII-masked Columns | 1 |


### Section 2 — Star Schema Definition

#### Dimension Table: DimOrganization

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OrganizationKey | INTEGER | Primary Key | Surrogate key |
| OrganizationID | VARCHAR(50) | Natural Key | Enterprise org code |
| OrganizationName | VARCHAR(200) | Attribute | Full legal name |
| OrganizationType | VARCHAR(80) | Attribute | Organizational type |
| ParentOrganizationKey | INTEGER | Foreign Key → DimOrganization | Parent organization hierarchy |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 country code |
| RegulatoryRegion | VARCHAR(80) | Attribute | Regulatory jurisdiction |
| IsActive | BOOLEAN | Attribute | Active organization flag |
| EffectiveStartDate | DATE | SCD Type 2 | Date this org record became valid |
| EffectiveEndDate | DATE | SCD Type 2 | Date this org record ceased to be valid |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimFacility

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| FacilityKey | INTEGER | Primary Key | Surrogate key |
| FacilityID | VARCHAR(50) | Natural Key | Enterprise facility code |
| FacilityName | VARCHAR(200) | Attribute | Full facility name |
| FacilityShortName | VARCHAR(80) | Attribute | Common short name |
| OrganizationKey | INTEGER | Foreign Key → DimOrganization | Parent organization |
| SiteCode | VARCHAR(20) | Attribute | Short site code |
| FacilityType | VARCHAR(80) | Attribute | Facility type classification |
| AddressLine1 | VARCHAR(200) | Attribute | Street address line 1 |
| AddressLine2 | VARCHAR(200) | Attribute | Street address line 2 |
| City | VARCHAR(100) | Attribute | City |
| StateRegion | VARCHAR(100) | Attribute | State or region |
| PostalCode | VARCHAR(20) | Attribute | Postal or ZIP code |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 country code |
| TimezoneName | VARCHAR(80) | Attribute | IANA timezone name |
| UtcOffsetHours | DECIMAL(4,2) | Attribute | UTC offset in hours |
| GmpCertified | BOOLEAN | Attribute | GMP certification flag |
| GmpCertificationDate | DATE | Attribute | Most recent GMP certification date |
| GmpExpiryDate | DATE | Attribute | GMP certification expiry date |
| RegulatoryAgency | VARCHAR(80) | Attribute | Primary regulatory agency |
| FdaEstablishmentId | VARCHAR(50) | Attribute | FDA Establishment Identifier |
| EmaSiteCode | VARCHAR(50) | Attribute | EMA site code |
| ManufacturingCapacity | VARCHAR(80) | Attribute | Scale classification |
| SourceSiteCodeMartA | VARCHAR(20) | Attribute | Site code in Mart A |
| SourcePlantCodeOps | VARCHAR(30) | Attribute | Plant code in Operational System |
| SourceFacCodeMartB | VARCHAR(30) | Attribute | Facility code in Mart B |
| EffectiveStartDate | DATE | SCD Type 2 | Start of this facility version |
| EffectiveEndDate | DATE | SCD Type 2 | End of this facility version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Current version flag |
| ScdVersion | NUMBER | SCD Type 2 | SCD version number |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimProduct

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProductKey | INTEGER | Primary Key | Surrogate key |
| ProductID | VARCHAR(50) | Natural Key | Enterprise product ID |
| Sku | VARCHAR(60) | Attribute | Stock Keeping Unit |
| ProductName | VARCHAR(200) | Attribute | Official product name |
| ProductShortName | VARCHAR(80) | Attribute | Abbreviated product name |
| OrganizationKey | INTEGER | Foreign Key → DimOrganization | Owning organization |
| FormulationID | VARCHAR(60) | Attribute | Formulation specification ID |
| FormulationVersion | VARCHAR(20) | Attribute | Formulation version number |
| DosageForm | VARCHAR(80) | Attribute | Dosage form |
| DosageStrength | VARCHAR(80) | Attribute | Strength descriptor |
| RouteOfAdministration | VARCHAR(80) | Attribute | Route of administration |
| TherapeuticClass | VARCHAR(100) | Attribute | Therapeutic category |
| TherapeuticArea | VARCHAR(100) | Attribute | Disease area |
| ProductCategory | VARCHAR(80) | Attribute | Broad product category |
| IsBiosimilar | BOOLEAN | Attribute | Biosimilar flag |
| ReferenceProductID | VARCHAR(50) | Attribute | Reference originator product ID |
| InnName | VARCHAR(200) | Attribute | International Nonproprietary Name |
| IdmpMpid | VARCHAR(100) | Attribute | IDMP Medicinal Product Identifier |
| NdaBlaNumber | VARCHAR(50) | Attribute | FDA NDA/BLA number |
| EmaProductNumber | VARCHAR(50) | Attribute | EMA product number |
| StandardYieldPct | DECIMAL(6,3) | Attribute | Validated target yield percentage |
| YieldLowerAlertPct | DECIMAL(6,3) | Attribute | Yield alert threshold |
| YieldLowerActionPct | DECIMAL(6,3) | Attribute | Yield action limit |
| ShelfLifeMonths | NUMBER | Attribute | Shelf life in months |
| StorageCondition | VARCHAR(80) | Attribute | Required storage condition |
| EffectiveStartDate | DATE | SCD Type 2 | Start of this product version |
| EffectiveEndDate | DATE | SCD Type 2 | End of this product version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Current version flag |
| ScdVersion | NUMBER | SCD Type 2 | SCD version number |
| SourceProductCodeMartA | VARCHAR(50) | Attribute | Product code in Mart A |
| SourceProductCodeOps | VARCHAR(50) | Attribute | Product code in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimMaterialLot

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| MaterialLotKey | INTEGER | Primary Key | Surrogate key |
| LotNumber | VARCHAR(80) | Natural Key | GMP lot number |
| ProductKey | INTEGER | Foreign Key → DimProduct | Related product |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility where lot is manufactured or stored |
| LotType | VARCHAR(50) | Attribute | Lot type classification |
| ManufactureDate | DATE | Attribute | Lot manufacture or receipt date |
| ExpiryDate | DATE | Attribute | Lot expiry date |
| RetestDate | DATE | Attribute | Lot retest date |
| QuantityProduced | DECIMAL(18,3) | Attribute | Quantity produced or received |
| QuantityUnit | VARCHAR(20) | Attribute | Unit of measure |
| LotStatus | VARCHAR(40) | Attribute | Lot status |
| CertificateOfAnalysis | VARCHAR(200) | Attribute | COA document reference |
| VendorLotNumber | VARCHAR(80) | Attribute | Supplier lot number |
| VendorID | VARCHAR(80) | Attribute | Supplier identifier |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimEquipment

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| EquipmentKey | INTEGER | Primary Key | Surrogate key |
| CanonicalEquipmentID | VARCHAR(50) | Natural Key | Canonical enterprise equipment ID |
| EquipmentName | VARCHAR(200) | Attribute | Full descriptive name |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility where equipment is located |
| FunctionalArea | VARCHAR(80) | Attribute | ISA-95 functional area |
| ProductionUnit | VARCHAR(80) | Attribute | ISA-95 production unit |
| EquipmentModule | VARCHAR(80) | Attribute | ISA-95 equipment module |
| AssetClass | VARCHAR(80) | Attribute | Broad asset class |
| AssetSubclass | VARCHAR(80) | Attribute | Asset subclass |
| CriticalityRating | VARCHAR(20) | Attribute | GMP criticality rating |
| ManufacturerName | VARCHAR(100) | Attribute | Manufacturer name |
| ModelNumber | VARCHAR(100) | Attribute | Equipment model number |
| SerialNumber | VARCHAR(100) | Attribute | Manufacturer serial number |
| WorkingVolumeL | DECIMAL(12,3) | Attribute | Working volume in litres |
| InstallationDate | DATE | Attribute | Installation date |
| CommissioningDate | DATE | Attribute | Commissioning date |
| QualificationStatus | VARCHAR(30) | Attribute | Qualification status |
| LastQualificationDate | DATE | Attribute | Last qualification date |
| NextQualificationDate | DATE | Attribute | Next qualification due date |
| CalibrationFrequency | VARCHAR(30) | Attribute | Calibration schedule |
| LastCalibrationDate | DATE | Attribute | Most recent calibration date |
| CalibrationDueDate | DATE | Attribute | Next calibration due date |
| CalibrationStatus | VARCHAR(30) | Attribute | Calibration compliance status |
| PlannedRuntimeMinsPerDay | NUMBER | Attribute | Planned runtime minutes per day |
| IdealCycleTimeSecs | DECIMAL(12,4) | Attribute | Ideal cycle time in seconds |
| EquipmentStatus | VARCHAR(30) | Attribute | Equipment status |
| StatusEffectiveDate | DATE | Attribute | Status effective date |
| DecommissionDate | DATE | Attribute | Decommission date |
| SourceEquipIDMartA | VARCHAR(50) | Attribute | Equipment ID in Mart A |
| SourceAssetCodeOps | VARCHAR(50) | Attribute | Asset code in Operational System |
| SourceEquipCodeMartB | VARCHAR(50) | Attribute | Equipment code in Mart B |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimProcessStep

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessStepKey | INTEGER | Primary Key | Surrogate key |
| StepCode | VARCHAR(40) | Natural Key | Canonical process step code |
| StepName | VARCHAR(100) | Attribute | Full step name |
| StepCategory | VARCHAR(60) | Attribute | Step category |
| StepSubcategory | VARCHAR(60) | Attribute | Step subcategory |
| TypicalSequenceOrder | NUMBER | Attribute | Typical sequence position |
| ExpectedDurationMinHrs | DECIMAL(8,2) | Attribute | Minimum expected duration in hours |
| ExpectedDurationMaxHrs | DECIMAL(8,2) | Attribute | Maximum expected duration in hours |
| ApplicableAssetClasses | VARCHAR(200) | Attribute | Applicable asset classes list |
| IsCcp | BOOLEAN | Attribute | Critical control point flag |
| IsActive | BOOLEAN | Attribute | Active step flag |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimProcessParameter

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessParameterKey | INTEGER | Primary Key | Surrogate key |
| ParameterCode | VARCHAR(60) | Natural Key | Canonical parameter code |
| ParameterName | VARCHAR(150) | Attribute | Full parameter name |
| ParameterCategory | VARCHAR(60) | Attribute | Parameter category |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceUomMartA | VARCHAR(30) | Attribute | Source unit in Mart A |
| SourceUomOps | VARCHAR(30) | Attribute | Source unit in Operational System |
| SourceUomMartB | VARCHAR(30) | Attribute | Source unit in Mart B |
| ConversionFormulaOps | VARCHAR(200) | Attribute | Conversion formula from Ops to canonical UOM |
| IsCpp | BOOLEAN | Attribute | Critical process parameter flag |
| IsKpa | BOOLEAN | Attribute | Key process attribute flag |
| TypicalTarget | DECIMAL(18,4) | Attribute | Typical target value |
| TypicalLsl | DECIMAL(18,4) | Attribute | Typical lower specification limit |
| TypicalUsl | DECIMAL(18,4) | Attribute | Typical upper specification limit |
| MeasurementFrequency | VARCHAR(50) | Attribute | Measurement frequency |
| InstrumentType | VARCHAR(100) | Attribute | Measuring instrument type |
| IsActive | BOOLEAN | Attribute | Active parameter flag |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimQualityDisposition

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| QualityDispositionKey | INTEGER | Primary Key | Surrogate key |
| DispositionCode | VARCHAR(40) | Natural Key | Canonical disposition code |
| DispositionName | VARCHAR(100) | Attribute | Full disposition name |
| RequiresInvestigation | BOOLEAN | Attribute | Whether investigation is mandatory |
| CommerciallyReleasable | BOOLEAN | Attribute | Whether batch is commercially releasable |
| DeviationImplied | BOOLEAN | Attribute | Whether disposition implies a deviation |
| PatientRiskLevel | VARCHAR(20) | Attribute | Patient risk level |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification requirement flag |
| DispositionDescription | VARCHAR(500) | Attribute | Disposition business description |
| IsActive | BOOLEAN | Attribute | Active disposition flag |
| SourceCodeMartA | VARCHAR(40) | Attribute | Equivalent code in Mart A |
| SourceCodeMartB | VARCHAR(40) | Attribute | Equivalent code in Mart B |
| SourceCodeOps | VARCHAR(10) | Attribute | Equivalent code in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimDeviationCategory

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DeviationCategoryKey | INTEGER | Primary Key | Surrogate key |
| CategoryCode | VARCHAR(50) | Natural Key | Deviation category code |
| CategoryName | VARCHAR(100) | Attribute | Full category name |
| CategoryGroup | VARCHAR(80) | Attribute | Category grouping |
| Description | VARCHAR(500) | Attribute | Category description |
| CapaTypicallyRequired | BOOLEAN | Attribute | Whether CAPA is typically required |
| IsActive | BOOLEAN | Attribute | Active category flag |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimOperator

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OperatorKey | INTEGER | Primary Key | Surrogate key |
| OperatorID | VARCHAR(50) | Natural Key | System operator ID |
| FullNameMasked | VARCHAR(200) | Attribute | Masked operator name (PII protected) |
| RoleCode | VARCHAR(50) | Attribute | Operator role |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Primary facility assignment |
| Department | VARCHAR(100) | Attribute | Department |
| IsGmpTrained | BOOLEAN | Attribute | Current GMP training flag |
| TrainingExpiryDate | DATE | Attribute | GMP training expiry date |
| EsignatureEnabled | BOOLEAN | Attribute | Electronic signature authority flag |
| EmploymentStatus | VARCHAR(30) | Attribute | Employment status |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Dimension Table: DimDate

| Column Name | Data Type | Role | Description |
|--------------|--------------|-------------|----------------------|
| DateKey | INTEGER | Primary Key | Surrogate (YYYYMMDD) |
| FullDate | DATE | Attribute | Calendar date |
| Day | INTEGER | Attribute | Day of month |
| Month | INTEGER | Attribute | Month number |
| MonthName | VARCHAR(20) | Attribute | Month name |
| Quarter | INTEGER | Attribute | Calendar quarter |
| Year | INTEGER | Attribute | Calendar year |
| WeekNumber | INTEGER | Attribute | Week of year |
| DayOfWeek | INTEGER | Attribute | Day of week (1-7) |
| DayName | VARCHAR(20) | Attribute | Day name |
| IsWeekend | BOOLEAN | Attribute | Weekend flag |
| IsHoliday | BOOLEAN | Attribute | Holiday flag |
| FiscalYear | INTEGER | Attribute | Fiscal year |
| FiscalQuarter | INTEGER | Attribute | Fiscal quarter |


#### Fact Table: FactProductionOrder

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactProductionOrderKey | INTEGER | Primary Key | Surrogate key |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier |
| ErpOrderNumber | VARCHAR(50) | Attribute | ERP production order number |
| MesBatchReference | VARCHAR(80) | Attribute | MES internal batch reference |
| GmpLotNumber | VARCHAR(80) | Attribute | GMP lot number for output |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility where batch produced |
| ProductKey | INTEGER | Foreign Key → DimProduct | Product being manufactured |
| PrimaryEquipmentKey | INTEGER | Foreign Key → DimEquipment | Primary equipment used |
| QualityDispositionKey | INTEGER | Foreign Key → DimQualityDisposition | Batch disposition |
| PlannedStartDateKey | INTEGER | Foreign Key → DimDate | Planned batch start date (YYYYMMDD) |
| PlannedEndDateKey | INTEGER | Foreign Key → DimDate | Planned batch end date (YYYYMMDD) |
| ActualStartDateKey | INTEGER | Foreign Key → DimDate | Actual start date (YYYYMMDD) |
| ActualEndDateKey | INTEGER | Foreign Key → DimDate | Actual end date (YYYYMMDD) |
| PlannedStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned batch start timestamp in UTC |
| PlannedEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned batch end timestamp in UTC |
| PlannedQuantity | DECIMAL(18,3) | Measure (Additive) | Planned output quantity |
| QuantityUom | VARCHAR(20) | Attribute | Unit of measure for quantity |
| ActualStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual start timestamp in UTC |
| ActualEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual completion timestamp in UTC |
| ActualQuantity | DECIMAL(18,3) | Measure (Additive) | Actual quantity produced |
| YieldPct | DECIMAL(6,3) | Measure (Non-additive) | Overall batch yield percentage |
| YieldVariancePct | DECIMAL(8,4) | Measure (Non-additive) | Yield variance vs target |
| OeeAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Availability component |
| OeePerformancePct | DECIMAL(6,3) | Measure (Non-additive) | OEE Performance component |
| OeeQualityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Quality component |
| OeeOverallPct | DECIMAL(6,3) | Measure (Non-additive) | Overall OEE percentage |
| BatchStatus | VARCHAR(30) | Attribute | Canonical batch status |
| DeviationCount | NUMBER | Measure (Additive) | Count of deviations associated with batch |
| IsGoldenBatch | BOOLEAN | Attribute | Golden batch designation flag |
| GoldenBatchReference | VARCHAR(50) | Attribute | Reference golden batch ID |
| ShiftAtStart | VARCHAR(20) | Attribute | Shift name when batch started |
| ShiftSupervisorKey | INTEGER | Foreign Key → DimOperator | Supervisor at batch start |
| SourceBatchIDMartA | VARCHAR(50) | Attribute | Batch ID in Mart A |
| SourceBatchIDOps | VARCHAR(50) | Attribute | Batch ID in Operational System |
| SourceOrderNumOps | VARCHAR(50) | Attribute | Order number in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Fact Table: FactBatchStep

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactBatchStepKey | INTEGER | Primary Key | Surrogate key |
| FactProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Parent production order |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch identifier denormalized |
| ProcessStepKey | INTEGER | Foreign Key → DimProcessStep | Executed process step |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Equipment used in step |
| StepSequence | NUMBER | Attribute | Execution order within batch |
| StepStartDateKey | INTEGER | Foreign Key → DimDate | Step start date (YYYYMMDD) |
| StepEndDateKey | INTEGER | Foreign Key → DimDate | Step end date (YYYYMMDD) |
| StepStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step start timestamp in UTC |
| StepEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step end timestamp in UTC |
| StepDurationHrs | DECIMAL(10,4) | Measure (Non-additive) | Step duration in hours |
| InputQuantity | DECIMAL(18,3) | Measure (Additive) | Input quantity to step |
| OutputQuantity | DECIMAL(18,3) | Measure (Additive) | Output quantity from step |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit of measure |
| StepYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Step-level yield percentage |
| StepStatus | VARCHAR(30) | Attribute | Step execution status |
| OperatorKey | INTEGER | Foreign Key → DimOperator | Executing operator |
| VerifierKey | INTEGER | Foreign Key → DimOperator | Verifying operator |
| EsignatureTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Electronic signature timestamp |
| EsignatureMeaning | VARCHAR(200) | Attribute | Meaning of signature |
| HasDeviation | BOOLEAN | Attribute | Deviation presence flag |
| DeviationCount | NUMBER | Measure (Additive) | Count of deviations linked to step |
| StepNotes | VARCHAR(2000) | Attribute | Step notes |
| SourceRunIDMartA | VARCHAR(50) | Attribute | Run ID in Mart A |
| SourceStepIDOps | NUMBER | Attribute | Step ID in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Fact Table: FactEquipmentTelemetry

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactEquipmentTelemetryKey | INTEGER | Primary Key | Surrogate key |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Equipment generating telemetry |
| FactBatchStepKey | INTEGER | Foreign Key → FactBatchStep | Associated batch step (nullable) |
| FactProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Associated production order (nullable) |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch ID denormalized |
| ProcessParameterKey | INTEGER | Foreign Key → DimProcessParameter | Process parameter measured |
| ReadingDateKey | INTEGER | Foreign Key → DimDate | Reading calendar date (YYYYMMDD) |
| ReadingTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Reading timestamp in UTC |
| CanonicalValue | DECIMAL(18,4) | Measure (Additive) | Canonical value in canonical UOM |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceValue | DECIMAL(18,4) | Measure (Additive) | Original source value |
| SourceUom | VARCHAR(30) | Attribute | Original unit of measure |
| ConversionApplied | VARCHAR(200) | Attribute | Conversion formula used |
| TargetValue | DECIMAL(18,4) | Measure (Non-additive) | Recipe target value |
| LowerSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower specification limit |
| UpperSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper specification limit |
| LowerAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower alert limit |
| UpperAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper alert limit |
| WithinSpecification | BOOLEAN | Measure (Non-additive) | Specification compliance flag |
| WithinAlert | BOOLEAN | Measure (Non-additive) | Alert compliance flag |
| DeviationFromTarget | DECIMAL(18,4) | Measure (Non-additive) | Deviation from target value |
| GoldenBatchValue | DECIMAL(18,4) | Measure (Non-additive) | Golden batch comparison value |
| GoldenBatchDeviation | DECIMAL(18,4) | Measure (Non-additive) | Deviation from golden batch value |
| AggregationType | VARCHAR(30) | Attribute | Raw or aggregated granularity |
| SourceSystemType | VARCHAR(30) | Attribute | Source system type (SCADA/PLC/etc.) |
| SourceReadingIDMartA | VARCHAR(60) | Attribute | Reading ID in Mart A |
| SourceReadingIDOps | NUMBER | Attribute | Reading ID in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Fact Table: FactDeviation

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactDeviationKey | INTEGER | Primary Key | Surrogate key |
| CanonicalDeviationID | VARCHAR(60) | Attribute | Canonical deviation number |
| FactProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Linked production order |
| FactBatchStepKey | INTEGER | Foreign Key → FactBatchStep | Linked batch step |
| FactEquipmentTelemetryKey | INTEGER | Foreign Key → FactEquipmentTelemetry | Triggering telemetry reading |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Equipment involved |
| ProcessParameterKey | INTEGER | Foreign Key → DimProcessParameter | Parameter involved |
| DeviationCategoryKey | INTEGER | Foreign Key → DimDeviationCategory | Deviation category |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility where deviation occurred |
| CanonicalBatchID | VARCHAR(50) | Attribute | Canonical batch ID denormalized |
| DetectedDateKey | INTEGER | Foreign Key → DimDate | Detection date (YYYYMMDD) |
| DetectedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Deviations detection timestamp |
| DetectedByKey | INTEGER | Foreign Key → DimOperator | Detecting operator |
| DetectionMethod | VARCHAR(80) | Attribute | Detection method |
| SeverityCode | VARCHAR(20) | Attribute | Severity classification |
| PotentialImpact | VARCHAR(200) | Attribute | Potential impact description |
| DeviationDescription | VARCHAR(4000) | Attribute | Formal deviation description |
| InvestigationStatus | VARCHAR(30) | Attribute | Investigation status |
| AssignedToKey | INTEGER | Foreign Key → DimOperator | Assigned investigator |
| InvestigationStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation start timestamp |
| InvestigationEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation end timestamp |
| RootCauseCode | VARCHAR(80) | Attribute | Root cause code |
| RootCauseDescription | VARCHAR(2000) | Attribute | Root cause description |
| CapaRequired | BOOLEAN | Attribute | CAPA requirement flag |
| CapaReferenceID | VARCHAR(60) | Attribute | Linked CAPA record ID |
| CapaDueDateKey | INTEGER | Foreign Key → DimDate | CAPA due date (YYYYMMDD) |
| CapaClosedDateKey | INTEGER | Foreign Key → DimDate | CAPA closed date (YYYYMMDD) |
| ClosedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Deviation closure timestamp |
| ClosedByKey | INTEGER | Foreign Key → DimOperator | Closing operator |
| ResolutionSummary | VARCHAR(4000) | Attribute | Resolution summary |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification requirement flag |
| RegulatoryNotifiedDateKey | INTEGER | Foreign Key → DimDate | Regulatory notification date (YYYYMMDD) |
| SourceDevIDMartA | VARCHAR(50) | Attribute | Deviation ID in Mart A |
| SourceDevNumOps | VARCHAR(50) | Attribute | Deviation number in Operational System |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Fact Table: FactYieldAnalytics

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactYieldAnalyticsKey | INTEGER | Primary Key | Surrogate key |
| AnalysisDateKey | INTEGER | Foreign Key → DimDate | Analysis calendar date (YYYYMMDD) |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility analyzed |
| ProductKey | INTEGER | Foreign Key → DimProduct | Product analyzed |
| AggregationLevel | VARCHAR(30) | Attribute | Aggregation granularity |
| BatchesStarted | NUMBER | Measure (Additive) | Batches started in period |
| BatchesCompleted | NUMBER | Measure (Additive) | Batches completed in period |
| BatchesOnHold | NUMBER | Measure (Additive) | Batches on hold |
| BatchesFailed | NUMBER | Measure (Additive) | Batches failed or rejected |
| AvgYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Average yield percentage |
| MinYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Minimum yield percentage |
| MaxYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Maximum yield percentage |
| StdYieldPct | DECIMAL(8,4) | Measure (Non-additive) | Yield standard deviation |
| YieldBelowTargetCount | NUMBER | Measure (Additive) | Count of batches below target |
| YieldTargetAttainmentPct | DECIMAL(6,3) | Measure (Non-additive) | Percentage of batches meeting yield target |
| TotalPlannedQty | DECIMAL(18,3) | Measure (Additive) | Total planned quantity |
| TotalActualQty | DECIMAL(18,3) | Measure (Additive) | Total actual quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit of measure |
| AvgOeePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE percentage |
| AvgAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Availability |
| AvgPerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Performance |
| AvgQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Quality |
| TotalDeviations | NUMBER | Measure (Additive) | Total deviations in period |
| HighCriticalDeviations | NUMBER | Measure (Additive) | High or critical deviations |
| CppComplianceRatePct | DECIMAL(6,3) | Measure (Non-additive) | CPP compliance rate |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


#### Fact Table: FactShiftLog

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| FactShiftLogKey | INTEGER | Primary Key | Surrogate key |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility of the shift |
| LogDateKey | INTEGER | Foreign Key → DimDate | Shift log date (YYYYMMDD) |
| ShiftName | VARCHAR(20) | Attribute | Shift identifier |
| ShiftStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift start timestamp in UTC |
| ShiftEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift end timestamp in UTC |
| SupervisorKey | INTEGER | Foreign Key → DimOperator | Shift supervisor |
| ActiveBatches | NUMBER | Measure (Additive) | Batches in progress during shift |
| CompletedBatches | NUMBER | Measure (Additive) | Batches completed during shift |
| NewDeviations | NUMBER | Measure (Additive) | New deviations raised |
| ClosedDeviations | NUMBER | Measure (Additive) | Deviations closed |
| EquipmentDowntimeMins | NUMBER | Measure (Additive) | Unplanned equipment downtime minutes |
| EquipmentIssuesCount | NUMBER | Measure (Additive) | Equipment issues reported |
| SignedOff | BOOLEAN | Attribute | Shift sign-off flag |
| SignedOffUtc | TIMESTAMP_TZ | Measure (Non-additive) | Sign-off timestamp |
| ShiftNotes | VARCHAR(4000) | Attribute | Supervisor narrative notes |
| SourceLogIDMartA | NUMBER | Attribute | Shift log ID in Mart A |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source primary key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator user ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater user ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |


### Section 3 — Canonical to Star Mapping Table

| Star Table Name | Star Column Name | Canonical Entity | Canonical Attribute | Mapping Rule | Measure Type | SCD Type | PII |
|---|---|---|---|---|---|---|---|
| DimOrganization | OrganizationKey | DIM_ORGANIZATION | ORGANIZATION_KEY | Surrogate Key (system-generated INTEGER; use canonical ORGANIZATION_KEY only for initial load, then managed by warehouse) | — | Type 2 | — |
| DimOrganization | OrganizationID | DIM_ORGANIZATION | ORGANIZATION_ID | Direct | — | Type 2 | — |
| DimOrganization | OrganizationName | DIM_ORGANIZATION | ORGANIZATION_NAME | Direct | — | Type 2 | — |
| DimOrganization | OrganizationType | DIM_ORGANIZATION | ORGANIZATION_TYPE | Direct | — | Type 2 | — |
| DimOrganization | ParentOrganizationKey | DIM_ORGANIZATION | PARENT_ORGANIZATION_KEY | Direct (FK retained to same DimOrganization) | — | Type 2 | — |
| DimOrganization | CountryCode | DIM_ORGANIZATION | COUNTRY_CODE | Direct | — | Type 2 | — |
| DimOrganization | RegulatoryRegion | DIM_ORGANIZATION | REGULATORY_REGION | Direct | — | Type 2 | — |
| DimOrganization | IsActive | DIM_ORGANIZATION | IS_ACTIVE | Direct | — | Type 2 | — |
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
| DimFacility | FacilityKey | DIM_FACILITY | FACILITY_KEY | Surrogate Key (system-generated INTEGER; canonical FACILITY_KEY used only for initial load) | — | Type 2 | — |
| DimFacility | FacilityID | DIM_FACILITY | FACILITY_ID | Direct | — | Type 2 | — |
| DimFacility | FacilityName | DIM_FACILITY | FACILITY_NAME | Direct | — | Type 2 | — |
| DimFacility | FacilityShortName | DIM_FACILITY | FACILITY_SHORT_NAME | Direct | — | Type 2 | — |
| DimFacility | OrganizationKey | DIM_FACILITY | ORGANIZATION_KEY | Direct (FK to DimOrganization.OrganizationKey) | — | Type 2 | — |
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
| DimFacility | SourceSystem | DIM_FACILITY | _SOURCE_SYSTEM | Direct | — | — | — |
| DimFacility | SourceKey | DIM_FACILITY | _SOURCE_KEY | Direct | — | — | — |
| DimFacility | CreatedAt | DIM_FACILITY | CREATED_AT | Direct | — | — | — |
| DimFacility | CreatedBy | DIM_FACILITY | CREATED_BY | Direct | — | — | — |
| DimFacility | UpdatedAt | DIM_FACILITY | UPDATED_AT | Direct | — | — | — |
| DimFacility | UpdatedBy | DIM_FACILITY | UPDATED_BY | Direct | — | — | — |
| DimFacility | IsDeleted | DIM_FACILITY | IS_DELETED | Direct | — | — | — |
| DimFacility | DeletedAt | DIM_FACILITY | DELETED_AT | Direct | — | — | — |
| DimProduct | ProductKey | DIM_PRODUCT | PRODUCT_KEY | Surrogate Key (system-generated INTEGER; canonical PRODUCT_KEY used only for initial load) | — | Type 2 | — |
| DimProduct | ProductID | DIM_PRODUCT | PRODUCT_ID | Direct | — | Type 2 | — |
| DimProduct | Sku | DIM_PRODUCT | SKU | Direct | — | Type 2 | — |
| DimProduct | ProductName | DIM_PRODUCT | PRODUCT_NAME | Direct | — | Type 2 | — |
| DimProduct | ProductShortName | DIM_PRODUCT | PRODUCT_SHORT_NAME | Direct | — | Type 2 | — |
| DimProduct | OrganizationKey | DIM_PRODUCT | ORGANIZATION_KEY | Direct (FK to DimOrganization.OrganizationKey) | — | Type 2 | — |
| DimProduct | FormulationID | DIM_PRODUCT | FORMULATION_ID | Direct | — | Type 2 | — |
| DimProduct | FormulationVersion | DIM_PRODUCT | FORMULATION_VERSION | Direct | — | Type 2 | — |
| DimProduct | DosageForm | DIM_PRODUCT | DOSAGE_FORM | Direct | — | Type 2 | — |
| DimProduct | DosageStrength | DIM_PRODUCT | DOSAGE_STRENGTH | Direct | — | Type 2 | — |
| DimProduct | RouteOfAdministration | DIM_PRODUCT | ROUTE_OF_ADMINISTRATION | Direct | — | Type 2 | — |
| DimProduct | TherapeuticClass | DIM_PRODUCT | THERAPEUTIC_CLASS | Direct | — | Type 2 | — |
| DimProduct | TherapeuticArea | DIM_PRODUCT | THERAPEUTIC_AREA | Direct | — | Type 2 | — |
| DimProduct | ProductCategory | DIM_PRODUCT | PRODUCT_CATEGORY | Direct | — | Type 2 | — |
| DimProduct | IsBiosimilar | DIM_PRODUCT | IS_BIOSIMILAR | Direct | — | Type 2 | — |
| DimProduct | ReferenceProductID | DIM_PRODUCT | REFERENCE_PRODUCT_ID | Direct | — | Type 2 | — |
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
| DimProduct | SourceSystem | DIM_PRODUCT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimProduct | SourceKey | DIM_PRODUCT | _SOURCE_KEY | Direct | — | — | — |
| DimProduct | CreatedAt | DIM_PRODUCT | CREATED_AT | Direct | — | — | — |
| DimProduct | CreatedBy | DIM_PRODUCT | CREATED_BY | Direct | — | — | — |
| DimProduct | UpdatedAt | DIM_PRODUCT | UPDATED_AT | Direct | — | — | — |
| DimProduct | UpdatedBy | DIM_PRODUCT | UPDATED_BY | Direct | — | — | — |
| DimProduct | IsDeleted | DIM_PRODUCT | IS_DELETED | Direct | — | — | — |
| DimProduct | DeletedAt | DIM_PRODUCT | DELETED_AT | Direct | — | — | — |
| DimMaterialLot | MaterialLotKey | DIM_MATERIAL_LOT | MATERIAL_LOT_KEY | Surrogate Key (system-generated INTEGER; canonical MATERIAL_LOT_KEY used only for initial load) | — | — | — |
| DimMaterialLot | LotNumber | DIM_MATERIAL_LOT | LOT_NUMBER | Direct | — | — | — |
| DimMaterialLot | ProductKey | DIM_MATERIAL_LOT | PRODUCT_KEY | Direct (FK to DimProduct.ProductKey) | — | — | — |
| DimMaterialLot | FacilityKey | DIM_MATERIAL_LOT | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | — | — | — |
| DimMaterialLot | LotType | DIM_MATERIAL_LOT | LOT_TYPE | Direct | — | — | — |
| DimMaterialLot | ManufactureDate | DIM_MATERIAL_LOT | MANUFACTURE_DATE | Direct | — | — | — |
| DimMaterialLot | ExpiryDate | DIM_MATERIAL_LOT | EXPIRY_DATE | Direct | — | — | — |
| DimMaterialLot | RetestDate | DIM_MATERIAL_LOT | RETEST_DATE | Direct | — | — | — |
| DimMaterialLot | QuantityProduced | DIM_MATERIAL_LOT | QUANTITY_PRODUCED | Direct | — | — | — |
| DimMaterialLot | QuantityUnit | DIM_MATERIAL_LOT | QUANTITY_UNIT | Direct | — | — | — |
| DimMaterialLot | LotStatus | DIM_MATERIAL_LOT | LOT_STATUS | Direct | — | — | — |
| DimMaterialLot | CertificateOfAnalysis | DIM_MATERIAL_LOT | CERTIFICATE_OF_ANALYSIS | Direct | — | — | — |
| DimMaterialLot | VendorLotNumber | DIM_MATERIAL_LOT | VENDOR_LOT_NUMBER | Direct | — | — | — |
| DimMaterialLot | VendorID | DIM_MATERIAL_LOT | VENDOR_ID | Direct | — | — | — |
| DimMaterialLot | SourceSystem | DIM_MATERIAL_LOT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimMaterialLot | SourceKey | DIM_MATERIAL_LOT | _SOURCE_KEY | Direct | — | — | — |
| DimMaterialLot | CreatedAt | DIM_MATERIAL_LOT | CREATED_AT | Direct | — | — | — |
| DimMaterialLot | CreatedBy | DIM_MATERIAL_LOT | CREATED_BY | Direct | — | — | — |
| DimMaterialLot | UpdatedAt | DIM_MATERIAL_LOT | UPDATED_AT | Direct | — | — | — |
| DimMaterialLot | UpdatedBy | DIM_MATERIAL_LOT | UPDATED_BY | Direct | — | — | — |
| DimMaterialLot | IsDeleted | DIM_MATERIAL_LOT | IS_DELETED | Direct | — | — | — |
| DimMaterialLot | DeletedAt | DIM_MATERIAL_LOT | DELETED_AT | Direct | — | — | — |
| DimEquipment | EquipmentKey | DIM_EQUIPMENT | EQUIPMENT_KEY | Surrogate Key (system-generated INTEGER; canonical EQUIPMENT_KEY used only for initial load) | — | — | — |
| DimEquipment | CanonicalEquipmentID | DIM_EQUIPMENT | CANONICAL_EQUIPMENT_ID | Direct | — | — | — |
| DimEquipment | EquipmentName | DIM_EQUIPMENT | EQUIPMENT_NAME | Direct | — | — | — |
| DimEquipment | FacilityKey | DIM_EQUIPMENT | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | — | — | — |
| DimEquipment | FunctionalArea | DIM_EQUIPMENT | FUNCTIONAL_AREA | Direct | — | — | — |
| DimEquipment | ProductionUnit | DIM_EQUIPMENT | PRODUCTION_UNIT | Direct | — | — | — |
| DimEquipment | EquipmentModule | DIM_EQUIPMENT | EQUIPMENT_MODULE | Direct | — | — | — |
| DimEquipment | AssetClass | DIM_EQUIPMENT | ASSET_CLASS | Direct | — | — | — |
| DimEquipment | AssetSubclass | DIM_EQUIPMENT | ASSET_SUBCLASS | Direct | — | — | — |
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
| DimEquipment | SourceEquipIDMartA | DIM_EQUIPMENT | SOURCE_EQUIP_ID_MART_A | Direct | — | — | — |
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
| DimProcessStep | ProcessStepKey | DIM_PROCESS_STEP | PROCESS_STEP_KEY | Surrogate Key (system-generated INTEGER; canonical PROCESS_STEP_KEY used only for initial load) | — | — | — |
| DimProcessStep | StepCode | DIM_PROCESS_STEP | STEP_CODE | Direct | — | — | — |
| DimProcessStep | StepName | DIM_PROCESS_STEP | STEP_NAME | Direct | — | — | — |
| DimProcessStep | StepCategory | DIM_PROCESS_STEP | STEP_CATEGORY | Direct | — | — | — |
| DimProcessStep | StepSubcategory | DIM_PROCESS_STEP | STEP_SUBCATEGORY | Direct | — | — | — |
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
| DimProcessParameter | ProcessParameterKey | DIM_PROCESS_PARAMETER | PARAMETER_KEY | Surrogate Key (system-generated INTEGER; canonical PARAMETER_KEY used only for initial load) | — | — | — |
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
| DimProcessParameter | InstrumentType | DIM_PROCESS_PARAMETER | INSTRUMENT_TYPE | Direct |
