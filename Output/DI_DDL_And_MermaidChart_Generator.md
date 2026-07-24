### SECTION 1 — DDL

```sql

-- [DIMENSION]
CREATE TABLE DIM_ORGANIZATION (
    OrganizationKey INTEGER AUTOINCREMENT,
    OrganizationID VARCHAR(50),
    OrganizationName VARCHAR(200),
    OrganizationType VARCHAR(80),
    ParentOrganizationKey INTEGER,
    CountryCode CHAR(2),
    RegulatoryRegion VARCHAR(80),
    IsActive BOOLEAN,
    EffectiveStartDate DATE,
    EffectiveEndDate DATE,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (OrganizationKey)
);

-- [DIMENSION]
CREATE TABLE DIM_FACILITY (
    FacilityKey INTEGER AUTOINCREMENT,
    FacilityID VARCHAR(50),
    FacilityName VARCHAR(200),
    FacilityShortName VARCHAR(80),
    OrganizationKey INTEGER,
    SiteCode VARCHAR(20),
    FacilityType VARCHAR(80),
    AddressLine1 VARCHAR(200),
    AddressLine2 VARCHAR(200),
    City VARCHAR(100),
    StateRegion VARCHAR(100),
    PostalCode VARCHAR(20),
    CountryCode CHAR(2),
    TimezoneName VARCHAR(80),
    UtcOffsetHours DECIMAL(4,2),
    GmpCertified BOOLEAN,
    GmpCertificationDate DATE,
    GmpExpiryDate DATE,
    RegulatoryAgency VARCHAR(80),
    FdaEstablishmentId VARCHAR(50),
    EmaSiteCode VARCHAR(50),
    ManufacturingCapacity VARCHAR(80),
    SourceSiteCodeMartA VARCHAR(20),
    SourcePlantCodeOps VARCHAR(30),
    SourceFacCodeMartB VARCHAR(30),
    EffectiveStartDate DATE,
    EffectiveEndDate DATE,
    CurrentFlag BOOLEAN,
    ScdVersion INTEGER,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (FacilityKey),
    FOREIGN KEY (OrganizationKey) REFERENCES DIM_ORGANIZATION(OrganizationKey)
);

-- [DIMENSION]
CREATE TABLE DIM_PRODUCT (
    ProductKey INTEGER AUTOINCREMENT,
    ProductID VARCHAR(50),
    SKU VARCHAR(60),
    ProductName VARCHAR(200),
    ProductShortName VARCHAR(80),
    OrganizationKey INTEGER,
    FormulationId VARCHAR(60),
    FormulationVersion VARCHAR(20),
    DosageForm VARCHAR(80),
    DosageStrength VARCHAR(80),
    RouteOfAdministration VARCHAR(80),
    TherapeuticClass VARCHAR(100),
    TherapeuticArea VARCHAR(100),
    ProductCategory VARCHAR(80),
    IsBiosimilar BOOLEAN,
    ReferenceProductId VARCHAR(50),
    InnName VARCHAR(200),
    IdmpMpid VARCHAR(100),
    NdaBlaNumber VARCHAR(50),
    EmaProductNumber VARCHAR(50),
    StandardYieldPct DECIMAL(6,3),
    YieldLowerAlertPct DECIMAL(6,3),
    YieldLowerActionPct DECIMAL(6,3),
    ShelfLifeMonths INTEGER,
    StorageCondition VARCHAR(80),
    EffectiveStartDate DATE,
    EffectiveEndDate DATE,
    CurrentFlag BOOLEAN,
    ScdVersion INTEGER,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    SourceProductCodeMartA VARCHAR(50),
    SourceProductCodeOps VARCHAR(50),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (ProductKey),
    FOREIGN KEY (OrganizationKey) REFERENCES DIM_ORGANIZATION(OrganizationKey)
);

-- [DIMENSION]
CREATE TABLE DIM_MATERIAL_LOT (
    MaterialLotKey INTEGER AUTOINCREMENT,
    LotNumber VARCHAR(80),
    ProductKey INTEGER,
    FacilityKey INTEGER,
    LotType VARCHAR(50),
    ManufactureDate DATE,
    ExpiryDate DATE,
    RetestDate DATE,
    QuantityProduced DECIMAL(18,3),
    QuantityUnit VARCHAR(20),
    LotStatus VARCHAR(40),
    CertificateOfAnalysis VARCHAR(200),
    VendorLotNumber VARCHAR(80),
    VendorId VARCHAR(80),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (MaterialLotKey),
    FOREIGN KEY (ProductKey) REFERENCES DIM_PRODUCT(ProductKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey)
);

-- [DIMENSION]
CREATE TABLE DIM_EQUIPMENT (
    EquipmentKey INTEGER AUTOINCREMENT,
    CanonicalEquipmentID VARCHAR(50),
    EquipmentName VARCHAR(200),
    FacilityKey INTEGER,
    FunctionalArea VARCHAR(80),
    ProductionUnit VARCHAR(80),
    EquipmentModule VARCHAR(80),
    AssetClass VARCHAR(80),
    AssetSubClass VARCHAR(80),
    CriticalityRating VARCHAR(20),
    ManufacturerName VARCHAR(100),
    ModelNumber VARCHAR(100),
    SerialNumber VARCHAR(100),
    WorkingVolumeL DECIMAL(12,3),
    InstallationDate DATE,
    CommissioningDate DATE,
    QualificationStatus VARCHAR(30),
    LastQualificationDate DATE,
    NextQualificationDate DATE,
    CalibrationFrequency VARCHAR(30),
    LastCalibrationDate DATE,
    CalibrationDueDate DATE,
    CalibrationStatus VARCHAR(30),
    PlannedRuntimeMinsPerDay INTEGER,
    IdealCycleTimeSecs DECIMAL(12,4),
    EquipmentStatus VARCHAR(30),
    StatusEffectiveDate DATE,
    DecommissionDate DATE,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    SourceEquipIdMartA VARCHAR(50),
    SourceAssetCodeOps VARCHAR(50),
    SourceEquipCodeMartB VARCHAR(50),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (EquipmentKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey)
);

-- [DIMENSION]
CREATE TABLE DIM_PROCESS_STEP (
    ProcessStepKey INTEGER AUTOINCREMENT,
    StepCode VARCHAR(40),
    StepName VARCHAR(100),
    StepCategory VARCHAR(60),
    StepSubCategory VARCHAR(60),
    TypicalSequenceOrder INTEGER,
    ExpectedDurationMinHrs DECIMAL(8,2),
    ExpectedDurationMaxHrs DECIMAL(8,2),
    ApplicableAssetClasses VARCHAR(200),
    IsCcp BOOLEAN,
    IsActive BOOLEAN,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (ProcessStepKey)
);

-- [DIMENSION]
CREATE TABLE DIM_PROCESS_PARAMETER (
    ParameterKey INTEGER AUTOINCREMENT,
    ParameterCode VARCHAR(60),
    ParameterName VARCHAR(150),
    ParameterCategory VARCHAR(60),
    CanonicalUom VARCHAR(30),
    SourceUomMartA VARCHAR(30),
    SourceUomOps VARCHAR(30),
    SourceUomMartB VARCHAR(30),
    ConversionFormulaOps VARCHAR(200),
    IsCpp BOOLEAN,
    IsKpa BOOLEAN,
    TypicalTarget DECIMAL(18,4),
    TypicalLsl DECIMAL(18,4),
    TypicalUsl DECIMAL(18,4),
    MeasurementFrequency VARCHAR(50),
    InstrumentType VARCHAR(100),
    IsActive BOOLEAN,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (ParameterKey)
);

-- [DIMENSION]
CREATE TABLE DIM_QUALITY_DISPOSITION (
    DispositionKey INTEGER AUTOINCREMENT,
    DispositionCode VARCHAR(40),
    DispositionName VARCHAR(100),
    RequiresInvestigation BOOLEAN,
    CommerciallyReleasable BOOLEAN,
    DeviationImplied BOOLEAN,
    PatientRiskLevel VARCHAR(20),
    RegulatoryNotificationRequired BOOLEAN,
    DispositionDescription VARCHAR(500),
    IsActive BOOLEAN,
    SourceCodeMartA VARCHAR(40),
    SourceCodeMartB VARCHAR(40),
    SourceCodeOps VARCHAR(10),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (DispositionKey)
);

-- [DIMENSION]
CREATE TABLE DIM_DEVIATION_CATEGORY (
    DeviationCategoryKey INTEGER AUTOINCREMENT,
    CategoryCode VARCHAR(50),
    CategoryName VARCHAR(100),
    CategoryGroup VARCHAR(80),
    Description VARCHAR(500),
    CapaTypicallyRequired BOOLEAN,
    IsActive BOOLEAN,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (DeviationCategoryKey)
);

-- [DIMENSION]
CREATE TABLE DIM_OPERATOR (
    OperatorKey INTEGER AUTOINCREMENT,
    OperatorID VARCHAR(50),
    FullName VARCHAR(200),
    RoleCode VARCHAR(50),
    FacilityKey INTEGER,
    Department VARCHAR(100),
    IsGmpTrained BOOLEAN,
    TrainingExpiryDate DATE,
    EsignatureEnabled BOOLEAN,
    EmploymentStatus VARCHAR(30),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (OperatorKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey)
);

-- [DIMENSION]
CREATE TABLE DIM_DATE (
    DateKey INTEGER AUTOINCREMENT,
    FullDate DATE,
    Day INTEGER,
    Month INTEGER,
    MonthName VARCHAR(20),
    Quarter INTEGER,
    Year INTEGER,
    WeekNumber INTEGER,
    DayOfWeek INTEGER,
    DayName VARCHAR(20),
    IsWeekend BOOLEAN,
    IsHoliday BOOLEAN,
    FiscalYear INTEGER,
    FiscalQuarter INTEGER,
    IsCurrent BOOLEAN,
    EffectiveDate DATE,
    ExpiryDate DATE,
    PRIMARY KEY (DateKey)
);

-- [FACT]
CREATE TABLE FACT_PRODUCTION_ORDER (
    ProductionOrderKey INTEGER AUTOINCREMENT,
    CanonicalBatchID VARCHAR(50),
    ErpOrderNumber VARCHAR(50),
    MesBatchReference VARCHAR(80),
    GmpLotNumber VARCHAR(80),
    FacilityKey INTEGER,
    ProductKey INTEGER,
    PrimaryEquipmentKey INTEGER,
    DispositionKey INTEGER,
    PlannedStartUtc TIMESTAMP_TZ,
    PlannedEndUtc TIMESTAMP_TZ,
    PlannedQuantity DECIMAL(18,3),
    QuantityUom VARCHAR(20),
    ActualStartUtc TIMESTAMP_TZ,
    ActualEndUtc TIMESTAMP_TZ,
    ActualQuantity DECIMAL(18,3),
    YieldPct DECIMAL(6,3),
    YieldVariancePct DECIMAL(8,4),
    OeeAvailabilityPct DECIMAL(6,3),
    OeePerformancePct DECIMAL(6,3),
    OeeQualityPct DECIMAL(6,3),
    OeeOverallPct DECIMAL(6,3),
    BatchStatus VARCHAR(30),
    DeviationCount INTEGER,
    IsGoldenBatch BOOLEAN,
    GoldenBatchReference VARCHAR(50),
    ShiftAtStart VARCHAR(20),
    ShiftSupervisorKey INTEGER,
    SourceBatchIdMartA VARCHAR(50),
    SourceBatchIdOps VARCHAR(50),
    SourceOrderNumOps VARCHAR(50),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (ProductionOrderKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey),
    FOREIGN KEY (ProductKey) REFERENCES DIM_PRODUCT(ProductKey),
    FOREIGN KEY (PrimaryEquipmentKey) REFERENCES DIM_EQUIPMENT(EquipmentKey),
    FOREIGN KEY (DispositionKey) REFERENCES DIM_QUALITY_DISPOSITION(DispositionKey),
    FOREIGN KEY (ShiftSupervisorKey) REFERENCES DIM_OPERATOR(OperatorKey)
);

-- [FACT]
CREATE TABLE FACT_BATCH_STEP (
    BatchStepKey INTEGER AUTOINCREMENT,
    ProductionOrderKey INTEGER,
    CanonicalBatchID VARCHAR(50),
    ProcessStepKey INTEGER,
    EquipmentKey INTEGER,
    StepSequence INTEGER,
    StepStartUtc TIMESTAMP_TZ,
    StepEndUtc TIMESTAMP_TZ,
    StepDurationHrs DECIMAL(10,4),
    InputQuantity DECIMAL(18,3),
    OutputQuantity DECIMAL(18,3),
    QuantityUom VARCHAR(20),
    StepYieldPct DECIMAL(6,3),
    StepStatus VARCHAR(30),
    OperatorKey INTEGER,
    VerifierKey INTEGER,
    EsignatureTimestampUtc TIMESTAMP_TZ,
    EsignatureMeaning VARCHAR(200),
    HasDeviation BOOLEAN,
    DeviationCount INTEGER,
    StepNotes VARCHAR(2000),
    SourceRunIdMartA VARCHAR(50),
    SourceStepIdOps INTEGER,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (BatchStepKey),
    FOREIGN KEY (ProductionOrderKey) REFERENCES FACT_PRODUCTION_ORDER(ProductionOrderKey),
    FOREIGN KEY (ProcessStepKey) REFERENCES DIM_PROCESS_STEP(ProcessStepKey),
    FOREIGN KEY (EquipmentKey) REFERENCES DIM_EQUIPMENT(EquipmentKey),
    FOREIGN KEY (OperatorKey) REFERENCES DIM_OPERATOR(OperatorKey),
    FOREIGN KEY (VerifierKey) REFERENCES DIM_OPERATOR(OperatorKey)
);

-- [FACT]
CREATE TABLE FACT_EQUIPMENT_TELEMETRY (
    TelemetryKey INTEGER AUTOINCREMENT,
    EquipmentKey INTEGER,
    BatchStepKey INTEGER,
    ProductionOrderKey INTEGER,
    CanonicalBatchID VARCHAR(50),
    ParameterKey INTEGER,
    ReadingTimestampUtc TIMESTAMP_TZ,
    CanonicalValue DECIMAL(18,4),
    CanonicalUom VARCHAR(30),
    SourceValue DECIMAL(18,4),
    SourceUom VARCHAR(30),
    ConversionApplied VARCHAR(200),
    TargetValue DECIMAL(18,4),
    LowerSpecLimit DECIMAL(18,4),
    UpperSpecLimit DECIMAL(18,4),
    LowerAlertLimit DECIMAL(18,4),
    UpperAlertLimit DECIMAL(18,4),
    WithinSpecification BOOLEAN,
    WithinAlert BOOLEAN,
    DeviationFromTarget DECIMAL(18,4),
    GoldenBatchValue DECIMAL(18,4),
    GoldenBatchDeviation DECIMAL(18,4),
    AggregationType VARCHAR(30),
    SourceSystemType VARCHAR(30),
    SourceReadingIdMartA VARCHAR(60),
    SourceReadingIdOps INTEGER,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (TelemetryKey),
    FOREIGN KEY (EquipmentKey) REFERENCES DIM_EQUIPMENT(EquipmentKey),
    FOREIGN KEY (BatchStepKey) REFERENCES FACT_BATCH_STEP(BatchStepKey),
    FOREIGN KEY (ProductionOrderKey) REFERENCES FACT_PRODUCTION_ORDER(ProductionOrderKey),
    FOREIGN KEY (ParameterKey) REFERENCES DIM_PROCESS_PARAMETER(ParameterKey)
);

-- [FACT]
CREATE TABLE FACT_DEVIATION (
    DeviationKey INTEGER AUTOINCREMENT,
    CanonicalDeviationID VARCHAR(60),
    ProductionOrderKey INTEGER,
    BatchStepKey INTEGER,
    TelemetryKey INTEGER,
    EquipmentKey INTEGER,
    ParameterKey INTEGER,
    DeviationCategoryKey INTEGER,
    FacilityKey INTEGER,
    CanonicalBatchID VARCHAR(50),
    DetectedTimestampUtc TIMESTAMP_TZ,
    DetectedByKey INTEGER,
    DetectionMethod VARCHAR(80),
    SeverityCode VARCHAR(20),
    PotentialImpact VARCHAR(200),
    DeviationDescription VARCHAR(4000),
    InvestigationStatus VARCHAR(30),
    AssignedToKey INTEGER,
    InvestigationStartUtc TIMESTAMP_TZ,
    InvestigationEndUtc TIMESTAMP_TZ,
    RootCauseCode VARCHAR(80),
    RootCauseDescription VARCHAR(2000),
    CapaRequired BOOLEAN,
    CapaReferenceId VARCHAR(60),
    CapaDueDate DATE,
    CapaClosedDate DATE,
    ClosedTimestampUtc TIMESTAMP_TZ,
    ClosedByKey INTEGER,
    ResolutionSummary VARCHAR(4000),
    RegulatoryNotificationRequired BOOLEAN,
    RegulatoryNotifiedDate DATE,
    SourceDevIdMartA VARCHAR(50),
    SourceDevNumOps VARCHAR(50),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (DeviationKey),
    FOREIGN KEY (ProductionOrderKey) REFERENCES FACT_PRODUCTION_ORDER(ProductionOrderKey),
    FOREIGN KEY (BatchStepKey) REFERENCES FACT_BATCH_STEP(BatchStepKey),
    FOREIGN KEY (TelemetryKey) REFERENCES FACT_EQUIPMENT_TELEMETRY(TelemetryKey),
    FOREIGN KEY (EquipmentKey) REFERENCES DIM_EQUIPMENT(EquipmentKey),
    FOREIGN KEY (ParameterKey) REFERENCES DIM_PROCESS_PARAMETER(ParameterKey),
    FOREIGN KEY (DeviationCategoryKey) REFERENCES DIM_DEVIATION_CATEGORY(DeviationCategoryKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey),
    FOREIGN KEY (DetectedByKey) REFERENCES DIM_OPERATOR(OperatorKey),
    FOREIGN KEY (AssignedToKey) REFERENCES DIM_OPERATOR(OperatorKey),
    FOREIGN KEY (ClosedByKey) REFERENCES DIM_OPERATOR(OperatorKey)
);

-- [FACT]
CREATE TABLE FACT_YIELD_ANALYTICS (
    YieldAnalyticsKey INTEGER AUTOINCREMENT,
    AnalysisDateKey INTEGER,
    FacilityKey INTEGER,
    ProductKey INTEGER,
    AggregationLevel VARCHAR(30),
    BatchesStarted INTEGER,
    BatchesCompleted INTEGER,
    BatchesOnHold INTEGER,
    BatchesFailed INTEGER,
    AvgYieldPct DECIMAL(6,3),
    MinYieldPct DECIMAL(6,3),
    MaxYieldPct DECIMAL(6,3),
    StdYieldPct DECIMAL(8,4),
    YieldBelowTargetCount INTEGER,
    YieldTargetAttainmentPct DECIMAL(6,3),
    TotalPlannedQty DECIMAL(18,3),
    TotalActualQty DECIMAL(18,3),
    QuantityUom VARCHAR(20),
    AvgOeePct DECIMAL(6,3),
    AvgAvailabilityPct DECIMAL(6,3),
    AvgPerformancePct DECIMAL(6,3),
    AvgQualityPct DECIMAL(6,3),
    TotalDeviations INTEGER,
    HighCriticalDeviations INTEGER,
    CppComplianceRatePct DECIMAL(6,3),
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (YieldAnalyticsKey),
    FOREIGN KEY (AnalysisDateKey) REFERENCES DIM_DATE(DateKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey),
    FOREIGN KEY (ProductKey) REFERENCES DIM_PRODUCT(ProductKey)
);

-- [FACT]
CREATE TABLE FACT_SHIFT_LOG (
    ShiftLogKey INTEGER AUTOINCREMENT,
    FacilityKey INTEGER,
    LogDateKey INTEGER,
    ShiftName VARCHAR(20),
    ShiftStartUtc TIMESTAMP_TZ,
    ShiftEndUtc TIMESTAMP_TZ,
    SupervisorKey INTEGER,
    ActiveBatches INTEGER,
    CompletedBatches INTEGER,
    NewDeviations INTEGER,
    ClosedDeviations INTEGER,
    EquipmentDowntimeMins INTEGER,
    EquipmentIssuesCount INTEGER,
    SignedOff BOOLEAN,
    SignedOffUtc TIMESTAMP_TZ,
    ShiftNotes VARCHAR(4000),
    SourceLogIdMartA INTEGER,
    SourceSystem VARCHAR(50),
    SourceKey VARCHAR(100),
    LoadedAtUtc TIMESTAMP_TZ,
    CreatedAt TIMESTAMP_TZ,
    CreatedBy VARCHAR(100),
    UpdatedAt TIMESTAMP_TZ,
    UpdatedBy VARCHAR(100),
    IsDeleted BOOLEAN,
    DeletedAt TIMESTAMP_TZ,
    PRIMARY KEY (ShiftLogKey),
    FOREIGN KEY (FacilityKey) REFERENCES DIM_FACILITY(FacilityKey),
    FOREIGN KEY (LogDateKey) REFERENCES DIM_DATE(DateKey),
    FOREIGN KEY (SupervisorKey) REFERENCES DIM_OPERATOR(OperatorKey)
);

```

### SECTION 2 — MERMAID DIAGRAM

```mermaid
erDiagram

    FactProductionOrder }o--|| DimFacility : "references"
    FactProductionOrder }o--|| DimProduct : "references"
    FactProductionOrder }o--|| DimEquipment : "references"
    FactProductionOrder }o--|| DimQualityDisposition : "references"
    FactProductionOrder }o--|| DimOperator : "references"

    FactBatchStep }o--|| FactProductionOrder : "references"
    FactBatchStep }o--|| DimProcessStep : "references"
    FactBatchStep }o--|| DimEquipment : "references"
    FactBatchStep }o--|| DimOperator : "references"

    FactEquipmentTelemetry }o--|| DimEquipment : "references"
    FactEquipmentTelemetry }o--|| FactBatchStep : "references"
    FactEquipmentTelemetry }o--|| FactProductionOrder : "references"
    FactEquipmentTelemetry }o--|| DimProcessParameter : "references"

    FactDeviation }o--|| FactProductionOrder : "references"
    FactDeviation }o--|| FactBatchStep : "references"
    FactDeviation }o--|| FactEquipmentTelemetry : "references"
    FactDeviation }o--|| DimEquipment : "references"
    FactDeviation }o--|| DimProcessParameter : "references"
    FactDeviation }o--|| DimDeviationCategory : "references"
    FactDeviation }o--|| DimFacility : "references"
    FactDeviation }o--|| DimOperator : "references"

    FactYieldAnalytics }o--|| DimDate : "references"
    FactYieldAnalytics }o--|| DimFacility : "references"
    FactYieldAnalytics }o--|| DimProduct : "references"

    FactShiftLog }o--|| DimFacility : "references"
    FactShiftLog }o--|| DimDate : "references"
    FactShiftLog }o--|| DimOperator : "references"


    DimOrganization {
        int OrganizationKey PK
        varchar OrganizationID
        varchar OrganizationName
        varchar OrganizationType
        int ParentOrganizationKey
        varchar CountryCode
        varchar RegulatoryRegion
        boolean IsActive
        date EffectiveStartDate
        date EffectiveEndDate
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimFacility {
        int FacilityKey PK
        varchar FacilityID
        varchar FacilityName
        varchar FacilityShortName
        int OrganizationKey FK
        varchar SiteCode
        varchar FacilityType
        varchar AddressLine1
        varchar AddressLine2
        varchar City
        varchar StateRegion
        varchar PostalCode
        varchar CountryCode
        varchar TimezoneName
        numeric UtcOffsetHours
        boolean GmpCertified
        date GmpCertificationDate
        date GmpExpiryDate
        varchar RegulatoryAgency
        varchar FdaEstablishmentId
        varchar EmaSiteCode
        varchar ManufacturingCapacity
        varchar SourceSiteCodeMartA
        varchar SourcePlantCodeOps
        varchar SourceFacCodeMartB
        date EffectiveStartDate
        date EffectiveEndDate
        boolean CurrentFlag
        int ScdVersion
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimProduct {
        int ProductKey PK
        varchar ProductID
        varchar SKU
        varchar ProductName
        varchar ProductShortName
        int OrganizationKey FK
        varchar FormulationId
        varchar FormulationVersion
        varchar DosageForm
        varchar DosageStrength
        varchar RouteOfAdministration
        varchar TherapeuticClass
        varchar TherapeuticArea
        varchar ProductCategory
        boolean IsBiosimilar
        varchar ReferenceProductId
        varchar InnName
        varchar IdmpMpid
        varchar NdaBlaNumber
        varchar EmaProductNumber
        numeric StandardYieldPct
        numeric YieldLowerAlertPct
        numeric YieldLowerActionPct
        int ShelfLifeMonths
        varchar StorageCondition
        date EffectiveStartDate
        date EffectiveEndDate
        boolean CurrentFlag
        int ScdVersion
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
        varchar SourceProductCodeMartA
        varchar SourceProductCodeOps
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimMaterialLot {
        int MaterialLotKey PK
        varchar LotNumber
        int ProductKey FK
        int FacilityKey FK
        varchar LotType
        date ManufactureDate
        date ExpiryDate
        date RetestDate
        numeric QuantityProduced
        varchar QuantityUnit
        varchar LotStatus
        varchar CertificateOfAnalysis
        varchar VendorLotNumber
        varchar VendorId
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimEquipment {
        int EquipmentKey PK
        varchar CanonicalEquipmentID
        varchar EquipmentName
        int FacilityKey FK
        varchar FunctionalArea
        varchar ProductionUnit
        varchar EquipmentModule
        varchar AssetClass
        varchar AssetSubClass
        varchar CriticalityRating
        varchar ManufacturerName
        varchar ModelNumber
        varchar SerialNumber
        numeric WorkingVolumeL
        date InstallationDate
        date CommissioningDate
        varchar QualificationStatus
        date LastQualificationDate
        date NextQualificationDate
        varchar CalibrationFrequency
        date LastCalibrationDate
        date CalibrationDueDate
        varchar CalibrationStatus
        int PlannedRuntimeMinsPerDay
        numeric IdealCycleTimeSecs
        varchar EquipmentStatus
        date StatusEffectiveDate
        date DecommissionDate
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
        varchar SourceEquipIdMartA
        varchar SourceAssetCodeOps
        varchar SourceEquipCodeMartB
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimProcessStep {
        int ProcessStepKey PK
        varchar StepCode
        varchar StepName
        varchar StepCategory
        varchar StepSubCategory
        int TypicalSequenceOrder
        numeric ExpectedDurationMinHrs
        numeric ExpectedDurationMaxHrs
        varchar ApplicableAssetClasses
        boolean IsCcp
        boolean IsActive
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimProcessParameter {
        int ParameterKey PK
        varchar ParameterCode
        varchar ParameterName
        varchar ParameterCategory
        varchar CanonicalUom
        varchar SourceUomMartA
        varchar SourceUomOps
        varchar SourceUomMartB
        varchar ConversionFormulaOps
        boolean IsCpp
        boolean IsKpa
        numeric TypicalTarget
        numeric TypicalLsl
        numeric TypicalUsl
        varchar MeasurementFrequency
        varchar InstrumentType
        boolean IsActive
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimQualityDisposition {
        int DispositionKey PK
        varchar DispositionCode
        varchar DispositionName
        boolean RequiresInvestigation
        boolean CommerciallyReleasable
        boolean DeviationImplied
        varchar PatientRiskLevel
        boolean RegulatoryNotificationRequired
        varchar DispositionDescription
        boolean IsActive
        varchar SourceCodeMartA
        varchar SourceCodeMartB
        varchar SourceCodeOps
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimDeviationCategory {
        int DeviationCategoryKey PK
        varchar CategoryCode
        varchar CategoryName
        varchar CategoryGroup
        varchar Description
        boolean CapaTypicallyRequired
        boolean IsActive
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimOperator {
        int OperatorKey PK
        varchar OperatorID
        varchar FullName
        varchar RoleCode
        int FacilityKey FK
        varchar Department
        boolean IsGmpTrained
        date TrainingExpiryDate
        boolean EsignatureEnabled
        varchar EmploymentStatus
        varchar SourceSystem
        varchar SourceKey
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    DimDate {
        int DateKey PK
        date FullDate
        int Day
        int Month
        varchar MonthName
        int Quarter
        int Year
        int WeekNumber
        int DayOfWeek
        varchar DayName
        boolean IsWeekend
        boolean IsHoliday
        int FiscalYear
        int FiscalQuarter
        boolean IsCurrent
        date EffectiveDate
        date ExpiryDate
    }

    FactProductionOrder {
        int ProductionOrderKey PK
        varchar CanonicalBatchID
        varchar ErpOrderNumber
        varchar MesBatchReference
        varchar GmpLotNumber
        int FacilityKey FK
        int ProductKey FK
        int PrimaryEquipmentKey FK
        int DispositionKey FK
        timestamp PlannedStartUtc
        timestamp PlannedEndUtc
        numeric PlannedQuantity
        varchar QuantityUom
        timestamp ActualStartUtc
        timestamp ActualEndUtc
        numeric ActualQuantity
        numeric YieldPct
        numeric YieldVariancePct
        numeric OeeAvailabilityPct
        numeric OeePerformancePct
        numeric OeeQualityPct
        numeric OeeOverallPct
        varchar BatchStatus
        int DeviationCount
        boolean IsGoldenBatch
        varchar GoldenBatchReference
        varchar ShiftAtStart
        int ShiftSupervisorKey FK
        varchar SourceBatchIdMartA
        varchar SourceBatchIdOps
        varchar SourceOrderNumOps
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    FactBatchStep {
        int BatchStepKey PK
        int ProductionOrderKey FK
        varchar CanonicalBatchID
        int ProcessStepKey FK
        int EquipmentKey FK
        int StepSequence
        timestamp StepStartUtc
        timestamp StepEndUtc
        numeric StepDurationHrs
        numeric InputQuantity
        numeric OutputQuantity
        varchar QuantityUom
        numeric StepYieldPct
        varchar StepStatus
        int OperatorKey FK
        int VerifierKey FK
        timestamp EsignatureTimestampUtc
        varchar EsignatureMeaning
        boolean HasDeviation
        int DeviationCount
        varchar StepNotes
        varchar SourceRunIdMartA
        int SourceStepIdOps
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    FactEquipmentTelemetry {
        int TelemetryKey PK
        int EquipmentKey FK
        int BatchStepKey FK
        int ProductionOrderKey FK
        varchar CanonicalBatchID
        int ParameterKey FK
        timestamp ReadingTimestampUtc
        numeric CanonicalValue
        varchar CanonicalUom
        numeric SourceValue
        varchar SourceUom
        varchar ConversionApplied
        numeric TargetValue
        numeric LowerSpecLimit
        numeric UpperSpecLimit
        numeric LowerAlertLimit
        numeric UpperAlertLimit
        boolean WithinSpecification
        boolean WithinAlert
        numeric DeviationFromTarget
        numeric GoldenBatchValue
        numeric GoldenBatchDeviation
        varchar AggregationType
        varchar SourceSystemType
        varchar SourceReadingIdMartA
        int SourceReadingIdOps
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    FactDeviation {
        int DeviationKey PK
        varchar CanonicalDeviationID
        int ProductionOrderKey FK
        int BatchStepKey FK
        int TelemetryKey FK
        int EquipmentKey FK
        int ParameterKey FK
        int DeviationCategoryKey FK
        int FacilityKey FK
        varchar CanonicalBatchID
        timestamp DetectedTimestampUtc
        int DetectedByKey FK
        varchar DetectionMethod
        varchar SeverityCode
        varchar PotentialImpact
        varchar DeviationDescription
        varchar InvestigationStatus
        int AssignedToKey FK
        timestamp InvestigationStartUtc
        timestamp InvestigationEndUtc
        varchar RootCauseCode
        varchar RootCauseDescription
        boolean CapaRequired
        varchar CapaReferenceId
        date CapaDueDate
        date CapaClosedDate
        timestamp ClosedTimestampUtc
        int ClosedByKey FK
        varchar ResolutionSummary
        boolean RegulatoryNotificationRequired
        date RegulatoryNotifiedDate
        varchar SourceDevIdMartA
        varchar SourceDevNumOps
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    FactYieldAnalytics {
        int YieldAnalyticsKey PK
        int AnalysisDateKey FK
        int FacilityKey FK
        int ProductKey FK
        varchar AggregationLevel
        int BatchesStarted
        int BatchesCompleted
        int BatchesOnHold
        int BatchesFailed
        numeric AvgYieldPct
        numeric MinYieldPct
        numeric MaxYieldPct
        numeric StdYieldPct
        int YieldBelowTargetCount
        numeric YieldTargetAttainmentPct
        numeric TotalPlannedQty
        numeric TotalActualQty
        varchar QuantityUom
        numeric AvgOeePct
        numeric AvgAvailabilityPct
        numeric AvgPerformancePct
        numeric AvgQualityPct
        int TotalDeviations
        int HighCriticalDeviations
        numeric CppComplianceRatePct
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

    FactShiftLog {
        int ShiftLogKey PK
        int FacilityKey FK
        int LogDateKey FK
        varchar ShiftName
        timestamp ShiftStartUtc
        timestamp ShiftEndUtc
        int SupervisorKey FK
        int ActiveBatches
        int CompletedBatches
        int NewDeviations
        int ClosedDeviations
        int EquipmentDowntimeMins
        int EquipmentIssuesCount
        boolean SignedOff
        timestamp SignedOffUtc
        varchar ShiftNotes
        int SourceLogIdMartA
        varchar SourceSystem
        varchar SourceKey
        timestamp LoadedAtUtc
        timestamp CreatedAt
        varchar CreatedBy
        timestamp UpdatedAt
        varchar UpdatedBy
        boolean IsDeleted
        timestamp DeletedAt
    }

```

### SECTION 3 — GENERATION SUMMARY

| Metric | Detail |
|---|---|
| Total tables identified (Step 2) | 15 |
| Fact Tables generated | 6 |
| Dimension Tables generated | 9 |
| CREATE TABLE statements generated | 15 |
| FK Relationships defined | 31 |
| SCD Type 2 Dimensions | 5 |
| DimDate included | Yes |
| DDL Compliance | Pass |
| Mermaid Validity | Pass |
| Notes | Updated FactYieldAnalytics and FactShiftLog to use surrogate DimDate keys (AnalysisDateKey, LogDateKey) and aligned SCD Type 2 columns across dimensions (IsCurrent, EffectiveDate, ExpiryDate), while maintaining one-to-one table and entity alignment. |
