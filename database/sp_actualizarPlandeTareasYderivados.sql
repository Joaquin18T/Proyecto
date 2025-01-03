use gamp;

DROP PROCEDURE `actualizarPlanDeTareas`
DELIMITER $$
CREATE PROCEDURE actualizarPlanDeTareas(
    IN _idplantarea INT, 
    IN _descripcion VARCHAR(80),
    IN _incompleto BOOLEAN)
BEGIN
    UPDATE plandetareas 
    SET descripcion = _descripcion,
		incompleto = _incompleto, 
        update_at = NOW()
    WHERE idplantarea = _idplantarea;
END $$
DELIMITER ;

-- ***************************************************************

DROP PROCEDURE IF EXISTS `actualizarTarea`
DELIMITER $$
CREATE PROCEDURE `actualizarTarea`(
    IN _idtarea INT,
    IN _idtipo_prioridad INT,
    IN _descripcion VARCHAR(200),     
    IN _intervalo		INT,
    IN _idfrecuencia		INT,
    IN _idestado INT)
BEGIN
    UPDATE tareas 
    SET 
		idtipo_prioridad = _idtipo_prioridad,
		descripcion = _descripcion,
        intervalo	= _intervalo,
        idfrecuencia	= _idfrecuencia,
        idestado = _idestado, 
        update_at = NOW()
    WHERE idtarea = _idtarea;
    
    SELECT MAX(idtarea) as idactualizado FROM tareas;
END $$



CALL actualizarTarea(2,2, 'linkin park', '', '', 2, 'mes', 1);
-- select * from tareas;
-- ********************************************************************

-- DELIMITER $$
-- CREATE PROCEDURE actualizarRecursoPorTarea(
--    IN _idrecurso_vinculado INT, 
--  IN _idrecurso INT, 
--    IN _idtarea INT, 
--  IN _cantidad INT)
-- BEGIN
--    UPDATE recursos_vinculados_tarea 
--    SET idrecurso = _idrecurso, 
 --       idtarea = _idtarea, 
 --       cantidad = _cantidad, 
  --      update_at = NOW()
 --   WHERE idrecurso_vinculado = _idrecurso_vinculado;
-- END $$
-- DELIMITER ;

-- *******************************************************************

DELIMITER $$
CREATE PROCEDURE actualizarActivoPorTarea(
    IN _idactivo_vinculado INT, 
    IN _idactivo INT, 
    IN _idtarea INT)
BEGIN
    UPDATE activos_vinculados_tarea 
    SET idactivo = _idactivo, 
        idtarea = _idtarea, 
        update_at = NOW()
    WHERE idactivo_vinculado = _idactivo_vinculado;
END $$
DELIMITER ;

-- *******************************************************************

-- DELIMITER $$
-- CREATE PROCEDURE actualizarDetalleRecurso(
  --  IN _iddetalle_recurso INT, 
 --   IN _stock_total INT, 
 --   IN _en_uso INT, 
 --   IN _en_reparacion INT, 
 --   IN _idestado INT)
-- BEGIN
  --  UPDATE detalle_recurso 
  --  SET stock_total = _stock_total, 
  --      en_uso = _en_uso, 
  --      en_reparacion = _en_reparacion,
  --      idestado = _idestado, 
  --      update_at = NOW()
  --  WHERE iddetalle_recurso = _iddetalle_recurso;
-- END $$
-- DELIMITER ;
-- ***********************************************************************
DROP PROCEDURE IF EXISTS `actualizarTareaEstado`
DELIMITER //
CREATE PROCEDURE `actualizarTareaEstado`
(
	IN _idtarea INT,
    IN _idestado INT,
    IN _trabajado BOOLEAN
)
BEGIN
	UPDATE tareas 
    SET idestado = _idestado,
		trabajado = _trabajado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
END //

call actualizarTareaEstado(2, 9, true)

-- *********************************************************************
DROP PROCEDURE IF EXISTS `actualizarTareaEstadoPausado`
DELIMITER //
CREATE PROCEDURE `actualizarTareaEstadoPausado`
(
	IN _idtarea INT,
    IN _pausado INT
)
BEGIN
	UPDATE tareas 
    SET pausado = _pausado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
END //
