USE Stud_Org
GO
DELETE FROM WorksOn
DELETE FROM Task
DELETE FROM MadeBy
DELETE FROM Project
DELETE FROM PartOf
DELETE FROM Department
DELETE FROM Volunteering
DELETE FROM Student
DELETE FROM Organization

INSERT INTO Organization (NameO) 
VALUES
    ('OSUBB'),
    ('ASC'),
    ('OSP'),
    ('ASP'),
    ('OSUT');

INSERT INTO Student (NameS, Telephone, PointsContribution, Age) 
VALUES
    ('Lung Andreea', 0726328798, 100, 20),
    ('Oltyan Octavian', 0721752492, 50, 19),
    ('Lazar Bianca', NULL, 20, 18),
    ('Matisan Rares', NULL, 170, 22),
    ('Vlad Dobrea', 0749893020, 40, 19),
    ('Antonio Stan', NULL, 80, 23);

INSERT INTO Volunteering (OId, SId, Since) 
VALUES 
    (100, 200, 2022),
    (100, 201, 2023),
    (100, 202, 2023),
    (100, 203, 2021),
    (101, 204, 2020),
    (101, 205, 2022);

INSERT INTO Department (NameD, MinimAge, OId) 
VALUES
    ('Human Resources', 18, 100),
    ('Youth', 19, 100),
    ('Fundraising', 20, 100),
    ('Projects writer', 20, 100),
    ('Img & Pr', 19, 100),
    ('Human Resources', 17, 101),
    ('Youth', 18, 101),
    ('Fundraising', 19, 101),
    ('Projects writer', 19, 101),
    ('Img & Pr', 20, 101);

INSERT INTO PartOf (DId, SId, Since) 
VALUES 
    (301, 200, 2023), 
    (302, 200, 2023),
    (303, 200, 2024),
    (301, 201, 2022),
    (302, 201, 2022),
    (303, 202, 2023),
    (301, 203, 2021),
    (303, 203, 2022),
    (306, 204, 2022),
    (306, 205, 2019),
    (307, 205, 2020);

INSERT INTO Project (NameP, DateP)
VALUES 
    ('CaravanaUBB', '2024-02-19'),
    ('Trix', '2023-12-04');

INSERT INTO MadeBy (DId, PId) 
VALUES 
    (302, 400),
    (305, 400),
    (301, 401),
    (303, 401),
    (305, 401);

INSERT INTO Task (DescriptionT, Deadline, StatusT, PId)
VALUES
    ('Write the script', '2023-11-30', 'in progress', 400),
    ('Make the presentation', '2023-12-30', 'not started', 400),
    ('Give all to feedback', '2024-01-04', 'in progress', 400),
    ('Make post on instagram', '2023-11-10', 'in progress', 401),
    ('Reserve a place', '2023-11-02', 'finished', 401);

INSERT INTO WorksOn (TId, SId)
VALUES 
    (501, 200),
    (502, 200),
    (503, 202),
    (504, 201),
    (503, 203);

SELECT * FROM Organization
SELECT * FROM Student
SELECT * FROM Volunteering
SELECT * FROM Department
SELECT * FROM PartOf
SELECT * FROM Project
SELECT * FROM MadeBy
SELECT * FROM Task
SELECT * FROM WorksOn