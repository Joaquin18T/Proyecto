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
select*from bajas_activo;

DELETE FROM bajas_activo where idbaja_activo>=2;
UPDATE activos SET idestado = 3 WHERE idactivo = 2;    
ALTER TABLE bajas_activo AUTO_INCREMENT = 1;

UPDATE usuarios SET contrasena = '$2y$10$/w29oS1sTWIU7fJphQkoIeox2MbOlR8YLEOOG199o0Am5HZ9wADfa' WHERE id_usuario = 14;

UPDATE activos_responsables SET es_responsable = '1' WHERE idactivo_resp = 12;




