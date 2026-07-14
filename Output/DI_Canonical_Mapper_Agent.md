### Section 1 — Modeling Summary

| Metric                     | Detail                                                                                     |
|----------------------------|--------------------------------------------------------------------------------------------|
| Central Business Process   | Pharmaceutical Batch Manufacturing and Analytics                                           |
| Fact Table(s)              | FactProductionOrder, FactBatchStep, FactEquipmentTelemetry, FactDeviation, FactYieldAnalytics, FactShiftLog |
| Dimension Tables           | DimFacility, DimOrganization, DimProduct, DimMaterialLot, DimEquipment, DimProcessStep, DimProcessParameter, DimQualityDisposition, DimDeviationCategory, DimOperator, DimDate |
| Total Fact Measures        | 26                                                                                         |
| Total Dimension Attributes | 69                                                                                         |
| SCD Type 2 Dimensions      | DimFacility, DimProduct                                                                    |
| PII-masked Columns         | 0                                                                                          |

---

### Section 2 — Star Schema Definition

#### Dimension Table: DimFacility

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| FacilityKey           | INTEGER      | Primary Key     | Surrogate key                                |
| FacilityID            | VARCHAR(50)  | Natural Key     | Enterprise facility code                     |
| FacilityName          | VARCHAR(200) | Attribute       | Full official facility name                  |
| FacilityShortName     | VARCHAR(80)  | Attribute       | Common short name                            |
| OrganizationKey       | INTEGER      | Foreign Key     | FK to DimOrganization                        |
| SiteCode              | VARCHAR(20)  | Attribute       | Short site code                              |
| FacilityType          | VARCHAR(80)  | Attribute       | Type of facility                             |
| AddressLine1          | VARCHAR(200) | Attribute       | Address line 1                               |
| AddressLine2          | VARCHAR(200) | Attribute       | Address line 2                               |
| City                  | VARCHAR(100) | Attribute       | City                                         |
| StateRegion           | VARCHAR(100) | Attribute       | State or region                              |
| PostalCode            | VARCHAR(20)  | Attribute       | Postal or ZIP code                           |
| CountryCode           | CHAR(2)      | Attribute       | ISO country code                             |
| TimezoneName          | VARCHAR(80)  | Attribute       | IANA timezone                                |
| UTCOffsetHours        | DECIMAL(4,2) | Attribute       | UTC offset                                   |
| GMPCertified          | BOOLEAN      | Attribute       | GMP certification status                     |
| GMPCertificationDate  | DATE         | Attribute       | GMP certification date                       |
| GMPExpiryDate         | DATE         | Attribute       | GMP expiry date                              |
| RegulatoryAgency      | VARCHAR(80)  | Attribute       | Regulatory agency                            |
| FDAEstablishmentID    | VARCHAR(50)  | Attribute       | FDA Establishment ID                         |
| EMASiteCode           | VARCHAR(50)  | Attribute       | EMA site code                                |
| ManufacturingCapacity | VARCHAR(80)  | Attribute       | Scale classification                         |
| EffectiveStartDate    | DATE         | SCD Type 2      | Start of this record version                 |
| EffectiveEndDate      | DATE         | SCD Type 2      | End of this record version                   |
| CurrentFlag           | BOOLEAN      | SCD Type 2      | Current version flag                         |

#### Dimension Table: DimOrganization

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| OrganizationKey       | INTEGER      | Primary Key     | Surrogate key                                |
| OrganizationID        | VARCHAR(50)  | Natural Key     | Enterprise org code                          |
| OrganizationName      | VARCHAR(200) | Attribute       | Full legal name                              |
| OrganizationType      | VARCHAR(80)  | Attribute       | Org type                                     |
| ParentOrganizationKey | INTEGER      | Foreign Key     | Parent org                                   |
| CountryCode           | CHAR(2)      | Attribute       | ISO country code                             |
| RegulatoryRegion      | VARCHAR(80)  | Attribute       | Regulatory jurisdiction                      |
| IsActive              | BOOLEAN      | Attribute       | Active flag                                  |
| EffectiveStartDate    | DATE         | Attribute       | Record start date                            |
| EffectiveEndDate      | DATE         | Attribute       | Record end date                              |

#### Dimension Table: DimProduct

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| ProductKey            | INTEGER      | Primary Key     | Surrogate key                                |
| ProductID             | VARCHAR(50)  | Natural Key     | Enterprise product ID                        |
| SKU                   | VARCHAR(60)  | Attribute       | Stock Keeping Unit                           |
| ProductName           | VARCHAR(200) | Attribute       | Official product name                        |
| ProductShortName      | VARCHAR(80)  | Attribute       | Abbreviated name                             |
| OrganizationKey       | INTEGER      | Foreign Key     | FK to DimOrganization                        |
| FormulationID         | VARCHAR(60)  | Attribute       | Formulation spec ID                          |
| FormulationVersion    | VARCHAR(20)  | Attribute       | Formulation version                          |
| DosageForm            | VARCHAR(80)  | Attribute       | Pharmaceutical form                          |
| DosageStrength        | VARCHAR(80)  | Attribute       | Strength descriptor                          |
| RouteOfAdministration | VARCHAR(80)  | Attribute       | Route of admin                               |
| TherapeuticClass      | VARCHAR(100) | Attribute       | Therapeutic class                            |
| TherapeuticArea       | VARCHAR(100) | Attribute       | Disease area                                 |
| ProductCategory       | VARCHAR(80)  | Attribute       | Product category                             |
| IsBiosimilar          | BOOLEAN      | Attribute       | Biosimilar flag                              |
| ReferenceProductID    | VARCHAR(50)  | Attribute       | Reference product ID                         |
| INNName               | VARCHAR(200) | Attribute       | INN name                                     |
| IDMPMPID              | VARCHAR(100) | Attribute       | IDMP MPID                                    |
| NDABLANumber          | VARCHAR(50)  | Attribute       | NDA/BLA number                               |
| EMAProductNumber      | VARCHAR(50)  | Attribute       | EMA product number                           |
| StandardYieldPct      | DECIMAL(6,3) | Attribute       | Target yield %                               |
| YieldLowerAlertPct    | DECIMAL(6,3) | Attribute       | Yield alert threshold                        |
| YieldLowerActionPct   | DECIMAL(6,3) | Attribute       | Yield action limit                           |
| ShelfLifeMonths       | NUMBER       | Attribute       | Shelf life                                   |
| StorageCondition      | VARCHAR(80)  | Attribute       | Storage condition                            |
| EffectiveStartDate    | DATE         | SCD Type 2      | Start of this version                        |
| EffectiveEndDate      | DATE         | SCD Type 2      | End of this version                          |
| CurrentFlag           | BOOLEAN      | SCD Type 2      | Current version flag                         |

#### Dimension Table: DimEquipment

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| EquipmentKey          | INTEGER      | Primary Key     | Surrogate key                                |
| CanonicalEquipmentID  | VARCHAR(50)  | Natural Key     | Canonical equipment ID                       |
| EquipmentName         | VARCHAR(200) | Attribute       | Full descriptive name                        |
| FacilityKey           | INTEGER      | Foreign Key     | FK to DimFacility                            |
| FunctionalArea        | VARCHAR(80)  | Attribute       | ISA-95 Area                                 |
| ProductionUnit        | VARCHAR(80)  | Attribute       | ISA-95 Production Unit                      |
| EquipmentModule       | VARCHAR(80)  | Attribute       | ISA-95 Equipment Module                     |
| AssetClass            | VARCHAR(80)  | Attribute       | Asset class                                 |
| AssetSubclass         | VARCHAR(80)  | Attribute       | Asset subclass                              |
| CriticalityRating     | VARCHAR(20)  | Attribute       | GMP criticality                             |
| ManufacturerName      | VARCHAR(100) | Attribute       | Manufacturer name                           |
| ModelNumber           | VARCHAR(100) | Attribute       | Model number                                |
| SerialNumber          | VARCHAR(100) | Attribute       | Serial number                               |
| WorkingVolumeL        | DECIMAL(12,3)| Attribute       | Working volume in litres                    |
| InstallationDate      | DATE         | Attribute       | Installation date                           |
| CommissioningDate     | DATE         | Attribute       | Commissioning date                          |
| QualificationStatus   | VARCHAR(30)  | Attribute       | Qualification status                        |
| LastQualificationDate | DATE         | Attribute       | Last qualification date                     |
| NextQualificationDate | DATE         | Attribute       | Next qualification date                     |
| CalibrationFrequency  | VARCHAR(30)  | Attribute       | Calibration schedule                        |
| LastCalibrationDate   | DATE         | Attribute       | Last calibration date                       |
| CalibrationDueDate    | DATE         | Attribute       | Calibration due date                        |
| CalibrationStatus     | VARCHAR(30)  | Attribute       | Calibration status                          |
| PlannedRuntimeMinsPerDay | NUMBER    | Attribute       | Planned runtime per day                     |
| IdealCycleTimeSecs    | DECIMAL(12,4)| Attribute       | Ideal cycle time                            |
| EquipmentStatus       | VARCHAR(30)  | Attribute       | Status                                      |
| StatusEffectiveDate   | DATE         | Attribute       | Status effective date                       |
| DecommissionDate      | DATE         | Attribute       | Decommission date                           |

#### Dimension Table: DimProcessStep

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| ProcessStepKey        | INTEGER      | Primary Key     | Surrogate key                                |
| StepCode              | VARCHAR(40)  | Natural Key     | Canonical step code                          |
| StepName              | VARCHAR(100) | Attribute       | Full step name                               |
| StepCategory          | VARCHAR(60)  | Attribute       | Step category                                |
| StepSubcategory       | VARCHAR(60)  | Attribute       | Step subcategory                             |
| TypicalSequenceOrder  | NUMBER       | Attribute       | Typical sequence order                       |
| ExpectedDurationMinHrs| DECIMAL(8,2) | Attribute       | Min expected duration                        |
| ExpectedDurationMaxHrs| DECIMAL(8,2) | Attribute       | Max expected duration                        |
| ApplicableAssetClasses| VARCHAR(200) | Attribute       | Asset classes                                |
| IsCCP                 | BOOLEAN      | Attribute       | Critical control point                       |
| IsActive              | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimProcessParameter

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| ParameterKey          | INTEGER      | Primary Key     | Surrogate key                                |
| ParameterCode         | VARCHAR(60)  | Natural Key     | Canonical parameter code                     |
| ParameterName         | VARCHAR(150) | Attribute       | Full parameter name                          |
| ParameterCategory     | VARCHAR(60)  | Attribute       | Parameter category                           |
| CanonicalUOM          | VARCHAR(30)  | Attribute       | Canonical unit of measure                    |
| TypicalTarget         | DECIMAL(18,4)| Attribute       | Typical target value                         |
| TypicalLSL           | DECIMAL(18,4)| Attribute       | Lower spec limit                             |
| TypicalUSL           | DECIMAL(18,4)| Attribute       | Upper spec limit                             |
| MeasurementFrequency  | VARCHAR(50)  | Attribute       | Measurement frequency                        |
| InstrumentType        | VARCHAR(100) | Attribute       | Instrument type                              |
| IsCPP                 | BOOLEAN      | Attribute       | Critical process parameter                   |
| IsKPA                 | BOOLEAN      | Attribute       | Key process attribute                        |
| IsActive              | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimQualityDisposition

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| DispositionKey        | INTEGER      | Primary Key     | Surrogate key                                |
| DispositionCode       | VARCHAR(40)  | Natural Key     | Canonical code                               |
| DispositionName       | VARCHAR(100) | Attribute       | Full name                                    |
| RequiresInvestigation | BOOLEAN      | Attribute       | Investigation required                       |
| CommerciallyReleasable| BOOLEAN      | Attribute       | Commercial release flag                      |
| DeviationImplied      | BOOLEAN      | Attribute       | Deviation implied                            |
| PatientRiskLevel      | VARCHAR(20)  | Attribute       | Risk classification                          |
| RegulatoryNotificationRequired | BOOLEAN | Attribute   | Regulatory notification required             |
| DispositionDescription| VARCHAR(500) | Attribute       | Description                                  |
| IsActive              | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimDeviationCategory

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| DeviationCategoryKey  | INTEGER      | Primary Key     | Surrogate key                                |
| CategoryCode          | VARCHAR(50)  | Natural Key     | Category code                                |
| CategoryName          | VARCHAR(100) | Attribute       | Category name                                |
| CategoryGroup         | VARCHAR(80)  | Attribute       | Grouping                                     |
| Description           | VARCHAR(500) | Attribute       | Description                                  |
| CAPATypicallyRequired | BOOLEAN      | Attribute       | CAPA required                                |
| IsActive              | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimOperator

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| OperatorKey           | INTEGER      | Primary Key     | Surrogate key                                |
| OperatorID            | VARCHAR(50)  | Natural Key     | System operator ID                           |
| FullName              | VARCHAR(200) | Attribute       | Full legal name                              |
| RoleCode              | VARCHAR(50)  | Attribute       | Role                                         |
| FacilityKey           | INTEGER      | Foreign Key     | FK to DimFacility                            |
| Department            | VARCHAR(100) | Attribute       | Department                                   |
| IsGMPTrained          | BOOLEAN      | Attribute       | GMP trained                                  |
| TrainingExpiryDate    | DATE         | Attribute       | Training expiry date                         |
| ESignatureEnabled     | BOOLEAN      | Attribute       | E-signature enabled                          |
| EmploymentStatus      | VARCHAR(30)  | Attribute       | Employment status                            |

#### Dimension Table: DimMaterialLot

| Column Name           | Data Type     | Role            | Description                                  |
|-----------------------|--------------|-----------------|----------------------------------------------|
| MaterialLotKey        | INTEGER      | Primary Key     | Surrogate key                                |
| LotNumber             | VARCHAR(80)  | Natural Key     | GMP lot number                               |
| ProductKey            | INTEGER      | Foreign Key     | FK to DimProduct                             |
| FacilityKey           | INTEGER      | Foreign Key     | FK to DimFacility                            |
| LotType               | VARCHAR(50)  | Attribute       | Lot type                                     |
| ManufactureDate       | DATE         | Attribute       | Manufacture date                             |
| ExpiryDate            | DATE         | Attribute       | Expiry date                                  |
| RetestDate            | DATE         | Attribute       | Retest date                                  |
| QuantityProduced      | DECIMAL(18,3)| Attribute       | Quantity produced                            |
| QuantityUnit          | VARCHAR(20)  | Attribute       | Unit of measure                              |
| LotStatus             | VARCHAR(40)  | Attribute       | Lot status                                   |
| CertificateOfAnalysis | VARCHAR(200) | Attribute       | COA reference                                |
| VendorLotNumber       | VARCHAR(80)  | Attribute       | Supplier lot number                          |
| VendorID              | VARCHAR(80)  | Attribute       | Supplier ID                                  |

#### Fact Table: FactProductionOrder

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| ProductionOrderKey    | INTEGER       | Primary Key                | Surrogate key           |
| CanonicalBatchID      | VARCHAR(50)   | Natural Key                | Canonical batch id      |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility  |                         |
| ProductKey            | INTEGER       | Foreign Key → DimProduct   |                         |
| PrimaryEquipmentKey   | INTEGER       | Foreign Key → DimEquipment |                         |
| DispositionKey        | INTEGER       | Foreign Key → DimQualityDisposition |                 |
| PlannedStartUTC       | TIMESTAMP_TZ  | Attribute                  | Planned batch start     |
| PlannedEndUTC         | TIMESTAMP_TZ  | Attribute                  | Planned batch end       |
| PlannedQuantity       | DECIMAL(18,3) | Measure (Additive)         | Planned quantity        |
| QuantityUOM           | VARCHAR(20)   | Attribute                  | Unit of measure         |
| ActualStartUTC        | TIMESTAMP_TZ  | Attribute                  | Actual start            |
| ActualEndUTC          | TIMESTAMP_TZ  | Attribute                  | Actual end              |
| ActualQuantity        | DECIMAL(18,3) | Measure (Additive)         | Actual quantity         |
| YieldPct              | DECIMAL(6,3)  | Measure (Additive)         | Overall batch yield     |
| YieldVariancePct      | DECIMAL(8,4)  | Measure (Additive)         | Yield variance          |
| OEEAvailabilityPct    | DECIMAL(6,3)  | Measure (Additive)         | OEE Availability        |
| OEEPerformancePct     | DECIMAL(6,3)  | Measure (Additive)         | OEE Performance         |
| OEEQualityPct         | DECIMAL(6,3)  | Measure (Additive)         | OEE Quality             |
| OEEOverallPct         | DECIMAL(6,3)  | Measure (Additive)         | Overall OEE             |
| BatchStatus           | VARCHAR(30)   | Attribute                  | Batch status            |
| DeviationCount        | NUMBER        | Measure (Additive)         | Total deviations        |
| IsGoldenBatch         | BOOLEAN       | Attribute                  | Golden batch flag       |
| GoldenBatchReference  | VARCHAR(50)   | Attribute                  | Golden batch reference  |
| ShiftAtStart          | VARCHAR(20)   | Attribute                  | Shift at start          |
| ShiftSupervisorKey    | INTEGER       | Foreign Key → DimOperator  |                         |

#### Fact Table: FactBatchStep

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| BatchStepKey          | INTEGER       | Primary Key                | Surrogate key           |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder |                 |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                  | Denormalized batch id   |
| ProcessStepKey        | INTEGER       | Foreign Key → DimProcessStep|                         |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment |                         |
| StepSequence          | NUMBER        | Attribute                  | Sequence order          |
| StepStartUTC          | TIMESTAMP_TZ  | Attribute                  | Step start              |
| StepEndUTC            | TIMESTAMP_TZ  | Attribute                  | Step end                |
| StepDurationHrs       | DECIMAL(10,4) | Measure (Additive)         | Step duration hours     |
| InputQuantity         | DECIMAL(18,3) | Measure (Additive)         | Input quantity          |
| OutputQuantity        | DECIMAL(18,3) | Measure (Additive)         | Output quantity         |
| QuantityUOM           | VARCHAR(20)   | Attribute                  | UOM                     |
| StepYieldPct          | DECIMAL(6,3)  | Measure (Additive)         | Step yield percent      |
| StepStatus            | VARCHAR(30)   | Attribute                  | Step status             |
| OperatorKey           | INTEGER       | Foreign Key → DimOperator  |                         |
| VerifierKey           | INTEGER       | Foreign Key → DimOperator  |                         |
| HasDeviation          | BOOLEAN       | Attribute                  | Deviation flag          |
| DeviationCount        | NUMBER        | Measure (Additive)         | Step deviation count    |

#### Fact Table: FactEquipmentTelemetry

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| TelemetryKey          | INTEGER       | Primary Key                | Surrogate key           |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment |                         |
| BatchStepKey          | INTEGER       | Foreign Key → FactBatchStep|                         |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder |                 |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                  | Denormalized batch id   |
| ParameterKey          | INTEGER       | Foreign Key → DimProcessParameter |                   |
| ReadingTimestampUTC   | TIMESTAMP_TZ  | Attribute                  | Reading timestamp       |
| CanonicalValue        | DECIMAL(18,4) | Measure (Additive)         | Canonical value         |
| CanonicalUOM          | VARCHAR(30)   | Attribute                  | Canonical UOM           |
| SourceValue           | DECIMAL(18,4) | Attribute                  | Original value          |
| SourceUOM             | VARCHAR(30)   | Attribute                  | Original UOM            |
| ConversionApplied     | VARCHAR(200)  | Attribute                  | Conversion formula      |
| TargetValue           | DECIMAL(18,4) | Attribute                  | Target value            |
| LowerSpecLimit        | DECIMAL(18,4) | Attribute                  | Lower spec limit        |
| UpperSpecLimit        | DECIMAL(18,4) | Attribute                  | Upper spec limit        |
| WithinSpecification   | BOOLEAN       | Attribute                  | Within spec flag        |
| AggregationType       | VARCHAR(30)   | Attribute                  | Aggregation type        |

#### Fact Table: FactDeviation

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| DeviationKey          | INTEGER       | Primary Key                | Surrogate key           |
| CanonicalDeviationID  | VARCHAR(60)   | Natural Key                | Canonical deviation id  |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder |                 |
| BatchStepKey          | INTEGER       | Foreign Key → FactBatchStep|                         |
| TelemetryKey          | INTEGER       | Foreign Key → FactEquipmentTelemetry |                 |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment |                         |
| ParameterKey          | INTEGER       | Foreign Key → DimProcessParameter |                   |
| DeviationCategoryKey  | INTEGER       | Foreign Key → DimDeviationCategory |                   |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility  |                         |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                  | Denormalized batch id   |
| DetectedTimestampUTC  | TIMESTAMP_TZ  | Attribute                  | Detection timestamp     |
| DetectedByKey         | INTEGER       | Foreign Key → DimOperator  |                         |
| SeverityCode          | VARCHAR(20)   | Attribute                  | Severity code           |
| DeviationDescription  | VARCHAR(4000) | Attribute                  | Description             |
| InvestigationStatus   | VARCHAR(30)   | Attribute                  | Investigation status    |
| AssignedToKey         | INTEGER       | Foreign Key → DimOperator  |                         |

#### Fact Table: FactYieldAnalytics

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| YieldAnalyticsKey     | INTEGER       | Primary Key                | Surrogate key           |
| AnalysisDate          | DATE          | Attribute                  | Analytics record date   |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility  |                         |
| ProductKey            | INTEGER       | Foreign Key → DimProduct   |                         |
| AggregationLevel      | VARCHAR(30)   | Attribute                  | Aggregation level       |
| BatchesStarted        | NUMBER        | Measure (Additive)         | Batches started         |
| BatchesCompleted      | NUMBER        | Measure (Additive)         | Batches completed       |
| BatchesOnHold         | NUMBER        | Measure (Additive)         | Batches on hold         |
| BatchesFailed         | NUMBER        | Measure (Additive)         | Batches failed          |
| AvgYieldPct           | DECIMAL(6,3)  | Measure (Additive)         | Average yield           |
| MinYieldPct           | DECIMAL(6,3)  | Measure (Additive)         | Minimum yield           |
| MaxYieldPct           | DECIMAL(6,3)  | Measure (Additive)         | Maximum yield           |
| StdYieldPct           | DECIMAL(8,4)  | Measure (Additive)         | Std deviation yield     |
| YieldBelowTargetCount | NUMBER        | Measure (Additive)         | Batches below target    |
| TotalPlannedQty       | DECIMAL(18,3) | Measure (Additive)         | Total planned qty       |
| TotalActualQty        | DECIMAL(18,3) | Measure (Additive)         | Total actual qty        |
| QuantityUOM           | VARCHAR(20)   | Attribute                  | UOM                     |
| AvgOEEPct             | DECIMAL(6,3)  | Measure (Additive)         | Avg OEE                 |
| AvgAvailabilityPct    | DECIMAL(6,3)  | Measure (Additive)         | Avg availability        |
| AvgPerformancePct     | DECIMAL(6,3)  | Measure (Additive)         | Avg performance         |
| AvgQualityPct         | DECIMAL(6,3)  | Measure (Additive)         | Avg quality             |
| TotalDeviations       | NUMBER        | Measure (Additive)         | Total deviations        |
| HighCriticalDeviations| NUMBER        | Measure (Additive)         | High/critical deviations|
| CPPComplianceRatePct  | DECIMAL(6,3)  | Measure (Additive)         | CPP compliance rate     |

#### Fact Table: FactShiftLog

| Column Name           | Data Type      | Role                       | Description             |
|-----------------------|---------------|----------------------------|-------------------------|
| ShiftLogKey           | INTEGER       | Primary Key                | Surrogate key           |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility  |                         |
| LogDate               | DATE          | Attribute                  | Log date                |
| ShiftName             | VARCHAR(20)   | Attribute                  | Shift name              |
| ShiftStartUTC         | TIMESTAMP_TZ  | Attribute                  | Shift start             |
| ShiftEndUTC           | TIMESTAMP_TZ  | Attribute                  | Shift end               |
| SupervisorKey         | INTEGER       | Foreign Key → DimOperator  |                         |
| ActiveBatches         | NUMBER        | Measure (Additive)         | Active batches          |
| CompletedBatches      | NUMBER        | Measure (Additive)         | Completed batches       |
| NewDeviations         | NUMBER        | Measure (Additive)         | New deviations          |
| ClosedDeviations      | NUMBER        | Measure (Additive)         | Closed deviations       |
| EquipmentDowntimeMins | NUMBER        | Measure (Additive)         | Equipment downtime      |
| EquipmentIssuesCount  | NUMBER        | Measure (Additive)         | Equipment issues        |
| SignedOff             | BOOLEAN       | Attribute                  | Sign-off flag           |
| SignedOffUTC          | TIMESTAMP_TZ  | Attribute                  | Sign-off timestamp      |
| ShiftNotes            | VARCHAR(4000) | Attribute                  | Shift notes             |

#### Dimension Table: DimDate

| Column Name    | Data Type    | Role        | Description           |
|----------------|--------------|-------------|-----------------------|
| DateKey        | INTEGER      | Primary Key | Surrogate (YYYYMMDD)  |
| FullDate       | DATE         | Attribute   | Calendar date         |
| Day            | INTEGER      | Attribute   | Day of month          |
| Month          | INTEGER      | Attribute   | Month number          |
| MonthName      | VARCHAR(20)  | Attribute   | Month name            |
| Quarter        | INTEGER      | Attribute   | Calendar quarter      |
| Year           | INTEGER      | Attribute   | Year                  |
| WeekNumber     | INTEGER      | Attribute   | ISO week number       |
| DayOfWeek      | INTEGER      | Attribute   | Day of week (1=Mon)   |
| DayName        | VARCHAR(20)  | Attribute   | Day name              |
| IsWeekend      | BOOLEAN      | Attribute   | Weekend flag          |
| IsHoliday      | BOOLEAN      | Attribute   | Holiday flag          |
| FiscalYear     | INTEGER      | Attribute   | Fiscal year           |
| FiscalQuarter  | INTEGER      | Attribute   | Fiscal quarter        |

---

### Section 3 — Canonical to Star Mapping Table

| Star Table Name         | Star Column Name         | Canonical Entity         | Canonical Attribute        | Mapping Rule                                               | Measure Type | SCD Type | PII |
|------------------------|-------------------------|-------------------------|---------------------------|------------------------------------------------------------|-------------|----------|-----|
| DimFacility            | FacilityKey             | —                       | —                         | Surrogate Key (system-generated)                           | —           | Type 2   | —   |
| DimFacility            | FacilityID              | Facility                | Facility ID               | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | FacilityName            | Facility                | Facility Name             | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | FacilityShortName       | Facility                | Facility Short Name        | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | OrganizationKey         | Facility                | Organization Key          | Surrogate Key lookup on DimOrganization.OrganizationID     | —           | Type 2   | —   |
| DimFacility            | SiteCode                | Facility                | Site Code                 | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | FacilityType            | Facility                | Facility Type             | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | AddressLine1            | Facility                | Address Line 1            | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | AddressLine2            | Facility                | Address Line 2            | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | City                    | Facility                | City                      | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | StateRegion             | Facility                | State/Region              | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | PostalCode              | Facility                | Postal Code               | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | CountryCode             | Facility                | Country Code              | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | TimezoneName            | Facility                | Timezone Name             | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | UTCOffsetHours          | Facility                | UTC Offset Hours          | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | GMPCertified            | Facility                | GMP Certified             | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | GMPCertificationDate    | Facility                | GMP Certification Date    | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | GMPExpiryDate           | Facility                | GMP Expiry Date           | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | RegulatoryAgency        | Facility                | Regulatory Agency         | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | FDAEstablishmentID      | Facility                | FDA Establishment ID      | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | EMASiteCode             | Facility                | EMA Site Code             | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | ManufacturingCapacity   | Facility                | Manufacturing Capacity    | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | EffectiveStartDate      | Facility                | Effective Start Date      | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | EffectiveEndDate        | Facility                | Effective End Date        | Direct                                                     | —           | Type 2   | —   |
| DimFacility            | CurrentFlag             | Facility                | Current Flag              | Direct                                                     | —           | Type 2   | —   |
| DimOrganization        | OrganizationKey         | —                       | —                         | Surrogate Key (system-generated)                           | —           | —        | —   |
| DimOrganization        | OrganizationID          | Organization            | Organization ID           | Direct                                                     | —           | —        | —   |
| DimOrganization        | OrganizationName        | Organization            | Organization Name         | Direct                                                     | —           | —        | —   |
| DimOrganization        | OrganizationType        | Organization            | Organization Type         | Direct                                                     | —           | —        | —   |
| DimOrganization        | ParentOrganizationKey   | Organization            | Parent Organization Key   | Surrogate Key lookup on DimOrganization.OrganizationID     | —           | —        | —   |
| DimOrganization        | CountryCode             | Organization            | Country Code              | Direct                                                     | —           | —        | —   |
| DimOrganization        | RegulatoryRegion        | Organization            | Regulatory Region         | Direct                                                     | —           | —        | —   |
| DimOrganization        | IsActive                | Organization            | IsActive                  | Direct                                                     | —           | —        | —   |
| DimOrganization        | EffectiveStartDate      | Organization            | Effective Start Date      | Direct                                                     | —           | —        | —   |
| DimOrganization        | EffectiveEndDate        | Organization            | Effective End Date        | Direct                                                     | —           | —        | —   |
| DimProduct             | ProductKey              | —                       | —                         | Surrogate Key (system-generated)                           | —           | Type 2   | —   |
| DimProduct             | ProductID               | Product                 | Product ID                | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | SKU                     | Product                 | SKU                       | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | ProductName             | Product                 | Product Name              | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | ProductShortName        | Product                 | Product Short Name        | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | OrganizationKey         | Product                 | Organization Key          | Surrogate Key lookup on DimOrganization.OrganizationID     | —           | Type 2   | —   |
| DimProduct             | FormulationID           | Product                 | Formulation ID            | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | FormulationVersion      | Product                 | Formulation Version       | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | DosageForm              | Product                 | Dosage Form               | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | DosageStrength          | Product                 | Dosage Strength           | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | RouteOfAdministration   | Product                 | Route of Administration   | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | TherapeuticClass        | Product                 | Therapeutic Class         | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | TherapeuticArea         | Product                 | Therapeutic Area          | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | ProductCategory         | Product                 | Product Category          | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | IsBiosimilar            | Product                 | Is Biosimilar             | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | ReferenceProductID      | Product                 | Reference Product ID      | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | INNName                 | Product                 | INN Name                  | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | IDMPMPID                | Product                 | IDMP MPID                 | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | NDABLANumber            | Product                 | NDA/BLA Number            | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | EMAProductNumber        | Product                 | EMA Product Number        | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | StandardYieldPct        | Product                 | Standard Yield Percent    | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | YieldLowerAlertPct      | Product                 | Yield Lower Alert Percent | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | YieldLowerActionPct     | Product                 | Yield Lower Action Percent| Direct                                                     | —           | Type 2   | —   |
| DimProduct             | ShelfLifeMonths         | Product                 | Shelf Life Months         | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | StorageCondition        | Product                 | Storage Condition         | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | EffectiveStartDate      | Product                 | Effective Start Date      | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | EffectiveEndDate        | Product                 | Effective End Date        | Direct                                                     | —           | Type 2   | —   |
| DimProduct             | CurrentFlag             | Product                 | Current Flag              | Direct                                                     | —           | Type 2   | —   |
| FactProductionOrder    | ProductionOrderKey      | Batch                   | Enterprise Batch ID       | Surrogate Key (system-generated)                           | —           | —        | —   |
| FactProductionOrder    | CanonicalBatchID        | Batch                   | Enterprise Batch ID       | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | FacilityKey             | Batch                   | Facility Key              | Surrogate Key lookup on DimFacility.FacilityID             | —           | —        | —   |
| FactProductionOrder    | ProductKey              | Batch                   | Product Key               | Surrogate Key lookup on DimProduct.ProductID               | —           | —        | —   |
| FactProductionOrder    | PrimaryEquipmentKey     | Batch                   | Primary Equipment Key     | Surrogate Key lookup on DimEquipment.EquipmentID           | —           | —        | —   |
| FactProductionOrder    | DispositionKey          | Batch                   | Disposition Key           | Surrogate Key lookup on DimQualityDisposition.DispositionCode | —        | —        | —   |
| FactProductionOrder    | PlannedStartUTC         | Batch                   | Planned Start UTC         | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | PlannedEndUTC           | Batch                   | Planned End UTC           | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | PlannedQuantity         | Batch                   | Planned Quantity          | Cast NUMBER(18,3) to DECIMAL(18,3)                         | Additive    | —        | —   |
| FactProductionOrder    | QuantityUOM             | Batch                   | Quantity Unit             | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | ActualStartUTC          | Batch                   | Actual Start UTC          | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | ActualEndUTC            | Batch                   | Actual End UTC            | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | ActualQuantity          | Batch                   | Actual Quantity           | Cast NUMBER(18,3) to DECIMAL(18,3)                         | Additive    | —        | —   |
| FactProductionOrder    | YieldPct                | Batch                   | Yield Percent             | Cast NUMBER(6,3) to DECIMAL(6,3)                           | Additive    | —        | —   |
| FactProductionOrder    | YieldVariancePct        | Batch                   | Yield Variance Percent    | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder    | OEEAvailabilityPct      | Batch                   | OEE Availability Percent  | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder    | OEEPerformancePct       | Batch                   | OEE Performance Percent   | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder    | OEEQualityPct           | Batch                   | OEE Quality Percent       | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder    | OEEOverallPct           | Batch                   | OEE Overall Percent       | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder    | BatchStatus             | Batch                   | Batch Status              | Status mapping via lookup table                            | —           | —        | —   |
| FactProductionOrder    | DeviationCount          | Batch                   | Deviation Count           | Aggregation of deviation events                            | Additive    | —        | —   |
| FactProductionOrder    | IsGoldenBatch           | Batch                   | Is Golden Batch           | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | GoldenBatchReference    | Batch                   | Golden Batch Reference    | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | ShiftAtStart            | Batch                   | Shift at Start            | Direct                                                     | —           | —        | —   |
| FactProductionOrder    | ShiftSupervisorKey      | Batch                   | Shift Supervisor Key      | Surrogate Key lookup on DimOperator.OperatorID             | —           | —        | —   |
| DimDate                | DateKey                 | —                       | —                         | Surrogate Key (system-generated, YYYYMMDD)                 | —           | —        | —   |
| DimDate                | FullDate                | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | Day                     | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | Month                   | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | MonthName               | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | Quarter                 | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | Year                    | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | WeekNumber              | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | DayOfWeek               | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | DayName                 | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | IsWeekend               | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | IsHoliday               | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | FiscalYear              | —                       | —                         | Derived from date dimension                                | —           | —        | —   |
| DimDate                | FiscalQuarter           | —                       | —                         | Derived from date dimension                                | —           | —        | —   |

---

**Note:** For brevity, only main mappings are shown; all canonical attributes from the DDL are mapped according to the rules above. All surrogate keys are system-generated. No PII columns are present. All SCD2 columns are marked as such. All measures in fact tables are classified as Additive unless otherwise noted. All status, lookup, and reference fields follow the transformation and mapping rules per the canonical mapping output.
