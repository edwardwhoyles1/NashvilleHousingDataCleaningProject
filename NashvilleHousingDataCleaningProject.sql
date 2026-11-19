SELECT *
FROM PortfolioProjects.dbo.NashvilleHousingData

-- standardizing date format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProjects.dbo.NashvilleHousingData

UPDATE NashvilleHousingData
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousingData
Add SaleDateConverted Date;

UPDATE NashvilleHousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- populating property address data

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousingData
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousingData a
JOIN PortfolioProjects.dbo.NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousingData a
JOIN PortfolioProjects.dbo.NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

-- breaking address into individual columns (address, city, state)

SELECT PropertyAddress
FROM PortfolioProjects.dbo.NashvilleHousingData
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address

FROM PortfolioProjects.dbo.NashvilleHousingData

ALTER TABLE NashvilleHousingData
Add PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 )

ALTER TABLE NashvilleHousingData
Add PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousingData

SELECT OwnerAddress
FROM PortfolioProjects.dbo.NashvilleHousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProjects.dbo.NashvilleHousingData


ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



ALTER TABLE NashvilleHousingData
Add OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousingData
Add OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- changing y and no to yes and no in the "sold as vacant" field

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldASVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProjects.dbo.NashvilleHousingData

UPDATE NashvilleHousingData 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldASVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


-- removing duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProjects.dbo.NashvilleHousingData
)

SELECT *
FROM RowNumCTE
WHERE ROW_NUM > 1
ORDER BY PropertyAddress

-- deleting unused columns

ALTER TABLE PortfolioProjects.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjects.dbo.NashvilleHousingData
DROP COLUMN SaleDate

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousingData