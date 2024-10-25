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
    incompleto = _borrador
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

DROP PROCEDURE IF EXISTS `actualizarDetalleOdt`
DELIMITER //
CREATE PROCEDURE `actualizarDetalleOdt`
(
	IN _iddetalleodt INT,
    IN _fechafinal DATETIME,
    IN _tiempoejecucion TIME,
    IN _clasificacion INT
)
BEGIN
	UPDATE detalle_odt SET
    fecha_final = _fechafinal,
    tiempo_ejecucion = _tiempoejecucion,
    clasificacion = _clasificacion
    WHERE iddetalleodt = _iddetalleodt;
END //

