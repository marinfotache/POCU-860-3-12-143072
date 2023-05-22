



-- care sunt judetele din Moldova?
SELECT *
FROM judete
WHERE regiune = 'Moldova' ;


-- Cate judetele sunt in Moldova?
SELECT COUNT(*)
FROM judete
WHERE regiune = 'Moldova' ;

