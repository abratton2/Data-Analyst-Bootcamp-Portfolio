SELECT * 
From Portfolio.dbo.[Nashville Housing]

-- Standardize Date Format


SELECT SaleDate, CONVERT(Date,SaleDate)
FROM Portfolio.dbo.[Nashville Housing]

UPDATE [Nashville Housing]
SET SaleDate = CONVERT(DATE, SaleDate)


-- Populate Property Address data
SELECT *
From Portfolio.dbo.[Nashville Housing]
WHERE PropertyAddress is null

SELECT *
From Portfolio.dbo.[Nashville Housing]
--WHERE PropertyAddress is null
ORDER BY ParcelID

--Fill in null addresses that have matching parcellID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.[Nashville Housing] A
JOIN Portfolio.dbo.[Nashville Housing] B 
	ON A.ParcelID = B.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL

--set property addresses
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.[Nashville Housing] A
JOIN Portfolio.dbo.[Nashville Housing] B 
	ON A.ParcelID = B.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL

--Breaking out Address into Individual Columns
SELECT PropertyAddress
From Portfolio.dbo.[Nashville Housing]


--Get street Address
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM Portfolio.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD PropertyStreetAddress varchar(255);

ALTER TABLE [Nashville Housing]
ADD PropertyCity varchar(255);

UPDATE [Nashville Housing]
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)

UPDATE [Nashville Housing]
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT PropertyStreetAddress, PropertyCity
From Portfolio.dbo.[Nashville Housing]


--Owner Address

SELECT OwnerAddress
FROM Portfolio.dbo.[Nashville Housing]


SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) AS State
FROM Portfolio.dbo.[Nashville Housing]

ALTER TABLE [Nashville Housing]
ADD OwnerStreetAddress varchar(255),
 OwnerCity varchar(255),
 OwnerState varchar(255);

UPDATE [Nashville Housing]
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
	OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
	OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT OwnerStreetAddress, OwnerCity, OwnerState
FROM [Nashville Housing]

-- Remove Duplicates
--WITH RowNumCTE AS (
--SELECT * ,
--	ROW_NUMBER() OVER ( 
--	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) rowNum
--FROM [Nashville Housing]
-- )
--SELECT *
--FROM RowNumCTE
--WHERE rowNum > 1


-- DELETE Unused Columns

ALTER TABLE [Nashville Housing]
DROP COLUMN  OwnerAddress, TaxDistrict, PropertyAddress,SaleDate

SELECT * FROM [Nashville Housing]
