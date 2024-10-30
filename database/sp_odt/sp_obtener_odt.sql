USE gamp;

DROP PROCEDURE IF EXISTS `obtenerTareas`;
DELIMITER //
CREATE PROCEDURE `obtenerTareas`()
BEGIN 
    SELECT 
        TAR.idtarea,
        PT.descripcion AS plantarea,
        TAR.descripcion,
        GROUP_CONCAT(ACT.descripcion SEPARATOR ', ') AS activos, -- Concatenar activos
        TP.tipo_prioridad AS prioridad,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
    FROM tareas TAR
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    INNER JOIN estados EST ON EST.idestado = TAR.idestado
    WHERE PT.eliminado = 0 AND PT.incompleto = 0
    GROUP BY TAR.idtarea; -- Agrupar por tarea
END //
DELIMITER ;


select * from tareas;
-- call obtenerTareas()
-- call registrar_odt(@idordentrabajo,7,2);
-- SELECT @idordentrabajo as idordentrabajo;
-- select * from od;
DROP PROCEDURE IF EXISTS `obtenerTareasPorEstado`
DELIMITER //
CREATE PROCEDURE `obtenerTareasPorEstado`
(
	IN _idestado INT
)
BEGIN
	SELECT 
		TAR.descripcion,
        ACT.descripcion as activo,
        TP.tipo_prioridad,
        EST.nom_estado
        FROM tareas TAR
        INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
        LEFT JOIN estados EST ON EST.idestado = TAR.idestado
        WHERE EST.idestado = _idestado;
END //

select * from detalle_odt;
select * from odt;
DROP PROCEDURE IF EXISTS `obtenerTareasOdt`;
DELIMITER //
CREATE PROCEDURE `obtenerTareasOdt`()
BEGIN
    SELECT 
        ODT.idorden_trabajo,
        GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,
        TAR.descripcion AS tarea,
        ODT.fecha_inicio,
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento,
        CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) as revisado_por,
        TAR.idtarea AS idtarea,
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        EST.nom_estado,
        ODT.incompleto,
        DODT.clasificacion
    FROM odt ODT
    LEFT JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, ODT.fecha_vencimiento, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END //
DELIMITER ;


call obtenerTareasOdt

DROP PROCEDURE IF EXISTS `obtenerTareaDeOdtGenerada`
DELIMITER //
CREATE PROCEDURE `obtenerTareaDeOdtGenerada`
(
	IN _idodt INT
)
BEGIN 
	SELECT 
		ODT.idorden_trabajo,
        PT.descripcion as plantarea,
		TAR.descripcion as tarea,
        TAR.idtarea as idtarea,
        ACT.descripcion as activo,
        ODT.fecha_inicio,
        ODT.hora_inicio,
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento
		from odt ODT
        INNER JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
        INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        INNER JOIN usuarios USU ON USU.id_usuario = ODT.creado_por
        INNER JOIN estados EST ON EST.idestado = ODT.idestado
        WHERE ODT.idorden_trabajo = _idodt;
END //


DROP PROCEDURE IF EXISTS `obtenerEvidenciasDiagnostico`
DELIMITER //
CREATE PROCEDURE `obtenerEvidenciasDiagnostico`
( 
	IN _iddiagnostico INT
)
BEGIN
	SELECT * FROM evidencias_diagnostico WHERE iddiagnostico = _iddiagnostico;
END //

DROP PROCEDURE IF EXISTS `obtenerDiagnostico`
DELIMITER //
CREATE PROCEDURE `obtenerDiagnostico`
( 
    IN _idordentrabajo INT,
    IN _idtipodiagnostico INT
)
BEGIN
	SELECT * FROM diagnosticos
    WHERE idorden_trabajo = _idordentrabajo AND idtipo_diagnostico = _idtipodiagnostico;
END //

select * from detalle_odt;

DROP PROCEDURE IF EXISTS `obtenerDetalleOdt`
DELIMITER //
CREATE PROCEDURE `obtenerDetalleOdt`
( 
    IN _idordentrabajo INT
)
BEGIN
	SELECT * FROM detalle_odt
    WHERE idorden_trabajo = _idordentrabajo;
END //


DROP PROCEDURE IF EXISTS `obtenerOdtporId`
DELIMITER //
CREATE PROCEDURE `obtenerOdtporId`
( 
    IN _idodt INT
)
BEGIN
	SELECT * FROM odt ODT
    INNER JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    WHERE ODT.idorden_trabajo = _idodt;
END //

call obtenerOdtporId(7)

DROP PROCEDURE IF EXISTS `obtenerHistorialOdt`
DELIMITER //
CREATE PROCEDURE `obtenerHistorialOdt`
()
BEGIN
	SELECT 
		ODT.idorden_trabajo,
        DODT.clasificacion,
		CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
		GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,        
        DODT.tiempo_ejecucion,
        DIA.diagnostico,
        
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        
        TAR.descripcion AS tarea,				
        
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) as revisado_por,
        TAR.idtarea AS idtarea,
        TP.tipo_prioridad,
        ODT.fecha_inicio,
        ODT.hora_inicio,
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento,
        
        EST.nom_estado,
        ODT.incompleto

            FROM historial_odt HO
    LEFT JOIN odt ODT ON ODT.idorden_trabajo = HO.idorden_trabajo
    LEFT JOIN diagnosticos DIA ON DIA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
    LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, ODT.fecha_vencimiento, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END //

