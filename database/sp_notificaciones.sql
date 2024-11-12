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
-- CALL sp_add_notificacion_activo(10, 'Baja Activo', 'Un activo que te asignaron, le dieron de baja');

-- crear otra lista para los activos que no tienen usuarios
DROP PROCEDURE IF EXISTS sp_list_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_list_notificacion
(
	IN _idusuario INT
)
BEGIN
SELECT 
    NA.idnotificacion_activo AS idnotificacion, 
    NA.tipo AS tipo_notificacion, 
    NA.mensaje, 
    NA.fecha_creacion, 
    NA.visto,
    A.descripcion AS descripcion_activo,
    AR.idactivo_resp,
    U.usuario AS usuario_nombre
FROM 
    notificaciones_activos NA
INNER JOIN 
    activos_responsables AR ON NA.idactivo_resp = AR.idactivo_resp
INNER JOIN 
    activos A ON AR.idactivo = A.idactivo
INNER JOIN 
    usuarios U ON AR.idusuario = U.id_usuario
WHERE U.id_usuario = _idusuario  -- Especifica aquí el usuario

UNION ALL

SELECT 
    NM.idnotificacion_mantenimiento AS idnotificacion, 
    'Mantenimiento' AS tipo_notificacion,  -- Etiqueta fija para diferenciar el tipo
    NM.mensaje, 
    NM.fecha_creacion, 
    NM.visto, 
    NM.activos AS descripcion_activo, 
    NM.idresp as idactivo_resp,
    U.usuario AS usuario_nombre
FROM 
    notificaciones_mantenimiento NM
INNER JOIN 
    usuarios U ON NM.idresp = U.id_usuario  -- Ahora usamos idresp directamente en la relación con usuarios
WHERE U.id_usuario = _idusuario -- Especifica aquí el mismo usuario
ORDER BY 
    fecha_creacion DESC;
END $$
-- CALL sp_list_notificacion(2);

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

DROP PROCEDURE IF EXISTS sp_detalle_orden_trabajo;
DELIMITER $$
CREATE PROCEDURE sp_detalle_orden_trabajo 
(
    IN _idnotificacion_mantenimiento INT
)
BEGIN
    SELECT
		NM.tarea, NM.fecha_creacion, NM.activos,
        ODT.creado_por,
        T.descripcion as descripcionT, T.fecha_inicio, T.fecha_vencimiento, T.cant_intervalo, T.frecuencia,T.create_at,
        TP.tipo_prioridad,
        PT.descripcion as descripcionPT
    FROM notificaciones_mantenimiento NM
    INNER JOIN odt ODT ON NM.idorden_trabajo = ODT.idorden_trabajo
    INNER JOIN tareas T ON ODT.idtarea = ODT.idtarea
    INNER JOIN tipo_prioridades TP ON T.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN plandetareas PT ON T.idplantarea = PT.idplantarea
    WHERE NM.idnotificacion_mantenimiento = _idnotificacion_mantenimiento
    ORDER BY T.create_at DESC
    LIMIT 1;
END $$
-- CALL sp_detalle_orden_trabajo(1);

-- ASIGNACION 
DROP PROCEDURE IF EXISTS sp_detalle_asignacion_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_detalle_asignacion_notificacion (
    IN _idnotificacion_activo INT
)
BEGIN
    SELECT
        ACT.idactivo,ACT.cod_identificacion,ACT.descripcion, ACT.modelo,
        RES.idactivo_resp, RES.descripcion as des_responsable,RES.condicion_equipo,RES.fecha_asignacion,RES.autorizacion,
        NA.fecha_creacion,
        MAR.marca,
        SUB.subcategoria,
        UBI.ubicacion
    FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    WHERE NA.idnotificacion_activo =_idnotificacion_activo
    ORDER BY HIS.fecha_movimiento DESC
    LIMIT 1;
END $$

-- CALL sp_detalle_asignacion_notificacion(48);

-- DESIGNACION
DROP PROCEDURE IF EXISTS sp_notificacion_designacion_detalle;
DELIMITER $$
CREATE PROCEDURE sp_notificacion_designacion_detalle
(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		NA.idnotificacion_activo, NA.fecha_creacion,
        ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
        SUB.subcategoria, MAR.marca,
        RES.fecha_designacion, RES.es_responsable, RES.idactivo_resp,
        UBI.ubicacion, HA.responsable_accion
        FROM historial_activos HA
        INNER JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
        INNER JOIN activos_responsables RES ON HA.idactivo_resp =RES.idactivo_resp
        INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
        INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
        WHERE NA.idnotificacion_activo = _idnotificacion_activo AND RES.fecha_designacion IS NOT NULL
        ORDER BY HA.fecha_movimiento DESC;
END $$
-- CALL sp_notificacion_designacion_detalle(4);

DROP PROCEDURE IF EXISTS sp_notificacion_baja_detalle;
DELIMITER $$
CREATE PROCEDURE sp_notificacion_baja_detalle
(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		NA.idnotificacion_activo,RES.idactivo_resp,
		ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
        MAR.marca,
        SUB.subcategoria,
        BA.fecha_baja, BA.motivo, BA.aprobacion, BA.coment_adicionales,
        UBI.ubicacion,
        NA.fecha_creacion
        FROM historial_activos HA
        INNER JOIN activos_responsables RES ON HA.idactivo_resp = RES.idactivo_resp
        INNER JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
        INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
        INNER JOIN notificaciones_activos NA ON ACT.idactivo = NA.idactivo
        INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        INNER JOIN bajas_activo BA ON ACT.idactivo = BA.idactivo
        WHERE NA.idnotificacion_activo = _idnotificacion_activo 
			  AND RES.fecha_designacion IS NULL
        ORDER BY HA.fecha_movimiento DESC
        LIMIT 1; -- probar cuando el usuario no es responsable p 
END $$
-- CALL sp_notificacion_baja_detalle(58);

DROP PROCEDURE IF EXISTS sp_detalle_ubicacion_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_detalle_ubicacion_notificacion
(
	IN _idnotificacion_activo INT
)
BEGIN 
		SELECT 
			ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
			MAR.marca,
            SUB.subcategoria,
            U.ubicacion,
            HA.fecha_movimiento, HA.responsable_accion,
            NA.fecha_creacion
            FROM historial_activos HA
            INNER JOIN ubicaciones U ON HA.idubicacion = U.idubicacion
            INNER JOIN activos_responsables AR ON HA.idactivo_resp = AR.idactivo_resp
            INNER JOIN activos ACT ON AR.idactivo = ACT.idactivo
            INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
            INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
            INNER JOIN notificaciones_activos NA ON AR.idactivo_resp = NA.idactivo_resp
            
            WHERE NA.idnotificacion_activo = _idnotificacion_activo
            ORDER BY HA.fecha_movimiento DESC
            LIMIT 1;
END $$
-- CALL sp_detalle_ubicacion_notificacion(60)
DROP PROCEDURE IF EXISTS sp_responsable_principal_detalle_notificacion;
DELIMITER $$
CREATE PROCEDURE sp_responsable_principal_detalle_notificacion
(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
		MAR.marca,
		SUB.subcategoria,
        HA.fecha_movimiento, HA.responsable_accion,
        NA.fecha_creacion,
        AR.fecha_asignacion
        FROM historial_activos HA
		INNER JOIN activos_responsables AR ON HA.idactivo_resp = AR.idactivo_resp
		INNER JOIN activos ACT ON AR.idactivo = ACT.idactivo
		INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
		INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
		INNER JOIN notificaciones_activos NA ON AR.idactivo_resp = NA.idactivo_resp
        WHERE NA.idnotificacion_activo = _idnotificacion_activo
        ORDER BY HA.fecha_movimiento DESC
        LIMIT 1;
END $$
-- CALL sp_responsable_principal_detalle_notificacion(42);

DROP PROCEDURE IF EXISTS sp_list_notificacion_wh_idactivo_resp;
DELIMITER $$
CREATE PROCEDURE sp_list_notificacion_wh_idactivo_resp
(
	IN _idaccion_responsable INT
)
BEGIN
	SELECT 
		NA.idnotificacion_activo, NA.tipo, NA.visto, NA.mensaje, NA.fecha_creacion,
		ACT.idactivo, ACT.descripcion, NA.idactivo_resp
	FROM notificaciones_activos NA
	LEFT JOIN activos ACT ON NA.idactivo = ACT.idactivo
	LEFT JOIN historial_activos HA ON ACT.idactivo = HA.idactivo
	WHERE NA.idactivo_resp IS NULL 
	  AND HA.responsable_accion IS NOT NULL
	  AND HA.responsable_accion = 1; 
END $$
-- CALL sp_list_notificacion_wh_idactivo_resp(6);

DROP PROCEDURE IF EXISTS sp_detalle_notificacion_baja_wh_idactivo_resp;
DELIMITER $$
CREATE PROCEDURE sp_detalle_notificacion_baja_wh_idactivo_resp
(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT 
		NA.idnotificacion_activo, NA.tipo, NA.visto, NA.mensaje, NA.fecha_creacion,
		ACT.idactivo, ACT.descripcion, ACT.cod_identificacion, ACT.modelo,
        SUB.subcategoria,
        MAR.marca,
        BA.fecha_baja, BA.motivo, BA.coment_adicionales, BA.aprobacion,
        UBI.ubicacion,
		HA.responsable_accion, HA.fecha_movimiento
	FROM notificaciones_activos NA
	LEFT JOIN activos ACT ON NA.idactivo = ACT.idactivo
    LEFT JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    LEFT JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	LEFT JOIN historial_activos HA ON ACT.idactivo = HA.idactivo
    LEFT JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
    LEFT JOIN bajas_activo BA ON ACT.idactivo = BA.idactivo
	WHERE NA.idactivo_resp IS NULL 
	  AND HA.responsable_accion IS NOT NULL
      AND NA.idnotificacion_activo = _idnotificacion_activo;
END $$

-- CALL sp_detalle_notificacion_baja_wh_idactivo_resp(58);