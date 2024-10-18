use gamp;

DELIMITER ;

DROP PROCEDURE IF EXISTS `insertarPlanDeTareas`
DELIMITER $$
CREATE PROCEDURE `insertarPlanDeTareas`(
	OUT _idplantarea INT,
	IN _descripcion VARCHAR(30)
)
BEGIN
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
END $$
DELIMITER ;

-- CALL insertarPlanDeTareas('Mantenimiento SIS');
-- select * from tareas;
-- *******************************************************************************

DROP PROCEDURE IF EXISTS `insertarTarea`
DELIMITER $$
CREATE PROCEDURE `insertarTarea`(
	OUT _idtarea INT,
    IN _idplantarea INT,
    IN _idtipo_prioridad INT,
    IN _descripcion VARCHAR(200),
    IN _fecha_inicio DATE,
    IN _fecha_vencimiento DATE,
    IN _cant_intervalo INT,
    IN _frecuencia VARCHAR(10),
    IN _idestado INT
)
BEGIN
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
END $$
DELIMITER ;

-- CALL insertarTarea(
--    1,  -- idplantarea (supongamos que es 1)
--    2,  -- idtipo_prioridad (supongamos que es 2)
--    'Revisión de Ventilador', '02:00:00', '2024-10-01 08:00:00', 
--    '2024-10-31 17:00:00', 3, 'Mensual', 1
-- );

 
-- *******************************************************************************
-- DROP PROCEDURE IF EXISTS `insertarRecursoPorTarea`
-- DELIMITER $$
-- CREATE PROCEDURE `insertarRecursoPorTarea`(
--    IN _idrecurso INT,
 --   IN _idtarea INT,
--    IN _cantidad SMALLINT
-- )
-- BEGIN
 --   INSERT INTO recursos_vinculados_tarea (idrecurso, idtarea, cantidad)
  -- VALUES (_idrecurso, _idtarea, _cantidad);
   
 --   SELECT MAX(idrecurso_vinculado) as id FROM recursos_vinculados_tarea;
-- END $$
-- DELIMITER ;

-- ********************************************************************

DROP PROCEDURE IF EXISTS `insertarActivoPorTarea`
DELIMITER $$
CREATE PROCEDURE `insertarActivoPorTarea`(
	OUT _idactivo_vinculado INT,
    IN _idactivo INT,
    IN _idtarea INT
)
BEGIN
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
END $$
DELIMITER ;

-- CALL insertarActivoPorTarea(4, 30);  -- idactivo 1, idtarea 1
-- select * from activos_vinculados_tarea;

-- *********************************************************************

-- FUTUROS PROCEDIMIENTOS ALMACENADOS CUANDO SE REGISTRE UN RECURSO AHI SE TENDRA QUE ASIGNAR AL ID CATEGORIA 
