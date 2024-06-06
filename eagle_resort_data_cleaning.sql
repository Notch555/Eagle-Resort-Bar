-- CREATING NEW DATABASE
create database eagle_resort;

-- DATA CLEANING
select *,
row_number() over(
partition by ï»¿DRINKS, OLD_STOCK, SUPPLY, TOTAL_OLDSTOCK, NEWSTOCK, sold, 
PURCHASEPRICE, TOTALAMOUNT_PP, SELLINGPRICE, PROFIT, `date`)
as row_num
from raw;

-- USING CTE FOR ADVANCE FILTER
with newd as(
select *,
row_number() over(
partition by ï»¿DRINKS, OLD_STOCK, SUPPLY, TOTAL_OLDSTOCK, NEWSTOCK, sold, 
PURCHASEPRICE, TOTALAMOUNT_PP, SELLINGPRICE, PROFIT, `date`)
as row_num
from raw
)
select *
from newd
where row_num > 1;

-- CREATING NEW TABLE FROM THE ORIGINAL TABLE
CREATE TABLE `raw1` (
  `ï»¿DRINKS` text,
  `OLD_STOCK` int DEFAULT NULL,
  `SUPPLY` int DEFAULT NULL,
  `TOTAL_OLDSTOCK` int DEFAULT NULL,
  `NEWSTOCK` int DEFAULT NULL,
  `SOLD` int DEFAULT NULL,
  `PURCHASEPRICE` int DEFAULT NULL,
  `TOTALAMOUNT_PP` int DEFAULT NULL,
  `SELLINGPRICE` int DEFAULT NULL,
  `TOTALAMOUNT_SP` int DEFAULT NULL,
  `PROFIT` int DEFAULT NULL,
  `DATE` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into raw1
select *,
row_number() over(
partition by ï»¿DRINKS, OLD_STOCK, SUPPLY, TOTAL_OLDSTOCK, NEWSTOCK, sold, 
PURCHASEPRICE, TOTALAMOUNT_PP, SELLINGPRICE, PROFIT, `date`)
as row_num
from raw;

-- DELETING DUPLICATE AND EMPTY CELLS
delete
from raw1
where row_num > 1; 

-- CHANGE COLUMN NAME
alter table raw1
change column ï»¿DRINKS DRINKS varchar(20); -- CHANGING COLUMN NAME


-- CORRECTING THE DATE DATA TYPE AND CONSISTENCY.
update raw1
set `date` = case
when `date` like '%/%' THEN date_format(str_to_date(`date`, '%m/%d/%Y'), '%Y-%m-%d')
else null
end;

alter table raw1
modify column `date` date;

-- CORRECTING SPELLING IN A TEXT COLUMN
update raw1
set drinks = 'Big Ice'
where drinks like 'B/Ice%';

update raw1
set drinks = 'Budweiser'
Where drinks like 'Burdwieser%';

update raw1
set drinks = 'Desperado'
where drinks like 'Despirado%' or drinks like 'Desperados%';

update raw1
set drinks = 'Star'
where drinks like 'Star%' or drinks like 'STAR%';

update raw1
set drinks = 'Goldberg Black'
where drinks like 'G/BLACK%' or drinks like 'Goldberg/Black%';

-- CHANGE THE DATA IN THE DRINKS COLUMN TO UPPERCASE
update raw1
set drinks = upper(Drinks);

-- DELETING ROWS AND COLUMNS WITH ZERO
delete 
from raw1
where profit = 0;

-- CREATE A COLUMN TO INDENTIFY THE PARTICULAR DAY OF SALES
alter table raw1
add column dayname varchar(20);

update raw1
set dayname = dayname(`date`);

alter table raw1
add column monthname varchar(20);

update raw1
set monthname = monthname(`date`)


