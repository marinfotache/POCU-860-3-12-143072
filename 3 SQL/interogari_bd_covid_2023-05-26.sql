
/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- Interogari SQL pentru baza de date COVID. Sintaxa PostgreSQL

SELECT *
FROM country_gen_info ;


-----------------------------------------------------------------------------------
-- 		1. Care sunt regiunile geografice (din tabela country_gen_info)
-----------------------------------------------------------------------------------

SELECT DISTINCT region
FROM country_gen_info 
ORDER BY 1;


SELECT region
FROM country_gen_info 
GROUP BY region 
ORDER BY 1;



-----------------------------------------------------------------------------------
-- 		2. Pentru cate tari este disponibil PIB-ul pe cap de locuitor
-----------------------------------------------------------------------------------
SELECT COUNT(*) AS nr_tari
FROM country_gen_info INNER JOIN country__other_data ON country_code = country_code_iso3 ;
-- 186

-----------------------------------------------------------------------------------
-- 				3. In ce regiune geografica se afla Romania?
-----------------------------------------------------------------------------------

SELECT region
FROM country_gen_info
WHERE country_name = 'Romania';

-----------------------------------------------------------------------------------
-- 				4. In ce grupa de venit se afla Romania?
-----------------------------------------------------------------------------------

SELECT country_income_group
FROM country_gen_info
WHERE country_name = 'Romania';


-----------------------------------------------------------------------------------
-- 			5. Care este PIB-ul pe cap de locuitor in Romania?
-----------------------------------------------------------------------------------

SELECT gdp_per_capita
FROM country_gen_info i INNER JOIN country__other_data o ON i.country_code = o.country_code_iso3
WHERE i.country_name = 'Romania';

SELECT gdp_per_capita
FROM country_gen_info INNER JOIN country__other_data ON country_code = country_code_iso3
WHERE country_name = 'Romania';


-----------------------------------------------------------------------------------
-- 		6. Care sunt tarile din aceeasi regiune geografica cu Romania?
-----------------------------------------------------------------------------------

SELECT *
FROM country_gen_info
WHERE region IN (SELECT region FROM country_gen_info WHERE country_name = 'Romania' ) ;

SELECT region
FROM country_gen_info
WHERE country_name = 'Romania';

-----------------------------------------------------------------------------------
-- 			7. Care este pozitia Romaniei in clasamentul 
---     PIB-ului pe cap de locuitor, atat in regiunea noastra, cat si global?
-----------------------------------------------------------------------------------

WITH clasament AS (
	SELECT i.*, gdp_per_capita,
		RANK() OVER (PARTITION BY region ORDER BY gdp_per_capita DESC) AS poz_clasament_regiune,
		RANK() OVER (ORDER BY gdp_per_capita DESC) AS poz_clasament_global
	FROM country_gen_info i INNER JOIN country__other_data ON country_code = country_code_iso3
	)
SELECT *
FROM clasament 
WHERE country_name = 'Romania'
ORDER BY region, poz_clasament_regiune ;


-----------------------------------------------------------------------------------
-- 	8. Care este pozitia fiecarei tari in clasamentul PIB-ului pe cap de locuitor,
--  atat in regiunea tarii respective, cat si global?
-- Fata de problema anterioara, sa se afiseze si numarul de tari din regiune
-- si numarul total al tarilor
-----------------------------------------------------------------------------------

WITH 
regions_n_of_countries AS (
	SELECT region, COUNT(*) AS region_n_of_countries 
	FROM country_gen_info
	GROUP BY region
	),
worldwide_n_of_countries AS (
	SELECT COUNT(*) AS worldwide_n_of_countries 
	FROM country_gen_info
	),
ranking AS (
	SELECT i.*, gdp_per_capita,
		RANK() OVER (PARTITION BY i.region ORDER BY gdp_per_capita DESC) AS rank_region,
		regions_n_of_countries.region_n_of_countries,
		RANK() OVER (ORDER BY gdp_per_capita DESC) AS rank_worldwide,
		worldwide_n_of_countries
	FROM country_gen_info i 
		INNER JOIN country__other_data ON country_code = country_code_iso3
		INNER JOIN regions_n_of_countries ON i.region = regions_n_of_countries.region
		INNER JOIN worldwide_n_of_countries ON 1 = 1 
	)
SELECT *
FROM ranking 
ORDER BY region, rank_region ;

-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------



