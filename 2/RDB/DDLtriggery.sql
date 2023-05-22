CREATE TRIGGER t_info
ON DATABASE 
FOR CREATE_TABLE 
AS 
    PRINT 'Tabulka vytvorena.'
    --SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') AS Dotaz
go

CREATE TABLE Tabulka2 (Atribut int);
go

CREATE TRIGGER t_safety 
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE 
AS 
   PRINT 'Nejdøíve zakažte trigger "safety", pak lze mazat a mìnit tabulky!' 
   ROLLBACK; -- ani se neprovede
go

DROP TABLE Tabulka2
go

CREATE TRIGGER t_database 
ON ALL SERVER 
FOR CREATE_DATABASE 
AS 
    PRINT 'Databaze vytvoøena.'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') AS Dotaz, 
		   EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'sysname') AS Udalost
go

CREATE DATABASE Pokus
go