use gamp;

DROP PROCEDURE IF EXISTS sp_add_notificacion_activo;
DELIMITER $$
CREATE PROCEDURE sp_add_notificacion_activo
(
	IN _idactivo_resp INT,
    IN _tipo	VARCHAR(30),
	IN _mensaje VARCHAR(400),
    IN _idactivo INT
)
BEGIN
	INSERT INTO notificaciones_activos (idactivo_resp, tipo, mensaje, idactivo) VALUES
	 (NULLIF(_idactivo_resp,''), _tipo, _mensaje, NULLIF(_idactivo, ''));
END $$
-- CALL sp_add_notificacion_activo(21, 'Asignacion', 'Te han asignado un activo');

-- crear otra lista para los activos que no tienen usuarios
DROP PROCEDURE IF EXISTS sp_list_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_list_notificacion
(
	IN _idusuario INT
)
BEGIN
	SELECT
		NA.idactivo_resp,
		NA.idnotificacion_activo,
		NA.tipo,
		NA.visto,
		NA.mensaje,
		ACT.descripcion as descripcion_activo,
		RES.descripcion
		FROM notificaciones_activos NA
		INNER JOIN activos_responsables RES ON NA.idactivo_resp = RES.idactivo_resp
		INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        WHERE RES.idusuario = _idusuario
        ORDER BY NA.fecha_creacion;
END $$
-- CALL sp_list_notificacion(3);

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

-- Crear otro SP para las notificaciones_mantenimientos

DROP PROCEDURE IF EXISTS sp_detalle_notificacion_activo;
DELIMITER $$
CREATE PROCEDURE sp_detalle_notificacion_activo (
    IN _idnotificacion_activo INT
)
BEGIN
    SELECT
        ACT.idactivo,
        RES.idactivo_resp,
        ACT.cod_identificacion,
        ACT.descripcion,
        NA.fecha_creacion,
        MAR.marca,
        ACT.modelo,
        RES.condicion_equipo,
        RES.fecha_asignacion,
        UBI.ubicacion
    FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE NA.idnotificacion_activo = _idnotificacion_activo;
END $$
-- CALL sp_detalle_notificacion_activo(4);


