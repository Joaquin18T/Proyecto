delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;


select* from activos_responsables where idactivo=3;
select*from historial_activos where idactivo_resp=1;
select*from notificaciones where idusuario = 2;
select*from activos;
select*from usuarios;
select*from personas;
select*from estados;
select*from bajas_activo;
select*from marcas;
select*from subcategorias;

DELETE FROM bajas_activo where idbaja_activo>=2;
DELETE FROM notificaciones where idusuario =2;
DELETE FROM historial_activos where idhistorial_activo =14;
DELETE FROM activos where idactivo =29;
UPDATE activos SET idestado = 3 WHERE idactivo = 5;    
ALTER TABLE detalles_marca_subcategoria AUTO_INCREMENT = 1;
UPDATE activos SET idestado = 2 WHERE idactivo = 5;
UPDATE usuarios SET contrasena = '$2y$10$/w29oS1sTWIU7fJphQkoIeox2MbOlR8YLEOOG199o0Am5HZ9wADfa' WHERE id_usuario = 14;

UPDATE activos_responsables SET es_responsable = '1' WHERE idactivo_resp = 16;
UPDATE activos_responsables SET fecha_designacion  = NULL WHERE idactivo_resp = 2;
UPDATE usuarios SET estado = '1' WHERE id_usuario = 15; 
SELECT * from activos_responsables where idactivo = 1;

insert into bajas_activo(idactivo, motivo, ruta_doc, aprobacion) VALUES
	(3, 'problemas frecuentes en su funcionamiento', 'C:/xampp/htdocs/CMMS/uploads/CAM123-Plan mantenimiento.pdf', 1);

insert into historial_activos(idactivo_resp, idubicacion) VALUES
	(4, 5);

SELECT
    NOF.idusuario,
    NOF.idnotificacion,
    NOF.tipo,
    NOF.estado,
    NOF.mensaje,
    NOF.fecha_creacion
FROM notificaciones NOF
WHERE NOF.idusuario = 2
ORDER BY NOF.fecha_creacion DESC


