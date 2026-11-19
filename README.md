# Nashville Housing Data Cleaning SQL Server

## Overview
A SQL project that cleans and standardizes a raw Nashville housing dataset so it is ready for analysis. All work is done in T-SQL using SQL Server.

## Tools
- SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)

## Cleaning Steps

| Step | Problem | Solution |
|------|---------|----------|
| 1. Standardize dates | `SaleDate` included a time component | Converted to a `Date` type with `CONVERT` and stored it in a new column |
| 2. Fill missing addresses | [X] null `PropertyAddress` values | Self-joined the table on `ParcelID` and filled gaps with `ISNULL` |
| 3. Split property address | Address and city stored in one column | Split into separate columns with `SUBSTRING` and `CHARINDEX` |
| 4. Split owner address | Address, city, and state in one column | Split into three columns with `PARSENAME` |
| 5. Standardize "Sold as Vacant" | Mix of `Y`, `N`, `Yes`, and `No` | Unified to `Yes`/`No` with a `CASE` statement |
| 6. Find duplicates | Repeated sale records | Flagged with `ROW_NUMBER()` in a CTE partitioned by key fields |
| 7. Drop unused columns | Original combined columns no longer needed | Removed with `ALTER TABLE ... DROP COLUMN` |

## Files
- `NashvilleHousingDataCleaningProject.sql`: full cleaning script
- `NashvilleHousingData.xlsx`: raw data
