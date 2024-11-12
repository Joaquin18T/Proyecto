use gamp;

DROP PROCEDURE IF EXISTS `registrarTarea`
DELIMITER //
CREATE PROCEDURE `registrarTarea`(
	OUT _idtarea 	INT,
	IN _idusuario	INT,
    IN _fecha_inicio	DATE,
    IN _hora_inicio		TIME
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO tareas (idusuario, fecha_inicio, hora_inicio)
    VALUES (_idusuario, _fecha_inicio, _hora_inicio);
    
    IF existe_error = 1 THEN
		SET _idtarea = -1;
	ELSE
        SET _idtarea = LAST_INSERT_ID();
    END IF;
END //




DROP PROCEDURE IF EXISTS `obtenerTareasPorEstado`
DELIMITER //
CREATE PROCEDURE `obtenerTareasPorEstado`(
	IN _idestado	INT
)
BEGIN
	SELECT * FROM tareas where estado = _idestado;
END //



