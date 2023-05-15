--use RDB2023_DavidSafarik

--Vytvo�te trigger, kter� po zad�n� nov� faktury dopo��t� cenu.
--CREATE TRIGGER tr_objednavka_count_price
--ON Objednavka
--AFTER INSERT AS
--BEGIN
--	DECLARE @faktura int
--	SELECT @faktura = faktura FROM inserted
--	DECLARE @pocet int
--	SELECT @pocet = pocet FROM inserted
--	DECLARE @cissou int
--	SELECT @cissou = cissou FROM inserted
--	UPDATE Objednavka
--	SET cena = (SELECT cena FROM Soucastka WHERE Soucastka.cissou = @cissou)*@pocet
--	WHERE Objednavka.faktura = @faktura
--END

--Upravte trigger tak, aby p�i p�ekro�en� ceny 1000 K� byla zapo�tena sleva 10 %.
ALTER TRIGGER tr_objednavka_count_price
ON Objednavka
AFTER INSERT AS
BEGIN
	DECLARE @faktura int
	SELECT @faktura = faktura FROM inserted
	DECLARE @pocet int
	SELECT @pocet = pocet FROM inserted
	DECLARE @cissou int
	SELECT @cissou = cissou FROM inserted
	DECLARE @cenasou money
	SET @cenasou = (SELECT cena FROM Soucastka WHERE Soucastka.cissou = @cissou)
	IF (@cenasou*@pocet > 1000)
		SET @cenasou = @cenasou*0.9
	UPDATE Objednavka
	SET cena = @cenasou*@pocet
	WHERE Objednavka.faktura = @faktura
END

--Upravte trigger tak, aby reflektoval vlo�en� v�ce objedn�vek najednou.


--Vytvo�te ulo�enou proceduru, kter� zobraz� sou��stky s cenou pod 20 K�.


--Vytvo�te ulo�enou proceduru, kter� zobraz� sou��stky s cenou pod zadanou cenu.


--Vytvo�te co nejobecn�j�� logovac� trigger, kter� bude sledovat v�echny zm�ny v tabulce objedn�vek.

