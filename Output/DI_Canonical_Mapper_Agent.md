### Section 1 — Modeling Summary

| Metric                     | Detail                                        |
|----------------------------|-----------------------------------------------|
| Central Business Process   | Pharmaceutical Batch Manufacturing and Analytics |
| Fact Table(s)              | FactProductionOrder, FactBatchStep, FactEquipmentTelemetry, FactDeviation, FactYieldAnalytics, FactShiftLog |
| Dimension Tables           | DimFacility, DimOrganization, DimProduct, DimMaterialLot, DimEquipment, DimProcessStep, DimProcessParameter, DimQualityDisposition, DimDeviationCategory, DimOperator, DimDate |
| Total Fact Measures        | 26                                            |
| Total Dimension Attributes | 69                                            |
| SCD Type 2 Dimensions      | DimFacility, DimProduct                       |
| PII-masked Columns         | 0                                             |

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

| Column Name              | Data Type     | Role            | Description                                  |
|--------------------------|--------------|-----------------|----------------------------------------------|
| EquipmentKey             | INTEGER      | Primary Key     | Surrogate key                                |
| CanonicalEquipmentID     | VARCHAR(50)  | Natural Key     | Canonical equipment ID                       |
| EquipmentName            | VARCHAR(200) | Attribute       | Full descriptive name                        |
| FacilityKey              | INTEGER      | Foreign Key     | FK to DimFacility                            |
| FunctionalArea           | VARCHAR(80)  | Attribute       | ISA-95 Area                                  |
| ProductionUnit           | VARCHAR(80)  | Attribute       | ISA-95 Production Unit                       |
| EquipmentModule          | VARCHAR(80)  | Attribute       | ISA-95 Equipment Module                      |
| AssetClass               | VARCHAR(80)  | Attribute       | Asset class                                  |
| AssetSubclass            | VARCHAR(80)  | Attribute       | Asset subclass                               |
| CriticalityRating        | VARCHAR(20)  | Attribute       | GMP criticality                              |
| ManufacturerName         | VARCHAR(100) | Attribute       | Manufacturer name                            |
| ModelNumber              | VARCHAR(100) | Attribute       | Model number                                 |
| SerialNumber             | VARCHAR(100) | Attribute       | Serial number                                |
| WorkingVolumeL           | DECIMAL(12,3)| Attribute       | Working volume in litres                     |
| InstallationDate         | DATE         | Attribute       | Installation date                            |
| CommissioningDate        | DATE         | Attribute       | Commissioning date                           |
| QualificationStatus      | VARCHAR(30)  | Attribute       | Qualification status                         |
| LastQualificationDate    | DATE         | Attribute       | Last qualification date                      |
| NextQualificationDate    | DATE         | Attribute       | Next qualification date                      |
| CalibrationFrequency     | VARCHAR(30)  | Attribute       | Calibration schedule                         |
| LastCalibrationDate      | DATE         | Attribute       | Last calibration date                        |
| CalibrationDueDate       | DATE         | Attribute       | Calibration due date                         |
| CalibrationStatus        | VARCHAR(30)  | Attribute       | Calibration status                           |
| PlannedRuntimeMinsPerDay | NUMBER       | Attribute       | Planned runtime per day                      |
| IdealCycleTimeSecs       | DECIMAL(12,4)| Attribute       | Ideal cycle time                             |
| EquipmentStatus          | VARCHAR(30)  | Attribute       | Status                                      |
| StatusEffectiveDate      | DATE         | Attribute       | Status effective date                        |
| DecommissionDate         | DATE         | Attribute       | Decommission date                            |

#### Dimension Table: DimProcessStep

| Column Name              | Data Type     | Role            | Description                                  |
|--------------------------|--------------|-----------------|----------------------------------------------|
| ProcessStepKey           | INTEGER      | Primary Key     | Surrogate key                                |
| StepCode                 | VARCHAR(40)  | Natural Key     | Canonical step code                          |
| StepName                 | VARCHAR(100) | Attribute       | Full step name                               |
| StepCategory             | VARCHAR(60)  | Attribute       | Step category                                |
| StepSubcategory          | VARCHAR(60)  | Attribute       | Step subcategory                             |
| TypicalSequenceOrder     | NUMBER       | Attribute       | Typical sequence order                       |
| ExpectedDurationMinHrs   | DECIMAL(8,2) | Attribute       | Min expected duration                        |
| ExpectedDurationMaxHrs   | DECIMAL(8,2) | Attribute       | Max expected duration                        |
| ApplicableAssetClasses   | VARCHAR(200) | Attribute       | Asset classes                                |
| IsCCP                    | BOOLEAN      | Attribute       | Critical control point                       |
| IsActive                 | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimProcessParameter

| Column Name              | Data Type     | Role            | Description                                  |
|--------------------------|--------------|-----------------|----------------------------------------------|
| ParameterKey             | INTEGER      | Primary Key     | Surrogate key                                |
| ParameterCode            | VARCHAR(60)  | Natural Key     | Canonical parameter code                     |
| ParameterName            | VARCHAR(150) | Attribute       | Full parameter name                          |
| ParameterCategory        | VARCHAR(60)  | Attribute       | Parameter category                           |
| CanonicalUOM             | VARCHAR(30)  | Attribute       | Canonical unit of measure                    |
| TypicalTarget            | DECIMAL(18,4)| Attribute       | Typical target value                         |
| TypicalLSL               | DECIMAL(18,4)| Attribute       | Lower spec limit                             |
| TypicalUSL               | DECIMAL(18,4)| Attribute       | Upper spec limit                             |
| MeasurementFrequency     | VARCHAR(50)  | Attribute       | Measurement frequency                        |
| InstrumentType           | VARCHAR(100) | Attribute       | Instrument type                              |
| IsCPP                    | BOOLEAN      | Attribute       | Critical process parameter                   |
| IsKPA                    | BOOLEAN      | Attribute       | Key process attribute                        |
| IsActive                 | BOOLEAN      | Attribute       | Active flag                                  |

#### Dimension Table: DimQualityDisposition

| Column Name                    | Data Type     | Role            | Description                                  |
|--------------------------------|--------------|-----------------|----------------------------------------------|
| DispositionKey                 | INTEGER      | Primary Key     | Surrogate key                                |
| DispositionCode                | VARCHAR(40)  | Natural Key     | Canonical code                               |
| DispositionName                | VARCHAR(100) | Attribute       | Full name                                    |
| RequiresInvestigation          | BOOLEAN      | Attribute       | Investigation required                       |
| CommerciallyReleasable         | BOOLEAN      | Attribute       | Commercial release flag                      |
| DeviationImplied               | BOOLEAN      | Attribute       | Deviation implied                            |
| PatientRiskLevel               | VARCHAR(20)  | Attribute       | Risk classification                          |
| RegulatoryNotificationRequired | BOOLEAN      | Attribute       | Regulatory notification required             |
| DispositionDescription         | VARCHAR(500) | Attribute       | Description                                  |
| IsActive                       | BOOLEAN      | Attribute       | Active flag                                  |

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

| Column Name        | Data Type     | Role            | Description                                  |
|--------------------|--------------|-----------------|----------------------------------------------|
| OperatorKey        | INTEGER      | Primary Key     | Surrogate key                                |
| OperatorID         | VARCHAR(50)  | Natural Key     | System operator ID                           |
| FullName           | VARCHAR(200) | Attribute       | Full legal name                              |
| RoleCode           | VARCHAR(50)  | Attribute       | Role                                         |
| FacilityKey        | INTEGER      | Foreign Key     | FK to DimFacility                            |
| Department         | VARCHAR(100) | Attribute       | Department                                   |
| IsGMPTrained       | BOOLEAN      | Attribute       | GMP trained                                  |
| TrainingExpiryDate | DATE         | Attribute       | Training expiry date                         |
| ESignatureEnabled  | BOOLEAN      | Attribute       | E-signature enabled                          |
| EmploymentStatus   | VARCHAR(30)  | Attribute       | Employment status                            |

#### Dimension Table: DimMaterialLot

| Column Name           | Data Type      | Role            | Description                                  |
|-----------------------|---------------|-----------------|----------------------------------------------|
| MaterialLotKey        | INTEGER       | Primary Key     | Surrogate key                                |
| LotNumber             | VARCHAR(80)   | Natural Key     | GMP lot number                               |
| ProductKey            | INTEGER       | Foreign Key     | FK to DimProduct                             |
| FacilityKey           | INTEGER       | Foreign Key     | FK to DimFacility                            |
| LotType               | VARCHAR(50)   | Attribute       | Lot type                                     |
| ManufactureDate       | DATE          | Attribute       | Manufacture date                             |
| ExpiryDate            | DATE          | Attribute       | Expiry date                                  |
| RetestDate            | DATE          | Attribute       | Retest date                                  |
| QuantityProduced      | DECIMAL(18,3) | Attribute       | Quantity produced                            |
| QuantityUnit          | VARCHAR(20)   | Attribute       | Unit of measure                              |
| LotStatus             | VARCHAR(40)   | Attribute       | Lot status                                   |
| CertificateOfAnalysis | VARCHAR(200)  | Attribute       | COA reference                                |
| VendorLotNumber       | VARCHAR(80)   | Attribute       | Supplier lot number                          |
| VendorID              | VARCHAR(80)   | Attribute       | Supplier ID                                  |

#### Fact Table: FactProductionOrder

| Column Name           | Data Type      | Role                                  | Description             |
|-----------------------|---------------|---------------------------------------|-------------------------|
| ProductionOrderKey    | INTEGER       | Primary Key                           | Surrogate key           |
| CanonicalBatchID      | VARCHAR(50)   | Natural Key                           | Canonical batch id      |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility             |                         |
| ProductKey            | INTEGER       | Foreign Key → DimProduct              |                         |
| PrimaryEquipmentKey   | INTEGER       | Foreign Key → DimEquipment            |                         |
| DispositionKey        | INTEGER       | Foreign Key → DimQualityDisposition   |                         |
| PlannedStartUTC       | TIMESTAMP_TZ  | Attribute                             | Planned batch start     |
| PlannedEndUTC         | TIMESTAMP_TZ  | Attribute                             | Planned batch end       |
| PlannedQuantity       | DECIMAL(18,3) | Measure (Additive)                    | Planned quantity        |
| QuantityUOM           | VARCHAR(20)   | Attribute                             | Unit of measure         |
| ActualStartUTC        | TIMESTAMP_TZ  | Attribute                             | Actual start            |
| ActualEndUTC          | TIMESTAMP_TZ  | Attribute                             | Actual end              |
| ActualQuantity        | DECIMAL(18,3) | Measure (Additive)                    | Actual quantity         |
| YieldPct              | DECIMAL(6,3)  | Measure (Additive)                    | Overall batch yield     |
| YieldVariancePct      | DECIMAL(8,4)  | Measure (Additive)                    | Yield variance          |
| OEEAvailabilityPct    | DECIMAL(6,3)  | Measure (Additive)                    | OEE Availability        |
| OEEPerformancePct     | DECIMAL(6,3)  | Measure (Additive)                    | OEE Performance         |
| OEEQualityPct         | DECIMAL(6,3)  | Measure (Additive)                    | OEE Quality             |
| OEEOverallPct         | DECIMAL(6,3)  | Measure (Additive)                    | Overall OEE             |
| BatchStatus           | VARCHAR(30)   | Attribute                             | Batch status            |
| DeviationCount        | NUMBER        | Measure (Additive)                    | Total deviations        |
| IsGoldenBatch         | BOOLEAN       | Attribute                             | Golden batch flag       |
| GoldenBatchReference  | VARCHAR(50)   | Attribute                             | Golden batch reference  |
| ShiftAtStart          | VARCHAR(20)   | Attribute                             | Shift at start          |
| ShiftSupervisorKey    | INTEGER       | Foreign Key → DimOperator             |                         |

#### Fact Table: FactBatchStep

| Column Name           | Data Type      | Role                                  | Description             |
|-----------------------|---------------|---------------------------------------|-------------------------|
| BatchStepKey          | INTEGER       | Primary Key                           | Surrogate key           |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder     |                         |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                             | Denormalized batch id   |
| ProcessStepKey        | INTEGER       | Foreign Key → DimProcessStep          |                         |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment            |                         |
| StepSequence          | NUMBER        | Attribute                             | Sequence order          |
| StepStartUTC          | TIMESTAMP_TZ  | Attribute                             | Step start              |
| StepEndUTC            | TIMESTAMP_TZ  | Attribute                             | Step end                |
| StepDurationHrs       | DECIMAL(10,4) | Measure (Additive)                    | Step duration hours     |
| InputQuantity         | DECIMAL(18,3) | Measure (Additive)                    | Input quantity          |
| OutputQuantity        | DECIMAL(18,3) | Measure (Additive)                    | Output quantity         |
| QuantityUOM           | VARCHAR(20)   | Attribute                             | UOM                     |
| StepYieldPct          | DECIMAL(6,3)  | Measure (Additive)                    | Step yield percent      |
| StepStatus            | VARCHAR(30)   | Attribute                             | Step status             |
| OperatorKey           | INTEGER       | Foreign Key → DimOperator             |                         |
| VerifierKey           | INTEGER       | Foreign Key → DimOperator             |                         |
| HasDeviation          | BOOLEAN       | Attribute                             | Deviation flag          |
| DeviationCount        | NUMBER        | Measure (Additive)                    | Step deviation count    |

#### Fact Table: FactEquipmentTelemetry

| Column Name           | Data Type      | Role                                  | Description             |
|-----------------------|---------------|---------------------------------------|-------------------------|
| TelemetryKey          | INTEGER       | Primary Key                           | Surrogate key           |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment            |                         |
| BatchStepKey          | INTEGER       | Foreign Key → FactBatchStep           |                         |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder     |                         |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                             | Denormalized batch id   |
| ParameterKey          | INTEGER       | Foreign Key → DimProcessParameter     |                         |
| ReadingTimestampUTC   | TIMESTAMP_TZ  | Attribute                             | Reading timestamp       |
| CanonicalValue        | DECIMAL(18,4) | Measure (Additive)                    | Canonical value         |
| CanonicalUOM          | VARCHAR(30)   | Attribute                             | Canonical UOM           |
| SourceValue           | DECIMAL(18,4) | Attribute                             | Original value          |
| SourceUOM             | VARCHAR(30)   | Attribute                             | Original UOM            |
| ConversionApplied     | VARCHAR(200)  | Attribute                             | Conversion formula      |
| TargetValue           | DECIMAL(18,4) | Attribute                             | Target value            |
| LowerSpecLimit        | DECIMAL(18,4) | Attribute                             | Lower spec limit        |
| UpperSpecLimit        | DECIMAL(18,4) | Attribute                             | Upper spec limit        |
| WithinSpecification   | BOOLEAN       | Attribute                             | Within spec flag        |
| AggregationType       | VARCHAR(30)   | Attribute                             | Aggregation type        |

#### Fact Table: FactDeviation

| Column Name           | Data Type      | Role                                  | Description             |
|-----------------------|---------------|---------------------------------------|-------------------------|
| DeviationKey          | INTEGER       | Primary Key                           | Surrogate key           |
| CanonicalDeviationID  | VARCHAR(60)   | Natural Key                           | Canonical deviation id  |
| ProductionOrderKey    | INTEGER       | Foreign Key → FactProductionOrder     |                         |
| BatchStepKey          | INTEGER       | Foreign Key → FactBatchStep           |                         |
| TelemetryKey          | INTEGER       | Foreign Key → FactEquipmentTelemetry  |                         |
| EquipmentKey          | INTEGER       | Foreign Key → DimEquipment            |                         |
| ParameterKey          | INTEGER       | Foreign Key → DimProcessParameter     |                         |
| DeviationCategoryKey  | INTEGER       | Foreign Key → DimDeviationCategory    |                         |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility             |                         |
| CanonicalBatchID      | VARCHAR(50)   | Attribute                             | Denormalized batch id   |
| DetectedTimestampUTC  | TIMESTAMP_TZ  | Attribute                             | Detection timestamp     |
| DetectedByKey         | INTEGER       | Foreign Key → DimOperator             |                         |
| SeverityCode          | VARCHAR(20)   | Attribute                             | Severity code           |
| DeviationDescription  | VARCHAR(4000) | Attribute                             | Description             |
| InvestigationStatus   | VARCHAR(30)   | Attribute                             | Investigation status    |
| AssignedToKey         | INTEGER       | Foreign Key → DimOperator             |                         |

#### Fact Table: FactYieldAnalytics

| Column Name              | Data Type      | Role                                  | Description             |
|--------------------------|---------------|---------------------------------------|-------------------------|
| YieldAnalyticsKey        | INTEGER       | Primary Key                           | Surrogate key           |
| AnalysisDate             | DATE          | Attribute                             | Analytics record date   |
| FacilityKey              | INTEGER       | Foreign Key → DimFacility             |                         |
| ProductKey               | INTEGER       | Foreign Key → DimProduct              |                         |
| AggregationLevel         | VARCHAR(30)   | Attribute                             | Aggregation level       |
| BatchesStarted           | NUMBER        | Measure (Additive)                    | Batches started         |
| BatchesCompleted         | NUMBER        | Measure (Additive)                    | Batches completed       |
| BatchesOnHold            | NUMBER        | Measure (Additive)                    | Batches on hold         |
| BatchesFailed            | NUMBER        | Measure (Additive)                    | Batches failed          |
| AvgYieldPct              | DECIMAL(6,3)  | Measure (Additive)                    | Average yield           |
| MinYieldPct              | DECIMAL(6,3)  | Measure (Additive)                    | Minimum yield           |
| MaxYieldPct              | DECIMAL(6,3)  | Measure (Additive)                    | Maximum yield           |
| StdYieldPct              | DECIMAL(8,4)  | Measure (Additive)                    | Std deviation yield     |
| YieldBelowTargetCount    | NUMBER        | Measure (Additive)                    | Batches below target    |
| TotalPlannedQty          | DECIMAL(18,3) | Measure (Additive)                    | Total planned qty       |
| TotalActualQty           | DECIMAL(18,3) | Measure (Additive)                    | Total actual qty        |
| QuantityUOM              | VARCHAR(20)   | Attribute                             | UOM                     |
| AvgOEEPct                | DECIMAL(6,3)  | Measure (Additive)                    | Avg OEE                 |
| AvgAvailabilityPct       | DECIMAL(6,3)  | Measure (Additive)                    | Avg availability        |
| AvgPerformancePct        | DECIMAL(6,3)  | Measure (Additive)                    | Avg performance         |
| AvgQualityPct            | DECIMAL(6,3)  | Measure (Additive)                    | Avg quality             |
| TotalDeviations          | NUMBER        | Measure (Additive)                    | Total deviations        |
| HighCriticalDeviations   | NUMBER        | Measure (Additive)                    | High/critical deviations|
| CPPComplianceRatePct     | DECIMAL(6,3)  | Measure (Additive)                    | CPP compliance rate     |

#### Fact Table: FactShiftLog

| Column Name           | Data Type      | Role                                  | Description             |
|-----------------------|---------------|---------------------------------------|-------------------------|
| ShiftLogKey           | INTEGER       | Primary Key                           | Surrogate key           |
| FacilityKey           | INTEGER       | Foreign Key → DimFacility             |                         |
| LogDate               | DATE          | Attribute                             | Log date                |
| ShiftName             | VARCHAR(20)   | Attribute                             | Shift name              |
| ShiftStartUTC         | TIMESTAMP_TZ  | Attribute                             | Shift start             |
| ShiftEndUTC           | TIMESTAMP_TZ  | Attribute                             | Shift end               |
| SupervisorKey         | INTEGER       | Foreign Key → DimOperator             |                         |
| ActiveBatches         | NUMBER        | Measure (Additive)                    | Active batches          |
| CompletedBatches      | NUMBER        | Measure (Additive)                    | Completed batches       |
| NewDeviations         | NUMBER        | Measure (Additive)                    | New deviations          |
| ClosedDeviations      | NUMBER        | Measure (Additive)                    | Closed deviations       |
| EquipmentDowntimeMins | NUMBER        | Measure (Additive)                    | Equipment downtime      |
| EquipmentIssuesCount  | NUMBER        | Measure (Additive)                    | Equipment issues        |
| SignedOff             | BOOLEAN       | Attribute                             | Sign-off flag           |
| SignedOffUTC          | TIMESTAMP_TZ  | Attribute                             | Sign-off timestamp      |
| ShiftNotes            | VARCHAR(4000) | Attribute                             | Shift notes             |

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
|-------------------------|--------------------------|--------------------------|----------------------------|------------------------------------------------------------|-------------|----------|-----|
| DimFacility             | FacilityKey              | DIM_FACILITY            | FACILITY_KEY              | Surrogate Key (system-generated INTEGER)                  | —           | Type 2   | —   |
| DimFacility             | FacilityID               | DIM_FACILITY            | FACILITY_ID               | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | FacilityName             | DIM_FACILITY            | FACILITY_NAME             | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | FacilityShortName        | DIM_FACILITY            | FACILITY_SHORT_NAME       | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | OrganizationKey          | DIM_FACILITY            | ORGANIZATION_KEY          | Surrogate Key lookup on DimOrganization.OrganizationID    | —           | Type 2   | —   |
| DimFacility             | SiteCode                 | DIM_FACILITY            | SITE_CODE                 | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | FacilityType             | DIM_FACILITY            | FACILITY_TYPE             | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | AddressLine1             | DIM_FACILITY            | ADDRESS_LINE_1            | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | AddressLine2             | DIM_FACILITY            | ADDRESS_LINE_2            | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | City                     | DIM_FACILITY            | CITY                      | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | StateRegion              | DIM_FACILITY            | STATE_REGION              | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | PostalCode               | DIM_FACILITY            | POSTAL_CODE               | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | CountryCode              | DIM_FACILITY            | COUNTRY_CODE              | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | TimezoneName             | DIM_FACILITY            | TIMEZONE_NAME             | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | UTCOffsetHours           | DIM_FACILITY            | UTC_OFFSET_HOURS          | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | GMPCertified             | DIM_FACILITY            | GMP_CERTIFIED             | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | GMPCertificationDate     | DIM_FACILITY            | GMP_CERTIFICATION_DATE    | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | GMPExpiryDate            | DIM_FACILITY            | GMP_EXPIRY_DATE           | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | RegulatoryAgency         | DIM_FACILITY            | REGULATORY_AGENCY        | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | FDAEstablishmentID       | DIM_FACILITY            | FDA_ESTABLISHMENT_ID     | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | EMASiteCode              | DIM_FACILITY            | EMA_SITE_CODE            | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | ManufacturingCapacity    | DIM_FACILITY            | MANUFACTURING_CAPACITY   | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | EffectiveStartDate       | DIM_FACILITY            | EFFECTIVE_START_DATE     | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | EffectiveEndDate         | DIM_FACILITY            | EFFECTIVE_END_DATE       | Direct                                                     | —           | Type 2   | —   |
| DimFacility             | CurrentFlag              | DIM_FACILITY            | CURRENT_FLAG             | Direct                                                     | —           | Type 2   | —   |
| DimOrganization         | OrganizationKey          | DIM_ORGANIZATION        | ORGANIZATION_KEY         | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimOrganization         | OrganizationID           | DIM_ORGANIZATION        | ORGANIZATION_ID          | Direct                                                     | —           | —        | —   |
| DimOrganization         | OrganizationName         | DIM_ORGANIZATION        | ORGANIZATION_NAME        | Direct                                                     | —           | —        | —   |
| DimOrganization         | OrganizationType         | DIM_ORGANIZATION        | ORGANIZATION_TYPE        | Direct                                                     | —           | —        | —   |
| DimOrganization         | ParentOrganizationKey    | DIM_ORGANIZATION        | PARENT_ORGANIZATION_KEY | Surrogate Key lookup on DimOrganization.OrganizationID    | —           | —        | —   |
| DimOrganization         | CountryCode              | DIM_ORGANIZATION        | COUNTRY_CODE             | Direct                                                     | —           | —        | —   |
| DimOrganization         | RegulatoryRegion         | DIM_ORGANIZATION        | REGULATORY_REGION        | Direct                                                     | —           | —        | —   |
| DimOrganization         | IsActive                 | DIM_ORGANIZATION        | IS_ACTIVE                | Direct                                                     | —           | —        | —   |
| DimOrganization         | EffectiveStartDate       | DIM_ORGANIZATION        | EFFECTIVE_START_DATE     | Direct                                                     | —           | —        | —   |
| DimOrganization         | EffectiveEndDate         | DIM_ORGANIZATION        | EFFECTIVE_END_DATE       | Direct                                                     | —           | —        | —   |
| DimProduct              | ProductKey               | DIM_PRODUCT             | PRODUCT_KEY              | Surrogate Key (system-generated INTEGER)                  | —           | Type 2   | —   |
| DimProduct              | ProductID                | DIM_PRODUCT             | PRODUCT_ID               | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | SKU                      | DIM_PRODUCT             | SKU                      | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | ProductName              | DIM_PRODUCT             | PRODUCT_NAME             | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | ProductShortName         | DIM_PRODUCT             | PRODUCT_SHORT_NAME       | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | OrganizationKey          | DIM_PRODUCT             | ORGANIZATION_KEY         | Surrogate Key lookup on DimOrganization.OrganizationID    | —           | Type 2   | —   |
| DimProduct              | FormulationID            | DIM_PRODUCT             | FORMULATION_ID           | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | FormulationVersion       | DIM_PRODUCT             | FORMULATION_VERSION      | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | DosageForm               | DIM_PRODUCT             | DOSAGE_FORM              | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | DosageStrength           | DIM_PRODUCT             | DOSAGE_STRENGTH          | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | RouteOfAdministration    | DIM_PRODUCT             | ROUTE_OF_ADMINISTRATION  | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | TherapeuticClass         | DIM_PRODUCT             | THERAPEUTIC_CLASS        | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | TherapeuticArea          | DIM_PRODUCT             | THERAPEUTIC_AREA         | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | ProductCategory          | DIM_PRODUCT             | PRODUCT_CATEGORY         | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | IsBiosimilar             | DIM_PRODUCT             | IS_BIOSIMILAR            | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | ReferenceProductID       | DIM_PRODUCT             | REFERENCE_PRODUCT_ID     | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | INNName                  | DIM_PRODUCT             | INN_NAME                 | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | IDMPMPID                 | DIM_PRODUCT             | IDMP_MPID                | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | NDABLANumber             | DIM_PRODUCT             | NDA_BLA_NUMBER           | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | EMAProductNumber         | DIM_PRODUCT             | EMA_PRODUCT_NUMBER       | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | StandardYieldPct         | DIM_PRODUCT             | STANDARD_YIELD_PCT       | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | YieldLowerAlertPct       | DIM_PRODUCT             | YIELD_LOWER_ALERT_PCT    | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | YieldLowerActionPct      | DIM_PRODUCT             | YIELD_LOWER_ACTION_PCT   | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | ShelfLifeMonths          | DIM_PRODUCT             | SHELF_LIFE_MONTHS        | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | StorageCondition         | DIM_PRODUCT             | STORAGE_CONDITION        | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | EffectiveStartDate       | DIM_PRODUCT             | EFFECTIVE_START_DATE     | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | EffectiveEndDate         | DIM_PRODUCT             | EFFECTIVE_END_DATE       | Direct                                                     | —           | Type 2   | —   |
| DimProduct              | CurrentFlag              | DIM_PRODUCT             | CURRENT_FLAG             | Direct                                                     | —           | Type 2   | —   |
| DimMaterialLot          | MaterialLotKey           | DIM_MATERIAL_LOT        | MATERIAL_LOT_KEY         | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimMaterialLot          | LotNumber                | DIM_MATERIAL_LOT        | LOT_NUMBER               | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | ProductKey               | DIM_MATERIAL_LOT        | PRODUCT_KEY              | Surrogate Key lookup on DimProduct.ProductID              | —           | —        | —   |
| DimMaterialLot          | FacilityKey              | DIM_MATERIAL_LOT        | FACILITY_KEY             | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| DimMaterialLot          | LotType                  | DIM_MATERIAL_LOT        | LOT_TYPE                 | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | ManufactureDate          | DIM_MATERIAL_LOT        | MANUFACTURE_DATE         | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | ExpiryDate               | DIM_MATERIAL_LOT        | EXPIRY_DATE              | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | RetestDate               | DIM_MATERIAL_LOT        | RETEST_DATE              | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | QuantityProduced         | DIM_MATERIAL_LOT        | QUANTITY_PRODUCED        | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | QuantityUnit             | DIM_MATERIAL_LOT        | QUANTITY_UNIT            | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | LotStatus                | DIM_MATERIAL_LOT        | LOT_STATUS               | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | CertificateOfAnalysis    | DIM_MATERIAL_LOT        | CERTIFICATE_OF_ANALYSIS  | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | VendorLotNumber          | DIM_MATERIAL_LOT        | VENDOR_LOT_NUMBER        | Direct                                                     | —           | —        | —   |
| DimMaterialLot          | VendorID                 | DIM_MATERIAL_LOT        | VENDOR_ID                | Direct                                                     | —           | —        | —   |
| DimEquipment            | EquipmentKey             | DIM_EQUIPMENT           | EQUIPMENT_KEY            | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimEquipment            | CanonicalEquipmentID     | DIM_EQUIPMENT           | CANONICAL_EQUIPMENT_ID   | Direct                                                     | —           | —        | —   |
| DimEquipment            | EquipmentName            | DIM_EQUIPMENT           | EQUIPMENT_NAME           | Direct                                                     | —           | —        | —   |
| DimEquipment            | FacilityKey              | DIM_EQUIPMENT           | FACILITY_KEY             | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| DimEquipment            | FunctionalArea           | DIM_EQUIPMENT           | FUNCTIONAL_AREA          | Direct                                                     | —           | —        | —   |
| DimEquipment            | ProductionUnit           | DIM_EQUIPMENT           | PRODUCTION_UNIT          | Direct                                                     | —           | —        | —   |
| DimEquipment            | EquipmentModule          | DIM_EQUIPMENT           | EQUIPMENT_MODULE         | Direct                                                     | —           | —        | —   |
| DimEquipment            | AssetClass               | DIM_EQUIPMENT           | ASSET_CLASS              | Direct                                                     | —           | —        | —   |
| DimEquipment            | AssetSubclass            | DIM_EQUIPMENT           | ASSET_SUBCLASS           | Direct                                                     | —           | —        | —   |
| DimEquipment            | CriticalityRating        | DIM_EQUIPMENT           | CRITICALITY_RATING       | Direct                                                     | —           | —        | —   |
| DimEquipment            | ManufacturerName         | DIM_EQUIPMENT           | MANUFACTURER_NAME        | Direct                                                     | —           | —        | —   |
| DimEquipment            | ModelNumber              | DIM_EQUIPMENT           | MODEL_NUMBER             | Direct                                                     | —           | —        | —   |
| DimEquipment            | SerialNumber             | DIM_EQUIPMENT           | SERIAL_NUMBER            | Direct                                                     | —           | —        | —   |
| DimEquipment            | WorkingVolumeL           | DIM_EQUIPMENT           | WORKING_VOLUME_L         | Direct                                                     | —           | —        | —   |
| DimEquipment            | InstallationDate         | DIM_EQUIPMENT           | INSTALLATION_DATE        | Direct                                                     | —           | —        | —   |
| DimEquipment            | CommissioningDate        | DIM_EQUIPMENT           | COMMISSIONING_DATE       | Direct                                                     | —           | —        | —   |
| DimEquipment            | QualificationStatus      | DIM_EQUIPMENT           | QUALIFICATION_STATUS     | Direct                                                     | —           | —        | —   |
| DimEquipment            | LastQualificationDate    | DIM_EQUIPMENT           | LAST_QUALIFICATION_DATE  | Direct                                                     | —           | —        | —   |
| DimEquipment            | NextQualificationDate    | DIM_EQUIPMENT           | NEXT_QUALIFICATION_DATE  | Direct                                                     | —           | —        | —   |
| DimEquipment            | CalibrationFrequency     | DIM_EQUIPMENT           | CALIBRATION_FREQUENCY    | Direct                                                     | —           | —        | —   |
| DimEquipment            | LastCalibrationDate      | DIM_EQUIPMENT           | LAST_CALIBRATION_DATE    | Direct                                                     | —           | —        | —   |
| DimEquipment            | CalibrationDueDate       | DIM_EQUIPMENT           | CALIBRATION_DUE_DATE     | Direct                                                     | —           | —        | —   |
| DimEquipment            | CalibrationStatus        | DIM_EQUIPMENT           | CALIBRATION_STATUS       | Direct                                                     | —           | —        | —   |
| DimEquipment            | PlannedRuntimeMinsPerDay | DIM_EQUIPMENT           | PLANNED_RUNTIME_MINS_PER_DAY | Direct                                                 | —           | —        | —   |
| DimEquipment            | IdealCycleTimeSecs       | DIM_EQUIPMENT           | IDEAL_CYCLE_TIME_SECS    | Direct                                                     | —           | —        | —   |
| DimEquipment            | EquipmentStatus          | DIM_EQUIPMENT           | EQUIPMENT_STATUS         | Direct                                                     | —           | —        | —   |
| DimEquipment            | StatusEffectiveDate      | DIM_EQUIPMENT           | STATUS_EFFECTIVE_DATE    | Direct                                                     | —           | —        | —   |
| DimEquipment            | DecommissionDate         | DIM_EQUIPMENT           | DECOMMISSION_DATE        | Direct                                                     | —           | —        | —   |
| DimProcessStep          | ProcessStepKey           | DIM_PROCESS_STEP        | PROCESS_STEP_KEY         | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimProcessStep          | StepCode                 | DIM_PROCESS_STEP        | STEP_CODE                | Direct                                                     | —           | —        | —   |
| DimProcessStep          | StepName                 | DIM_PROCESS_STEP        | STEP_NAME                | Direct                                                     | —           | —        | —   |
| DimProcessStep          | StepCategory             | DIM_PROCESS_STEP        | STEP_CATEGORY            | Direct                                                     | —           | —        | —   |
| DimProcessStep          | StepSubcategory          | DIM_PROCESS_STEP        | STEP_SUBCATEGORY         | Direct                                                     | —           | —        | —   |
| DimProcessStep          | TypicalSequenceOrder     | DIM_PROCESS_STEP        | TYPICAL_SEQUENCE_ORDER   | Direct                                                     | —           | —        | —   |
| DimProcessStep          | ExpectedDurationMinHrs   | DIM_PROCESS_STEP        | EXPECTED_DURATION_MIN_HRS| Direct                                                     | —           | —        | —   |
| DimProcessStep          | ExpectedDurationMaxHrs   | DIM_PROCESS_STEP        | EXPECTED_DURATION_MAX_HRS| Direct                                                     | —           | —        | —   |
| DimProcessStep          | ApplicableAssetClasses   | DIM_PROCESS_STEP        | APPLICABLE_ASSET_CLASSES | Direct                                                     | —           | —        | —   |
| DimProcessStep          | IsCCP                    | DIM_PROCESS_STEP        | IS_CCP                   | Direct                                                     | —           | —        | —   |
| DimProcessStep          | IsActive                 | DIM_PROCESS_STEP        | IS_ACTIVE                | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | ParameterKey             | DIM_PROCESS_PARAMETER   | PARAMETER_KEY            | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimProcessParameter     | ParameterCode            | DIM_PROCESS_PARAMETER   | PARAMETER_CODE           | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | ParameterName            | DIM_PROCESS_PARAMETER   | PARAMETER_NAME           | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | ParameterCategory        | DIM_PROCESS_PARAMETER   | PARAMETER_CATEGORY       | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | CanonicalUOM             | DIM_PROCESS_PARAMETER   | CANONICAL_UOM            | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | TypicalTarget            | DIM_PROCESS_PARAMETER   | TYPICAL_TARGET           | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | TypicalLSL               | DIM_PROCESS_PARAMETER   | TYPICAL_LSL              | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | TypicalUSL               | DIM_PROCESS_PARAMETER   | TYPICAL_USL              | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | MeasurementFrequency     | DIM_PROCESS_PARAMETER   | MEASUREMENT_FREQUENCY    | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | InstrumentType           | DIM_PROCESS_PARAMETER   | INSTRUMENT_TYPE          | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | IsCPP                    | DIM_PROCESS_PARAMETER   | IS_CPP                   | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | IsKPA                    | DIM_PROCESS_PARAMETER   | IS_KPA                   | Direct                                                     | —           | —        | —   |
| DimProcessParameter     | IsActive                 | DIM_PROCESS_PARAMETER   | IS_ACTIVE                | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | DispositionKey           | DIM_QUALITY_DISPOSITION | DISPOSITION_KEY          | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimQualityDisposition   | DispositionCode          | DIM_QUALITY_DISPOSITION | DISPOSITION_CODE         | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | DispositionName          | DIM_QUALITY_DISPOSITION | DISPOSITION_NAME         | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | RequiresInvestigation    | DIM_QUALITY_DISPOSITION | REQUIRES_INVESTIGATION   | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | CommerciallyReleasable   | DIM_QUALITY_DISPOSITION | COMMERCIALLY_RELEASABLE  | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | DeviationImplied         | DIM_QUALITY_DISPOSITION | DEVIATION_IMPLIED        | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | PatientRiskLevel         | DIM_QUALITY_DISPOSITION | PATIENT_RISK_LEVEL       | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | RegulatoryNotificationRequired | DIM_QUALITY_DISPOSITION | REGULATORY_NOTIFICATION_REQUIRED | Direct                                           | —           | —        | —   |
| DimQualityDisposition   | DispositionDescription   | DIM_QUALITY_DISPOSITION | DISPOSITION_DESCRIPTION  | Direct                                                     | —           | —        | —   |
| DimQualityDisposition   | IsActive                 | DIM_QUALITY_DISPOSITION | IS_ACTIVE                | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | DeviationCategoryKey     | DIM_DEVIATION_CATEGORY  | DEVIATION_CATEGORY_KEY   | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimDeviationCategory    | CategoryCode             | DIM_DEVIATION_CATEGORY  | CATEGORY_CODE            | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | CategoryName             | DIM_DEVIATION_CATEGORY  | CATEGORY_NAME            | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | CategoryGroup            | DIM_DEVIATION_CATEGORY  | CATEGORY_GROUP           | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | Description              | DIM_DEVIATION_CATEGORY  | DESCRIPTION              | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | CAPATypicallyRequired    | DIM_DEVIATION_CATEGORY  | CAPA_TYPICALLY_REQUIRED  | Direct                                                     | —           | —        | —   |
| DimDeviationCategory    | IsActive                 | DIM_DEVIATION_CATEGORY  | IS_ACTIVE                | Direct                                                     | —           | —        | —   |
| DimOperator             | OperatorKey              | DIM_OPERATOR            | OPERATOR_KEY             | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| DimOperator             | OperatorID               | DIM_OPERATOR            | OPERATOR_ID              | Direct                                                     | —           | —        | —   |
| DimOperator             | FullName                 | DIM_OPERATOR            | FULL_NAME                | Direct                                                     | —           | —        | —   |
| DimOperator             | RoleCode                 | DIM_OPERATOR            | ROLE_CODE                | Direct                                                     | —           | —        | —   |
| DimOperator             | FacilityKey              | DIM_OPERATOR            | FACILITY_KEY             | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| DimOperator             | Department               | DIM_OPERATOR            | DEPARTMENT               | Direct                                                     | —           | —        | —   |
| DimOperator             | IsGMPTrained             | DIM_OPERATOR            | IS_GMP_TRAINED           | Direct                                                     | —           | —        | —   |
| DimOperator             | TrainingExpiryDate       | DIM_OPERATOR            | TRAINING_EXPIRY_DATE     | Direct                                                     | —           | —        | —   |
| DimOperator             | ESignatureEnabled        | DIM_OPERATOR            | ESIGNATURE_ENABLED       | Direct                                                     | —           | —        | —   |
| DimOperator             | EmploymentStatus         | DIM_OPERATOR            | EMPLOYMENT_STATUS        | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ProductionOrderKey       | FACT_PRODUCTION_ORDER   | PRODUCTION_ORDER_KEY     | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactProductionOrder     | CanonicalBatchID         | FACT_PRODUCTION_ORDER   | CANONICAL_BATCH_ID       | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | FacilityKey              | FACT_PRODUCTION_ORDER   | FACILITY_KEY             | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| FactProductionOrder     | ProductKey               | FACT_PRODUCTION_ORDER   | PRODUCT_KEY              | Surrogate Key lookup on DimProduct.ProductID              | —           | —        | —   |
| FactProductionOrder     | PrimaryEquipmentKey      | FACT_PRODUCTION_ORDER   | PRIMARY_EQUIPMENT_KEY    | Surrogate Key lookup on DimEquipment.CanonicalEquipmentID | —           | —        | —   |
| FactProductionOrder     | DispositionKey           | FACT_PRODUCTION_ORDER   | DISPOSITION_KEY          | Surrogate Key lookup on DimQualityDisposition.DispositionCode | —       | —        | —   |
| FactProductionOrder     | PlannedStartUTC          | FACT_PRODUCTION_ORDER   | PLANNED_START_UTC        | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | PlannedEndUTC            | FACT_PRODUCTION_ORDER   | PLANNED_END_UTC          | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | PlannedQuantity          | FACT_PRODUCTION_ORDER   | PLANNED_QUANTITY         | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | QuantityUOM              | FACT_PRODUCTION_ORDER   | QUANTITY_UOM             | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ActualStartUTC           | FACT_PRODUCTION_ORDER   | ACTUAL_START_UTC         | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ActualEndUTC             | FACT_PRODUCTION_ORDER   | ACTUAL_END_UTC           | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ActualQuantity           | FACT_PRODUCTION_ORDER   | ACTUAL_QUANTITY          | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | YieldPct                 | FACT_PRODUCTION_ORDER   | YIELD_PCT                | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | YieldVariancePct         | FACT_PRODUCTION_ORDER   | YIELD_VARIANCE_PCT       | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | OEEAvailabilityPct       | FACT_PRODUCTION_ORDER   | OEE_AVAILABILITY_PCT     | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | OEEPerformancePct        | FACT_PRODUCTION_ORDER   | OEE_PERFORMANCE_PCT      | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | OEEQualityPct            | FACT_PRODUCTION_ORDER   | OEE_QUALITY_PCT          | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | OEEOverallPct            | FACT_PRODUCTION_ORDER   | OEE_OVERALL_PCT          | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | BatchStatus              | FACT_PRODUCTION_ORDER   | BATCH_STATUS             | Status mapping via lookup table                            | —           | —        | —   |
| FactProductionOrder     | DeviationCount           | FACT_PRODUCTION_ORDER   | DEVIATION_COUNT          | Direct                                                     | Additive    | —        | —   |
| FactProductionOrder     | IsGoldenBatch            | FACT_PRODUCTION_ORDER   | IS_GOLDEN_BATCH          | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | GoldenBatchReference     | FACT_PRODUCTION_ORDER   | GOLDEN_BATCH_REFERENCE   | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ShiftAtStart             | FACT_PRODUCTION_ORDER   | SHIFT_AT_START           | Direct                                                     | —           | —        | —   |
| FactProductionOrder     | ShiftSupervisorKey       | FACT_PRODUCTION_ORDER   | SHIFT_SUPERVISOR_KEY     | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactBatchStep           | BatchStepKey             | FACT_BATCH_STEP         | BATCH_STEP_KEY           | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactBatchStep           | ProductionOrderKey       | FACT_BATCH_STEP         | PRODUCTION_ORDER_KEY     | Surrogate Key lookup on FactProductionOrder.ProductionOrderKey | —      | —        | —   |
| FactBatchStep           | CanonicalBatchID         | FACT_BATCH_STEP         | CANONICAL_BATCH_ID       | Direct                                                     | —           | —        | —   |
| FactBatchStep           | ProcessStepKey           | FACT_BATCH_STEP         | PROCESS_STEP_KEY         | Surrogate Key lookup on DimProcessStep.ProcessStepKey     | —           | —        | —   |
| FactBatchStep           | EquipmentKey             | FACT_BATCH_STEP         | EQUIPMENT_KEY            | Surrogate Key lookup on DimEquipment.EquipmentKey         | —           | —        | —   |
| FactBatchStep           | StepSequence             | FACT_BATCH_STEP         | STEP_SEQUENCE            | Direct                                                     | —           | —        | —   |
| FactBatchStep           | StepStartUTC             | FACT_BATCH_STEP         | STEP_START_UTC           | Direct                                                     | —           | —        | —   |
| FactBatchStep           | StepEndUTC               | FACT_BATCH_STEP         | STEP_END_UTC             | Direct                                                     | —           | —        | —   |
| FactBatchStep           | StepDurationHrs          | FACT_BATCH_STEP         | STEP_DURATION_HRS        | Direct                                                     | Additive    | —        | —   |
| FactBatchStep           | InputQuantity            | FACT_BATCH_STEP         | INPUT_QUANTITY           | Direct                                                     | Additive    | —        | —   |
| FactBatchStep           | OutputQuantity           | FACT_BATCH_STEP         | OUTPUT_QUANTITY          | Direct                                                     | Additive    | —        | —   |
| FactBatchStep           | QuantityUOM              | FACT_BATCH_STEP         | QUANTITY_UOM             | Direct                                                     | —           | —        | —   |
| FactBatchStep           | StepYieldPct             | FACT_BATCH_STEP         | STEP_YIELD_PCT           | Direct                                                     | Additive    | —        | —   |
| FactBatchStep           | StepStatus               | FACT_BATCH_STEP         | STEP_STATUS              | Direct                                                     | —           | —        | —   |
| FactBatchStep           | OperatorKey              | FACT_BATCH_STEP         | OPERATOR_KEY             | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactBatchStep           | VerifierKey              | FACT_BATCH_STEP         | VERIFIER_KEY             | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactBatchStep           | HasDeviation             | FACT_BATCH_STEP         | HAS_DEVIATION            | Direct                                                     | —           | —        | —   |
| FactBatchStep           | DeviationCount           | FACT_BATCH_STEP         | DEVIATION_COUNT          | Direct                                                     | Additive    | —        | —   |
| FactEquipmentTelemetry  | TelemetryKey             | FACT_EQUIPMENT_TELEMETRY | TELEMETRY_KEY          | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactEquipmentTelemetry  | EquipmentKey             | FACT_EQUIPMENT_TELEMETRY | EQUIPMENT_KEY          | Surrogate Key lookup on DimEquipment.EquipmentKey         | —           | —        | —   |
| FactEquipmentTelemetry  | BatchStepKey             | FACT_EQUIPMENT_TELEMETRY | BATCH_STEP_KEY        | Surrogate Key lookup on FactBatchStep.BatchStepKey        | —           | —        | —   |
| FactEquipmentTelemetry  | ProductionOrderKey       | FACT_EQUIPMENT_TELEMETRY | PRODUCTION_ORDER_KEY  | Surrogate Key lookup on FactProductionOrder.ProductionOrderKey | —      | —        | —   |
| FactEquipmentTelemetry  | CanonicalBatchID         | FACT_EQUIPMENT_TELEMETRY | CANONICAL_BATCH_ID    | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | ParameterKey             | FACT_EQUIPMENT_TELEMETRY | PARAMETER_KEY         | Surrogate Key lookup on DimProcessParameter.ParameterKey  | —           | —        | —   |
| FactEquipmentTelemetry  | ReadingTimestampUTC      | FACT_EQUIPMENT_TELEMETRY | READING_TIMESTAMP_UTC | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | CanonicalValue           | FACT_EQUIPMENT_TELEMETRY | CANONICAL_VALUE       | Direct                                                     | Additive    | —        | —   |
| FactEquipmentTelemetry  | CanonicalUOM             | FACT_EQUIPMENT_TELEMETRY | CANONICAL_UOM         | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | SourceValue              | FACT_EQUIPMENT_TELEMETRY | SOURCE_VALUE          | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | SourceUOM                | FACT_EQUIPMENT_TELEMETRY | SOURCE_UOM            | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | ConversionApplied        | FACT_EQUIPMENT_TELEMETRY | CONVERSION_APPLIED    | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | TargetValue              | FACT_EQUIPMENT_TELEMETRY | TARGET_VALUE          | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | LowerSpecLimit           | FACT_EQUIPMENT_TELEMETRY | LOWER_SPEC_LIMIT      | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | UpperSpecLimit           | FACT_EQUIPMENT_TELEMETRY | UPPER_SPEC_LIMIT      | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | WithinSpecification      | FACT_EQUIPMENT_TELEMETRY | WITHIN_SPECIFICATION  | Direct                                                     | —           | —        | —   |
| FactEquipmentTelemetry  | AggregationType          | FACT_EQUIPMENT_TELEMETRY | AGGREGATION_TYPE      | Direct                                                     | —           | —        | —   |
| FactDeviation           | DeviationKey             | FACT_DEVIATION          | DEVIATION_KEY          | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactDeviation           | CanonicalDeviationID     | FACT_DEVIATION          | CANONICAL_DEVIATION_ID | Direct                                                     | —           | —        | —   |
| FactDeviation           | ProductionOrderKey       | FACT_DEVIATION          | PRODUCTION_ORDER_KEY   | Surrogate Key lookup on FactProductionOrder.ProductionOrderKey | —      | —        | —   |
| FactDeviation           | BatchStepKey             | FACT_DEVIATION          | BATCH_STEP_KEY         | Surrogate Key lookup on FactBatchStep.BatchStepKey        | —           | —        | —   |
| FactDeviation           | TelemetryKey             | FACT_DEVIATION          | TELEMETRY_KEY          | Surrogate Key lookup on FactEquipmentTelemetry.TelemetryKey | —        | —        | —   |
| FactDeviation           | EquipmentKey             | FACT_DEVIATION          | EQUIPMENT_KEY          | Surrogate Key lookup on DimEquipment.EquipmentKey         | —           | —        | —   |
| FactDeviation           | ParameterKey             | FACT_DEVIATION          | PARAMETER_KEY          | Surrogate Key lookup on DimProcessParameter.ParameterKey  | —           | —        | —   |
| FactDeviation           | DeviationCategoryKey     | FACT_DEVIATION          | DEVIATION_CATEGORY_KEY | Surrogate Key lookup on DimDeviationCategory.DeviationCategoryKey | —   | —        | —   |
| FactDeviation           | FacilityKey              | FACT_DEVIATION          | FACILITY_KEY           | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| FactDeviation           | CanonicalBatchID         | FACT_DEVIATION          | CANONICAL_BATCH_ID     | Direct                                                     | —           | —        | —   |
| FactDeviation           | DetectedTimestampUTC     | FACT_DEVIATION          | DETECTED_TIMESTAMP_UTC | Direct                                                     | —           | —        | —   |
| FactDeviation           | DetectedByKey            | FACT_DEVIATION          | DETECTED_BY_KEY        | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactDeviation           | SeverityCode             | FACT_DEVIATION          | SEVERITY_CODE          | Direct                                                     | —           | —        | —   |
| FactDeviation           | DeviationDescription     | FACT_DEVIATION          | DEVIATION_DESCRIPTION  | Direct                                                     | —           | —        | —   |
| FactDeviation           | InvestigationStatus      | FACT_DEVIATION          | INVESTIGATION_STATUS   | Direct                                                     | —           | —        | —   |
| FactDeviation           | AssignedToKey            | FACT_DEVIATION          | ASSIGNED_TO_KEY        | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactYieldAnalytics      | YieldAnalyticsKey        | FACT_YIELD_ANALYTICS    | YIELD_ANALYTICS_KEY    | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactYieldAnalytics      | AnalysisDate             | FACT_YIELD_ANALYTICS    | ANALYSIS_DATE          | Direct                                                     | —           | —        | —   |
| FactYieldAnalytics      | FacilityKey              | FACT_YIELD_ANALYTICS    | FACILITY_KEY           | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| FactYieldAnalytics      | ProductKey               | FACT_YIELD_ANALYTICS    | PRODUCT_KEY            | Surrogate Key lookup on DimProduct.ProductID              | —           | —        | —   |
| FactYieldAnalytics      | AggregationLevel         | FACT_YIELD_ANALYTICS    | AGGREGATION_LEVEL      | Direct                                                     | —           | —        | —   |
| FactYieldAnalytics      | BatchesStarted           | FACT_YIELD_ANALYTICS    | BATCHES_STARTED        | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | BatchesCompleted         | FACT_YIELD_ANALYTICS    | BATCHES_COMPLETED      | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | BatchesOnHold            | FACT_YIELD_ANALYTICS    | BATCHES_ON_HOLD        | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | BatchesFailed            | FACT_YIELD_ANALYTICS    | BATCHES_FAILED         | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | AvgYieldPct              | FACT_YIELD_ANALYTICS    | AVG_YIELD_PCT          | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | MinYieldPct              | FACT_YIELD_ANALYTICS    | MIN_YIELD_PCT          | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | MaxYieldPct              | FACT_YIELD_ANALYTICS    | MAX_YIELD_PCT          | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | StdYieldPct              | FACT_YIELD_ANALYTICS    | STD_YIELD_PCT          | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | YieldBelowTargetCount    | FACT_YIELD_ANALYTICS    | YIELD_BELOW_TARGET_COUNT | Direct                                                   | Additive    | —        | —   |
| FactYieldAnalytics      | TotalPlannedQty          | FACT_YIELD_ANALYTICS    | TOTAL_PLANNED_QTY      | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | TotalActualQty           | FACT_YIELD_ANALYTICS    | TOTAL_ACTUAL_QTY       | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | QuantityUOM              | FACT_YIELD_ANALYTICS    | QUANTITY_UOM           | Direct                                                     | —           | —        | —   |
| FactYieldAnalytics      | AvgOEEPct                | FACT_YIELD_ANALYTICS    | AVG_OEE_PCT            | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | AvgAvailabilityPct       | FACT_YIELD_ANALYTICS    | AVG_AVAILABILITY_PCT   | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | AvgPerformancePct        | FACT_YIELD_ANALYTICS    | AVG_PERFORMANCE_PCT    | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | AvgQualityPct            | FACT_YIELD_ANALYTICS    | AVG_QUALITY_PCT        | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | TotalDeviations          | FACT_YIELD_ANALYTICS    | TOTAL_DEVIATIONS       | Direct                                                     | Additive    | —        | —   |
| FactYieldAnalytics      | HighCriticalDeviations   | FACT_YIELD_ANALYTICS    | HIGH_CRITICAL_DEVIATIONS | Direct                                                   | Additive    | —        | —   |
| FactYieldAnalytics      | CPPComplianceRatePct     | FACT_YIELD_ANALYTICS    | CPP_COMPLIANCE_RATE_PCT | Direct                                                   | Additive    | —        | —   |
| FactShiftLog            | ShiftLogKey              | FACT_SHIFT_LOG          | SHIFT_LOG_KEY          | Surrogate Key (system-generated INTEGER)                  | —           | —        | —   |
| FactShiftLog            | FacilityKey              | FACT_SHIFT_LOG          | FACILITY_KEY           | Surrogate Key lookup on DimFacility.FacilityID            | —           | —        | —   |
| FactShiftLog            | LogDate                  | FACT_SHIFT_LOG          | LOG_DATE               | Direct                                                     | —           | —        | —   |
| FactShiftLog            | ShiftName                | FACT_SHIFT_LOG          | SHIFT_NAME             | Direct                                                     | —           | —        | —   |
| FactShiftLog            | ShiftStartUTC            | FACT_SHIFT_LOG          | SHIFT_START_UTC        | Direct                                                     | —           | —        | —   |
| FactShiftLog            | ShiftEndUTC              | FACT_SHIFT_LOG          | SHIFT_END_UTC          | Direct                                                     | —           | —        | —   |
| FactShiftLog            | SupervisorKey            | FACT_SHIFT_LOG          | SUPERVISOR_KEY         | Surrogate Key lookup on DimOperator.OperatorID            | —           | —        | —   |
| FactShiftLog            | ActiveBatches            | FACT_SHIFT_LOG          | ACTIVE_BATCHES         | Direct                                                     | Additive    | —        | —   |
| FactShiftLog            | CompletedBatches         | FACT_SHIFT_LOG          | COMPLETED_BATCHES      | Direct                                                     | Additive    | —        | —   |
| FactShiftLog            | NewDeviations            | FACT_SHIFT_LOG          | NEW_DEVIATIONS         | Direct                                                     | Additive    | —        | —   |
| FactShiftLog            | ClosedDeviations         | FACT_SHIFT_LOG          | CLOSED_DEVIATIONS      | Direct                                                     | Additive    | —        | —   |
| FactShiftLog            | EquipmentDowntimeMins    | FACT_SHIFT_LOG          | EQUIPMENT_DOWNTIME_MINS | Direct                                                    | Additive    | —        | —   |
| FactShiftLog            | EquipmentIssuesCount     | FACT_SHIFT_LOG          | EQUIPMENT_ISSUES_COUNT | Direct                                                     | Additive    | —        | —   |
| FactShiftLog            | SignedOff                | FACT_SHIFT_LOG          | SIGNED_OFF             | Direct                                                     | —           | —        | —   |
| FactShiftLog            | SignedOffUTC             | FACT_SHIFT_LOG          | SIGNED_OFF_UTC         | Direct                                                     | —           | —        | —   |
| FactShiftLog            | ShiftNotes               | FACT_SHIFT_LOG          | SHIFT_NOTES            | Direct                                                     | —           | —        | —   |
| DimDate                 | DateKey                  | —                       | —                      | Surrogate Key (system-generated, YYYYMMDD)                 | —           | —        | —   |
| DimDate                 | FullDate                 | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | Day                      | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | Month                    | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | MonthName                | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | Quarter                  | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | Year                     | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | WeekNumber               | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | DayOfWeek                | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | DayName                  | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | IsWeekend                | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | IsHoliday                | —                       | —                      | Derived from calendar date                                | —           | —        | —   |
| DimDate                 | FiscalYear               | —                       | —                      | Derived from calendar date and fiscal calendar            | —           | —        | —   |
| DimDate                 | FiscalQuarter            | —                       | —                      | Derived from calendar date and fiscal calendar            | —           | —        | —   |
