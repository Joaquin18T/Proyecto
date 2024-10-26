-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-10-2024 a las 06:07:40
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gamp`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarActivoPorTarea` (IN `_idactivo_vinculado` INT, IN `_idactivo` INT, IN `_idtarea` INT)   BEGIN
    UPDATE activos_vinculados_tarea 
    SET idactivo = _idactivo, 
        idtarea = _idtarea, 
        update_at = NOW()
    WHERE idactivo_vinculado = _idactivo_vinculado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarBorradorOdt` (IN `_idorden_trabajo` INT, IN `_borrador` INT)   BEGIN
	UPDATE odt SET
    incompleto = _borrador
    WHERE idorden_trabajo = _idorden_trabajo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarDetalleOdt` (IN `_iddetalleodt` INT, IN `_fechafinal` DATETIME, IN `_tiempoejecucion` TIME, IN `_clasificacion` INT)   BEGIN
	UPDATE detalle_odt SET
    fecha_final = _fechafinal,
    tiempo_ejecucion = _tiempoejecucion,
    clasificacion = _clasificacion
    WHERE iddetalleodt = _iddetalleodt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarDiagnosticoOdt` (IN `_iddiagnostico` INT, IN `_diagnostico` VARCHAR(300))   BEGIN
	UPDATE diagnosticos SET
    diagnostico = _diagnostico
    WHERE iddiagnostico = _iddiagnostico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarPlanDeTareas` (IN `_idplantarea` INT, IN `_descripcion` VARCHAR(80), IN `_incompleto` BOOLEAN)   BEGIN
    UPDATE plandetareas 
    SET descripcion = _descripcion,
		incompleto = _incompleto, 
        update_at = NOW()
    WHERE idplantarea = _idplantarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarTarea` (IN `_idtarea` INT, IN `_idtipo_prioridad` INT, IN `_descripcion` VARCHAR(200), IN `_fecha_inicio` DATETIME, IN `_fecha_vencimiento` DATETIME, IN `_cant_intervalo` INT, IN `_frecuencia` VARCHAR(10), IN `_idestado` INT)   BEGIN
    UPDATE tareas 
    SET 
		idtipo_prioridad = _idtipo_prioridad,
		descripcion = _descripcion,
        fecha_inicio = _fecha_inicio,
        fecha_vencimiento = _fecha_vencimiento,
        cant_intervalo = _cant_intervalo, 
        frecuencia = _frecuencia,
        idestado = _idestado, 
        update_at = NOW()
    WHERE idtarea = _idtarea;
    
    SELECT MAX(idtarea) as idactualizado FROM tareas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarTareaEstado` (IN `_idtarea` INT, IN `_idestado` INT)   BEGIN
	UPDATE tareas 
    SET idestado = _idestado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarResponsables` (OUT `_idresponsable_asignado` INT, IN `_idorden_trabajo` INT, IN `_idresponsable` INT)   BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
	INSERT INTO responsables_asignados_odt (idorden_trabajo, idresponsable) values
		(_idorden_trabajo, _idresponsable);
        
	IF existe_error = 1 THEN
		SET _idresponsable_asignado = -1;
	ELSE
        SET _idresponsable_asignado = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarResponsablesODT` (IN `_idorden_trabajo` INT, IN `_idresponsable` INT)   BEGIN
	INSERT INTO responsables_asignados_odt (idorden_trabajo, idresponsable)
		VALUES (_idorden_trabajo, _idresponsable);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarActivosVinculadosTarea` (IN `_idactivovinculado` INT)   BEGIN
	DELETE FROM activos_vinculados_tarea WHERE idactivo_vinculado = _idactivovinculado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarEvidenciaOdt` (IN `_idevidencias_diagnostico` INT)   BEGIN
	DELETE FROM evidencias_diagnostico WHERE idevidencias_diagnostico = _idevidencias_diagnostico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarOdt` (IN `_idorden_trabajo` INT)   BEGIN
	DELETE FROM odt WHERE idorden_trabajo = _idorden_trabajo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarPlanDeTarea` (IN `_idplantarea` INT, IN `_eliminado` BOOLEAN)   BEGIN
	-- DELETE FROM plandetareas WHERE idplantarea = _idplantarea;
    UPDATE plandetareas 
    SET 
		eliminado = _eliminado,
        update_at = NOW()
    WHERE idplantarea = _idplantarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarResponsableOdt` (IN `_idresponsable_asignado` INT)   BEGIN
	DELETE FROM responsables_asignados_odt WHERE idresponsable_asignado = _idresponsable_asignado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarTarea` (IN `_idtarea` INT)   BEGIN
	DELETE FROM tareas WHERE idtarea = _idtarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarActivoPorTarea` (OUT `_idactivo_vinculado` INT, IN `_idactivo` INT, IN `_idtarea` INT)   BEGIN
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO activos_vinculados_tarea (idactivo, idtarea)
    VALUES (_idactivo, _idtarea);
    
    IF existe_error = 1 THEN
		SET _idactivo_vinculado = -1;
	ELSE
        SET _idactivo_vinculado = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarPlanDeTareas` (OUT `_idplantarea` INT, IN `_descripcion` VARCHAR(30))   BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO plandetareas (descripcion, incompleto)
    VALUES (_descripcion, true);
    
    IF existe_error = 1 THEN
		SET _idplantarea = -1;
	ELSE
        SET _idplantarea = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarTarea` (OUT `_idtarea` INT, IN `_idplantarea` INT, IN `_idtipo_prioridad` INT, IN `_descripcion` VARCHAR(200), IN `_fecha_inicio` DATE, IN `_fecha_vencimiento` DATE, IN `_cant_intervalo` INT, IN `_frecuencia` VARCHAR(10), IN `_idestado` INT)   BEGIN
-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
        
    INSERT INTO tareas (
        idplantarea, idtipo_prioridad, descripcion,
        fecha_inicio, fecha_vencimiento, cant_intervalo, frecuencia, idestado
    )
    VALUES (
        _idplantarea, _idtipo_prioridad, _descripcion,
        _fecha_inicio, _fecha_vencimiento, _cant_intervalo, _frecuencia, _idestado
    );
    
    IF existe_error = 1 THEN
		SET _idtarea = -1;
	ELSE
        SET _idtarea = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listarActivosPorTareaYPlan` (IN `p_idplantarea` INT)   BEGIN
  -- Listar todos los activos vinculados a cada tarea del plan de tareas
  SELECT 
	avt.idactivo_vinculado,
    pt.descripcion AS descripcion_plan,
    t.idtarea,
    t.descripcion AS descripcion_tarea,
    a.idactivo,
    a.descripcion
  FROM
    plandetareas pt
    INNER JOIN tareas t ON pt.idplantarea = t.idplantarea
    INNER JOIN activos_vinculados_tarea avt ON t.idtarea = avt.idtarea
    INNER JOIN activos a ON avt.idactivo = a.idactivo
  WHERE
    pt.idplantarea = p_idplantarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerActivos` (IN `_idcategoria` INT)   BEGIN
	SELECT ACT.idactivo, ACT.descripcion as activo, ACT.cod_identificacion ,CAT.categoria, SUB.subcategoria, MAR.marca, ACT.modelo FROM activos ACT 
    INNER JOIN subcategorias SUB ON SUB.idsubcategoria = ACT.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE CAT.idcategoria = _idcategoria
    ORDER BY ACT.idactivo DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerActivosPorTarea` (IN `_idtarea` INT)   BEGIN
	SELECT ACTV.idactivo_vinculado, SCAT.subcategoria, MAR.marca, ACT.modelo FROM activos_vinculados_tarea ACTV
    INNER JOIN activos ACT ON ACTV.idactivo = ACT.idactivo
    INNER JOIN subcategorias SCAT ON ACT.idsubcategoria = SCAT.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE ACTV.idtarea = _idtarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerDetalleOdt` (IN `_idordentrabajo` INT)   BEGIN
	SELECT * FROM detalle_odt
    WHERE idorden_trabajo = _idordentrabajo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerDiagnostico` (IN `_idordentrabajo` INT, IN `_idtipodiagnostico` INT)   BEGIN
	SELECT * FROM diagnosticos
    WHERE idorden_trabajo = _idordentrabajo AND idtipo_diagnostico = _idtipodiagnostico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerEvidenciasDiagnostico` (IN `_iddiagnostico` INT)   BEGIN
	SELECT * FROM evidencias_diagnostico WHERE iddiagnostico = _iddiagnostico;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerPlanTareaPorId` (IN `_idplantarea` INT)   BEGIN 
	SELECT 
        idplantarea, 
        descripcion,
        incompleto
    FROM plandetareas
    WHERE idplantarea = _idplantarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerPlantareasDetalles` (IN `_eliminado` INT)   BEGIN 
SELECT PT.idplantarea, 
       PT.descripcion, 
       COUNT(DISTINCT TAR.idtarea) AS tareas_totales, 
       COUNT(DISTINCT AV.idactivo_vinculado) AS activos_vinculados,
       PT.incompleto
       FROM plandetareas PT
LEFT JOIN tareas TAR ON TAR.idplantarea = PT.idplantarea
LEFT JOIN activos_vinculados_tarea AV ON AV.idtarea = TAR.idtarea
WHERE PT.eliminado = _eliminado
GROUP BY PT.idplantarea, PT.descripcion
ORDER BY PT.idplantarea DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerResponsables` (IN `_idodt` INT)   BEGIN
	SELECT 
		RODT.idorden_trabajo,
		RODT.idresponsable,
        RODT.idresponsable_asignado,
        CONCAT(PER.apellidos,' ',PER.nombres) as nombres
    FROM responsables_asignados_odt RODT 
	INNER JOIN usuarios USU ON USU.id_usuario = RODT.idresponsable
    INNER JOIN personas PER ON PER.id_persona = USU.idpersona
	WHERE idorden_trabajo = _idodt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerResponsablesPorOdt` (IN `_idorden_trabajo` INT)   BEGIN
	SELECT 
		RA.idresponsable_asignado, RA.idorden_trabajo, RA.idresponsable,
        USU.usuario
		FROM responsables_asignados_odt RA
	INNER JOIN usuarios USU ON USU.idusuario = RA.idresponsable
    WHERE idorden_trabajo = _idorden_trabajo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareaDeOdtGenerada` (IN `_idodt` INT)   BEGIN 
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareaPorId` (IN `_idtarea` INT)   BEGIN
	SELECT * FROM tareas WHERE idtarea = _idtarea;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareas` ()   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasOdt` (IN `_borrador` BOOLEAN)   BEGIN 
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
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo -- Unión corregida
    WHERE ODT.eliminado = _borrador
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, TAR.fecha_inicio, TAR.fecha_vencimiento, PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, ACT.descripcion, EST.nom_estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasPorEstado` (IN `_idestado` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasPorPlanTarea` (IN `_idplantarea` INT)   BEGIN
	SELECT TAR.idtarea, PT.descripcion as plan_tarea, TP.tipo_prioridad, TAR.descripcion, TAR.cant_intervalo, TAR.frecuencia ,ES.nom_estado FROM tareas TAR
    INNER JOIN plandetareas PT ON TAR.idplantarea = PT.idplantarea -- quitar esta linea luego pq no es necesario mostrar el plan de tareas al que pertenece
    INNER JOIN tipo_prioridades TP ON TAR.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN estados ES ON TAR.idestado = ES.idestado
    WHERE TAR.idplantarea = _idplantarea ORDER BY TAR.idtarea DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerUnActivoVinculadoAtarea` (IN `_idactivo_vinculado` INT)   BEGIN
	SELECT AVT.idactivo_vinculado, AVT.idactivo, AVT.idtarea, ACT.descripcion ,SUB.subcategoria FROM activos_vinculados_tarea AVT
    INNER JOIN activos ACT ON AVT.idactivo = ACT.idactivo
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    where AVT.idactivo_vinculado = _idactivo_vinculado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerUsuario` (IN `_idusuario` INT)   BEGIN
	SELECT  * FROM usuarios WHERE idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarDetalleOdt` (OUT `_iddetalleodt` INT, IN `_idorden_trabajo` INT, IN `_clasificacion` INT)   BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO detalle_odt (idorden_trabajo, clasificacion)	
		VALUES (_idorden_trabajo, _clasificacion);
        
	IF existe_error = 1 THEN
		SET _iddetalleodt = -1;
	ELSE
        SET _iddetalleodt = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarDiagnostico` (OUT `_iddiagnostico` INT, IN `_idorden_trabajo` INT, IN `_idtipo_diagnostico` INT, IN `_diagnostico` VARCHAR(300))   BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO diagnosticos (idorden_trabajo, idtipo_diagnostico, diagnostico)
		VALUES (_idorden_trabajo, _idtipo_diagnostico, _diagnostico);
        
	IF existe_error = 1 THEN
		SET _iddiagnostico = -1;
	ELSE
        SET _iddiagnostico = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarEvidenciaDiagnostico` (IN `_iddiagnostico` INT, IN `_evidencia` VARCHAR(80))   BEGIN
	INSERT INTO evidencias_diagnostico (iddiagnostico, evidencia)
		VALUES (_iddiagnostico, _evidencia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarHistorial` (IN `_idorden_trabajo` INT, IN `_estado_anterior` INT, IN `_estado_nuevo` INT, IN `_comentario` TEXT, IN `_devuelto` BOOLEAN)   BEGIN
	INSERT INTO historial_estado_odt (idorden_trabajo, estado_anterior, estado_nuevo, comentario, devuelto)	
		VALUES (_idorden_trabajo, _estado_anterior, _estado_nuevo, _comentario, NULLIF(_devuelto, ""));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_odt` (OUT `_idorden_trabajo` INT, IN `_idtarea` INT, IN `_creado_por` INT)   BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO odt (idtarea, creado_por)
		VALUES (_idtarea, _creado_por);
        
	IF existe_error = 1 THEN
		SET _idorden_trabajo = -1;
	ELSE
        SET _idorden_trabajo = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchby_code` (IN `_cod_identificacion` CHAR(40))   BEGIN
	SELECT modelo FROM activos WHERE cod_identificacion = _cod_identificacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activos_sin_servicio` (IN `_fecha_adquisicion` DATE, IN `_idestado` INT, IN `_cod_identificacion` CHAR(40))   BEGIN
	SELECT distinct
		ACT.idactivo,
        ACT.fecha_adquisicion,
        ACT.cod_identificacion,
        EST.nom_estado,
        ACT.descripcion,
        (SELECT CONCAT(U.usuario,'|', P.apellidos, ' ', P.nombres) FROM usuarios U
        INNER JOIN personas P ON u.idpersona = P.id_persona WHERE
        U.id_usuario = RES.idusuario AND RES.es_responsable='1') as dato,
        UBI.ubicacion
	FROM historial_activos HIS
	INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
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
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    WHERE  (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL) AND
    (ACT.cod_identificacion LIKE CONCAT('%',_cod_identificacion,'%') OR _cod_identificacion IS NULL) AND
	EST.idestado >1 AND EST.idestado<5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_activo` (OUT `_idactivo` INT, IN `_idsubcategoria` INT, IN `_idmarca` INT, IN `_modelo` VARCHAR(60), IN `_cod_identificacion` CHAR(40), IN `_fecha_adquisicion` DATE, IN `_descripcion` VARCHAR(200), IN `_especificaciones` JSON)   BEGIN
	DECLARE existe_error INT DEFAULT 0;
    -- DECLARE repetido_cod INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
        SET existe_error = 1;
	END;
    
	INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones) VALUES
		(_idsubcategoria, _idmarca, _modelo, _cod_identificacion, _fecha_adquisicion, _descripcion, _especificaciones);
        
	-- SELECT cod_identificacion INTO repetido_cod
	-- FROM activos;
	-- IF repetido_cod = _cod_identificacion THEN
	-- 	SET _idactivo = -2;
	-- END IF;
    
    IF existe_error= 1 THEN
		SET _idactivo = -1;
	ELSE
        SET _idactivo = last_insert_id();
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_baja_activo` (OUT `_idbaja_activo` INT, IN `_idactivo` INT, IN `_motivo` VARCHAR(250), IN `_coment_adicionales` VARCHAR(250), IN `_ruta_doc` VARCHAR(250), IN `_aprobacion` INT)   BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET existe_error = 1;
	END;

     INSERT INTO bajas_activo(idactivo, motivo, coment_adicionales, ruta_doc, aprobacion) VALUES
     (_idactivo, _motivo, NULLIF(_coment_adicionales,''), _ruta_doc, _aprobacion);

     IF existe_error = 1 THEN
		SET _idbaja_activo = -1;
     ELSE
		SET _idbaja_activo = last_insert_id();
     END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_notificacion` (IN `_idusuario` INT, IN `_tipo` VARCHAR(20), IN `_mensaje` VARCHAR(400))   BEGIN
	INSERT INTO notificaciones (idusuario, tipo, mensaje) VALUES
	 (_idusuario, _tipo, _mensaje);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_solicitud` (IN `_idusuario` INT, IN `_idactivo` INT, IN `_motivo_solicitud` VARCHAR(500))   BEGIN
	INSERT INTO solicitudes_activos (idusuario, idactivo, motivo_solicitud) VALUES
		(_idusuario, _idactivo, _motivo_solicitud);
	SELECT @@last_insert_id as idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_solicitud` (IN `_idsolicitud` INT, IN `_idactivo` INT, IN `_idusuario` INT, IN `_estado_solicitud` ENUM('pendiente','aprobado','rechazado'), IN `_idautorizador` INT, IN `_coment_autorizador` VARCHAR(500))   BEGIN
	UPDATE solicitudes_activos SET
    idactivo = _idactivo,
    idusuario = _idusuario,
    estado_solicitud = _estado_solicitud,
    idautorizador = _idautorizador,
    coment_autorizador = _coment_autorizador,
    fecha_respuesta = NOW()
    WHERE idsolicitud = _idsolicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_data_baja_activo` (IN `_idactivo` INT)   BEGIN
	SELECT idbaja_activo, fecha_baja, motivo, coment_adicionales, ruta_doc, aprobacion FROM bajas_activo
    WHERE idactivo = _idactivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_notificacion_resp` (IN `_idusuario` INT, IN `_idactivo_resp` INT)   BEGIN
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
    WHERE RES.idusuario = _idusuario AND RES.idactivo_resp = _idactivo_resp
    ORDER BY HIS.fecha_movimiento DESC
    LIMIT 1; -- acabar esto
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_sol_estado` (IN `_idsolicitud` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_existe_responsable` (IN `_idactivo` INT)   BEGIN
	SELECT COUNT(es_responsable) cantidad FROM
    activos_responsables 
    WHERE idactivo=_idactivo AND es_responsable='1';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filter_by_subcategorias` (IN `_idsubcategoria` INT)   BEGIN
	SELECT DISTINCT MAR.idmarca, MAR.marca
	FROM marcas MAR
	INNER JOIN activos ACT ON MAR.idmarca = ACT.idmarca
	WHERE ACT.idsubcategoria = _idsubcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filtrar_usuarios` (IN `_numdoc` VARCHAR(50), IN `_dato` VARCHAR(80))   BEGIN
	SELECT
		U.id_usuario,
		U.usuario,
        R.rol,
        CONCAT(P.apellidos,' ',P.nombres) as nombres,
        TD.tipodoc,
        P.num_doc,
		U.estado
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    AND (P.num_doc LIKE CONCAT('%', _numdoc ,'%') OR _numdoc IS NULL)
    AND (P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getresp_principal` (IN `_idactivo_resp` INT, IN `_idactivo` INT)   BEGIN
	DECLARE isResP INT DEFAULT 0;
    
    SELECT COUNT(*) INTO isResP
    FROM activos_responsables WHERE es_responsable='1'
    AND idactivo = _idactivo;
    
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
		WHERE RES.idactivo_resp = _idactivo_resp
        ORDER BY RES.fecha_asignacion asc
        LIMIT 1;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getUser_by_id` (IN `_idusuario` INT)   BEGIN
	SELECT U.usuario, CONCAT(P.apellidos, ' ', P.nombres) as dato 
    FROM usuarios U
    INNER JOIN personas P ON U.idpersona = P.id_persona
    WHERE id_usuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_activoById` (IN `_idactivo` INT)   BEGIN
	SELECT descripcion, cod_identificacion FROM activos
    WHERE idactivo = _idactivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_persona` (IN `_idusuario` INT)   BEGIN
		SELECT
		U.id_usuario,
		U.usuario,
        R.idrol,
        P.apellidos,
        TD.idtipodoc,
        P.nombres,
        P.num_doc,
        P.telefono,
        P.genero
			FROM usuarios U
			INNER JOIN roles R ON U.idrol = R.idrol
			INNER JOIN personas P ON U.idpersona = P.id_persona
			INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
		WHERE U.id_usuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_activos` (IN `_idsubcategoria` INT, IN `_cod_identificacion` CHAR(40), IN `_fecha_adquisicion` DATE, IN `_fecha_adquisicion_fin` DATE, IN `_idestado` INT, IN `_idmarca` INT)   BEGIN
	SELECT
		ACT.idactivo,
        SUB.subcategoria,
        CAT.categoria,
        MAR.marca,
        EST.nom_estado,
        ACT.modelo,
        ACT.cod_identificacion,
        ACT.fecha_adquisicion,
        ACT.descripcion,
        EST.nom_estado,
        ACT.especificaciones
	FROM activos ACT
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    WHERE (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL)
    AND (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL)
    AND (ACT.fecha_adquisicion>=_fecha_adquisicion AND ACT.fecha_adquisicion<=_fecha_adquisicion_fin OR _fecha_adquisicion IS NULL OR _fecha_adquisicion_fin IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL)
    AND (MAR.idmarca = _idmarca OR _idmarca IS NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_notificacion` (IN `_idusuario` INT, IN `_idnotificacion` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_pass` (IN `_estado_solicitud` ENUM('pendiente','aprobado','rechazado'))   BEGIN
		SELECT
		SOL.idsolicitud,
		USU.usuario,
        USU.id_usuario,
        ACT.idactivo,
        ACT.modelo,
        ACT.cod_identificacion,
        SOL.fecha_solicitud,
        SOL.estado_solicitud
        FROM solicitudes_activos SOL
        INNER JOIN usuarios USU ON SOL.idusuario = USU.id_usuario
        INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
        WHERE SOL.estado_solicitud = _estado_solicitud;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_persona_users` (IN `_idrol` INT, IN `_idtipodoc` INT, IN `_estado` CHAR(1), IN `_dato` VARCHAR(50))   BEGIN
	SELECT
		U.id_usuario,
		U.usuario,
        R.rol,
        U.estado,
        CONCAT(P.apellidos,' ',P.nombres) as nombres,
        TD.tipodoc,
        P.num_doc,
        P.telefono,
        P.genero,
        U.asignacion
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    WHERE (R.idrol = _idrol OR _idrol IS NULL) 
    AND (U.estado = _estado OR _estado IS NULL) 
    AND (TD.idtipodoc=_idtipodoc OR _idtipodoc IS NULL)
    AND (CONCAT(P.apellidos,' ',P.nombres) LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_resp_activo` ()   BEGIN
	SELECT R.idactivo_resp, A.descripcion
    FROM activos_responsables R
    INNER JOIN activos A ON R.idactivo = A.idactivo
    WHERE A.idestado >=3 AND A.idestado<=4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_users` ()   BEGIN
	SELECT
    US.id_usuario,
    US.usuario,
    RO.rol
    FROM usuarios US
    INNER JOIN roles RO ON US.idrol = RO.idrol
    WHERE US.estado=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_max_colaboradores` (OUT `_cantidad` INT, IN `_idactivo` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_persona_by_numdoc` (IN `_num_doc` VARCHAR(50))   BEGIN
	SELECT 
		USU.usuario,
		PER.idtipodoc, 
		PER.apellidos, 
        PER.nombres, 
        PER.telefono, 
        PER.genero, 
        USU.idrol,
        USU.contrasena
    FROM usuarios USU
    RIGHT JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE PER.num_doc=_num_doc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_person` (IN `_idtipodoc` INT, IN `_num_doc` VARCHAR(30), IN `_apellidos` VARCHAR(100), IN `_nombres` VARCHAR(100), IN `_genero` CHAR(1), IN `_telefono` CHAR(9))   BEGIN
	INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono) VALUES 
    (_idtipodoc, _num_doc, _apellidos, _nombres, _genero, _telefono);
    
    SELECT last_insert_id() as idpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_user` (IN `_idpersona` INT, IN `_idrol` INT, IN `_usuario` VARCHAR(120), IN `_contrasena` VARCHAR(120))   BEGIN
	INSERT INTO usuarios (idpersona, idrol, usuario, contrasena)
    VALUES (_idpersona, _idrol, _usuario, _contrasena);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_repeat_responsable` (IN `_idactivo` INT, IN `_idusuario` INT)   BEGIN
    SELECT
	COUNT(idactivo_resp) cantidad,
    USU.usuario
    FROM activos_responsables
    INNER JOIN usuarios USU ON activos_responsables.idusuario = USU.id_usuario
    WHERE idactivo=_idactivo AND idusuario = _idusuario AND fecha_designacion IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_request_duplicate` (IN `_idusuario` INT, IN `_idactivo` INT)   BEGIN
	SELECT
		COUNT(*) as cantidad
        FROM solicitudes_activos
        WHERE idusuario=_idusuario AND idactivo=_idactivo AND(estado_solicitud='pendiente' OR estado_solicitud='aprobado');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_respact_add` (IN `_idactivo` INT, IN `_idusuario` INT, IN `_condicion_equipo` VARCHAR(500), IN `_imagenes` JSON, IN `_descripcion` VARCHAR(500), IN `_autorizacion` INT, IN `_solicitud` INT)   BEGIN
	INSERT INTO activos_responsables(idactivo, idusuario, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) VALUES
		(_idactivo, _idusuario, _condicion_equipo, _imagenes, _descripcion, _autorizacion, _solicitud);
        
	SELECT last_insert_id() as idresp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_responsable_notificacion` (IN `_idusuario` INT)   BEGIN
	SELECT
    RES.idusuario,
	ACT.descripcion,
    RES.descripcion desresp,
    RES.idactivo_resp
	FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE RES.idusuario = _idusuario
    ORDER BY RES.fecha_asignacion DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo` (IN `_descripcion` VARCHAR(40))   BEGIN
	SELECT ACT.idactivo, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.descripcion LIKE CONCAT('%', _descripcion,'%') AND ACT.idestado!=4 
	ORDER BY SUB.subcategoria ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo_resp` (IN `_descripcion` VARCHAR(40))   BEGIN
	SELECT DISTINCT ACT.idactivo, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
    -- INNER JOIN activos_responsables RES ON ACT.idactivo = RES.idactivo
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.descripcion LIKE CONCAT('%', _descripcion,'%') AND ACT.idestado!=4 AND ACT.idestado!=5
	ORDER BY SUB.subcategoria ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo_responsable` (IN `_idsubcategoria` INT, IN `_idubicacion` INT, IN `_cod_identificacion` CHAR(40))   BEGIN
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
            RES.fecha_designacion IS NULL
            -- ACT.idestado BETWEEN 1 AND 2
    GROUP BY ACT.idactivo
    ORDER BY RES.idactivo_resp asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_by_activo` (IN `_idactivo` INT)   BEGIN
	SELECT
		RES.idusuario,
		RES.idactivo_resp,
		CONCAT(PER.apellidos,' ',PER.nombres) as nombres,
        ROL.rol,
        RES.es_responsable,
        (SELECT COUNT(R.idactivo_resp) FROM activos_responsables R
WHERE R.idusuario = RES.idusuario AND R.fecha_designacion IS NULL) as cantidad,
        USU.estado
	FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    INNER JOIN roles ROL ON USU.idrol = ROL.idrol
    WHERE RES.idactivo = _idactivo AND RES.fecha_designacion IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_resp` (IN `_idactivo_resp` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_solicitud` (IN `_valor` VARCHAR(50))   BEGIN
	SELECT
		SOL.idsolicitud,
        USU.id_usuario,
        ACT.idactivo,
        USU.usuario,
        ACT.descripcion
	FROM solicitudes_activos SOL
    INNER JOIN usuarios USU ON SOL.idusuario = USU.id_usuario
    INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
    WHERE 
    SOL.estado_solicitud='aprobado' AND
    (USU.usuario LIKE CONCAT('%',_valor, '%')
    OR
    ACT.descripcion LIKE CONCAT('%',_valor,'%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_telefono` (IN `_telefono` CHAR(9))   BEGIN
	SELECT id_persona FROM personas WHERE telefono =_telefono;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_update_activo` (IN `_idactivo` INT)   BEGIN
		SELECT
		ACT.idactivo, ACT.idsubcategoria, ACT.idmarca, MAR.marca,
        CAT.categoria,
        EST.nom_estado,
        ACT.modelo,
        ACT.cod_identificacion,
        ACT.fecha_adquisicion,
        ACT.descripcion,
        ACT.especificaciones
		FROM activos ACT
		INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
		INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
		INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
		INNER JOIN estados EST ON ACT.idestado = EST.idestado
        WHERE ACT.idactivo = _idactivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user` (IN `_usuario` VARCHAR(120))   BEGIN
	SELECT id_usuario FROM usuarios WHERE usuario = _usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ubicacion_activo` (IN `_idactivo` INT, IN `_idactivo_resp` INT)   BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo and res.idactivo_resp = _idactivo_resp
    ORDER BY HIS.fecha_movimiento desc
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activo` (IN `_idactivo` INT, IN `_idsubcategoria` INT, IN `_idmarca` INT, IN `_modelo` VARCHAR(60), IN `_cod_identificacion` CHAR(40), IN `_fecha_adquisicion` DATE, IN `_descripcion` VARCHAR(200), IN `_especificaciones` JSON)   BEGIN
	UPDATE activos SET
    idsubcategoria = _idsubcategoria,
    idmarca = _idmarca,
    modelo = _modelo,
    cod_identificacion = _cod_identificacion,
    fecha_adquisicion = _fecha_adquisicion,
    descripcion = _descripcion,
    especificaciones = _especificaciones
    WHERE idactivo = _idactivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activo_responsable` (IN `_idactivo_resp` INT, IN `_idactivo` INT, IN `_idusuario` INT, IN `_autorizacion` INT)   BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
        autorizacion = _autorizacion,
        fecha_designacion = NOW()
	WHERE idactivo_resp = _idactivo_resp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_asignacion_principal` (IN `_idactivo_resp` INT, IN `_idactivo` INT, IN `_idusuario` INT, IN `_es_responsable` CHAR(1), IN `_autorizacion` INT)   BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
		es_responsable = _es_responsable,
        autorizacion = _autorizacion
	WHERE idactivo_resp = _idactivo_resp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_claveacceso` (IN `_idusuario` INT, IN `_contrasena` VARCHAR(120))   BEGIN
	UPDATE usuarios SET
    contrasena = _contrasena
    WHERE id_usuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_estado_activo` (IN `_idactivo` INT, IN `_idestado` INT)   BEGIN
	UPDATE activos SET
    idestado = _idestado
    WHERE idactivo = _idactivo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_estado_usuario` (IN `_idusuario` INT, IN `_estado` CHAR(1))   BEGIN
	UPDATE usuarios SET
    estado = _estado
    WHERE id_usuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_persona` (IN `_idpersona` INT, IN `_idtipo_doc` INT, IN `_num_doc` VARCHAR(50), IN `_apellidos` VARCHAR(100), IN `_nombres` VARCHAR(100), IN `_genero` CHAR(1), IN `_telefono` CHAR(9))   BEGIN
	UPDATE personas SET
	idtipodoc = _idtipo_doc,
    num_doc = _num_doc,
    apellidos = _apellidos,
    nombres = _nombres,
    genero = _genero,
    telefono = _telefono
    WHERE id_persona = _idpersona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_responsable` (IN `_idactivo_resp` INT)   BEGIN
	UPDATE activos_responsables SET
    es_responsable='1'
    WHERE idactivo_resp=_idactivo_resp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_usuario` (OUT `_idpersona` INT, IN `_idusuario` INT, IN `_idrol` INT, IN `_usuario` VARCHAR(120))   BEGIN
	UPDATE usuarios SET
    idrol = _idrol,
    usuario = _usuario
    WHERE id_usuario = _idusuario;
    
    SELECT idpersona INTO _idpersona
    FROM usuarios WHERE id_usuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_by_activo` (IN `_idactivo` INT)   BEGIN
	SELECT
    USU.id_usuario,
	USU.usuario,
    PER.apellidos,
    RES.idactivo_resp,
    RES.fecha_asignacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo AND RES.fecha_designacion IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_login` (IN `_usuario` VARCHAR(120))   BEGIN
	SELECT
    US.id_usuario,
    CONCAT(PE.apellidos, ' ', PE.nombres) datos,
    US.usuario,
    RO.rol,
    US.contrasena,
    US.estado
    FROM usuarios US
    LEFT JOIN personas PE ON US.idpersona = PE.id_persona
    LEFT JOIN roles RO ON US.idrol = RO.idrol
    WHERE usuario=_usuario AND US.estado=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificarOrdenInconclusa` (IN `_idorden_trabajo` INT)   BEGIN
	SELECT
		*
        FROM odt ODT
        LEFT JOIN diagnosticos DIA ON DIA.idorden_trabajo = ODT.idorden_trabajo
        WHERE ODT.idorden_trabajo = 21 AND ODT.borrador = 1;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificarPlanInconcluso` (IN `_idplantarea` INT)   BEGIN
	SELECT 
        pt.idplantarea, 
        pt.descripcion, 
        COUNT(t.idtarea) AS cantidad_tareas,
        COUNT(a.idactivo) AS cantidad_activos
    FROM plandetareas pt
    LEFT JOIN tareas t ON pt.idplantarea = t.idplantarea
    LEFT JOIN activos_vinculados_tarea a ON t.idtarea = a.idtarea
    WHERE pt.idplantarea = _idplantarea
    GROUP BY pt.idplantarea, pt.descripcion;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activos`
--

CREATE TABLE `activos` (
  `idactivo` int(11) NOT NULL,
  `idsubcategoria` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idestado` int(11) NOT NULL DEFAULT 1,
  `modelo` varchar(60) DEFAULT NULL,
  `cod_identificacion` char(40) NOT NULL,
  `fecha_adquisicion` date NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`especificaciones`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `activos`
--

INSERT INTO `activos` (`idactivo`, `idsubcategoria`, `idmarca`, `idestado`, `modelo`, `cod_identificacion`, `fecha_adquisicion`, `descripcion`, `especificaciones`) VALUES
(1, 2, 1, 1, '14-EP', '123ABC', '2024-10-24', 'Laptop 14-EP 16 RAM', '{\"ram\":\"16GB\", \"disco\":\"solido\"}'),
(2, 10, 1, 1, 'Monitor 4K', 'MON123', '2024-10-24', 'Monitor LG de 27 pulgadas', '{\"resolucion\":\"3840x2160\"}'),
(3, 11, 2, 1, 'Teclado Mecánico', 'TEC123', '2024-10-24', 'Teclado mecánico HP', '{\"tipo\":\"mecánico\", \"conectividad\":\"inalámbrico\"}'),
(4, 7, 4, 1, 'Compresor Industrial', 'COMP123', '2024-10-24', 'Compresor Caterpillar de 10HP', '{\"potencia\":\"10HP\"}'),
(5, 6, 5, 1, 'Camión de Carga Hyundai', 'CAM123', '2024-10-24', 'Camión de carga pesada Hyundai', '{\"capacidad\":\"10 toneladas\"}'),
(6, 9, 2, 1, 'L3110', 'IMP123', '2024-10-24', 'Impresora HP L3110', '{\"capacidad\":\"200 kilogramos\"}'),
(7, 1, 2, 1, 'LG UltraGear', 'LG-001', '2023-01-15', 'Monitor para gaming', '{\"resolucion\": \"2560x1440\", \"tasa_de_refresco\": \"144Hz\"}'),
(8, 2, 2, 1, 'HP Pavilion', 'HP-002', '2023-02-20', 'Laptop para uso diario', '{\"procesador\": \"Intel i5\", \"ram\": \"8GB\"}'),
(9, 3, 5, 1, 'Caterpillar 320', 'CAT-003', '2023-03-10', 'Maquinaria pesada', '{\"potencia\": \"150HP\", \"peso\": \"20ton\"}'),
(10, 4, 3, 1, 'Nissan Frontier', 'NIS-004', '2023-04-05', 'Camioneta pickup', '{\"motor\": \"2.5L\", \"traccion\": \"4x4\"}'),
(11, 5, 6, 1, 'Hyundai Generator', 'HYD-005', '2023-05-12', 'Generador portátil', '{\"potencia\": \"3000W\", \"tipo_combustible\": \"Gasolina\"}'),
(12, 6, 1, 1, 'HP LaserJet', 'HP-006', '2023-06-18', 'Impresora láser', '{\"tipo\": \"monocromo\", \"velocidad\": \"30ppm\"}'),
(13, 7, 1, 1, 'LG Gram', 'LG-007', '2023-07-22', 'Laptop ultraligera', '{\"peso\": \"999g\", \"pantalla\": \"14in\"}'),
(14, 8, 4, 1, 'ABB Robot IRB', 'ABB-008', '2023-08-15', 'Robot industrial', '{\"carga_util\": \"10kg\", \"alcance\": \"1.5m\"}'),
(15, 9, 7, 1, 'FenWick Forklift', 'FW-009', '2023-09-10', 'Montacargas eléctrico', '{\"capacidad_carga\": \"2000kg\", \"batería\": \"24V\"}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activos_responsables`
--

CREATE TABLE `activos_responsables` (
  `idactivo_resp` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `es_responsable` char(1) NOT NULL DEFAULT '0',
  `fecha_asignacion` date NOT NULL DEFAULT current_timestamp(),
  `fecha_designacion` date DEFAULT NULL,
  `condicion_equipo` varchar(500) DEFAULT NULL,
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`imagenes`)),
  `descripcion` varchar(500) NOT NULL,
  `autorizacion` int(11) NOT NULL,
  `solicitud` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `activos_responsables`
--

INSERT INTO `activos_responsables` (`idactivo_resp`, `idactivo`, `idusuario`, `es_responsable`, `fecha_asignacion`, `fecha_designacion`, `condicion_equipo`, `imagenes`, `descripcion`, `autorizacion`, `solicitud`) VALUES
(1, 1, 2, '0', '2024-10-24', NULL, 'En perfectas condiciones', '{\"imagen1\":\"http://nose/que/poner\"}', 'equipo de trabajo', 1, 1),
(2, 1, 3, '0', '2024-10-24', NULL, 'Nuevo', '{\"imagen1\":\"https://ejemplo.com/imagenes/lg_ultragear.jpg\"}', 'Asignación a usuario', 6, 1),
(3, 2, 4, '0', '2024-10-24', NULL, 'Este activo esta sin problemas', '{\"imagen1\":\"https://ejemplo.com/imagenes/hp_pavilion.jpg\"}', 'Uso diario', 1, 1),
(4, 3, 5, '0', '2024-10-24', NULL, 'En buenas condiciones', '{\"imagen1\":\"https://ejemplo.com/imagenes/caterpillar_320.jpg\"}', 'Asignación a proyecto', 8, 1),
(5, 4, 6, '0', '2024-10-24', NULL, 'Tienes fallos en el motor', '{\"imagen1\":\"https://ejemplo.com/imagenes/nissan_frontier.jpg\"}', 'Camioneta de trabajo', 14, 1),
(6, 5, 7, '0', '2024-10-24', NULL, 'Nuevo', '{\"imagen1\":\"https://ejemplo.com/imagenes/hyundai_generator.jpg\"}', 'Generador de respaldo', 12, 1),
(7, 6, 8, '0', '2024-10-24', NULL, 'Nuevo', '{\"imagen1\":\"https://ejemplo.com/imagenes/hp_laserjet.jpg\"}', 'Impresión de documentos', 8, 1),
(8, 7, 9, '0', '2024-10-24', NULL, 'Usado', '{\"imagen1\":\"https://ejemplo.com/imagenes/lg_gram.jpg\"}', 'Laptop para administración', 10, 1),
(9, 8, 10, '0', '2024-10-24', NULL, 'Nuevo', '{\"imagen1\":\"https://ejemplo.com/imagenes/abb_robot_irb.jpg\"}', 'Robot para automatización', 14, 1),
(10, 9, 11, '0', '2024-10-24', NULL, 'Usado', '{\"imagen1\":\"https://ejemplo.com/imagenes/fenwick_forklift.jpg\"}', 'Montacargas para logística', 14, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activos_vinculados_tarea`
--

CREATE TABLE `activos_vinculados_tarea` (
  `idactivo_vinculado` int(11) NOT NULL,
  `idtarea` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `activos_vinculados_tarea`
--

INSERT INTO `activos_vinculados_tarea` (`idactivo_vinculado`, `idtarea`, `idactivo`, `create_at`, `update_at`) VALUES
(1, 1, 5, '2024-10-24 19:23:13', NULL),
(2, 2, 5, '2024-10-24 19:24:53', NULL),
(3, 3, 5, '2024-10-24 19:33:53', NULL),
(7, 5, 5, '2024-10-24 19:44:06', NULL),
(8, 6, 1, '2024-10-24 19:55:46', NULL),
(9, 7, 1, '2024-10-24 20:11:59', NULL),
(10, 8, 1, '2024-10-24 22:02:06', NULL),
(11, 9, 7, '2024-10-24 22:07:02', NULL),
(12, 10, 1, '2024-10-24 22:15:46', NULL),
(13, 11, 1, '2024-10-24 22:48:17', NULL),
(14, 12, 6, '2024-10-24 22:55:03', NULL),
(15, 13, 9, '2024-10-24 22:56:29', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bajas_activo`
--

CREATE TABLE `bajas_activo` (
  `idbaja_activo` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `fecha_baja` datetime NOT NULL DEFAULT current_timestamp(),
  `motivo` varchar(250) NOT NULL,
  `coment_adicionales` varchar(250) DEFAULT NULL,
  `ruta_doc` varchar(250) NOT NULL,
  `aprobacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `idcategoria` int(11) NOT NULL,
  `categoria` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`idcategoria`, `categoria`) VALUES
(3, 'Equipo de Produccion'),
(2, 'Equipo Pesado'),
(1, 'Tecnologia'),
(4, 'Transporte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_odt`
--

CREATE TABLE `detalle_odt` (
  `iddetalleodt` int(11) NOT NULL,
  `idorden_trabajo` int(11) NOT NULL,
  `fecha_inicial` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_final` datetime DEFAULT NULL,
  `tiempo_ejecucion` time DEFAULT NULL,
  `clasificacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_odt`
--

INSERT INTO `detalle_odt` (`iddetalleodt`, `idorden_trabajo`, `fecha_inicial`, `fecha_final`, `tiempo_ejecucion`, `clasificacion`) VALUES
(1, 1, '2024-10-24 19:28:18', '2024-10-24 00:10:30', '00:10:20', 11),
(2, 2, '2024-10-24 19:35:14', '2024-10-25 00:35:47', '00:00:05', 11),
(3, 4, '2024-10-24 19:48:12', '2024-10-25 03:24:59', '00:00:07', 11),
(4, 5, '2024-10-24 22:31:27', '2024-10-25 03:31:28', '00:00:05', 11),
(5, 7, '2024-10-24 22:31:58', '2024-10-25 03:31:59', '00:00:05', 11),
(6, 8, '2024-10-24 22:35:57', '2024-10-25 03:35:59', '00:00:05', 11),
(7, 9, '2024-10-24 22:38:33', '2024-10-25 03:38:43', '00:00:05', 11),
(8, 10, '2024-10-24 22:41:22', '2024-10-25 03:41:34', '00:00:05', 11),
(9, 12, '2024-10-24 22:49:02', '2024-10-24 22:49:18', '00:00:00', 11),
(10, 14, '2024-10-24 22:57:06', '2024-10-24 22:57:12', '00:00:06', 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `diagnosticos`
--

CREATE TABLE `diagnosticos` (
  `iddiagnostico` int(11) NOT NULL,
  `idorden_trabajo` int(11) NOT NULL,
  `idtipo_diagnostico` int(11) NOT NULL,
  `diagnostico` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `diagnosticos`
--

INSERT INTO `diagnosticos` (`iddiagnostico`, `idorden_trabajo`, `idtipo_diagnostico`, `diagnostico`) VALUES
(1, 1, 1, 'llanta ponchada'),
(2, 1, 2, 'solo tuvismo que cambiar el interno'),
(3, 2, 1, 'xddeee'),
(4, 2, 2, ''),
(6, 4, 1, 'asdasdasd'),
(7, 4, 2, ''),
(8, 5, 1, 'yo dee'),
(9, 5, 2, 'yo'),
(10, 7, 1, 'po'),
(11, 8, 1, 'iooo'),
(12, 9, 1, 'xdxdxdd'),
(13, 10, 1, ''),
(14, 7, 2, 'yuyuaaa'),
(15, 8, 2, 'yo cuando'),
(16, 9, 2, 'xddddd'),
(17, 10, 2, ''),
(18, 12, 1, 'FFFFFFFFFFFFFFF'),
(19, 12, 2, ''),
(20, 13, 1, ''),
(21, 14, 1, 'adasdasasasdsd'),
(22, 14, 2, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados`
--

CREATE TABLE `estados` (
  `idestado` int(11) NOT NULL,
  `tipo_estado` varchar(50) NOT NULL,
  `nom_estado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estados`
--

INSERT INTO `estados` (`idestado`, `tipo_estado`, `nom_estado`) VALUES
(1, 'activo', 'Activo'),
(2, 'activo', 'En Mantenimiento'),
(3, 'activo', 'Fuera de Servicio'),
(4, 'activo', 'Absoleto'),
(5, 'activo', 'Baja'),
(6, 'responsable', 'Asignado'),
(7, 'responsable', 'No Asignado'),
(8, 'orden', 'pendiente'),
(9, 'orden', 'proceso'),
(10, 'orden', 'revision'),
(11, 'orden', 'finalizado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evidencias_diagnostico`
--

CREATE TABLE `evidencias_diagnostico` (
  `idevidencias_diagnostico` int(11) NOT NULL,
  `iddiagnostico` int(11) NOT NULL,
  `evidencia` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `evidencias_diagnostico`
--

INSERT INTO `evidencias_diagnostico` (`idevidencias_diagnostico`, `iddiagnostico`, `evidencia`) VALUES
(1, 1, 'qPv4O7pL.jpg'),
(2, 1, 'mQU9Vg1B.jpg'),
(3, 2, '8l3wQmNi.jpg'),
(4, 3, 'xybmp5Mz.jpg'),
(5, 6, 'meM6RchZ.jpg'),
(6, 8, 'QnNAzve4.jpg'),
(7, 10, '2BOKSH3J.png'),
(8, 11, '5Y1dqK4f.png'),
(9, 12, 'DV6vHJ8i.jpg'),
(10, 12, 'D2dB9FHU.jpg'),
(11, 13, 'mqZGL5w6.jpg'),
(12, 9, 'kz0C91Hc.png'),
(13, 14, 'pjPBiF0O.jpg'),
(14, 15, '6gos5iIY.jpg'),
(15, 18, 'AgObudyU.jpeg'),
(16, 21, '39LKpk8i.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_activos`
--

CREATE TABLE `historial_activos` (
  `idhistorial_activo` int(11) NOT NULL,
  `idactivo_resp` int(11) NOT NULL,
  `idubicacion` int(11) NOT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_activos`
--

INSERT INTO `historial_activos` (`idhistorial_activo`, `idactivo_resp`, `idubicacion`, `fecha_movimiento`) VALUES
(1, 2, 3, '2024-10-24 19:23:13'),
(2, 3, 2, '2024-10-24 19:23:13'),
(3, 4, 1, '2024-10-24 19:23:13'),
(4, 5, 4, '2024-10-24 19:23:13'),
(5, 6, 2, '2024-10-24 19:23:13'),
(6, 7, 3, '2024-10-24 19:23:13'),
(7, 8, 4, '2024-10-24 19:23:13'),
(8, 9, 5, '2024-10-24 19:23:13'),
(9, 10, 2, '2024-10-24 19:23:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_estado_odt`
--

CREATE TABLE `historial_estado_odt` (
  `idhistorial` int(11) NOT NULL,
  `idorden_trabajo` int(11) NOT NULL,
  `estado_anterior` int(11) DEFAULT NULL,
  `estado_nuevo` int(11) NOT NULL,
  `comentario` text DEFAULT NULL,
  `fecha_cambio` datetime DEFAULT current_timestamp(),
  `devuelto` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL,
  `marca` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`idmarca`, `marca`) VALUES
(8, 'ABB'),
(4, 'Caterpillar'),
(5, 'Einhell'),
(7, 'FenWick'),
(2, 'HP'),
(6, 'Hyundai'),
(1, 'LG'),
(3, 'Nissan');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `idnotificacion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `mensaje` varchar(400) NOT NULL,
  `estado` enum('no leido','leido') NOT NULL DEFAULT 'no leido',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `odt`
--

CREATE TABLE `odt` (
  `idorden_trabajo` int(11) NOT NULL,
  `idtarea` int(11) NOT NULL,
  `creado_por` int(11) NOT NULL,
  `idestado` int(11) DEFAULT 9,
  `incompleto` tinyint(1) DEFAULT 1,
  `eliminado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `odt`
--

INSERT INTO `odt` (`idorden_trabajo`, `idtarea`, `creado_por`, `idestado`, `incompleto`, `eliminado`) VALUES
(1, 2, 5, 9, 0, 0),
(2, 3, 5, 9, 0, 0),
(4, 5, 5, 9, 0, 0),
(5, 6, 5, 9, 0, 0),
(6, 7, 2, 9, 1, 0),
(7, 7, 5, 9, 0, 0),
(8, 8, 5, 9, 0, 0),
(9, 9, 5, 9, 0, 0),
(10, 10, 5, 9, 1, 0),
(11, 2, 5, 9, 1, 0),
(12, 11, 5, 9, 0, 0),
(13, 12, 5, 9, 1, 0),
(14, 13, 5, 9, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idpermiso` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `permiso` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`permiso`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idpermiso`, `idrol`, `permiso`) VALUES
(1, 2, '{\"activos\":{\"registerActivo\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false}, \"Responsables\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"Activos\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false}},\"ODT\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"planTarea\":{\"read\":true,\"create\":false,\"update\":false,\"delete\":false},\"bajaActivo\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"usuarios\":{\"ListaUsuario\":{\"read\":false,\"create\":false,\"update\":false,\"delete\":false},\"PermisoRol\":{\"read\":false,\"create\":false,\"update\":false,\"delete\":false}}}'),
(2, 1, '{\"activos\":{\"registerActivo\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":true}},\"ODT\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":false},\"PlanTarea\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"BajaActivo\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":false},\"usuarios\":{\"ListaUsuario\":{\"read\":true,\"create\": true,\"update\":true,\"delete\":true},\"PermisoRol\":{ \"read\":true,\"create\": true, \"update\":true, \"delete\":true}}}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id_persona` int(11) NOT NULL,
  `idtipodoc` int(11) NOT NULL,
  `num_doc` varchar(50) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `genero` char(1) NOT NULL,
  `telefono` char(9) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id_persona`, `idtipodoc`, `num_doc`, `apellidos`, `nombres`, `genero`, `telefono`) VALUES
(1, 1, '12345678', 'González', 'Juan', 'M', '987654321'),
(2, 2, 'A1234567', 'Smith', 'Anna', 'F', '987654322'),
(3, 2, 'EX123456', 'Martínez', 'Carlos', 'M', '987654323'),
(4, 1, '35255456', 'Ortiz Huaman', 'Pablo', 'M', '928483244'),
(5, 1, '72754752', 'Avalos Romero', 'Royer Alexis', 'M', '936439633'),
(6, 1, '72754751', 'Avalos Romero', 'Pedro Aldair', 'M', '995213305'),
(7, 1, '36436772', 'García', 'Juan', 'M', '555-1234'),
(8, 2, '87654321', 'Pérez', 'Ana', 'F', '555-5678'),
(9, 1, '23456789', 'López', 'Carlos', 'M', '555-9101'),
(10, 2, '98765432', 'Martínez', 'Laura', 'F', '555-1122'),
(11, 1, '34567890', 'Sánchez', 'Pedro', 'M', '555-1314'),
(12, 2, '65432109', 'Ramírez', 'Marta', 'F', '555-1516'),
(13, 1, '45678901', 'Torres', 'Jorge', 'M', '555-1718'),
(14, 2, '54321098', 'Hernández', 'Lucía', 'F', '555-1920');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plandetareas`
--

CREATE TABLE `plandetareas` (
  `idplantarea` int(11) NOT NULL,
  `descripcion` varchar(80) NOT NULL,
  `incompleto` tinyint(1) DEFAULT 1,
  `eliminado` tinyint(1) DEFAULT 0,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `plandetareas`
--

INSERT INTO `plandetareas` (`idplantarea`, `descripcion`, `incompleto`, `eliminado`, `create_at`, `update_at`) VALUES
(1, 'mantenimiento de impresora', 1, 1, '2024-10-24 19:23:13', '2024-10-24 19:24:16'),
(2, 'mantenimiento camioneta', 0, 0, '2024-10-24 19:24:27', '2024-10-24 22:56:30'),
(3, 'prueba', 1, 0, '2024-10-24 19:32:43', NULL),
(4, 'cullo', 0, 0, '2024-10-24 19:55:25', '2024-10-24 19:55:48'),
(5, 'test', 0, 0, '2024-10-24 20:11:33', '2024-10-24 20:12:01'),
(6, 'royer', 0, 0, '2024-10-24 22:01:38', '2024-10-24 22:02:07'),
(7, 'plan b', 0, 0, '2024-10-24 22:06:27', '2024-10-24 22:07:03'),
(8, 'haaa', 0, 0, '2024-10-24 22:15:33', '2024-10-24 22:15:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `responsables_asignados_odt`
--

CREATE TABLE `responsables_asignados_odt` (
  `idresponsable_asignado` int(11) NOT NULL,
  `idorden_trabajo` int(11) NOT NULL,
  `idresponsable` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `responsables_asignados_odt`
--

INSERT INTO `responsables_asignados_odt` (`idresponsable_asignado`, `idorden_trabajo`, `idresponsable`) VALUES
(1, 1, 6),
(2, 2, 6),
(3, 4, 6),
(4, 5, 7),
(5, 7, 5),
(6, 8, 12),
(7, 9, 10),
(8, 10, 14),
(9, 12, 2),
(10, 14, 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `rol`) VALUES
(1, 'Administrador'),
(2, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_activos`
--

CREATE TABLE `solicitudes_activos` (
  `idsolicitud` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `fecha_solicitud` date NOT NULL DEFAULT current_timestamp(),
  `estado_solicitud` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `motivo_solicitud` varchar(500) DEFAULT NULL,
  `idautorizador` int(11) NOT NULL,
  `fecha_respuesta` date DEFAULT NULL,
  `coment_autorizador` varchar(500) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `solicitudes_activos`
--

INSERT INTO `solicitudes_activos` (`idsolicitud`, `idusuario`, `idactivo`, `fecha_solicitud`, `estado_solicitud`, `motivo_solicitud`, `idautorizador`, `fecha_respuesta`, `coment_autorizador`) VALUES
(1, 2, 1, '2024-10-24', 'pendiente', 'Para el proyecto X', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategorias`
--

CREATE TABLE `subcategorias` (
  `idsubcategoria` int(11) NOT NULL,
  `idcategoria` int(11) NOT NULL,
  `subcategoria` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subcategorias`
--

INSERT INTO `subcategorias` (`idsubcategoria`, `idcategoria`, `subcategoria`) VALUES
(1, 1, 'Computadora'),
(2, 1, 'Laptop'),
(3, 2, 'Maquinaria Industrial'),
(4, 2, 'Generador'),
(5, 4, 'Auto'),
(6, 4, 'Camioneta'),
(7, 3, 'Equipo de Fabricacion'),
(8, 3, 'Robot Industrial'),
(9, 1, 'Impresora'),
(10, 1, 'Monitor'),
(11, 1, 'Teclado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

CREATE TABLE `tareas` (
  `idtarea` int(11) NOT NULL,
  `idplantarea` int(11) NOT NULL,
  `idtipo_prioridad` int(11) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `cant_intervalo` int(11) NOT NULL,
  `frecuencia` varchar(10) NOT NULL,
  `idestado` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tareas`
--

INSERT INTO `tareas` (`idtarea`, `idplantarea`, `idtipo_prioridad`, `descripcion`, `fecha_inicio`, `fecha_vencimiento`, `cant_intervalo`, `frecuencia`, `idestado`, `create_at`, `update_at`) VALUES
(1, 1, 3, 'llenado de tinta color rojo', '0000-00-00', '0000-00-00', 1, 'mensual', 1, '2024-10-24 19:23:13', NULL),
(2, 2, 2, 'cambio de rueda', '2024-10-26', '2024-10-30', 2, 'mes', 9, '2024-10-24 19:24:41', '2024-10-24 19:25:43'),
(3, 2, 3, 'relleno de gasolina', '2024-10-26', '2024-11-06', 2, 'mes', 9, '2024-10-24 19:33:41', '2024-10-24 19:34:15'),
(5, 2, 1, 'xd', '2024-10-25', '2024-10-30', 2, ',es', 9, '2024-10-24 19:43:57', '2024-10-24 19:44:12'),
(6, 4, 4, 'dgh', '2024-10-25', '2024-10-27', 2, 'xd', 9, '2024-10-24 19:55:40', '2024-10-24 19:55:51'),
(7, 5, 3, 'test one', '2024-10-18', '2024-10-26', 2, ',es', 9, '2024-10-24 20:11:48', '2024-10-24 21:43:56'),
(8, 6, 1, 'royer uno', '2024-10-25', '2024-11-05', 2, 'mes', 9, '2024-10-24 22:01:51', '2024-10-24 22:02:12'),
(9, 7, 2, 'plan dos', '2024-10-26', '2024-10-29', 2, 'mesw', 9, '2024-10-24 22:06:39', '2024-10-24 22:07:10'),
(10, 8, 2, 'gaaa', '2024-10-25', '2024-11-06', 2, ',ess', 9, '2024-10-24 22:15:42', '2024-10-24 22:15:54'),
(11, 2, 3, 'yooooooooo', '2024-10-26', '2024-10-19', 2, 'mes', 9, '2024-10-24 22:48:10', '2024-10-24 22:48:24'),
(12, 2, 1, 'BLHAAAAAAAAAAAAAAAAAAAAAAA', '2024-11-02', '2024-10-30', 2, 'mes', 9, '2024-10-24 22:54:55', '2024-10-24 22:55:12'),
(13, 2, 2, 'XDDAAAA', '2024-10-25', '2024-10-29', 2, 'mes', 9, '2024-10-24 22:56:22', '2024-10-24 22:56:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_diagnosticos`
--

CREATE TABLE `tipo_diagnosticos` (
  `idtipo_diagnostico` int(11) NOT NULL,
  `tipo_diagnostico` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_diagnosticos`
--

INSERT INTO `tipo_diagnosticos` (`idtipo_diagnostico`, `tipo_diagnostico`) VALUES
(1, 'entrada'),
(2, 'salida');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_doc`
--

CREATE TABLE `tipo_doc` (
  `idtipodoc` int(11) NOT NULL,
  `tipodoc` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_doc`
--

INSERT INTO `tipo_doc` (`idtipodoc`, `tipodoc`) VALUES
(1, 'DNI'),
(2, 'Carnet de Extranjería');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_prioridades`
--

CREATE TABLE `tipo_prioridades` (
  `idtipo_prioridad` int(11) NOT NULL,
  `tipo_prioridad` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_prioridades`
--

INSERT INTO `tipo_prioridades` (`idtipo_prioridad`, `tipo_prioridad`) VALUES
(1, 'baja'),
(2, 'media'),
(3, 'alta'),
(4, 'urgente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

CREATE TABLE `ubicaciones` (
  `idubicacion` int(11) NOT NULL,
  `ubicacion` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`idubicacion`, `ubicacion`) VALUES
(1, 'lugar 1'),
(2, 'lugar 2'),
(3, 'lugar 3'),
(4, 'lugar 4'),
(5, 'lugar 5');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `idpersona` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `usuario` varchar(120) NOT NULL,
  `contrasena` varchar(120) NOT NULL,
  `estado` char(1) DEFAULT '1',
  `asignacion` int(11) DEFAULT 7
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `idpersona`, `idrol`, `usuario`, `contrasena`, `estado`, `asignacion`) VALUES
(1, 1, 1, 'j.gonzalez', '$2y$10$TpMmHZcum7YJqXOqTrsDy.WheLpUnU98OZjc4WqLgPke9HlX6ZaJS', '1', 7),
(2, 2, 2, 'a.smith', '$2y$10$HdD325QAWm7QpH7KXtRdROBKe39KwDQr6l4K83u2a0w5h/d6yNgau', '1', 7),
(3, 3, 2, 'c.martinez', '$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG', '1', 7),
(4, 4, 2, 'pablo35a', '$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO', '1', 7),
(5, 4, 2, 'r.avalos', '$2y$10$VrxeMCQteaNdX6LwxoZEYevp8BCwKTpIKTVebChbXcxnNX7BTIFaW', '1', 7),
(6, 5, 1, 'p.avalos', '$2y$10$j1KccY6Iex7h19WR0pfMpumhp.dsjJkBCcFUbtVwbPCHw7hECJNyW', '1', 7),
(7, 6, 1, 'garcia.juan', 'contrasena1', '1', 7),
(8, 7, 2, 'perez.ana', 'contrasena2', '1', 7),
(9, 8, 1, 'lopez.carlos', 'contrasena3', '1', 7),
(10, 9, 2, 'martinez.laura', 'contrasena4', '1', 7),
(11, 10, 1, 'sanchez.pedro', 'contrasena5', '1', 7),
(12, 11, 2, 'ramirez.marta', 'contrasena6', '1', 7),
(13, 12, 1, 'torres.jorge', 'contrasena7', '1', 7),
(14, 13, 2, 'hernandez.lucia', 'contrasena8', '1', 7);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_all_solicitudes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_all_solicitudes` (
`idsolicitud` int(11)
,`usuario` varchar(120)
,`modelo` varchar(60)
,`cod_identificacion` char(40)
,`fecha_solicitud` date
,`estado_solicitud` enum('pendiente','aprobado','rechazado')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_personas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_personas` (
`id_persona` int(11)
,`idtipodoc` int(11)
,`num_doc` varchar(50)
,`apellidos` varchar(100)
,`nombres` varchar(100)
,`genero` char(1)
,`telefono` char(9)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_subcategoria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_subcategoria` (
`idsubcategoria` int(11)
,`categoria` varchar(60)
,`subcategoria` varchar(60)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `v_all_solicitudes`
--
DROP TABLE IF EXISTS `v_all_solicitudes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_all_solicitudes`  AS SELECT `sol`.`idsolicitud` AS `idsolicitud`, `usu`.`usuario` AS `usuario`, `act`.`modelo` AS `modelo`, `act`.`cod_identificacion` AS `cod_identificacion`, `sol`.`fecha_solicitud` AS `fecha_solicitud`, `sol`.`estado_solicitud` AS `estado_solicitud` FROM ((`solicitudes_activos` `sol` join `usuarios` `usu` on(`sol`.`idusuario` = `usu`.`id_usuario`)) join `activos` `act` on(`sol`.`idactivo` = `act`.`idactivo`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_personas`
--
DROP TABLE IF EXISTS `v_personas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_personas`  AS SELECT `personas`.`id_persona` AS `id_persona`, `personas`.`idtipodoc` AS `idtipodoc`, `personas`.`num_doc` AS `num_doc`, `personas`.`apellidos` AS `apellidos`, `personas`.`nombres` AS `nombres`, `personas`.`genero` AS `genero`, `personas`.`telefono` AS `telefono` FROM `personas` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_subcategoria`
--
DROP TABLE IF EXISTS `v_subcategoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_subcategoria`  AS SELECT `sub`.`idsubcategoria` AS `idsubcategoria`, `cat`.`categoria` AS `categoria`, `sub`.`subcategoria` AS `subcategoria` FROM (`categorias` `cat` left join `subcategorias` `sub` on(`sub`.`idcategoria` = `cat`.`idcategoria`)) ORDER BY `sub`.`idsubcategoria` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `activos`
--
ALTER TABLE `activos`
  ADD PRIMARY KEY (`idactivo`),
  ADD UNIQUE KEY `uk_cod_identificacion` (`cod_identificacion`),
  ADD KEY `fkidmarca` (`idmarca`),
  ADD KEY `fk_actsubcategoria` (`idsubcategoria`),
  ADD KEY `fk_idestado` (`idestado`);

--
-- Indices de la tabla `activos_responsables`
--
ALTER TABLE `activos_responsables`
  ADD PRIMARY KEY (`idactivo_resp`),
  ADD KEY `fk_activo_resp` (`idactivo`),
  ADD KEY `fk_user_resp` (`idusuario`),
  ADD KEY `fk_autorizacion` (`autorizacion`),
  ADD KEY `fk_solicitud` (`solicitud`);

--
-- Indices de la tabla `activos_vinculados_tarea`
--
ALTER TABLE `activos_vinculados_tarea`
  ADD PRIMARY KEY (`idactivo_vinculado`),
  ADD KEY `fk_idtarea5` (`idtarea`),
  ADD KEY `fk_idactivo3` (`idactivo`);

--
-- Indices de la tabla `bajas_activo`
--
ALTER TABLE `bajas_activo`
  ADD PRIMARY KEY (`idbaja_activo`),
  ADD UNIQUE KEY `uk_ruta_doc` (`ruta_doc`),
  ADD KEY `fk_activo_baja_activo` (`idactivo`),
  ADD KEY `fk_usuario_baja_activo` (`aprobacion`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`idcategoria`),
  ADD UNIQUE KEY `uk_categoria` (`categoria`);

--
-- Indices de la tabla `detalle_odt`
--
ALTER TABLE `detalle_odt`
  ADD PRIMARY KEY (`iddetalleodt`),
  ADD KEY `fk_orden_trabajo2` (`idorden_trabajo`),
  ADD KEY `fk_clasificacion` (`clasificacion`);

--
-- Indices de la tabla `diagnosticos`
--
ALTER TABLE `diagnosticos`
  ADD PRIMARY KEY (`iddiagnostico`),
  ADD KEY `fk_idorden_trabajo3` (`idorden_trabajo`),
  ADD KEY `fk_idtipo_diagnostico` (`idtipo_diagnostico`);

--
-- Indices de la tabla `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`idestado`),
  ADD UNIQUE KEY `uk_nom_estado` (`nom_estado`);

--
-- Indices de la tabla `evidencias_diagnostico`
--
ALTER TABLE `evidencias_diagnostico`
  ADD PRIMARY KEY (`idevidencias_diagnostico`),
  ADD KEY `fk_iddiagnostico` (`iddiagnostico`);

--
-- Indices de la tabla `historial_activos`
--
ALTER TABLE `historial_activos`
  ADD PRIMARY KEY (`idhistorial_activo`),
  ADD KEY `fk_idactivo_resp` (`idactivo_resp`),
  ADD KEY `fk_idubicacion` (`idubicacion`);

--
-- Indices de la tabla `historial_estado_odt`
--
ALTER TABLE `historial_estado_odt`
  ADD PRIMARY KEY (`idhistorial`),
  ADD KEY `fk_idorden_trabajo` (`idorden_trabajo`),
  ADD KEY `fk_idestado5` (`estado_anterior`),
  ADD KEY `fk_idestado6` (`estado_nuevo`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`idmarca`),
  ADD UNIQUE KEY `uk_marca` (`marca`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`idnotificacion`),
  ADD KEY `fk_idusuario_notif` (`idusuario`);

--
-- Indices de la tabla `odt`
--
ALTER TABLE `odt`
  ADD PRIMARY KEY (`idorden_trabajo`),
  ADD KEY `fk_idtarea4` (`idtarea`),
  ADD KEY `fk_creado_por` (`creado_por`),
  ADD KEY `fk_idestado4` (`idestado`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idpermiso`),
  ADD KEY `fk_idrol` (`idrol`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id_persona`),
  ADD UNIQUE KEY `uk_num_doc` (`num_doc`),
  ADD UNIQUE KEY `uk_telefono` (`telefono`),
  ADD KEY `fk_idtipodoc` (`idtipodoc`);

--
-- Indices de la tabla `plandetareas`
--
ALTER TABLE `plandetareas`
  ADD PRIMARY KEY (`idplantarea`),
  ADD UNIQUE KEY `uk_descripcion_plan` (`descripcion`);

--
-- Indices de la tabla `responsables_asignados_odt`
--
ALTER TABLE `responsables_asignados_odt`
  ADD PRIMARY KEY (`idresponsable_asignado`),
  ADD KEY `fk_idodt` (`idorden_trabajo`),
  ADD KEY `fk_idresponsable` (`idresponsable`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `uk_rol` (`rol`);

--
-- Indices de la tabla `solicitudes_activos`
--
ALTER TABLE `solicitudes_activos`
  ADD PRIMARY KEY (`idsolicitud`),
  ADD KEY `fk_usuario_sol` (`idusuario`),
  ADD KEY `fk_activo_sol` (`idactivo`);

--
-- Indices de la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  ADD PRIMARY KEY (`idsubcategoria`),
  ADD UNIQUE KEY `uk_subcategoria` (`subcategoria`),
  ADD KEY `fk_categoria` (`idcategoria`);

--
-- Indices de la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD PRIMARY KEY (`idtarea`),
  ADD UNIQUE KEY `fk_descripcion_tarea` (`descripcion`),
  ADD KEY `fk_idplantarea` (`idplantarea`),
  ADD KEY `fk_idtipo_prioridad` (`idtipo_prioridad`),
  ADD KEY `fk_idestado2` (`idestado`);

--
-- Indices de la tabla `tipo_diagnosticos`
--
ALTER TABLE `tipo_diagnosticos`
  ADD PRIMARY KEY (`idtipo_diagnostico`);

--
-- Indices de la tabla `tipo_doc`
--
ALTER TABLE `tipo_doc`
  ADD PRIMARY KEY (`idtipodoc`);

--
-- Indices de la tabla `tipo_prioridades`
--
ALTER TABLE `tipo_prioridades`
  ADD PRIMARY KEY (`idtipo_prioridad`);

--
-- Indices de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`idubicacion`),
  ADD UNIQUE KEY `uk_ubicacion` (`ubicacion`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uk_idpersonaUser1` (`idpersona`,`usuario`),
  ADD KEY `fk_rol1` (`idrol`),
  ADD KEY `fk_asignacion1` (`asignacion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `activos`
--
ALTER TABLE `activos`
  MODIFY `idactivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `activos_responsables`
--
ALTER TABLE `activos_responsables`
  MODIFY `idactivo_resp` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `activos_vinculados_tarea`
--
ALTER TABLE `activos_vinculados_tarea`
  MODIFY `idactivo_vinculado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `bajas_activo`
--
ALTER TABLE `bajas_activo`
  MODIFY `idbaja_activo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `idcategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `detalle_odt`
--
ALTER TABLE `detalle_odt`
  MODIFY `iddetalleodt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `diagnosticos`
--
ALTER TABLE `diagnosticos`
  MODIFY `iddiagnostico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `estados`
--
ALTER TABLE `estados`
  MODIFY `idestado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `evidencias_diagnostico`
--
ALTER TABLE `evidencias_diagnostico`
  MODIFY `idevidencias_diagnostico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `historial_activos`
--
ALTER TABLE `historial_activos`
  MODIFY `idhistorial_activo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `historial_estado_odt`
--
ALTER TABLE `historial_estado_odt`
  MODIFY `idhistorial` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `idnotificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `odt`
--
ALTER TABLE `odt`
  MODIFY `idorden_trabajo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idpermiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plandetareas`
--
ALTER TABLE `plandetareas`
  MODIFY `idplantarea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `responsables_asignados_odt`
--
ALTER TABLE `responsables_asignados_odt`
  MODIFY `idresponsable_asignado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `solicitudes_activos`
--
ALTER TABLE `solicitudes_activos`
  MODIFY `idsolicitud` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  MODIFY `idsubcategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `tareas`
--
ALTER TABLE `tareas`
  MODIFY `idtarea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tipo_diagnosticos`
--
ALTER TABLE `tipo_diagnosticos`
  MODIFY `idtipo_diagnostico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_doc`
--
ALTER TABLE `tipo_doc`
  MODIFY `idtipodoc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipo_prioridades`
--
ALTER TABLE `tipo_prioridades`
  MODIFY `idtipo_prioridad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `idubicacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activos`
--
ALTER TABLE `activos`
  ADD CONSTRAINT `fk_actsubcategoria` FOREIGN KEY (`idsubcategoria`) REFERENCES `subcategorias` (`idsubcategoria`),
  ADD CONSTRAINT `fk_idestado` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fkidmarca` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`);

--
-- Filtros para la tabla `activos_responsables`
--
ALTER TABLE `activos_responsables`
  ADD CONSTRAINT `fk_activo_resp` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  ADD CONSTRAINT `fk_autorizacion` FOREIGN KEY (`autorizacion`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_solicitud` FOREIGN KEY (`solicitud`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_user_resp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `activos_vinculados_tarea`
--
ALTER TABLE `activos_vinculados_tarea`
  ADD CONSTRAINT `fk_idactivo3` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  ADD CONSTRAINT `fk_idtarea5` FOREIGN KEY (`idtarea`) REFERENCES `tareas` (`idtarea`) ON DELETE CASCADE;

--
-- Filtros para la tabla `bajas_activo`
--
ALTER TABLE `bajas_activo`
  ADD CONSTRAINT `fk_activo_baja_activo` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  ADD CONSTRAINT `fk_usuario_baja_activo` FOREIGN KEY (`aprobacion`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `detalle_odt`
--
ALTER TABLE `detalle_odt`
  ADD CONSTRAINT `fk_clasificacion` FOREIGN KEY (`clasificacion`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_orden_trabajo2` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `diagnosticos`
--
ALTER TABLE `diagnosticos`
  ADD CONSTRAINT `fk_idorden_trabajo3` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_idtipo_diagnostico` FOREIGN KEY (`idtipo_diagnostico`) REFERENCES `tipo_diagnosticos` (`idtipo_diagnostico`);

--
-- Filtros para la tabla `evidencias_diagnostico`
--
ALTER TABLE `evidencias_diagnostico`
  ADD CONSTRAINT `fk_iddiagnostico` FOREIGN KEY (`iddiagnostico`) REFERENCES `diagnosticos` (`iddiagnostico`) ON DELETE CASCADE;

--
-- Filtros para la tabla `historial_activos`
--
ALTER TABLE `historial_activos`
  ADD CONSTRAINT `fk_idactivo_resp` FOREIGN KEY (`idactivo_resp`) REFERENCES `activos_responsables` (`idactivo_resp`),
  ADD CONSTRAINT `fk_idubicacion` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`);

--
-- Filtros para la tabla `historial_estado_odt`
--
ALTER TABLE `historial_estado_odt`
  ADD CONSTRAINT `fk_idestado5` FOREIGN KEY (`estado_anterior`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_idestado6` FOREIGN KEY (`estado_nuevo`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_idorden_trabajo` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `fk_idusuario_notif` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `odt`
--
ALTER TABLE `odt`
  ADD CONSTRAINT `fk_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `fk_idestado4` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_idtarea4` FOREIGN KEY (`idtarea`) REFERENCES `tareas` (`idtarea`) ON DELETE CASCADE;

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `fk_idrol` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);

--
-- Filtros para la tabla `personas`
--
ALTER TABLE `personas`
  ADD CONSTRAINT `fk_idtipodoc` FOREIGN KEY (`idtipodoc`) REFERENCES `tipo_doc` (`idtipodoc`);

--
-- Filtros para la tabla `responsables_asignados_odt`
--
ALTER TABLE `responsables_asignados_odt`
  ADD CONSTRAINT `fk_idodt` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_idresponsable` FOREIGN KEY (`idresponsable`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `solicitudes_activos`
--
ALTER TABLE `solicitudes_activos`
  ADD CONSTRAINT `fk_activo_sol` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  ADD CONSTRAINT `fk_usuario_sol` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  ADD CONSTRAINT `fk_categoria` FOREIGN KEY (`idcategoria`) REFERENCES `categorias` (`idcategoria`);

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `fk_idestado2` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_idplantarea` FOREIGN KEY (`idplantarea`) REFERENCES `plandetareas` (`idplantarea`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_idtipo_prioridad` FOREIGN KEY (`idtipo_prioridad`) REFERENCES `tipo_prioridades` (`idtipo_prioridad`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_asignacion1` FOREIGN KEY (`asignacion`) REFERENCES `estados` (`idestado`),
  ADD CONSTRAINT `fk_persona1` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `fk_rol1` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
