USE gamp;

DROP PROCEDURE IF EXISTS `obtenerTareas`
DELIMITER //
CREATE PROCEDURE `obtenerTareas`
()
BEGIN
	SELECT 
		TAR.idtarea,
		PT.descripcion as plantarea,
		TAR.descripcion,
        TAR.fecha_inicio,
        TAR.fecha_vencimiento,
        ACT.descripcion as activo,
        TP.tipo_prioridad as prioridad,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
        FROM tareas TAR
        LEFT JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
        LEFT JOIN estados EST ON EST.idestado = TAR.idestado
        WHERE PT.eliminado = 0 AND PT.incompleto = 0;
END //


DROP PROCEDURE IF EXISTS `obtenerTareasPorEstado`
DELIMITER //
CREATE PROCEDURE `obtenerTareasPorEstado`
(
	IN _idestado INT
)
BEGIN
	SELECT 
		TAR.descripcion,
        TAR.fecha_inicio,
        TAR.fecha_vencimiento,
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

DROP PROCEDURE IF EXISTS `obtenerTareasOdt`
DELIMITER //
CREATE PROCEDURE `obtenerTareasOdt` (
	IN _borrador boolean
)
BEGIN 
    SELECT 
        ODT.idorden_trabajo,
        -- Concatenar los nombres y apellidos de los responsables
        GROUP_CONCAT(CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,
        TAR.descripcion AS tarea,
        TAR.fecha_inicio,
        TAR.fecha_vencimiento,
        CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
        TAR.idtarea AS idtarea,
        ACT.descripcion AS activo,
        EST.nom_estado,
        DODT.clasificacion
    FROM odt ODT
    INNER JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    INNER JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    INNER JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    INNER JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    INNER JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    INNER JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
    INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    INNER JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.clasificacion = EST.idestado 
    WHERE ODT.borrador = _borrador
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, TAR.fecha_inicio, TAR.fecha_vencimiento, PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, ACT.descripcion, EST.nom_estado;
END //

call obtenerTareasOdt(0);

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
        ACT.descripcion as activo
		from odt ODT
        INNER JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
        INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        INNER JOIN usuarios USU ON USU.id_usuario = ODT.creado_por
        INNER JOIN estados EST ON EST.idestado = ODT.idestado
        WHERE ODT.idorden_trabajo = _idodt;
END //

call obtenerTareaDeOdtGenerada(1)

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

select * from diagnosticos;