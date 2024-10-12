use gamp;

-- 10/10
DROP PROCEDURE IF EXISTS sp_add_baja_activo;
DELIMITER $$
CREATE PROCEDURE sp_add_baja_activo
(
   OUT _idbaja_activo INT,
   IN  _idactivo INT,
   IN  _motivo VARCHAR(200),
   IN  _aprobación INT
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
         BEGIN
            SET existe_error = 1;
         END;

     INSERT INTO bajas_activo(idactivo, motivo, aprobacion) VALUES
     (_idactivo, _motivo, _aprobación);

     IF existe_error = 1 THEN
		SET _idbaja_activo = -1;
     ELSE
		SET _idbaja_activo = last_insert_id();
     END IF;
END $$

DROP PROCEDURE IF EXISTS sp_list_activos_baja;
DELIMITER $$
CREATE PROCEDURE sp_list_activos_baja
(
	
)
BEGIN
	SELECT
		ACT.idactivo, ACT.cod_identificacion, ACT.modelo, ACT.fecha_adquisicion, ACT.especificaciones,
        SUB.subcategoria,
        MAR.marca
	FROM activos ACT
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca 
    WHERE idestado!=4;
END $$
-- EN LA TABLA PONER LA OPCION DE CUALES SON LOS RESPONSABLES DE CADA ACTIVO