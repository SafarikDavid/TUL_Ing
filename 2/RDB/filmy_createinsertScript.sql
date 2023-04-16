USE RDB2023_DavidSafarik

CREATE TABLE [Film]
(
	[id_film] Integer NOT NULL,
	[nazev] Varchar(50) NULL,
	[rok] Integer NULL,
	[reziser] Varchar(30) NULL,
Primary Key ([id_film])
)
go

CREATE TABLE [Reviewer]
(
	[id_reviewer] Integer NOT NULL,
	[jmeno] Varchar(30) NULL,
	[vip] Bit NULL,
Primary Key ([id_reviewer])
)
go

CREATE TABLE [Hodnoceni]
(
	[id_reviewer] Integer NOT NULL,
	[id_film] Integer NOT NULL,
	[hodnoceni] Integer NOT NULL,
	[datum] Datetime NULL,
Primary Key ([id_film],[id_reviewer],[hodnoceni])
)
go

ALTER TABLE [Hodnoceni] ADD FOREIGN KEY ([id_film]) REFERENCES [Film] ([id_film]) ON DELETE CASCADE
go
ALTER TABLE [Hodnoceni] ADD FOREIGN KEY ([id_reviewer]) REFERENCES [Reviewer] ([id_reviewer]) ON DELETE CASCADE
go



INSERT INTO Film VALUES (101, 'Gone with the Wind', 1939, 'Victor Fleming')
INSERT INTO Film VALUES (102, 'Star Wars', 1977, 'George Lucas')
INSERT INTO Film VALUES (103, 'The Sound of Music', 1965, 'Robert Wise')
INSERT INTO Film VALUES (104, 'E.T.', 1982, 'Steven Spielberg')
INSERT INTO Film VALUES (105, 'Titanic', 1997, 'James Cameron')
INSERT INTO Film VALUES (106, 'Snow White', 1937, null) -- režie David Hand
INSERT INTO Film VALUES (107, 'Avatar', 2009, 'James Cameron')
INSERT INTO Film VALUES (108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg')

INSERT INTO Reviewer VALUES (201, 'Sarah Martinez', 0)
INSERT INTO Reviewer VALUES (202, 'Daniel Lewis', 1)
INSERT INTO Reviewer VALUES (203, 'Brittany Harris', 0)
INSERT INTO Reviewer VALUES (204, 'Mike Anderson', 1)
INSERT INTO Reviewer VALUES (205, 'Chris Jackson', 0)
INSERT INTO Reviewer VALUES (206, 'Elizabeth Thomas', 1)
INSERT INTO Reviewer VALUES (207, 'James Cameron', 0)
INSERT INTO Reviewer VALUES (208, 'Ashley White', 1)

INSERT INTO Hodnoceni VALUES (201, 101, 2, '2011-01-22')
INSERT INTO Hodnoceni VALUES (201, 101, 4, '2011-01-27')
INSERT INTO Hodnoceni VALUES (202, 106, 4, null)
INSERT INTO Hodnoceni VALUES (203, 103, 2, '2011-01-20')
INSERT INTO Hodnoceni VALUES (203, 108, 4, '2011-01-12')
INSERT INTO Hodnoceni VALUES (203, 108, 2, '2011-01-30')
INSERT INTO Hodnoceni VALUES (204, 101, 3, '2011-01-09')
INSERT INTO Hodnoceni VALUES (205, 103, 3, '2011-01-27')
INSERT INTO Hodnoceni VALUES (205, 104, 2, '2011-01-22')
INSERT INTO Hodnoceni VALUES (205, 108, 4, null)
INSERT INTO Hodnoceni VALUES (206, 107, 3, '2011-01-15')
INSERT INTO Hodnoceni VALUES (206, 106, 5, '2011-01-19')
INSERT INTO Hodnoceni VALUES (207, 107, 5, '2011-01-20')
INSERT INTO Hodnoceni VALUES (208, 104, 3, '2011-01-02')