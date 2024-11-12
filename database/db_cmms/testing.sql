-- PRUEBAS

-- UPDATE usuarios SET claveacceso = '$2y$10$M9oVu51MvWQfjA0Lr6lRZOqHK3lWlz9SPMT/FvG8UfkezBctOpWNK' WHERE idusuario = 2;

SELECT* FROM tipo_doc;
SELECT*FROM personas;
SELECT*FROM areas;
SELECT*FROM usuarios;
SELECT*FROM subcategorias;
SELECT*FROM marcas;
SELECT*FROM activos;
SELECT*FROM estados;
SELECT*FROM tipo_estados;
SELECT*FROM activos_asignados;
SELECT*FROM historial_asignaciones_activos;
SELECT*FROM notificaciones_asignaciones;
SELECT*FROM bajas_activo;

SELECT*FROM perfiles;
SELECT*FROM modulos;
SELECT*FROM vistas;
select*from permisos;

-- ALTER TABLE permisos auto_increment = 1;
-- delete from permisos where idpermiso>=1;
-- delete from vistas where idvista>=1;
-- delete from modulos where idmodulo>=1;
-- delete from tipo_doc WHERE idtipodoc=3;
-- delete from usuarios WHERE idusuario=4;
-- delete from personas WHERE id_persona=5;
-- delete from tipo_estados WHERE idtipo_estado>=1;
-- delete from estados WHERE idestado>=1;
-- delete from activos where idactivo>=1;
-- delete from activos_asignados WHERE idactivo_asig>=1;
-- delete from categorias WHERE idcategoria>=1;
-- delete from subcategorias WHERE idsubcategoria>=1;
-- delete from detalles_marca_subcategoria WHERE iddetalle_marca_sub>=1;
-- delete from marcas WHERE idmarca>=1;