/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/


-- ############################################################################
--        Studiu de caz: Interogări SQL pentru baza de date `chinook`
-- ############################################################################
-- 		  SQL01: Filtrare simpla, regular expressions, structuri CASE
-- ############################################################################
-- ultima actualizare: 2023-05-23


-- Funcții/operatori/opțiuni SQL utilizate în acest script 

--  	`EXTRACT` (year, month, ...)
-- 		`CAST`
-- 		`SUBSTRING`
-- 		`REGEXP_REPLACE`
-- 		`LENGTH`
-- 		`CASE ... WHEN ...`
-- 		`LIKE`
-- 		`LENGTH`
-- 		`IS NULL`
-- 		`POSITION`
-- 		`SPLIT_PART`
-- 		`REPLACE`
-- 		`regexp_match`

-- `UPPER`, `LOWER`, ...
-- `NOT` ...
-- `IN` (lista de valori, nu sub-consultati)
-- `TO_DATE` ...
-- 	`SUBSTR`
-- `LEFT`, `RIGHT`, ...




-- ############################################################################
--                    În ce ani s-au înregistrat vânzări?
-- ############################################################################

-- aceasta comanda extrage toate zilele cu (macar) o factura
select distinct invoicedate
from invoice
order by invoicedate ;

-- diverse functii de lucru cu date si ore
select invoicedate, 
	extract (year from invoicedate) as an,
	extract (month from invoicedate) as luna,
	extract (day from invoicedate) as zi,
	extract (dow from invoicedate) as zi_sapt,
	extract (hour from invoicedate) as ora
from invoice
order by invoicedate ;


-- ce obtinem ruland aceasta interogare?
select current_timestamp
from invoice ;


-- 
-- prima notație pentru ordonare (specificarea expresiei de calcul a atributului de ordonare)
select distinct extract (year from invoicedate) as an
from invoice
order by extract (year from invoicedate) ;

-- a doua notație pentru ordonare (specificarea atributului (calculat) de ordonare)
select distinct extract (year from invoicedate) as an
from invoice
order by an ;

-- a treia notație pentru ordonare (specificarea poziției atributului de ordonare în rezultat)
select distinct extract (year from invoicedate) as an
from invoice
order by 1 ;

-- a patra varianta - bazată pe SUBSTRING:
-- știind că formatul datei este `2019-10-01`, păstrăm numai primele patru caractere din dată,
--    care reprezintă anul;
-- prin funcția `cast`, convertim datele calendaristice în șiruri de caractere și, în final,
--  exprimăm rezultatul (anul calendaristic) ca număr întreg
select distinct cast (SUBSTRING(cast (invoicedate as character(10)), 1, 4) as integer) as an
from invoice
order by 1


-- a cincea variantă - bazată pe `regular expression` (extrage primele patru cifre):
select distinct cast (SUBSTRING(cast (invoicedate as character(10)), '[0-9]{4}') as integer) as an
from invoice
order by 1


-- a șasea variantă - bazată tot pe `regular expression`:
-- știind că formatul datei este `2019-10-01`, înlocuim toate caracterele, începând cu prima cratimă (`-`)
--   cu "nimic"; astfel, păstrăm numai primele patru caractere din dată, care reprezintă anul;
-- prin funcția `cast`, convertim datele calendaristice în șiruri de caractere și, în final,
--  exprimăm rezultatul (anul calendaristic) ca număr întreg
select distinct cast (REGEXP_REPLACE(cast (invoicedate as character(10)), '\-.*', '') as integer) as an
from invoice
order by 1





-- ############################################################################
--  Extrageți lunile calendaristice (și anii) în care s-au înregistrat vânzări
-- ############################################################################

-- prima variantă - folosind funcțiile `year` și `month`
select distinct 
	extract (year from invoicedate) as an,
	extract (month from invoicedate) as luna
from invoice
order by 1,2

-- a doua variantă - bazată pe SUBSTRING:
-- (știind că formatul datei este `2019-10-01`)
select distinct
	cast (SUBSTRING(cast (invoicedate as character(10)), 1, 4) as integer) as an,
	cast (SUBSTRING(cast (invoicedate as character(10)), 6, 2) as integer) as luna
from invoice
order by 1,2


---
-- a treia variantă - bazată SUBSTRING și pe `regular expression`:
-- anul este determinat folosind un șablon (pattern) care extrage primul grup de patru cifre ('[0-9]{4}')
-- luna este determinată folosind un șablon care extrage primul grup de două cifre care succede
--  unei cratime '\-([0-9]{2})'; `\` este un `escape character`
select distinct
	cast (SUBSTRING(cast (invoicedate as character(10)), '[0-9]{4}') as integer) as an,
	cast (SUBSTRING(cast (invoicedate as character(10)), '\-([0-9]{2})') as integer) as luna
from invoice
order by 1,2



-- ############################################################################
-- Care este lungimea numelui pentru fiecare artist/formatie?
-- ############################################################################

select artist.*, LENGTH(name) as lungime_nume
from artist


-- ############################################################################
--     Să se afișeze artiștii în ordinea descrescătoare a lungimii numelui
-- ############################################################################

select artist.*, LENGTH(name) as lungime_nume
from artist
order by LENGTH(name) desc

select artist.*, LENGTH(name) as lungime_nume
from artist
order by 3 desc



-- ############################################################################
-- Să se afișeze numele formatat al artiștilor, conform următoarei cerințe:
-- 1. pentru artiștii cu numele lung de până la 10 caractere,
--		se afișează numele întreg
-- 2. pentru artiștii cu numele mai lung de 10 caractere se extrag cinci
--   	caractere, se adaugă `...` la mijloc și se finalizează cu
-- 		ultimele cinci caractere

-- solutie 1 - bazata pe LEFT si RIGHT
select artist.*,
	case
		when length(name) <= 10 then name
		else left(name, 5) || '...' || right(name, 5)
	end as nume_formatat,
	length(name) as lungime_nume
from artist

-- solutie 2 - bazata pe SUBSTRING
select artist.*,
	case
		when length(name) <= 10 then name
		else substring(name, 1, 5) || '...' ||
			substring(name, length(name)-4, length(name))
		end as nume_formatat,
	length(name) as lungime_nume
from artist


-- solutie 3 - bazata pe regular expression (REGEXP_REPLACE)
-- sablonul este impartit pe trei sectiuni, care identifica:
-- 		`\1`: primele cinci caractere '(^.{5})'
-- 		`\2`: caracterele de la mijloc '(.+)'
-- 		`\3`: ultimele cinci caractere '(.{5}$)'
-- in sirul returnat se includ numai sectiunile \1 si \3, intre care se intercaleaza `...`
SELECT artist.*,
	REGEXP_REPLACE(name,'(^.{5})(.+)(.{5}$)','\1...\3') as nume_formatat,
	length(name) as lungime_nume
FROM artist




-- ############################################################################
-- Care sunt artiștii/formațiile cu numele alcătuit dintr-un singur cuvânt?
-- 					(adică numele lor nu conține niciun spațiu)
-- ############################################################################

-- solutie bazata pe operatorul `LIKE`
select *
from artist
where name not like '% %'

-- solutie bazata pe operatorii `LIKE` si CASE
select *
from artist
where case when name like '% %' then false else true end


-- solutie bazata pe operatorul `regexp_match` (regular expression)
SELECT *, regexp_match(name, ' ')
FROM artist
WHERE regexp_match(name, ' ') IS NULL


-- soluție cu POSITION
SELECT *
FROM artist
WHERE POSITION(' ' IN NAME) = 0

-- soluție cu SPLIT_PART
SELECT *,
	SPLIT_PART(name, ' ', 1) AS primul_cuvant,
	SPLIT_PART(name, ' ', 2) AS al_doilea_cuvant
FROM artist
WHERE SPLIT_PART(name, ' ', 2) = ''

-- prima soluție cu REPLACE
SELECT *, REPLACE(name, ' ', '') AS nume_fara_spatii
FROM artist
WHERE name = REPLACE(name, ' ', '')

-- a doua soluție cu REPLACE
SELECT *, REPLACE(name, ' ', '') AS nume_fara_spatii,
	LENGTH(name), LENGTH(REPLACE(name, ' ', ''))
FROM artist
WHERE LENGTH(name) = LENGTH(REPLACE(name, ' ', ''))



-- ############################################################################
-- Care sunt artiștii/formatiile cu numele alcătuit din cel puțin
--       două cuvinte? (numele lor conține cel puțin un spațiu)
-- ############################################################################

-- solutie bazata pe operatorul `LIKE`
select *
from artist
where name like '% %'


-- solutie bazata pe operatorul `regexp_match` (regular expression)
SELECT *
FROM artist
WHERE regexp_match(name, ' ') IS NOT NULL


-- soluție cu POSITION
SELECT *, POSITION(' ' IN NAME)
FROM artist
WHERE POSITION(' ' IN NAME) > 0

-- soluție cu SPLIT_PART
SELECT *,
	SPLIT_PART(name, ' ', 1) AS primul_cuvant,
	SPLIT_PART(name, ' ', 2) AS al_doilea_cuvant
FROM artist
WHERE SPLIT_PART(name, ' ', 2) <> ''

-- soluție cu REPLACE
SELECT *, REPLACE(name, ' ', '') AS nume_fara_spatii,
	LENGTH(name), LENGTH(REPLACE(name, ' ', ''))
FROM artist
WHERE LENGTH(name) - LENGTH(REPLACE(name, ' ', '')) > 0



-- ############################################################################
-- Care sunt artiștii/formațiile cu numele alcătuit din exact două cuvinte?
--         (adică numele lor conține un singur spațiu)
-- ############################################################################

-- solutie bazata pe operatorul `LIKE`
select *
from artist
where name like '% %' and name not like '% % %'


-- solutie bazata pe operatorul `regexp_match` (regular expression)
SELECT *
FROM artist
WHERE
	regexp_match(name, '.* .*') IS NOT NULL -- name contains at least a space
	AND
	regexp_match(name, '.* .* .*') IS NULL  -- name DOES NOT contain two spaces


-- soluție cu SPLIT_PART
SELECT *,
	SPLIT_PART(name, ' ', 1) AS primul_cuvant,
	SPLIT_PART(name, ' ', 2) AS al_doilea_cuvant,
	SPLIT_PART(name, ' ', 3) AS al_treilea_cuvant
FROM artist
WHERE SPLIT_PART(name, ' ', 2) <> '' and SPLIT_PART(name, ' ', 3) = ''

-- soluție cu REPLACE
SELECT *, REPLACE(name, ' ', '') AS nume_fara_spatii,
	LENGTH(name), LENGTH(REPLACE(name, ' ', ''))
FROM artist
WHERE LENGTH(name) - LENGTH(REPLACE(name, ' ', '')) = 1



-- ############################################################################
--            Care sunt primii trei ani s-au inregistrat vanzari?
-- ############################################################################

-- prima notatie pentru ordonare (specificarea expresiei de calcul a atributului de ordonare)
select distinct extract (year from invoicedate) as an
from invoice
order by extract (year from invoicedate)
limit 3




-- ############################################################################
--                Probleme de rezolvat la curs/laborator/acasa
-- ############################################################################


-- ############################################################################
-- Extrageti numele de utilizator de pe contul de e-mail al fiecarui angajat
-- ############################################################################


-- ############################################################################
-- Extrageti toate serverele de e-mail  (ex. `gmail.com`) ale clientilor
-- ############################################################################



-- ############################################################################
--              La ce întrebări răspund următoarele interogări ?
-- ############################################################################


select current_date ;


select current_date from playlist;


select * from track where name like 'Custard%' ;



select * from artist where upper(name) like 'AC%'


select lastname, firstname, birthdate, age(current_date, birthdate) as age
from employee ;

select e.lastname, e.firstname, birthdate, age(current_date, birthdate) as age
from employee e ;
