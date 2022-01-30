Select * 
From Projectportfolio.dbo.Nashvillehousing


--Standardize date format. Converted it into only Date.

Select SaleDateConverted, CONVERT (Date,SaleDate)
From Projectportfolio.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address Data

Select *
From Projectportfolio.dbo.Nashvillehousing
--Where PropertyAddress is not null
ORDER BY ParcelID


Select a.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projectportfolio.dbo.Nashvillehousing a
Join Projectportfolio.dbo.Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projectportfolio.dbo.Nashvillehousing a
Join Projectportfolio.dbo.Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, city, state)

Select PropertyAddress
From Projectportfolio.dbo.Nashvillehousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 
FROM Projectportfolio.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Nashvillehousing
Add PropertySplitCity NVARCHAR(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select * 
From Projectportfolio.dbo.Nashvillehousing


Select * 
From Projectportfolio.dbo.Nashvillehousing


Select OwnerAddress
From Projectportfolio.dbo.Nashvillehousing

Select PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
From Projectportfolio.dbo.Nashvillehousing

ALTER Table Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER Table Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER Table Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

SELECT *
FROM Projectportfolio.dbo.Nashvillehousing


--changing Y & N to Yes & No in Sold for Vacant fields

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projectportfolio.dbo.Nashvillehousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
			END
FROM Projectportfolio.dbo.Nashvillehousing


Update Nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldAsVacant
			END




--Remove Duplicates

With RowNumCTE As(
Select *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								ORDER BY
										UniqueID
										) row_num
FROM Projectportfolio.dbo.Nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num>1
Order by PropertyAddress

Select *
FROM Projectportfolio.dbo.Nashvillehousing


--Delete Unused Columns

Select * 
From Projectportfolio.dbo.Nashvillehousing

ALTER Table Projectportfolio.dbo.Nashvillehousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate