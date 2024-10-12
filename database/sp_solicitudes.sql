use gamp;
-- LISTAR SOLICITUDES
CREATE VIEW v_all_solicitudes AS
	SELECT
		SOL.idsolicitud,
		USU.usuario,
        ACT.modelo,
        ACT.cod_identificacion,
        SOL.fecha_solicitud,
        SOL.estado_solicitud
		FROM solicitudes_activos SOL
        INNER JOIN usuarios USU ON SOL.idusuario = USU.id_usuario
        INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo;


-- AGREGAR SOLICITUD (fecha_solicitud, estado_solicitud) campo idautorizador es null??
DELIMITER $$
CREATE PROCEDURE sp_add_solicitud
(
	IN _idusuario INT,
    IN _idactivo INT,
    IN _motivo_solicitud VARCHAR(500)
)
BEGIN
	INSERT INTO solicitudes_activos (idusuario, idactivo, motivo_solicitud) VALUES
		(_idusuario, _idactivo, _motivo_solicitud);
	SELECT @@last_insert_id as idsolicitud;
END $$

-- SI LA SOLICITUD ES APROBADA O RECHAZADA... (fecha_respuesta)
DELIMITER $$
CREATE PROCEDURE sp_check_solicitud
(
	IN _idsolicitud INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _estado_solicitud ENUM('pendiente', 'aprobado','rechazado'), -- (se elegira el estado si es aprobado o rechazado)
    IN _idautorizador INT,
    IN _coment_autorizador VARCHAR(500)
)
BEGIN
	UPDATE solicitudes_activos SET
    idactivo = _idactivo,
    idusuario = _idusuario,
    estado_solicitud = _estado_solicitud,
    idautorizador = _idautorizador,
    coment_autorizador = _coment_autorizador,
    fecha_respuesta = NOW()
    WHERE idsolicitud = _idsolicitud;
END $$
-- CALL sp_check_solicitud(1,2, 'aprobado', 1, null,1);
-- select*from solicitudes_activos;
-- LISTADO APROBADOS
DELIMITER $$
CREATE PROCEDURE sp_list_pass
(
	IN _estado_solicitud ENUM('pendiente','aprobado','rechazado')
)	
BEGIN
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
END $$
-- CALL sp_list_pass('pendiente')
-- select*from usuarios;

-- BUSCADOR (usuario - cod_identificacion activo)
DELIMITER $$
CREATE PROCEDURE sp_search_solicitud
(
	IN _valor VARCHAR(50)
)
BEGIN
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
END $$       
-- SELECT*FROM solicitudes_activos
-- SELECT*FROM activos
-- CALL sp_search_solicitud('');
-- El usuario no puede solicitar el mismo activo cuando la solicitud esta pendiente o activo
-- El usuario puede solicitar el mismo activo si su solicitud fue rechazada anteriormente
DELIMITER $$
CREATE PROCEDURE sp_request_duplicate
(
	IN _idusuario INT,
	IN _idactivo INT
)
BEGIN
	SELECT
		COUNT(*) as cantidad
        FROM solicitudes_activos
        WHERE idusuario=_idusuario AND idactivo=_idactivo AND(estado_solicitud='pendiente' OR estado_solicitud='aprobado');
END $$
-- CALL sp_request_duplicate(1,2);





		
