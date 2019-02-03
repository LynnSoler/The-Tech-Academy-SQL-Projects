
-- =FINDING BOOK + BRCH LOC
CREATE PROC uspGETBookAndBranch 
@Title VARCHAR(30), 
@BranchName VARCHAR(30)
--VARCHAR CONSIST CHK = OK
AS
	SELECT 
	a1.books_Title, a2.branch_Name, c.number_Copies --2.) =HOW MANY COPIES 
	FROM tbl_books a1
	JOIN tbl_bookcopies c ON c.books_ID = a1. books_ID
	INNER JOIN tbl_library a2 ON a2.branch_ID = c.branch_ID
	WHERE books_Title = @Title and branch_Name = @BranchName
GO
EXEC uspGETBookAndBranch 'The Lost Tribe', 'Sharpstown' -- 1.) 2.) HOW MANY COPIES "THE LOST TRIBE" BKS_TITLE @ BRANCHNAME "SHARPSTOWN"




--3.) RETRIEVE NAMES OF BORROWERS W/O ANY BKS CHECKED OUT
CREATE PROC uspNoBooks
AS
	SELECT 
	a1.borrower_Name, a2.card_Num, a2.date_Out, a2. date_Due
	FROM tbl_borrower a1
	LEFT JOIN tbl_bookloans a2 ON a1.card_Num = a2. card_Num
	WHERE a1.card_Num NOT IN (SELECT card_Num FROM tbl_bookloans) -- = W/OUT ANY BKS
EXEC uspNoBooks




--RETRIEVE EA BK DUE TODAY @ VARIOUS BRCH LOC'S
CREATE PROC uspBooksDueToday --4.) CREATING DUETODAY PROC
@BranchName VARCHAR(30), 
@DateDue VARCHAR(10)
--VARCHAR CONSIST CHK = OK
AS
	SELECT --4.) RETRIEVE BK TITLE + BORROWER NAME + BORROWER ADDY  FOR EA BOOK FROM "Sharpstown" BRCH W/"DATEDUE" = TODAY 
	a1.branch_Name, a2.date_Due, c.books_Title, d.borrower_Name, d.borrower_Addy
	FROM tbl_library a1
	JOIN tbl_bookloans a2 ON a2.branch_ID = a1. branch_ID
	JOIN tbl_books c ON c.books_ID = a2.books_ID
	JOIN tbl_borrower d ON a2.card_Num = d.card_Num
	WHERE branch_Name = @BranchName and date_Due = @DateDue
EXEC uspBooksDueToday 'Sharpstown', '10/31/2018'



--5.) RETRIEVE BRANCH NAME + TOTAL BKS CHECKED OUT FROM BRCH "Sharpstown"
CREATE PROCEDURE uspTotalBookLoans
@BranchName VARCHAR(30)
--VARCHAR CONSIST CHK = OK
AS
	SELECT 
	a1.branch_Name, COUNT(books_Title)
	FROM tbl_library a1
	JOIN tbl_bookloans a2 ON a2.branch_ID = a1. branch_ID
	JOIN tbl_books c ON c.books_ID = a2.books_ID
	WHERE branch_name = @BranchName
	GROUP BY a1.branch_Name
EXEC uspTotalBookLoans 'Sharpstown'
--EXEC "" '@BranchName'



--6.) RETRIEVE NAMES + ADDYS + # BKS CHKD OUT FOR ALL BRRWERS WHO HAVE > 5 BKS CHKD OUT
CREATE PROCEDURE uspGREATERThanFiveBooks
AS
	SELECT borrower_Name, c.card_Num, c.borrower_Addy FROM
	tbl_books a 
	JOIN tbl_bookloans b ON a.books_ID = b.books_ID
	JOIN tbl_borrower c ON c.card_Num = b.card_Num
	GROUP BY borrower_Name, c.card_Num, c.borrower_Addy
	HAVING COUNT(b.card_Num) > 5 -- = BORROWER ID W/ >5 BOOKS CHKD OUT
	ORDER BY c.card_Num ASC
EXEC uspGREATERThanFiveBooks





--RETRIEVE # OF COPIES OWNED BY BRCH
CREATE PROCEDURE uspNumCopiesAtBranch
@Title VARCHAR(30), 
@BranchName VARCHAR(30)
-- VARCHAR CONSIST CHK = OK
AS

	SELECT authors_Name, books_Title, num_Copies, branch_Name 
		FROM tbl_books a
		JOIN tbl_authors e ON e.books_ID = a.books_ID
		JOIN tbl_bookcopies b ON  a.books_ID = b.books_ID
		JOIN tbl_library d ON d.branch_ID = b.branch_ID
		WHERE books_Title = @Title and branch_Name = @BranchName

EXEC uspNumCopiesAtBranch 'IT', 'Central'