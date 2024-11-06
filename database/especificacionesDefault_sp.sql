USE gamp;

DROP PROCEDURE IF EXISTS sp_default_especificacion;
DELIMITER $$
CREATE PROCEDURE sp_default_especificacion
(
	IN _idsubcategoria INT
)
BEGIN
	SELECT especificaciones FROM 
    especificacionesdefecto 
    WHERE idsubcategoria = _idsubcategoria;
END $$

-- CALL sp_default_especificacion (3)