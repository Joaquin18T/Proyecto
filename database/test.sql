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
UPDATE activos SET idestado = 2 WHERE idactivo = 5;
UPDATE usuarios SET contrasena = '$2y$10$/w29oS1sTWIU7fJphQkoIeox2MbOlR8YLEOOG199o0Am5HZ9wADfa' WHERE id_usuario = 14;

UPDATE activos_responsables SET es_responsable = '1' WHERE idactivo_resp = 12;
SELECT * from activos_responsables where idactivo = 9;

insert into bajas_activo(idactivo, motivo, ruta_doc, aprobacion) VALUES
	(3, 'problemas frecuentes en su funcionamiento', 'C:/xampp/htdocs/CMMS/uploads/CAM123-Plan mantenimiento.pdf', 1);


