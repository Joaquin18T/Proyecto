delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;


select *from activos_responsables;
select*from historial_activos where idactivo_resp=1;
select*from notificaciones ;
select*from activos;
select*from usuarios;
select*from personas;
select*from estados;
select*from bajas_activo;

DELETE FROM bajas_activo where idbaja_activo>=2;
UPDATE activos SET idestado = 3 WHERE idactivo = 2;    
ALTER TABLE bajas_activo AUTO_INCREMENT = 1;

UPDATE usuarios SET contrasena = '$2y$10$/w29oS1sTWIU7fJphQkoIeox2MbOlR8YLEOOG199o0Am5HZ9wADfa' WHERE id_usuario = 14;

UPDATE activos_responsables SET es_responsable = '1' WHERE idactivo_resp = 12;

SELECT
    NOF.idusuario,
    NOF.idnotificacion,
    NOF.tipo,
    NOF.estado,
    NOF.mensaje,
    MAX(NOF.fecha_creacion) AS fecha_creacion, -- Usamos MAX o alguna función agregada
    RES.idusuario,
    ACT.descripcion,
    RES.descripcion AS desresp,
    RES.idactivo_resp
FROM notificaciones NOF
RIGHT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
WHERE NOF.idusuario = 2
GROUP BY 
    NOF.idusuario,
    NOF.idnotificacion,
    NOF.tipo,
    NOF.estado,
    NOF.mensaje,
    RES.idusuario,
    ACT.descripcion,
    RES.descripcion,
    RES.idactivo_resp
ORDER BY MAX(NOF.fecha_creacion) DESC;


	SELECT 
		NOF.idusuario,
		NOF.idnotificacion,
		NOF.tipo,
		NOF.estado,
		NOF.mensaje,
		NOF.fecha_creacion
    FROM notificaciones NOF
	where NOF.idusuario = _idusuario AND
		(NOF.idusuario = _idusuario OR _idusuario IS NULL) 
        AND (NOF.idnotificacion = _idnotificacion OR _idnotificacion IS NULL)
        -- group by NOF.idnotificacion
    ORDER BY NOF.fecha_creacion DESC;


