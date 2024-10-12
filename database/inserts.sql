USE gamp;

INSERT INTO TIPO_DOC (tipodoc) VALUES 
('DNI'),
('Carnet de Extranjería');

INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono, nacionalidad) VALUES 
(1, '12345678', 'González', 'Juan', 'M', '987654321', 'Peruano'),
(2, 'A1234567', 'Smith', 'Anna', 'F', '987654322', 'Chilena'),
(2, 'EX123456', 'Martínez', 'Carlos', 'M', '987654323', 'Colombiano'),
(1, '35255456','Ortiz Huaman', 'Pablo', 'M', '928483244', 'Peruana'),
(1, '72754752', 'Avalos Romero', 'Royer Alexis', 'M', '936439633','Peruano'),
(1, '72754751', 'Avalos Romero', 'Pedro Aldair', 'M', '995213305','Peruano');

INSERT INTO ROLES (rol) VALUES 
('Administrador'),
('Usuario');

INSERT INTO USUARIOS (idpersona, idrol, usuario, contrasena) VALUES 
(1, 1, 'j.gonzalez', '$2y$10$TpMmHZcum7YJqXOqTrsDy.WheLpUnU98OZjc4WqLgPke9HlX6ZaJS'),
(2, 2, 'a.smith', '$2y$10$HdD325QAWm7QpH7KXtRdROBKe39KwDQr6l4K83u2a0w5h/d6yNgau'),
(3, 2, 'c.martinez', '$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG'),
(4,2,'pablo35a', '$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO'),
(4, 2, 'r.avalos', '$2y$10$VrxeMCQteaNdX6LwxoZEYevp8BCwKTpIKTVebChbXcxnNX7BTIFaW'),
(5, 1, 'p.avalos', '$2y$10$j1KccY6Iex7h19WR0pfMpumhp.dsjJkBCcFUbtVwbPCHw7hECJNyW');

-- UPDATE usuarios SET contrasena = '$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO' WHERE id_usuario=4;
-- SELECT * FROM activos;
INSERT INTO permisos(idrol, permiso)
VALUES
    (2, '{"activos":{"registerActivo":{"read":true,"create":true,"update":false,"delete":false}, "Responsables":{"read":true,"create":true,"update":false,"delete":false},"Activos":{"read":true,"create":true,"update":false,"delete":false}},"ODT":{"read":true,"create":true,"update":false,"delete":false},"planTarea":{"read":true,"create":false,"update":false,"delete":false},"bajaActivo":{"read":true,"create":true,"update":false,"delete":false},"usuarios":{"ListaUsuario":{"read":false,"create":false,"update":false,"delete":false},"PermisoRol":{"read":false,"create":false,"update":false,"delete":false}}}'),
    (1, '{"activos":{"registerActivo":{"read":true,"create":true,"update":true,"delete":true}},"ODT":{"read":true,"create":true,"update":true,"delete":false},"PlanTarea":{"read":true,"create":true,"update":false,"delete":false},"BajaActivo":{"read":true,"create":true,"update":true,"delete":false},"usuarios":{"ListaUsuario":{"read":true,"create": true,"update":true,"delete":true},"PermisoRol":{ "read":true,"create": true, "update":true, "delete":true}}}');

-- DROP TABLE permisos;
INSERT INTO categorias(categoria)
	VALUES
    ('Tecnologia'),
    ('Equipo Pesado'),
    ('Equipo de Produccion'),
    ('Transporte');
    

INSERT INTO subcategorias(idcategoria, subcategoria)
	VALUES
		(1, 'Computadora'),
		(1, 'Laptop'),
		(2, 'Maquinaria Industrial'),
		(2, 'Generador'),
		(4, 'Auto'),
		(4, 'Camioneta'),
		(3, 'Equipo de Fabricacion'),
		(3, 'Robot Industrial'),
		(1, 'Impresora'),
		(1, 'Monitor'),
		(1, 'Teclado');


INSERT INTO marcas(marca)
	VALUES
		('LG'),
		('HP'),
		('Nissan'),
		('Caterpillar'),
		('Einhell'),
		('Hyundai'),
		('FenWick'),
		('ABB');
        
INSERT INTO estados(tipo_estado, nom_estado)
	VALUES
		('activo', 'Activo'),
		('activo', 'En Mantenimiento'),
		('activo', 'Fuera de Servicio'),
		('activo', 'Baja'),
		('responsable', 'Asignado'),
		('responsable', 'No Asignado'),
		('orden', 'Abierta'),
		('orden', 'En Proceso'),
		('orden', 'Cerrada');

INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones, idestado)
	VALUES
	(2, 1, '14-EP', '123ABC', NOW(), 'Laptop 14-EP 16 RAM', '{"ram":"16GB", "disco":"solido"}',1),
	(10, 1, 'Monitor 4K', 'MON123', NOW(), 'Monitor LG de 27 pulgadas', '{"resolucion":"3840x2160"}', 5),
    (11, 2, 'Teclado Mecánico', 'TEC123', NOW(), 'Teclado mecánico HP', '{"tipo":"mecánico", "conectividad":"inalámbrico"}', 5),
    (7, 4, 'Compresor Industrial', 'COMP123', NOW(), 'Compresor Caterpillar de 10HP', '{"potencia":"10HP"}', 2),
    (6, 5, 'Camión de Carga Hyundai', 'CAM123', NOW(), 'Camión de carga pesada Hyundai', '{"capacidad":"10 toneladas"}', 2),
	(9, 2, 'L3110', 'IMP123', NOW(), 'Impresora HP L3110', '{"capacidad":"200 kilogramos"}', 5);    
-- select*from activos;
INSERT INTO ubicaciones(ubicacion) 
	VALUES
		('lugar 1'),
		('lugar 2'),
		('lugar 3'),
		('lugar 4'),
		('lugar 5');

INSERT INTO solicitudes_activos(idusuario, idactivo, fecha_solicitud, motivo_solicitud, idautorizador) 
	VALUES
		(2,1,NOW(), 'Para el proyecto X', 1);

INSERT INTO activos_responsables(idactivo, idusuario, fecha_designacion, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) 
	VALUES
		(1,2,null, 'En perfectas condiciones', '{"imagen1":"http://nose/que/poner"}', 'equipo de trabajo',1,1);


 -- SELECT*FROM activos_responsables;
INSERT INTO historial_activos (idactivo_resp,idubicacion)
	VALUES
		(1,1);
        

-- SELECT VERSION(); -- saber la version de mysql
-- *************************** INSERCIONES DE ROYER ********************************
-- 12/10/2024
INSERT INTO tipo_prioridades (tipo_prioridad) values ('baja'),('media'),('alta'),('urgente');

INSERT INTO tipo_diagnosticos (tipo_diagnostico) VALUES ('entrada'), ('salida');

select * from tipo_prioridades;

select * from estados;

select * from activos_vinculados_tarea;

INSERT INTO plandetareas (descripcion) values ('mantenimiento de impresora');

INSERT INTO tareas (idplantarea, idtipo_prioridad, descripcion, fecha_inicio, fecha_vencimiento, cant_intervalo, frecuencia, idestado) values (1, 3, 'llenado de tinta color rojo','11-10-2024','15-10-2024', 1, 'mensual', 1);

INSERT INTO activos_vinculados_tarea (idtarea, idactivo) values (1, 5);

select * from tareas;