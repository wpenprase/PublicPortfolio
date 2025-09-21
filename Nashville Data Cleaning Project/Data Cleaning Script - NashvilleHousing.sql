



-- Cleaning Data in SQL Queries

SELECT * 
FROM Portfolio_Project.dbo.NashvilleHousing;


SELECT SaleDate, CONVERT(Date, SaleDate) AS SaleDate
FROM Portfolio_Project.dbo.NashvilleHousing;

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);


--ALTER TABLE NashvilleHousing
--ADD SaleDateCoverted Date;


--------------Populate Property Address Data----------------

SELECT * 
FROM Portfolio_Project.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;


SELECT 
	a.ParcelID, 
	a.ParcelID, 
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress) 
	AS PropertiesWithNulls
FROM Portfolio_Project.dbo.NashvilleHousing AS a
	JOIN Portfolio_Project.dbo.NashvilleHousing AS b
		ON a.ParcelID = b.ParcelID
		AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM Portfolio_Project.dbo.NashvilleHousing AS a
JOIN Portfolio_Project.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;


 ---------------- Breaking out adress into individual columns (Address. City, State)--------

 SELECT PropertyAddress
 FROM Portfolio_Project.dbo.NashvilleHousing
 --WHERE PropertyAddress IS NULL
--ORDER BY ParcelID;


 SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS StreetAddress,
	--SUBSTRING(PropertyAddress, 1, CHARINDEX(' ', PropertyAddress) -1) AS NumAddress,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
 FROM Portfolio_Project.dbo.NashvilleHousing



ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD StreetAddress VARCHAR(100);

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET StreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD City VARCHAR(100);

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing;

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Portfolio_Project.DBO.NashvilleHousing;


ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerStreetAddress VARCHAR(100);

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerState VARCHAR(100);

ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ADD OwnerCity VARCHAR(100);

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing;

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolio_Project.dbo.NashvilleHousing
GROUP BY SoldAsVacant



SELECT 
SoldAsVacant,
CASE WHEN SoldAsVacant = 0 THEN 'No'
	 WHEN SoldAsVacant = 1 THEN 'Yes'
END
FROM Portfolio_Project.dbo.NashvilleHousing;



ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(5);

UPDATE Portfolio_Project.dbo.NashvilleHousing
SET SoldAsVacant = 
	CASE 
		WHEN SoldAsVacant = 0 THEN 'No'
		WHEN SoldAsVacant = 1 THEN 'Yes'
	END
	


SELECT SoldAsVacant
FROM Portfolio_Project.dbo.NashvilleHousing;



--------- Remove Duplicates --------

WITH RuwNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference 
				ORDER BY
					UniqueID
					) AS row_num
FROM Portfolio_Project.dbo.NashvilleHousing
)
SELECT * --DELETE
FROM RuwNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress;


SELECT *
FROM Portfolio_Project.dbo.NashvilleHousing


ALTER TABLE Portfolio_Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

