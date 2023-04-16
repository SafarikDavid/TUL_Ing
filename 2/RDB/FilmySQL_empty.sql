USE RDB2023_DavidSafarik

SELECT * FROM Film;
SELECT * FROM Reviewer;
SELECT * FROM Hodnoceni;

-- 1. Najdìte názvy filmù, které reíroval Steven Spielberg.
SELECT nazev
FROM Film
WHERE reziser = 'Steven Spielberg';

-- 2. Najdìte všechny roky filmù, které mají hodnocení 4 nebo 5 a seøaïte je vzestupnì.
SELECT YEAR(datum) as rok
FROM Hodnoceni
WHERE hodnoceni >= 4 AND datum IS NOT NULL
ORDER BY datum ASC;

SELECT DISTINCT YEAR(datum) as rok
FROM Hodnoceni
WHERE hodnoceni >= 4 AND datum IS NOT NULL
GROUP BY datum
ORDER BY YEAR(datum) ASC;

-- 3. Najdìte názvy všech filmù, které nemají hodnocení.
SELECT nazev
FROM Film
WHERE id_film NOT IN (SELECT id_film FROM Hodnoceni);

-- 4. Nìkteøí hodnotitelé neposkytli datum svého hodnocení. Najdìte jména takovıch hodnotitelù.
SELECT jmeno
FROM Reviewer
WHERE id_reviewer IN (SELECT id_reviewer FROM Hodnoceni WHERE datum IS NULL);

-- 5. Napište dotaz, kterı vrátí data o hodnocení v èitelnìjším formátu: jméno hodnotitele, název filmu, hodnocení a datum hodnocení. Setøiïte data podle jména hodnotitele, názvu filmu a nakonec podle hodnocení.
SELECT Reviewer.jmeno as jmeno, Film.nazev as nazev, Hodnoceni.hodnoceni as hodnoceni, Hodnoceni.datum as datum
FROM Film
JOIN Hodnoceni ON Film.id_film = Hodnoceni.id_film
JOIN Reviewer ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
ORDER BY jmeno, nazev, hodnoceni;

-- 6. Pro všechny pøípady, kdy urèitı reviewer hodnotil stejnı film dvakrát a dal mu podruhé vyšší hodnocení, vrate jméno reviewera a název filmu.


-- 7. Pro kadı film, kterı má nìjaké hodnocení, najdìte nejvyšší dosaené hodnocení. Vypište název filmu a hodnocení, setøiïte podle názvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) as max_hodnoceni
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY nazev;

-- 8. Pro kadı film naleznìte název filmu a rozsah hodnocení, co je rozdíl mezi nejvyšším a nejniším hodnocením. Setøiïte nejdøíve podle rozsahu od nejvyššího po nejniší, potom podle názvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) - MIN(Hodnoceni.hodnoceni) as rozsah
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY rozsah, nazev;

-- 9. Najdìte rozdíl mezi prùmìrnım hodnocením filmù uvedenıch pøed rokem 1980 a prùmìrné hodnocení filmù uvedenıch od roku 1980. Ujistìte se, e jste spoèítali prùmìrné hodnocení nejdøíve pro kadı film a pak prùmìr tìchto prùmìrù pøed rokem 1980 a po roce 1980.
SELECT AVG(Hodnoceni.hodnoceni)
FROM Hodnoceni
JOIN Film ON Hodnoceni.id_film = Film.id_film
WHERE Film.rok < 1980; -- dodelat

-- 10. Najdìte jména všech reviewerù, kteøí pøispìli tøemi a více hodnoceními. Pokuste se napsat dotaz bez pouití HAVING nebo bez Count.
SELECT Reviewer.jmeno as jmeno, COUNT(id_film) as pocet
FROM Reviewer
JOIN Hodnoceni ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
GROUP BY jmeno
HAVING COUNT(id_film) >= 3;