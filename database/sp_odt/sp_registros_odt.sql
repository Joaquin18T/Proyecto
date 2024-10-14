USE gamp;

DROP PROCEDURE IF EXISTS `registrar_odt`
DELIMITER //
CREATE PROCEDURE `registrar_odt`
(
	OUT _idorden_trabajo INT,
	IN _idtarea INT,
    IN _creado_por INT
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO odt (idtarea, creado_por)
		VALUES (_idtarea, _creado_por);
        
	IF existe_error = 1 THEN
		SET _idorden_trabajo = -1;
	ELSE
        SET _idorden_trabajo = LAST_INSERT_ID();
    END IF;
END //


DROP PROCEDURE IF EXISTS `registrarDiagnostico`
DELIMITER //
CREATE PROCEDURE `registrarDiagnostico`
(
	OUT _iddiagnostico INT,
	IN _idorden_trabajo INT,
    IN _idtipo_diagnostico INT,
    IN _diagnostico VARCHAR(300)
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO diagnosticos (idorden_trabajo, idtipo_diagnostico, diagnostico)
		VALUES (_idorden_trabajo, _idtipo_diagnostico, _diagnostico);
        
	IF existe_error = 1 THEN
		SET _iddiagnostico = -1;
	ELSE
        SET _iddiagnostico = LAST_INSERT_ID();
    END IF;
END //

DROP PROCEDURE IF EXISTS `registrarEvidenciaDiagnostico`
DELIMITER //
CREATE PROCEDURE `registrarEvidenciaDiagnostico`
(
	IN _iddiagnostico INT,
    IN _evidencia BLOB
)
BEGIN
	INSERT INTO evidencias_diagnostico (iddiagnostico, evidencia)
		VALUES (_iddiagnostico, _evidencia);
END //


DROP PROCEDURE IF EXISTS `asignarResponsablesODT`
DELIMITER //
CREATE PROCEDURE `asignarResponsablesODT`
(
	IN _idorden_trabajo INT,
    IN _idresponsable	INT
)
BEGIN
	INSERT INTO responsables_asignados_odt (idorden_trabajo, idresponsable)
		VALUES (_idorden_trabajo, _idresponsable);
END //

call asignarResponsablesODT(1,5);

DROP PROCEDURE IF EXISTS `registrarHistorial`
DELIMITER //
CREATE PROCEDURE `registrarHistorial`
(
	IN _idorden_trabajo INT,
    IN _estado_anterior INT,
    IN _estado_nuevo 	INT,
    IN _comentario		TEXT,
    IN _devuelto		BOOLEAN
)
BEGIN
	INSERT INTO historial_estado_odt (_idorden_trabajo, _estado_anterior, _estado_nuevo, _comentario, _devuelto)	
		VALUES (_idorden_trabajo, _estado_anterior, _estado_nuevo, _comentario, NULLIF(_devuelto, ""));
END //
