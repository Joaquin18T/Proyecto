DROP PROCEDURE IF EXISTS sp_list_users;
DELIMITER $$
CREATE PROCEDURE sp_list_users
(
)
BEGIN
	SELECT
    US.id_usuario,
    US.usuario,
    RO.rol
    FROM usuarios US
    INNER JOIN roles RO ON US.idrol = RO.idrol
    WHERE US.estado=1;
END $$

DROP PROCEDURE IF EXISTS sp_list_persona_users;
DELIMITER $$
CREATE PROCEDURE sp_list_persona_users
(
	IN _idrol INT,
    IN _idtipodoc INT,
    IN _estado CHAR(1),
    IN _dato VARCHAR(50)
)
BEGIN
	SELECT
		U.id_usuario,
		U.usuario,
        R.rol,
        CONCAT(P.apellidos,' ',P.nombres) as nombres,
        P.num_doc,
        P.telefono,
        P.genero,
        P.nacionalidad
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    WHERE (R.idrol = _idrol OR _idrol IS NULL) 
    AND (U.estado = _estado OR _estado IS NULL) 
    AND (TD.idtipodoc=_idtipodoc OR _idtipodoc IS NULL)
    AND (P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
END $$
-- CALL sp_list_persona_users(1,null,null,null);
        


DROP PROCEDURE IF EXISTS sp_user_login;
DELIMITER $$
CREATE PROCEDURE sp_user_login
(
	IN _usuario VARCHAR(120)
)
BEGIN
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
END $$

DROP PROCEDURE IF EXISTS sp_register_user;
DELIMITER $$
CREATE PROCEDURE sp_register_user
(
	IN _idpersona 	INT,
    IN _idrol		INT,
    IN _usuario		VARCHAR(120),
    IN _contrasena	VARCHAR(120)
)
BEGIN
	INSERT INTO usuarios (idpersona, idrol, usuario, contrasena)
    VALUES (_idpersona, _idrol, _usuario, _contrasena);
END $$

-- CALL sp_register_user(4,2,'pablo35a', '$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG');

DROP PROCEDURE IF EXISTS sp_search_user;
DELIMITER $$
CREATE PROCEDURE sp_search_user
(
	IN _usuario VARCHAR(120)
)
BEGIN
	SELECT id_usuario FROM usuarios WHERE usuario = _usuario;
END $$

DROP PROCEDURE IF EXISTS sp_getUser_by_id;
DELIMITER $$
CREATE PROCEDURE sp_getUser_by_id
(
	IN _idusuario INT
)
BEGIN
	SELECT usuario FROM usuarios WHERE id_usuario = _idusuario;
END $$


DROP PROCEDURE IF EXISTS sp_update_usuario;
DELIMITER $$
CREATE PROCEDURE sp_update_usuario
(
	OUT _idpersona INT,
	IN _idusuario INT,
    IN _idrol	INT,
    IN _usuario VARCHAR(120)
)
BEGIN
	UPDATE usuarios SET
    idrol = _idrol,
    usuario = _usuario
    WHERE id_usuario = _idusuario;
    
    SELECT idpersona INTO _idpersona
    FROM usuarios WHERE id_usuario = _idusuario;
END $$

DROP PROCEDURE IF EXISTS sp_update_estado_usuario;
DELIMITER $$
CREATE PROCEDURE sp_update_estado_usuario
(
	IN _idusuario INT,
    IN _estado CHAR(1)
)
BEGIN
	UPDATE usuarios SET
    estado = _estado
    WHERE id_usuario = _idusuario;
END $$

DROP PROCEDURE IF EXISTS sp_update_claveacceso;
DELIMITER $$
CREATE PROCEDURE sp_update_claveacceso
(
	IN _idusuario INT,
    IN _contrasena VARCHAR(120)
)
BEGIN
	UPDATE usuarios SET
    contrasena = _contrasena
    WHERE id_usuario = _idusuario;
END $$