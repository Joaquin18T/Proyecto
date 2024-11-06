DROP PROCEDURE IF EXISTS sp_add_historial_activo;
DELIMITER $$
CREATE PROCEDURE sp_add_historial_activo
(
	OUT _idhistorial_activo INT,
	IN _idactivo_resp INT,
    IN _idubicacion INT,
    IN _accion VARCHAR(70),
    IN _responsable_accion INT,
    IN _idactivo INT
)
BEGIN
	DECLARE existe_error INT DEFAULT 0;
    
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO historial_activos(idactivo_resp, idubicacion, accion, responsable_accion, idactivo) VALUES
    (_idactivo_resp, _idubicacion, _accion, _responsable_accion, _idactivo);
    
	IF existe_error= 1 THEN
		SET _idhistorial_activo = -1;
	ELSE
        SET _idhistorial_activo = last_insert_id();
	END IF;
END $$

CALL sp_add_historial_activo(@idhis, 4,2,'Cambio de ubicacion', 1,null);
SELECT @idhis as idhis;