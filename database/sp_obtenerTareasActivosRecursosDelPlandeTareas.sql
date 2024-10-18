use gamp;

DROP PROCEDURE IF EXISTS `verificarPlanInconcluso`
DELIMITER $$
CREATE PROCEDURE `verificarPlanInconcluso`(IN _idplantarea INT)
BEGIN
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
END $$

DROP PROCEDURE IF EXISTS `obtenerPlanTareaPorId`
DELIMITER $$
CREATE PROCEDURE `obtenerPlanTareaPorId` (IN _idplantarea INT)
BEGIN 
	SELECT 
        idplantarea, 
        descripcion,
        incompleto
    FROM plandetareas
    WHERE idplantarea = _idplantarea;
END $$

-- PROCEDIMIENTOS ALMACENADOS PLAN DE TAREA Y TAREAS
DROP PROCEDURE IF EXISTS `obtenerPlantareasDetalles`
DELIMITER $$
CREATE PROCEDURE obtenerPlantareasDetalles(IN _eliminado INT)
BEGIN 
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
END $$

-- call obtenerPlantareasDetalles();

-- TABLAS ESTATICAS
-- USAR LIKE LUEGO PARA FILTRAR
-- DROP PROCEDURE `obtenerRecursos`
-- DELIMITER $$ 
-- CREATE PROCEDURE `obtenerRecursos`(
-- )
-- BEGIN 
-- 	SELECT 
-- 		RE.idrecurso, RE.nombre as recurso, RE.costo, DR.stock_total
-- 	FROM detalle_recurso DR
-- 	INNER JOIN recursos RE ON DR.idrecurso = RE.idrecurso
-- 	INNER JOIN proveedores_vinculados_recurso PVR ON RE.idrecurso = PVR.idrecurso
 --   INNER JOIN proveedores PRO ON PVR.idproveedor = PRO.idproveedor
  --  GROUP BY RE.idrecurso, RE.nombre, RE.costo, DR.stock_total;
-- END $$

DROP PROCEDURE IF EXISTS `obtenerActivos`
DELIMITER $$ 
CREATE PROCEDURE `obtenerActivos`(
	IN _idcategoria	INT
)
BEGIN
	SELECT ACT.idactivo, ACT.descripcion as activo, ACT.cod_identificacion ,CAT.categoria, SUB.subcategoria, MAR.marca, ACT.modelo FROM activos ACT 
    INNER JOIN subcategorias SUB ON SUB.idsubcategoria = ACT.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE CAT.idcategoria = _idcategoria
    ORDER BY ACT.idactivo DESC;
END $$  -- ME QUEDE AQUI


DROP PROCEDURE IF EXISTS `obtenerTareaPorId`
DELIMITER $$
CREATE PROCEDURE `obtenerTareaPorId`(IN _idtarea INT)
BEGIN
	SELECT * FROM tareas WHERE idtarea = _idtarea;
END $$

DROP PROCEDURE IF EXISTS `obtenerTareasPorPlanTarea`
DELIMITER $$
CREATE PROCEDURE `obtenerTareasPorPlanTarea`(IN _idplantarea INT)
BEGIN
	SELECT TAR.idtarea, PT.descripcion as plan_tarea, TP.tipo_prioridad, TAR.descripcion, TAR.cant_intervalo, TAR.frecuencia ,ES.nom_estado FROM tareas TAR
    INNER JOIN plandetareas PT ON TAR.idplantarea = PT.idplantarea -- quitar esta linea luego pq no es necesario mostrar el plan de tareas al que pertenece
    INNER JOIN tipo_prioridades TP ON TAR.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN estados ES ON TAR.idestado = ES.idestado
    WHERE TAR.idplantarea = _idplantarea ORDER BY TAR.idtarea DESC;
END $$

-- CALL obtenerTareasPorPlanTarea(16);

-- DELIMITER $$
-- CREATE PROCEDURE obtenerRecursosPorTarea(IN _idtarea INT)
-- BEGIN
-- 	select RVT.idrecurso_vinculado ,RVT.idrecurso, RVT.idtarea, RVT.cantidad, RE.nombre, RE.costo from recursos_vinculados_tarea RVT
--   INNER JOIN recursos RE ON RVT.idrecurso = RE.idrecurso
--    WHERE RVT.idtarea = _idtarea;
-- END $$
DROP PROCEDURE IF EXISTS `obtenerActivosPorTarea`
DELIMITER $$
CREATE PROCEDURE `obtenerActivosPorTarea`(IN _idtarea INT)
BEGIN
	SELECT ACTV.idactivo_vinculado, SCAT.subcategoria, MAR.marca, ACT.modelo FROM activos_vinculados_tarea ACTV
    INNER JOIN activos ACT ON ACTV.idactivo = ACT.idactivo
    INNER JOIN subcategorias SCAT ON ACT.idsubcategoria = SCAT.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE ACTV.idtarea = _idtarea;
END $$


DROP PROCEDURE IF EXISTS `obtenerUnActivoVinculadoAtarea`
DELIMITER $$
create PROCEDURE obtenerUnActivoVinculadoAtarea(IN _idactivo_vinculado INT)
BEGIN
	SELECT AVT.idactivo_vinculado, AVT.idactivo, AVT.idtarea, ACT.descripcion ,SUB.subcategoria FROM activos_vinculados_tarea AVT
    INNER JOIN activos ACT ON AVT.idactivo = ACT.idactivo
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    where AVT.idactivo_vinculado = _idactivo_vinculado;
END $$

-- *******************************************************************************************************

DELIMITER $$
CREATE PROCEDURE listarActivosPorTareaYPlan(IN p_idplantarea INT)
BEGIN
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

