use sigemapre;

DROP PROCEDURE IF EXISTS `actualizarBorradorOdt`
DELIMITER //
CREATE PROCEDURE `actualizarBorradorOdt`
(
	IN _idorden_trabajo INT,
	IN _borrador INT
)
BEGIN
	UPDATE odt SET
    borrador = _borrador
    WHERE idorden_trabajo = _idorden_trabajo;
END //
