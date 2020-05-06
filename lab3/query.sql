Используется PostgreSQL

1. INSERT
	INSERT INTO lab3.book VALUES (8, 1111111111111, 'aaaaa', '', date('1999-02-11'), null);
	INSERT INTO lab3.publisher (id, title, address, city_id, phone, email) values (1, 'Питер', 'Б. Сампсониевский пр., 29а', 1, 78127037372, 'books@piter.com');
	INSERT INTO lab3.book (publisher_id) SELECT id FROM lab3.publisher LIMIT 1;

2. DELETE
	DELETE FROM lab3.author;
	DELETE FROM lab3.book WHERE lab3.book.id > 6;
	TRUNCATE TABLE lab3.author;

3. UPDATE
	UPDATE lab3.author SET author.patronymic = 'Джонович';
	UPDATE lab3.author SET patronymic = 'Станиславович' WHERE name = 'Стив';
	UPDATE lab3.author SET patronymic = 'Игоревич', country = 'USA' WHERE name = 'Томас';

4. SELECT
	SELECT title, isbn, publishing FROM lab3.book;
	SELECT * FROM lab3.book;
	SELECT * FROM lab3.book WHERE book.publishing < date('2000-01-01');

5. SELECT ORDER BY + TOP (LIMIT)
	SELECT * FROM lab3.book ORDER BY book.isbn ASC LIMIT 3;
	SELECT * FROM lab3.book ORDER BY book.isbn DESC LIMIT 3;
	SELECT * FROM lab3.book ORDER BY book.isbn, book.id DESC LIMIT 3;
	SELECT * FROM lab3.book ORDER BY book.isbn;

6. DATETIME
	SELECT * FROM lab3.book WHERE book.publishing = date('1993-01-01');
	SELECT title,  EXTRACT(YEAR FROM publishing) AS date FROM lab3.book;

7. GROUP BY
	SELECT MIN(publishing) AS min, publisher_id FROM lab3.book GROUP BY book.publisher_id;
	SELECT MAX(publishing) AS max, publisher_id FROM lab3.book GROUP BY book.publisher_id;
	SELECT AVG(min_price) AS avg, publisher_id FROM lab3.book GROUP BY book.publisher_id;
	SELECT SUM(min_price) AS sum, publisher_id FROM lab3.book GROUP BY book.publisher_id;
	SELECT COUNT(id) AS count, publisher_id FROM lab3.book GROUP BY book.publisher_id;

8. GROUP BY + HAVING
	SELECT AVG(min_price) AS avg, publisher_id FROM lab3.book GROUP BY book.publisher_id HAVING AVG(min_price) < 500;
	SELECT SUM(min_price) AS sum, publisher_id FROM lab3.book GROUP BY book.publisher_id HAVING SUM(min_price) > 300;
	SELECT COUNT(id) AS count, publisher_id FROM lab3.book GROUP BY book.publisher_id HAVING publisher_id = 1;

9. SELECT JOIN
	SELECT * FROM lab3.book LEFT JOIN lab3.publisher ON book.publisher_id = publisher.id WHERE phone IS NOT NULL;
	SELECT * FROM lab3.book RIGHT JOIN lab3.publisher ON book.publisher_id = publisher.id WHERE phone IS NOT NULL ORDER BY publishing ASC LIMIT 3;
	SELECT * FROM lab3.book LEFT JOIN lab3.book_author ON book.id = book_author.book_id
                        	LEFT JOIN lab3.author ON author.id = book_author.author_id
                        	WHERE publishing > date('2000-01-01') AND country IS NULL AND author_id < 11;
    SELECT * FROM lab3.publisher FULL OUTER JOIN lab3.city ON publisher.city_id = city.id;

10. Подзапросы
	SELECT title FROM lab3.book WHERE publishing IN (date('2013-05-30'), date('2018-01-01'));
	SELECT title FROM lab3.book WHERE publisher_id IN (SELECT id FROM lab3.publisher WHERE address IS NOT NULL);
	SELECT (SELECT AVG(min_price) FROM lab3.book) as price FROM lab3.book;
