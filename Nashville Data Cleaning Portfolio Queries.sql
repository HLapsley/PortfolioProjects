/*
Cleaning Data in SQL Queries
*/


Select *
From Portfolioproject1.dbo.Nashville

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Portfolioproject1.dbo.Nashville

ALTER TABLE Nashville
Add SaleDateConverted Date;

Update Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)

-------------------------------------------------------------------------------------------------------------------------

--- Populate Property Address data

Select *
From Portfolioproject1.dbo.Nashville
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject1.dbo.Nashville a
JOIN PortfolioProject1.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject1.dbo.Nashville a
JOIN PortfolioProject1.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject1.dbo.Nashville


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject1.dbo.Nashville


ALTER TABLE Nashville
Add PropertySplitAddress Nvarchar(255);

Update Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255);

Update Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select *
From PortfolioProject1.dbo.Nashville





Select OwnerAddress
From PortfolioProject1.dbo.Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as State
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as Address
From PortfolioProject1.dbo.Nashville


ALTER TABLE Nashville
Add OwnerSplitAddress Nvarchar(255);

Update Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville
Add OwnerSplitCity Nvarchar(255);

Update Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville
Add OwnerSplitState Nvarchar(255);

Update Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject1.dbo.Nashville


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject1.dbo.Nashville
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject1.dbo.Nashville


Update Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	   
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject1.dbo.Nashville
)
--Delete
Select *
From RowNumCTE
Where row_num > 1


Select *
From PortfolioProject1.dbo.Nashville


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject1.dbo.Nashville


ALTER TABLE PortfolioProject1.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


