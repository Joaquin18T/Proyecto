use gamp;

DROP PROCEDURE IF EXISTS `registrarTareaMantenimiento`
DELIMITER //
CREATE PROCEDURE `registrarTareaMantenimiento`(
	OUT _idtm		 	INT,
	IN _idtarea				INT,
    IN _descripcion			VARCHAR(300)
)	
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO tareas_mantenimiento (idtarea, descripcion)
    VALUES (_idtarea, _descripcion);

    IF existe_error = 1 THEN
		SET _idtm = -1;
	ELSE
        SET _idtm = LAST_INSERT_ID();
    END IF;
END //


-- Obtiene los mantenimientos de un activo

DROP PROCEDURE IF EXISTS `obtenerMantenimientosActivo` 
DELIMITER //
CREATE PROCEDURE `obtenerMantenimientosActivo`(
	IN _idactivo	INT
)
BEGIN
	SELECT * FROM tareas_mantenimiento TM
	INNER JOIN tareas TAR ON TM.idtarea = TAR.idtarea
    INNER JOIN activos_tarea ACT ON TAR.idtarea = ACT.idtarea
    where ACT.idactivo = _idactivo;
END //

