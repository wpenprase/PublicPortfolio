-- Query 1 Selecting all columns from table CLIENT.

SELECT*
FROM Client;

-- Query 2  Selecting columns, subtracting the difference between DOB and current year and giving it an alias.

SELECT ClientFirstName, ClientLastName, (2024 - ClientDoB) AS AGE, Occupation
FROM Client;


-- Query 3 Selecting specific columns and INNER JOIN with 3 TABLES using Primary keys.

SELECT Borrower.borrowdate, Client.ClientFirstName, Client.ClientLastName
FROM Borrower
INNER JOIN Client
ON Borrower.ClientID = Client.clientID 
WHERE borrowdate BETWEEN '2018-03-01' AND '2018-03-31';

-- Query 4 Selecting specific columns and INNER JOIN with 3 TABLES using Primary keys. Grouped by columns then ordered by Author_Count.

SELECT AuthorFirstName, AuthorLastName, author.AuthorID,  Count(*) AS Author_Count
FROM Borrower
INNER JOIN Book
	ON Borrower.BookId = Book.BookId
INNER JOIN Author
	ON Book.authorID = Author.authorID
WHERE borrowdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY AuthorFirstName, AuthorLastName, Author.AuthorID
ORDER BY Author_Count DESC;



-- Query 5 Selecting specific columns and INNER JOIN with 3 TABLES from Primary keys. Group by Nationality, Author first and last name, authorID. Order by Author Count ASC.  least 5 author that clients borrowed during 2015-2017

SELECT Author.AuthorNationality, Author.AuthorFirstName, Author.AuthorLastName, Author.AuthorID, COUNT(author.authorid) AS Author_Count
FROM Borrower
INNER JOIN Book
	ON Borrower.BookId = Book.BookId 
INNER JOIN Author
	ON Book.authorID = Author.authorID 
WHERE BorrowDate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY Author.AuthorNationality, Author.AuthorFirstName, Author.AuthorLastName, Author.AuthorID
ORDER BY Author_Count ASC;

-- Query 6  INNER JOIN ON 3 tables between 2015-2017.Grouped by BookTitle then ordered by 
-- BookCount desc to find most borrowed during years of 2015-2017

SELECT BookTitle, count(Booktitle) AS Book_Count
FROM Borrower
INNER JOIN Book
	ON Borrower.bookID = book.bookID
WHERE borrowdate BETWEEN '2015-01-01' AND '2017-12-31'
GROUP BY BookTitle
ORDER BY Book_Count desc;

-- Query 7  Inner joining from 3 tables by primary key ClientID. Grouped by ClientsDoB and Ordered by 
-- GenreCount descending to find borrowed genres for clients born in years 1970-1980.

SELECT Client.ClientDoB, Genre, count(Book.genre) AS Genre_Count_1970S
FROM client
INNER JOIN Borrower
	ON Client.clientID = Borrower.clientID
INNER JOIN Book
	ON borrower.bookID = book.bookID
WHERE ClientDoB BETWEEN '1970' AND '1980'
GROUP BY Client.ClientDoB, Genre
ORDER BY Genre_Count_1970S DESC;

-- Query 8 inner join on 3 tables and Grouped byyyyyyyy occupation then ordered by OccupationCount descending. 
-- 5 occupations that the most borrowed in 2016

SELECT Client.Occupation, COUNT(Client.occupation) AS Occupation_Count
FROM client
INNER JOIN Borrower
	ON Client.clientID = Borrower.clientID
INNER JOIN Book
	ON borrower.bookID = book.bookID
where borrowdate Between '2016-01-01' AND '2016-12-31'
GROUP BY Occupation
ORDER BY Occupation_Count desc;

-- Query 9 Inner join on two table  with the average number of borrowed books by job title

SELECT count(BookID) / COUNT(DISTINCT client.ClientID) AS Avg_Books_Per_Client, Occupation
FROM Borrower
JOIN CLIENT
	ON Borrower.ClientID= Client.ClientID
GROUP BY Occupation
ORDER BY Avg_Books_Per_Client desc;

-- Query 10 created a view to display a table  to display the titles that were borrowed by at least %20 of the clients
DROP VIEW IF EXISTS BookTitleBorrowed;
CREATE VIEW BookTitleBorrowed AS
(
SELECT 
	BookTitle, 
	COUNT(DISTINCT ClientID) AS TitleBorrowed,
    COUNT(DISTINCT borrower.ClientID) /(SELECT COUNT(DISTINCT ClientID) FROM BORROWER) AS BorrowRate
FROM Book 
INNER JOIN Borrower  
	ON book.BookID = borrower.BookID
GROUP BY BookTitle
HAVING  BorrowRate >= 0.20
);

SELECT *
FROM BookTitleBorrowed;

-- Query 11  Selected from borrower table and grouped by borrow date date to get top months 

SELECT 
	DATE_FORMAT(BorrowDate, '%Y-%m') AS BorrowMonth,
	COUNT(*) AS BorrowCount
FROM Borrower 
WHERE BorrowDate  
BETWEEN '2017-01-01' AND '2017-12-31' 
GROUP BY BorrowMonth 
ORDER BY BorrowCount DESC; 

--  Query 12 counts all books and grouped by ClientDoB and ordered by age 

SELECT Count(BookID) AS 'Number of Borrows', (2024-ClientDoB) AS 'Borrower_Age' 
FROM CLIENT 
INNER JOIN Borrower 
	ON client.ClientID = borrower.ClientID
GROUP BY Borrower_Age 
ORDER BY Borrower_Age ASC;  

-- Query 13 --------

SELECT 
	MAX(2024 - ClientDoB) AS Oldest_Borrower,
    MIN(2024 - ClientDoB) AS Yongest_Borrower
FROM Client
INNER JOIN Borrower 
	ON Client.clientID = Borrower.borrowID;
    
    
-- Query 14: Selected columns and counted genre greater than 1. 
-- Then used inner join with the primary keys and then grouped by first and last name. 
-- Ordered by descending genre count 

SELECT AuthorFirstName, AuthorLastName, Count(Genre) AS Genre_Count
FROM Book
INNER JOIN Author
	ON book.AuthorID = author.AuthorID
GROUP BY AuthorFirstName, AuthorLastName
ORDER BY Genre_Count DESC
LIMIT 5;