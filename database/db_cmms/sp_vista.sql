-- VISTAS
DROP PROCEDURE IF EXISTS sp_listar_vistas;
DELIMITER $$
CREATE PROCEDURE sp_listar_vistas
(
)
BEGIN
	SELECT
		V.idvista,
		P.perfil,
		M.modulo,
        V.ruta,
        V.isVisible,
        V.texto,
        V.icono
        FROM permisos PER
        INNER JOIN perfiles P ON PER.idperfil = P.idperfil
        INNER JOIN vistas V ON PER.idvista = V.idvista
        INNER JOIN modulos M ON V.idmodulo = M.idmodulo;
END $$

-- CALL sp_listar_vistas();

DROP PROCEDURE IF EXISTS sp_obtener_permisos;
DELIMITER $$
CREATE PROCEDURE sp_obtener_permisos
(
	IN _idperfil INT
)
BEGIN
	SELECT 
		PRM.idpermiso,
        M.modulo,
        V.idvista, V.ruta, V.isVisible, V.texto, V.icono
        FROM permisos PRM
		INNER JOIN vistas V ON PRM.idvista = V.idvista
        LEFT JOIN modulos M ON V.idmodulo = M.idmodulo
        WHERE PRM.idperfil = _idperfil;
END $$
CALL sp_obtener_permisos(1);