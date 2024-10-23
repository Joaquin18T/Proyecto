USE gamp;

DROP PROCEDURE IF EXISTS `eliminarOdt`
DELIMITER $$
CREATE PROCEDURE eliminarOdt(IN _idorden_trabajo INT)
BEGIN
	DELETE FROM odt WHERE idorden_trabajo = _idorden_trabajo;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `eliminarEvidenciaOdt`
DELIMITER $$
CREATE PROCEDURE `eliminarEvidenciaOdt`(IN _idevidencias_diagnostico INT)
BEGIN
	DELETE FROM evidencias_diagnostico WHERE idevidencias_diagnostico = _idevidencias_diagnostico;
END $$
DELIMITER ;
