-- Data Cleaning Project

SELECT *
FROM layoffs;
-- 1. Remove Duplicates (normalizing)
-- 2. Standarize the data
-- 3. Null values or blank values
-- 4. Remove columns if necessary

-- We imported our data via new schema
-- Creating our layoffs staging database to keep our raw data untouched

DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging
LIKE layoffs;

-- We inserted our data into new table
INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- This helps identify any redundant data in our database
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- This create a CTE to filter our our duplicate data
WITH duplicates_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, 
    total_laid_off, percentage_laid_off, `date`, 
    stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- This validates one of our field has duplicate data
SELECT *
FROM layoffs_staging
WHERE company = "Casper";
    
-- We are extracting our data, attemping to delete the duplicates, and then create a new table as layoffs_staging2
WITH duplicates_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY 
	company, location, industry, 
    total_laid_off, percentage_laid_off, `date`, 
    stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * -- DELETE -- This delete statement does not work.
FROM duplicates_cte
WHERE row_num > 1;

-- Create an empty table since we are not able to delete rows in our dataset
DROP TABLE IF EXISTS layoffs_staging2;
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT -- We are creating a new column to delete our duplicates
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- This identefies our duplicates where row_num is greater than 1
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- We are inserting our data into layoffs_staging2
INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, 
    total_laid_off, percentage_laid_off, `date`, 
    stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Deletes our duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Validates that we do not have any more dupicate rows.
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- standarlize the data
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- This identifies any blank, null, or inconsistent attributes
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Identifies anything starting with "Crypto" in industry 
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE "Crypto%";

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

-- Trim the period at the end of US
SELECT DISTINCT country, TRIM(TRAILING "." FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING "." FROM country)
WHERE country LIKE "United States%";

-- Validatation that we cleaned our country attribute
SELECT *
FROM layoffs_staging2
WHERE country LIKE "United States%";

-- Created a new coloumn and formats our date column as mmddYYY
SELECT `date`,
STR_TO_DATE(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

-- Updates our "date" column with reformatted values
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

-- Alters our table from TEXT to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Filters industry attributes where is NULL or ""
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = "";

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = "" ;

SELECT *
FROM layoffs_staging2
WHERE company LIKE "Bally%";    -- "Airbnb";

SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- We are finished repopulating data where values are blank or NULL. 
-- Now, we need to delete data that is not helpful
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- We no longer need row_num column so we can drop the column
SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Data is now cleaned and ready for data exploration

