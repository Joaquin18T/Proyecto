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
    MAX(NOF.fecha_creacion) AS fecha_creacion, -- Usamos MAX o alguna función agregada
    RES.idusuario,
    ACT.descripcion,
    RES.descripcion AS desresp,
    RES.idactivo_resp
FROM notificaciones NOF
RIGHT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
	where 
		(NOF.idusuario = _idusuario OR _idusuario IS NULL) 
        AND (NOF.idnotificacion = _idnotificacion OR _idnotificacion IS NULL)
GROUP BY 
    NOF.idusuario,
    NOF.idnotificacion,
    NOF.tipo,
    NOF.estado,
    NOF.mensaje,
    RES.idusuario,
    ACT.descripcion,
    RES.descripcion,
    RES.idactivo_resp
ORDER BY MAX(NOF.fecha_creacion) DESC;
END $$
-- CALL sp_list_notificacion(2,null);

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
    RES.idactivo_resp,
    RES.fecha_asignacion
	FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE RES.idusuario = _idusuario
    ORDER BY RES.idactivo_resp DESC;
END $$

CALL sp_responsable_notificacion(2);

DROP PROCEDURE IF EXISTS sp_detalle_notificacion_resp;
DELIMITER $$
CREATE PROCEDURE sp_detalle_notificacion_resp (
    IN _idusuario INT,
    IN _idactivo_resp INT
)
BEGIN
    SELECT
        ACT.idactivo,
        RES.idactivo_resp,
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
    WHERE RES.idusuario = _idusuario AND RES.idactivo_resp = _idactivo_resp
    ORDER BY HIS.fecha_movimiento DESC;
END $$
CALL sp_detalle_notificacion_resp(2, 18);

-- no se usa
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

DROP PROCEDURE IF EXISTS sp_notificacion_designacion;
DELIMITER $$
CREATE PROCEDURE sp_notificacion_designacion
(

)
BEGIN

END $$
