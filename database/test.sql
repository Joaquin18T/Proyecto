delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;

select *from activos_responsables;
select*from historial_activos;
select*from notificaciones;
select*from activos;
select*from usuarios;
select*from personas;
select*from estados;

	set @es_responsable = (SELECT COUNT(idusuario) cantidad FROM activos_responsables where es_responsable =1 AND idactivo=3);
	select @es_responsable;
	SELECT
		RES.idusuario,
		RES.idactivo_resp,
		CONCAT(PER.apellidos,' ',PER.nombres) as nombres,
        ROL.rol,
        (SELECT COUNT(R.idactivo_resp) FROM activos_responsables R
WHERE R.idusuario = RES.idusuario) as cantidad,
        USU.estado
	FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    INNER JOIN roles ROL ON USU.idrol = ROL.idrol
    WHERE RES.idactivo = 1;
    

-- o 
SELECT
    RES.idusuario,
    RES.idactivo_resp,
    CONCAT(PER.apellidos, ' ', PER.nombres) AS nombres,
    ROL.rol,
    COALESCE(count_activos.cantidad, 0) AS cantidad,
    USU.estado
FROM activos_responsables RES
INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
INNER JOIN personas PER ON USU.idpersona = PER.id_persona
INNER JOIN roles ROL ON USU.idrol = ROL.idrol
LEFT JOIN (
    SELECT idusuario, COUNT(idactivo_resp) AS cantidad 
    FROM activos_responsables 
    GROUP BY idusuario
) AS count_activos ON count_activos.idusuario = RES.idusuario
WHERE RES.idactivo = 1;

    
