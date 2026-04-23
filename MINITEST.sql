DROP DATABASE IF EXISTS BookStoreDB;	
CREATE DATABASE BookStoreDB;
USE BookStoreDB;

CREATE TABLE category(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE book(
	book_id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(150) NOT NULL,
    status INT DEFAULT 1,
    publish_date DATE,
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE book_order(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(100) NOT NULL,
    book_id INT,
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
    ON DELETE CASCADE,
	order_date DATE DEFAULT (CURRENT_DATE),
    delivery_date DATE
);

ALTER TABLE book
ADD COLUMN author_name VARCHAR(100) NOT NULL;

ALTER TABLE book_order
MODIFY COLUMN customer_name VARCHAR(200);

ALTER TABLE book_order
MODIFY COLUMN delivery_date DATE CHECK (delivery_date >= order_date);

INSERT INTO category (category_id, category_name, description)
VALUES
(1, 'IT & Tech', 'Sách lập trình'),
(2, 'Business', 'Sách kinh doanh'),
(3, 'Novel', 'Tiểu thuyết');

INSERT INTO book (book_id, title, status, publish_date, price, category_id, author_name)
VALUES
(1, 'Clean Code', 1, '2020-05-10', 500000 , 1, ' Robert C.Martin'),
(2, 'Đắc Nhân Tâm', 0, '2018-08-20', 150000, 2, 'Dale Carnegie'),
(3, 'JavaScript Nâng cao', 1, '2023-01-15', 350000, 1, 'Kyle Simpson'),
(4, 'Nhà Giả Kim', 0, '2015-11-25', 120000, 3, 'Paulo Coelho');

INSERT INTO book_order (order_id, customer_name, book_id, order_date, delivery_date)
VALUES
(101, 'Nguyen Hai Nam', 1, '2025-01-10', '2025-01-15'),
(102, 'Tran Bao Ngoc', 3, '2025-02-05', '2025-02-10'),
(103, 'Le Hoang Yen', 4, '2025-03-12', NULL);

SELECT * FROM category;
SELECT * FROM book;
SELECT * FROM book_order;

UPDATE book
SET price = price + 50000
WHERE category_id = 1;

UPDATE book_order
SET delivery_date = '2025-12-31'
WHERE delivery_date IS NULL;

DELETE FROM book_order WHERE order_date < '2025-02-01';

SELECT title, author_name,
CASE
	WHEN status = 1 THEN 'Còn hàng'
	WHEN status = 0 THEN 'Hết hàng'
	END as status_name
FROM book;

SELECT UPPER(title) AS title_upper, YEAR(CURDATE()) - YEAR(publish_date) AS years_since_publish
FROM book;

SELECT b.title, b.price, c.category_name FROM book as b
JOIN category as c
 ON c.category_id = b.category_id;
 
SELECT * FROM book
ORDER BY price DESC 
LIMIT 3;

SELECT c.category_name, COUNT(b.book_id) FROM book as b
JOIN category as c
	ON c.category_id = b.category_id
GROUP BY c.category_name
HAVING COUNT(b.book_id) >= 2;

SELECT * FROM book 
WHERE price > (SELECT AVG(price) FROM book);

SELECT * FROM book_order
WHERE order_id IN (SELECT COUNT(book_id) as total_order FROM book_order
HAVING total_order IS NOT NULL);

SELECT * FROM book as b 
JOIN category as c
	ON c.category_id = b.category_id
WHERE price = (
	SELECT MAX(price) FROM book
    HAVING c.category_id = b.category_id
);
