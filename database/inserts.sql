USE gamp;

INSERT INTO TIPO_DOC (tipodoc) VALUES 
('DNI'),
('Carnet de Extranjería');

INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono) VALUES 
(1, '12345678', 'González', 'Juan', 'M', '987654321'),
(2, 'A1234567', 'Smith', 'Anna', 'F', '987654322'),
(2, 'EX123456', 'Martínez', 'Carlos', 'M', '987654323'),
(1, '35255456','Ortiz Huaman', 'Pablo', 'M', '928483244'),
(1, '72754752', 'Avalos Romero', 'Royer Alexis', 'M', '936439633'),
(1, '72754751', 'Avalos Romero', 'Pedro Aldair', 'M', '995213305'),
(1, '36436772', 'García', 'Juan', 'M', '555-1234'),
(2, '87654321', 'Pérez', 'Ana', 'F', '555-5678'),
(1, '23456789', 'López', 'Carlos', 'M', '555-9101'),
(2, '98765432', 'Martínez', 'Laura', 'F', '555-1122'),
(1, '34567890', 'Sánchez', 'Pedro', 'M', '555-1314'),
(2, '65432109', 'Ramírez', 'Marta', 'F', '555-1516'),
(1, '45678901', 'Torres', 'Jorge', 'M', '555-1718'),
(2, '54321098', 'Hernández', 'Lucía', 'F', '555-1920');

INSERT INTO ROLES (rol) VALUES 
('Administrador'),
('Usuario');

INSERT INTO estados(tipo_estado, nom_estado)
	VALUES
		('activo', 'Activo'),
		('activo', 'En Mantenimiento'),
		('activo', 'Fuera de Servicio'),
        ('activo', 'Absoleto'),
		('activo', 'Baja'),
		('responsable', 'Asignado'),
		('responsable', 'No Asignado'),
		('orden', 'pendiente'),
		('orden', 'proceso'),
		('orden', 'revision'),
        ('orden', 'finalizado');

INSERT INTO USUARIOS (idpersona, idrol, usuario, contrasena) VALUES 
(1, 1, 'j.gonzalez', '$2y$10$TpMmHZcum7YJqXOqTrsDy.WheLpUnU98OZjc4WqLgPke9HlX6ZaJS'),
(2, 2, 'a.smith', '$2y$10$HdD325QAWm7QpH7KXtRdROBKe39KwDQr6l4K83u2a0w5h/d6yNgau'),
(3, 2, 'c.martinez', '$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG'),
(4,2,'pablo35a', '$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO'),
(4, 2, 'r.avalos', '$2y$10$VrxeMCQteaNdX6LwxoZEYevp8BCwKTpIKTVebChbXcxnNX7BTIFaW'),
(5, 1, 'p.avalos', '$2y$10$j1KccY6Iex7h19WR0pfMpumhp.dsjJkBCcFUbtVwbPCHw7hECJNyW'),
(6, 1, 'garcia.juan', 'contrasena1'),
(7, 2, 'perez.ana', 'contrasena2'),
(8, 1, 'lopez.carlos', 'contrasena3'),
(9, 2, 'martinez.laura', 'contrasena4'),
(10, 1, 'sanchez.pedro', 'contrasena5'),
(11, 2, 'ramirez.marta', 'contrasena6'),
(12, 1, 'torres.jorge', 'contrasena7'),
(13, 2, 'hernandez.lucia', 'contrasena8');

select * from usuarios;

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
select* from detalles_marca_subcategoria;
INSERT INTO detalles_marca_subcategoria (idsubcategoria, idmarca) VALUES
	(1,1),
	(2,1),
	(2,2),
	(3,4),
	(3,7),
	(4,5),
	(5,6),
	(5,3),
	(6,6),
	(6,3),
	(7,4),
	(8,8),
	(9,2),
	(10,1),
	(11,1);

INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones)
	VALUES
	(2, 1, '14-EP', '123ABC', NOW(), 'Laptop 14-EP 16 RAM', '{"ram":"16GB", "disco":"solido"}'),
	(10, 1, 'Monitor 4K', 'MON123', NOW(), 'Monitor LG de 27 pulgadas', '{"resolucion":"3840x2160"}'),
    (11, 2, 'Teclado Mecánico', 'TEC123', NOW(), 'Teclado mecánico HP', '{"tipo":"mecánico", "conectividad":"inalámbrico"}'),
    (7, 4, 'Compresor Industrial', 'COMP123', NOW(), 'Compresor Caterpillar de 10HP', '{"potencia":"10HP"}'),
    (6, 5, 'Camión de Carga Hyundai', 'CAM123', NOW(), 'Camión de carga pesada Hyundai', '{"capacidad":"10 toneladas"}'),
	(9, 2, 'L3110', 'IMP123', NOW(), 'Impresora HP L3110', '{"capacidad":"200 kilogramos"}'),
    (1, 2, 'LG UltraGear', 'LG-001', '2023-01-15', 'Monitor para gaming', '{"resolucion": "2560x1440", "tasa_de_refresco": "144Hz"}'),
	(2, 2, 'HP Pavilion', 'HP-002', '2023-02-20', 'Laptop para uso diario', '{"procesador": "Intel i5", "ram": "8GB"}'),
	(3, 5, 'Caterpillar 320', 'CAT-003', '2023-03-10', 'Maquinaria pesada', '{"potencia": "150HP", "peso": "20ton"}'),
	(4, 3, 'Nissan Frontier', 'NIS-004', '2023-04-05', 'Camioneta pickup', '{"motor": "2.5L", "traccion": "4x4"}'),
	(5, 6, 'Hyundai Generator', 'HYD-005', '2023-05-12', 'Generador portátil', '{"potencia": "3000W", "tipo_combustible": "Gasolina"}'),
	(6, 1, 'HP LaserJet', 'HP-006', '2023-06-18', 'Impresora láser', '{"tipo": "monocromo", "velocidad": "30ppm"}'),
	(7, 1, 'LG Gram', 'LG-007', '2023-07-22', 'Laptop ultraligera', '{"peso": "999g", "pantalla": "14in"}'),
	(8, 4, 'ABB Robot IRB', 'ABB-008', '2023-08-15', 'Robot industrial', '{"carga_util": "10kg", "alcance": "1.5m"}'),
	(9, 7, 'FenWick Forklift', 'FW-009', '2023-09-10', 'Montacargas eléctrico', '{"capacidad_carga": "2000kg", "batería": "24V"}');
-- select*from activos;
INSERT INTO ubicaciones(ubicacion) 
	VALUES
		('lugar 1'),
		('lugar 2'),
		('lugar 3'),
		('lugar 4'),
		('lugar 5'),
        ('No Definida');

INSERT INTO solicitudes_activos(idusuario, idactivo, fecha_solicitud, motivo_solicitud, idautorizador) 
	VALUES
		(2,1,NOW(), 'Para el proyecto X', 1);

INSERT INTO activos_responsables(idactivo, idusuario, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) 
	VALUES
		(1,2,'En perfectas condiciones', '{"imagen1":"http://nose/que/poner"}', 'equipo de trabajo',1,1),
        (1, 3, 'Nuevo', '{"imagen1":"https://ejemplo.com/imagenes/lg_ultragear.jpg"}', 'Asignación a usuario', 6,1),
		(2, 4, 'Este activo esta sin problemas', '{"imagen1":"https://ejemplo.com/imagenes/hp_pavilion.jpg"}', 'Uso diario', 1,1),
		(3, 5, 'En buenas condiciones', '{"imagen1":"https://ejemplo.com/imagenes/caterpillar_320.jpg"}', 'Asignación a proyecto',8,1),
		(4, 6, 'Tienes fallos en el motor', '{"imagen1":"https://ejemplo.com/imagenes/nissan_frontier.jpg"}', 'Camioneta de trabajo', 14, 1),
		(5, 7, 'Nuevo', '{"imagen1":"https://ejemplo.com/imagenes/hyundai_generator.jpg"}', 'Generador de respaldo', 12, 1),
		(6, 8, 'Nuevo', '{"imagen1":"https://ejemplo.com/imagenes/hp_laserjet.jpg"}', 'Impresión de documentos', 8, 1),
		(7,9, 'Usado', '{"imagen1":"https://ejemplo.com/imagenes/lg_gram.jpg"}', 'Laptop para administración', 10, 1),
		(8, 10, 'Nuevo', '{"imagen1":"https://ejemplo.com/imagenes/abb_robot_irb.jpg"}', 'Robot para automatización', 14, 1),
		(9, 11, 'Usado', '{"imagen1":"https://ejemplo.com/imagenes/fenwick_forklift.jpg"}', 'Montacargas para logística',14,1);


 -- SELECT*FROM activos_responsables;
INSERT INTO historial_activos (idactivo_resp,idubicacion)
	VALUES
		-- (1,1),
		(2,3),
		(3,2),
		(4,1),
		(5,4),
		(6,2),
		(7,3),
		(8,4),
		(9,5),
		(10,2);
        

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