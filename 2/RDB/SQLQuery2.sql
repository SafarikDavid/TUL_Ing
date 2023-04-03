USE [RDB2023_DavidSafarik]
GO

INSERT INTO [Uzivatel]
           ([id_uziv]
           ,[login]
           ,[heslo]
           ,[telefon])
     VALUES
           (1
           ,'David'
           ,HASHBYTES('MD5', 'heslo')
           ,NULL)
GO

INSERT INTO [Uzivatel]
           ([id_uziv]
           ,[login]
           ,[heslo]
           ,[telefon])
     VALUES
           (2
           ,'Filip'
           ,HASHBYTES('MD5', 'kleslo')
           ,'+420777666444')
GO


INSERT INTO [Uzivatel]
           ([id_uziv]
           ,[login]
           ,[heslo]
           ,[telefon])
     VALUES
           (3
           ,'Hagrid'
           ,HASHBYTES('MD5', 'hleslo')
           ,NULL),
		   (4
           ,'Karel'
           ,HASHBYTES('MD5', 'kreslo')
           ,NULL),
		   (5
           ,'Bedrich'
           ,HASHBYTES('MD5', 'plesklo')
           ,'+420498759125')
GO


SET IDENTITY_INSERT Tema ON

INSERT INTO Tema (id_tema, nazev, id_uziv)
	VALUES (1, 'Jak elin', 2)

SET IDENTITY_INSERT Tema OFF

INSERT INTO Tema (nazev)
	VALUES ('Zelenina')

INSERT INTO Tema (nazev, id_uziv)
	VALUES ('Ovoce', 1), ('Kabrnak', NULL), ('Jak na krys', 3)


INSERT INTO Prihlaseni (id_tema, id_uziv, datum)
	VALUES (1, 1, GETDATE()), (1, 2, GETDATE()-367), (1, 3, GETDATE()-10), (2, 1, GETDATE()), (2, 2, GETDATE()), (3, 1, GETDATE()-389), (3, 3, GETDATE()), (4, 4, GETDATE())

INSERT INTO Prihlaseni (id_tema, id_uziv, datum)
	VALUES (2, 3, '2022-02-22')

UPDATE Prihlaseni SET id_uziv = 4 WHERE id_tema = 2 AND id_uziv = 3

DELETE FROM Tema WHERE id_tema = 5

DELETE FROM Uzivatel WHERE login = 'Hagrid'