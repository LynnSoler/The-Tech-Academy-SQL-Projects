CREATE DATABASE db_library
GO

CREATE TABLE tbl_library (
	branch_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	branch_name VARCHAR(50) NOT NULL,
	branch_address VARCHAR(60) NOT NULL
);

CREATE TABLE tbl_publisher (
	publisher_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	publisher_name VARCHAR(50) NOT NULL,
	publisher_address VARCHAR(50) NOT NULL,
	publisher_phone VARCHAR(50) NOT NULL,
);

CREATE TABLE tbl_books (
	books_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	books_title VARCHAR(50) NOT NULL,
	books_publisher INT NOT NULL CONSTRAINT fk_publisher_id FOREIGN KEY REFERENCES tbl_publisher(publisher_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tbl_authors (
	books_id INT NOT NULL CONSTRAINT fk_books_id FOREIGN KEY REFERENCES tbl_books(books_id) ON UPDATE CASCADE ON DELETE CASCADE,
	authors_name VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_bookcopies (
	books_id INT NOT NULL CONSTRAINT fk2_books_id FOREIGN KEY REFERENCES tbl_books(books_id) ON UPDATE CASCADE ON DELETE CASCADE,
	branch_id INT NOT NULL CONSTRAINT fk_branch_id FOREIGN KEY REFERENCES tbl_library(branch_id) ON UPDATE CASCADE ON DELETE CASCADE,
	number_of_copies VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_borrower (
	card_number INT PRIMARY KEY NOT NULL IDENTITY (200,1),
	borrower_name VARCHAR(50) NOT NULL,
	borrower_address VARCHAR(60) NOT NULL,
	borrower_phone VARCHAR(60) NOT NULL
);

CREATE TABLE tbl_bookloans (
	books_id INT NOT NULL CONSTRAINT fk3_books_id FOREIGN KEY REFERENCES tbl_books(books_id) ON UPDATE CASCADE ON DELETE CASCADE,
	branch_id INT NOT NULL CONSTRAINT fk2_branch_id FOREIGN KEY REFERENCES tbl_library(branch_id) ON UPDATE CASCADE ON DELETE CASCADE,
	card_number INT NOT NULL CONSTRAINT fk_card_number FOREIGN KEY REFERENCES tbl_borrower(card_number) ON UPDATE CASCADE ON DELETE CASCADE,
	date_out VARCHAR(50) NOT NULL,
	date_due VARCHAR(50) NOT NULL
);