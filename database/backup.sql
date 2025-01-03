/*
SQLyog Professional v12.5.1 (64 bit)
MySQL - 10.4.32-MariaDB : Database - gamp
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`gamp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `gamp`;

/*Table structure for table `activos` */

DROP TABLE IF EXISTS `activos`;

CREATE TABLE `activos` (
  `idactivo` int(11) NOT NULL AUTO_INCREMENT,
  `idsubcategoria` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idestado` int(11) NOT NULL DEFAULT 1,
  `modelo` varchar(60) DEFAULT NULL,
  `cod_identificacion` char(40) NOT NULL,
  `fecha_adquisicion` date NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`especificaciones`)),
  PRIMARY KEY (`idactivo`),
  UNIQUE KEY `uk_cod_identificacion` (`cod_identificacion`),
  KEY `fkidmarca` (`idmarca`),
  KEY `fk_actsubcategoria` (`idsubcategoria`),
  KEY `fk_idestado` (`idestado`),
  CONSTRAINT `fk_actsubcategoria` FOREIGN KEY (`idsubcategoria`) REFERENCES `subcategorias` (`idsubcategoria`),
  CONSTRAINT `fk_idestado` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fkidmarca` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos` */

insert  into `activos`(`idactivo`,`idsubcategoria`,`idmarca`,`idestado`,`modelo`,`cod_identificacion`,`fecha_adquisicion`,`descripcion`,`especificaciones`) values 
(1,1,1,1,'Dell Optiplex 3020','EQ-001','2022-01-15','CPU de oficina','{\"procesador\":\"Intel i5\", \"ram\":\"8GB\", \"disco\":\"256GB SSD\"}'),
(2,1,2,1,'HP ProDesk 400','EQ-002','2023-05-22','CPU para uso administrativo','{\"procesador\":\"Intel i3\", \"ram\":\"4GB\", \"disco\":\"500GB HDD\"}'),
(3,2,3,1,'MacBook Air M1','EQ-003','2023-02-10','Laptop para diseño','{\"procesador\":\"Apple M1\", \"ram\":\"8GB\", \"disco\":\"256GB SSD\"}'),
(4,2,1,2,'Dell Latitude 5510','EQ-004','2022-12-01','Laptop para oficina','{\"procesador\":\"Intel i7\", \"ram\":\"16GB\", \"disco\":\"512GB SSD\"}'),
(5,3,2,1,'HP LaserJet Pro MFP M428','EQ-005','2021-11-17','Impresora multifunción','{\"tipo\":\"Blanco y negro\", \"conectividad\":\"red, WiFi\"}'),
(6,4,4,1,'Samsung Odyssey G5','EQ-006','2022-08-30','Monitor de alta resolución','{\"tamano\":\"32 pulgadas\", \"resolucion\":\"2560x1440\", \"frecuencia\":\"144Hz\"}'),
(7,5,5,1,'Logitech MK345','EQ-007','2023-03-25','Teclado y mouse inalámbrico','{\"conectividad\":\"USB\"}'),
(8,6,3,1,'Ford F-150','VE-001','2021-10-10','Camión para transporte de carga','{\"motor\":\"V6\", \"capacidad_asientos\":\"5\"}'),
(9,7,2,2,'Toyota Hilux','VE-002','2020-07-15','Camioneta para trabajo pesado','{\"motor\":\"diésel 2.8L\", \"capacidad_asientos\":\"5\"}'),
(10,8,1,1,'Yamaha MT-07','VE-003','2022-03-12','Motocicleta para patrullaje','{\"motor\":\"689cc\", \"transmision\":\"manual\"}'),
(11,9,5,1,'Silla Ergonomica A12','OF-001','2023-06-18','Asiento ergonómico para oficina','{\"ajustes\":\"altura, respaldo lumbar\"}'),
(12,10,4,1,'Mampara Divisora 200','OF-002','2022-09-05','Mampara para división de espacios','{\"material\":\"Aluminio y vidrio templado\"}'),
(13,11,2,2,'Mesa de Trabajo Madera','OF-003','2023-04-01','Mueble de oficina','{\"dimensiones\":\"120x60 cm\", \"acabado\":\"madera\"}'),
(14,12,6,1,'Tester de Cableado','RD-001','2021-01-10','Medidor de redes para cableado estructurado','{\"funcionalidad\":\"multifuncional\", \"pantalla\":\"LCD\"}'),
(15,13,2,1,'Cisco RV340','RD-002','2022-02-22','Router empresarial','{\"puertos_wan\":\"2\", \"puertos_lan\":\"4\"}'),
(16,14,3,1,'Netgear GS308','RD-003','2022-12-15','Switch de 8 puertos','{\"velocidad\":\"1Gbps\"}'),
(17,4,1,1,'LG UltraGear','EQ-008','2021-06-21','Monitor de alta definición','{\"tamano\":\"27 pulgadas\", \"resolucion\":\"1920x1080\", \"frecuencia\":\"144Hz\"}'),
(18,5,2,1,'Razer BlackWidow','EQ-009','2023-01-10','Teclado mecánico para oficina','{\"tipo\":\"mecánico\", \"iluminacion\":\"RGB\"}'),
(19,3,4,1,'Canon ImageClass MF264dw','EQ-010','2023-02-28','Impresora multifunción','{\"tecnologia\":\"laser\", \"funciones\":\"escaneo, copia\"}'),
(20,6,5,1,'Mack Anthem','VE-004','2022-05-19','Camión de carga pesada','{\"motor\":\"diesel\", \"cabina\":\"extendida\"}'),
(21,9,1,1,'Silla Executiva A3','OF-004','2023-03-18','Silla ejecutiva de oficina','{\"ajuste\":\"lumbar\", \"material\":\"cuero sintético\"}'),
(22,10,3,1,'Panel Divisor','OF-005','2023-05-20','Mampara para oficina','{\"color\":\"gris\", \"material\":\"madera y acero\"}'),
(23,11,2,1,'Escritorio Esquinero','OF-006','2023-04-25','Mueble para oficina','{\"dimensiones\":\"150x150 cm\", \"acabado\":\"roble\"}'),
(24,8,4,2,'Ducati Monster 821','VE-005','2022-02-10','Motocicleta para patrullaje','{\"motor\":\"821cc\", \"transmision\":\"manual\"}'),
(25,2,3,1,'HP Pavilion','EQ-011','2023-06-15','Laptop para diseño','{\"procesador\":\"Intel i5\", \"ram\":\"16GB\", \"disco\":\"512GB SSD\"}'),
(26,1,2,1,'Lenovo ThinkCentre M710','EQ-012','2022-07-10','CPU para uso administrativo','{\"procesador\":\"Intel i7\", \"ram\":\"8GB\", \"disco\":\"500GB HDD\"}'),
(27,13,5,1,'Huawei AR1220','RD-004','2023-03-30','Router de oficina','{\"seguridad\":\"integrada\", \"puertos\":\"4\"}'),
(28,14,4,1,'D-Link DGS-1016D','RD-005','2022-10-01','Switch de 16 puertos','{\"puertos\":\"16\", \"velocidad\":\"1Gbps\"}'),
(29,12,3,1,'Fluke DTX-1800','RD-006','2023-01-10','Medidor de cableado para redes','{\"capacidad\":\"hasta Cat 6A\"}'),
(30,6,4,1,'Chevrolet Silverado','VE-006','2021-12-11','Camioneta para trabajo','{\"motor\":\"V8\", \"capacidad_asientos\":\"6\"}'),
(31,3,3,4,'Teclado Logitech D4','FR5-345K','2023-08-10','Teclado para empleados','{\"tipo\":\"mecanico\"}');

/*Table structure for table `activos_responsables` */

DROP TABLE IF EXISTS `activos_responsables`;

CREATE TABLE `activos_responsables` (
  `idactivo_resp` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `es_responsable` char(1) NOT NULL DEFAULT '0',
  `fecha_asignacion` date NOT NULL DEFAULT current_timestamp(),
  `fecha_designacion` date DEFAULT NULL,
  `condicion_equipo` varchar(500) DEFAULT NULL,
  `imagenes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`imagenes`)),
  `descripcion` varchar(500) NOT NULL,
  `autorizacion` int(11) NOT NULL,
  `solicitud` int(11) NOT NULL,
  PRIMARY KEY (`idactivo_resp`),
  KEY `fk_activo_resp` (`idactivo`),
  KEY `fk_user_resp` (`idusuario`),
  KEY `fk_autorizacion` (`autorizacion`),
  KEY `fk_solicitud` (`solicitud`),
  CONSTRAINT `fk_activo_resp` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_autorizacion` FOREIGN KEY (`autorizacion`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_solicitud` FOREIGN KEY (`solicitud`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_user_resp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `chk_es_responsable` CHECK (`es_responsable` in ('1','0'))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos_responsables` */

insert  into `activos_responsables`(`idactivo_resp`,`idactivo`,`idusuario`,`es_responsable`,`fecha_asignacion`,`fecha_designacion`,`condicion_equipo`,`imagenes`,`descripcion`,`autorizacion`,`solicitud`) values 
(1,1,2,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen1.jpg\"}','Equipo asignado para trabajo de campo',1,1),
(2,2,3,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen2.jpg\"}','Laptop para uso en oficina',3,1),
(3,3,7,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen3.jpg\"}','Impresora multifuncional en sala de impresiones',5,1),
(4,4,9,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen4.jpg\"}','Monitor para diseño gráfico',7,1),
(5,5,11,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen5.jpg\"}','Impresora para trabajos de oficina',9,1),
(6,6,8,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen6.jpg\"}','Camión para transporte de materiales',11,1),
(7,7,13,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen7.jpg\"}','Camioneta para supervisión de obras',13,1),
(8,8,3,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen8.jpg\"}','Motocicleta para patrullaje',2,1),
(9,9,10,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen9.jpg\"}','Silla ergonómica para oficina',4,1),
(10,10,2,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen10.jpg\"}','Mampara de oficina',6,1),
(11,11,12,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen11.jpg\"}','Mueble de almacenamiento',8,1),
(12,12,4,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen12.jpg\"}','Medidor de cableado para redes',10,1),
(13,13,5,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen13.jpg\"}','Router para red de alta velocidad',12,1),
(14,14,6,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen14.jpg\"}','Switch para conexión en sala de servidores',14,1),
(15,15,13,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen15.jpg\"}','Laptop para diseño y desarrollo',2,1),
(16,16,7,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen16.jpg\"}','CPU de alto rendimiento para laboratorio',4,1),
(17,17,11,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen17.jpg\"}','Monitor de 27 pulgadas para oficina',6,1),
(18,18,8,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen18.jpg\"}','Teclado inalámbrico para movilidad',8,1),
(19,19,2,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen19.jpg\"}','Impresora en oficina de administración',10,1),
(20,20,12,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen20.jpg\"}','Escritorio ergonómico',12,1),
(21,21,10,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen21.jpg\"}','Camión de carga pesada',14,1),
(22,22,9,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen22.jpg\"}','Silla de oficina ajustable',2,1),
(23,23,8,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen23.jpg\"}','Mampara divisoria de espacio',4,1),
(24,24,3,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen24.jpg\"}','Mesa de trabajo en sala de juntas',6,1),
(25,25,5,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen25.jpg\"}','Motocicleta para desplazamientos cortos',8,1),
(26,26,6,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen26.jpg\"}','Router para red de oficina',10,1),
(27,27,13,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen27.jpg\"}','Switch para conexión en redes locales',12,1),
(28,28,4,'0','2024-11-09',NULL,'Excelente','{\"imagen_1\": \"imagen28.jpg\"}','Medidor de cableado para mantenimiento',14,1),
(29,29,12,'0','2024-11-09',NULL,'Bueno','{\"imagen_1\": \"imagen29.jpg\"}','Camioneta de uso compartido en obras',2,1),
(30,30,9,'0','2024-11-09',NULL,'Regular','{\"imagen_1\": \"imagen30.jpg\"}','Impresora de gran formato',4,1);

/*Table structure for table `activos_vinculados_tarea` */

DROP TABLE IF EXISTS `activos_vinculados_tarea`;

CREATE TABLE `activos_vinculados_tarea` (
  `idactivo_vinculado` int(11) NOT NULL AUTO_INCREMENT,
  `idtarea` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idactivo_vinculado`),
  KEY `fk_idtarea5` (`idtarea`),
  KEY `fk_idactivo3` (`idactivo`),
  CONSTRAINT `fk_idactivo3` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_idtarea5` FOREIGN KEY (`idtarea`) REFERENCES `tareas` (`idtarea`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos_vinculados_tarea` */

/*Table structure for table `bajas_activo` */

DROP TABLE IF EXISTS `bajas_activo`;

CREATE TABLE `bajas_activo` (
  `idbaja_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo` int(11) NOT NULL,
  `fecha_baja` datetime NOT NULL DEFAULT current_timestamp(),
  `motivo` varchar(250) NOT NULL,
  `coment_adicionales` varchar(250) DEFAULT NULL,
  `ruta_doc` varchar(250) NOT NULL,
  `aprobacion` int(11) NOT NULL,
  PRIMARY KEY (`idbaja_activo`),
  UNIQUE KEY `uk_ruta_doc` (`ruta_doc`),
  KEY `fk_activo_baja_activo` (`idactivo`),
  KEY `fk_usuario_baja_activo` (`aprobacion`),
  CONSTRAINT `fk_activo_baja_activo` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_usuario_baja_activo` FOREIGN KEY (`aprobacion`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `bajas_activo` */

/*Table structure for table `categorias` */

DROP TABLE IF EXISTS `categorias`;

CREATE TABLE `categorias` (
  `idcategoria` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` varchar(60) NOT NULL,
  PRIMARY KEY (`idcategoria`),
  UNIQUE KEY `uk_categoria` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `categorias` */

insert  into `categorias`(`idcategoria`,`categoria`) values 
(1,'Equipos de computo'),
(4,'Equipos de redes y conectividad'),
(3,'Inmobiliario de oficina'),
(2,'Vehiculos');

/*Table structure for table `comentarios_odt` */

DROP TABLE IF EXISTS `comentarios_odt`;

CREATE TABLE `comentarios_odt` (
  `idcomentario` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `comentario` varchar(300) DEFAULT NULL,
  `revisadoPor` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idcomentario`),
  KEY `fk_idorden_trabajo` (`idorden_trabajo`),
  KEY `fk_revisadoPor` (`revisadoPor`),
  CONSTRAINT `fk_idorden_trabajo` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  CONSTRAINT `fk_revisadoPor` FOREIGN KEY (`revisadoPor`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `comentarios_odt` */

/*Table structure for table `detalle_odt` */

DROP TABLE IF EXISTS `detalle_odt`;

CREATE TABLE `detalle_odt` (
  `iddetalleodt` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `fecha_inicial` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_final` datetime DEFAULT NULL,
  `tiempo_ejecucion` time DEFAULT NULL,
  `intervalos_ejecutados` int(11) NOT NULL,
  `clasificacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`iddetalleodt`),
  KEY `fk_orden_trabajo2` (`idorden_trabajo`),
  KEY `fk_clasificacion` (`clasificacion`),
  CONSTRAINT `fk_clasificacion` FOREIGN KEY (`clasificacion`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_orden_trabajo2` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detalle_odt` */

/*Table structure for table `detalles_marca_subcategoria` */

DROP TABLE IF EXISTS `detalles_marca_subcategoria`;

CREATE TABLE `detalles_marca_subcategoria` (
  `iddetalle_marca_sub` int(11) NOT NULL AUTO_INCREMENT,
  `idmarca` int(11) NOT NULL,
  `idsubcategoria` int(11) NOT NULL,
  PRIMARY KEY (`iddetalle_marca_sub`),
  KEY `fk_idmarca_detalle` (`idmarca`),
  KEY `fk_idsubcategoria` (`idsubcategoria`),
  CONSTRAINT `fk_idmarca_detalle` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`),
  CONSTRAINT `fk_idsubcategoria` FOREIGN KEY (`idsubcategoria`) REFERENCES `subcategorias` (`idsubcategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detalles_marca_subcategoria` */

insert  into `detalles_marca_subcategoria`(`iddetalle_marca_sub`,`idmarca`,`idsubcategoria`) values 
(1,1,1),
(2,2,1),
(3,4,1),
(4,2,2),
(5,1,2),
(6,4,2),
(7,3,3),
(8,5,3),
(9,5,4),
(10,1,4),
(11,4,4),
(12,2,5),
(13,6,5),
(14,7,6),
(15,8,7),
(16,7,7),
(17,9,8),
(18,10,8),
(19,9,9),
(20,10,9),
(21,11,10),
(22,12,10),
(23,11,11),
(24,13,11),
(25,12,12),
(26,13,12);

/*Table structure for table `diagnosticos` */

DROP TABLE IF EXISTS `diagnosticos`;

CREATE TABLE `diagnosticos` (
  `iddiagnostico` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `idtipo_diagnostico` int(11) NOT NULL,
  `diagnostico` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`iddiagnostico`),
  KEY `fk_idorden_trabajo3` (`idorden_trabajo`),
  KEY `fk_idtipo_diagnostico` (`idtipo_diagnostico`),
  CONSTRAINT `fk_idorden_trabajo3` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  CONSTRAINT `fk_idtipo_diagnostico` FOREIGN KEY (`idtipo_diagnostico`) REFERENCES `tipo_diagnosticos` (`idtipo_diagnostico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `diagnosticos` */

/*Table structure for table `especificacionesdefecto` */

DROP TABLE IF EXISTS `especificacionesdefecto`;

CREATE TABLE `especificacionesdefecto` (
  `idespecificacionD` int(11) NOT NULL AUTO_INCREMENT,
  `idsubcategoria` int(11) NOT NULL,
  `especificaciones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`especificaciones`)),
  PRIMARY KEY (`idespecificacionD`),
  UNIQUE KEY `uk_subcategoria_especificacion` (`idsubcategoria`,`especificaciones`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `especificacionesdefecto` */

insert  into `especificacionesdefecto`(`idespecificacionD`,`idsubcategoria`,`especificaciones`) values 
(1,1,'{\"Procesador\":\"Intel i7\", \"RAM\":\"16GB\", \"Disco\":\"HDD\"}'),
(2,2,'{\"Pantalla\":\"13 pulgadas\", \"Duracion bateria\":\"8 horas\", \"Resolucion\":\"1366x768\"}'),
(3,3,'{\"Capacidad\":\"5 T\", \"Consumo\":\"8 kW\", \"Tipo motor\":\"Electrico\"}'),
(4,4,'{\"Combustible\":\"Diesel\", \"Potencia\":\"200 kW\", \"Duracion\":\"20 horas\"}'),
(5,5,'{\"HP\":\"120\", \"Tipo Motor\":\"Hibrido\", \"Transmision\":\"Automatica\"}'),
(6,6,'{\"Combustible\":\"Eléctrico\", \"HP\":\"100\", \"A. fabricacion\":\"2021\"}'),
(7,7,'{\"Material\":\"Acero\", \"Capacidad\":\"300 piezas por minuto\", \"Velocidad\":\"3 ciclos por minuto\"}'),
(8,8,'{\"Articulaciones\":\"6\", \"Capacidad\":\"1000 kg\", \"Tipo\":\"Soldadora\"}'),
(9,9,'{\"Resolucion\":\"1200x1200\", \"Velocidad\":\"60 ppm\", \"Conectividad\":\"Ethernet\"}'),
(10,10,'{\"Resolucion\":\"2560x1440\", \"Tamaño\":\"27\\\"\", \"Frecuencia\":\"144 Hz\"}'),
(11,11,'{\"Tipo\":\"Mecánico\", \"Conectividad\":\"Inalambrico\", \"Teclado numerico\":\"Sí\"}');

/*Table structure for table `estados` */

DROP TABLE IF EXISTS `estados`;

CREATE TABLE `estados` (
  `idestado` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_estado` varchar(50) NOT NULL,
  `nom_estado` varchar(50) NOT NULL,
  PRIMARY KEY (`idestado`),
  UNIQUE KEY `uk_nom_estado` (`nom_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `estados` */

insert  into `estados`(`idestado`,`tipo_estado`,`nom_estado`) values 
(1,'activo','Activo'),
(2,'activo','En Mantenimiento'),
(3,'activo','Fuera de Servicio'),
(4,'activo','Absoleto'),
(5,'activo','Baja'),
(6,'responsable','Asignado'),
(7,'responsable','No Asignado'),
(8,'orden','pendiente'),
(9,'orden','proceso'),
(10,'orden','revision'),
(11,'orden','finalizado');

/*Table structure for table `evidencias_diagnostico` */

DROP TABLE IF EXISTS `evidencias_diagnostico`;

CREATE TABLE `evidencias_diagnostico` (
  `idevidencias_diagnostico` int(11) NOT NULL AUTO_INCREMENT,
  `iddiagnostico` int(11) NOT NULL,
  `evidencia` varchar(80) NOT NULL,
  PRIMARY KEY (`idevidencias_diagnostico`),
  KEY `fk_iddiagnostico` (`iddiagnostico`),
  CONSTRAINT `fk_iddiagnostico` FOREIGN KEY (`iddiagnostico`) REFERENCES `diagnosticos` (`iddiagnostico`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `evidencias_diagnostico` */

/*Table structure for table `frecuencias` */

DROP TABLE IF EXISTS `frecuencias`;

CREATE TABLE `frecuencias` (
  `idfrecuencia` int(11) NOT NULL AUTO_INCREMENT,
  `frecuencia` varchar(20) NOT NULL,
  PRIMARY KEY (`idfrecuencia`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `frecuencias` */

insert  into `frecuencias`(`idfrecuencia`,`frecuencia`) values 
(1,'diaria'),
(2,'semanal'),
(3,'mensual'),
(4,'anual');

/*Table structure for table `historial_activos` */

DROP TABLE IF EXISTS `historial_activos`;

CREATE TABLE `historial_activos` (
  `idhistorial_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo_resp` int(11) DEFAULT NULL,
  `idubicacion` int(11) NOT NULL,
  `accion` varchar(70) DEFAULT NULL,
  `responsable_accion` int(11) DEFAULT NULL,
  `idactivo` int(11) DEFAULT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idhistorial_activo`),
  KEY `fk_idactivo_resp` (`idactivo_resp`),
  KEY `fk_idubicacion` (`idubicacion`),
  KEY `fk_usuario_his` (`responsable_accion`),
  KEY `fk_idactivo_his_act` (`idactivo`),
  CONSTRAINT `fk_idactivo_his_act` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_idactivo_resp` FOREIGN KEY (`idactivo_resp`) REFERENCES `activos_responsables` (`idactivo_resp`),
  CONSTRAINT `fk_idubicacion` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`),
  CONSTRAINT `fk_usuario_his` FOREIGN KEY (`responsable_accion`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_activos` */

insert  into `historial_activos`(`idhistorial_activo`,`idactivo_resp`,`idubicacion`,`accion`,`responsable_accion`,`idactivo`,`fecha_movimiento`) values 
(1,1,1,'Asignación de equipo',1,NULL,'2024-11-09 09:47:57'),
(2,2,2,'Mantenimiento preventivo',2,NULL,'2024-11-09 09:47:57'),
(3,3,3,'Reubicación de equipo',3,NULL,'2024-11-09 09:47:57'),
(4,4,4,'Entrega de equipo',4,NULL,'2024-11-09 09:47:57'),
(5,5,5,'Inspección de equipo',5,NULL,'2024-11-09 09:47:57');

/*Table structure for table `historial_odt` */

DROP TABLE IF EXISTS `historial_odt`;

CREATE TABLE `historial_odt` (
  `idhistorial` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  PRIMARY KEY (`idhistorial`),
  KEY `fk_idordentrabajo3` (`idorden_trabajo`),
  CONSTRAINT `fk_idordentrabajo3` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_odt` */

/*Table structure for table `marcas` */

DROP TABLE IF EXISTS `marcas`;

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL AUTO_INCREMENT,
  `marca` varchar(80) NOT NULL,
  PRIMARY KEY (`idmarca`),
  UNIQUE KEY `uk_marca` (`marca`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `marcas` */

insert  into `marcas`(`idmarca`,`marca`) values 
(6,'Canon'),
(9,'Cisco'),
(1,'Dell'),
(8,'Ford'),
(11,'Herman Miller'),
(2,'HP'),
(12,'IKEA'),
(4,'Lenovo'),
(3,'Logitech'),
(5,'Samsung'),
(13,'Steelcase'),
(7,'Toyota'),
(10,'TP-Link');

/*Table structure for table `notificaciones_activos` */

DROP TABLE IF EXISTS `notificaciones_activos`;

CREATE TABLE `notificaciones_activos` (
  `idnotificacion_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo_resp` int(11) DEFAULT NULL,
  `tipo` varchar(90) NOT NULL,
  `mensaje` varchar(250) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `visto` char(1) NOT NULL DEFAULT '0',
  `idactivo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idnotificacion_activo`),
  KEY `fk_idactivo_resp_nof` (`idactivo_resp`),
  KEY `fk_idactivo_noti_activo` (`idactivo`),
  CONSTRAINT `fk_idactivo_noti_activo` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_idactivo_resp_nof` FOREIGN KEY (`idactivo_resp`) REFERENCES `activos_responsables` (`idactivo_resp`),
  CONSTRAINT `chk_visto` CHECK (`visto` in ('1','0'))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `notificaciones_activos` */

insert  into `notificaciones_activos`(`idnotificacion_activo`,`idactivo_resp`,`tipo`,`mensaje`,`fecha_creacion`,`visto`,`idactivo`) values 
(1,1,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(2,2,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(3,3,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(4,4,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(5,5,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(6,6,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(7,7,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(8,8,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(9,9,'Asignacion','Te han asignado un nuevo activo','2024-11-09 09:47:57','0',NULL),
(10,10,'actualizar estado','Se ha actualizado el estado del activo','2024-11-09 09:47:57','0',NULL);

/*Table structure for table `notificaciones_mantenimiento` */

DROP TABLE IF EXISTS `notificaciones_mantenimiento`;

CREATE TABLE `notificaciones_mantenimiento` (
  `idnotificacion_mantenimiento` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `tarea` varchar(100) DEFAULT NULL,
  `activos` text DEFAULT NULL,
  `idresp` int(11) NOT NULL,
  `mensaje` varchar(250) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `visto` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idnotificacion_mantenimiento`),
  KEY `fk_idorden_trabajoNM` (`idorden_trabajo`),
  KEY `fk_idresp` (`idresp`),
  CONSTRAINT `fk_idorden_trabajoNM` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`),
  CONSTRAINT `fk_idresp` FOREIGN KEY (`idresp`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `notificaciones_mantenimiento` */

/*Table structure for table `odt` */

DROP TABLE IF EXISTS `odt`;

CREATE TABLE `odt` (
  `idorden_trabajo` int(11) NOT NULL AUTO_INCREMENT,
  `idtarea` int(11) NOT NULL,
  `creado_por` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `fecha_final` date DEFAULT NULL,
  `hora_final` time DEFAULT NULL,
  `idestado` int(11) DEFAULT 9,
  `incompleto` tinyint(1) DEFAULT 0,
  `eliminado` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`idorden_trabajo`),
  KEY `fk_idtarea4` (`idtarea`),
  KEY `fk_creado_por` (`creado_por`),
  KEY `fk_idestado4` (`idestado`),
  CONSTRAINT `fk_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_idestado4` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_idtarea4` FOREIGN KEY (`idtarea`) REFERENCES `tareas` (`idtarea`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `odt` */

/*Table structure for table `permisos` */

DROP TABLE IF EXISTS `permisos`;

CREATE TABLE `permisos` (
  `idpermiso` int(11) NOT NULL AUTO_INCREMENT,
  `idrol` int(11) NOT NULL,
  `permiso` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`permiso`)),
  PRIMARY KEY (`idpermiso`),
  KEY `fk_idrol` (`idrol`),
  CONSTRAINT `fk_idrol` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `permisos` */

insert  into `permisos`(`idpermiso`,`idrol`,`permiso`) values 
(1,2,'{\"activos\":{\"registerActivo\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false}, \"Responsables\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"Activos\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false}},\"ODT\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"planTarea\":{\"read\":true,\"create\":false,\"update\":false,\"delete\":false},\"bajaActivo\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"usuarios\":{\"ListaUsuario\":{\"read\":false,\"create\":false,\"update\":false,\"delete\":false},\"PermisoRol\":{\"read\":false,\"create\":false,\"update\":false,\"delete\":false}}}'),
(2,1,'{\"activos\":{\"registerActivo\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":true}},\"ODT\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":false},\"PlanTarea\":{\"read\":true,\"create\":true,\"update\":false,\"delete\":false},\"BajaActivo\":{\"read\":true,\"create\":true,\"update\":true,\"delete\":false},\"usuarios\":{\"ListaUsuario\":{\"read\":true,\"create\": true,\"update\":true,\"delete\":true},\"PermisoRol\":{ \"read\":true,\"create\": true, \"update\":true, \"delete\":true}}}');

/*Table structure for table `personas` */

DROP TABLE IF EXISTS `personas`;

CREATE TABLE `personas` (
  `id_persona` int(11) NOT NULL AUTO_INCREMENT,
  `idtipodoc` int(11) NOT NULL,
  `num_doc` varchar(50) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `genero` char(1) NOT NULL,
  `telefono` char(9) DEFAULT NULL,
  PRIMARY KEY (`id_persona`),
  UNIQUE KEY `uk_num_doc` (`num_doc`),
  UNIQUE KEY `uk_telefono` (`telefono`),
  KEY `fk_idtipodoc` (`idtipodoc`),
  CONSTRAINT `fk_idtipodoc` FOREIGN KEY (`idtipodoc`) REFERENCES `tipo_doc` (`idtipodoc`),
  CONSTRAINT `chk_genero` CHECK (`genero` in ('M','F'))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `personas` */

insert  into `personas`(`id_persona`,`idtipodoc`,`num_doc`,`apellidos`,`nombres`,`genero`,`telefono`) values 
(1,1,'12345678','González','Juan','M','987654321'),
(2,2,'A1234567','Smith','Anna','F','987654322'),
(3,2,'EX123456','Martínez','Carlos','M','987654323'),
(4,1,'35255456','Ortiz Huaman','Pablo','M','928483244'),
(5,1,'72754752','Avalos Romero','Royer Alexis','M','936439633'),
(6,1,'72754751','Avalos Romero','Pedro Aldair','M','995213305'),
(7,1,'36436772','García','Juan','M','555-1234'),
(8,2,'87654321','Pérez','Ana','F','555-5678'),
(9,1,'23456789','López','Carlos','M','555-9101'),
(10,2,'98765432','Martínez','Laura','F','555-1122'),
(11,1,'34567890','Sánchez','Pedro','M','555-1314'),
(12,2,'65432109','Ramírez','Marta','F','555-1516'),
(13,1,'45678901','Torres','Jorge','M','555-1718'),
(14,2,'54321098','Hernández','Lucía','F','555-1920'),
(15,1,'89239048','Valencia','Dilan','M','934894556');

/*Table structure for table `plandetareas` */

DROP TABLE IF EXISTS `plandetareas`;

CREATE TABLE `plandetareas` (
  `idplantarea` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(80) NOT NULL,
  `idcategoria` int(11) NOT NULL,
  `incompleto` tinyint(1) DEFAULT 1,
  `eliminado` tinyint(1) DEFAULT 0,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idplantarea`),
  UNIQUE KEY `uk_descripcion_plan` (`descripcion`),
  KEY `fk_idcategoria_plan` (`idcategoria`),
  CONSTRAINT `fk_idcategoria_plan` FOREIGN KEY (`idcategoria`) REFERENCES `categorias` (`idcategoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `plandetareas` */

/*Table structure for table `responsables_asignados_odt` */

DROP TABLE IF EXISTS `responsables_asignados_odt`;

CREATE TABLE `responsables_asignados_odt` (
  `idresponsable_asignado` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `idresponsable` int(11) NOT NULL,
  PRIMARY KEY (`idresponsable_asignado`),
  KEY `fk_idodt` (`idorden_trabajo`),
  KEY `fk_idresponsable` (`idresponsable`),
  CONSTRAINT `fk_idodt` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  CONSTRAINT `fk_idresponsable` FOREIGN KEY (`idresponsable`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `responsables_asignados_odt` */

/*Table structure for table `roles` */

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL AUTO_INCREMENT,
  `rol` varchar(20) NOT NULL,
  PRIMARY KEY (`idrol`),
  UNIQUE KEY `uk_rol` (`rol`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `roles` */

insert  into `roles`(`idrol`,`rol`) values 
(1,'Administrador'),
(2,'Usuario');

/*Table structure for table `solicitudes_activos` */

DROP TABLE IF EXISTS `solicitudes_activos`;

CREATE TABLE `solicitudes_activos` (
  `idsolicitud` int(11) NOT NULL AUTO_INCREMENT,
  `idusuario` int(11) NOT NULL,
  `idactivo` int(11) NOT NULL,
  `fecha_solicitud` date NOT NULL DEFAULT current_timestamp(),
  `estado_solicitud` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `motivo_solicitud` varchar(500) DEFAULT NULL,
  `idautorizador` int(11) NOT NULL,
  `fecha_respuesta` date DEFAULT NULL,
  `coment_autorizador` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idsolicitud`),
  KEY `fk_usuario_sol` (`idusuario`),
  KEY `fk_activo_sol` (`idactivo`),
  CONSTRAINT `fk_activo_sol` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`),
  CONSTRAINT `fk_usuario_sol` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `chk_resp_sol` CHECK (`fecha_respuesta` >= `fecha_solicitud`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `solicitudes_activos` */

insert  into `solicitudes_activos`(`idsolicitud`,`idusuario`,`idactivo`,`fecha_solicitud`,`estado_solicitud`,`motivo_solicitud`,`idautorizador`,`fecha_respuesta`,`coment_autorizador`) values 
(1,2,1,'2024-11-09','pendiente','Para el proyecto X',1,NULL,NULL);

/*Table structure for table `subcategorias` */

DROP TABLE IF EXISTS `subcategorias`;

CREATE TABLE `subcategorias` (
  `idsubcategoria` int(11) NOT NULL AUTO_INCREMENT,
  `idcategoria` int(11) NOT NULL,
  `subcategoria` varchar(60) NOT NULL,
  PRIMARY KEY (`idsubcategoria`),
  UNIQUE KEY `uk_subcategoria` (`subcategoria`),
  KEY `fk_categoria` (`idcategoria`),
  CONSTRAINT `fk_categoria` FOREIGN KEY (`idcategoria`) REFERENCES `categorias` (`idcategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `subcategorias` */

insert  into `subcategorias`(`idsubcategoria`,`idcategoria`,`subcategoria`) values 
(1,1,'Cpu'),
(2,1,'Laptops'),
(3,1,'Impresoras'),
(4,1,'Monitores'),
(5,1,'Teclados'),
(6,2,'Camiones'),
(7,2,'Camionetas'),
(8,2,'Motocicletas'),
(9,3,'Asientos ergonomicos'),
(10,3,'Mamparas'),
(11,3,'Muebles'),
(12,4,'Medidores de cableado'),
(13,4,'Routers'),
(14,4,'Switches');

/*Table structure for table `tareas` */

DROP TABLE IF EXISTS `tareas`;

CREATE TABLE `tareas` (
  `idtarea` int(11) NOT NULL AUTO_INCREMENT,
  `idplantarea` int(11) NOT NULL,
  `idtipo_prioridad` int(11) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `idsubcategoria` int(11) NOT NULL,
  `intervalo` int(11) NOT NULL,
  `idfrecuencia` int(11) NOT NULL,
  `idestado` int(11) NOT NULL,
  `trabajado` tinyint(1) NOT NULL DEFAULT 0,
  `pausado` tinyint(1) NOT NULL DEFAULT 0,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idtarea`),
  UNIQUE KEY `fk_descripcion_tarea` (`descripcion`),
  KEY `fk_idplantarea` (`idplantarea`),
  KEY `fk_idtipo_prioridad` (`idtipo_prioridad`),
  KEY `fk_idestado2` (`idestado`),
  KEY `fk_idsubcategoria_plan` (`idsubcategoria`),
  KEY `fk_idfrecuencia` (`idfrecuencia`),
  CONSTRAINT `fk_idestado2` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_idfrecuencia` FOREIGN KEY (`idfrecuencia`) REFERENCES `frecuencias` (`idfrecuencia`),
  CONSTRAINT `fk_idplantarea` FOREIGN KEY (`idplantarea`) REFERENCES `plandetareas` (`idplantarea`) ON DELETE CASCADE,
  CONSTRAINT `fk_idsubcategoria_plan` FOREIGN KEY (`idsubcategoria`) REFERENCES `subcategorias` (`idsubcategoria`),
  CONSTRAINT `fk_idtipo_prioridad` FOREIGN KEY (`idtipo_prioridad`) REFERENCES `tipo_prioridades` (`idtipo_prioridad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tareas` */

/*Table structure for table `tipo_diagnosticos` */

DROP TABLE IF EXISTS `tipo_diagnosticos`;

CREATE TABLE `tipo_diagnosticos` (
  `idtipo_diagnostico` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_diagnostico` varchar(30) NOT NULL,
  PRIMARY KEY (`idtipo_diagnostico`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tipo_diagnosticos` */

insert  into `tipo_diagnosticos`(`idtipo_diagnostico`,`tipo_diagnostico`) values 
(1,'entrada'),
(2,'salida');

/*Table structure for table `tipo_doc` */

DROP TABLE IF EXISTS `tipo_doc`;

CREATE TABLE `tipo_doc` (
  `idtipodoc` int(11) NOT NULL AUTO_INCREMENT,
  `tipodoc` varchar(50) NOT NULL,
  PRIMARY KEY (`idtipodoc`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tipo_doc` */

insert  into `tipo_doc`(`idtipodoc`,`tipodoc`) values 
(1,'DNI'),
(2,'Carnet de Extranjería');

/*Table structure for table `tipo_prioridades` */

DROP TABLE IF EXISTS `tipo_prioridades`;

CREATE TABLE `tipo_prioridades` (
  `idtipo_prioridad` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_prioridad` varchar(10) NOT NULL,
  PRIMARY KEY (`idtipo_prioridad`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tipo_prioridades` */

insert  into `tipo_prioridades`(`idtipo_prioridad`,`tipo_prioridad`) values 
(1,'baja'),
(2,'media'),
(3,'alta'),
(4,'urgente');

/*Table structure for table `ubicaciones` */

DROP TABLE IF EXISTS `ubicaciones`;

CREATE TABLE `ubicaciones` (
  `idubicacion` int(11) NOT NULL AUTO_INCREMENT,
  `ubicacion` varchar(60) NOT NULL,
  PRIMARY KEY (`idubicacion`),
  UNIQUE KEY `uk_ubicacion` (`ubicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `ubicaciones` */

insert  into `ubicaciones`(`idubicacion`,`ubicacion`) values 
(4,'Almacén de Equipos'),
(5,'Área de Soporte Técnico'),
(6,'No definido'),
(1,'Oficina Administrativa'),
(3,'Sala de Reuniones'),
(2,'Sala de Servidores');

/*Table structure for table `usuarios` */

DROP TABLE IF EXISTS `usuarios`;

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `idpersona` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `usuario` varchar(120) NOT NULL,
  `contrasena` varchar(120) NOT NULL,
  `estado` char(1) DEFAULT '1',
  `asignacion` int(11) DEFAULT 7,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_idpersonaUser1` (`idpersona`,`usuario`),
  KEY `fk_rol1` (`idrol`),
  KEY `fk_asignacion1` (`asignacion`),
  CONSTRAINT `fk_asignacion1` FOREIGN KEY (`asignacion`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_persona1` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`id_persona`),
  CONSTRAINT `fk_rol1` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `usuarios` */

insert  into `usuarios`(`id_usuario`,`idpersona`,`idrol`,`usuario`,`contrasena`,`estado`,`asignacion`) values 
(1,1,1,'j.gonzalez','$2y$10$TpMmHZcum7YJqXOqTrsDy.WheLpUnU98OZjc4WqLgPke9HlX6ZaJS','1',7),
(2,2,2,'a.smith','$2y$10$HdD325QAWm7QpH7KXtRdROBKe39KwDQr6l4K83u2a0w5h/d6yNgau','1',7),
(3,3,2,'c.martinez','$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG','1',7),
(4,15,2,'dilan35a','$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO','1',7),
(5,4,2,'r.avalos','$2y$10$ctE3gtp7UwFaztXmJ3W/8e0sqgh3JrhjoZEcz8A7a9npOHij3sgZ.','1',7),
(6,5,1,'p.avalos','$2y$10$sWk/BPxsr.jss/3pJnF8HuE1KReQ6mldJm1nguSwDeR3if5jvO/ra','1',7),
(7,6,1,'garcia.juan','contrasena1','1',7),
(8,7,2,'perez.ana','contrasena2','1',7),
(9,8,1,'lopez.carlos','contrasena3','1',7),
(10,9,2,'martinez.laura','$2y$10$GHYdqNqBJiv1Dh6WqNH5b.YFIU59bf5sdMGrAil9XiZVmPL36WqBC','1',7),
(11,10,1,'sanchez.pedro','contrasena5','1',7),
(12,11,2,'ramirez.marta','contrasena6','1',7),
(13,12,1,'torres.jorge','contrasena7','1',7),
(14,13,2,'hernandez.lucia','contrasena8','1',7);

/* Procedure structure for procedure `actualizarActivoPorTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarActivoPorTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarActivoPorTarea`(
    IN _idactivo_vinculado INT, 
    IN _idactivo INT, 
    IN _idtarea INT)
BEGIN
    UPDATE activos_vinculados_tarea 
    SET idactivo = _idactivo, 
        idtarea = _idtarea, 
        update_at = NOW()
    WHERE idactivo_vinculado = _idactivo_vinculado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarBorradorOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarBorradorOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarBorradorOdt`(
	IN _idorden_trabajo INT,
	IN _borrador INT
)
BEGIN
	UPDATE odt SET
    incompleto = _borrador
    WHERE idorden_trabajo = _idorden_trabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarDetalleOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarDetalleOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarDetalleOdt`(
	IN _iddetalleodt INT,
    IN _fechafinal DATETIME,
    IN _tiempoejecucion TIME,
    IN _intervalos_ejecutados INT,
    IN _clasificacion INT
)
BEGIN
	UPDATE detalle_odt SET
    fecha_final = _fechafinal,
    tiempo_ejecucion = _tiempoejecucion,
    intervalos_ejecutados = _intervalos_ejecutados,
    clasificacion = _clasificacion
    WHERE iddetalleodt = _iddetalleodt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarDiagnosticoOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarDiagnosticoOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarDiagnosticoOdt`(
	IN _iddiagnostico INT,
    IN _diagnostico VARCHAR(300)
)
BEGIN
	UPDATE diagnosticos SET
    diagnostico = _diagnostico
    WHERE iddiagnostico = _iddiagnostico;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarEstadoOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarEstadoOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarEstadoOdt`(
	IN _idorden_trabajo INT,
	IN _idestado INT
)
BEGIN
	UPDATE odt SET
    idestado = _idestado
    WHERE idorden_trabajo = _idorden_trabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarFechaFinalOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarFechaFinalOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarFechaFinalOdt`(
	IN _idorden_trabajo INT,
    IN _fecha_final DATE,
    IN _hora_final TIME
)
BEGIN
	UPDATE odt SET
    fecha_final = _fecha_final,
    hora_final = _hora_final    
    WHERE idorden_trabajo = _idorden_trabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarPlanDeTareas` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarPlanDeTareas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarPlanDeTareas`(
    IN _idplantarea INT, 
    IN _descripcion VARCHAR(80),
    IN _incompleto BOOLEAN)
BEGIN
    UPDATE plandetareas 
    SET descripcion = _descripcion,
		incompleto = _incompleto, 
        update_at = NOW()
    WHERE idplantarea = _idplantarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarTarea`(
    IN _idtarea INT,
    IN _idtipo_prioridad INT,
    IN _descripcion VARCHAR(200),     
    IN _intervalo		INT,
    IN _idfrecuencia		INT,
    IN _idestado INT)
BEGIN
    UPDATE tareas 
    SET 
		idtipo_prioridad = _idtipo_prioridad,
		descripcion = _descripcion,
        intervalo	= _intervalo,
        idfrecuencia	= _idfrecuencia,
        idestado = _idestado, 
        update_at = NOW()
    WHERE idtarea = _idtarea;
    
    SELECT MAX(idtarea) as idactualizado FROM tareas;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarTareaEstado` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarTareaEstado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarTareaEstado`(
	IN _idtarea INT,
    IN _idestado INT,
    IN _trabajado BOOLEAN
)
BEGIN
	UPDATE tareas 
    SET idestado = _idestado,
		trabajado = _trabajado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `actualizarTareaEstadoPausado` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarTareaEstadoPausado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarTareaEstadoPausado`(
	IN _idtarea INT,
    IN _pausado INT
)
BEGIN
	UPDATE tareas 
    SET pausado = _pausado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `agregarNotificacionOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `agregarNotificacionOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `agregarNotificacionOdt`(
	OUT _idnotificacion_mantenimiento INT,
    IN _idorden_trabajo INT,
    IN _tarea			VARCHAR(100),
    IN _activos			TEXT,
    IN _idresp			INT,
    IN _mensaje			VARCHAR(250)
)
BEGIN
	-- Declaración de variable de control de error
	DECLARE existe_error INT DEFAULT 0;

	-- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET existe_error = 1;
		END;
        
	INSERT INTO notificaciones_mantenimiento (idorden_trabajo, tarea, activos,idresp, mensaje) values
	(_idorden_trabajo, _tarea, _activos, _idresp , _mensaje);
    
    IF existe_error = 1 THEN
		SET _idnotificacion_mantenimiento = -1;
	ELSE
		SET _idnotificacion_mantenimiento = LAST_INSERT_ID();
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `asignarResponsables` */

/*!50003 DROP PROCEDURE IF EXISTS  `asignarResponsables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarResponsables`(
	OUT _idresponsable_asignado INT,
	IN _idorden_trabajo INT,
    IN _idresponsable INT
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
	INSERT INTO responsables_asignados_odt (idorden_trabajo, idresponsable) values
		(_idorden_trabajo, _idresponsable);
        
	IF existe_error = 1 THEN
		SET _idresponsable_asignado = -1;
	ELSE
        SET _idresponsable_asignado = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `asignarResponsablesODT` */

/*!50003 DROP PROCEDURE IF EXISTS  `asignarResponsablesODT` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `asignarResponsablesODT`(
	IN _idorden_trabajo INT,
    IN _idresponsable	INT
)
BEGIN
	INSERT INTO responsables_asignados_odt (idorden_trabajo, idresponsable)
		VALUES (_idorden_trabajo, _idresponsable);
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarActivosVinculadosTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarActivosVinculadosTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarActivosVinculadosTarea`(IN _idactivovinculado INT)
BEGIN
	DELETE FROM activos_vinculados_tarea WHERE idactivo_vinculado = _idactivovinculado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarEvidenciaOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarEvidenciaOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarEvidenciaOdt`(IN _idevidencias_diagnostico INT)
BEGIN
	DELETE FROM evidencias_diagnostico WHERE idevidencias_diagnostico = _idevidencias_diagnostico;
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarOdt`(IN _idorden_trabajo INT)
BEGIN
	DELETE FROM odt WHERE idorden_trabajo = _idorden_trabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarPlanDeTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarPlanDeTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarPlanDeTarea`(
	IN _idplantarea INT,
    IN _eliminado BOOLEAN
)
BEGIN
	-- DELETE FROM plandetareas WHERE idplantarea = _idplantarea;
    UPDATE plandetareas 
    SET 
		eliminado = _eliminado,
        update_at = NOW()
    WHERE idplantarea = _idplantarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarResponsableOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarResponsableOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarResponsableOdt`(
	IN _idresponsable_asignado INT
)
BEGIN
	DELETE FROM responsables_asignados_odt WHERE idresponsable_asignado = _idresponsable_asignado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `eliminarTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarTarea`(IN _idtarea INT)
BEGIN
	DELETE FROM tareas WHERE idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `get_idresp_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `get_idresp_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `get_idresp_activo`(
	IN _idactivo INT,
    IN _idusuario INT
)
BEGIN
	SELECT
		idactivo_resp
        FROM activos_responsables 
		WHERE idactivo = _idactivo AND idusuario = _idusuario
        AND fecha_designacion IS NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `insertarActivoPorTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `insertarActivoPorTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarActivoPorTarea`(
	OUT _idactivo_vinculado INT,
    IN _idactivo INT,
    IN _idtarea INT
)
BEGIN
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO activos_vinculados_tarea (idactivo, idtarea)
    VALUES (_idactivo, _idtarea);
    
    IF existe_error = 1 THEN
		SET _idactivo_vinculado = -1;
	ELSE
        SET _idactivo_vinculado = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `insertarPlanDeTareas` */

/*!50003 DROP PROCEDURE IF EXISTS  `insertarPlanDeTareas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarPlanDeTareas`(
	OUT _idplantarea INT,
	IN _descripcion VARCHAR(30),
    IN _idcategoria	INT
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO plandetareas (descripcion, idcategoria)
    VALUES (_descripcion, _idcategoria);
    
    IF existe_error = 1 THEN
		SET _idplantarea = -1;
	ELSE
        SET _idplantarea = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `insertarTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `insertarTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `insertarTarea`(
	OUT _idtarea INT,
    IN _idplantarea INT,
    IN _idtipo_prioridad INT,
    IN _descripcion VARCHAR(200),
	IN _idsubcategoria	INT,
    IN _intervalo		INT,
    IN _idfrecuencia		VARCHAR(30),
    IN _idestado INT
)
BEGIN
-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
        
    INSERT INTO tareas (
        idplantarea, idtipo_prioridad, descripcion, idsubcategoria, intervalo, idfrecuencia, idestado
    )
    VALUES (
        _idplantarea, _idtipo_prioridad, _descripcion, _idsubcategoria, _intervalo, _idfrecuencia ,_idestado
    );
    
    IF existe_error = 1 THEN
		SET _idtarea = -1;
	ELSE
        SET _idtarea = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `listarActivosPorTareaYPlan` */

/*!50003 DROP PROCEDURE IF EXISTS  `listarActivosPorTareaYPlan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `listarActivosPorTareaYPlan`(IN p_idplantarea INT)
BEGIN
  -- Listar todos los activos vinculados a cada tarea del plan de tareas
  SELECT 
	avt.idactivo_vinculado,
    pt.descripcion AS descripcion_plan,
    t.idtarea,
    t.descripcion AS descripcion_tarea,
    a.idactivo,
    a.descripcion,
    t.idestado
  FROM
    plandetareas pt
    INNER JOIN tareas t ON pt.idplantarea = t.idplantarea
    INNER JOIN activos_vinculados_tarea avt ON t.idtarea = avt.idtarea
    INNER JOIN activos a ON avt.idactivo = a.idactivo
  WHERE
    pt.idplantarea = p_idplantarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `listarActivosResponsables` */

/*!50003 DROP PROCEDURE IF EXISTS  `listarActivosResponsables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `listarActivosResponsables`(
    IN _idsubcategoria INT, 
    IN _idubicacion INT
)
BEGIN
    SELECT DISTINCT
        AR.idactivo_resp,
        AR.idactivo,
        ACT.descripcion,
        ACT.modelo,
        MAR.marca,
        EST.nom_estado,
        HA.idubicacion,
        AR.es_responsable
    FROM activos_responsables AR
    INNER JOIN activos ACT ON AR.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN usuarios USU ON AR.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    INNER JOIN (
        SELECT idactivo_resp, idubicacion
        FROM historial_activos
        WHERE (idactivo_resp, fecha_movimiento) IN (
            SELECT idactivo_resp, MAX(fecha_movimiento)
            FROM historial_activos
            GROUP BY idactivo_resp
        )
    ) HA ON HA.idactivo_resp = AR.idactivo_resp
    LEFT JOIN ubicaciones UBI ON UBI.idubicacion = HA.idubicacion
    WHERE AR.es_responsable = 1
        AND (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL)
        AND (UBI.idubicacion = _idubicacion OR _idubicacion IS NULL);
END */$$
DELIMITER ;

/* Procedure structure for procedure `mostrarTareasEnTablaPorIdTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `mostrarTareasEnTablaPorIdTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `mostrarTareasEnTablaPorIdTarea`(IN _idtarea INT)
BEGIN 
    SELECT 
        TAR.idtarea,
        PT.descripcion AS plantarea,
        TAR.descripcion,
        TAR.pausado,
        ACT.idactivo AS id_activo,
        ACT.descripcion AS activo,
        AR.idusuario,
        PER.nombres,
        PER.apellidos,
        AR.es_responsable,
        TP.tipo_prioridad AS prioridad,
        TAR.intervalo,
        FRE.frecuencia,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
    FROM tareas TAR
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN activos_responsables AR ON AR.idactivo = ACT.idactivo AND AR.es_responsable = 1
    INNER JOIN usuarios USU ON USU.id_usuario = AR.idusuario
    INNER JOIN personas PER ON PER.id_persona = USU.idpersona
    INNER JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    INNER JOIN estados EST ON EST.idestado = TAR.idestado
    INNER JOIN frecuencias FRE ON FRE.idfrecuencia = TAR.idfrecuencia
    WHERE PT.eliminado = 0 AND PT.incompleto = 0 AND TAR.idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerActivos` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerActivos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerActivos`(
	IN _idcategoria	INT
)
BEGIN
	SELECT ACT.idactivo, ACT.descripcion as activo, ACT.cod_identificacion ,CAT.categoria, SUB.subcategoria, MAR.marca, ACT.modelo FROM activos ACT 
    INNER JOIN subcategorias SUB ON SUB.idsubcategoria = ACT.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE CAT.idcategoria = _idcategoria
    ORDER BY ACT.idactivo DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerActivosPorTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerActivosPorTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerActivosPorTarea`(IN _idtarea INT)
BEGIN
	SELECT ACTV.idactivo_vinculado, ACT.idestado, ACTV.idtarea ,ACT.cod_identificacion,ACT.descripcion,ACT.idactivo,SCAT.subcategoria, MAR.marca, ACT.modelo FROM activos_vinculados_tarea ACTV
    INNER JOIN activos ACT ON ACTV.idactivo = ACT.idactivo
    INNER JOIN subcategorias SCAT ON ACT.idsubcategoria = SCAT.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE ACTV.idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerDetalleOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerDetalleOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerDetalleOdt`( 
    IN _idordentrabajo INT
)
BEGIN
	SELECT * FROM detalle_odt
    WHERE idorden_trabajo = _idordentrabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerDiagnostico` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerDiagnostico` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerDiagnostico`( 
    IN _idordentrabajo INT,
    IN _idtipodiagnostico INT
)
BEGIN
	SELECT * FROM diagnosticos
    WHERE idorden_trabajo = _idordentrabajo AND idtipo_diagnostico = _idtipodiagnostico;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerEstadoActivoEnOtrasTareas` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerEstadoActivoEnOtrasTareas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerEstadoActivoEnOtrasTareas`(IN _idactivo INT, IN _idtarea INT)
BEGIN
    SELECT *
    FROM activos_vinculados_tarea ACTV
    INNER JOIN activos ACT ON ACTV.idactivo = ACT.idactivo
    WHERE ACT.idactivo = 1 
      AND ACTV.idtarea <> 1  -- Omitir la tarea actual
      AND ACT.idestado = 2         -- Buscar solo activos en mantenimiento
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerEvidenciasDiagnostico` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerEvidenciasDiagnostico` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerEvidenciasDiagnostico`( 
	IN _iddiagnostico INT
)
BEGIN
	SELECT 
		ED.idevidencias_diagnostico,
        ED.iddiagnostico,
        ED.evidencia,
        DIA.idtipo_diagnostico
    FROM evidencias_diagnostico ED
    INNER JOIN diagnosticos DIA ON DIA.iddiagnostico = ED.iddiagnostico
    WHERE ED.iddiagnostico = _iddiagnostico;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerFrecuencias` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerFrecuencias` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerFrecuencias`()
BEGIN
	SELECT 
	*
    FROM frecuencias;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerHistorialOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerHistorialOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerHistorialOdt`()
BEGIN
	SELECT 
    
		HO.idhistorial,
		ODT.idorden_trabajo,
        DODT.clasificacion,
		CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
		GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,        
        DODT.tiempo_ejecucion,
        DIA.diagnostico,
        
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        
        TAR.descripcion AS tarea,				
        
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) as revisado_por,
        TAR.idtarea AS idtarea,
        TP.tipo_prioridad,
        ODT.fecha_inicio,
        ODT.hora_inicio,
        
        EST.nom_estado,
        ODT.incompleto,
		ODT.fecha_final,
        ODT.hora_final
            FROM historial_odt HO
    LEFT JOIN odt ODT ON ODT.idorden_trabajo = HO.idorden_trabajo
    LEFT JOIN diagnosticos DIA ON DIA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
    LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerIdsUsuariosOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerIdsUsuariosOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerIdsUsuariosOdt`()
BEGIN
	select 
    ODT.idorden_trabajo,
    AVT.idtarea,
	AR.idusuario
	 from odt ODT
	INNER JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
	inner join activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
	inner join activos_responsables AR ON AR.idactivo = AVT.idactivo AND AR.es_responsable = 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerOdtporId` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerOdtporId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerOdtporId`( 
    IN _idodt INT
)
BEGIN
	SELECT 
        ODT.idorden_trabajo,
        GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,
        TAR.descripcion AS tarea,
        ODT.fecha_inicio,
        CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) AS revisado_por,
        TAR.idtarea AS idtarea,
        TP.tipo_prioridad,
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        ODT.idestado,
        EST.nom_estado,
        ODT.incompleto,
        /* Subconsulta para obtener la última clasificación */
        (SELECT DODT.clasificacion 
         FROM detalle_odt DODT 
         WHERE DODT.idorden_trabajo = _idodt
         ORDER BY DODT.fecha_final DESC, DODT.iddetalleodt DESC 
         LIMIT 1) AS clasificacion,
        /* Subconsulta para obtener el último tiempo de ejecución */
        (SELECT DODT.tiempo_ejecucion 
         FROM detalle_odt DODT 
         WHERE DODT.idorden_trabajo = _idodt 
         ORDER BY DODT.fecha_final DESC, DODT.iddetalleodt DESC 
         LIMIT 1) AS tiempo_ejecucion,
        ODT.hora_inicio,
        ODT.fecha_final,
        ODT.hora_final
    FROM odt ODT
    LEFT JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
	LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    WHERE ODT.idorden_trabajo = _idodt
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerPlanTareaPorId` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerPlanTareaPorId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerPlanTareaPorId`(IN _idplantarea INT)
BEGIN 
	SELECT 
        idplantarea, 
        descripcion,
        incompleto,
        idcategoria
    FROM plandetareas
    WHERE idplantarea = _idplantarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerPlantareasDetalles` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerPlantareasDetalles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerPlantareasDetalles`(IN _eliminado INT)
BEGIN 
SELECT PT.idplantarea, 
       PT.descripcion, 
       COUNT(DISTINCT TAR.idtarea) AS tareas_totales, 
       COUNT(DISTINCT AV.idactivo_vinculado) AS activos_vinculados,
       PT.incompleto
       FROM plandetareas PT
LEFT JOIN tareas TAR ON TAR.idplantarea = PT.idplantarea
LEFT JOIN activos_vinculados_tarea AV ON AV.idtarea = TAR.idtarea
WHERE PT.eliminado = _eliminado
GROUP BY PT.idplantarea, PT.descripcion
ORDER BY PT.idplantarea DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerResponsables` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerResponsables` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerResponsables`(
	IN _idodt INT
)
BEGIN
	SELECT 
		RODT.idorden_trabajo,
		RODT.idresponsable,
        RODT.idresponsable_asignado,
        CONCAT(PER.apellidos,' ',PER.nombres) as nombres
    FROM responsables_asignados_odt RODT 
	INNER JOIN usuarios USU ON USU.id_usuario = RODT.idresponsable
    INNER JOIN personas PER ON PER.id_persona = USU.idpersona
	WHERE idorden_trabajo = _idodt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerResponsablesPorOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerResponsablesPorOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerResponsablesPorOdt`(
	IN _idorden_trabajo INT
)
BEGIN
	SELECT 
		RA.idresponsable_asignado, RA.idorden_trabajo, RA.idresponsable,
        USU.usuario
		FROM responsables_asignados_odt RA
	INNER JOIN usuarios USU ON USU.idusuario = RA.idresponsable
    WHERE idorden_trabajo = _idorden_trabajo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareaDeOdtGenerada` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareaDeOdtGenerada` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareaDeOdtGenerada`(
	IN _idodt INT
)
BEGIN 
	SELECT 
		ODT.idorden_trabajo,
        PT.descripcion as plantarea,
		TAR.descripcion as tarea,
        TAR.idtarea as idtarea,
        ACT.descripcion as activo,
        ODT.fecha_inicio,
        ODT.hora_inicio
		from odt ODT
        INNER JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
        INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        INNER JOIN usuarios USU ON USU.id_usuario = ODT.creado_por
        INNER JOIN estados EST ON EST.idestado = ODT.idestado
        WHERE ODT.idorden_trabajo = _idodt;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareaPorId` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareaPorId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareaPorId`(IN _idtarea INT)
BEGIN
	SELECT 
			TAR.idtarea,
            TAR.descripcion,
            FRE.frecuencia,
            TAR.idestado,
            TAR.idfrecuencia,
            TAR.idplantarea,
            TAR.idsubcategoria,
            TAR.idtipo_prioridad,
            TAR.intervalo,
            TAR.pausado,
            TAR.trabajado,
            GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos
		FROM tareas TAR
		INNER JOIN frecuencias FRE ON FRE.idfrecuencia = TAR.idfrecuencia
		LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
		LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        WHERE TAR.idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareas` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareas`()
BEGIN 
    SELECT 
        TAR.idtarea,
        PT.descripcion AS plantarea,
        TAR.descripcion,
        TAR.pausado,
        ACT.idactivo AS id_activo,
        ACT.descripcion AS activo,
        AR.idusuario,
        PER.nombres,
        PER.apellidos,
        AR.es_responsable,
        TP.tipo_prioridad AS prioridad,
        TAR.intervalo,
        FRE.frecuencia,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
    FROM tareas TAR
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN activos_responsables AR ON AR.idactivo = ACT.idactivo AND AR.es_responsable = 1
    INNER JOIN usuarios USU ON USU.id_usuario = AR.idusuario
    INNER JOIN personas PER ON PER.id_persona = USU.idpersona
    INNER JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    INNER JOIN estados EST ON EST.idestado = TAR.idestado
    INNER JOIN frecuencias FRE ON FRE.idfrecuencia = TAR.idfrecuencia
    WHERE PT.eliminado = 0 AND PT.incompleto = 0;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasOdt`()
BEGIN
    SELECT 
        ODT.idorden_trabajo,
        GROUP_CONCAT(DISTINCT USURES.id_usuario SEPARATOR ', ') AS responsables_ids,
        GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,
        TAR.descripcion AS tarea,
        ODT.fecha_inicio,
        CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) as revisado_por,
        TAR.idtarea AS idtarea,
        TP.tipo_prioridad,
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        EST.nom_estado,
        ODT.incompleto,
        DODT.clasificacion,
        DODT.tiempo_ejecucion,
        ODT.hora_inicio,
        ODT.fecha_final,
        ODT.hora_final
    FROM odt ODT
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
	LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
	LEFT JOIN activos_responsables AR ON AR.idactivo = ACT.idactivo AND AR.es_responsable = 1
    LEFT JOIN usuarios USURES ON USURES.id_usuario = AR.idusuario
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasPorEstado` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasPorEstado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasPorEstado`(
	IN _idestado INT
)
BEGIN
	SELECT 
		TAR.descripcion,
        ACT.descripcion as activo,
        TP.tipo_prioridad,
        EST.nom_estado
        FROM tareas TAR
        INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
        LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
        LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
        LEFT JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
        LEFT JOIN estados EST ON EST.idestado = TAR.idestado
        WHERE EST.idestado = _idestado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasPorPlanTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasPorPlanTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasPorPlanTarea`(IN _idplantarea INT)
BEGIN
	SELECT TAR.idtarea, TAR.trabajado, TAR.pausado ,PT.descripcion as plan_tarea, TAR.idsubcategoria, TP.tipo_prioridad, TAR.descripcion ,ES.nom_estado FROM tareas TAR
    INNER JOIN plandetareas PT ON TAR.idplantarea = PT.idplantarea -- quitar esta linea luego pq no es necesario mostrar el plan de tareas al que pertenece
    INNER JOIN tipo_prioridades TP ON TAR.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN estados ES ON TAR.idestado = ES.idestado
    WHERE TAR.idplantarea = _idplantarea ORDER BY TAR.idtarea DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasSinActivos` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasSinActivos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasSinActivos`()
BEGIN 
    SELECT 
        TAR.idtarea,
        PT.descripcion AS plantarea,
        TAR.descripcion,
        TAR.pausado,
        GROUP_CONCAT(ACT.idactivo SEPARATOR ', ') AS ids_activos,
        GROUP_CONCAT(ACT.descripcion SEPARATOR ', ') AS activos, -- Concatenar activos
        TP.tipo_prioridad AS prioridad,
        TAR.intervalo,
        FRE.frecuencia,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
    FROM tareas TAR
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    INNER JOIN estados EST ON EST.idestado = TAR.idestado
    INNER JOIN frecuencias FRE ON FRE.idfrecuencia = TAR.idfrecuencia
    GROUP BY TAR.idtarea; -- Agrupar por tarea
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerUnActivoVinculadoAtarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerUnActivoVinculadoAtarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerUnActivoVinculadoAtarea`(IN _idactivo_vinculado INT)
BEGIN
	SELECT AVT.idactivo_vinculado, AVT.idactivo, AVT.idtarea, ACT.descripcion ,SUB.subcategoria FROM activos_vinculados_tarea AVT
    INNER JOIN activos ACT ON AVT.idactivo = ACT.idactivo
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    where AVT.idactivo_vinculado = _idactivo_vinculado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerUsuario` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerUsuario` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerUsuario`(
	IN _idusuario INT
)
BEGIN
	SELECT  * FROM usuarios WHERE idusuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrarDetalleOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrarDetalleOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarDetalleOdt`(
	OUT _iddetalleodt 		INT,
	IN _idorden_trabajo 	INT,
    IN _intervalos_ejecutados INT,
    IN _clasificacion		INT
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO detalle_odt (idorden_trabajo, intervalos_ejecutados, clasificacion)	
		VALUES (_idorden_trabajo, _intervalos_ejecutados, _clasificacion);
        
	IF existe_error = 1 THEN
		SET _iddetalleodt = -1;
	ELSE
        SET _iddetalleodt = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrarDiagnostico` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrarDiagnostico` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarDiagnostico`(
	OUT _iddiagnostico INT,
	IN _idorden_trabajo INT,
    IN _idtipo_diagnostico INT,
    IN _diagnostico VARCHAR(300)
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO diagnosticos (idorden_trabajo, idtipo_diagnostico, diagnostico)
		VALUES (_idorden_trabajo, _idtipo_diagnostico, _diagnostico);
        
	IF existe_error = 1 THEN
		SET _iddiagnostico = -1;
	ELSE
        SET _iddiagnostico = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrarEvidenciaDiagnostico` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrarEvidenciaDiagnostico` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarEvidenciaDiagnostico`(
	IN _iddiagnostico INT,
    IN _evidencia VARCHAR(80)
)
BEGIN
	INSERT INTO evidencias_diagnostico (iddiagnostico, evidencia)
		VALUES (_iddiagnostico, _evidencia);
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrarHistorial` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrarHistorial` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarHistorial`(
	IN _idorden_trabajo INT,
    IN _estado_anterior INT,
    IN _estado_nuevo 	INT,
    IN _comentario		TEXT,
    IN _devuelto		BOOLEAN
)
BEGIN
	INSERT INTO historial_estado_odt (idorden_trabajo, estado_anterior, estado_nuevo, comentario, devuelto)	
		VALUES (_idorden_trabajo, _estado_anterior, _estado_nuevo, _comentario, NULLIF(_devuelto, ""));
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrarHistorialOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrarHistorialOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarHistorialOdt`(
	OUT _idhistorial 		INT,
	IN _idorden_trabajo 	INT
)
BEGIN	
	-- Declaración de variable de control de error
	DECLARE existe_error INT DEFAULT 0;

	-- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
			SET existe_error = 1;
		END;
		
	-- Insertar el registro en historial_odt
	INSERT INTO historial_odt (idorden_trabajo) values (_idorden_trabajo);	

	-- Asignar el ID del último registro insertado o devolver -1 si hay error
	IF existe_error = 1 THEN
		SET _idhistorial = -1;
	ELSE
		SET _idhistorial = LAST_INSERT_ID();
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrar_comentario_odt` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrar_comentario_odt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_comentario_odt`(
	IN _idorden_trabajo 	INT,
    IN _comentario			VARCHAR(300),
    IN _revisadoPor			INT
)
BEGIN	
	INSERT INTO comentarios_odt (idorden_trabajo, comentario, revisadoPor)	
		VALUES (_idorden_trabajo, NULLIF(_comentario,""), _revisadoPor);	
END */$$
DELIMITER ;

/* Procedure structure for procedure `registrar_odt` */

/*!50003 DROP PROCEDURE IF EXISTS  `registrar_odt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_odt`(
	OUT _idorden_trabajo INT,
	IN _idtarea INT,
    IN _creado_por INT,
    IN _fecha_inicio DATE,
    IN _hora_inicio	TIME
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO odt (idtarea, creado_por, fecha_inicio, hora_inicio)
		VALUES (_idtarea, _creado_por, _fecha_inicio, _hora_inicio);
        
	IF existe_error = 1 THEN
		SET _idorden_trabajo = -1;
	ELSE
        SET _idorden_trabajo = LAST_INSERT_ID();
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `searchby_code` */

/*!50003 DROP PROCEDURE IF EXISTS  `searchby_code` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `searchby_code`(
	IN _cod_identificacion CHAR(40)
)
BEGIN
	SELECT modelo FROM activos WHERE cod_identificacion = _cod_identificacion;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_activos_sin_servicio` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_activos_sin_servicio` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activos_sin_servicio`(
    IN _fecha_adquisicion DATE,
    IN _idestado INT,
    IN _cod_identificacion CHAR(40)
)
BEGIN
	SELECT distinct
		ACT.idactivo,
        ACT.fecha_adquisicion,
        ACT.cod_identificacion,
        EST.nom_estado,
        ACT.descripcion,
        RES.idactivo_resp,
        (SELECT CONCAT(U.usuario,'|', P.apellidos, ' ', P.nombres) FROM usuarios U
        INNER JOIN personas P ON u.idpersona = P.id_persona WHERE
        U.id_usuario = RES.idusuario AND RES.es_responsable='1') as dato,
        UBI.ubicacion
	FROM historial_activos HIS
	INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp
        )
    )UBI ON UBI.idactivo_resp = RES.idactivo_resp
    RIGHT JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    WHERE  (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL) AND
    (ACT.cod_identificacion LIKE CONCAT('%',_cod_identificacion,'%') OR _cod_identificacion IS NULL) AND
	EST.idestado >1 AND EST.idestado<5
    AND (RES.es_responsable='1' OR RES.idactivo_resp IS NULL);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_add_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_activo`(
	OUT _idactivo	INT,
	IN _idsubcategoria INT,
	IN _idmarca INT,
    IN _modelo VARCHAR(60),
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _descripcion VARCHAR(200),
    IN _especificaciones JSON
)
BEGIN
	DECLARE existe_error INT DEFAULT 0;
    -- DECLARE repetido_cod INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
        SET existe_error = 1;
	END;
    
	INSERT INTO activos(idsubcategoria, idmarca, modelo, cod_identificacion, fecha_adquisicion, descripcion, especificaciones) VALUES
		(_idsubcategoria, _idmarca, _modelo, _cod_identificacion, _fecha_adquisicion, _descripcion, _especificaciones);
        
	-- SELECT cod_identificacion INTO repetido_cod
	-- FROM activos;
	-- IF repetido_cod = _cod_identificacion THEN
	-- 	SET _idactivo = -2;
	-- END IF;
    
    IF existe_error= 1 THEN
		SET _idactivo = -1;
	ELSE
        SET _idactivo = last_insert_id();
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_add_baja_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_baja_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_baja_activo`(
   OUT _idbaja_activo INT,
   IN  _idactivo INT,
   IN  _motivo VARCHAR(250),
   IN  _coment_adicionales VARCHAR(250),
   IN _ruta_doc VARCHAR(250),
   IN  _aprobacion INT
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET existe_error = 1;
	END;

     INSERT INTO bajas_activo(idactivo, motivo, coment_adicionales, ruta_doc, aprobacion) VALUES
     (_idactivo, _motivo, NULLIF(_coment_adicionales,''), _ruta_doc, _aprobacion);

     IF existe_error = 1 THEN
		SET _idbaja_activo = -1;
     ELSE
		SET _idbaja_activo = last_insert_id();
     END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_add_historial_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_historial_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_historial_activo`(
	OUT _idhistorial_activo INT,
	IN _idactivo_resp INT,
    IN _idubicacion INT,
    IN _accion VARCHAR(70),
    IN _responsable_accion INT,
    IN _idactivo INT
)
BEGIN
	DECLARE existe_error INT DEFAULT 0;
    
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO historial_activos(idactivo_resp, idubicacion, accion, responsable_accion, idactivo) VALUES
    (_idactivo_resp, _idubicacion, _accion, _responsable_accion, _idactivo);
    
	IF existe_error= 1 THEN
		SET _idhistorial_activo = -1;
	ELSE
        SET _idhistorial_activo = last_insert_id();
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_add_notificacion_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_notificacion_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_notificacion_activo`(
	IN _idactivo_resp INT,
    IN _tipo	VARCHAR(30),
	IN _mensaje VARCHAR(400),
    IN _idactivo INT
)
BEGIN
	INSERT INTO notificaciones_activos (idactivo_resp, tipo, mensaje, idactivo) VALUES
	 (NULLIF(_idactivo_resp,''), _tipo, _mensaje, NULLIF(_idactivo, ''));
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_data_baja_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_data_baja_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_data_baja_activo`(
	IN _idactivo INT
)
BEGIN
	SELECT idbaja_activo, fecha_baja, motivo, coment_adicionales, ruta_doc, aprobacion FROM bajas_activo
    WHERE idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_default_especificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_default_especificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_default_especificacion`(
	IN _idsubcategoria INT
)
BEGIN
	SELECT especificaciones FROM 
    especificacionesdefecto 
    WHERE idsubcategoria = _idsubcategoria;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_detalle_asignacion_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_asignacion_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_asignacion_notificacion`(
    IN _idnotificacion_activo INT
)
BEGIN
    SELECT
        ACT.idactivo,ACT.cod_identificacion,ACT.descripcion, ACT.modelo,
        RES.idactivo_resp, RES.descripcion as des_responsable,RES.condicion_equipo,RES.fecha_asignacion,RES.autorizacion,
        NA.fecha_creacion,
        MAR.marca,
        SUB.subcategoria,
        UBI.ubicacion
    FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    WHERE NA.idnotificacion_activo =_idnotificacion_activo
    ORDER BY HIS.fecha_movimiento DESC
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_detalle_notificacion_baja_wh_idactivo_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_notificacion_baja_wh_idactivo_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_notificacion_baja_wh_idactivo_resp`(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT 
		NA.idnotificacion_activo, NA.tipo, NA.visto, NA.mensaje, NA.fecha_creacion,
		ACT.idactivo, ACT.descripcion, ACT.cod_identificacion, ACT.modelo,
        SUB.subcategoria,
        MAR.marca,
        BA.fecha_baja, BA.motivo, BA.coment_adicionales, BA.aprobacion,
        UBI.ubicacion,
		HA.responsable_accion, HA.fecha_movimiento
	FROM notificaciones_activos NA
	LEFT JOIN activos ACT ON NA.idactivo = ACT.idactivo
    LEFT JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    LEFT JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	LEFT JOIN historial_activos HA ON ACT.idactivo = HA.idactivo
    LEFT JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
    LEFT JOIN bajas_activo BA ON ACT.idactivo = BA.idactivo
	WHERE NA.idactivo_resp IS NULL 
	  AND HA.responsable_accion IS NOT NULL
      AND NA.idnotificacion_activo = _idnotificacion_activo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_detalle_orden_trabajo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_orden_trabajo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_orden_trabajo`(
    IN _idnotificacion_mantenimiento INT
)
BEGIN
    SELECT
		NM.tarea, NM.fecha_creacion, NM.activos,
        ODT.creado_por,
        T.descripcion as descripcionT, T.fecha_inicio, T.fecha_vencimiento, T.cant_intervalo, T.frecuencia,T.create_at,
        TP.tipo_prioridad,
        PT.descripcion as descripcionPT
    FROM notificaciones_mantenimiento NM
    INNER JOIN odt ODT ON NM.idorden_trabajo = ODT.idorden_trabajo
    INNER JOIN tareas T ON ODT.idtarea = ODT.idtarea
    INNER JOIN tipo_prioridades TP ON T.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN plandetareas PT ON T.idplantarea = PT.idplantarea
    WHERE NM.idnotificacion_mantenimiento = _idnotificacion_mantenimiento
    ORDER BY T.create_at DESC
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_detalle_ubicacion_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_ubicacion_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_ubicacion_notificacion`(
	IN _idnotificacion_activo INT
)
BEGIN 
		SELECT 
			ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
			MAR.marca,
            SUB.subcategoria,
            U.ubicacion,
            HA.fecha_movimiento, HA.responsable_accion,
            NA.fecha_creacion
            FROM historial_activos HA
            INNER JOIN ubicaciones U ON HA.idubicacion = U.idubicacion
            INNER JOIN activos_responsables AR ON HA.idactivo_resp = AR.idactivo_resp
            INNER JOIN activos ACT ON AR.idactivo = ACT.idactivo
            INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
            INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
            INNER JOIN notificaciones_activos NA ON AR.idactivo_resp = NA.idactivo_resp
            
            WHERE NA.idnotificacion_activo = _idnotificacion_activo
            ORDER BY HA.fecha_movimiento DESC
            LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_existe_responsable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_existe_responsable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_existe_responsable`(
	IN _idactivo INT
)
BEGIN
	SELECT COUNT(es_responsable) cantidad FROM
    activos_responsables 
    WHERE idactivo=_idactivo AND es_responsable='1';
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filter_by_subcategorias` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filter_by_subcategorias` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filter_by_subcategorias`(
	IN _idsubcategoria INT
)
BEGIN
	SELECT DISTINCT MAR.idmarca, MAR.marca
	FROM marcas MAR
	INNER JOIN activos ACT ON MAR.idmarca = ACT.idmarca
	WHERE ACT.idsubcategoria = _idsubcategoria;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filter_marcas_by_subcategoria` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filter_marcas_by_subcategoria` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filter_marcas_by_subcategoria`(
	IN _idsubcategoria INT
)
BEGIN
	SELECT M.idmarca, M.marca
    FROM marcas M
    INNER JOIN detalles_marca_subcategoria MS ON M.idmarca = MS.idmarca
    WHERE MS.idsubcategoria = _idsubcategoria;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtrar_activos_responsables_asignados` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtrar_activos_responsables_asignados` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filtrar_activos_responsables_asignados`(
    IN _idsubcategoria INT,
    IN _idubicacion INT,
    IN _cod_identificacion CHAR(40)
)
BEGIN
    SELECT 
        RES.idactivo_resp,
        ACT.cod_identificacion,
        ACT.idactivo,
        ACT.descripcion,
        SUB.subcategoria,
        ACT.modelo,
        MAR.marca,
        UBI.ubicacion,
        EST.nom_estado,
        RES.autorizacion,
        RES.es_responsable,
        USU.id_usuario
    FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    INNER JOIN (
        SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
        FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
            SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp 
        )
    ) UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE 
        (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL) AND
        (UBI.idubicacion = _idubicacion OR _idubicacion IS NULL) AND
        (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL) AND
        ACT.idestado BETWEEN 1 AND 2 AND
        RES.es_responsable = 1
    GROUP BY ACT.idactivo
    ORDER BY RES.idactivo_resp ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_filtrar_usuarios` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_filtrar_usuarios` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_filtrar_usuarios`(
    IN _numdoc VARCHAR(50),
    IN _dato VARCHAR(80)
)
BEGIN
	SELECT
		U.id_usuario,
		U.usuario,
        R.rol,
        CONCAT(P.apellidos,' ',P.nombres) as nombres,
        TD.tipodoc,
        P.num_doc,
		U.estado,
        U.asignacion
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    AND (P.num_doc LIKE CONCAT('%', _numdoc ,'%') OR _numdoc IS NULL)
    AND (P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL)
    WHERE U.asignacion = 7 AND R.idrol = 2;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getresp_principal` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getresp_principal` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getresp_principal`(
	IN _idactivo_resp INT,
	IN _idactivo INT
)
BEGIN
	DECLARE isResP INT DEFAULT 0;
    
    SELECT COUNT(*) INTO isResP
    FROM activos_responsables WHERE es_responsable='1'
    AND idactivo =_idactivo AND fecha_designacion IS NULL;
    
    IF isResP>0 THEN
		SELECT 
			RES.idactivo_resp,
			P.apellidos, P.nombres,
			U.usuario
		FROM activos_responsables RES
		INNER JOIN usuarios U ON RES.idusuario = U.id_usuario
		INNER JOIN personas P ON U.idpersona = P.id_persona
		WHERE RES.idactivo = _idactivo AND RES.es_responsable = '1';
	ELSE
		SELECT 
			RES.idactivo_resp,
			P.apellidos, P.nombres,
			U.usuario
		FROM activos_responsables RES
		INNER JOIN usuarios U ON RES.idusuario = U.id_usuario
		INNER JOIN personas P ON U.idpersona = P.id_persona
		WHERE RES.idactivo_resp = _idactivo_resp AND RES.fecha_designacion IS NULL
        ORDER BY RES.fecha_asignacion asc
        LIMIT 1;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_getUser_by_id` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getUser_by_id` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getUser_by_id`(
	IN _idusuario INT
)
BEGIN
	SELECT U.id_usuario, U.usuario, CONCAT(P.apellidos, ' ', P.nombres) as dato, U.idrol
    FROM usuarios U
    INNER JOIN personas P ON U.idpersona = P.id_persona
    WHERE U.id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_get_activoById` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_get_activoById` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_activoById`(
	IN _idactivo INT
)
BEGIN
	SELECT descripcion, cod_identificacion FROM activos
    WHERE idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_get_any_idresp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_get_any_idresp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_any_idresp`(
	IN _idactivo INT
)
BEGIN
	select idactivo_resp FROM activos_responsables 
    WHERE idactivo = _idactivo
    ORDER BY idactivo_resp desc
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_get_any_ubicacion_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_get_any_ubicacion_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_any_ubicacion_activo`(
	IN _idactivo_resp INT
)
BEGIN
	SELECT idubicacion FROM historial_activos
    WHERE idactivo_resp = _idactivo_resp
    ORDER BY fecha_movimiento DESC
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_get_user_persona` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_get_user_persona` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_persona`(
	IN _idusuario INT
)
BEGIN
		SELECT
		U.id_usuario,
		U.usuario,
        R.idrol,
        P.apellidos,
        TD.idtipodoc,
        P.nombres,
        P.num_doc,
        P.telefono,
        P.genero
			FROM usuarios U
			INNER JOIN roles R ON U.idrol = R.idrol
			INNER JOIN personas P ON U.idpersona = P.id_persona
			INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
		WHERE U.id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_activos` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_activos` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_activos`(
	IN _idsubcategoria INT,
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _fecha_adquisicion_fin DATE,
    IN _idestado INT,
    IN _idmarca INT
)
BEGIN
	SELECT
		ACT.idactivo,
        SUB.subcategoria,
        CAT.categoria,
        MAR.marca,
        EST.nom_estado,
        ACT.modelo,
        ACT.cod_identificacion,
        ACT.fecha_adquisicion,
        ACT.descripcion,
        EST.nom_estado,
        ACT.especificaciones
	FROM activos ACT
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    WHERE (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL)
    AND (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL)
    AND (ACT.fecha_adquisicion>=_fecha_adquisicion AND ACT.fecha_adquisicion<=_fecha_adquisicion_fin OR _fecha_adquisicion IS NULL OR _fecha_adquisicion_fin IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL)
    AND (MAR.idmarca = _idmarca OR _idmarca IS NULL);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_notificacion`(
	IN _idusuario INT
)
BEGIN
SELECT 
    NA.idnotificacion_activo AS idnotificacion, 
    NA.tipo AS tipo_notificacion, 
    NA.mensaje, 
    NA.fecha_creacion, 
    NA.visto,
    A.descripcion AS descripcion_activo,
    AR.idactivo_resp,
    U.usuario AS usuario_nombre
FROM 
    notificaciones_activos NA
INNER JOIN 
    activos_responsables AR ON NA.idactivo_resp = AR.idactivo_resp
INNER JOIN 
    activos A ON AR.idactivo = A.idactivo
INNER JOIN 
    usuarios U ON AR.idusuario = U.id_usuario
WHERE U.id_usuario = _idusuario  -- Especifica aquí el usuario

UNION ALL

SELECT 
    NM.idnotificacion_mantenimiento AS idnotificacion, 
    'Mantenimiento' AS tipo_notificacion,  -- Etiqueta fija para diferenciar el tipo
    NM.mensaje, 
    NM.fecha_creacion, 
    NM.visto, 
    NM.activos AS descripcion_activo, 
    NM.idresp as idactivo_resp,
    U.usuario AS usuario_nombre
FROM 
    notificaciones_mantenimiento NM
INNER JOIN 
    usuarios U ON NM.idresp = U.id_usuario  -- Ahora usamos idresp directamente en la relación con usuarios
WHERE U.id_usuario = _idusuario -- Especifica aquí el mismo usuario

UNION ALL

SELECT 
    NA.idnotificacion_activo AS idnotificacion, 
    NA.tipo AS tipo_notificacion, 
    NA.mensaje, 
    NA.fecha_creacion, 
    NA.visto, 
    ACT.descripcion AS descripcion_activo,
    HA.idactivo_resp,
    U.usuario AS usuario_nombre -- Relación con usuarios
FROM 
    notificaciones_activos NA
LEFT JOIN 
    activos ACT ON NA.idactivo = ACT.idactivo
LEFT JOIN 
    historial_activos HA ON ACT.idactivo = HA.idactivo
LEFT JOIN 
    usuarios U ON HA.responsable_accion = U.id_usuario -- Relación con usuarios
WHERE 
    NA.idactivo_resp IS NULL 
    AND HA.responsable_accion IS NOT NULL
    AND HA.responsable_accion = _idusuario
ORDER BY 
    fecha_creacion DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_notificacion_mantenimiento` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_notificacion_mantenimiento` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_notificacion_mantenimiento`(
	IN _idusuario INT
)
BEGIN
	SELECT
		*
		FROM notificaciones_mantenimiento
        WHERE idresp = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_notificacion_wh_idactivo_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_notificacion_wh_idactivo_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_notificacion_wh_idactivo_resp`(
	IN _idaccion_responsable INT
)
BEGIN
	SELECT 
		NA.idnotificacion_activo, NA.tipo, NA.visto, NA.mensaje, NA.fecha_creacion,
		ACT.idactivo, ACT.descripcion, NA.idactivo_resp
	FROM notificaciones_activos NA
	LEFT JOIN activos ACT ON NA.idactivo = ACT.idactivo
	LEFT JOIN historial_activos HA ON ACT.idactivo = HA.idactivo
	WHERE NA.idactivo_resp IS NULL 
	  AND HA.responsable_accion IS NOT NULL
	  AND HA.responsable_accion = 1; 
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_persona_users` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_persona_users` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_persona_users`(
	IN _idrol INT,
    IN _idtipodoc INT,
    IN _estado CHAR(1),
    IN _dato VARCHAR(50)
)
BEGIN
	SELECT
		U.id_usuario,
		U.usuario,
        R.rol,
        U.estado,
        CONCAT(P.apellidos,' ',P.nombres) as nombres,
        TD.tipodoc,
        P.num_doc,
        P.telefono,
        P.genero,
        U.asignacion
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    WHERE (R.idrol = _idrol OR _idrol IS NULL) 
    AND (U.estado = _estado OR _estado IS NULL) 
    AND (TD.idtipodoc=_idtipodoc OR _idtipodoc IS NULL)
    AND (CONCAT(P.apellidos,' ',P.nombres) LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_resp_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_resp_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_resp_activo`()
BEGIN
	SELECT R.idactivo_resp, A.descripcion
    FROM activos_responsables R
    INNER JOIN activos A ON R.idactivo = A.idactivo
    WHERE A.idestado >=3 AND A.idestado<=4;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_users` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_users` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_users`(
)
BEGIN
	SELECT
    US.id_usuario,
    US.usuario,
    RO.rol
    FROM usuarios US
    INNER JOIN roles RO ON US.idrol = RO.idrol
    WHERE US.estado=1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_max_colaboradores` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_max_colaboradores` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_max_colaboradores`(
	OUT _cantidad INT,
	IN _idactivo INT
)
BEGIN
	DECLARE es_resp INT DEFAULT 0;
    
	SELECT COUNT(idusuario) INTO es_resp 
	FROM activos_responsables 
	WHERE es_responsable = 1 AND idactivo = _idactivo;

    IF es_resp >=1 THEN
		SET _cantidad = -1;
	ELSE
		SELECT COUNT(idusuario) INTO _cantidad 
		FROM activos_responsables
		WHERE idactivo = _idactivo AND es_responsable = 0 AND fecha_designacion IS NULL;
    END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_notificacion_baja_detalle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_notificacion_baja_detalle` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_notificacion_baja_detalle`(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		NA.idnotificacion_activo,RES.idactivo_resp,
		ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
        MAR.marca,
        SUB.subcategoria,
        BA.fecha_baja, BA.motivo, BA.aprobacion, BA.coment_adicionales,
        UBI.ubicacion,
        NA.fecha_creacion
        FROM historial_activos HA
        INNER JOIN activos_responsables RES ON HA.idactivo_resp = RES.idactivo_resp
        INNER JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
        INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
        INNER JOIN notificaciones_activos NA ON ACT.idactivo = NA.idactivo
        INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        INNER JOIN bajas_activo BA ON ACT.idactivo = BA.idactivo
        WHERE NA.idnotificacion_activo = _idnotificacion_activo 
			  AND RES.fecha_designacion IS NULL
        ORDER BY HA.fecha_movimiento DESC
        LIMIT 1; -- probar cuando el usuario no es responsable p 
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_notificacion_designacion_detalle` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_notificacion_designacion_detalle` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_notificacion_designacion_detalle`(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		NA.idnotificacion_activo, NA.fecha_creacion,
        ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
        SUB.subcategoria, MAR.marca,
        RES.fecha_designacion, RES.es_responsable, RES.idactivo_resp,
        UBI.ubicacion, HA.responsable_accion
        FROM historial_activos HA
        INNER JOIN ubicaciones UBI ON HA.idubicacion = UBI.idubicacion
        INNER JOIN activos_responsables RES ON HA.idactivo_resp =RES.idactivo_resp
        INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
        INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
        WHERE NA.idnotificacion_activo = _idnotificacion_activo AND RES.fecha_designacion IS NOT NULL
        ORDER BY HA.fecha_movimiento DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_persona_by_numdoc` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_persona_by_numdoc` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_persona_by_numdoc`(
	IN _num_doc VARCHAR(50)
)
BEGIN
	SELECT 
		USU.usuario,
		PER.idtipodoc, 
		PER.apellidos, 
        PER.nombres, 
        PER.telefono, 
        PER.genero, 
        USU.idrol,
        USU.contrasena
    FROM usuarios USU
    RIGHT JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE PER.num_doc=_num_doc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_register_person` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_register_person` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_person`(
	IN _idtipodoc INT,
    IN _num_doc	VARCHAR(30),
    IN _apellidos VARCHAR(100),
    IN _nombres VARCHAR(100),
    IN _genero	CHAR(1),
    IN _telefono CHAR(9)
)
BEGIN
	INSERT INTO PERSONAS (idtipodoc, num_doc, apellidos, nombres, genero, telefono) VALUES 
    (_idtipodoc, _num_doc, _apellidos, _nombres, _genero, _telefono);
    
    SELECT last_insert_id() as idpersona;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_register_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_register_user` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register_user`(
	IN _idpersona 	INT,
    IN _idrol		INT,
    IN _usuario		VARCHAR(120),
    IN _contrasena	VARCHAR(120)
)
BEGIN
	INSERT INTO usuarios (idpersona, idrol, usuario, contrasena)
    VALUES (_idpersona, _idrol, _usuario, _contrasena);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_repeat_responsable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_repeat_responsable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_repeat_responsable`(
    IN _idactivo INT,
    IN _idusuario INT
)
BEGIN
    SELECT
	COUNT(idactivo_resp) cantidad,
    USU.usuario
    FROM activos_responsables
    INNER JOIN usuarios USU ON activos_responsables.idusuario = USU.id_usuario
    WHERE idactivo=_idactivo AND idusuario = _idusuario AND fecha_designacion IS NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_respact_add` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_respact_add` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_respact_add`(
	IN _idactivo INT,
    IN _idusuario INT,
    IN _condicion_equipo VARCHAR(500),
    IN _imagenes	JSON,
    IN _descripcion VARCHAR(500),
    IN _autorizacion INT,
    IN _solicitud INT
)
BEGIN
	INSERT INTO activos_responsables(idactivo, idusuario, condicion_equipo, imagenes, descripcion, autorizacion, solicitud) VALUES
		(_idactivo, _idusuario, _condicion_equipo, _imagenes, _descripcion, _autorizacion, _solicitud);
        
	SELECT last_insert_id() as idresp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_responsable_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_responsable_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_responsable_notificacion`(
	IN _idusuario INT
)
BEGIN
	SELECT
    RES.idusuario,
	ACT.descripcion,
    RES.descripcion desresp,
    RES.idactivo_resp,
    RES.fecha_asignacion
	FROM activos_responsables RES
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE RES.idusuario = _idusuario
    ORDER BY RES.idactivo_resp DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_responsable_principal_detalle_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_responsable_principal_detalle_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_responsable_principal_detalle_notificacion`(
	IN _idnotificacion_activo INT
)
BEGIN
	SELECT
		ACT.cod_identificacion, ACT.modelo, ACT.descripcion, ACT.idactivo,
		MAR.marca,
		SUB.subcategoria,
        HA.fecha_movimiento, HA.responsable_accion,
        NA.fecha_creacion,
        AR.fecha_asignacion
        FROM historial_activos HA
		INNER JOIN activos_responsables AR ON HA.idactivo_resp = AR.idactivo_resp
		INNER JOIN activos ACT ON AR.idactivo = ACT.idactivo
		INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
		INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
		INNER JOIN notificaciones_activos NA ON AR.idactivo_resp = NA.idactivo_resp
        WHERE NA.idnotificacion_activo = _idnotificacion_activo
        ORDER BY HA.fecha_movimiento DESC
        LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo`(
	IN _cod_identificacion VARCHAR(40)
)
BEGIN
	SELECT ACT.idactivo, ACT.cod_identificacion, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion,'%') AND ACT.idestado!=4 
	ORDER BY SUB.subcategoria ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_activo_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_activo_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo_resp`(
	IN _cod_identificacion VARCHAR(40)
)
BEGIN
	SELECT DISTINCT ACT.idactivo, ACT.cod_identificacion, ACT.descripcion
	FROM activos ACT
    -- INNER JOIN activos_responsables RES ON ACT.idactivo = RES.idactivo
	-- INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    -- INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion,'%') AND ACT.idestado!=4 AND ACT.idestado!=5
	ORDER BY ACT.idactivo ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_activo_responsable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_activo_responsable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo_responsable`(
	IN _idsubcategoria	INT,
    IN _idubicacion	    INT,
    IN _cod_identificacion CHAR(40)
)
BEGIN
		SELECT 
	  RES.idactivo_resp,
      ACT.cod_identificacion,
	  ACT.idactivo,
	  ACT.descripcion,
      SUB.subcategoria,
      ACT.modelo,
      MAR.marca,
	  UBI.ubicacion,
	  EST.nom_estado,
      RES.autorizacion
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp 
        )
    )UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE 	(SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL) AND
			(UBI.idubicacion = _idubicacion OR _idubicacion IS NULL) AND
			(ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL) AND 
            ACT.idestado = 1 AND
            -- RES.fecha_designacion IS NULL
            ACT.idestado BETWEEN 1 AND 2
    GROUP BY ACT.idactivo
    ORDER BY RES.idactivo_resp asc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_by_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_by_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_by_activo`(
	IN _idactivo INT
)
BEGIN
	SELECT
		RES.idusuario,
		RES.idactivo_resp,
		CONCAT(PER.apellidos,' ',PER.nombres) as nombres,
        ROL.rol,
        RES.es_responsable,
        (SELECT COUNT(R.idactivo_resp) FROM activos_responsables R
WHERE R.idusuario = RES.idusuario AND R.fecha_designacion IS NULL) as cantidad,
        USU.estado
	FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    INNER JOIN roles ROL ON USU.idrol = ROL.idrol
    WHERE RES.idactivo = _idactivo AND RES.fecha_designacion IS NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_resp`(
	IN _idactivo_resp INT
)
BEGIN
	 SELECT 
	  RES.idactivo_resp, RES.condicion_equipo, RES.autorizacion, RES.descripcion despresp, RES.imagenes,
	  ACT.idactivo, ACT.cod_identificacion, ACT.descripcion, ACT.fecha_adquisicion, ACT.modelo, ACT.especificaciones,
      SUB.subcategoria,
      MAR.marca,
	  UBI.ubicacion,
	  EST.nom_estado
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H1.idactivo_resp, UBI1.ubicacion, UBI1.idubicacion
		FROM historial_activos H1
        INNER JOIN ubicaciones UBI1 ON H1.idubicacion = UBI1.idubicacion
        WHERE H1.fecha_movimiento = (
			SELECT MAX(H2.fecha_movimiento)
            FROM historial_activos H2
            WHERE H2.idactivo_resp = H1.idactivo_resp
        )
    )UBI ON UBI.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo_resp = _idactivo_resp
    GROUP BY ACT.idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_telefono` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_telefono` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_telefono`(
	IN _telefono CHAR(9)
)
BEGIN
	SELECT id_persona FROM personas WHERE telefono =_telefono;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_update_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_update_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_update_activo`(
	IN _idactivo INT
)
BEGIN
		SELECT
		ACT.idactivo, ACT.idsubcategoria, ACT.idmarca, MAR.marca,
        SUB.subcategoria,
        CAT.categoria,
        EST.nom_estado,
        ACT.modelo,
        ACT.cod_identificacion,
        ACT.fecha_adquisicion,
        ACT.descripcion,
        ACT.especificaciones
		FROM activos ACT
		INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
		INNER JOIN categorias CAT ON SUB.idcategoria = CAT.idcategoria
		INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
		INNER JOIN estados EST ON ACT.idestado = EST.idestado
        WHERE ACT.idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_user` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_user` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_user`(
	IN _usuario VARCHAR(120)
)
BEGIN
	SELECT id_usuario FROM usuarios WHERE usuario = _usuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_ubicacion_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_ubicacion_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ubicacion_activo`(
	IN _idactivo INT,
	IN _idactivo_resp INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo and res.idactivo_resp = _idactivo_resp
    ORDER BY HIS.fecha_movimiento desc
    LIMIT 1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_ubicacion_only_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_ubicacion_only_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ubicacion_only_activo`(
	IN _idactivo INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo
    ORDER BY HIS.fecha_movimiento desc;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activo`(
	IN _idactivo INT,
	IN _idsubcategoria INT,
	IN _idmarca INT,
    IN _modelo VARCHAR(60),
    IN _cod_identificacion CHAR(40),
    IN _fecha_adquisicion DATE,
    IN _descripcion VARCHAR(200),
    IN _especificaciones JSON
)
BEGIN
	UPDATE activos SET
    idsubcategoria = _idsubcategoria,
    idmarca = _idmarca,
    modelo = _modelo,
    cod_identificacion = _cod_identificacion,
    fecha_adquisicion = _fecha_adquisicion,
    descripcion = _descripcion,
    especificaciones = _especificaciones
    WHERE idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_activo_responsable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_activo_responsable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activo_responsable`(
    IN _idactivo_resp INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _autorizacion INT
)
BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
        autorizacion = _autorizacion,
        fecha_designacion = NOW()
	WHERE idactivo_resp = _idactivo_resp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_asignacion_principal` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_asignacion_principal` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_asignacion_principal`(
    IN _idactivo_resp INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _es_responsable CHAR(1),
    IN _autorizacion INT
)
BEGIN
	UPDATE activos_responsables SET
		idactivo = _idactivo,
		idusuario = _idusuario,
		es_responsable = _es_responsable,
        autorizacion = _autorizacion
	WHERE idactivo_resp = _idactivo_resp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_asignacion_usuario` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_asignacion_usuario` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_asignacion_usuario`(
	IN _idusuario INT,
    IN _asignacion INT
)
BEGIN
	UPDATE usuarios SET
    asignacion = _asignacion
    WHERE id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_claveacceso` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_claveacceso` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_claveacceso`(
	IN _idusuario INT,
    IN _contrasena VARCHAR(120)
)
BEGIN
	UPDATE usuarios SET
    contrasena = _contrasena
    WHERE id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_estado_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_estado_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_estado_activo`(
	IN _idactivo INT,
    IN _idestado INT
)
BEGIN
	UPDATE activos SET
    idestado = _idestado
    WHERE idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_estado_usuario` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_estado_usuario` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_estado_usuario`(
	IN _idusuario INT,
    IN _estado CHAR(1)
)
BEGIN
	UPDATE usuarios SET
    estado = _estado
    WHERE id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_persona` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_persona` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_persona`(
	IN _idpersona INT,
    IN _idtipo_doc INT,
    IN _num_doc VARCHAR(50),
    IN _apellidos VARCHAR(100),
    IN _nombres VARCHAR(100),
    IN _genero CHAR(1),
    IN _telefono CHAR(9)
)
BEGIN
	UPDATE personas SET
	idtipodoc = _idtipo_doc,
    num_doc = _num_doc,
    apellidos = _apellidos,
    nombres = _nombres,
    genero = _genero,
    telefono = _telefono
    WHERE id_persona = _idpersona;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_responsable` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_responsable` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_responsable`(
	IN _idactivo_resp INT
)
BEGIN
	UPDATE activos_responsables SET
    es_responsable='1'
    WHERE idactivo_resp=_idactivo_resp;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_update_usuario` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_update_usuario` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_usuario`(
	OUT _idpersona INT,
	IN _idusuario INT,
    IN _idrol	INT,
    IN _usuario VARCHAR(120)
)
BEGIN
	UPDATE usuarios SET
    idrol = _idrol,
    usuario = _usuario
    WHERE id_usuario = _idusuario;
    
    SELECT idpersona INTO _idpersona
    FROM usuarios WHERE id_usuario = _idusuario;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_users_by_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_users_by_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_by_activo`(
	IN _idactivo INT
)
BEGIN
	SELECT
    USU.id_usuario,
	USU.usuario,
    PER.apellidos,
    RES.idactivo_resp,
    RES.fecha_asignacion,
    RES.fecha_designacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo
    ORDER BY RES.fecha_asignacion DESC;
    -- AND RES.fecha_designacion IS NULL
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_users_by_activo_v2` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_users_by_activo_v2` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_by_activo_v2`(
	IN _idactivo INT
)
BEGIN
	SELECT
    USU.id_usuario,
	USU.usuario,
    PER.apellidos,
    RES.idactivo_resp,
    RES.fecha_asignacion,
    RES.fecha_designacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo
    AND RES.fecha_designacion IS NULL
    ORDER BY RES.fecha_asignacion DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_user_login` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_user_login` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_login`(
	IN _usuario VARCHAR(120)
)
BEGIN
	SELECT
    US.id_usuario,
    CONCAT(PE.apellidos, ' ', PE.nombres) datos,
    US.usuario,
    RO.rol,
    US.contrasena,
    US.estado
    FROM usuarios US
    LEFT JOIN personas PE ON US.idpersona = PE.id_persona
    LEFT JOIN roles RO ON US.idrol = RO.idrol
    WHERE usuario=_usuario AND US.estado=1;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_verificar_colaboradores` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_verificar_colaboradores` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_colaboradores`(
	IN _idactivo INT
)
BEGIN    
    SELECT COUNT(*) colaboradores
    FROM activos_responsables 
    WHERE idactivo = _idactivo AND fecha_designacion IS NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `verificarOrdenInconclusa` */

/*!50003 DROP PROCEDURE IF EXISTS  `verificarOrdenInconclusa` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `verificarOrdenInconclusa`(
	IN _idorden_trabajo INT
)
BEGIN
	SELECT
		*
        FROM odt ODT
        LEFT JOIN diagnosticos DIA ON DIA.idorden_trabajo = ODT.idorden_trabajo
        WHERE ODT.idorden_trabajo = 21 AND ODT.borrador = 1;
	
END */$$
DELIMITER ;

/* Procedure structure for procedure `verificarPlanInconcluso` */

/*!50003 DROP PROCEDURE IF EXISTS  `verificarPlanInconcluso` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `verificarPlanInconcluso`(IN _idplantarea INT)
BEGIN
	SELECT 
        pt.idplantarea, 
        pt.descripcion, 
        COUNT(t.idtarea) AS cantidad_tareas,
        COUNT(a.idactivo) AS cantidad_activos
    FROM plandetareas pt
    LEFT JOIN tareas t ON pt.idplantarea = t.idplantarea
    LEFT JOIN activos_vinculados_tarea a ON t.idtarea = a.idtarea
    WHERE pt.idplantarea = _idplantarea
    GROUP BY pt.idplantarea, pt.descripcion;
END */$$
DELIMITER ;

/*Table structure for table `v_personas` */

DROP TABLE IF EXISTS `v_personas`;

/*!50001 DROP VIEW IF EXISTS `v_personas` */;
/*!50001 DROP TABLE IF EXISTS `v_personas` */;

/*!50001 CREATE TABLE  `v_personas`(
 `id_persona` int(11) ,
 `idtipodoc` int(11) ,
 `num_doc` varchar(50) ,
 `apellidos` varchar(100) ,
 `nombres` varchar(100) ,
 `genero` char(1) ,
 `telefono` char(9) 
)*/;

/*Table structure for table `v_subcategoria` */

DROP TABLE IF EXISTS `v_subcategoria`;

/*!50001 DROP VIEW IF EXISTS `v_subcategoria` */;
/*!50001 DROP TABLE IF EXISTS `v_subcategoria` */;

/*!50001 CREATE TABLE  `v_subcategoria`(
 `idsubcategoria` int(11) ,
 `categoria` varchar(60) ,
 `subcategoria` varchar(60) 
)*/;

/*View structure for view v_personas */

/*!50001 DROP TABLE IF EXISTS `v_personas` */;
/*!50001 DROP VIEW IF EXISTS `v_personas` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_personas` AS select `personas`.`id_persona` AS `id_persona`,`personas`.`idtipodoc` AS `idtipodoc`,`personas`.`num_doc` AS `num_doc`,`personas`.`apellidos` AS `apellidos`,`personas`.`nombres` AS `nombres`,`personas`.`genero` AS `genero`,`personas`.`telefono` AS `telefono` from `personas` */;

/*View structure for view v_subcategoria */

/*!50001 DROP TABLE IF EXISTS `v_subcategoria` */;
/*!50001 DROP VIEW IF EXISTS `v_subcategoria` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_subcategoria` AS select `sub`.`idsubcategoria` AS `idsubcategoria`,`cat`.`categoria` AS `categoria`,`sub`.`subcategoria` AS `subcategoria` from (`categorias` `cat` left join `subcategorias` `sub` on(`sub`.`idcategoria` = `cat`.`idcategoria`)) order by `sub`.`idsubcategoria` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
