USE RDB2023_DavidSafarik

CREATE TABLE Objednavka
(
	[cisdod] Integer NOT NULL,
	[cissou] Integer NOT NULL,
	[faktura] Integer NOT NULL,
	[cena] Money NULL,
	[pocet] Integer NULL,
Primary Key ([faktura])
)
go

ALTER TABLE [Objednavka] ADD FOREIGN KEY (cisdod) REFERENCES [Dodavatel] ([cisdod]) ON DELETE CASCADE
go
ALTER TABLE [Objednavka] ADD FOREIGN KEY (cissou) REFERENCES [Soucastka] ([cissou]) ON DELETE CASCADE
go