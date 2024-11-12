DROP PROCEDURE IF EXISTS sp_user_login;
DELIMITER $$
CREATE PROCEDURE sp_user_login
(
	IN _usuario VARCHAR(120)
)
BEGIN
	SELECT
		US.idusuario,
        PE.apellidos, PE.nombres,
        US.nom_usuario,
        US.claveacceso,
        US.perfil,
        US.idperfil
		FROM usuarios US
        INNER JOIN personas PE ON PE.id_persona = US.idpersona
        WHERE US.nom_usuario = _usuario;
END $$

-- CALL sp_user_login('ana.martinez');

DROP PROCEDURE IF EXISTS sp_add_usuario;
DELIMITER $$
CREATE PROCEDURE sp_add_usuario
(
	OUT _idusuario INT,
    IN _idpersona INT,
    IN _nom_usuario VARCHAR(120),
    IN _claveacceso VARBINARY(255),
    IN _perfil CHAR(3),
    IN _idperfil INT,
    IN _idarea INT,
    IN _responsable_area TINYINT
)
BEGIN
	DECLARE existe_error INT DEFAULT 0;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO usuarios (idpersona, nom_usuario, claveacceso, perfil, idperfil, idarea, responsable_area)VALUES 
		(_idpersona, _nom_usuario, _claveacceso, _perfil, _idperfil, _idarea, _responsable_area);
        
	IF existe_error= 1 THEN
		SET _idusuario = -1;
	ELSE
        SET _idusuario = last_insert_id();
	END IF;
END $$

-- CALL sp_add_usuario(@iduser, 4, 'luka', 'luka2024', 'USR', 2, 1, 0);
-- SELECT @iduser as iduser;

DROP PROCEDURE IF EXISTS sp_update_usuario;
DELIMITER $$
CREATE PROCEDURE sp_update_usuario
(
	OUT _idpersona INT,
    IN _idusuario INT,
    IN _idperfil INT
)
BEGIN
	UPDATE usuarios SET
	idperfil = _idperfil,
    update_at = NOW()
    WHERE idusuario = _idusuario;
    
    SELECT idpersona INTO _idpersona
    FROM usuarios WHERE idusuario = _idusuario;
END $$

-- CALL sp_update_usuario(@idpersona,5,3);
-- SELECT @idpersona as idpersona;
-- UPDATE usuarios SET perfil = 'TNC' WHERE idusuario = 5;

DROP PROCEDURE IF EXISTS sp_cambiar_area_usuario;
DELIMITER $$
CREATE PROCEDURE sp_cambiar_area_usuario
(
	IN _idusuario INT,
    IN _idarea INT
)
BEGIN
	UPDATE usuarios SET
	idarea = _idarea
    WHERE idusuario = _idusuario;
END $$
-- CALL sp_cambiar_area_usuario(5, 2);
-- validar que el perfil escrito coincida con la llave foranea

DROP PROCEDURE IF EXISTS sp_filtrar_usuarios;
DELIMITER $$
CREATE PROCEDURE sp_filtrar_usuarios
(
    IN _dato VARCHAR(100),
	IN _num_doc VARCHAR(20),
    IN _idtipodoc INT,
	IN _estado TINYINT,
    IN _responsable_area TINYINT,
    IN _idarea INT,
    IN _idperfil INT
) 
BEGIN
	SELECT
		CONCAT(P.apellidos, ' ', P.nombres) AS dato, P.num_doc, P.genero, P.telefono, 
        TP.tipodoc,
        U.idusuario,U.nom_usuario, U.responsable_area, U.estado,
        A.area,
        PER.perfil
        FROM usuarios U
        INNER JOIN areas A ON U.idarea = A.idarea
        INNER JOIN perfiles PER ON U.idperfil = PER.idperfil
        INNER JOIN personas P ON U.idpersona = P.id_persona
        INNER JOIN tipo_doc TP ON P.idtipodoc = TP.idtipodoc
        WHERE 
			(P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL) 
            AND (P.num_doc LIKE CONCAT('%', _num_doc, '%') OR _num_doc IS NULL)
            AND (P.idtipodoc = _idtipodoc OR _idtipodoc IS NULL)
			AND (U.estado = _estado OR _estado IS NULL)
            AND (U.responsable_area = _responsable_area OR _responsable_area IS NULL)
            AND (U.idarea = _idarea OR _idarea IS NULL)
            AND (PER.idperfil = _idperfil OR _idperfil IS NULL);
END $$
-- CALL sp_filtrar_usuarios(null, null, null, 1, null, null, 3);

DROP PROCEDURE IF EXISTS sp_get_usuario_by_id;
DELIMITER $$
CREATE PROCEDURE sp_get_usuario_by_id
(
	IN _idusuario INT
)
BEGIN
	SELECT
		P.apellidos,P.nombres AS dato, P.num_doc, P.genero, P.telefono, 
        TP.tipodoc,
        U.idusuario,U.nom_usuario, U.responsable_area, U.estado, U.perfil, U.idperfil,
        A.area
		FROM usuarios U
        INNER JOIN areas A ON U.idarea = A.idarea
        INNER JOIN personas P ON U.idpersona = P.id_persona
        INNER JOIN tipo_doc TP ON P.idtipodoc = TP.idtipodoc
        WHERE idusuario = _idusuario;
END $$
-- CALL sp_get_usuario_by_id(2);

DROP PROCEDURE IF EXISTS sp_update_estado_usuario;
DELIMITER $$
CREATE PROCEDURE sp_update_estado_usuario
(
	IN _idusuario INT,
    IN _estado TINYINT
)
BEGIN
	UPDATE usuarios SET
    estado = _estado 
    WHERE idusuario = _idusuario;
END $$
-- CALL sp_update_estado_usuario(5, 1)

DROP PROCEDURE IF EXISTS sp_search_nom_usuario;
DELIMITER $$
CREATE PROCEDURE sp_search_nom_usuario
(
	IN _nom_usuario VARCHAR (120)
)
BEGIN
	SELECT idusuario, idpersona, responsable_area, perfil, idperfil, idarea
    FROM usuarios WHERE nom_usuario = _nom_usuario;
END $$

-- CALL sp_search_nom_usuario('luka');