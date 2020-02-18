DELIMITER //
-- Проверка правильности ссылки на вторую сторону в договорах
DROP TRIGGER IF EXISTS add_contract_dependencies_check;
CREATE TRIGGER add_contract_dependencies_check BEFORE INSERT ON contracts
FOR EACH ROW 
BEGIN
	IF NEW.contract_type_id = (SELECT id FROM contract_types ct WHERE contract_type = 'income')
		AND 
		NEW.counterpart_id NOT IN (SELECT id from clients)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Insert cancelled: counterpart_id for income contracts must reference clients.id';
	ELSEIF NEW.contract_type_id = (SELECT id FROM contract_types ct WHERE contract_type = 'expense')
		AND 
		NEW.counterpart_id NOT IN (SELECT id from contractor_service_type_links)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Insert cancelled: counterpart_id for expense contracts must reference contractor_service_type_links.id';
	 END IF;
END//
 
-- Проверка на наличие неоплаченных счетов
DROP FUNCTION IF EXISTS overdue_payments;
CREATE FUNCTION overdue_payments()
RETURNS VARCHAR(200) READS SQL DATA
BEGIN
	RETURN ''
END//
 
 
DELIMITER ;
 
