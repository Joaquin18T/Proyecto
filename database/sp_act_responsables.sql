use gamp;

DROP PROCEDURE IF EXISTS sp_respact_add;
DELIMITER $$
CREATE PROCEDURE sp_respact_add
(
	IN _idactivo INT,
    IN _idusuario INT,
    IN _condicion_equipo VARCHAR(500),
    IN _imagenes	JSON,
    IN _descripcion VARCHAR(500),
    IN _autorizacion INT,
    IN _solicitud INT
)
BEGIN
	INSERT INTO activos_responsables(idactivo, idusuario, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) VALUES
		(_idactivo, _idusuario, _condicion_equipo, _imagenes, _descripcion, _autorizacion, _solicitud);
        
	SELECT last_insert_id() as idresp;
END $$
-- CALL sp_respact_add (2,3,'1', 'En perfectas condiciones', '{"imagen1":"http://nose/que/poner"}', 'equipo de trabajo',1,1);

DROP VIEW IF EXISTS v_activo_resp;
CREATE VIEW v_activo_resp AS
	SELECT 
	  RES.idactivo_resp,
	  ACT.idactivo,
	  ACT.cod_identificacion,
	  ACT.descripcion,
      SUB.subcategoria,
      ACT.modelo,
      MAR.marca,
	  MAX(UBI.ubicacion) ubicacion,
	  ACT.fecha_adquisicion,
	  MAX(RES.condicion_equipo) condicion_equipo,
	  EST.nom_estado,
      RES.autorizacion,
      RES.descripcion despresp,
      ACT.especificaciones,
	  MAX(RES.imagenes) imagenes
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H.idactivo_resp, MAX(H.idubicacion) AS idubicacion
		FROM historial_activos H
		GROUP BY H.idactivo_resp
    )HIS ON HIS.idactivo_resp = RES.idactivo_resp
	INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    WHERE ACT.idestado=1
    GROUP BY ACT.idactivo
    ORDER BY RES.fecha_asignacion DESC;
    
DROP PROCEDURE IF EXISTS sp_search_resp;
DELIMITER $$
CREATE PROCEDURE sp_search_resp
(
	IN _idactivo_resp INT
)
BEGIN
	SELECT * FROM v_activo_resp WHERE idactivo_resp=_idactivo_resp;
END $$
    
DROP PROCEDURE IF EXISTS sp_update_responsable;
DELIMITER $$
CREATE PROCEDURE sp_update_responsable
(
	IN _idactivo_resp INT
)
BEGIN
	UPDATE activos_responsables SET
    es_responsable='1'
    WHERE idactivo_resp=_idactivo_resp;
END $$

DROP PROCEDURE IF EXISTS sp_existe_responsable;
DELIMITER $$
CREATE PROCEDURE sp_existe_responsable
(
	IN _idactivo INT
)
BEGIN
	SELECT COUNT(es_responsable) cantidad FROM
    activos_responsables 
    WHERE idactivo=_idactivo AND es_responsable='1';
END $$

DROP PROCEDURE IF EXISTS sp_max_colaboradores;
DELIMITER $$
CREATE PROCEDURE sp_max_colaboradores
(
	OUT _cantidad INT,
	IN _idactivo INT
)
BEGIN
	DECLARE es_resp INT DEFAULT 0;
    
	SELECT COUNT(idusuario) INTO es_resp 
	FROM activos_responsables 
	WHERE es_responsable = 1 AND idactivo = _idactivo;

    IF es_resp >=1 THEN
		SET _cantidad = -1;
	ELSE
		SELECT COUNT(idusuario) INTO _cantidad 
		FROM activos_responsables
		WHERE idactivo = _idactivo AND es_responsable = 0;
    END IF;
END $$
CALL sp_max_colaboradores(@cantidad, 3);
SELECT @cantidad as cantidad;
DROP PROCEDURE IF EXISTS sp_repeat_responsable;
DELIMITER $$
CREATE PROCEDURE sp_repeat_responsable
(
    IN _idactivo INT,
    IN _idusuario INT
)
BEGIN
    SELECT
	COUNT(idactivo_resp) cantidad,
    USU.usuario
    FROM activos_responsables
    INNER JOIN usuarios USU ON activos_responsables.idusuario = USU.id_usuario
    WHERE idactivo=_idactivo AND idusuario = _idusuario;
END $$

DROP PROCEDURE IF EXISTS sp_ubicacion_activo,
DELIMITER $$
CREATE PROCEDURE  sp_ubicacion_activo
(
	IN _idactivo INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo;
END $$

DROP PROCEDURE IF EXISTS sp_users_by_activo;
DELIMITER $$
CREATE PROCEDURE sp_users_by_activo
(
	IN _idactivo INT
)
BEGIN
	SELECT
	USU.usuario,
    PER.apellidos,
    RES.fecha_asignacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo;
END $$



