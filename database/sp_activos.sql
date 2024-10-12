use gamp;

-- ACTIVO 10/10
DROP PROCEDURE IF EXISTS sp_add_activo;
DELIMITER $$
CREATE PROCEDURE sp_add_activo
(
	OUT _idactivo	INT,
	IN _idsubcategoria INT,
	IN _idmarca INT,
    IN _modelo VARCHAR(60),
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _descripcion VARCHAR(200),
    IN _especificaciones JSON
)
BEGIN
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
END $$ 

DROP PROCEDURE IF EXISTS searchby_code;
DELIMITER $$
CREATE PROCEDURE searchby_code
(
	IN _cod_identificacion CHAR(40)
)
BEGIN
	SELECT modelo FROM activos WHERE cod_identificacion = _cod_identificacion;
END $$


DROP PROCEDURE IF EXISTS sp_search_activo;
DELIMITER $$
CREATE PROCEDURE sp_search_activo
(
	IN _descripcion VARCHAR(40)
)
BEGIN
	SELECT DISTINCT  ACT.idactivo, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
    INNER JOIN activos_responsables RES ON ACT.idactivo = RES.idactivo
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.descripcion LIKE CONCAT('%', _descripcion,'%') AND ACT.idestado!=4 
	ORDER BY SUB.subcategoria ASC;
END $$
-- CALL sp_search_activo('D');

DROP VIEW IF EXISTS v_all_activos;
CREATE VIEW v_all_activos AS
	SELECT 
		ACT.idactivo,
        ACT.cod_identificacion,
        ACT.modelo,
        ACT.fecha_adquisicion,
		USU.usuario,
		EST.nom_estado
        FROM activos ACT
        LEFT JOIN activos_responsables RES ON ACT.idactivo = RES.idactivo
        LEFT JOIN usuarios USU ON RES.idusuario = USU.id_usuario
        INNER JOIN estados EST ON ACT.idestado = EST.idestado;
        
DROP PROCEDURE IF EXISTS sp_filter_by_subcategorias;
DELIMITER $$
CREATE PROCEDURE sp_filter_by_subcategorias
(
	IN _idsubcategoria INT
)
BEGIN
	SELECT DISTINCT MAR.idmarca, MAR.marca
	FROM marcas MAR
	INNER JOIN activos ACT ON MAR.idmarca = ACT.idmarca
	WHERE ACT.idsubcategoria = _idsubcategoria;
END $$


DROP PROCEDURE IF EXISTS sp_search_by_activo;
DELIMITER $$
CREATE PROCEDURE sp_search_by_activo
(
	IN _idactivo INT
)
BEGIN
	SELECT
		RES.idusuario,
		RES.idactivo_resp,
		CONCAT(PER.apellidos,' ',PER.nombres) as nombres,
        ROL.rol,
        RES.es_responsable,
        (SELECT COUNT(R.idactivo_resp) FROM activos_responsables R
WHERE R.idusuario = RES.idusuario) as cantidad,
        USU.estado
	FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    INNER JOIN roles ROL ON USU.idrol = ROL.idrol
    WHERE RES.idactivo = _idactivo;
END $$

DROP PROCEDURE IF EXISTS sp_list_activos;
DELIMITER $$
CREATE PROCEDURE sp_list_activos
(
	IN _idsubcategoria INT,
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _idestado INT,
    IN _idmarca INT
)
BEGIN
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
        ACT.especificaciones
	FROM activos ACT
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    WHERE (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL)
    AND (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL)
    AND (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL)
    AND (MAR.idmarca = _idmarca OR _idmarca IS NULL);
END $$
-- CALL sp_list_activos('','','','','');

-- HACER SABADO
DROP PROCEDURE IF EXISTS sp_update_estado_activo;
DELIMITER $$
CREATE PROCEDURE sp_update_estado_activo
(
	IN _idactivo INT,
    IN _idestado INT
)
BEGIN
	UPDATE activos SET
    idestado = _idestado
    WHERE idactivo = _idactivo;
END $$

DROP PROCEDURE IF EXISTS sp_update_activo;
DELIMITER $$
CREATE PROCEDURE sp_update_activo
(
	IN _idactivo INT,
	IN _idsubcategoria INT,
	IN _idmarca INT,
    IN _modelo VARCHAR(60),
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _descripcion VARCHAR(200),
    IN _especificaciones JSON
)
BEGIN
	UPDATE activos SET
    idsubcategoria = _idsubcategoria,
    idmarca = _idmarca,
    modelo = _modelo,
    cod_identificacion = _cod_identificacion,
    fecha_adquisicion = _fecha_adquisicion,
    descripcion = _descripcion,
    especificaciones = _especificaciones
    WHERE idactivo = _idactivo;
END $$

DROP PROCEDURE IF EXISTS sp_search_update_activo;
DELIMITER $$
CREATE PROCEDURE sp_search_update_activo
(
	IN _idactivo INT
)
BEGIN
		SELECT
		ACT.idactivo,
        ACT.idsubcategoria,
        CAT.categoria,
        ACT.idmarca,
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
END $$
-- CALL sp_update_activo(1, 1,1, 1,'D4 R', NOW(), 'Laptop D4 LG', '{"ram":"32GB", "disco":"solido", "color":"rojo"}');



