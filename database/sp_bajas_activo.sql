use gamp;

-- 10/10
DROP PROCEDURE IF EXISTS sp_add_baja_activo;
DELIMITER $$
CREATE PROCEDURE sp_add_baja_activo
(
   OUT _idbaja_activo INT,
   IN  _idactivo INT,
   IN  _motivo VARCHAR(250),
   IN  _coment_adicionales VARCHAR(250),
   IN _ruta_doc VARCHAR(250),
   IN  _aprobacion INT
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET existe_error = 1;
	END;

     INSERT INTO bajas_activo(idactivo, motivo, coment_adicionales, ruta_doc, aprobacion) VALUES
     (_idactivo, _motivo, NULLIF(_coment_adicionales,''), _ruta_doc, _aprobacion);

     IF existe_error = 1 THEN
		SET _idbaja_activo = -1;
     ELSE
		SET _idbaja_activo = last_insert_id();
     END IF;
END $$

CALL sp_add_baja_activo(@idbaja, 1, 'Sobre calentamiento frecuente', null, 'localhost/CMMS/uploads/archiv1.pdf', 1);
SELECT @idbaja;

DROP VIEW IF EXISTS v_activos_list;
CREATE VIEW v_activos_list
AS
	SELECT
		ACT.idactivo, ACT.cod_identificacion, ACT.modelo, ACT.fecha_adquisicion, ACT.especificaciones,
        SUB.subcategoria,
        MAR.marca
	FROM activos ACT
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca 
    WHERE idestado!=4 AND idestado=3;
    
DROP PROCEDURE IF EXISTS sp_activos_sin_servicio;
DELIMITER $$
CREATE PROCEDURE sp_activos_sin_servicio
(
    IN _fecha_adquisicion DATE,
    IN _idestado INT
)
BEGIN
	SELECT
		ACT.idactivo,
        ACT.fecha_adquisicion,
        ACT.cod_identificacion,
        ACT.descripcion,
        (SELECT CONCAT(U.usuario,'|', P.apellidos, ' ', P.nombres) FROM usuarios U
        INNER JOIN personas P ON u.idpersona = P.id_persona WHERE
        U.id_usuario = RES.idusuario AND RES.es_responsable='1') as dato,
        UBI.ubicacion
	FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    RIGHT JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    AND (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL)
    WHERE EST.idestado >1 AND EST.idestado<5 AND EST.idestado !=4;
END $$

