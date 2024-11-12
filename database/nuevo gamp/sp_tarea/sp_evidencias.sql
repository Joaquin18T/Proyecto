use gamp;

DROP PROCEDURE IF EXISTS `registrarEvidencia`
DELIMITER //
CREATE PROCEDURE `registrarEvidencia`(
	OUT _idevidencia 	INT,
    IN _idtm			INT,
	IN _evidencia		varchar(30)
)	
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO evidencias (idtm, evidencia)
    VALUES (_idtm, _evidencia);

    IF existe_error = 1 THEN
		SET _idevidencia = -1;
	ELSE
        SET _idevidencia = LAST_INSERT_ID();
    END IF;
END //


-- Obtiene las evidencias de de una tarea mantenimiento
DROP PROCEDURE IF EXISTS `obtenerEvidencias` 
DELIMITER //
CREATE PROCEDURE `obtenerEvidencias`(
	IN _idtm	INT
)
BEGIN
	SELECT * FROM evidencias EV
	INNER JOIN tareas_mantenimiento TM ON TM.idtm = EV.idtm    
    where TM.idtm = _idtm;
END //

