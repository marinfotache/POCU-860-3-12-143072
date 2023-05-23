/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- ############################################################################
--        Studiu de caz: Interogări SQL pentru baza de date `chinook`
-- ############################################################################
-- 					SQL05: Funcții agregat (count, count distinct, ...) fără grupare
-- ############################################################################
-- ultima actualizare: 2023-05-23


-- ############################################################################
--                    Câți artiști sunt în baza de date?
-- ############################################################################

SELECT COUNT(*) AS nr_artisti
FROM artist

-- sau
SELECT COUNT(artistid) AS nr_artisti
FROM artist


-- ############################################################################
--                 Cate piese sunt stocate în baza de date?
-- ############################################################################

-- solutie corecta
SELECT COUNT(*) AS nr_piese
FROM track

-- alta solutie corecta
SELECT COUNT(trackid) AS nr_piese
FROM track

-- solutie incorecta
SELECT COUNT(composer) AS nr_piese
FROM track


-- ############################################################################
-- 				                     Câți clienți au fax?
-- ############################################################################

-- sol. 1 (cu filtrarea inregistrarilor)
SELECT COUNT(*)
FROM customer
WHERE fax IS NOT NULL

-- sol. 2 (bazata pe COUNT valori nenule)
SELECT COUNT(fax)
FROM customer



-- ############################################################################
-- 				Pentru câți artiști există măcar un album în baza de date?
-- ############################################################################

-- solutie eronata!!!
SELECT COUNT(artistid)
FROM album

-- solutie corecta - COUNT DISTINCT
SELECT COUNT(DISTINCT artistid)
FROM album


-- ############################################################################
--                Din câte țări sunt clienții companiei?
-- ############################################################################

SELECT COUNT(DISTINCT country)
FROM customer



-- ############################################################################
--        Câte secunde are albumul `Achtung Baby` al formației `U2`?
-- ############################################################################

SELECT SUM(milliseconds) / 1000 AS duration_seconds
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'U2' AND title = 'Achtung Baby'



-- ############################################################################
--               Care este durata medie (în secunde) a pieselor
--               de pe albumul `Achtung Baby` al formației `U2`
-- ############################################################################

SELECT ROUND(AVG(milliseconds / 1000)) AS duration_seconds
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'U2' AND title = 'Achtung Baby'


-- ############################################################################
--           Care este durata medie a pieselor formației `U2`
-- ############################################################################

SELECT ROUND(AVG(milliseconds / 1000)) AS duration_seconds
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'U2'


-- ############################################################################
-- 			Care este durata medie a pieselor formației `Pink Floyd`,
--                     exprimată în minute și secunde
-- ############################################################################

SELECT ROUND(AVG(milliseconds / 1000)) * interval '1 sec' AS duration_mins_secs
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Pink Floyd'



-- ############################################################################
--                      În ce zi a fost prima vânzare?
-- ############################################################################

SELECT MIN(invoicedate) AS prima_zi
FROM invoice


-- solutie fara MIN
SELECT invoicedate AS prima_zi
FROM invoice
ORDER BY invoicedate
LIMIT 1



-- ############################################################################
--                       În ce dată a fost ultima vanzare?
-- ############################################################################

SELECT MAX(invoicedate) AS prima_zi
FROM invoice

-- solutie fara MAX
SELECT invoicedate AS prima_zi
FROM invoice
ORDER BY invoicedate DESC
LIMIT 1



-- ############################################################################
--                Probleme de rezolvat la curs/laborator/acasa
-- ############################################################################


--############################################################################
--##               Din cate orașe sunt clienții companiei?
--############################################################################

-- Care este data primei angajari in companie

-- Cate piese sunt pe playlistul `Grunge`?

-- Cati subordonati are, in total (pe toate nivelurile), angajatul xxxxxx?




-- ############################################################################
--              La ce întrebări răspund următoarele interogări ?
-- ############################################################################

select min(birthdate)
from employee ;


SELECT MAX(milliseconds / 60000) AS durata_max_lz
FROM artist
	INNER JOIN album ON artist.artistid = album.artistid
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Led Zeppelin'


SELECT *
FROM artist
	INNER JOIN album ON artist.artistid = album.artistid
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Led Zeppelin' and milliseconds / 60000 = 26
