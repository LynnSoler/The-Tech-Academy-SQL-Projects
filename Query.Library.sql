
--Query for finding a book and what branch it's located at
CREATE PROCEDURE uspGetBookBranch 
@Title VARCHAR(50), 
@BranchName VARCHAR(50)
AS
	SELECT 
	a1.books_title, a2.branch_name, c.number_of_copies
	FROM tbl_books a1
	JOIN tbl_bookcopies c ON c.books_id = a1. books_id
	INNER JOIN tbl_library a2 ON a2.branch_id = c.branch_id
	WHERE books_title = @Title and branch_name = @BranchName
GO

EXEC uspGetBookBranch 'The Lost Tribe', 'Sharpstown'


--Query that retrieves the names of all borrowers who do not have any books checked out
CREATE PROCEDURE uspZeroBooks
AS
	SELECT 
	a1.borrower_name, a2.card_number, a2.date_out, a2. date_due
	FROM tbl_borrower a1
	LEFT JOIN tbl_bookloans a2 ON a1.card_number = a2. card_number
	WHERE a1.card_number NOT IN (SELECT card_number FROM tbl_bookloans)

EXEC uspZeroBooks


--Query that retrieves each book that is due today at different branch locations
CREATE PROCEDURE uspBooksDueToday
@BranchName VARCHAR(50), 
@DateDue VARCHAR(50)
AS

	SELECT 
	a1.branch_name, a2.date_due, c.books_title, d.borrower_name, d.borrower_address
	FROM tbl_library a1
	JOIN tbl_bookloans a2 ON a2.branch_id = a1. branch_id
	JOIN tbl_books c ON c.books_id = a2.books_id
	JOIN tbl_borrower d ON a2.card_number = d.card_number
	WHERE branch_name = @BranchName and date_due = @DateDue

EXEC uspBooksDueToday 'Sharpstown', '10/10/2018'



--Query that retrieves the branch name and the total number of books loaned out from that branch
CREATE PROCEDURE uspTotalBookLoans
@BranchName VARCHAR(50)
AS
	SELECT 
	a1.branch_name, COUNT(books_title)
	FROM tbl_library a1
	JOIN tbl_bookloans a2 ON a2.branch_id = a1. branch_id
	JOIN tbl_books c ON c.books_id = a2.books_id
	WHERE branch_name = @BranchName
	GROUP BY a1.branch_name
	
EXEC uspTotalBookLoans 'Sharpstown'



--Query that retrieves the names, addresses, and the number of books checked out for all borrowers who have more than five books checked out
CREATE PROCEDURE uspGreaterThanFiveBooks
AS
	SELECT borrower_name, c.card_number, c.borrower_address FROM
	tbl_books a 
	JOIN tbl_bookloans b ON a.books_id = b.books_id
	JOIN tbl_borrower c ON c.card_number = b.card_number
	GROUP BY borrower_name, c.card_number, c.borrower_address
	HAVING COUNT(b.card_number) > 5
	ORDER BY c.card_number ASC

EXEC uspGreaterThanFiveBooks





--Query that retrieves the number of copies owned by a specific library branch
CREATE PROCEDURE uspNumberOfCopiesAndBranch
@Title VARCHAR(50), 
@BranchName VARCHAR(50)
AS

	SELECT authors_name, books_title, number_of_copies, branch_name 
		FROM tbl_books a
		JOIN tbl_authors e ON e.books_id = a.books_id
		JOIN tbl_bookcopies b ON  a.books_id = b.books_id
		JOIN tbl_library d ON d.branch_id = b.branch_id
		WHERE books_title = @Title and branch_name = @BranchName

EXEC uspNumberofCopiesAndBranch 'Misery', 'Central'