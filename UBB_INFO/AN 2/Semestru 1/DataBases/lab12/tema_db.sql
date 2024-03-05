CREATE TABLE BrandDress(
	brand_id INT PRIMARY KEY,
	brand_name VARCHAR(50)
);

CREATE TABLE Styles(
	style_id INT PRIMARY KEY IDENTITY,
	style_name VARCHAR(25) UNIQUE,
	style_origin VARCHAR(25)
);

CREATE TABLE Dresses(
	dress_id INT PRIMARY KEY IDENTITY,
	dress_colour VARCHAR(100),
	dress_length INT,
	style_id INT FOREIGN KEY REFERENCES Styles(style_id),
	brand_id INT FOREIGN KEY REFERENCES BrandDress(brand_id)
);

CREATE TABLE DressStyles(
	dress_id INT FOREIGN KEY REFERENCES Dresses(dress_id),
	style_id INT FOREIGN KEY REFERENCES Styles(style_id),
	PRIMARY KEY(dress_id,style_id),
);
DROP TABLE DressStyles

CREATE TABLE Studios(
	studio_id INT PRIMARY KEY IDENTITY,
	studio_name VARCHAR(50),
	studio_city VARCHAR(50) 
);
CREATE TABLE Designers(
	designer_id INT PRIMARY KEY IDENTITY,
	studio_id INT FOREIGN KEY REFERENCES Studios(studio_id),
	designer_name VARCHAR(50)
);

CREATE TABLE DressExemplares(
	dress_id INT FOREIGN KEY REFERENCES Dresses(dress_id),
	designer_id INT FOREIGN KEY REFERENCES Designers(designer_id),
	nr_exemplare INT PRIMARY KEY
);

CREATE TABLE Materials(
	material_id INT NOT NULL,
	material_colour VARCHAR(50),
	material_price INT
);

CREATE TABLE Models(
	model_id INT NOT NULL,
	model_name VARCHAR(50),
	PRIMARY KEY(model_id),
	model_size INT
);

CREATE TABLE DressLength(
	length_id INT PRIMARY KEY IDENTITY,
	dress_id INT FOREIGN KEY REFERENCES Dresses(dress_id),
	trena BIT,
	adjustabila BIT
);

DROP TABLE DressLength

CREATE TABLE ModelsPerStudio(
	model_id INT FOREIGN KEY REFERENCES Models(model_id),
	studio_id INT FOREIGN KEY REFERENCES Studios(studio_id)
);

CREATE TABLE MaterialsInStudios(
	material_id INT FOREIGN KEY REFERENCES Materials(material_id),
	studio_id INT FOREIGN KEY REFERENCES Studios(studio_id),
	PRIMARY KEY(material_id, studio_id),
	nr_meters INT
);

set identity_insert Models oFF;

INSERT INTO Models(
	model_id,
	model_name,
	model_size
) VALUES
	(1, 'Gigi Hadid', 32),
	(2, 'Bella Hadid', 34),
	(3, 'Selena Gomez',34 ),
	(4, 'Kendall Jenner', 38)
;

INSERT INTO Models(model_id, model_name, model_size) VALUES (10, 'Kim K', 38);
SELECT * FROM Models
set identity_insert BrandDress on;

INSERT INTO BrandDress(
	brand_id,
    brand_name
) VALUES
	(1, 'Versace'),
	(2, 'Balenciaga'),
	(3, 'Fendi'),
	(4, 'Dior')
;
set identity_insert Styles off;

INSERT INTO Styles(
	style_id,
    style_name,
	style_origin
) VALUES
	(1, 'retro', 'south'),
	(2, 'gothic', 'south'),
	(3, 'vintage', 'north'),
	(4, 'classy', 'europe')
;

set identity_insert Materials on;

INSERT INTO Materials(
	material_id,
    material_colour,
	material_price
) VALUES
	(1, 'silk', 12),
	(2, 'satin', 22),
	(3, 'velvet', 50),
	(4, 'cashmere', 9),
	(5, 'silk', 90)
;

INSERT INTO Materials(
	material_id,
    material_colour,
	material_price
) VALUES
	(5, 'silk', 90)
;

INSERT INTO Materials(
	material_id,
    material_colour,
	material_price
) VALUES
	(6, 'veil', 91),
	(7, 'lace', 96),
	(8, 'italy lace', 99)
;

SELECT * FROM	Materials

set identity_insert Studios off;

INSERT INTO Studios(
	studio_id,
    studio_name,
	studio_city
) VALUES
	(1, 'Fashion', 'Cluj'),
	(2, 'Chic girl', 'Timisoara'),
	(3, 'Go hard or go home', 'Bistrita'),
	(4, 'Barbie Studio', 'Bucuresti'),
	(5, 'Glam you up', 'Arad')
;

INSERT INTO Studios(
	studio_id,
	studio_city
) VALUES
	(6, 'Cluj')
;

INSERT INTO Studios(
	studio_id,
    studio_name,
	studio_city
)VALUES
	(10, 'Versace', 'Bucuresti'),
	(11, 'Balenciaga', 'Bucuresti')
;

INSERT INTO Studios(studio_id, studio_city) VALUES (7, 'Arad');
SELECT * FROM	Studios

set identity_insert Dresses off;

INSERT INTO Dresses(
	dress_id, 
	dress_colour,
	dress_length, 
	style_id, 
	brand_id
)VALUES
	(1, 'pink', 32, 1, 1),
	(2, 'green', 36, 2, 1),
	(3, 'black', 38, 1, 2),
	(4, 'pink', 34, 1, 3)
;


--VIOLATED CONSTRAINT
INSERT INTO Dresses(
	dress_id, 
	dress_colour,
	dress_length, 
	style_id, 
	brand_id
)VALUES(10, 'yellow', 32, 100, 1)


INSERT INTO ModelsPerStudio(
		model_id,
		studio_id
)VALUES
	(1, 1),
	(1, 2),
	(2, 2),
	(2, 1)
;
 INSERT INTO ModelsPerStudio(
		model_id,
		studio_id
)VALUES
	(3, 10),
	(4, 5)
;
INSERT INTO ModelsPerStudio (model_id, studio_id) VALUES(3, 4);
INSERT INTO ModelsPerStudio (model_id) VALUES(10);

SELECT * FROM ModelsPerStudio

INSERT INTO MaterialsInStudios(
	material_id,
	studio_id,
	nr_meters
)VALUES
	(1, 1, 3),
	(2, 2, 5)
;

set identity_insert Designers off;


INSERT INTO Designers(
	designer_id,
	studio_id,
	designer_name
)VALUES
	(1, 1, 'Donatella Versace'),
	(2, 4, 'Catalin Botezatu'),
	(3, 1, 'Roberto Cavalli'),
	(4, 7, 'Mario Valentino'),
	(5, 1, 'Gianni Versace'),
	(6, 4, 'Valentino Garavani')
;

INSERT INTO DressExemplares(
	dress_id,
	designer_id,
	nr_exemplare
)VALUES
	(1, 1, 3),
	(2, 1, 5),
	(3, 5, 8),
	(4, 6, 1)
;



INSERT INTO MaterialsInStudios(material_id, studio_id, nr_meters) VALUES (5, 7, 90);

SELECT * FROM ModelsPerStudio

SELECT * FROM	Studios

UPDATE Models SET model_name='lavi'  WHERE model_id=1
SELECT * FROM Models

UPDATE Materials SET material_price=20  WHERE material_price>100 or material_colour = 'silk'
SELECT * FROM Materials
UPDATE Materials SET material_price=29  WHERE material_id = 1
UPDATE Materials SET material_price=30  WHERE material_id = 2
UPDATE Materials SET material_price=90  WHERE material_id = 3
UPDATE Studios SET studio_name='Cool Dresses'  WHERE studio_city LIKE 'C%' OR studio_name IS  NULL
UPDATE MaterialsInStudios set nr_meters = 10 where studio_id =1

DELETE FROM Studios WHERE studio_city IN ('Bistrita' , 'Brasov')

DELETE FROM Materials WHERE material_price BETWEEN 1 AND 10;
SELECT * FROM MaterialsInStudios

--QUERIES
--a) two queries with the union operation; use UNION [ALL] and OR

--The studio Cool Dresses WITH ID = 1 from Cluj wants to keep a record of the models and the meters of materials they are in charge of, so that they know how many dresses can manufactor.

SELECT M.model_id
FROM ModelsPerStudio M
WHERE M.studio_id = 1

UNION

SELECT MA.nr_meters
FROM MaterialsInStudios MA
WHERE MA.studio_id =1

select * 
FROM MaterialsInStudios

-- select all the studios whose models wear a 38 size or who have a nr of meters of material bigger than 20
--USED UNION, DISTINCT, OR

SELECT DISTINCT S.studio_id, S.studio_name, s.studio_city, MO.model_name
FROM Studios S, ModelsPerStudio M , MaterialsInStudios MA, Models MO
WHERE (MO.model_id = M.model_id AND MO.model_size = 38 AND M.studio_id = S.studio_id) OR ( MA.studio_id = S.studio_id AND MA.nr_meters >20)


--b)  2 queries with the intersection operation; use INTERSECT and IN;
--show all the studios that are also designer brands

SELECT S.studio_name
FROM Studios S

INTERSECT --used intersect

SELECT B.brand_name
FROM BrandDress B

--alternative with IN

SELECT S.studio_name
FROM Studios S
WHERE S.studio_name IN (SELECT B.brand_name FROM BrandDress B)

--c) two queries with the difference operation; use EXCEPT and NOT IN
--show all models with size bigger than 32 who do not work in Bucharest

SELECT DISTINCT M.model_id, MO.model_name
FROM ModelsPerStudio M, Models MO
WHERE MO.model_id = M.model_id AND MO.model_size > 32
EXCEPT 
SELECT DISTINCT M.model_id,  MO.model_name
FROM ModelsPerStudio M, Studios S, Models  MO
WHERE M.model_id = MO.model_id AND   M.studio_id = S.studio_id AND S.studio_city  IN ('Bucuresti')


--show the first 3 studios which do not have any extensions in Timisoara

SELECT  DISTINCT TOP 3 S.studio_city, S.studio_name
FROM Studios S
WHERE  S.studio_city NOT IN ('Timisoara')

SELECT * FROM  Studios
SELECT  * FROM ModelsPerStudio

--alternative with NOT IN
--toti designerii care au facut rochii in stilul retro dar care nu au studio cu numele lor

SELECT B.brand_name, B.brand_id
FROM BrandDress B, Dresses D, Styles S
WHERE  D.brand_id = B.brand_id AND  D.style_id = S.style_id AND S.style_name = 'retro'  AND B.brand_name NOT IN (SELECT ST.studio_name FROM Studios ST)

--f). 2 queries with the EXISTS operator and a subquery in the WHERE clause;
--select the styles which have dresses in colour pink
SELECT S.style_name
FROM Styles S
WHERE EXISTS (SELECT * FROM Dresses D WHERE S.style_id = D.style_id AND D.dress_colour = 'pink')

--select the brands who have dresses of length 34

SELECT B.brand_name, B.brand_id
FROM BrandDress B
WHERE EXISTS( SELECT * FROM Dresses D WHERE D.brand_id = B.brand_id and D.dress_length = 34)

--g). 2 queries with a subquery in the FROM clause;                        
--find all dresses whose length is bigger than the average nr of meters of all studios, and sort them in descending order
--USED AVG 
--USED ORDER BY

SELECT D.dress_id, D.dress_length, METERS.averageMeters
FROM (SELECT AVG(nr_meters) as averageMeters from MaterialsInStudios) AS METERS, Dresses as D
WHERE D.dress_length > METERS.averageMeters
ORDER BY D.dress_length DESC


--find all materials whose price is bigger than the average price of the materials
--USED TOP
--USED ORDER BY

SELECT DISTINCT TOP 4 Materials.material_id, Materials.material_price, mavg.materials_avg FROM (SELECT AVG(material_price) as materials_avg FROM Materials) AS mavg, Dresses D, Materials
WHERE  Materials.material_price > mavg.materials_avg
ORDER BY Materials.material_price

--arithmetic expressions in the SELECT clause in at least 3 queries;
--WE HAVE SALES! find the material sale with a discount of 5%.

SELECT M.material_id, M.material_colour,
(M.material_price * 5)/100 as discount
FROM Materials M

--from each and every studio, there is obviously some material loss.
--this week the loss is 2m. Find out the remainding nr of meters.

SELECT M.material_id, M.studio_id,
(M.nr_meters - 2) as Loss
FROM MaterialsInStudios M

SELECT * FROM DressExemplares D

update DressExemplares set nr_exemplare = nr_exemplare + 1

--at each studio, designers add ten more dresses, compute in a separate coloumn the new nr of dresses.
SELECT D.dress_id, D.designer_id,
(D.nr_exemplare + 10) as nr_exemplare_adaos
FROM DressExemplares D

--e). 2 queries with the IN operator and a subquery in the WHERE clause; in at least one case, the subquery must include a subquery in its own WHERE clause;
--select all the designers who have made 5 or more exemplares.

SELECT DISTINCT D.designer_ID
FROM Studios S, Designers D
WHERE D.designer_id IN (SELECT DE.designer_id FROM DressExemplares DE WHERE DE.nr_exemplare > 5)

--select all the studios who have made 5 or more exemplares.

SELECT DISTINCT D.designer_ID, S.studio_name, S.studio_city, S.studio_id
FROM Studios S, Designers D
WHERE D.designer_id IN (SELECT DE.designer_id FROM DressExemplares DE WHERE (DE.nr_exemplare > 5 AND D.studio_id = S.studio_id))

select * from Designers
select * from Dresses
select * from Studios

--d)  4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); 
--one query will join at least 3 tables, while another one will join at least two many-to-many relationships;

--select all the dresses, with their style id, brand id and brand name

SELECT D.dress_id, D.style_id, D.brand_id, B.brand_name
FROM Dresses D INNER JOIN Styles S
ON D.style_id = S.style_id
INNER JOIN BrandDress B
ON B.brand_id = D.brand_id

--while another one will join at least two many-to-many relationships;
--models per studio is a many to many relation between models and studios, and materials in studios, a many to many between materials and studios
SELECT DISTINCT M.model_id , M.studio_id, MS.nr_meters
FROM ModelsPerStudio M LEFT JOIN MaterialsInStudios MS
ON M.studio_id = MS.studio_id

INSERT INTO MaterialsInStudios
(	material_id, 
	studio_id, 
	nr_meters
)VALUES
	(1, 2, 3),
	(3, 2, 10)
;
--right join
SELECT D.dress_id, S.style_id
FROM Dresses D RIGHT JOIN Styles S
ON D.style_id = S.style_id

--full join
SELECT DISTINCT S.studio_id, S.studio_name, M.model_id
FROM Studios S FULL JOIN ModelsPerStudio M
ON S.studio_id = M.studio_id

--h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause;
--2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

--the shortest dress  made by a brand,  for each and every style
SELECT MIN(D.dress_length) as minimum, D.style_id
FROM Dresses D
WHERE D.brand_id IS NOT NULL
GROUP BY D.style_id

INSERT INTO Dresses (dress_id, dress_colour, dress_length, style_id, brand_id) VALUES (88, 'white', 32, 3, 1), (90, 'black', 32, 2, 2);
INSERT INTO Dresses (dress_id, dress_colour, dress_length, style_id, brand_id) VALUES (89, 'black', 35, 1, 2);

--the number of dresses in retro style, grouped by colour, which are in number of 2 or more exemplares

SELECT COUNT(D.dress_id) as dress_nr, D.dress_colour
FROM Dresses D
WHERE D.style_id = 1
GROUP BY D.dress_colour
HAVING COUNT(D.dress_id) > 1

--for all the styles, find the average length dress in that style, with a minimum length of 30, and keep only those styles who have at least 2 dresses satisfying those conditions.
SELECT D.style_id, AVG(D.dress_length) as AV_Length
FROM Dresses D 
WHERE D.dress_length >30
GROUP BY D.style_id
HAVING 1 < (SELECT COUNT(*) FROM Dresses D2 WHERE D.style_id = D2.style_id)

--select the maximum id of a material like satin and velvet , grouped by studio, with a total sum of meters of material, per studio smaller than 16m.
SELECT M.studio_id, MAX(M.material_id) as max_material_id
FROM MaterialsInStudios M, Materials MA
WHERE MA.material_id = M.material_id AND  MA.material_colour IN ('satin', 'velvet')
GROUP BY M.studio_id
HAVING SUM(M.nr_meters) < 16
--studio with id 2 has dresses made by satin 5 meters and velvet 10 meters, => for studio id 2 the sum is 15

select * from MaterialsInStudios
select * from Materials
--i). 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator); 
--rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.

-- select all the designers who have made a piece in more than 3 exemplares
SELECT D.designer_name, D.designer_id
FROM Designers D
WHERE D.designer_id = ANY ( SELECT DE.designer_id FROM DressExemplares DE WHERE DE.nr_exemplare>3)

--rewrite with in 

SELECT D.designer_name, D.designer_id
FROM Designers D
WHERE D.designer_id IN (SELECT DE.designer_id FROM DressExemplares DE WHERE DE.nr_exemplare>3)

--select all the models who work at Cool Dresses, they can also work at more studios.
SELECT M.model_id, M.model_name
FROM Models M
WHERE M.model_id = ANY ( SELECT  MS.model_id FROM ModelsPerStudio MS, Studios S WHERE (MS.studio_id=S.studio_id AND S.studio_name = 'Cool Dresses'))
 
--select all the models who work only at glam you up                      EXTRA 
SELECT M.model_id, M.model_name
FROM Models M
GROUP BY M.model_id, M.model_name
HAVING 1 = (select count (*) from ModelsPerStudio MO, Studios S where mo.model_id = m.model_id and S.studio_name = 'Glam you up' and S.studio_id=MO.studio_id)


--transform it using count

SELECT M.model_id, M.model_name
FROM Models M
GROUP BY M.model_id, M.model_name
HAVING 0<(select count (*) from ModelsPerStudio MO, Studios S where mo.model_id = m.model_id and S.studio_name = 'Cool Dresses' and S.studio_id=MO.studio_id)

--select all the materials with a price bigger than the price for velvet and satin
SELECT M.material_colour, M.material_price
FROM Materials M
WHERE M.material_price > ALL (SELECT MS.material_price FROM Materials MS WHERE MS.material_colour IN ('velvet', 'satin'))


--rewrite with aggregation operator MAX
SELECT M.material_colour, M.material_price
FROM Materials M
WHERE M.material_price > (SELECT MAX(MS.material_price) FROM Materials MS WHERE MS.material_colour IN ('velvet', 'satin'))


--find all designers who are not also studios in Bucuresti

SELECT B.brand_name
FROM BrandDress B
WHERE B.brand_name <> ALL ( SELECT S.studio_name FROM Studios S WHERE S.studio_city LIKE '%Bucuresti%')


--rewrite with not in
SELECT B.brand_name
FROM BrandDress B
WHERE B.brand_name NOT IN ( SELECT S.studio_name FROM Studios S WHERE S.studio_city LIKE '%Bucuresti%')


select * from Studios