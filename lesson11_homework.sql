-- lesson11_homework

-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи
-- в таблицах users, catalogs и products в таблицу logs помещается время и дата
-- создания записи, название таблицы, идентификатор первичного ключа
-- и содержимое поля name.

CREATE TABLE logs (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	create_ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50) NOT NULL,
	row_id INT UNSIGNED NOT NULL,
	name VARCHAR(100),
	PRIMARY KEY (id)
) ENGINE=Archive;

DELIMITER //
CREATE TRIGGER users_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, row_id, name)
		VALUES ('users', NEW.id, NEW.name);
END //
CREATE TRIGGER catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, row_id, name)
		VALUES ('catalogs', NEW.id, NEW.name);
END //
CREATE TRIGGER products_log AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, row_id, name)
		VALUES ('products', NEW.id, NEW.name);
END //
DELIMITER ;

-- 1.
-- В базе данных Redis подберите коллекцию для подсчета посещений
-- с определенных IP-адресов.

Чтобы не извлекать значение из базы для его увеличения на 1 имеет смысл 
использовать сами IP адреса в качестве ключей и количество посещений в качестве
значений и пользоваться функцией INCR

SET 192.168.1.0 23
INCR 192.168.1.0


-- 2.
-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному 
-- адресу и наоборот, поиск электронного адреса пользователя по его имени.

Поскольку данные можно извлечь только по ключу, то при создании пользователя следует
создавать две записи:
MSET user:id01:user01name user01_email user:01:user01_email user01name
Извлекать записи нужно двумя запросами:
KEYS user:*:email, подставив на место email соответствующий адрес,
GET user:id:email, подставив найденный в предыдущем запросе ключ 

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных
-- shop в СУБД MongoDB.







