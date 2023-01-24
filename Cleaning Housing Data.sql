select *
from PortfolioProject.dbo.NashvilleHousing

--Standardize date format

Select SaleDateConverted, convert(date,SaleDate) 
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set SaleDate=convert(date,SaleDate) 

Alter Table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
Set SaleDateConverted=convert(date,SaleDate) 



--Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL

update a
Set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL

--Breaking out address into individual columns (address, city, state)

Select*-- PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

Select 
Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
Set PropertySplitAddress=Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
Set PropertySplitCity=Substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))



Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


Select 
Parsename (replace (OwnerAddress,',','.'),1),
Parsename (replace (OwnerAddress,',','.'),2),
Parsename (replace (OwnerAddress,',','.'),3)
from PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
Set OwnerSplitAddress=Parsename (replace (OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
Set OwnerSplitCity=Parsename (replace (OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
Set OwnerSplitState=Parsename (replace (OwnerAddress,',','.'),1)


Select *
from PortfolioProject.dbo.NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" Field


Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by (SoldAsVacant)
Order by 2


Select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
 when SoldAsVacant='N' then 'No'
 else SoldAsVacant
 end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
 when SoldAsVacant='N' then 'No'
 else SoldAsVacant
 end


 --Remove Duplicates

 with RowNumCTE AS( 
 Select *,
 row_number() over (
 partition by ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference
 order by uniqueID) row_num

from PortfolioProject.dbo.NashvilleHousing
 --order by ParcelID
 )
Select *
 From RowNumCTE
 where row_num >1
 --order by PropertyAddress

 --Delete Unused Columns

 
Select *
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate