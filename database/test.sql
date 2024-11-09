delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;

-- 8: tiene usuario pero no rp
-- 9: ningun usuario
-- 4: tiene usuarios y rp
select* from activos_responsables where idactivo=6;
select* from activos_responsables where idusuario=8;
select*from historial_activos where idactivo_resp=15;
select*from notificaciones_activos where idactivo = 57;
select*from notificaciones_mantenimiento where idactivo = 57;
select*from activos where idactivo =8; -- V456IJDKJSDASDA
select*from activos where cod_identificacion ='DASYU435BMADASD'; -- DASYU435BMADASD 
select*from usuarios;
select*from personas right join usuarios on personas.id_persona = usuarios.idpersona;
select*from estados;
select*from bajas_activo;
select*from marcas;
select*from subcategorias;
select*from ubicaciones;
select*from especificacionesDefecto;

DELETE FROM bajas_activo where idbaja_activo=59;
DELETE FROM activos_responsables where idactivo_resp=22;
DELETE FROM notificaciones_activos where idnotificacion_activo >53;
DELETE FROM notificaciones_activos where idactivo_resp=22;
DELETE FROM historial_activos where idhistorial_activo =94;
DELETE FROM activos where idactivo >=47 and idactivo <53;
  
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
DELETE FROM notificaciones_activos where idnotificacion_activo =8;

UPDATE activos SET idestado = 4 WHERE idactivo = 8;  
DELETE FROM bajas_activo where idbaja_activo=44;
DELETE FROM historial_activos where idhistorial_activo >=47;
DELETE FROM notificaciones_activos where idactivo_resp >9;

select*from plandetareas;
SELECT * FROM tareas inner join estados ON tareas.idestado=estados.idestado;
SELECT * FROM odt;
SELECT*FROM notificaciones_mantenimiento;

-- INSERT INTO odt (idtarea, creado_por) VALUES
-- 	(1, 1);

-- INSERT INTO notificaciones_mantenimiento (idorden_trabajo, tarea, activos, idresp, mensaje) VALUES
-- 	(1, 'Cambio de rodillos', 'Impresora DR 5, Impresora HP 5T',20, 'Se ha creado una tarea a un activo asignado');



