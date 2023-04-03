CREATE TABLE Dodavatel (
	cisdod int NOT NULL PRIMARY KEY,
	jmeno nvarchar(50),
	adresa nvarchar(50),
	mesto nvarchar(50)
)
go

CREATE TABLE Soucastka (
	cissou int NOT NULL PRIMARY KEY,
	cena money,
	barva nvarchar(20)
)
go

CREATE TABLE Dodava (
	cisdod int NOT NULL,
	cissou int NOT NULL,
	PRIMARY KEY (cisdod, cissou),
	FOREIGN KEY (cissou) REFERENCES Soucastka,
	FOREIGN KEY (cisdod) REFERENCES Dodavatel
)
go