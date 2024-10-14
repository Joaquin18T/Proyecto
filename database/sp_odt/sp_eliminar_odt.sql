USE sigemapre;

DROP PROCEDURE IF EXISTS `eliminarOdt`
DELIMITER $$
CREATE PROCEDURE eliminarOdt(IN _idorden_trabajo INT)
BEGIN
	DELETE FROM odt WHERE idorden_trabajo = _idorden_trabajo;
END $$
DELIMITER ;