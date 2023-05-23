/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/


-- ############################################################################
--        Studiu de caz: Interogări SQL pentru baza de date `chinook`
-- ############################################################################
-- 					SQL04: Tratamentul (meta)valorilor NULL
-- ############################################################################
-- ultima actualizare: 2023-05-23


-- ############################################################################
--                                     IS NULL
-- ############################################################################

-- ############################################################################
--             Care sunt clienții individuali (non-companii)
-- ############################################################################

SELECT *
FROM customer
WHERE company IS NULL


--############################################################################
--##               Care sunt clienții care reprezintă companii
-- ############################################################################

SELECT *
FROM customer
WHERE company IS NOT NULL



-- ############################################################################
--       Care sunt piesele de pe albumele formației `Black Sabbath`
--                   cărora nu li se cunoaște compozitorul
-- ############################################################################

SELECT *
FROM artist
	INNER JOIN album ON artist.artistid = album.artistid
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Black Sabbath' AND composer is null



-- ############################################################################
-- Să se afișeze, sub formă de șir de caractere, orașele din care provin
-- clienții (pentru a elimina confuziile, numele orașului trebuie concatenat
-- cu statul și tara din care face parte orașul respectiv)
-- ############################################################################

-- solutie eronata !!!! De ce?
SELECT DISTINCT city || ' - ' || state || ' - ' || country
FROM customer

-- comparati cu...
SELECT DISTINCT city, state, country
FROM customer



-- ############################################################################
--                                COALESCE
-- ############################################################################

-- ############################################################################
-- Afișați clienții în ordinea țărilor; pentru cei din țări non-federative,
--   la atributul `state`, în locul valorii NULL, afișati `-`
-- ############################################################################

SELECT customerid, firstname, lastname, state, COALESCE(state, '-') as state2
FROM customer


-- ############################################################################
-- Să se afișeze, în ordine alfabetică, toate titlurile pieselor de pe
-- albumele formației `Black Sabbath`, împreuna cu autorii (compozitorii) lor;
-- acolo unde compozitorul nu este specificat (NULL), să se afișeze
-- `COMPOZITOR NECUNOSCUT`
-- ############################################################################

-- solutie cu CASE
SELECT track.name,
	CASE WHEN composer IS NULL THEN 'COMPOZITOR NECUNOSCUT'
		ELSE composer END AS compozitor
FROM artist
	INNER JOIN album ON artist.artistid = album.artistid
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Black Sabbath'
ORDER BY 1


-- solutie  ce foloseste COALESCE()
SELECT track.name, COALESCE(composer, 'COMPOZITOR NECUNOSCUT') AS compozitor
FROM artist
	INNER JOIN album ON artist.artistid = album.artistid
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Black Sabbath'
ORDER BY 1




-- ############################################################################
--                Probleme de rezolvat la curs/laborator/acasa
-- ############################################################################


-- ############################################################################
-- Sa se afiseze, sub forma de sir de caractere, orasele din care provin
-- clientii (pentru a elimina confuziile, numele orasului trebuie concatenat
-- cu statul si tara din care face parte orasul respectiv)



-- ############################################################################
-- Afisati toate facturile (tabela `invoice), completand eventualele valori NULL
--   ale atributului `billingstate` cu valoarea tributului `billing city` de pe
--   aceeasi linie




-- ############################################################################
--              La ce întrebări răspund următoarele interogări ?
-- ############################################################################

-- A.
SELECT firstname, lastname, city,
	COALESCE(state, country) AS state,
	country
FROM customer



-- B.
SELECT COUNT(city || ' - ' || state || ' - ' || country) AS n_of_cities
FROM customer


-- C.
SELECT COUNT(city || ' - ' || coalesce(state, '-') || ' - ' || country) AS n_of_cities
FROM customer
ORDER BY 1




-- ############################################################################
--          Explicati diferenta numarului de linii din rezultat pentru
--                 urmatoarele doua perechi de interogari
-- ############################################################################

-- A.

SELECT city || ' - ' || state || ' - ' || country AS city_string
FROM customer
ORDER BY 1
-- 59 randuri

SELECT city || ' - ' || coalesce(state, '-') || ' - ' || country AS city_string2
FROM customer
ORDER BY 1
-- 59 randuri


-- B.

SELECT DISTINCT city || ' - ' || state || ' - ' || country AS city_string
FROM customer
ORDER BY 1
-- 29 randuri

SELECT DISTINCT city || ' - ' || coalesce(state, '-') || ' - ' || country AS city_string2
FROM customer
-- 53 randuri
