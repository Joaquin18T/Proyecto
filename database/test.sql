delete from historial_activos WHERE idhistorial_activo>=11;
delete from activos_responsables WHERE idactivo_resp>=11;
delete from notificaciones WHERE idnotificacion>=1;

ALTER TABLE historial_activos AUTO_INCREMENT = 1;

-- 8: tiene usuario pero no rp
-- 9: ningun usuario
-- 4: tiene usuarios y rp
select* from activos_responsables where idactivo=12;
select* from activos_responsables where idusuario=5;
select*from historial_activos where idactivo_resp=15;
select*from notificaciones_activos where idactivo = 4;
select*from activos where idactivo =22; -- V456IJDKJSDASDA
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

SELECT *
FROM notificaciones_activos WHERE idactivo_resp = 4;

SELECT* FROM historial_activos WHERE idactivo_resp = 4;
        
SELECT distinct *
FROM notificaciones_activos NA
INNER JOIN historial_activos HA ON NA.idactivo_resp = HA.idactivo_resp 
WHERE HA.idactivo_resp = 4 ORDER BY HA.fecha_movimiento DESC;

SELECT * FROM historial_activos;



