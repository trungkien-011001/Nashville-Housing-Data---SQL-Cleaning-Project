--/* Checking data */
SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData

--/* Standardize Date Format */
	
	--Convert Datatype of the SaleDate column
	SELECT ParcelID, SaleDateConverted, CAST(SaleDate AS DATE)
	FROM PortfolioProject.dbo.NashvilleHousingData
	
	--Add SaleDateConverted column into the table
	ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
	ADD SaleDateConverted DATE
	
	--Put the SaleDateConverted values into the created column
	UPDATE PortfolioProject.dbo.NashvilleHousingData
	SET SaleDateConverted = CAST(SaleDate AS DATE)


--/* Populate Property Address Data */
	
	--Checking data to find columns that are related to Property Address column
	SELECT *
	FROM PortfolioProject.dbo.NashvilleHousingData
	WHERE PropertyAddress IS NULL
	
	--Using Self-join to filter the information that related to the PropertyAddress column
	SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashvilleHousingData a
	JOIN PortfolioProject.dbo.NashvilleHousingData b
		ON a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL

	--Updating Null values in PropertyAddress column
	UPDATE a
	SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	FROM PortfolioProject.dbo.NashvilleHousingData a
	JOIN PortfolioProject.dbo.NashvilleHousingData b
		ON a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress IS NULL


--/* Breaking out Address into Individual Columns */
	--Breaking out the PropertyAddress column
		--Using Substring and Charindex functions to split the PropertyAddress into Address and City
		SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
				SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
		FROM PortfolioProject.dbo.NashvilleHousingData
	
		--Add new column for splited Address in the table
		ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
		ADD PropertyAddressSplited NVARCHAR(255)
	
		--Update values in the new column for splited Address in the table
		UPDATE PortfolioProject.dbo.NashvilleHousingData
		SET PropertyAddressSplited = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
	
		--Add new column for splited City in the table
		ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
		ADD PropertyCitySplited NVARCHAR(255)

		--Update values in the new column for splited City in the table
		UPDATE PortfolioProject.dbo.NashvilleHousingData
		SET PropertyCitySplited = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

	--Breaking out the OwnerAddress column
		--Using PARSENAME function to split out the OwnerAddress Column into Address, City and State
		SELECT OwnerAddress,
			PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
			PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
			PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
		FROM PortfolioProject.dbo.NashvilleHousingData
		WHERE OwnerAddress IS NOT NULL

		--Add new column for splited Owner's Address in the table
		ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
		ADD OwnerAddressSplited NVARCHAR(255)

		--Update values in the new column for splited Owner's Address in the table
		UPDATE PortfolioProject.dbo.NashvilleHousingData
		SET OwnerAddressSplited = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

		--Add new column for splited Owner's City in the table
		ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
		ADD OwnerCitySplited NVARCHAR(255)

		--Update values in the new column for splited Owner's City in the table
		UPDATE PortfolioProject.dbo.NashvilleHousingData
		SET OwnerCitySplited = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

		--Add new column for splited Owner's State in the table
		ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
		ADD OwnerStateSplited NVARCHAR(255)

		--Update values in the new column for splited Owner's State in the table
		UPDATE PortfolioProject.dbo.NashvilleHousingData
		SET OwnerStateSplited = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--/* Change Y and N to Yes and No in "Sold as Vacant" field */
	
	--Checking the counts of Yes/No and Y/N Values
	SELECT SoldAsVacant, COUNT(*)
	FROM PortfolioProject.dbo.NashvilleHousingData
	GROUP BY SoldAsVacant

	--Converting the Y/N values into Yes/No values by CASE function
	SELECT
		CASE WHEN SoldAsVacant = 'N' THEN 'No'
			 WHEN SoldAsVacant = 'Y' THEN 'Yes'
			 ELSE SoldAsVacant
		END
	FROM PortfolioProject.dbo.NashvilleHousingData

		--Updating converted values into the table
	UPDATE PortfolioProject.dbo.NashvilleHousingData
	SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'N' THEN 'No'
							 WHEN SoldAsVacant = 'Y' THEN 'Yes'
							 ELSE SoldAsVacant
						END


--/* Remove Duplicates */
WITH CTE AS(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 LegalReference,
					 LandValue,
					 BuildingValue,
					 TotalValue
		ORDER BY UniqueID) AS rn
FROM PortfolioProject.dbo.NashvilleHousingData)

DELETE FROM CTE
WHERE rn > 1


--Delete unused columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousingData
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate

--Checking the data one last time

SELECT *
FROM PortfolioProject.dbo.NashvilleHousingData