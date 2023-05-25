/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- ############################################################################
--        Studiu de caz: Interogări SQL pentru baza de date `chinook`
-- ############################################################################
-- 					SQL11: Opțiuni OLAP
-- ############################################################################
-- ultima actualizare: 2023-05-25
--


-- ############################################################################
-- 		Știind că `trackid` respectă ordinea (poziția) pieselor de pe albume,
--  să se numeroteze toate piesele de pe toate albumele formației
-- `Led Zeppelin`; albumele vor fi ordonate alfabetic, iar piesele după
-- poziția lor în cadrul albumului
-- ############################################################################


-- solutie cu ROW_NUMBER()
SELECT title AS album_title,
	ROW_NUMBER() OVER (PARTITION BY title ORDER BY trackid) AS track_no,
	track.name AS track_name
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Led Zeppelin'
ORDER BY title, 2


-- solutie cu RANK()
SELECT title AS album_title,
	RANK() OVER (PARTITION BY title ORDER BY trackid) AS track_no,
	track.name AS track_name
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
WHERE artist.name = 'Led Zeppelin'
ORDER BY title, 2



-- ############################################################################
-- 		Știind că `trackid` respectă ordinea (poziția) pieselor de pe albume,
--  să se numeroteze toate piesele de pe toate albumele tuturor artiștilor;
-- artiștii și albumele vor fi ordonate alfabetic, iar piesele după
-- poziția lor în cadrul albumului
-- ############################################################################

-- solutie cu ROW_NUMBER()
SELECT
	artist.name AS artist_name,
	title AS album_title,
	ROW_NUMBER() OVER (PARTITION BY artist.name, title ORDER BY trackid) AS track_no,
	track.name AS track_name
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
ORDER BY artist_name, title, 3


-- solutie cu RANK()
SELECT
	artist.name AS artist_name,
	title AS album_title,
	RANK() OVER (PARTITION BY artist.name, title ORDER BY trackid) AS track_no,
	track.name AS track_name
FROM artist
	NATURAL JOIN album
	INNER JOIN track ON album.albumid = track.albumid
ORDER BY artist_name, title, 3



-- ############################################################################
--         Extrageți primele trei piese de pe fiecare album al formației U2
-- ############################################################################

-- solutie cu ROW_NUMBER()
WITH t AS (
	SELECT artist.name AS artist_name,
		title AS album_title,
		ROW_NUMBER() OVER (PARTITION BY artist.name, title ORDER BY trackid) AS track_no,
		track.name AS track_name
	FROM artist NATURAL JOIN album INNER JOIN track ON album.albumid = track.albumid
	WHERE artist.name = 'U2'
	)
SELECT *
FROM t
WHERE track_no <= 3
ORDER BY 1, 2, 3




-- ############################################################################
--              Afisați topul albumelor lansate de formația Queen,
--                      dupa numărul de piese conținute
-- ############################################################################


-- solutie cu RANK
WITH
	queen_albums_and_n_of_tracks AS
		(SELECT title, COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
	 	 WHERE artist.name = 'Queen'
	 	 GROUP BY title),
	-- the second table expression refers to the first one
	queen_albums_ranking AS
		(SELECT title, n_of_tracks,
			 RANK() OVER (ORDER BY n_of_tracks DESC) AS album_rank
		 FROM queen_albums_and_n_of_tracks)
SELECT *
FROM queen_albums_ranking
ORDER BY 1


-- solutie cu DENSE_RANK (sesizati diferenta in rezultat!)
WITH
	queen_albums_and_n_of_tracks AS
		(SELECT title, COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
	 	 WHERE artist.name = 'Queen'
	 	 GROUP BY title),
	-- the second table expression refers to the first one
	queen_albums_ranking AS
		(SELECT title, n_of_tracks,
			 DENSE_RANK() OVER (ORDER BY n_of_tracks DESC) AS album_rank
		 FROM queen_albums_and_n_of_tracks)
SELECT *
FROM queen_albums_ranking
ORDER BY 1




-- ############################################################################
--              Care este albumul (sau albumele) formației Queen
--                       cu cele mai multe piese? (reluare)
-- ############################################################################

-- solutie bazata pe functia RANK()
WITH
	queen_albums_and_n_of_tracks AS
		(SELECT title, COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
	 	 WHERE artist.name = 'Queen'
	 	 GROUP BY title),
	-- the second table expression refers to the first one
	queen_albums_ranking AS
		(SELECT title, n_of_tracks,
			 RANK() OVER (ORDER BY n_of_tracks DESC) AS album_rank
		 FROM queen_albums_and_n_of_tracks)
SELECT *
FROM queen_albums_ranking
WHERE album_rank = 1
ORDER BY 1





-- ############################################################################
-- 	Pentru fiecare album al fiecărui artist, afișați poziția albumului (după
--  numărul de piese conținute) în clasamentul pe albume ale artistului și
--  poziția în clasamentul general (al albumelor tuturor artiștilor)
-- ############################################################################


-- solutie cu RANK()
WITH
	albums_and_n_of_tracks AS
		(SELECT artist.name AS artist_name, title AS album_title,
			COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
	 	 GROUP BY artist_name, title),
	-- the second table expression refers to the first one
	albums_rankinging AS
		(SELECT artist_name, album_title, n_of_tracks,
			RANK() OVER (PARTITION BY artist_name ORDER BY n_of_tracks DESC) AS rank__artist,
			RANK() OVER (ORDER BY n_of_tracks DESC) AS rank__overall
		 FROM albums_and_n_of_tracks)
SELECT *
FROM albums_rankinging
ORDER BY 1,2



-- solutie cu DENSE_RANK()
WITH
	albums_and_n_of_tracks AS
		(SELECT artist.name AS artist_name, title AS album_title,
			COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
	 	 GROUP BY artist_name, title),
	-- the second table expression refers to the first one
	albums_rankinging AS
		(SELECT artist_name, album_title, n_of_tracks,
			DENSE_RANK() OVER (PARTITION BY artist_name ORDER BY n_of_tracks DESC) AS rank__artist,
			DENSE_RANK() OVER (ORDER BY n_of_tracks DESC) AS rank__overall
		 FROM albums_and_n_of_tracks)
SELECT *
FROM albums_rankinging
ORDER BY 1,2



-- ############################################################################
--      Luând în calcul numărul de piese conținute, pe ce poziție se găsește
--       albumul `Machine Head` în ierarhia albumelor formației `Deep Purple`?
-- ############################################################################

WITH
	albums_and_n_of_tracks_deep_purple AS
		(SELECT artist.name AS artist_name, title AS album_title,
			COUNT(*) AS n_of_tracks
	 	 FROM album
			NATURAL JOIN artist
			INNER JOIN track on album.albumid = track.albumid
		 WHERE artist.name = 'Deep Purple'
	 	 GROUP BY artist_name, title),
	-- the second table expression refers to the first one
	albums_ranking__deep_purple AS
		(SELECT artist_name, album_title, n_of_tracks,
			DENSE_RANK() OVER (PARTITION BY artist_name ORDER BY n_of_tracks DESC) AS rank__album
		 FROM albums_and_n_of_tracks_deep_purple)
SELECT rank__album
FROM albums_ranking__deep_purple
WHERE album_title = 'Machine Head'



-- ############################################################################
--    Extrageți, pentru fiecare an, topul celor mai bine vândute trei piese
-- ############################################################################


-- top 3 best selling tracks for each year
WITH
	-- first table expression computes yearly sales for each track
	tracks_yearly_sales AS
		(SELECT track.name AS track_name, title AS album_title,
		 	artist.name AS artist_name, EXTRACT (YEAR FROM invoicedate) AS year,
		 	SUM(invoiceline.quantity * invoiceline.unitprice) AS sales
		 FROM track
		 	NATURAL JOIN album
		 	INNER JOIN artist ON album.artistid = artist.artistid
		 	INNER JOIN invoiceline ON track.trackid = invoiceline.trackid
		 	INNER JOIN invoice ON invoiceline.invoiceid = invoice.invoiceid
		 GROUP BY track.name, title, artist.name, EXTRACT (YEAR FROM invoicedate)
		),
	-- the second table expression ranks the tracks within each year
	sales_ranking AS
		(SELECT year, track_name, album_title, artist_name,  sales,
			RANK() OVER (PARTITION BY year ORDER BY sales DESC) AS rank_of_the_track
		 FROM tracks_yearly_sales)
SELECT *
FROM sales_ranking
WHERE rank_of_the_track <= 3
ORDER BY year, rank_of_the_track




-- ############################################################################
--    Pentru fiecare lună cu vânzări, afișați creșterea sau scăderea valorii
--                 vânzărilor, comparativ cu luna precedentă
-- ############################################################################

WITH
	-- the table expression computes the monthly sales
	monthly_sales AS
		(SELECT
		 	EXTRACT (YEAR FROM invoicedate) AS year,
		 	EXTRACT (MONTH FROM invoicedate) AS month,
		 	SUM(total) AS sales
		 FROM invoice
		 GROUP BY EXTRACT (YEAR FROM invoicedate), EXTRACT (MONTH FROM invoicedate)
		 ORDER BY 1, 2
		)
-- function `LAG` does the job
SELECT year, month, sales as current_month__sales,
	LAG (sales, 1) OVER ( ORDER BY year, month) AS previous_month__sales,
	sales - COALESCE(LAG (sales, 1) OVER ( ORDER BY year, month), 0) AS difference
FROM monthly_sales
ORDER BY year, month


-- ############################################################################
--    Pentru fiecare lună cu vânzări, calculați creșterea sau scăderea valorii
--       vânzărilor, comparativ cu luna precedentă, însă numai în cadrul
--       anului (diferența se va calcula numai între lunile anului curent)
-- ############################################################################

WITH
	-- the table expression computes the monthly sales
	monthly_sales AS
		(SELECT
		 	EXTRACT (YEAR FROM invoicedate) AS year,
		 	EXTRACT (MONTH FROM invoicedate) AS month,
		 	SUM(total) AS sales
		 FROM invoice
		 GROUP BY EXTRACT (YEAR FROM invoicedate), EXTRACT (MONTH FROM invoicedate)
		 ORDER BY 1, 2
		)
-- function `LAG` does the job, this time with `PARTITION BY` clause
SELECT year, month, sales as current_month__sales,
	LAG (sales, 1) OVER (PARTITION BY year ORDER BY month) AS previous_month__sales,
	sales - COALESCE(LAG (sales, 1) OVER (PARTITION BY year ORDER BY month), 0) AS difference
FROM monthly_sales
ORDER BY year, month





-- ############################################################################
--    Pentru fiecare lună cu vânzări, afișați vânzările cumulate de la
--  începutul anului curent și vânzările cumulate de la prima vânzare 
-- ############################################################################

WITH
	-- the table expression computes the monthly sales
	monthly_sales AS
		(SELECT
		 	EXTRACT (YEAR FROM invoicedate) AS year,
		 	EXTRACT (MONTH FROM invoicedate) AS month,
		 	SUM(total) AS sales
		 FROM invoice
		 GROUP BY EXTRACT (YEAR FROM invoicedate), EXTRACT (MONTH FROM invoicedate)
		 ORDER BY 1, 2
		)
SELECT year, month, sales as current_month__sales,
	SUM(sales) OVER (PARTITION BY year ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
		AS cumulative_sales_crt_month__within_crt_year,
	SUM(sales) OVER (ORDER BY year, MONTH ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
		AS cumulative_sales_crt_month__overall		
FROM monthly_sales
ORDER BY year, month




-- ############################################################################
--                Probleme de rezolvat la curs/laborator/acasa
-- ############################################################################

-- ...


-- ############################################################################
--              La ce întrebări răspund următoarele interogări ?
-- ############################################################################


select track.*, row_number() OVER (PARTITION BY albumid ORDER BY trackid) AS trackNo
from track
order by albumid, trackNo ;


with new_track as
	(select track.*, row_number()
     OVER (PARTITION BY albumid ORDER BY trackid) AS trackNo
	from track)
select artist.name as artist_name, title as album_title,
	COALESCE(nt1.name,' ') as track_1,
    COALESCE(nt2.name,' ') as track_2,
    COALESCE(nt3.name,' ') as track_3
from artist
	inner join album on artist.artistid = album.artistid
    left outer join new_track nt1
    	on album.albumid = nt1.albumid and nt1.trackNo = 1
    left outer join new_track nt2
    	on album.albumid = nt2.albumid and nt2.trackNo = 2
    left outer join new_track nt3
    	on album.albumid = nt3.albumid and nt3.trackNo = 3
order by 1, 2
