use gamp;

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

DROP PROCEDURE IF EXISTS `actualizarDiagnosticoOdt`
DELIMITER //
CREATE PROCEDURE `actualizarDiagnosticoOdt`
(
	IN _iddiagnostico INT,
    IN _diagnostico VARCHAR(300)
)
BEGIN
	UPDATE diagnosticos SET
    diagnostico = _diagnostico
    WHERE iddiagnostico = _iddiagnostico;
END //

select * from diagnosticos;