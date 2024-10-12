use gamp;

DROP VIEW IF EXISTS v_personas;
CREATE VIEW v_personas AS
	SELECT * FROM personas;

DROP PROCEDURE IF EXISTS  sp_register_person;
DELIMITER $$
CREATE PROCEDURE sp_register_person
(
	IN _idtipodoc INT,
    IN _num_doc	VARCHAR(30),
    IN _apellidos VARCHAR(100),
    IN _nombres VARCHAR(100),
    IN _genero	CHAR(1),
    IN _telefono CHAR(9),
    IN _nacionalidad VARCHAR(50)
)
BEGIN
	INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono, nacionalidad) VALUES 
    (_idtipodoc, _num_doc, _apellidos, _nombres, _genero, _telefono, _nacionalidad);
    
    SELECT last_insert_id() as idpersona;
END $$
-- CALL sp_register_person(1, '35255456','Ortiz Huaman', 'Pablo', 'M', '928483244', 'Peruana');

DROP PROCEDURE IF EXISTS sp_persona_by_numdoc;
DELIMITER $$
CREATE PROCEDURE sp_persona_by_numdoc
(
	IN _num_doc VARCHAR(50)
)
BEGIN
	SELECT 
		USU.usuario,
		PER.idtipodoc, 
		PER.apellidos, 
        PER.nombres, 
        PER.telefono, 
        PER.genero, 
        PER.nacionalidad,
        USU.idrol,
        USU.contrasena
    FROM usuarios USU
    RIGHT JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE PER.num_doc=_num_doc;
END $$

DELIMITER $$
CREATE PROCEDURE sp_search_telefono
(
	IN _telefono CHAR(9)
)
BEGIN
	SELECT id_persona FROM personas WHERE telefono =_telefono;
END $$
-- SELECT*FROM usuarios;

DROP PROCEDURE IF EXISTS sp_update_persona;
DELIMITER $$
CREATE PROCEDURE sp_update_persona
(
	IN _idpersona INT,
    IN _idtipo_doc INT,
    IN _num_doc VARCHAR(50),
    IN _apellidos VARCHAR(100),
    IN _nombres VARCHAR(100),
    IN _genero CHAR(1),
    IN _telefono CHAR(9),
    IN _nacionalidad VARCHAR(50)
)
BEGIN
	UPDATE personas SET
	idtipodoc = _idtipo_doc,
    num_doc = _num_doc,
    apellidos = _apellidos,
    nombres = _nombres,
    genero = _genero,
    telefono = _telefono,
    nacionalidad = _nacionalidad
    WHERE id_persona = _idpersona;
END $$

-- CALL sp_update_persona(1, 1, '12637743', 'Gonzalez', 'Juan', 'M', '982453845', 'Peruana');
