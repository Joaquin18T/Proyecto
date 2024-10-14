USE gamp;


DROP PROCEDURE IF EXISTS `verificarOrdenInconclusa`
DELIMITER //
CREATE PROCEDURE `verificarOrdenInconclusa`
(
	IN _idorden_trabajo INT
)
BEGIN
	SELECT
		*
        FROM odt ODT
        LEFT JOIN diagnosticos DIA ON DIA.idorden_trabajo = ODT.idorden_trabajo
        WHERE ODT.idorden_trabajo = 21 AND ODT.borrador = 1;
	
END //