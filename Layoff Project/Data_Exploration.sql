-- Exploratory Data Analysis


SELECT * 
FROM layoffs_staging2;

SELECT * #MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) AS company_total_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY company_total_layoff DESC;

SELECT MIN(DATE), MAX(DATE)
FROM layoffs_staging2;


SELECT company, industry, SUM(total_laid_off) AS company_total_layoff
FROM layoffs_staging2
GROUP BY company, industry
ORDER BY company_total_layoff DESC;


SELECT YEAR(DATE), SUM(total_laid_off) AS company_total_layoff
FROM layoffs_staging2
GROUP BY YEAR(DATE)
ORDER BY YEAR(DATE)DESC;

SELECT SUBSTRING(DATE, 1, 7) AS year_mon, sum(total_laid_off) AS total_layoff
FROM layoffs_staging2
WHERE DATE IS NOT NULL
GROUP BY SUBSTRING(DATE, 1, 7)
ORDER BY year_mon ASC
;

WITH Rolling_total AS
(
SELECT SUBSTRING(DATE, 1, 7) AS MONTH, sum(total_laid_off) AS company_layoff_total
FROM layoffs_staging2
WHERE DATE IS NOT NULL
GROUP BY MONTH
ORDER BY MONTH ASC
)
SELECT MONTH, company_layoff_total,
SUM(company_layoff_total) OVER(ORDER BY MONTH) AS rolling_total
FROM Rolling_Total;


SELECT company, SUM(total_laid_off) AS company_layoff_total
FROM layoffs_staging2
GROUP BY company
ORDER BY company_layoff_total DESC;


SELECT company, EXTRACT(YEAR FROM DATE) AS year, SUM(total_laid_off) AS company_layoff_total
FROM layoffs_staging2
GROUP BY company, EXTRACT(YEAR FROM DATE)
ORDER BY company ASC, year;


WITH Company_year (company, layoff_year, company_layoff_total) AS
(
SELECT company, EXTRACT(YEAR FROM DATE) AS year, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, EXTRACT(YEAR FROM DATE)
ORDER BY company ASC, year
), Comany_Year_Rank AS
(
SELECT*, DENSE_RANK() OVER (PARTITION BY layoff_year ORDER BY company_layoff_total DESC) 
AS Ranking
FROM Company_year
WHERE layoff_year IS NOT NULL
)
SELECT *
FROM Comany_Year_Rank
WHERE Ranking <= 5;





