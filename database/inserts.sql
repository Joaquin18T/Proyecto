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
(2, '54321098', 'Hernández', 'Lucía', 'F', '555-1920'),
(1, '89239048', 'Valencia', 'Dilan', 'M', '934894556');

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
(15,2,'dilan35a', '$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO'),
(4, 2, 'r.avalos', '$2y$10$ctE3gtp7UwFaztXmJ3W/8e0sqgh3JrhjoZEcz8A7a9npOHij3sgZ.'),
(5, 1, 'p.avalos', '$2y$10$sWk/BPxsr.jss/3pJnF8HuE1KReQ6mldJm1nguSwDeR3if5jvO/ra'),
(6, 1, 'garcia.juan', 'contrasena1'),
(7, 2, 'perez.ana', 'contrasena2'),
(8, 1, 'lopez.carlos', 'contrasena3'),
(9, 2, 'martinez.laura', '$2y$10$GHYdqNqBJiv1Dh6WqNH5b.YFIU59bf5sdMGrAil9XiZVmPL36WqBC'),
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
	('Equipos de computo'),
    ('Vehiculos'),
    ('Inmobiliario de oficina'),
    ('Equipos de redes y conectividad');

INSERT INTO subcategorias(idcategoria, subcategoria)
	VALUES
		(1, 'Cpu'),
		(1, 'Laptops'),
        (1, 'Impresoras'),
        (1, 'Monitores'),
		(1, 'Teclados'),
		(2, 'Camiones'),
        (2, 'Camionetas'),
        (2,	'Motocicletas'),
        (3, 'Asientos ergonomicos'),
        (3, 'Mamparas'),
        (3, 'Muebles'),
        (4, 'Medidores de cableado'),
		(4, 'Routers'),
        (4, 'Switches');        


INSERT INTO marcas(marca)
VALUES
    ('Dell'),             -- Relacionado con laptops, monitores y estaciones de trabajo.
    ('HP'),               -- Relacionado con computadoras de escritorio, impresoras y estaciones de trabajo.
    ('Logitech'),         -- Relacionado con teclados y ratones.
    ('Lenovo'),           -- Relacionado con laptops y estaciones de trabajo.
    ('Samsung'),          -- Relacionado con monitores y pantallas.
    ('Canon'),            -- Relacionado con impresoras.
    ('Toyota'),           -- Relacionado con vehículos de transporte.
    ('Ford'),             -- Relacionado con camionetas y vehículos de transporte.
    ('Cisco'),            -- Relacionado con equipos de redes y conectividad.
    ('TP-Link'),          -- Relacionado con routers y switches.
    ('Herman Miller'),    -- Relacionado con mobiliario de oficina (sillas y escritorios).
    ('IKEA'),             -- Relacionado con mobiliario de oficina (escritorios, sillas, y estanterías).
    ('Steelcase')         -- Relacionado con mobiliario de oficina (escritorios y estaciones de trabajo).
;

select* from detalles_marca_subcategoria;
INSERT INTO detalles_marca_subcategoria (idsubcategoria, idmarca)
VALUES
    -- Equipos de Computo
    (1, 1),   -- Laptop - Dell
    (1, 2),   -- Laptop - HP
    (1, 4),   -- Laptop - Lenovo
    (2, 2),   -- Computadora de Escritorio - HP
    (2, 1),   -- Computadora de Escritorio - Dell
    (2, 4),   -- Computadora de Escritorio - Lenovo
    (3, 3),   -- Teclado - Logitech
    (3, 5),   -- Monitor - Samsung
    (4, 5),   -- Monitor - Samsung
    (4, 1),   -- Monitor - Dell
    (4, 4),   -- Monitor - Lenovo
    (5, 2),   -- Impresora - HP
    (5, 6),   -- Impresora - Canon

    -- Vehículos
    (6, 7),   -- Camión - Toyota
    (7, 8),   -- Camioneta - Ford
    (7, 7),   -- Camioneta - Toyota

    -- Equipos de Redes y Conectividad
    (8, 9),   -- Router - Cisco
    (8, 10),  -- Router - TP-Link
    (9, 9),   -- Switch - Cisco
    (9, 10),  -- Switch - TP-Link

    -- Mobiliario de Oficina
    (10, 11), -- Escritorio - Herman Miller
    (10, 12), -- Escritorio - IKEA
    (11, 11), -- Silla - Herman Miller
    (11, 13), -- Silla - Steelcase
    (12, 12), -- Estantería - IKEA
    (12, 13); -- Estantería - Steelcase


INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones, idestado)
VALUES
    (1, 1, 'Dell Optiplex 3020', 'EQ-001', '2022-01-15', 'CPU de oficina', '{"procesador":"Intel i5", "ram":"8GB", "disco":"256GB SSD"}', 1),
    (1, 2, 'HP ProDesk 400', 'EQ-002', '2023-05-22', 'CPU para uso administrativo', '{"procesador":"Intel i3", "ram":"4GB", "disco":"500GB HDD"}', 1),
    (2, 3, 'MacBook Air M1', 'EQ-003', '2023-02-10', 'Laptop para diseño', '{"procesador":"Apple M1", "ram":"8GB", "disco":"256GB SSD"}', 1),
    (2, 1, 'Dell Latitude 5510', 'EQ-004', '2022-12-01', 'Laptop para oficina', '{"procesador":"Intel i7", "ram":"16GB", "disco":"512GB SSD"}', 2),
    (3, 2, 'HP LaserJet Pro MFP M428', 'EQ-005', '2021-11-17', 'Impresora multifunción', '{"tipo":"Blanco y negro", "conectividad":"red, WiFi"}', 1),
    (4, 4, 'Samsung Odyssey G5', 'EQ-006', '2022-08-30', 'Monitor de alta resolución', '{"tamano":"32 pulgadas", "resolucion":"2560x1440", "frecuencia":"144Hz"}', 1),
    (5, 5, 'Logitech MK345', 'EQ-007', '2023-03-25', 'Teclado y mouse inalámbrico', '{"conectividad":"USB"}', 1),
    (6, 3, 'Ford F-150', 'VE-001', '2021-10-10', 'Camión para transporte de carga', '{"motor":"V6", "capacidad_asientos":"5"}', 1),
    (7, 2, 'Toyota Hilux', 'VE-002', '2020-07-15', 'Camioneta para trabajo pesado', '{"motor":"diésel 2.8L", "capacidad_asientos":"5"}', 2),
    (8, 1, 'Yamaha MT-07', 'VE-003', '2022-03-12', 'Motocicleta para patrullaje', '{"motor":"689cc", "transmision":"manual"}', 1),
    (9, 5, 'Silla Ergonomica A12', 'OF-001', '2023-06-18', 'Asiento ergonómico para oficina', '{"ajustes":"altura, respaldo lumbar"}', 1),
    (10, 4, 'Mampara Divisora 200', 'OF-002', '2022-09-05', 'Mampara para división de espacios', '{"material":"Aluminio y vidrio templado"}', 1),
    (11, 2, 'Mesa de Trabajo Madera', 'OF-003', '2023-04-01', 'Mueble de oficina', '{"dimensiones":"120x60 cm", "acabado":"madera"}', 2),
    (12, 6, 'Tester de Cableado', 'RD-001', '2021-01-10', 'Medidor de redes para cableado estructurado', '{"funcionalidad":"multifuncional", "pantalla":"LCD"}', 1),
    (13, 2, 'Cisco RV340', 'RD-002', '2022-02-22', 'Router empresarial', '{"puertos_wan":"2", "puertos_lan":"4"}', 1),
    (14, 3, 'Netgear GS308', 'RD-003', '2022-12-15', 'Switch de 8 puertos', '{"velocidad":"1Gbps"}', 1),
    (4, 1, 'LG UltraGear', 'EQ-008', '2021-06-21', 'Monitor de alta definición', '{"tamano":"27 pulgadas", "resolucion":"1920x1080", "frecuencia":"144Hz"}', 1),
    (5, 2, 'Razer BlackWidow', 'EQ-009', '2023-01-10', 'Teclado mecánico para oficina', '{"tipo":"mecánico", "iluminacion":"RGB"}', 1),
    (3, 4, 'Canon ImageClass MF264dw', 'EQ-010', '2023-02-28', 'Impresora multifunción', '{"tecnologia":"laser", "funciones":"escaneo, copia"}', 1),
    (6, 5, 'Mack Anthem', 'VE-004', '2022-05-19', 'Camión de carga pesada', '{"motor":"diesel", "cabina":"extendida"}', 1),
    (9, 1, 'Silla Executiva A3', 'OF-004', '2023-03-18', 'Silla ejecutiva de oficina', '{"ajuste":"lumbar", "material":"cuero sintético"}', 1),
    (10, 3, 'Panel Divisor', 'OF-005', '2023-05-20', 'Mampara para oficina', '{"color":"gris", "material":"madera y acero"}', 1),
    (11, 2, 'Escritorio Esquinero', 'OF-006', '2023-04-25', 'Mueble para oficina', '{"dimensiones":"150x150 cm", "acabado":"roble"}', 1),
    (8, 4, 'Ducati Monster 821', 'VE-005', '2022-02-10', 'Motocicleta para patrullaje', '{"motor":"821cc", "transmision":"manual"}', 2),
    (2, 3, 'HP Pavilion', 'EQ-011', '2023-06-15', 'Laptop para diseño', '{"procesador":"Intel i5", "ram":"16GB", "disco":"512GB SSD"}', 1),
    (1, 2, 'Lenovo ThinkCentre M710', 'EQ-012', '2022-07-10', 'CPU para uso administrativo', '{"procesador":"Intel i7", "ram":"8GB", "disco":"500GB HDD"}', 1),
    (13, 5, 'Huawei AR1220', 'RD-004', '2023-03-30', 'Router de oficina', '{"seguridad":"integrada", "puertos":"4"}', 1),
    (14, 4, 'D-Link DGS-1016D', 'RD-005', '2022-10-01', 'Switch de 16 puertos', '{"puertos":"16", "velocidad":"1Gbps"}', 1),
    (12, 3, 'Fluke DTX-1800', 'RD-006', '2023-01-10', 'Medidor de cableado para redes', '{"capacidad":"hasta Cat 6A"}', 1),
    (6, 4, 'Chevrolet Silverado', 'VE-006', '2021-12-11', 'Camioneta para trabajo', '{"motor":"V8", "capacidad_asientos":"6"}', 1);


-- select*from activos;
INSERT INTO ubicaciones (ubicacion) 
VALUES
    ('Oficina Administrativa'),
    ('Sala de Servidores'),
    ('Sala de Reuniones'),
    ('Almacén de Equipos'),
    ('Área de Soporte Técnico'),
    ('No definido');


INSERT INTO solicitudes_activos(idusuario, idactivo, fecha_solicitud, motivo_solicitud, idautorizador) 
	VALUES
		(2,1,NOW(), 'Para el proyecto X', 1);

INSERT INTO activos_responsables(idactivo, idusuario, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) 
VALUES
    (1, 2, 'Bueno', '{"imagen_1": "imagen1.jpg"}', 'Equipo asignado para trabajo de campo', 1, 1),
    (2, 3, 'Regular', '{"imagen_1": "imagen2.jpg"}', 'Laptop para uso en oficina', 3, 1),
    (3, 7, 'Bueno', '{"imagen_1": "imagen3.jpg"}', 'Impresora multifuncional en sala de impresiones', 5, 1),
    (4, 9, 'Excelente', '{"imagen_1": "imagen4.jpg"}', 'Monitor para diseño gráfico', 7, 1),
    (5, 11, 'Bueno', '{"imagen_1": "imagen5.jpg"}', 'Impresora para trabajos de oficina', 9, 1), -- modificado
    (6, 8, 'Bueno', '{"imagen_1": "imagen6.jpg"}', 'Camión para transporte de materiales', 11, 1),
    (7, 13, 'Regular', '{"imagen_1": "imagen7.jpg"}', 'Camioneta para supervisión de obras', 13, 1),
    (8, 3, 'Bueno', '{"imagen_1": "imagen8.jpg"}', 'Motocicleta para patrullaje', 2, 1),
    (9, 10, 'Excelente', '{"imagen_1": "imagen9.jpg"}', 'Silla ergonómica para oficina', 4, 1),
    (10, 2, 'Regular', '{"imagen_1": "imagen10.jpg"}', 'Mampara de oficina', 6, 1),
    (11, 12, 'Bueno', '{"imagen_1": "imagen11.jpg"}', 'Mueble de almacenamiento', 8, 1),
    (12, 4, 'Excelente', '{"imagen_1": "imagen12.jpg"}', 'Medidor de cableado para redes', 10, 1),
    (13, 5, 'Bueno', '{"imagen_1": "imagen13.jpg"}', 'Router para red de alta velocidad', 12, 1),
    (14, 6, 'Regular', '{"imagen_1": "imagen14.jpg"}', 'Switch para conexión en sala de servidores', 14, 1),
    (15, 13, 'Bueno', '{"imagen_1": "imagen15.jpg"}', 'Laptop para diseño y desarrollo', 2, 1),
    (16, 7, 'Excelente', '{"imagen_1": "imagen16.jpg"}', 'CPU de alto rendimiento para laboratorio', 4, 1),
    (17, 11, 'Bueno', '{"imagen_1": "imagen17.jpg"}', 'Monitor de 27 pulgadas para oficina', 6, 1),
    (18, 8, 'Regular', '{"imagen_1": "imagen18.jpg"}', 'Teclado inalámbrico para movilidad', 8, 1),
    (19, 2, 'Bueno', '{"imagen_1": "imagen19.jpg"}', 'Impresora en oficina de administración', 10, 1),
    (20, 12, 'Regular', '{"imagen_1": "imagen20.jpg"}', 'Escritorio ergonómico', 12, 1),
    (21, 10, 'Excelente', '{"imagen_1": "imagen21.jpg"}', 'Camión de carga pesada', 14, 1),
    (22, 9, 'Bueno', '{"imagen_1": "imagen22.jpg"}', 'Silla de oficina ajustable', 2, 1),
    (23, 8, 'Regular', '{"imagen_1": "imagen23.jpg"}', 'Mampara divisoria de espacio', 4, 1),
    (24, 3, 'Bueno', '{"imagen_1": "imagen24.jpg"}', 'Mesa de trabajo en sala de juntas', 6, 1),
    (25, 5, 'Regular', '{"imagen_1": "imagen25.jpg"}', 'Motocicleta para desplazamientos cortos', 8, 1),
    (26, 6, 'Bueno', '{"imagen_1": "imagen26.jpg"}', 'Router para red de oficina', 10, 1),
    (27, 13, 'Bueno', '{"imagen_1": "imagen27.jpg"}', 'Switch para conexión en redes locales', 12, 1),
    (28, 4, 'Excelente', '{"imagen_1": "imagen28.jpg"}', 'Medidor de cableado para mantenimiento', 14, 1),
    (29, 12, 'Bueno', '{"imagen_1": "imagen29.jpg"}', 'Camioneta de uso compartido en obras', 2, 1),
    (30, 9, 'Regular', '{"imagen_1": "imagen30.jpg"}', 'Impresora de gran formato', 4, 1);




 -- SELECT*FROM activos_responsables;
INSERT INTO historial_activos (idactivo_resp, idubicacion, accion, responsable_accion) 
VALUES
    (1, 1, 'Asignación de equipo', 1),  -- Asignación de equipo a Oficina Administrativa
    (2, 2, 'Mantenimiento preventivo', 2),  -- Mantenimiento de equipo en Sala de Servidores
    (3, 3, 'Reubicación de equipo', 3),  -- Reubicación de equipo en Sala de Reuniones
    (4, 4, 'Entrega de equipo', 4),  -- Entrega de equipo en Almacén de Equipos
    (5, 5, 'Inspección de equipo', 5);  -- Inspección de equipo en Área de Soporte Técnico

        
INSERT INTO notificaciones_activos(idactivo_resp, tipo, mensaje) VALUES
	(1,'Asignacion', 'Te han asignado un nuevo activo'),
	(2,'Asignacion', 'Te han asignado un nuevo activo'),
	(3,'Asignacion', 'Te han asignado un nuevo activo'),
	(4,'Asignacion', 'Te han asignado un nuevo activo'),
	(5,'Asignacion', 'Te han asignado un nuevo activo'),
	(6,'Asignacion', 'Te han asignado un nuevo activo'),
	(7,'Asignacion', 'Te han asignado un nuevo activo'),
	(8,'Asignacion', 'Te han asignado un nuevo activo'),
	(9,'Asignacion', 'Te han asignado un nuevo activo'),
	(10,'actualizar estado', 'Se ha actualizado el estado del activo');
        
INSERT INTO especificacionesDefecto(idsubcategoria, especificaciones) 
VALUES
    (1, '{"Procesador":"Intel i7", "RAM":"16GB", "Disco":"HDD"}'),  -- Subcategoría 1 (Computadoras)
    (2, '{"Pantalla":"13 pulgadas", "Duracion bateria":"8 horas", "Resolucion":"1366x768"}'),  -- Subcategoría 2 (Laptops)
    (3, '{"Capacidad":"5 T", "Consumo":"8 kW", "Tipo motor":"Electrico"}'),  -- Subcategoría 3 (Grúas)
    (4, '{"Combustible":"Diesel", "Potencia":"200 kW", "Duracion":"20 horas"}'),  -- Subcategoría 4 (Generadores)
    (5, '{"HP":"120", "Tipo Motor":"Hibrido", "Transmision":"Automatica"}'),  -- Subcategoría 5 (Vehículos)
    (6, '{"Combustible":"Eléctrico", "HP":"100", "A. fabricacion":"2021"}'),  -- Subcategoría 6 (Autos eléctricos)
    (7, '{"Material":"Acero", "Capacidad":"300 piezas por minuto", "Velocidad":"3 ciclos por minuto"}'),  -- Subcategoría 7 (Máquinas industriales)
    (8, '{"Articulaciones":"6", "Capacidad":"1000 kg", "Tipo":"Soldadora"}'),  -- Subcategoría 8 (Robots industriales)
    (9, '{"Resolucion":"1200x1200", "Velocidad":"60 ppm", "Conectividad":"Ethernet"}'),  -- Subcategoría 9 (Impresoras)
    (10, '{"Resolucion":"2560x1440", "Tamaño":"27\\"", "Frecuencia":"144 Hz"}'),  -- Subcategoría 10 (Monitores)
    (11, '{"Tipo":"Mecánico", "Conectividad":"Inalambrico", "Teclado numerico":"Sí"}');  -- Subcategoría 11 (Teclados)


-- SELECT VERSION(); -- saber la version de mysql
-- *************************** INSERCIONES DE ROYER ********************************
-- 12/10/2024
INSERT INTO frecuencias (frecuencia) VALUES ('diaria'),('semanal'),('mensual'),('anual');
INSERT INTO tipo_prioridades (tipo_prioridad) values ('baja'),('media'),('alta'),('urgente');

INSERT INTO tipo_diagnosticos (tipo_diagnostico) VALUES ('entrada'), ('salida');

select * from tipo_prioridades;

select * from estados;

select * from activos_vinculados_tarea;

-- INSERT INTO plandetareas (descripcion) values ('mantenimiento de impresora');

-- INSERT INTO tareas (idplantarea, idtipo_prioridad, descripcion, fecha_inicio, fecha_vencimiento, cant_intervalo, frecuencia, idestado) values (1, 3, 'llenado de tinta color rojo','11-10-2024','15-10-2024', 1, 'mensual', 1);

-- INSERT INTO activos_vinculados_tarea (idtarea, idactivo) values (1, 5);

select * from tareas;