delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;

-- 8: tiene usuario pero no rp
-- 9: ningun usuario
-- 4: tiene usuarios y rp
select* from activos_responsables where idactivo=9;
select* from activos_responsables where idusuario=4;
select*from historial_activos where idactivo_resp=3;
select*from notificaciones_activos where idactivo_resp = 3;
select*from activos where idactivo =26;
select*from usuarios;
select*from personas;
select*from estados;
select*from bajas_activo;
select*from marcas;
select*from subcategorias;
select*from ubicaciones;

DELETE FROM bajas_activo where idbaja_activo=51;
DELETE FROM activos_responsables where idactivo_resp=25;
DELETE FROM notificaciones_activos where idactivo_resp =5;
DELETE FROM notificaciones_activos where idnotificacion_activo=33;
DELETE FROM historial_activos where idhistorial_activo =64;
DELETE FROM activos where idactivo =29;
  
ALTER TABLE detalles_marca_subcategoria AUTO_INCREMENT = 1;
UPDATE activos SET idestado = 2 WHERE idactivo = 5;
UPDATE usuarios SET contrasena = '$2y$10$/w29oS1sTWIU7fJphQkoIeox2MbOlR8YLEOOG199o0Am5HZ9wADfa' WHERE id_usuario = 14;

UPDATE activos_responsables SET es_responsable = '1' WHERE idactivo_resp = 16;
UPDATE activos_responsables SET fecha_designacion  = NULL WHERE idactivo_resp = 5;
UPDATE notificaciones_activos SET tipo = 'Asignacion', mensaje= 'Te han asignado un nuevo activo' WHERE idnotificacion_activo = 1;
UPDATE usuarios SET estado = '1' WHERE id_usuario = 15; 
SELECT * from activos_responsables where idactivo = 1;

-- eliminar el doc
UPDATE activos SET idestado = 4 WHERE idactivo = 4;  
DELETE FROM bajas_activo where idbaja_activo>=11;
DELETE FROM historial_activos where idhistorial_activo >=47;
DELETE FROM notificaciones_activos where idnotificacion_activo >=22;

UPDATE activos SET idestado = 4 WHERE idactivo = 8;  
DELETE FROM bajas_activo where idbaja_activo=44;
DELETE FROM historial_activos where idhistorial_activo >=47;
DELETE FROM notificaciones_activos where idactivo_resp >9;

insert into bajas_activo(idactivo, motivo, ruta_doc, aprobacion) VALUES
	(3, 'problemas frecuentes en su funcionamiento', 'C:/xampp/htdocs/CMMS/uploads/CAM123-Plan mantenimiento.pdf', 1);

insert into historial_activos(idactivo_resp, idubicacion) VALUES
	(21, 3);



