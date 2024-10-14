use gamp;

-- ESTO SERA ELIMINACION LOGICA
DROP PROCEDURE IF EXISTS `eliminarPlanDeTarea`
DELIMITER $$
CREATE PROCEDURE `eliminarPlanDeTarea`(
	IN _idplantarea INT
    -- IN _eliminado BOOLEAN
)
BEGIN
	DELETE FROM plandetareas WHERE idplantarea = _idplantarea;
   -- UPDATE plandetareas 
   -- SET 
	-- eliminado = _eliminado,
     --   update_at = NOW()
    -- WHERE idplantarea = _idplantarea;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarTarea(IN _idtarea INT)
BEGIN
	DELETE FROM tareas WHERE idtarea = _idtarea;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE eliminarActivosVinculadosTarea(IN _idactivovinculado INT)
BEGIN
	DELETE FROM activos_vinculados_tarea WHERE idactivo_vinculado = _idactivovinculado;
END $$
DELIMITER ;

-- DELIMITER $$
-- CREATE PROCEDURE eliminarRecursosVinculadosTarea(IN _idrecursovinculado INT)
-- BEGIN
--	DELETE FROM recursos_vinculados_tarea WHERE idrecurso_vinculado = _idrecursovinculado;
-- END $$
-- DELIMITER ;

