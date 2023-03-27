-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-03-27 14:32:06.837

USE RDB2023_DavidSafarik
go

-- tables
-- Table: Prihlaseni
CREATE TABLE Prihlaseni (
    datum datetime  NOT NULL,
    id_uziv int  NOT NULL,
    id_tema int  NOT NULL,
    CONSTRAINT Prihlaseni_pk PRIMARY KEY  (id_uziv,id_tema)
);

-- Table: Tema
CREATE TABLE Tema (
    id_tema int  NOT NULL IDENTITY,
    nazev nvarchar(20)  NOT NULL,
    id_uziv int  NULL,
    CONSTRAINT Tema_pk PRIMARY KEY  (id_tema)
);

-- Table: Uzivatel
CREATE TABLE Uzivatel (
    id_uziv int  NOT NULL,
    [login] nvarchar(50)  NOT NULL,
    heslo nvarchar(50)  NOT NULL,
    CONSTRAINT Uzivatel_pk PRIMARY KEY  (id_uziv)
);

-- foreign keys
-- Reference: FK_Spravce (table: Tema)
ALTER TABLE Tema ADD CONSTRAINT FK_Spravce
    FOREIGN KEY (id_uziv)
    REFERENCES Uzivatel (id_uziv)
    ON DELETE  SET NULL;

-- Reference: FK_Tema (table: Prihlaseni)
ALTER TABLE Prihlaseni ADD CONSTRAINT FK_Tema
    FOREIGN KEY (id_tema)
    REFERENCES Tema (id_tema);

-- Reference: FK_Uzivatel (table: Prihlaseni)
ALTER TABLE Prihlaseni ADD CONSTRAINT FK_Uzivatel
    FOREIGN KEY (id_uziv)
    REFERENCES Uzivatel (id_uziv)
    ON DELETE  CASCADE;

ALTER TABLE Uzivatel ADD CONSTRAINT UQ_Login
	UNIQUE ([login]);

ALTER TABLE Uzivatel ADD telefon nvarchar(14) NULL;

-- End of file.

