/*
--------------------------------------------------------------------------------
SSIS Telecom Project: Database & Schema Setup
Author: Ahmed Hassan
Description: This script creates the database and required tables for the 
             Telecom Data Engineering project, including Fact and Dimension tables.
--------------------------------------------------------------------------------
*/

-- 1. Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SSIS_Telecom_DB')
BEGIN
    CREATE DATABASE SSIS_Telecom_DB;
END
GO

USE SSIS_Telecom_DB;
GO

-- 2. Drop Tables if they exist (for clean re-runs)
IF OBJECT_ID('fact_transaction', 'U') IS NOT NULL DROP TABLE fact_transaction;
IF OBJECT_ID('dim_imsi_reference', 'U') IS NOT NULL DROP TABLE dim_imsi_reference;
IF OBJECT_ID('error_destination_output', 'U') IS NOT NULL DROP TABLE error_destination_output;
GO

-- 3. Create Dimension: IMSI Reference
CREATE TABLE dim_imsi_reference (
    id int IDENTITY(1,1) PRIMARY KEY,
    imsi varchar(9) NOT NULL,
    subscriber_id int NOT NULL
);
GO

-- 4. Create Fact: Transactions
CREATE TABLE fact_transaction (
    id int IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    transaction_id int NOT NULL,      -- Business Key from CSV
    imsi varchar(9) NOT NULL,
    subscriber_id int NULL,           -- Populated via Lookup
    tac varchar(8) NOT NULL,
    snr varchar(6) NOT NULL,
    imei varchar(14) NOT NULL,
    cell int NOT NULL,
    lac int NOT NULL,
    event_type varchar(1) NULL,
    event_ts datetime NOT NULL
);
GO

-- 5. Create Error Handling Table
CREATE TABLE error_destination_output (
    id int NULL,
    imsi varchar(9) NULL,
    imei varchar(14) NULL,
    cell int NULL,
    lac int NULL,
    event_type varchar(1) NULL,
    event_ts datetime NULL,           -- Allowed NULL for invalid date strings
    tac varchar(8) NULL,
    snr varchar(8) NULL,
    ErrorCode int NULL,
    ErrorColumn int NULL
);
GO

-- 6. Seed Dimension Data
INSERT INTO dim_imsi_reference (imsi, subscriber_id)
VALUES 
    ('919106573', 62306), ('835424796', 12831), ('222893094', 14084),
    ('461051324', 74624), ('720757084', 21855), ('236344683', 99383),
    -- ... [Rest of your 400+ values go here] ...
    ('310120265', 22904);
GO

-- 7. Verification Queries
SELECT 'Fact Table' as TableName, COUNT(*) as RowCount FROM fact_transaction
UNION ALL
SELECT 'Dimension Table', COUNT(*) FROM dim_imsi_reference
UNION ALL
SELECT 'Error Table', COUNT(*) FROM error_destination_output;