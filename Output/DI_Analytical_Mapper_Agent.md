### Section 1 — Modeling Summary

| Metric | Detail |
|----------------------------|-----------------------------------------------|
| Central Business Process | Pharma batch production & execution |
| Fact Table(s) | FactProductionOrder, FactBatchStep, FactEquipmentTelemetry, FactDeviation, FactYieldAnalytics, FactShiftLog |
| Dimension Tables | DimOrganization, DimFacility, DimProduct, DimMaterialLot, DimEquipment, DimProcessStep, DimProcessParameter, DimQualityDisposition, DimDeviationCategory, DimOperator, DimDate |
| Total Fact Measures | 63 |
| Total Dimension Attributes | 123 |
| SCD Type 2 Dimensions | DimFacility, DimProduct |
| PII-masked Columns | 0 |

---

### Section 2 — Star Schema Definition

#### Dimension Table: DimOrganization

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OrganizationKey | INTEGER | Primary Key | Surrogate key |
| OrganizationID | VARCHAR(50) | Natural Key | Enterprise org code |
| OrganizationName | VARCHAR(200) | Attribute | Full legal name |
| OrganizationType | VARCHAR(80) | Attribute | Company/division/business unit/subsidiary |
| ParentOrganizationKey | INTEGER | Attribute | Parent organization relationship |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 country code |
| RegulatoryRegion | VARCHAR(80) | Attribute | Regulatory jurisdiction |
| IsActive | BOOLEAN | Attribute | Active organization flag |
| EffectiveStartDate | DATE | SCD Type 2 | Start of record validity |
| EffectiveEndDate | DATE | SCD Type 2 | End of record validity |
| SourceSystem | VARCHAR(50) | Audit | Originating source system |
| SourceKey | VARCHAR(100) | Audit | Source system primary key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimFacility

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| FacilityKey | INTEGER | Primary Key | Surrogate key |
| FacilityID | VARCHAR(50) | Natural Key | Enterprise facility code |
| FacilityName | VARCHAR(200) | Attribute | Full official facility name |
| FacilityShortName | VARCHAR(80) | Attribute | Common short name |
| OrganizationKey | INTEGER | Foreign Key → DimOrganization | Parent organization |
| SiteCode | VARCHAR(20) | Attribute | Short site code |
| FacilityType | VARCHAR(80) | Attribute | Facility type classification |
| AddressLine1 | VARCHAR(200) | Attribute | Address line 1 |
| AddressLine2 | VARCHAR(200) | Attribute | Address line 2 |
| City | VARCHAR(100) | Attribute | City |
| StateRegion | VARCHAR(100) | Attribute | State or region |
| PostalCode | VARCHAR(20) | Attribute | Postal or ZIP code |
| CountryCode | CHAR(2) | Attribute | ISO 3166-1 alpha-2 country code |
| TimezoneName | VARCHAR(80) | Attribute | IANA timezone name |
| UtcOffsetHours | DECIMAL(4,2) | Attribute | UTC offset in hours |
| GmpCertified | BOOLEAN | Attribute | GMP certified flag |
| GmpCertificationDate | DATE | Attribute | Latest GMP certification date |
| GmpExpiryDate | DATE | Attribute | GMP certification expiry date |
| RegulatoryAgency | VARCHAR(80) | Attribute | Primary regulatory agency |
| FdaEstablishmentId | VARCHAR(50) | Attribute | FDA Establishment Identifier |
| EmaSiteCode | VARCHAR(50) | Attribute | EMA site code |
| ManufacturingCapacity | VARCHAR(80) | Attribute | Manufacturing scale classification |
| SourceSiteCodeMartA | VARCHAR(20) | Attribute | Mart A site code |
| SourcePlantCodeOps | VARCHAR(30) | Attribute | Operational system plant code |
| SourceFacCodeMartB | VARCHAR(30) | Attribute | Mart B facility code |
| EffectiveStartDate | DATE | SCD Type 2 | Start of SCD version |
| EffectiveEndDate | DATE | SCD Type 2 | End of SCD version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Active version flag |
| ScdVersion | NUMBER | SCD Type 2 | SCD version number |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
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
| FormulationId | VARCHAR(60) | Attribute | Formulation specification ID |
| FormulationVersion | VARCHAR(20) | Attribute | Formulation version number |
| DosageForm | VARCHAR(80) | Attribute | Pharmaceutical form |
| DosageStrength | VARCHAR(80) | Attribute | Strength descriptor |
| RouteOfAdministration | VARCHAR(80) | Attribute | Route of administration |
| TherapeuticClass | VARCHAR(100) | Attribute | Therapeutic category |
| TherapeuticArea | VARCHAR(100) | Attribute | Disease area |
| ProductCategory | VARCHAR(80) | Attribute | Product category classification |
| IsBiosimilar | BOOLEAN | Attribute | Biosimilar flag |
| ReferenceProductId | VARCHAR(50) | Attribute | Reference originator product ID |
| InnName | VARCHAR(200) | Attribute | International Nonproprietary Name |
| IdmpMpid | VARCHAR(100) | Attribute | IDMP Medicinal Product Identifier |
| NdaBlaNumber | VARCHAR(50) | Attribute | FDA NDA or BLA number |
| EmaProductNumber | VARCHAR(50) | Attribute | EMA product number |
| StandardYieldPct | DECIMAL(6,3) | Attribute | Target yield percentage |
| YieldLowerAlertPct | DECIMAL(6,3) | Attribute | Yield lower alert threshold |
| YieldLowerActionPct | DECIMAL(6,3) | Attribute | Yield lower action limit |
| ShelfLifeMonths | NUMBER | Attribute | Product shelf life in months |
| StorageCondition | VARCHAR(80) | Attribute | Required storage condition |
| EffectiveStartDate | DATE | SCD Type 2 | Start of SCD version |
| EffectiveEndDate | DATE | SCD Type 2 | End of SCD version |
| CurrentFlag | BOOLEAN | SCD Type 2 | Active version flag |
| ScdVersion | NUMBER | SCD Type 2 | SCD version number |
| SourceProductCodeMartA | VARCHAR(50) | Attribute | Mart A product code |
| SourceProductCodeOps | VARCHAR(50) | Attribute | Operational system product code |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimMaterialLot

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| MaterialLotKey | INTEGER | Primary Key | Surrogate key |
| LotNumber | VARCHAR(80) | Natural Key | GMP lot number |
| ProductKey | INTEGER | Foreign Key → DimProduct | Related product |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility producing/holding lot |
| LotType | VARCHAR(50) | Attribute | Lot type classification |
| ManufactureDate | DATE | Attribute | Manufacture or receipt date |
| ExpiryDate | DATE | Attribute | Lot expiry date |
| RetestDate | DATE | Attribute | Retest date |
| QuantityProduced | DECIMAL(18,3) | Attribute | Quantity produced/received |
| QuantityUnit | VARCHAR(20) | Attribute | Quantity unit of measure |
| LotStatus | VARCHAR(40) | Attribute | Lot status |
| CertificateOfAnalysis | VARCHAR(200) | Attribute | COA reference |
| VendorLotNumber | VARCHAR(80) | Attribute | Supplier lot number |
| VendorId | VARCHAR(80) | Attribute | Supplier identifier |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimEquipment

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| EquipmentKey | INTEGER | Primary Key | Surrogate key |
| CanonicalEquipmentId | VARCHAR(50) | Natural Key | Canonical equipment ID |
| EquipmentName | VARCHAR(200) | Attribute | Equipment descriptive name |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility location |
| FunctionalArea | VARCHAR(80) | Attribute | ISA-95 area |
| ProductionUnit | VARCHAR(80) | Attribute | ISA-95 production unit |
| EquipmentModule | VARCHAR(80) | Attribute | ISA-95 equipment module |
| AssetClass | VARCHAR(80) | Attribute | Asset class |
| AssetSubClass | VARCHAR(80) | Attribute | Asset subclass |
| CriticalityRating | VARCHAR(20) | Attribute | GMP criticality rating |
| ManufacturerName | VARCHAR(100) | Attribute | Manufacturer name |
| ModelNumber | VARCHAR(100) | Attribute | Model number |
| SerialNumber | VARCHAR(100) | Attribute | Serial number |
| WorkingVolumeL | DECIMAL(12,3) | Attribute | Working volume in litres |
| InstallationDate | DATE | Attribute | Installation date |
| CommissioningDate | DATE | Attribute | Commissioning date |
| QualificationStatus | VARCHAR(30) | Attribute | Qualification status |
| LastQualificationDate | DATE | Attribute | Last qualification date |
| NextQualificationDate | DATE | Attribute | Next qualification date |
| CalibrationFrequency | VARCHAR(30) | Attribute | Calibration frequency |
| LastCalibrationDate | DATE | Attribute | Last calibration date |
| CalibrationDueDate | DATE | Attribute | Next calibration due date |
| CalibrationStatus | VARCHAR(30) | Attribute | Calibration status |
| PlannedRuntimeMinsPerDay | NUMBER | Attribute | Planned runtime minutes per day |
| IdealCycleTimeSecs | DECIMAL(12,4) | Attribute | Ideal cycle time in seconds |
| EquipmentStatus | VARCHAR(30) | Attribute | Equipment status |
| StatusEffectiveDate | DATE | Attribute | Status effective date |
| DecommissionDate | DATE | Attribute | Decommission date |
| SourceEquipIdMartA | VARCHAR(50) | Attribute | Mart A equipment ID |
| SourceAssetCodeOps | VARCHAR(50) | Attribute | Operational system asset code |
| SourceEquipCodeMartB | VARCHAR(50) | Attribute | Mart B equipment code |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimProcessStep

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ProcessStepKey | INTEGER | Primary Key | Surrogate key |
| StepCode | VARCHAR(40) | Natural Key | Canonical step code |
| StepName | VARCHAR(100) | Attribute | Full step name |
| StepCategory | VARCHAR(60) | Attribute | Step category |
| StepSubCategory | VARCHAR(60) | Attribute | Step subcategory |
| TypicalSequenceOrder | NUMBER | Attribute | Typical sequence position |
| ExpectedDurationMinHrs | DECIMAL(8,2) | Attribute | Minimum expected duration in hours |
| ExpectedDurationMaxHrs | DECIMAL(8,2) | Attribute | Maximum expected duration in hours |
| ApplicableAssetClasses | VARCHAR(200) | Attribute | Asset classes used |
| IsCcp | BOOLEAN | Attribute | Critical Control Point flag |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimProcessParameter

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| ParameterKey | INTEGER | Primary Key | Surrogate key |
| ParameterCode | VARCHAR(60) | Natural Key | Canonical parameter code |
| ParameterName | VARCHAR(150) | Attribute | Parameter descriptive name |
| ParameterCategory | VARCHAR(60) | Attribute | Parameter category |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceUomMartA | VARCHAR(30) | Attribute | Mart A UOM |
| SourceUomOps | VARCHAR(30) | Attribute | Operational system UOM |
| SourceUomMartB | VARCHAR(30) | Attribute | Mart B UOM |
| ConversionFormulaOps | VARCHAR(200) | Attribute | Conversion formula from Ops to canonical |
| IsCpp | BOOLEAN | Attribute | Critical Process Parameter flag |
| IsKpa | BOOLEAN | Attribute | Key Process Attribute flag |
| TypicalTarget | DECIMAL(18,4) | Attribute | Typical target value |
| TypicalLsl | DECIMAL(18,4) | Attribute | Typical lower specification limit |
| TypicalUsl | DECIMAL(18,4) | Attribute | Typical upper specification limit |
| MeasurementFrequency | VARCHAR(50) | Attribute | Measurement frequency |
| InstrumentType | VARCHAR(100) | Attribute | Measuring instrument type |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimQualityDisposition

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DispositionKey | INTEGER | Primary Key | Surrogate key |
| DispositionCode | VARCHAR(40) | Natural Key | Canonical disposition code |
| DispositionName | VARCHAR(100) | Attribute | Disposition name |
| RequiresInvestigation | BOOLEAN | Attribute | Flag: investigation required |
| CommerciallyReleasable | BOOLEAN | Attribute | Flag: batch can be released |
| DeviationImplied | BOOLEAN | Attribute | Flag: deviation implied |
| PatientRiskLevel | VARCHAR(20) | Attribute | Patient risk level |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification required flag |
| DispositionDescription | VARCHAR(500) | Attribute | Business description |
| IsActive | BOOLEAN | Attribute | Active flag |
| SourceCodeMartA | VARCHAR(40) | Attribute | Mart A code |
| SourceCodeMartB | VARCHAR(40) | Attribute | Mart B code |
| SourceCodeOps | VARCHAR(10) | Attribute | Operational system code |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimDeviationCategory

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| DeviationCategoryKey | INTEGER | Primary Key | Surrogate key |
| CategoryCode | VARCHAR(50) | Natural Key | Deviation category code |
| CategoryName | VARCHAR(100) | Attribute | Category descriptive name |
| CategoryGroup | VARCHAR(80) | Attribute | High-level grouping |
| Description | VARCHAR(500) | Attribute | Category description |
| CapaTypicallyRequired | BOOLEAN | Attribute | CAPA requirement flag |
| IsActive | BOOLEAN | Attribute | Active flag |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Dimension Table: DimOperator

| Column Name | Data Type | Role | Description |
|---------------|---------------|-----------------|-------------------------|
| OperatorKey | INTEGER | Primary Key | Surrogate key |
| OperatorID | VARCHAR(50) | Natural Key | System operator ID |
| FullName | VARCHAR(200) | Attribute | Operator full legal name |
| RoleCode | VARCHAR(50) | Attribute | Role code |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Primary facility assignment |
| Department | VARCHAR(100) | Attribute | Department |
| IsGmpTrained | BOOLEAN | Attribute | GMP training flag |
| TrainingExpiryDate | DATE | Attribute | GMP training expiry date |
| EsignatureEnabled | BOOLEAN | Attribute | Electronic signature authorization flag |
| EmploymentStatus | VARCHAR(30) | Attribute | Employment status |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
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
| WeekNumber | INTEGER | Attribute | ISO week number |
| DayOfWeek | INTEGER | Attribute | Day of week (1–7) |
| DayName | VARCHAR(20) | Attribute | Day name |
| IsWeekend | BOOLEAN | Attribute | Weekend flag |
| IsHoliday | BOOLEAN | Attribute | Holiday flag |
| FiscalYear | INTEGER | Attribute | Fiscal year |
| FiscalQuarter | INTEGER | Attribute | Fiscal quarter |

#### Fact Table: FactProductionOrder

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ProductionOrderKey | INTEGER | Primary Key | Surrogate key |
| CanonicalBatchId | VARCHAR(50) | Attribute | Canonical batch identifier |
| ErpOrderNumber | VARCHAR(50) | Attribute | ERP production order number |
| MesBatchReference | VARCHAR(80) | Attribute | MES batch reference |
| GmpLotNumber | VARCHAR(80) | Attribute | GMP lot number |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility context |
| ProductKey | INTEGER | Foreign Key → DimProduct | Product context |
| PrimaryEquipmentKey | INTEGER | Foreign Key → DimEquipment | Primary equipment |
| DispositionKey | INTEGER | Foreign Key → DimQualityDisposition | Quality disposition |
| PlannedStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned start timestamp |
| PlannedEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Planned end timestamp |
| PlannedQuantity | DECIMAL(18,3) | Measure (Additive) | Planned quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit |
| ActualStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual start timestamp |
| ActualEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Actual end timestamp |
| ActualQuantity | DECIMAL(18,3) | Measure (Additive) | Actual quantity |
| YieldPct | DECIMAL(6,3) | Measure (Non-additive) | Yield percentage |
| YieldVariancePct | DECIMAL(8,4) | Measure (Non-additive) | Yield variance vs target |
| OeeAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Availability |
| OeePerformancePct | DECIMAL(6,3) | Measure (Non-additive) | OEE Performance |
| OeeQualityPct | DECIMAL(6,3) | Measure (Non-additive) | OEE Quality |
| OeeOverallPct | DECIMAL(6,3) | Measure (Non-additive) | Overall OEE |
| BatchStatus | VARCHAR(30) | Attribute | Canonical batch status |
| DeviationCount | NUMBER | Measure (Additive) | Count of deviations per batch |
| IsGoldenBatch | BOOLEAN | Attribute | Golden batch flag |
| GoldenBatchReference | VARCHAR(50) | Attribute | Reference golden batch ID |
| ShiftAtStart | VARCHAR(20) | Attribute | Shift name at start |
| ShiftSupervisorKey | INTEGER | Foreign Key → DimOperator | Supervisor at start |
| SourceBatchIdMartA | VARCHAR(50) | Attribute | Mart A batch ID |
| SourceBatchIdOps | VARCHAR(50) | Attribute | Operational system batch ID |
| SourceOrderNumOps | VARCHAR(50) | Attribute | Operational system order number |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Fact Table: FactBatchStep

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| BatchStepKey | INTEGER | Primary Key | Surrogate key |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Production order context |
| CanonicalBatchId | VARCHAR(50) | Attribute | Denormalized batch ID |
| ProcessStepKey | INTEGER | Foreign Key → DimProcessStep | Process step context |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Executing equipment |
| StepSequence | NUMBER | Measure (Additive) | Execution sequence order |
| StepStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step start timestamp |
| StepEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Step end timestamp |
| StepDurationHrs | DECIMAL(10,4) | Measure (Additive) | Step duration in hours |
| InputQuantity | DECIMAL(18,3) | Measure (Additive) | Input quantity |
| OutputQuantity | DECIMAL(18,3) | Measure (Additive) | Output quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit |
| StepYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Step yield percent |
| StepStatus | VARCHAR(30) | Attribute | Step execution status |
| OperatorKey | INTEGER | Foreign Key → DimOperator | Executing operator |
| VerifierKey | INTEGER | Foreign Key → DimOperator | Verifying operator |
| EsignatureTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Electronic signature timestamp |
| EsignatureMeaning | VARCHAR(200) | Attribute | Signature meaning |
| HasDeviation | BOOLEAN | Attribute | Deviation presence flag |
| DeviationCount | NUMBER | Measure (Additive) | Count of deviations at step |
| StepNotes | VARCHAR(2000) | Attribute | Free-text step notes |
| SourceRunIdMartA | VARCHAR(50) | Attribute | Mart A run ID |
| SourceStepIdOps | NUMBER | Attribute | Operational system step ID |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Fact Table: FactEquipmentTelemetry

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| TelemetryKey | INTEGER | Primary Key | Surrogate key |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Equipment context |
| BatchStepKey | INTEGER | Foreign Key → FactBatchStep | Batch step context |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Production order context |
| CanonicalBatchId | VARCHAR(50) | Attribute | Denormalized batch ID |
| ParameterKey | INTEGER | Foreign Key → DimProcessParameter | Process parameter context |
| ReadingTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Reading timestamp |
| CanonicalValue | DECIMAL(18,4) | Measure (Additive) | Reading value in canonical UOM |
| CanonicalUom | VARCHAR(30) | Attribute | Canonical unit of measure |
| SourceValue | DECIMAL(18,4) | Measure (Additive) | Original source value |
| SourceUom | VARCHAR(30) | Attribute | Original source UOM |
| ConversionApplied | VARCHAR(200) | Attribute | Conversion formula applied |
| TargetValue | DECIMAL(18,4) | Measure (Non-additive) | Recipe target value |
| LowerSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower specification limit |
| UpperSpecLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper specification limit |
| LowerAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Lower alert limit |
| UpperAlertLimit | DECIMAL(18,4) | Measure (Non-additive) | Upper alert limit |
| WithinSpecification | BOOLEAN | Attribute | Within specification flag |
| WithinAlert | BOOLEAN | Attribute | Within alert limits flag |
| DeviationFromTarget | DECIMAL(18,4) | Measure (Non-additive) | Deviation from target |
| GoldenBatchValue | DECIMAL(18,4) | Measure (Non-additive) | Golden batch reference value |
| GoldenBatchDeviation | DECIMAL(18,4) | Measure (Non-additive) | Deviation from golden batch |
| AggregationType | VARCHAR(30) | Attribute | Aggregation level |
| SourceSystemType | VARCHAR(30) | Attribute | Source system type |
| SourceReadingIdMartA | VARCHAR(60) | Attribute | Mart A reading ID |
| SourceReadingIdOps | NUMBER | Attribute | Operational system reading ID |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Fact Table: FactDeviation

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| DeviationKey | INTEGER | Primary Key | Surrogate key |
| CanonicalDeviationId | VARCHAR(60) | Attribute | Canonical deviation number |
| ProductionOrderKey | INTEGER | Foreign Key → FactProductionOrder | Production order context |
| BatchStepKey | INTEGER | Foreign Key → FactBatchStep | Batch step context |
| TelemetryKey | INTEGER | Foreign Key → FactEquipmentTelemetry | Triggering telemetry context |
| EquipmentKey | INTEGER | Foreign Key → DimEquipment | Equipment context |
| ParameterKey | INTEGER | Foreign Key → DimProcessParameter | Parameter context |
| DeviationCategoryKey | INTEGER | Foreign Key → DimDeviationCategory | Deviation category context |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility context |
| CanonicalBatchId | VARCHAR(50) | Attribute | Denormalized batch ID |
| DetectedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Detection timestamp |
| DetectedByKey | INTEGER | Foreign Key → DimOperator | Detector operator |
| DetectionMethod | VARCHAR(80) | Attribute | Detection method |
| SeverityCode | VARCHAR(20) | Attribute | Severity code |
| PotentialImpact | VARCHAR(200) | Attribute | Potential impact description |
| DeviationDescription | VARCHAR(4000) | Attribute | Detailed deviation description |
| InvestigationStatus | VARCHAR(30) | Attribute | Investigation status |
| AssignedToKey | INTEGER | Foreign Key → DimOperator | Assigned investigator |
| InvestigationStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation start timestamp |
| InvestigationEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Investigation end timestamp |
| RootCauseCode | VARCHAR(80) | Attribute | Root cause category |
| RootCauseDescription | VARCHAR(2000) | Attribute | Root cause detailed description |
| CapaRequired | BOOLEAN | Attribute | CAPA required flag |
| CapaReferenceId | VARCHAR(60) | Attribute | CAPA record identifier |
| CapaDueDate | DATE | Measure (Non-additive) | CAPA due date |
| CapaClosedDate | DATE | Measure (Non-additive) | CAPA closed date |
| ClosedTimestampUtc | TIMESTAMP_TZ | Measure (Non-additive) | Deviation closure timestamp |
| ClosedByKey | INTEGER | Foreign Key → DimOperator | Closure owner |
| ResolutionSummary | VARCHAR(4000) | Attribute | Resolution summary |
| RegulatoryNotificationRequired | BOOLEAN | Attribute | Regulatory notification required flag |
| RegulatoryNotifiedDate | DATE | Measure (Non-additive) | Regulatory notified date |
| SourceDevIdMartA | VARCHAR(50) | Attribute | Mart A deviation ID |
| SourceDevNumOps | VARCHAR(50) | Attribute | Operational system deviation number |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Fact Table: FactYieldAnalytics

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| YieldAnalyticsKey | INTEGER | Primary Key | Surrogate key |
| AnalysisDate | DATE | Foreign Key → DimDate.DateKey (logical) | Analytics date |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility context |
| ProductKey | INTEGER | Foreign Key → DimProduct | Product context |
| AggregationLevel | VARCHAR(30) | Attribute | Aggregation level |
| BatchesStarted | NUMBER | Measure (Additive) | Count of batches started |
| BatchesCompleted | NUMBER | Measure (Additive) | Count of batches completed |
| BatchesOnHold | NUMBER | Measure (Additive) | Count of batches on hold |
| BatchesFailed | NUMBER | Measure (Additive) | Count of failed/rejected batches |
| AvgYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Average yield percent |
| MinYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Minimum yield percent |
| MaxYieldPct | DECIMAL(6,3) | Measure (Non-additive) | Maximum yield percent |
| StdYieldPct | DECIMAL(8,4) | Measure (Non-additive) | Yield standard deviation |
| YieldBelowTargetCount | NUMBER | Measure (Additive) | Count of batches below target |
| YieldTargetAttainmentPct | DECIMAL(6,3) | Measure (Non-additive) | Percent meeting/exceeding target |
| TotalPlannedQty | DECIMAL(18,3) | Measure (Additive) | Total planned quantity |
| TotalActualQty | DECIMAL(18,3) | Measure (Additive) | Total actual quantity |
| QuantityUom | VARCHAR(20) | Attribute | Quantity unit |
| AvgOeePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE |
| AvgAvailabilityPct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Availability |
| AvgPerformancePct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Performance |
| AvgQualityPct | DECIMAL(6,3) | Measure (Non-additive) | Average OEE Quality |
| TotalDeviations | NUMBER | Measure (Additive) | Total deviations |
| HighCriticalDeviations | NUMBER | Measure (Additive) | High/critical deviations |
| CppComplianceRatePct | DECIMAL(6,3) | Measure (Non-additive) | CPP compliance rate |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

#### Fact Table: FactShiftLog

| Column Name | Data Type | Role | Description |
|---------------|----------------|----------------------------|-----------------|
| ShiftLogKey | INTEGER | Primary Key | Surrogate key |
| FacilityKey | INTEGER | Foreign Key → DimFacility | Facility context |
| LogDate | DATE | Foreign Key → DimDate.DateKey (logical) | Shift date |
| ShiftName | VARCHAR(20) | Attribute | Shift identifier |
| ShiftStartUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift start timestamp |
| ShiftEndUtc | TIMESTAMP_TZ | Measure (Non-additive) | Shift end timestamp |
| SupervisorKey | INTEGER | Foreign Key → DimOperator | Supervisor context |
| ActiveBatches | NUMBER | Measure (Additive) | Batches in progress |
| CompletedBatches | NUMBER | Measure (Additive) | Batches completed |
| NewDeviations | NUMBER | Measure (Additive) | New deviations raised |
| ClosedDeviations | NUMBER | Measure (Additive) | Deviations closed |
| EquipmentDowntimeMins | NUMBER | Measure (Additive) | Equipment downtime minutes |
| EquipmentIssuesCount | NUMBER | Measure (Additive) | Equipment issues count |
| SignedOff | BOOLEAN | Attribute | Sign-off flag |
| SignedOffUtc | TIMESTAMP_TZ | Measure (Non-additive) | Sign-off timestamp |
| ShiftNotes | VARCHAR(4000) | Attribute | Shift notes |
| SourceLogIdMartA | NUMBER | Attribute | Mart A shift log ID |
| SourceSystem | VARCHAR(50) | Audit | Source system |
| SourceKey | VARCHAR(100) | Audit | Source key |
| LoadedAtUtc | TIMESTAMP_TZ | Audit | Load timestamp |
| CreatedAt | TIMESTAMP_TZ | Audit | Creation timestamp |
| CreatedBy | VARCHAR(100) | Audit | Creator ID |
| UpdatedAt | TIMESTAMP_TZ | Audit | Last update timestamp |
| UpdatedBy | VARCHAR(100) | Audit | Last updater ID |
| IsDeleted | BOOLEAN | Audit | Soft delete flag |
| DeletedAt | TIMESTAMP_TZ | Audit | Soft delete timestamp |

---

### Section 3 — Canonical to Star Mapping Table

| Star Table Name | Star Column Name | Canonical Entity | Canonical Attribute | Mapping Rule | Measure Type | SCD Type | PII |
|---|---|---|---|---|---|---|---|
| DimOrganization | OrganizationKey | DIM_ORGANIZATION | ORGANIZATION_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| DimOrganization | OrganizationID | DIM_ORGANIZATION | ORGANIZATION_ID | Direct | — | — | — |
| DimOrganization | OrganizationName | DIM_ORGANIZATION | ORGANIZATION_NAME | Direct | — | — | — |
| DimOrganization | OrganizationType | DIM_ORGANIZATION | ORGANIZATION_TYPE | Direct | — | — | — |
| DimOrganization | ParentOrganizationKey | DIM_ORGANIZATION | PARENT_ORGANIZATION_KEY | Direct | — | — | — |
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
| DimFacility | FacilityKey | DIM_FACILITY | FACILITY_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | Type 2 | — |
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
| DimProduct | ProductKey | DIM_PRODUCT | PRODUCT_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | Type 2 | — |
| DimProduct | ProductID | DIM_PRODUCT | PRODUCT_ID | Direct | — | Type 2 | — |
| DimProduct | Sku | DIM_PRODUCT | SKU | Direct | — | Type 2 | — |
| DimProduct | ProductName | DIM_PRODUCT | PRODUCT_NAME | Direct | — | Type 2 | — |
| DimProduct | ProductShortName | DIM_PRODUCT | PRODUCT_SHORT_NAME | Direct | — | Type 2 | — |
| DimProduct | OrganizationKey | DIM_PRODUCT | ORGANIZATION_KEY | Direct (FK to DimOrganization.OrganizationKey) | — | Type 2 | — |
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
| DimProduct | SourceSystem | DIM_PRODUCT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimProduct | SourceKey | DIM_PRODUCT | _SOURCE_KEY | Direct | — | — | — |
| DimProduct | CreatedAt | DIM_PRODUCT | CREATED_AT | Direct | — | — | — |
| DimProduct | CreatedBy | DIM_PRODUCT | CREATED_BY | Direct | — | — | — |
| DimProduct | UpdatedAt | DIM_PRODUCT | UPDATED_AT | Direct | — | — | — |
| DimProduct | UpdatedBy | DIM_PRODUCT | UPDATED_BY | Direct | — | — | — |
| DimProduct | IsDeleted | DIM_PRODUCT | IS_DELETED | Direct | — | — | — |
| DimProduct | DeletedAt | DIM_PRODUCT | DELETED_AT | Direct | — | — | — |
| DimMaterialLot | MaterialLotKey | DIM_MATERIAL_LOT | MATERIAL_LOT_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
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
| DimMaterialLot | VendorId | DIM_MATERIAL_LOT | VENDOR_ID | Direct | — | — | — |
| DimMaterialLot | SourceSystem | DIM_MATERIAL_LOT | _SOURCE_SYSTEM | Direct | — | — | — |
| DimMaterialLot | SourceKey | DIM_MATERIAL_LOT | _SOURCE_KEY | Direct | — | — | — |
| DimMaterialLot | CreatedAt | DIM_MATERIAL_LOT | CREATED_AT | Direct | — | — | — |
| DimMaterialLot | CreatedBy | DIM_MATERIAL_LOT | CREATED_BY | Direct | — | — | — |
| DimMaterialLot | UpdatedAt | DIM_MATERIAL_LOT | UPDATED_AT | Direct | — | — | — |
| DimMaterialLot | UpdatedBy | DIM_MATERIAL_LOT | UPDATED_BY | Direct | — | — | — |
| DimMaterialLot | IsDeleted | DIM_MATERIAL_LOT | IS_DELETED | Direct | — | — | — |
| DimMaterialLot | DeletedAt | DIM_MATERIAL_LOT | DELETED_AT | Direct | — | — | — |
| DimEquipment | EquipmentKey | DIM_EQUIPMENT | EQUIPMENT_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| DimEquipment | CanonicalEquipmentId | DIM_EQUIPMENT | CANONICAL_EQUIPMENT_ID | Direct | — | — | — |
| DimEquipment | EquipmentName | DIM_EQUIPMENT | EQUIPMENT_NAME | Direct | — | — | — |
| DimEquipment | FacilityKey | DIM_EQUIPMENT | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | — | — | — |
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
| DimProcessStep | ProcessStepKey | DIM_PROCESS_STEP | PROCESS_STEP_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
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
| DimProcessParameter | ParameterKey | DIM_PROCESS_PARAMETER | PARAMETER_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
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
| DimQualityDisposition | DispositionKey | DIM_QUALITY_DISPOSITION | DISPOSITION_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
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
| DimDeviationCategory | DeviationCategoryKey | DIM_DEVIATION_CATEGORY | DEVIATION_CATEGORY_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
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
| DimOperator | OperatorKey | DIM_OPERATOR | OPERATOR_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| DimOperator | OperatorID | DIM_OPERATOR | OPERATOR_ID | Direct | — | — | — |
| DimOperator | FullName | DIM_OPERATOR | FULL_NAME | Direct | — | — | — |
| DimOperator | RoleCode | DIM_OPERATOR | ROLE_CODE | Direct | — | — | — |
| DimOperator | FacilityKey | DIM_OPERATOR | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | — | — | — |
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
| DimDate | DateKey | DimDate | DateKey | Default (system-generated YYYYMMDD from FullDate) | — | — | — |
| DimDate | FullDate | DimDate | FullDate | Direct (calendar date loaded from calendar table) | — | — | — |
| DimDate | Day | DimDate | Day | Derived (EXTRACT day from FullDate) | — | — | — |
| DimDate | Month | DimDate | Month | Derived (EXTRACT month from FullDate) | — | — | — |
| DimDate | MonthName | DimDate | MonthName | Derived (to_char(FullDate,'Month')) | — | — | — |
| DimDate | Quarter | DimDate | Quarter | Derived (EXTRACT quarter from FullDate) | — | — | — |
| DimDate | Year | DimDate | Year | Derived (EXTRACT year from FullDate) | — | — | — |
| DimDate | WeekNumber | DimDate | WeekNumber | Derived (ISO week from FullDate) | — | — | — |
| DimDate | DayOfWeek | DimDate | DayOfWeek | Derived | — | — | — |
| DimDate | DayName | DimDate | DayName | Derived | — | — | — |
| DimDate | IsWeekend | DimDate | IsWeekend | Derived | — | — | — |
| DimDate | IsHoliday | DimDate | IsHoliday | Derived/lookup from holiday calendar | — | — | — |
| DimDate | FiscalYear | DimDate | FiscalYear | Derived per fiscal calendar | — | — | — |
| DimDate | FiscalQuarter | DimDate | FiscalQuarter | Derived per fiscal calendar | — | — | — |
| FactProductionOrder | ProductionOrderKey | FACT_PRODUCTION_ORDER | PRODUCTION_ORDER_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactProductionOrder | CanonicalBatchId | FACT_PRODUCTION_ORDER | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FactProductionOrder | ErpOrderNumber | FACT_PRODUCTION_ORDER | ERP_ORDER_NUMBER | Direct | Non-additive | — | — |
| FactProductionOrder | MesBatchReference | FACT_PRODUCTION_ORDER | MES_BATCH_REFERENCE | Direct | Non-additive | — | — |
| FactProductionOrder | GmpLotNumber | FACT_PRODUCTION_ORDER | GMP_LOT_NUMBER | Direct | Non-additive | — | — |
| FactProductionOrder | FacilityKey | FACT_PRODUCTION_ORDER | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | Non-additive | — | — |
| FactProductionOrder | ProductKey | FACT_PRODUCTION_ORDER | PRODUCT_KEY | Direct (FK to DimProduct.ProductKey) | Non-additive | — | — |
| FactProductionOrder | PrimaryEquipmentKey | FACT_PRODUCTION_ORDER | PRIMARY_EQUIPMENT_KEY | Direct (FK to DimEquipment.EquipmentKey) | Non-additive | — | — |
| FactProductionOrder | DispositionKey | FACT_PRODUCTION_ORDER | DISPOSITION_KEY | Direct (FK to DimQualityDisposition.DispositionKey) | Non-additive | — | — |
| FactProductionOrder | PlannedStartUtc | FACT_PRODUCTION_ORDER | PLANNED_START_UTC | Direct | Non-additive | — | — |
| FactProductionOrder | PlannedEndUtc | FACT_PRODUCTION_ORDER | PLANNED_END_UTC | Direct | Non-additive | — | — |
| FactProductionOrder | PlannedQuantity | FACT_PRODUCTION_ORDER | PLANNED_QUANTITY | Direct | Additive | — | — |
| FactProductionOrder | QuantityUom | FACT_PRODUCTION_ORDER | QUANTITY_UOM | Direct | — | — | — |
| FactProductionOrder | ActualStartUtc | FACT_PRODUCTION_ORDER | ACTUAL_START_UTC | Direct | Non-additive | — | — |
| FactProductionOrder | ActualEndUtc | FACT_PRODUCTION_ORDER | ACTUAL_END_UTC | Direct | Non-additive | — | — |
| FactProductionOrder | ActualQuantity | FACT_PRODUCTION_ORDER | ACTUAL_QUANTITY | Direct | Additive | — | — |
| FactProductionOrder | YieldPct | FACT_PRODUCTION_ORDER | YIELD_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | YieldVariancePct | FACT_PRODUCTION_ORDER | YIELD_VARIANCE_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeAvailabilityPct | FACT_PRODUCTION_ORDER | OEE_AVAILABILITY_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeePerformancePct | FACT_PRODUCTION_ORDER | OEE_PERFORMANCE_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeQualityPct | FACT_PRODUCTION_ORDER | OEE_QUALITY_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | OeeOverallPct | FACT_PRODUCTION_ORDER | OEE_OVERALL_PCT | Direct | Non-additive | — | — |
| FactProductionOrder | BatchStatus | FACT_PRODUCTION_ORDER | BATCH_STATUS | Direct | Non-additive | — | — |
| FactProductionOrder | DeviationCount | FACT_PRODUCTION_ORDER | DEVIATION_COUNT | Direct | Additive | — | — |
| FactProductionOrder | IsGoldenBatch | FACT_PRODUCTION_ORDER | IS_GOLDEN_BATCH | Direct | Non-additive | — | — |
| FactProductionOrder | GoldenBatchReference | FACT_PRODUCTION_ORDER | GOLDEN_BATCH_REFERENCE | Direct | Non-additive | — | — |
| FactProductionOrder | ShiftAtStart | FACT_PRODUCTION_ORDER | SHIFT_AT_START | Direct | Non-additive | — | — |
| FactProductionOrder | ShiftSupervisorKey | FACT_PRODUCTION_ORDER | SHIFT_SUPERVISOR_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactProductionOrder | SourceBatchIdMartA | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_MART_A | Direct | Non-additive | — | — |
| FactProductionOrder | SourceBatchIdOps | FACT_PRODUCTION_ORDER | SOURCE_BATCH_ID_OPS | Direct | Non-additive | — | — |
| FactProductionOrder | SourceOrderNumOps | FACT_PRODUCTION_ORDER | SOURCE_ORDER_NUM_OPS | Direct | Non-additive | — | — |
| FactProductionOrder | SourceSystem | FACT_PRODUCTION_ORDER | _SOURCE_SYSTEM | Direct | — | — | — |
| FactProductionOrder | SourceKey | FACT_PRODUCTION_ORDER | _SOURCE_KEY | Direct | — | — | — |
| FactProductionOrder | LoadedAtUtc | FACT_PRODUCTION_ORDER | _LOADED_AT_UTC | Direct | — | — | — |
| FactProductionOrder | CreatedAt | FACT_PRODUCTION_ORDER | CREATED_AT | Direct | — | — | — |
| FactProductionOrder | CreatedBy | FACT_PRODUCTION_ORDER | CREATED_BY | Direct | — | — | — |
| FactProductionOrder | UpdatedAt | FACT_PRODUCTION_ORDER | UPDATED_AT | Direct | — | — | — |
| FactProductionOrder | UpdatedBy | FACT_PRODUCTION_ORDER | UPDATED_BY | Direct | — | — | — |
| FactProductionOrder | IsDeleted | FACT_PRODUCTION_ORDER | IS_DELETED | Direct | — | — | — |
| FactProductionOrder | DeletedAt | FACT_PRODUCTION_ORDER | DELETED_AT | Direct | — | — | — |
| FactBatchStep | BatchStepKey | FACT_BATCH_STEP | BATCH_STEP_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactBatchStep | ProductionOrderKey | FACT_BATCH_STEP | PRODUCTION_ORDER_KEY | Direct (FK to FactProductionOrder.ProductionOrderKey) | Non-additive | — | — |
| FactBatchStep | CanonicalBatchId | FACT_BATCH_STEP | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FactBatchStep | ProcessStepKey | FACT_BATCH_STEP | PROCESS_STEP_KEY | Direct (FK to DimProcessStep.ProcessStepKey) | Non-additive | — | — |
| FactBatchStep | EquipmentKey | FACT_BATCH_STEP | EQUIPMENT_KEY | Direct (FK to DimEquipment.EquipmentKey) | Non-additive | — | — |
| FactBatchStep | StepSequence | FACT_BATCH_STEP | STEP_SEQUENCE | Direct | Additive | — | — |
| FactBatchStep | StepStartUtc | FACT_BATCH_STEP | STEP_START_UTC | Direct | Non-additive | — | — |
| FactBatchStep | StepEndUtc | FACT_BATCH_STEP | STEP_END_UTC | Direct | Non-additive | — | — |
| FactBatchStep | StepDurationHrs | FACT_BATCH_STEP | STEP_DURATION_HRS | Direct | Additive | — | — |
| FactBatchStep | InputQuantity | FACT_BATCH_STEP | INPUT_QUANTITY | Direct | Additive | — | — |
| FactBatchStep | OutputQuantity | FACT_BATCH_STEP | OUTPUT_QUANTITY | Direct | Additive | — | — |
| FactBatchStep | QuantityUom | FACT_BATCH_STEP | QUANTITY_UOM | Direct | — | — | — |
| FactBatchStep | StepYieldPct | FACT_BATCH_STEP | STEP_YIELD_PCT | Direct | Non-additive | — | — |
| FactBatchStep | StepStatus | FACT_BATCH_STEP | STEP_STATUS | Direct | Non-additive | — | — |
| FactBatchStep | OperatorKey | FACT_BATCH_STEP | OPERATOR_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactBatchStep | VerifierKey | FACT_BATCH_STEP | VERIFIER_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactBatchStep | EsignatureTimestampUtc | FACT_BATCH_STEP | ESIGNATURE_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FactBatchStep | EsignatureMeaning | FACT_BATCH_STEP | ESIGNATURE_MEANING | Direct | — | — | — |
| FactBatchStep | HasDeviation | FACT_BATCH_STEP | HAS_DEVIATION | Direct | Non-additive | — | — |
| FactBatchStep | DeviationCount | FACT_BATCH_STEP | DEVIATION_COUNT | Direct | Additive | — | — |
| FactBatchStep | StepNotes | FACT_BATCH_STEP | STEP_NOTES | Direct | — | — | — |
| FactBatchStep | SourceRunIdMartA | FACT_BATCH_STEP | SOURCE_RUN_ID_MART_A | Direct | — | — | — |
| FactBatchStep | SourceStepIdOps | FACT_BATCH_STEP | SOURCE_STEP_ID_OPS | Direct | — | — | — |
| FactBatchStep | SourceSystem | FACT_BATCH_STEP | _SOURCE_SYSTEM | Direct | — | — | — |
| FactBatchStep | SourceKey | FACT_BATCH_STEP | _SOURCE_KEY | Direct | — | — | — |
| FactBatchStep | LoadedAtUtc | FACT_BATCH_STEP | _LOADED_AT_UTC | Direct | — | — | — |
| FactBatchStep | CreatedAt | FACT_BATCH_STEP | CREATED_AT | Direct | — | — | — |
| FactBatchStep | CreatedBy | FACT_BATCH_STEP | CREATED_BY | Direct | — | — | — |
| FactBatchStep | UpdatedAt | FACT_BATCH_STEP | UPDATED_AT | Direct | — | — | — |
| FactBatchStep | UpdatedBy | FACT_BATCH_STEP | UPDATED_BY | Direct | — | — | — |
| FactBatchStep | IsDeleted | FACT_BATCH_STEP | IS_DELETED | Direct | — | — | — |
| FactBatchStep | DeletedAt | FACT_BATCH_STEP | DELETED_AT | Direct | — | — | — |
| FactEquipmentTelemetry | TelemetryKey | FACT_EQUIPMENT_TELEMETRY | TELEMETRY_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactEquipmentTelemetry | EquipmentKey | FACT_EQUIPMENT_TELEMETRY | EQUIPMENT_KEY | Direct (FK to DimEquipment.EquipmentKey) | Non-additive | — | — |
| FactEquipmentTelemetry | BatchStepKey | FACT_EQUIPMENT_TELEMETRY | BATCH_STEP_KEY | Direct (FK to FactBatchStep.BatchStepKey) | Non-additive | — | — |
| FactEquipmentTelemetry | ProductionOrderKey | FACT_EQUIPMENT_TELEMETRY | PRODUCTION_ORDER_KEY | Direct (FK to FactProductionOrder.ProductionOrderKey) | Non-additive | — | — |
| FactEquipmentTelemetry | CanonicalBatchId | FACT_EQUIPMENT_TELEMETRY | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | ParameterKey | FACT_EQUIPMENT_TELEMETRY | PARAMETER_KEY | Direct (FK to DimProcessParameter.ParameterKey) | Non-additive | — | — |
| FactEquipmentTelemetry | ReadingTimestampUtc | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Direct | Non-additive | — | — |
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
| FactEquipmentTelemetry | WithinSpecification | FACT_EQUIPMENT_TELEMETRY | WITHIN_SPECIFICATION | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | WithinAlert | FACT_EQUIPMENT_TELEMETRY | WITHIN_ALERT | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | DeviationFromTarget | FACT_EQUIPMENT_TELEMETRY | DEVIATION_FROM_TARGET | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | GoldenBatchValue | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_VALUE | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | GoldenBatchDeviation | FACT_EQUIPMENT_TELEMETRY | GOLDEN_BATCH_DEVIATION | Direct | Non-additive | — | — |
| FactEquipmentTelemetry | AggregationType | FACT_EQUIPMENT_TELEMETRY | AGGREGATION_TYPE | Direct | — | — | — |
| FactEquipmentTelemetry | SourceSystemType | FACT_EQUIPMENT_TELEMETRY | SOURCE_SYSTEM_TYPE | Direct | — | — | — |
| FactEquipmentTelemetry | SourceReadingIdMartA | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_MART_A | Direct | — | — | — |
| FactEquipmentTelemetry | SourceReadingIdOps | FACT_EQUIPMENT_TELEMETRY | SOURCE_READING_ID_OPS | Direct | — | — | — |
| FactEquipmentTelemetry | SourceSystem | FACT_EQUIPMENT_TELEMETRY | _SOURCE_SYSTEM | Direct | — | — | — |
| FactEquipmentTelemetry | SourceKey | FACT_EQUIPMENT_TELEMETRY | _SOURCE_KEY | Direct | — | — | — |
| FactEquipmentTelemetry | LoadedAtUtc | FACT_EQUIPMENT_TELEMETRY | _LOADED_AT_UTC | Direct | — | — | — |
| FactEquipmentTelemetry | CreatedAt | FACT_EQUIPMENT_TELEMETRY | CREATED_AT | Direct | — | — | — |
| FactEquipmentTelemetry | CreatedBy | FACT_EQUIPMENT_TELEMETRY | CREATED_BY | Direct | — | — | — |
| FactEquipmentTelemetry | IsDeleted | FACT_EQUIPMENT_TELEMETRY | IS_DELETED | Direct | — | — | — |
| FactEquipmentTelemetry | DeletedAt | FACT_EQUIPMENT_TELEMETRY | DELETED_AT | Direct | — | — | — |
| FactDeviation | DeviationKey | FACT_DEVIATION | DEVIATION_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactDeviation | CanonicalDeviationId | FACT_DEVIATION | CANONICAL_DEVIATION_ID | Direct | Non-additive | — | — |
| FactDeviation | ProductionOrderKey | FACT_DEVIATION | PRODUCTION_ORDER_KEY | Direct (FK to FactProductionOrder.ProductionOrderKey) | Non-additive | — | — |
| FactDeviation | BatchStepKey | FACT_DEVIATION | BATCH_STEP_KEY | Direct (FK to FactBatchStep.BatchStepKey) | Non-additive | — | — |
| FactDeviation | TelemetryKey | FACT_DEVIATION | TELEMETRY_KEY | Direct (FK to FactEquipmentTelemetry.TelemetryKey) | Non-additive | — | — |
| FactDeviation | EquipmentKey | FACT_DEVIATION | EQUIPMENT_KEY | Direct (FK to DimEquipment.EquipmentKey) | Non-additive | — | — |
| FactDeviation | ParameterKey | FACT_DEVIATION | PARAMETER_KEY | Direct (FK to DimProcessParameter.ParameterKey) | Non-additive | — | — |
| FactDeviation | DeviationCategoryKey | FACT_DEVIATION | DEVIATION_CATEGORY_KEY | Direct (FK to DimDeviationCategory.DeviationCategoryKey) | Non-additive | — | — |
| FactDeviation | FacilityKey | FACT_DEVIATION | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | Non-additive | — | — |
| FactDeviation | CanonicalBatchId | FACT_DEVIATION | CANONICAL_BATCH_ID | Direct | Non-additive | — | — |
| FactDeviation | DetectedTimestampUtc | FACT_DEVIATION | DETECTED_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FactDeviation | DetectedByKey | FACT_DEVIATION | DETECTED_BY_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactDeviation | DetectionMethod | FACT_DEVIATION | DETECTION_METHOD | Direct | — | — | — |
| FactDeviation | SeverityCode | FACT_DEVIATION | SEVERITY_CODE | Direct | — | — | — |
| FactDeviation | PotentialImpact | FACT_DEVIATION | POTENTIAL_IMPACT | Direct | — | — | — |
| FactDeviation | DeviationDescription | FACT_DEVIATION | DEVIATION_DESCRIPTION | Direct | — | — | — |
| FactDeviation | InvestigationStatus | FACT_DEVIATION | INVESTIGATION_STATUS | Direct | — | — | — |
| FactDeviation | AssignedToKey | FACT_DEVIATION | ASSIGNED_TO_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactDeviation | InvestigationStartUtc | FACT_DEVIATION | INVESTIGATION_START_UTC | Direct | Non-additive | — | — |
| FactDeviation | InvestigationEndUtc | FACT_DEVIATION | INVESTIGATION_END_UTC | Direct | Non-additive | — | — |
| FactDeviation | RootCauseCode | FACT_DEVIATION | ROOT_CAUSE_CODE | Direct | — | — | — |
| FactDeviation | RootCauseDescription | FACT_DEVIATION | ROOT_CAUSE_DESCRIPTION | Direct | — | — | — |
| FactDeviation | CapaRequired | FACT_DEVIATION | CAPA_REQUIRED | Direct | — | — | — |
| FactDeviation | CapaReferenceId | FACT_DEVIATION | CAPA_REFERENCE_ID | Direct | — | — | — |
| FactDeviation | CapaDueDate | FACT_DEVIATION | CAPA_DUE_DATE | Direct | Non-additive | — | — |
| FactDeviation | CapaClosedDate | FACT_DEVIATION | CAPA_CLOSED_DATE | Direct | Non-additive | — | — |
| FactDeviation | ClosedTimestampUtc | FACT_DEVIATION | CLOSED_TIMESTAMP_UTC | Direct | Non-additive | — | — |
| FactDeviation | ClosedByKey | FACT_DEVIATION | CLOSED_BY_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactDeviation | ResolutionSummary | FACT_DEVIATION | RESOLUTION_SUMMARY | Direct | — | — | — |
| FactDeviation | RegulatoryNotificationRequired | FACT_DEVIATION | REGULATORY_NOTIFICATION_REQUIRED | Direct | — | — | — |
| FactDeviation | RegulatoryNotifiedDate | FACT_DEVIATION | REGULATORY_NOTIFIED_DATE | Direct | Non-additive | — | — |
| FactDeviation | SourceDevIdMartA | FACT_DEVIATION | SOURCE_DEV_ID_MART_A | Direct | — | — | — |
| FactDeviation | SourceDevNumOps | FACT_DEVIATION | SOURCE_DEV_NUM_OPS | Direct | — | — | — |
| FactDeviation | SourceSystem | FACT_DEVIATION | _SOURCE_SYSTEM | Direct | — | — | — |
| FactDeviation | SourceKey | FACT_DEVIATION | _SOURCE_KEY | Direct | — | — | — |
| FactDeviation | LoadedAtUtc | FACT_DEVIATION | _LOADED_AT_UTC | Direct | — | — | — |
| FactDeviation | CreatedAt | FACT_DEVIATION | CREATED_AT | Direct | — | — | — |
| FactDeviation | CreatedBy | FACT_DEVIATION | CREATED_BY | Direct | — | — | — |
| FactDeviation | UpdatedAt | FACT_DEVIATION | UPDATED_AT | Direct | — | — | — |
| FactDeviation | UpdatedBy | FACT_DEVIATION | UPDATED_BY | Direct | — | — | — |
| FactDeviation | IsDeleted | FACT_DEVIATION | IS_DELETED | Direct | — | — | — |
| FactDeviation | DeletedAt | FACT_DEVIATION | DELETED_AT | Direct | — | — | — |
| FactYieldAnalytics | YieldAnalyticsKey | FACT_YIELD_ANALYTICS | YIELD_ANALYTICS_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactYieldAnalytics | AnalysisDate | FACT_YIELD_ANALYTICS | ANALYSIS_DATE | Direct | Non-additive | — | — |
| FactYieldAnalytics | FacilityKey | FACT_YIELD_ANALYTICS | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | Non-additive | — | — |
| FactYieldAnalytics | ProductKey | FACT_YIELD_ANALYTICS | PRODUCT_KEY | Direct (FK to DimProduct.ProductKey) | Non-additive | — | — |
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
| FactYieldAnalytics | LoadedAtUtc | FACT_YIELD_ANALYTICS | _LOADED_AT_UTC | Direct | — | — | — |
| FactYieldAnalytics | CreatedAt | FACT_YIELD_ANALYTICS | CREATED_AT | Direct | — | — | — |
| FactYieldAnalytics | CreatedBy | FACT_YIELD_ANALYTICS | CREATED_BY | Direct | — | — | — |
| FactYieldAnalytics | UpdatedAt | FACT_YIELD_ANALYTICS | UPDATED_AT | Direct | — | — | — |
| FactYieldAnalytics | UpdatedBy | FACT_YIELD_ANALYTICS | UPDATED_BY | Direct | — | — | — |
| FactYieldAnalytics | IsDeleted | FACT_YIELD_ANALYTICS | IS_DELETED | Direct | — | — | — |
| FactYieldAnalytics | DeletedAt | FACT_YIELD_ANALYTICS | DELETED_AT | Direct | — | — | — |
| FactShiftLog | ShiftLogKey | FACT_SHIFT_LOG | SHIFT_LOG_KEY | Surrogate Key (system-generated INTEGER, preserved from canonical) | — | — | — |
| FactShiftLog | FacilityKey | FACT_SHIFT_LOG | FACILITY_KEY | Direct (FK to DimFacility.FacilityKey) | Non-additive | — | — |
| FactShiftLog | LogDate | FACT_SHIFT_LOG | LOG_DATE | Direct | Non-additive | — | — |
| FactShiftLog | ShiftName | FACT_SHIFT_LOG | SHIFT_NAME | Direct | — | — | — |
| FactShiftLog | ShiftStartUtc | FACT_SHIFT_LOG | SHIFT_START_UTC | Direct | Non-additive | — | — |
| FactShiftLog | ShiftEndUtc | FACT_SHIFT_LOG | SHIFT_END_UTC | Direct | Non-additive | — | — |
| FactShiftLog | SupervisorKey | FACT_SHIFT_LOG | SUPERVISOR_KEY | Direct (FK to DimOperator.OperatorKey) | Non-additive | — | — |
| FactShiftLog | ActiveBatches | FACT_SHIFT_LOG | ACTIVE_BATCHES | Direct | Additive | — | — |
| FactShiftLog | CompletedBatches | FACT_SHIFT_LOG | COMPLETED_BATCHES | Direct | Additive | — | — |
| FactShiftLog | NewDeviations | FACT_SHIFT_LOG | NEW_DEVIATIONS | Direct | Additive | — | — |
| FactShiftLog | ClosedDeviations | FACT_SHIFT_LOG | CLOSED_DEVIATIONS | Direct | Additive | — | — |
| FactShiftLog | EquipmentDowntimeMins | FACT_SHIFT_LOG | EQUIPMENT_DOWNTIME_MINS | Direct | Additive | — | — |
| FactShiftLog | EquipmentIssuesCount | FACT_SHIFT_LOG | EQUIPMENT_ISSUES_COUNT | Direct | Additive | — | — |
| FactShiftLog | SignedOff | FACT_SHIFT_LOG | SIGNED_OFF | Direct | Non-additive | — | — |
| FactShiftLog | SignedOffUtc | FACT_SHIFT_LOG | SIGNED_OFF_UTC | Direct | Non-additive | — | — |
| FactShiftLog | ShiftNotes | FACT_SHIFT_LOG | SHIFT_NOTES | Direct | — | — | — |
| FactShiftLog | SourceLogIdMartA | FACT_SHIFT_LOG | SOURCE_LOG_ID_MART_A | Direct | — | — | — |
| FactShiftLog | SourceSystem | FACT_SHIFT_LOG | _SOURCE_SYSTEM | Direct | — | — | — |
| FactShiftLog | SourceKey | FACT_SHIFT_LOG | _SOURCE_KEY | Direct | — | — | — |
| FactShiftLog | LoadedAtUtc | FACT_SHIFT_LOG | _LOADED_AT_UTC | Direct | — | — | — |
| FactShiftLog | CreatedAt | FACT_SHIFT_LOG | CREATED_AT | Direct | — | — | — |
| FactShiftLog | CreatedBy | FACT_SHIFT_LOG | CREATED_BY | Direct | — | — | — |
| FactShiftLog | UpdatedAt | FACT_SHIFT_LOG | UPDATED_AT | Direct | — | — | — |
| FactShiftLog | UpdatedBy | FACT_SHIFT_LOG | UPDATED_BY | Direct | — | — | — |
| FactShiftLog | IsDeleted | FACT_SHIFT_LOG | IS_DELETED | Direct | — | — | — |
| FactShiftLog | DeletedAt | FACT_SHIFT_LOG | DELETED_AT | Direct | — | — | — |
