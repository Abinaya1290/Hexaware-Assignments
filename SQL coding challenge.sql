-- 1. Create the database
CREATE DATABASE VirtualArtGallery;

-- 2. Use the newly created database
USE VirtualArtGallery;

-- 3. Create the Artists table
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Biography TEXT,
    Nationality VARCHAR(100)
);

-- 4. Create the Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- 5. Create the Artworks table
CREATE TABLE Artworks (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT,
    CategoryID INT,
    Year INT,
    Description TEXT,
    ImageURL VARCHAR(255),
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 6. Create the Exhibitions table
CREATE TABLE Exhibitions (
    ExhibitionID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT
);

-- 7. Create the ExhibitionArtworks table (junction table)
CREATE TABLE ExhibitionArtworks (
    ExhibitionID INT,
    ArtworkID INT,
    PRIMARY KEY (ExhibitionID, ArtworkID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions(ExhibitionID),
    FOREIGN KEY (ArtworkID) REFERENCES Artworks(ArtworkID)
);

-- 8. Insert sample data into Artists
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- 9. Insert sample data into Categories
INSERT INTO Categories (CategoryID, Name) VALUES
(1, 'Painting'),
(2, 'Sculpture'),
(3, 'Photography');

-- 10. Insert sample data into Artworks
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso''s powerful anti-war mural.', 'guernica.jpg');

-- 11. Insert sample data into Exhibitions
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- 12. Insert sample data into ExhibitionArtworks
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2);

-- 1. Names of all artists with number of artworks, in descending order
SELECT A.Name, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
LEFT JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name
ORDER BY ArtworkCount DESC;

--  2. Titles of artworks by Spanish and Dutch artists, ordered by year sql

SELECT AR.Title, AR.Year
FROM Artworks AR
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Nationality IN ('Spanish', 'Dutch')
ORDER BY AR.Year ASC;

-- 3. Artists with artworks in 'Painting' category and their count
SELECT A.Name, COUNT(AR.ArtworkID) AS PaintingCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
WHERE C.Name = 'Painting'
GROUP BY A.Name;

 -- 4. Artworks in 'Modern Art Masterpieces' with artist and category names
SELECT AR.Title AS ArtworkTitle, A.Name AS ArtistName, C.Name AS CategoryName
FROM ExhibitionArtworks EA
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
JOIN Categories C ON AR.CategoryID = C.CategoryID
WHERE E.Title = 'Modern Art Masterpieces';

-- 5. Artists with more than 2 artworks
SELECT A.Name, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name
HAVING COUNT(AR.ArtworkID) > 2;

-- 6. Artworks exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art'
SELECT AR.Title
FROM Artworks AR
JOIN ExhibitionArtworks EA1 ON AR.ArtworkID = EA1.ArtworkID
JOIN Exhibitions E1 ON EA1.ExhibitionID = E1.ExhibitionID
JOIN ExhibitionArtworks EA2 ON AR.ArtworkID = EA2.ArtworkID
JOIN Exhibitions E2 ON EA2.ExhibitionID = E2.ExhibitionID
WHERE E1.Title = 'Modern Art Masterpieces' AND E2.Title = 'Renaissance Art';

--  7. Total number of artworks in each category

SELECT C.Name AS CategoryName, COUNT(AR.ArtworkID) AS TotalArtworks
FROM Categories C
LEFT JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.Name;

-- 8. Artists with more than 3 artworks
SELECT A.Name, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name
HAVING COUNT(AR.ArtworkID) > 3;

 -- 9. Artworks created by Spanish artists
SELECT AR.Title
FROM Artworks AR
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Nationality = 'Spanish';

 -- 10. Exhibitions that feature both Vincent van Gogh and Leonardo da Vinci
SELECT DISTINCT E.Title
FROM Exhibitions E
JOIN ExhibitionArtworks EA ON E.ExhibitionID = EA.ExhibitionID
JOIN Artworks AR ON EA.ArtworkID = AR.ArtworkID
JOIN Artists A ON AR.ArtistID = A.ArtistID
WHERE A.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY E.ExhibitionID, E.Title
HAVING COUNT(DISTINCT A.Name) = 2;


-- 11. Artworks not included in any exhibition

SELECT AR.Title
FROM Artworks AR
LEFT JOIN ExhibitionArtworks EA ON AR.ArtworkID = EA.ArtworkID
WHERE EA.ArtworkID IS NULL;

-- 12. Artists who have created artworks in all available categories
SELECT A.Name
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.ArtistID, A.Name
HAVING COUNT(DISTINCT AR.CategoryID) = (SELECT COUNT(*) FROM Categories);

-- 13. Total number of artworks in each category
SELECT C.Name AS CategoryName, COUNT(AR.ArtworkID) AS TotalArtworks
FROM Categories C
LEFT JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.Name;

-- 14. Artists who have more than 2 artworks in the gallery
SELECT A.Name, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name
HAVING COUNT(AR.ArtworkID) > 2;

 -- 15. Categories with average year of artworks, only if they have more than 1 artwork
SELECT C.Name AS CategoryName, AVG(AR.Year) AS AvgYear
FROM Categories C
JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.Name
HAVING COUNT(AR.ArtworkID) > 1;

-- 16. Artworks exhibited in 'Modern Art Masterpieces'
SELECT AR.Title
FROM Artworks AR
JOIN ExhibitionArtworks EA ON AR.ArtworkID = EA.ArtworkID
JOIN Exhibitions E ON EA.ExhibitionID = E.ExhibitionID
WHERE E.Title = 'Modern Art Masterpieces';

 -- 17. Categories where average year is greater than overall average year
SELECT C.Name, AVG(AR.Year) AS AvgYear
FROM Categories C
JOIN Artworks AR ON C.CategoryID = AR.CategoryID
GROUP BY C.Name
HAVING AVG(AR.Year) > (SELECT AVG(Year) FROM Artworks);

-- 18. Artworks not exhibited in any exhibition
SELECT AR.Title
FROM Artworks AR
LEFT JOIN ExhibitionArtworks EA ON AR.ArtworkID = EA.ArtworkID
WHERE EA.ArtworkID IS NULL;

-- 19. Artists who have artworks in same category as "Mona Lisa"
SELECT DISTINCT A.Name
FROM Artists A
JOIN Artworks AR ON A.ArtistID = AR.ArtistID
WHERE AR.CategoryID = (
    SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa'
);

-- 20. Names of artists and number of artworks they have
SELECT A.Name, COUNT(AR.ArtworkID) AS ArtworkCount
FROM Artists A
LEFT JOIN Artworks AR ON A.ArtistID = AR.ArtistID
GROUP BY A.Name;

