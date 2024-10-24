use gamp;

DROP PROCEDURE IF EXISTS `asignarResponsables`
DELIMITER //
CREATE PROCEDURE `asignarResponsables`
(
	OUT _idresponsable_asignado INT,
	IN _idorden_trabajo INT,
    IN _idresponsable INT
)
BEGIN
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
END
select * from usuarios;
select * from odt;
select * from responsables_asignados_odt;

DROP PROCEDURE IF EXISTS `obtenerUsuario`
DELIMITER //
CREATE PROCEDURE `obtenerUsuario`
(
	IN _idusuario INT
)
BEGIN
	SELECT  * FROM usuarios WHERE idusuario = _idusuario;
END	//

DROP PROCEDURE IF EXISTS `obtenerResponsablesPorOdt`
DELIMITER //
CREATE PROCEDURE `obtenerResponsablesPorOdt`
(
	IN _idorden_trabajo INT
)
BEGIN
	SELECT 
		RA.idresponsable_asignado, RA.idorden_trabajo, RA.idresponsable,
        USU.usuario
		FROM responsables_asignados_odt RA
	INNER JOIN usuarios USU ON USU.idusuario = RA.idresponsable
    WHERE idorden_trabajo = _idorden_trabajo;
END //

select * from responsables_asignados_odt;
select * from usuarios;

DROP PROCEDURE IF EXISTS `eliminarResponsableOdt`
DELIMITER //
CREATE PROCEDURE `eliminarResponsableOdt`
(
	IN _idresponsable_asignado INT
)
BEGIN
	DELETE FROM responsables_asignados_odt WHERE idresponsable_asignado = _idresponsable_asignado;
END //

CALL eliminarResponsableOdt(19);

DROP PROCEDURE IF EXISTS `obtenerResponsables`
DELIMITER //
CREATE PROCEDURE `obtenerResponsables`
(
	IN _idodt INT
)
BEGIN
	SELECT 
		RODT.idorden_trabajo,
		RODT.idresponsable,
        RODT.idresponsable_asignado,
        CONCAT(PER.apellidos,' ',PER.nombres) as nombres
    FROM responsables_asignados_odt RODT 
	INNER JOIN usuarios USU ON USU.id_usuario = RODT.idresponsable
    INNER JOIN personas PER ON PER.id_persona = USU.idpersona
	WHERE idorden_trabajo = _idodt;
END //

