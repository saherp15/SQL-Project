/* CLEANING DATA IN SQL QUERIES */
select * from [Pro1 Nahwille].dbo.NashvilleHousing

--Standardize Date format
select SaleDate,CONVERT(Date,SaleDate) as Converted_Date
from [Pro1 Nahwille].dbo.NashvilleHousing

Update [Pro1 Nahwille].dbo.NashvilleHousing
SET SaleDate =CONVERT(Date,SaleDate)
Alter table [Pro1 Nahwille].dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [Pro1 Nahwille].dbo.NashvilleHousing
Set SaleDateConverted =CONVERT(Date,SaleDate)

--Populate Property address data
select *
from [Pro1 Nahwille].dbo.NashvilleHousing
where PropertyAddress is NULL
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,
b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Pro1 Nahwille].dbo.NashvilleHousing as a
join [Pro1 Nahwille].dbo.NashvilleHousing as b on
a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is NULL

Update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Pro1 Nahwille].dbo.NashvilleHousing as a
join [Pro1 Nahwille].dbo.NashvilleHousing as b on
a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is NULL
----END--

-------Breaking out address into columns (address,city,state)
select PropertyAddress
from [Pro1 Nahwille].dbo.NashvilleHousing


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,Len(PropertyAddress)) as Address 
from [Pro1 Nahwille].dbo.NashvilleHousing

Alter table [Pro1 Nahwille].dbo.NashvilleHousing
Add PropertyySplitAddress Nvarchar(255);

Update [Pro1 Nahwille].dbo.NashvilleHousing
Set PropertyySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter table [Pro1 Nahwille].dbo.NashvilleHousing
Add PropertyySplitCity Nvarchar(255);

Update [Pro1 Nahwille].dbo.NashvilleHousing
Set PropertyySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

select * from [Pro1 Nahwille].dbo.NashvilleHousing





------
select OwnerAddress
from [Pro1 Nahwille].dbo.NashvilleHousing

select 
PARSENAME(REplace(OwnerAddress,',','.'),3)
,PARSENAME(REplace(OwnerAddress,',','.'),2)
,PARSENAME(REplace(OwnerAddress,',','.'),1)
from [Pro1 Nahwille].dbo.NashvilleHousing


Alter table [Pro1 Nahwille].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Pro1 Nahwille].dbo.NashvilleHousing
Set OwnerSplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter table [Pro1 Nahwille].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Pro1 Nahwille].dbo.NashvilleHousing
Set OwnerSplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))



select * 
from [Pro1 Nahwille].dbo.NashvilleHousing


--Change Y and N in "sold as vacant" field

select distinct(SoldAsVacant),Count(SoldAsVacant)
from [Pro1 Nahwille].dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
Case when SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' Then 'No'
else SoldAsVacant
end
from [Pro1 Nahwille].dbo.NashvilleHousing

Update [Pro1 Nahwille].dbo.NashvilleHousing
set SoldAsVacant= Case when SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' Then 'No'
else SoldAsVacant
end


-----Remove duplicates
with RowNumCTE AS(
select *,
ROW_NUMBER() over
(partition by ParcelID
,PropertyAddress,SalePrice,SaleDate
,LegalReference order by UniqueID)  as row_num
from [Pro1 Nahwille].dbo.NashvilleHousing
)
Select * from RowNumCTE
where row_num>1

------Delete unused column
select *
from [Pro1 Nahwille].dbo.NashvilleHousing

Alter Table [Pro1 Nahwille].dbo.NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress OwnerAddress,TaxDistrict,PropertyAddress,


Alter Table [Pro1 Nahwille].dbo.NashvilleHousing
Drop column SaleDate
