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
        ACT.idactivo,
		ACT.descripcion as descripcion_activo,
		RES.descripcion,
        NA.fecha_creacion
		FROM notificaciones_activos NA
		INNER JOIN activos_responsables RES ON NA.idactivo_resp = RES.idactivo_resp
		INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        WHERE RES.idusuario = 5
        ORDER BY NA.fecha_creacion asc;
END $$
-- CALL sp_list_notificacion(5);
DROP PROCEDURE IF EXISTS sp_list_notificacion_mantenimiento;
DELIMITER $$
CREATE PROCEDURE sp_list_notificacion_mantenimiento
(
	IN _idusuario INT
)
BEGIN
	SELECT
		*
		FROM notificaciones_mantenimiento
        WHERE idresp = _idusuario;
END $$

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
DROP PROCEDURE IF EXISTS `agregarNotificacionOdt`;
DELIMITER $$
CREATE PROCEDURE `agregarNotificacionOdt` (
	OUT _idnotificacion_mantenimiento INT,
    IN _idorden_trabajo INT,
    IN _tarea			VARCHAR(100),
    IN _activos			TEXT,
    IN _idresp			INT,
    IN _mensaje			VARCHAR(250)
)
BEGIN
	-- Declaración de variable de control de error
	DECLARE existe_error INT DEFAULT 0;

	-- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET existe_error = 1;
		END;
        
	INSERT INTO notificaciones_mantenimiento (idorden_trabajo, tarea, activos,idresp, mensaje) values
	(_idorden_trabajo, _tarea, _activos, _idresp , _mensaje);
    
    IF existe_error = 1 THEN
		SET _idnotificacion_mantenimiento = -1;
	ELSE
		SET _idnotificacion_mantenimiento = LAST_INSERT_ID();
	END IF;
END $$

DROP PROCEDURE IF EXISTS `buscarNotificacionPorOdt`;
DELIMITER $$
CREATE PROCEDURE `buscarNotificacionPorOdt` (
    IN _idodt INT
)
BEGIN
    SELECT
        *
    FROM notificaciones_mantenimiento NM
    INNER JOIN odt ODT ON ODT.idorden_trabajo = 12;    
END $$

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
    WHERE NA.idnotificacion_activo =_idnotificacion_activo;
END $$
-- CALL sp_detalle_notificacion_activo(8);


