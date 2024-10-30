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

DROP PROCEDURE IF EXISTS `actualizarEstadoOdt`
DELIMITER //
CREATE PROCEDURE `actualizarEstadoOdt`
(
	IN _idorden_trabajo INT,
	IN _idestado INT
)
BEGIN
	UPDATE odt SET
    idestado = _idestado
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

DROP PROCEDURE IF exists `actualizarFechaVencimientoOdt`
DELIMITER //
CREATE PROCEDURE `actualizarFechaVencimientoOdt`
(
	IN _idodt INT,
    IN _fecha_vencimiento DATE,
    IN _hora_vencimiento TIME
)
BEGIN
	UPDATE odt SET
    fecha_vencimiento = _fecha_vencimiento,
    hora_vencimiento = _hora_vencimiento
    WHERE idorden_trabajo = _idodt;
END //
