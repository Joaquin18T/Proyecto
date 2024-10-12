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
	IN _idusuario INT
)
BEGIN
	SELECT 
		NOF.idnotificacion,
		NOF.tipo,
        NOF.estado,
		NOF.mensaje,
        NOF.fecha_creacion,
        RES.descripcion desresp,
        ACT.descripcion
    FROM notificaciones NOF
    LEFT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
    LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE NOF.idusuario = _idusuario
    ORDER BY NOF.fecha_creacion DESC;
END $$
-- CALL sp_list_notificacion(2);

DROP PROCEDURE IF EXISTS sp_detalle_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_detalle_notificacion
(
	IN _idnotificacion INT
)
BEGIN
	SELECT
		NOF.mensaje,
        NOF.fecha_creacion,
        NOF.tipo,
        ACT.descripcion,
        MAR.marca,
        ACT.modelo,
        ACT.cod_identificacion,
        RES.condicion_equipo,
        RES.fecha_asignacion,
        UBI.ubicacion
        FROM notificaciones NOF
        LEFT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
        LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
        LEFT JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        LEFT JOIN historial_activos HIS ON RES.idactivo_resp = HIS.idactivo_resp
        LEFT JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
        WHERE NOF.idnotificacion = _idnotificacion;
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

