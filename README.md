# Telecom ETL Pipeline: Raw Batch Processing & Error Redirection

## 📋 Project Overview
This repository contains an end-to-end ETL (Extract, Transform, Load) solution designed to process bulk telecom transaction data. The pipeline automates the ingestion of raw CSV batches into a SQL Server Star Schema, ensuring data integrity through complex lookups and custom validation logic.

## 🏗️ Architecture
The pipeline follows a robust logic flow to ensure that only "clean" data reaching the production fact table:
1. **Extraction:** High-speed ingestion from Flat File Sources.
2. **Transformation:** - **Data Cleansing:** Handling regional date formats (`DD/MM/YYYY`) using specific locale parsing.
   - **Business Logic:** Decomposing 14-digit IMEI numbers into `TAC` and `SNR` via Derived Columns and Data Conversions.
   - **Reference Lookup:** Performing memory-efficient lookups against `dim_imsi_reference` to associate transactions with subscribers.
3. **Loading:** - **Fact Load:** Validated data is pushed to `fact_transaction`.
   - **Error Redirection:** Any row failing date conversion or containing nulls is redirected via a **Union All** transformation into a dedicated `error_destination_output` table for auditing.

## 🛠️ Tech Stack
- **ETL Tool:** SQL Server Integration Services (SSIS)
- **Database:** Microsoft SQL Server (T-SQL)
- **Data Modeling:** Star Schema (Fact & Dimension tables)

## 🚀 Key Engineering Challenges Solved
- **Metadata Lineage Management:** Successfully resolved `HRESULT 0xC0204006` errors by performing a surgical refresh of the Union All metadata when source data types shifted from Strings to Integers.
- **Identity Constraint Alignment:** Configured the OLE DB Destination to handle manual `transaction_id` mapping while allowing SQL Server to manage the primary `identity` key, preventing `NULL` insertion failures.
- **Fail-Safe Processing:** Configured Error Output Redirection on conversion components to ensure the entire batch doesn't fail due to a single malformed date string.

## 📂 Repository Structure
- **/SQL:** Contains T-SQL scripts for database initialization, schema creation, and dimension seeding.
- **/telecom_project:** The SSIS project files (`.dtproj`, `.dtsx`) containing the package logic.
- **/images:** Screenshots of the ETL Data Flow.

## 📖 How to Deploy
1. Run the script in `/SQL/SSIS_Telecom_DB_Setup.sql` to initialize the database.
2. Open the solution in Visual Studio with SQL Server Data Tools (SSDT) installed.
3. Update the **Connection Managers** to point to your local SQL instance.
4. Execute the package to process the source CSV.

---
*Developed as part of the Digital Egypt Pioneers Initiative (DEPI) - AI and Data Engineering Track.*
