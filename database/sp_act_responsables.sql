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


CREATE VIEW v_activo_resp AS
	SELECT 
	  RES.idactivo_resp,
	  ACT.idactivo,
	  ACT.cod_identificacion,
	  ACT.descripcion,
      SUB.subcategoria,
      ACT.modelo,
      MAR.marca,
	  UBI.ubicacion,
	  ACT.fecha_adquisicion,
	  RES.condicion_equipo,
	  EST.nom_estado,
      RES.autorizacion,
      RES.descripcion despresp,
      ACT.especificaciones,
	  RES.imagenes
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp
        )
    )AS UBI ON UBI.idactivo_resp = RES.idactivo_resp

    
DROP PROCEDURE IF EXISTS sp_search_resp;
DELIMITER $$
CREATE PROCEDURE sp_search_resp
(
	IN _idactivo_resp INT
)
BEGIN
	 SELECT 
	  RES.idactivo_resp, RES.condicion_equipo, RES.autorizacion, RES.descripcion despresp, RES.imagenes,
	  ACT.idactivo, ACT.cod_identificacion, ACT.descripcion, ACT.fecha_adquisicion, ACT.modelo, ACT.especificaciones,
      SUB.subcategoria,
      MAR.marca,
	  UBI.ubicacion,
	  EST.nom_estado
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp
        )
    )UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo_resp = _idactivo_resp
    GROUP BY ACT.idactivo;
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
		WHERE idactivo = _idactivo AND es_responsable = 0 AND fecha_designacion IS NULL;
    END IF;
END $$

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
    WHERE idactivo=_idactivo AND idusuario = _idusuario AND fecha_designacion IS NULL;
END $$

DROP PROCEDURE IF EXISTS sp_ubicacion_only_activo;
DELIMITER $$
CREATE PROCEDURE sp_ubicacion_only_activo
(
	IN _idactivo INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo
    ORDER BY HIS.fecha_movimiento desc;
END $$
-- CALL sp_ubicacion_only_activo(12);

DROP PROCEDURE IF EXISTS sp_ubicacion_activo;
DELIMITER $$
CREATE PROCEDURE  sp_ubicacion_activo
(
	IN _idactivo INT,
	IN _idactivo_resp INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo and res.idactivo_resp = _idactivo_resp
    ORDER BY HIS.fecha_movimiento desc
    LIMIT 1;
END $$
-- CALL sp_ubicacion_activo(8,9)
DROP PROCEDURE IF EXISTS sp_users_by_activo;
DELIMITER $$
CREATE PROCEDURE sp_users_by_activo
(
	IN _idactivo INT
)
BEGIN
	SELECT
    USU.id_usuario,
	USU.usuario,
    PER.apellidos,
    RES.idactivo_resp,
    RES.fecha_asignacion,
    RES.fecha_designacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo
    ORDER BY RES.fecha_asignacion DESC;
    -- AND RES.fecha_designacion IS NULL
END $$
-- CALL sp_users_by_activo(6);

DROP PROCEDURE IF EXISTS sp_search_activo_responsable;
DELIMITER $$
CREATE PROCEDURE sp_search_activo_responsable
(
	IN _idsubcategoria	INT,
    IN _idubicacion	    INT,
    IN _cod_identificacion CHAR(40)
)
BEGIN
		SELECT 
	  RES.idactivo_resp,
      ACT.cod_identificacion,
	  ACT.idactivo,
	  ACT.descripcion,
      SUB.subcategoria,
      ACT.modelo,
      MAR.marca,
	  UBI.ubicacion,
	  EST.nom_estado,
      RES.autorizacion
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp 
        )
    )UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE 	(SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL) AND
			(UBI.idubicacion = _idubicacion OR _idubicacion IS NULL) AND
			(ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL) AND 
            ACT.idestado = 1 AND
            -- RES.fecha_designacion IS NULL
            ACT.idestado BETWEEN 1 AND 2
    GROUP BY ACT.idactivo
    ORDER BY RES.idactivo_resp asc;
END $$
-- CALL sp_search_activo_responsable(null, null, null);

DROP PROCEDURE IF EXISTS `sp_filtrar_activos_responsables_asignados`;
DELIMITER $$
CREATE PROCEDURE `sp_filtrar_activos_responsables_asignados`
(
    IN _idsubcategoria INT,
    IN _idubicacion INT,
    IN _cod_identificacion CHAR(40)
)
BEGIN
    SELECT 
        RES.idactivo_resp,
        ACT.cod_identificacion,
        ACT.idactivo,
        ACT.descripcion,
        SUB.subcategoria,
        ACT.modelo,
        MAR.marca,
        UBI.ubicacion,
        EST.nom_estado,
        RES.autorizacion,
        RES.es_responsable,
        USU.id_usuario
    FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    INNER JOIN (
        SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
        FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
            SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp 
        )
    ) UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE 
        (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL) AND
        (UBI.idubicacion = _idubicacion OR _idubicacion IS NULL) AND
        (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL) AND
        ACT.idestado BETWEEN 1 AND 2 AND
        RES.es_responsable = 1
    GROUP BY ACT.idactivo
    ORDER BY RES.idactivo_resp ASC;
END $$
DELIMITER ;
-- CALL sp_filtrar_activos_responsables_asignados(2, null, null);
select * from subcategorias;

DROP PROCEDURE IF EXISTS sp_list_resp_activo;
DELIMITER $$
CREATE PROCEDURE sp_list_resp_activo
(

)
BEGIN
	SELECT R.idactivo_resp, A.descripcion
    FROM activos_responsables R
    INNER JOIN activos A ON R.idactivo = A.idactivo
    WHERE A.idestado >=3 AND A.idestado<=4;
END $$

DROP PROCEDURE IF EXISTS sp_getresp_principal;
DELIMITER $$
CREATE PROCEDURE sp_getresp_principal
(
	IN _idactivo_resp INT,
	IN _idactivo INT
)
BEGIN
	DECLARE isResP INT DEFAULT 0;
    
    SELECT COUNT(*) INTO isResP
    FROM activos_responsables WHERE es_responsable='1'
    AND idactivo =_idactivo AND fecha_designacion IS NULL;
    
    IF isResP>0 THEN
		SELECT 
			RES.idactivo_resp,
			P.apellidos, P.nombres,
			U.usuario
		FROM activos_responsables RES
		INNER JOIN usuarios U ON RES.idusuario = U.id_usuario
		INNER JOIN personas P ON U.idpersona = P.id_persona
		WHERE RES.idactivo = _idactivo AND RES.es_responsable = '1';
	ELSE
		SELECT 
			RES.idactivo_resp,
			P.apellidos, P.nombres,
			U.usuario
		FROM activos_responsables RES
		INNER JOIN usuarios U ON RES.idusuario = U.id_usuario
		INNER JOIN personas P ON U.idpersona = P.id_persona
		WHERE RES.idactivo_resp = _idactivo_resp AND RES.fecha_designacion IS NULL
        ORDER BY RES.fecha_asignacion asc
        LIMIT 1;
	END IF;
END $$
-- CALL sp_getresp_principal(5,4);
-- designacion
DROP PROCEDURE IF EXISTS sp_update_activo_responsable;
DELIMITER $$
CREATE PROCEDURE sp_update_activo_responsable
(
    IN _idactivo_resp INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _autorizacion INT
)
BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
        autorizacion = _autorizacion,
        fecha_designacion = NOW()
	WHERE idactivo_resp = _idactivo_resp;
END $$
-- CALL sp_update_activo_responsable(2, 1, 8, 1);

-- cambiar de responsable principal
DROP PROCEDURE IF EXISTS sp_update_asignacion_principal;
DELIMITER $$
CREATE PROCEDURE sp_update_asignacion_principal
(
    IN _idactivo_resp INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _es_responsable CHAR(1),
    IN _autorizacion INT
)
BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
		es_responsable = _es_responsable,
        autorizacion = _autorizacion
	WHERE idactivo_resp = _idactivo_resp;
END $$
-- CALL sp_update_asignacion_principal(16, 1,7,'0',1);

DROP PROCEDURE IF EXISTS sp_verificar_colaboradores;
DELIMITER $$
CREATE PROCEDURE sp_verificar_colaboradores
(
	IN _idactivo INT
)
BEGIN    
    SELECT COUNT(*) colaboradores
    FROM activos_responsables 
    WHERE idactivo = _idactivo AND fecha_designacion IS NULL;
END $$

-- CALL sp_verificar_colaboradores(7);

DROP PROCEDURE IF EXISTS get_idresp_activo;
DELIMITER $$
CREATE PROCEDURE get_idresp_activo
(
	IN _idactivo INT,
    IN _idusuario INT
)
BEGIN
	SELECT
		idactivo_resp
        FROM activos_responsables 
		WHERE idactivo = _idactivo AND idusuario = _idusuario
        AND fecha_designacion IS NULL;
END $$

DROP PROCEDURE IF EXISTS sp_get_any_idresp;
DELIMITER $$
CREATE PROCEDURE sp_get_any_idresp
(
	IN _idactivo INT
)
BEGIN
	select idactivo_resp FROM activos_responsables 
    WHERE idactivo = _idactivo
    ORDER BY idactivo_resp desc
    LIMIT 1;
END $$
-- CALL sp_get_any_idresp(9);
-- Obtiene la ultima ubicacion del activo sin importar que el usuario se haya designado
DROP PROCEDURE IF EXISTS sp_get_any_ubicacion_activo;
DELIMITER $$
CREATE PROCEDURE sp_get_any_ubicacion_activo
(
	IN _idactivo_resp INT
)
BEGIN
	SELECT idubicacion FROM historial_activos
    WHERE idactivo_resp = _idactivo_resp
    ORDER BY fecha_movimiento DESC
    LIMIT 1;
END $$
-- CALL sp_get_any_ubicacion_activo(10);