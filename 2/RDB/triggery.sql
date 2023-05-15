--use RDB2023_DavidSafarik

--Vytvoøte trigger, který po zadání nové faktury dopoèítá cenu.
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

--Upravte trigger tak, aby pøi pøekroèení ceny 1000 Kè byla zapoètena sleva 10 %.
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

--Upravte trigger tak, aby reflektoval vložení více objednávek najednou.


--Vytvoøte uloženou proceduru, která zobrazí souèástky s cenou pod 20 Kè.


--Vytvoøte uloženou proceduru, která zobrazí souèástky s cenou pod zadanou cenu.


--Vytvoøte co nejobecnìjší logovací trigger, který bude sledovat všechny zmìny v tabulce objednávek.

