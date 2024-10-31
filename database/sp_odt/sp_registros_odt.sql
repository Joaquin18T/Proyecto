USE gamp;
DROP PROCEDURE IF EXISTS `registrar_odt`
DELIMITER //
CREATE PROCEDURE `registrar_odt`
(
	OUT _idorden_trabajo INT,
	IN _idtarea INT,
    IN _creado_por INT,
    IN _fecha_inicio DATE,
    IN _hora_inicio	TIME,
    IN _fecha_vencimiento DATE,
    IN _hora_vencimiento	TIME
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO odt (idtarea, creado_por, fecha_inicio, hora_inicio, fecha_vencimiento, hora_vencimiento)
		VALUES (_idtarea, _creado_por, _fecha_inicio, _hora_inicio, _fecha_vencimiento, _hora_vencimiento);
        
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
    IN _evidencia VARCHAR(80)
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
	INSERT INTO historial_estado_odt (idorden_trabajo, estado_anterior, estado_nuevo, comentario, devuelto)	
		VALUES (_idorden_trabajo, _estado_anterior, _estado_nuevo, _comentario, NULLIF(_devuelto, ""));
END //

DROP PROCEDURE IF EXISTS `registrarDetalleOdt`
DELIMITER //
CREATE PROCEDURE `registrarDetalleOdt`
(
	OUT _iddetalleodt 		INT,
	IN _idorden_trabajo 	INT,
    IN _clasificacion		INT
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO detalle_odt (idorden_trabajo, clasificacion)	
		VALUES (_idorden_trabajo, _clasificacion);
        
	IF existe_error = 1 THEN
		SET _iddetalleodt = -1;
	ELSE
        SET _iddetalleodt = LAST_INSERT_ID();
    END IF;
END //

DROP PROCEDURE IF EXISTS `registrar_comentario_odt`
DELIMITER //
CREATE PROCEDURE `registrar_comentario_odt`
(
	IN _idorden_trabajo 	INT,
    IN _comentario			VARCHAR(300),
    IN _revisadoPor			INT
)
BEGIN	
	INSERT INTO comentarios_odt (idorden_trabajo, comentario, revisadoPor)	
		VALUES (_idorden_trabajo, NULLIF(_comentario,""), _revisadoPor);	
END //

DROP PROCEDURE IF EXISTS `registrarHistorialOdt`
DELIMITER //
CREATE PROCEDURE `registrarHistorialOdt`
(
	OUT _idhistorial 		INT,
	IN _idorden_trabajo 	INT
)
BEGIN	
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO historial_odt (idorden_trabajo)	
		VALUES (_idorden_trabajo);	
        
	IF existe_error = 1 THEN
		SET _idhistorial = -1;
	ELSE
        SET _idhistorial = LAST_INSERT_ID();
    END IF;
END //

select * from tareas;