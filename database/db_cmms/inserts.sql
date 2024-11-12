USE db_cmms;

-- ALTER TABLE usuarios AUTO_INCREMENT = 1;
INSERT INTO modulos (modulo) VALUES
	('usuarios'),
	('activos'),
	('asignaciones'),
	('bajas'),
    ('reportes'),
    ('configuracion'); -- ONLY ADMIN

INSERT INTO vistas(idmodulo, ruta, isVisible, texto, icono) VALUES
	(null, 'home',1,'Inicio',''),
    
    -- USUARIOS
	(1,'listar-usuario', '1', 'Usuario', ''),
    
    -- ACTIVOS
	(2, 'listar-activo', '1', 'Activo', ''),
    
    -- BAJAS
    (4, 'listar-activo-baja', '1', 'Baja', ''),
    
	-- REPORTES
    -- REPORTE - ACTIVOS
    (5, 'reporte', 1,'Reportes',''),
	(5, 'reporte-activo','0','reporte de Activos',''), -- FILTRADO POR ESTADO, FECHA REGISTRO, ETC.
	(5, 'reporte-mantenimiento',0,'Reporte de mantenimientos', ''),
    
	-- Configuracion (se registrara nuevas categorias, subcategorias, marcas, areas, etc.)
	(6,'gestion-data', '1', 'Gestion', '');


INSERT INTO perfiles (perfil, nombrecorto) VALUES
	('Administrador', 'ADM'),
	('Usuario', 'USR'),
	('Tecnico', 'TNC');
    
SELECT*FROM  vistas;
INSERT INTO permisos(idperfil, idvista) VALUES
-- ADMINISTRADOR
	(1,1),
	(1,2),
	(1,3),
	(1,4),
    (1,5),
    (1,6),
    (1,7),
    (1,8),
-- USUARIOS
	(2,1),
	(2,5),
	(2,6),
	(2,7);

INSERT INTO tipo_doc(tipodoc) VALUES
	('dni'),
    ('Carnet de extranjeria');
    
INSERT INTO areas (area) VALUES
('Lugar 1'),
('Lugar 2'),
('Lugar 3');

INSERT INTO tipo_estados(tipo_estado) VALUES
	('usuario'),
	('activo'),
    ('ubicacion');

INSERT INTO estados (idtipo_estado, nom_estado) VALUES
	(1,'activo'),
	(1,'inactivo'),
    (2, 'activo'),
    (2, 'Absoleto'),
    (3, 'ubicacion actual'),
    (3, 'cambio ubicacion');

-- Insertando en la tabla PERSONAS
INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono)VALUES 
(1, '1234567890', 'Gonzalez', 'Juan', 'M', '555-1234'),

(1, '2345678901', 'Martinez', 'Ana', 'F', '555-5678'),

(1, '3456789012', 'Ramirez', 'Luis', 'M', '555-8765');


-- Insertando en la tabla USUARIOS
-- ALTER TABLE usuarios AUTO_INCREMENT = 1;
INSERT INTO USUARIOS (idpersona, nom_usuario, claveacceso, perfil, idperfil, idarea, responsable_area)VALUES 
(1, 'juan.gonzalez','$2y$10$K2YSlVhUrKO/.AjyyETlde7ycbs2/ciOKfmYJKwQO1ryilpZTM4Li', 'ADM', 1, 1, 0),
(2, 'ana.martinez', '$2y$10$GbUWccarACj86SOfkx36G.AYH1/rnZQKqPXngR8nvU38Ny/nfyzmC' , 'USR', 2, 2, 1),
(3, 'luis.ramirez', '78910',  'TNC', 3, 3, 0);
 
INSERT INTO categorias (categoria) VALUES 
('Equipos de computo'),
('Vehículos');


INSERT INTO subcategorias (idcategoria, subcategoria) VALUES 
(1, 'Impresora'),
(1, 'Computadora'),
(1, 'Laptop'),
(2, 'Auto'),
(2, 'Montacargas');

INSERT INTO marcas (marca) VALUES 
('Caterpillar'),
('Volvo'),
('Nissan'),
('Lenovo'),
('HP');

INSERT INTO detalles_marca_subcategoria (idmarca, idsubcategoria) VALUES 
(1, 5),
(2, 4),
(3, 4),
(4, 2),
(4, 3),
(5, 1),
(5, 3);

INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones) VALUES
	(1, 5, 'FT 4F', 'D435K-FTY3-RR4S', NOW(), 'Impresora HP FT 4F', '{"conexion": "wifi"}');

INSERT INTO activos_asignados (idarea, idactivo, condicion_asig, imagenes, idestado) VALUES 
	(1,1, 'En buenas condiciones', '{"imagen1": "imagen_impresora.png"}',5);
	-- (2,1, 'Tienes daños menores, por favor usarlo con cuidado', '{"imagen1": "imagen_impresora_problemas.png"}',5);





