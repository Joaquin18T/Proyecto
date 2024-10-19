use gamp;

DROP PROCEDURE IF EXISTS sp_add_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_add_notificacion
(
	IN _idusuario INT,
    IN _tipo	VARCHAR(20),
	IN _mensaje VARCHAR(400)
)
BEGIN
	INSERT INTO notificaciones (idusuario, tipo, mensaje) VALUES
	 (_idusuario, _tipo, _mensaje);
END $$

DROP PROCEDURE IF EXISTS sp_list_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_list_notificacion
(
	IN _idusuario INT,
    IN _idnotificacion INT
)
BEGIN
	SELECT
		NOF.idusuario,
		NOF.idnotificacion,
		NOF.tipo,
		NOF.estado,
		NOF.mensaje,
		NOF.fecha_creacion
    FROM notificaciones NOF
	WHERE 
		(NOF.idusuario = _idusuario OR _idusuario IS NULL) AND
        (NOF.idnotificacion = _idnotificacion OR _idnotificacion IS NULL)
    ORDER BY NOF.fecha_creacion DESC;
END $$
-- CALL sp_list_notificacion(null, 3);

DROP PROCEDURE IF EXISTS sp_responsable_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_responsable_notificacion
(
	IN _idusuario INT
)
BEGIN
	SELECT
    RES.idusuario,
	ACT.descripcion,
    RES.descripcion desresp,
    RES.idactivo_resp
	FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE RES.idusuario = _idusuario
    ORDER BY fecha_asignacion DESC;
END $$



DROP PROCEDURE IF EXISTS sp_detalle_notificacion_resp;
DELIMITER $$
CREATE PROCEDURE sp_detalle_notificacion_resp (
    IN _idusuario INT,
    IN _idactivo_resp INT
)
BEGIN
    SELECT
        ACT.idactivo,
        ACT.cod_identificacion,
        ACT.descripcion,
        MAR.marca,
        ACT.modelo,
        RES.condicion_equipo,
        RES.fecha_asignacion,
        UBI.ubicacion
    FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN historial_activos HIS ON RES.idactivo_resp = HIS.idactivo_resp
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    WHERE RES.idusuario = _idusuario AND RES.idactivo_resp = _idactivo_resp;
END $$



DROP PROCEDURE IF EXISTS sp_detalle_sol_estado
DELIMITER $$
CREATE PROCEDURE sp_detalle_sol_estado
(
	IN _idsolicitud INT
)
BEGIN
	SELECT
		SOL.estado_solicitud,
        SOL.fecha_solicitud,
        ACT.cod_identificacion,
		SUB.subcategoria,
        MAR.marca,
        ACT.descripcion,
        SOL.coment_autorizador
	FROM solicitudes_activos SOL
    INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE (SOL.estado_solicitud='rechazado' OR SOL.estado_solicitud='pendiente') AND
    SOL.idsolicitud=_idsolicitud;
END $$

-- CALL sp_detalle_sol_estado(7);

