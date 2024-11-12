use gamp;

DROP PROCEDURE IF EXISTS `registrarActivoTarea`
DELIMITER //
CREATE PROCEDURE `registrarActivoTarea`(
	OUT _idactivos_tarea 	INT,
	IN _idtarea				INT,
    IN _idactivo			INT
)	
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO tareas (idtarea, idactivo)
    VALUES (_idtarea, _idactivo);

    IF existe_error = 1 THEN
		SET _idactivos_tarea = -1;
	ELSE
        SET _idactivos_tarea = LAST_INSERT_ID();
    END IF;
END //


