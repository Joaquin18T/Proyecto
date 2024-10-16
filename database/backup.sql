/*
SQLyog Ultimate v12.5.1 (64 bit)
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos` */

insert  into `activos`(`idactivo`,`idsubcategoria`,`idmarca`,`idestado`,`modelo`,`cod_identificacion`,`fecha_adquisicion`,`descripcion`,`especificaciones`) values 
(1,2,1,1,'14-EP','123ABC','2024-10-16','Laptop 14-EP 16 RAM','{\"ram\":\"16GB\", \"disco\":\"solido\"}'),
(2,10,1,5,'Monitor 4K','MON123','2024-10-16','Monitor LG de 27 pulgadas','{\"resolucion\":\"3840x2160\"}'),
(3,11,2,5,'Teclado Mecánico','TEC123','2024-10-16','Teclado mecánico HP','{\"tipo\":\"mecánico\", \"conectividad\":\"inalámbrico\"}'),
(4,7,4,2,'Compresor Industrial','COMP123','2024-10-16','Compresor Caterpillar de 10HP','{\"potencia\":\"10HP\"}'),
(5,6,5,2,'Camión de Carga Hyundai','CAM123','2024-10-16','Camión de carga pesada Hyundai','{\"capacidad\":\"10 toneladas\"}'),
(6,9,2,5,'L3110','IMP123','2024-10-16','Impresora HP L3110','{\"capacidad\":\"200 kilogramos\"}'),
(7,1,2,1,'LG UltraGear','LG-001','2023-01-15','Monitor para gaming','{\"resolucion\": \"2560x1440\", \"tasa_de_refresco\": \"144Hz\"}'),
(8,2,2,1,'HP Pavilion','HP-002','2023-02-20','Laptop para uso diario','{\"procesador\": \"Intel i5\", \"ram\": \"8GB\"}'),
(9,3,5,1,'Caterpillar 320','CAT-003','2023-03-10','Maquinaria pesada','{\"potencia\": \"150HP\", \"peso\": \"20ton\"}'),
(10,4,3,1,'Nissan Frontier','NIS-004','2023-04-05','Camioneta pickup','{\"motor\": \"2.5L\", \"traccion\": \"4x4\"}'),
(11,5,6,1,'Hyundai Generator','HYD-005','2023-05-12','Generador portátil','{\"potencia\": \"3000W\", \"tipo_combustible\": \"Gasolina\"}'),
(12,6,1,1,'HP LaserJet','HP-006','2023-06-18','Impresora láser','{\"tipo\": \"monocromo\", \"velocidad\": \"30ppm\"}'),
(13,7,1,1,'LG Gram','LG-007','2023-07-22','Laptop ultraligera','{\"peso\": \"999g\", \"pantalla\": \"14in\"}'),
(14,8,4,1,'ABB Robot IRB','ABB-008','2023-08-15','Robot industrial','{\"carga_util\": \"10kg\", \"alcance\": \"1.5m\"}'),
(15,9,7,1,'FenWick Forklift','FW-009','2023-09-10','Montacargas eléctrico','{\"capacidad_carga\": \"2000kg\", \"batería\": \"24V\"}');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos_responsables` */

insert  into `activos_responsables`(`idactivo_resp`,`idactivo`,`idusuario`,`es_responsable`,`fecha_asignacion`,`fecha_designacion`,`condicion_equipo`,`imagenes`,`descripcion`,`autorizacion`,`solicitud`) values 
(1,1,2,'0','2024-10-16',NULL,'En perfectas condiciones','{\"imagen1\":\"http://nose/que/poner\"}','equipo de trabajo',1,1),
(2,1,8,'0','2024-10-16',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/lg_ultragear.jpg\"}','Asignación a usuario',6,1),
(3,2,9,'0','2024-10-16',NULL,'Este activo esta sin problemas','{\"imagen1\":\"https://ejemplo.com/imagenes/hp_pavilion.jpg\"}','Uso diario',1,1),
(4,3,10,'0','2024-10-16',NULL,'En buenas condiciones','{\"imagen1\":\"https://ejemplo.com/imagenes/caterpillar_320.jpg\"}','Asignación a proyecto',8,1),
(5,4,11,'0','2024-10-16',NULL,'Tienes fallos en el motor','{\"imagen1\":\"https://ejemplo.com/imagenes/nissan_frontier.jpg\"}','Camioneta de trabajo',14,1),
(6,5,12,'0','2024-10-16',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/hyundai_generator.jpg\"}','Generador de respaldo',12,1),
(7,6,13,'0','2024-10-16',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/hp_laserjet.jpg\"}','Impresión de documentos',8,1),
(8,7,14,'0','2024-10-16',NULL,'Usado','{\"imagen1\":\"https://ejemplo.com/imagenes/lg_gram.jpg\"}','Laptop para administración',10,1),
(9,8,15,'0','2024-10-16',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/abb_robot_irb.jpg\"}','Robot para automatización',14,1),
(10,9,8,'0','2024-10-16',NULL,'Usado','{\"imagen1\":\"https://ejemplo.com/imagenes/fenwick_forklift.jpg\"}','Montacargas para logística',14,1);

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `activos_vinculados_tarea` */

insert  into `activos_vinculados_tarea`(`idactivo_vinculado`,`idtarea`,`idactivo`,`create_at`,`update_at`) values 
(1,1,5,'2024-10-16 14:35:53',NULL);

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
(3,'Equipo de Produccion'),
(2,'Equipo Pesado'),
(1,'Tecnologia'),
(4,'Transporte');

/*Table structure for table `detalle_odt` */

DROP TABLE IF EXISTS `detalle_odt`;

CREATE TABLE `detalle_odt` (
  `iddetalleodt` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `fecha_inicial` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_final` datetime DEFAULT NULL,
  `tiempo_ejecucion` time DEFAULT NULL,
  `clasificacion` int(11) DEFAULT NULL,
  PRIMARY KEY (`iddetalleodt`),
  KEY `fk_orden_trabajo2` (`idorden_trabajo`),
  KEY `fk_clasificacion` (`clasificacion`),
  CONSTRAINT `fk_clasificacion` FOREIGN KEY (`clasificacion`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_orden_trabajo2` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detalle_odt` */

/*Table structure for table `diagnosticos` */

DROP TABLE IF EXISTS `diagnosticos`;

CREATE TABLE `diagnosticos` (
  `iddiagnostico` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `idtipo_diagnostico` int(11) NOT NULL,
  `diagnostico` varchar(300) NOT NULL,
  PRIMARY KEY (`iddiagnostico`),
  KEY `fk_idorden_trabajo3` (`idorden_trabajo`),
  KEY `fk_idtipo_diagnostico` (`idtipo_diagnostico`),
  CONSTRAINT `fk_idorden_trabajo3` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE,
  CONSTRAINT `fk_idtipo_diagnostico` FOREIGN KEY (`idtipo_diagnostico`) REFERENCES `tipo_diagnosticos` (`idtipo_diagnostico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `diagnosticos` */

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
  `evidencia` blob NOT NULL,
  PRIMARY KEY (`idevidencias_diagnostico`),
  KEY `fk_iddiagnostico` (`iddiagnostico`),
  CONSTRAINT `fk_iddiagnostico` FOREIGN KEY (`iddiagnostico`) REFERENCES `diagnosticos` (`iddiagnostico`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `evidencias_diagnostico` */

/*Table structure for table `historial_activos` */

DROP TABLE IF EXISTS `historial_activos`;

CREATE TABLE `historial_activos` (
  `idhistorial_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo_resp` int(11) NOT NULL,
  `idubicacion` int(11) NOT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idhistorial_activo`),
  KEY `fk_idactivo_resp` (`idactivo_resp`),
  KEY `fk_idubicacion` (`idubicacion`),
  CONSTRAINT `fk_idactivo_resp` FOREIGN KEY (`idactivo_resp`) REFERENCES `activos_responsables` (`idactivo_resp`),
  CONSTRAINT `fk_idubicacion` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_activos` */

insert  into `historial_activos`(`idhistorial_activo`,`idactivo_resp`,`idubicacion`,`fecha_movimiento`) values 
(1,1,1,'2024-10-16 14:35:53'),
(2,2,3,'2024-10-16 18:07:39'),
(3,3,2,'2024-10-16 18:07:39'),
(4,4,1,'2024-10-16 18:07:39'),
(5,5,4,'2024-10-16 18:07:39'),
(6,6,2,'2024-10-16 18:07:39'),
(7,7,3,'2024-10-16 18:07:39'),
(8,8,4,'2024-10-16 18:07:39'),
(9,9,5,'2024-10-16 18:07:39'),
(10,10,2,'2024-10-16 18:07:39');

/*Table structure for table `historial_estado_odt` */

DROP TABLE IF EXISTS `historial_estado_odt`;

CREATE TABLE `historial_estado_odt` (
  `idhistorial` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `estado_anterior` int(11) DEFAULT NULL,
  `estado_nuevo` int(11) NOT NULL,
  `comentario` text DEFAULT NULL,
  `fecha_cambio` datetime DEFAULT current_timestamp(),
  `devuelto` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`idhistorial`),
  KEY `fk_idorden_trabajo` (`idorden_trabajo`),
  KEY `fk_idestado5` (`estado_anterior`),
  KEY `fk_idestado6` (`estado_nuevo`),
  CONSTRAINT `fk_idestado5` FOREIGN KEY (`estado_anterior`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_idestado6` FOREIGN KEY (`estado_nuevo`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_idorden_trabajo` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_estado_odt` */

/*Table structure for table `marcas` */

DROP TABLE IF EXISTS `marcas`;

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL AUTO_INCREMENT,
  `marca` varchar(80) NOT NULL,
  PRIMARY KEY (`idmarca`),
  UNIQUE KEY `uk_marca` (`marca`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `marcas` */

insert  into `marcas`(`idmarca`,`marca`) values 
(8,'ABB'),
(4,'Caterpillar'),
(5,'Einhell'),
(7,'FenWick'),
(2,'HP'),
(6,'Hyundai'),
(1,'LG'),
(3,'Nissan');

/*Table structure for table `notificaciones` */

DROP TABLE IF EXISTS `notificaciones`;

CREATE TABLE `notificaciones` (
  `idnotificacion` int(11) NOT NULL AUTO_INCREMENT,
  `idusuario` int(11) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `mensaje` varchar(400) NOT NULL,
  `estado` enum('no leido','leido') NOT NULL DEFAULT 'no leido',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idnotificacion`),
  KEY `fk_idusuario_notif` (`idusuario`),
  CONSTRAINT `fk_idusuario_notif` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `notificaciones` */

/*Table structure for table `odt` */

DROP TABLE IF EXISTS `odt`;

CREATE TABLE `odt` (
  `idorden_trabajo` int(11) NOT NULL AUTO_INCREMENT,
  `idtarea` int(11) NOT NULL,
  `creado_por` int(11) NOT NULL,
  `idestado` int(11) DEFAULT 2,
  `borrador` tinyint(1) DEFAULT 1,
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
  UNIQUE KEY `uk_telefono` (`telefono`),
  UNIQUE KEY `uk_num_doc` (`num_doc`),
  KEY `fk_idtipodoc` (`idtipodoc`),
  CONSTRAINT `fk_idtipodoc` FOREIGN KEY (`idtipodoc`) REFERENCES `tipo_doc` (`idtipodoc`),
  CONSTRAINT `chk_genero` CHECK (`genero` in ('M','F'))
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `personas` */

insert  into `personas`(`id_persona`,`idtipodoc`,`num_doc`,`apellidos`,`nombres`,`genero`,`telefono`) values 
(1,1,'12345678','González','Juan','M','987654321'),
(2,2,'A1234567','Smith','Anna','F','987654322'),
(3,2,'EX123456','Martínez','Carlos','M','987654323'),
(4,1,'35255456','Ortiz Huaman','Pablo','M','928483244'),
(5,1,'72754752','Avalos Romero','Royer Alexis','M','936439633'),
(6,1,'72754751','Avalos Romero','Pedro Aldair','M','995213305'),
(7,1,'24232423','López','Manuela','F','924723647'),
(16,1,'36436772','García','Juan','M','555-1234'),
(17,2,'87654321','Pérez','Ana','F','555-5678'),
(18,1,'23456789','López','Carlos','M','555-9101'),
(19,2,'98765432','Martínez','Laura','F','555-1122'),
(20,1,'34567890','Sánchez','Pedro','M','555-1314'),
(21,2,'65432109','Ramírez','Marta','F','555-1516'),
(22,1,'45678901','Torres','Jorge','M','555-1718'),
(23,2,'54321098','Hernández','Lucía','F','555-1920'),
(24,1,'28742343','Lopez Nonoez','Andrea','F','982734234'),
(25,1,'86742333','Valares Diaz','Julian','M','967274234'),
(26,1,'32432334','Gonzalez','Joel','M',NULL);

/*Table structure for table `plandetareas` */

DROP TABLE IF EXISTS `plandetareas`;

CREATE TABLE `plandetareas` (
  `idplantarea` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(80) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idplantarea`),
  UNIQUE KEY `uk_descripcion_plan` (`descripcion`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `plandetareas` */

insert  into `plandetareas`(`idplantarea`,`descripcion`,`create_at`,`update_at`) values 
(1,'mantenimiento de impresora','2024-10-16 14:35:53',NULL);

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
(1,2,1,'2024-10-16','pendiente','Para el proyecto X',1,NULL,NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `subcategorias` */

insert  into `subcategorias`(`idsubcategoria`,`idcategoria`,`subcategoria`) values 
(1,1,'Computadora'),
(2,1,'Laptop'),
(3,2,'Maquinaria Industrial'),
(4,2,'Generador'),
(5,4,'Auto'),
(6,4,'Camioneta'),
(7,3,'Equipo de Fabricacion'),
(8,3,'Robot Industrial'),
(9,1,'Impresora'),
(10,1,'Monitor'),
(11,1,'Teclado');

/*Table structure for table `tareas` */

DROP TABLE IF EXISTS `tareas`;

CREATE TABLE `tareas` (
  `idtarea` int(11) NOT NULL AUTO_INCREMENT,
  `idplantarea` int(11) NOT NULL,
  `idtipo_prioridad` int(11) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_vencimiento` datetime NOT NULL,
  `cant_intervalo` int(11) NOT NULL,
  `frecuencia` varchar(10) NOT NULL,
  `idestado` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idtarea`),
  UNIQUE KEY `fk_descripcion_tarea` (`descripcion`),
  KEY `fk_idplantarea` (`idplantarea`),
  KEY `fk_idtipo_prioridad` (`idtipo_prioridad`),
  KEY `fk_idestado2` (`idestado`),
  CONSTRAINT `fk_idestado2` FOREIGN KEY (`idestado`) REFERENCES `estados` (`idestado`),
  CONSTRAINT `fk_idplantarea` FOREIGN KEY (`idplantarea`) REFERENCES `plandetareas` (`idplantarea`) ON DELETE CASCADE,
  CONSTRAINT `fk_idtipo_prioridad` FOREIGN KEY (`idtipo_prioridad`) REFERENCES `tipo_prioridades` (`idtipo_prioridad`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tareas` */

insert  into `tareas`(`idtarea`,`idplantarea`,`idtipo_prioridad`,`descripcion`,`fecha_inicio`,`fecha_vencimiento`,`cant_intervalo`,`frecuencia`,`idestado`,`create_at`,`update_at`) values 
(1,1,3,'llenado de tinta color rojo','0000-00-00 00:00:00','0000-00-00 00:00:00',1,'mensual',1,'2024-10-16 14:35:53',NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `ubicaciones` */

insert  into `ubicaciones`(`idubicacion`,`ubicacion`) values 
(1,'lugar 1'),
(2,'lugar 2'),
(3,'lugar 3'),
(4,'lugar 4'),
(5,'lugar 5');

/*Table structure for table `usuarios` */

DROP TABLE IF EXISTS `usuarios`;

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `idpersona` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `usuario` varchar(120) NOT NULL,
  `contrasena` varchar(120) NOT NULL,
  `estado` char(1) DEFAULT '1',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_idpersonaUser` (`idpersona`,`usuario`),
  KEY `fk_rol` (`idrol`),
  CONSTRAINT `fk_persona` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`id_persona`),
  CONSTRAINT `fk_rol` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `usuarios` */

insert  into `usuarios`(`id_usuario`,`idpersona`,`idrol`,`usuario`,`contrasena`,`estado`) values 
(1,1,1,'j.gonzalez','$2y$10$TpMmHZcum7YJqXOqTrsDy.WheLpUnU98OZjc4WqLgPke9HlX6ZaJS','1'),
(2,2,2,'a.smith','$2y$10$HdD325QAWm7QpH7KXtRdROBKe39KwDQr6l4K83u2a0w5h/d6yNgau','1'),
(3,3,2,'c.martinez','$2y$10$x45pTq2wG/jFtZkOPhvsMe9hReDbWqjo7sv5U37MTL2g10BglS4jG','1'),
(4,4,2,'pablo35a','$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO','1'),
(5,4,2,'r.avalos','$2y$10$VrxeMCQteaNdX6LwxoZEYevp8BCwKTpIKTVebChbXcxnNX7BTIFaW','1'),
(6,5,1,'p.avalos','$2y$10$j1KccY6Iex7h19WR0pfMpumhp.dsjJkBCcFUbtVwbPCHw7hECJNyW','1'),
(7,7,2,'manuelaL','$2y$10$N/fJ6vi73q6jINKfOcz71e0d/HpC0EhkL5Pqw4KwH2AscAX2G/L6u','1'),
(8,16,1,'garcia.juan','contrasena1','1'),
(9,17,2,'perez.ana','contrasena2','1'),
(10,18,1,'lopez.carlos','contrasena3','1'),
(11,19,2,'martinez.laura','contrasena4','1'),
(12,20,1,'sanchez.pedro','contrasena5','1'),
(13,21,2,'ramirez.marta','contrasena6','1'),
(14,22,1,'torres.jorge','contrasena7','1'),
(15,23,2,'hernandez.lucia','contrasena8','1'),
(16,24,1,'andreaBTS','$2y$10$b0jhCsgzy8s14q6g.zZQ/OGzQGwJVqvQBrPhB.WLiK/77a60QXTHu','1'),
(17,25,1,'julianV','$2y$10$tMndXYFd4w81.vC3l1iP8.YQMPDyKdQwlewBKa5HiLISk4K7r0Ki6','1'),
(18,26,2,'joel33','$2y$10$eRbOkniRKCYi2LCMaJZjJuQsGukOQv0Jt/UOPnFPD1jOXvrWeiLQS','1');

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

/* Procedure structure for procedure `actualizarPlanDeTareas` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarPlanDeTareas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarPlanDeTareas`(
    IN _idplantarea INT, 
    IN _descripcion VARCHAR(80),
    IN _borrador BOOLEAN)
BEGIN
    UPDATE plandetareas 
    SET descripcion = _descripcion,
		borrador = _borrador, 
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
    IN _fecha_inicio DATETIME,
    IN _fecha_vencimiento DATETIME, 
    IN _cant_intervalo INT, 
    IN _frecuencia VARCHAR(10), 
    IN _idestado INT)
BEGIN
    UPDATE tareas 
    SET 
		idtipo_prioridad = _idtipo_prioridad,
		descripcion = _descripcion,
        fecha_inicio = _fecha_inicio,
        fecha_vencimiento = _fecha_vencimiento,
        cant_intervalo = _cant_intervalo, 
        frecuencia = _frecuencia,
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
    IN _idestado INT
)
BEGIN
	UPDATE tareas 
    SET idestado = _idestado,
        update_at = NOW()
    WHERE idtarea = _idtarea;
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

/* Procedure structure for procedure `eliminarPlanDeTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `eliminarPlanDeTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarPlanDeTarea`(
	IN _idplantarea INT
    -- IN _eliminado BOOLEAN
)
BEGIN
	DELETE FROM plandetareas WHERE idplantarea = _idplantarea;
   -- UPDATE plandetareas 
   -- SET 
	-- eliminado = _eliminado,
     --   update_at = NOW()
    -- WHERE idplantarea = _idplantarea;
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
	IN _descripcion VARCHAR(30)
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO plandetareas (descripcion)
    VALUES (_descripcion);
    
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
    IN _fecha_inicio DATETIME,
    IN _fecha_vencimiento DATETIME,
    IN _cant_intervalo INT,
    IN _frecuencia VARCHAR(10),
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
        idplantarea, idtipo_prioridad, descripcion,
        fecha_inicio, fecha_vencimiento, cant_intervalo, frecuencia, idestado
    )
    VALUES (
        _idplantarea, _idtipo_prioridad, _descripcion,
        _fecha_inicio, _fecha_vencimiento, _cant_intervalo, _frecuencia, _idestado
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
    a.descripcion
  FROM
    plandetareas pt
    INNER JOIN tareas t ON pt.idplantarea = t.idplantarea
    INNER JOIN activos_vinculados_tarea avt ON t.idtarea = avt.idtarea
    INNER JOIN activos a ON avt.idactivo = a.idactivo
  WHERE
    pt.idplantarea = p_idplantarea;
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
	SELECT ACTV.idactivo_vinculado, SCAT.subcategoria, MAR.marca, ACT.modelo FROM activos_vinculados_tarea ACTV
    INNER JOIN activos ACT ON ACTV.idactivo = ACT.idactivo
    INNER JOIN subcategorias SCAT ON ACT.idsubcategoria = SCAT.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE ACTV.idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerPlantareasDetalles` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerPlantareasDetalles` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerPlantareasDetalles`()
BEGIN 
SELECT PT.idplantarea, 
       PT.descripcion, 
       COUNT(DISTINCT TAR.idtarea) AS tareas_totales, 
       COUNT(DISTINCT AV.idactivo_vinculado) AS activos_vinculados
       FROM plandetareas PT
LEFT JOIN tareas TAR ON TAR.idplantarea = PT.idplantarea
LEFT JOIN activos_vinculados_tarea AV ON AV.idtarea = TAR.idtarea
GROUP BY PT.idplantarea, PT.descripcion
ORDER BY PT.idplantarea DESC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareaPorId` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareaPorId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareaPorId`(IN _idtarea INT)
BEGIN
	SELECT * FROM tareas WHERE idtarea = _idtarea;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasPorPlanTarea` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasPorPlanTarea` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasPorPlanTarea`(IN _idplantarea INT)
BEGIN
	SELECT TAR.idtarea, PT.descripcion as plan_tarea, TP.tipo_prioridad, TAR.descripcion, TAR.cant_intervalo, TAR.frecuencia ,ES.nom_estado FROM tareas TAR
    INNER JOIN plandetareas PT ON TAR.idplantarea = PT.idplantarea -- quitar esta linea luego pq no es necesario mostrar el plan de tareas al que pertenece
    INNER JOIN tipo_prioridades TP ON TAR.idtipo_prioridad = TP.idtipo_prioridad
    INNER JOIN estados ES ON TAR.idestado = ES.idestado
    WHERE TAR.idplantarea = _idplantarea ORDER BY TAR.idtarea DESC;
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
    IN _idestado INT
)
BEGIN
	SELECT
		ACT.idactivo,
        ACT.fecha_adquisicion,
        ACT.cod_identificacion,
        ACT.descripcion,
        (SELECT CONCAT(U.usuario,'|', P.apellidos, ' ', P.nombres) FROM usuarios U
        INNER JOIN personas P ON u.idpersona = P.id_persona WHERE
        U.id_usuario = RES.idusuario AND RES.es_responsable='1') as dato,
        UBI.ubicacion
	FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    RIGHT JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN estados EST ON ACT.idestado = EST.idestado
    AND (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
    AND (EST.idestado = _idestado OR _idestado IS NULL)
    WHERE EST.idestado >1 AND EST.idestado<5 AND EST.idestado !=4;
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

/* Procedure structure for procedure `sp_add_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_notificacion`(
	IN _idusuario INT,
    IN _tipo	VARCHAR(20),
	IN _mensaje VARCHAR(400)
)
BEGIN
	INSERT INTO notificaciones (idusuario, tipo, mensaje) VALUES
	 (_idusuario, _tipo, _mensaje);
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

/* Procedure structure for procedure `sp_detalle_notificacion` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_notificacion` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_notificacion`(
	IN _idnotificacion INT
)
BEGIN
	SELECT
		NOF.mensaje,
        NOF.fecha_creacion,
        NOF.tipo,
        ACT.descripcion,
        MAR.marca,
        ACT.modelo,
        ACT.cod_identificacion,
        RES.condicion_equipo,
        RES.fecha_asignacion,
        UBI.ubicacion
        FROM notificaciones NOF
        LEFT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
        LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
        LEFT JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
        LEFT JOIN historial_activos HIS ON RES.idactivo_resp = HIS.idactivo_resp
        LEFT JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
        WHERE NOF.idnotificacion = _idnotificacion;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_detalle_sol_estado` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_sol_estado` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_sol_estado`(
	IN _idsolicitud INT
)
BEGIN
	SELECT
		SOL.estado_solicitud,
        SOL.fecha_solicitud,
        ACT.cod_identificacion,
		SUB.subcategoria,
        MAR.marca,
        ACT.descripcion,
        SOL.coment_autorizador
	FROM solicitudes_activos SOL
    INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE (SOL.estado_solicitud='rechazado' OR SOL.estado_solicitud='pendiente') AND
    SOL.idsolicitud=_idsolicitud;
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

/* Procedure structure for procedure `sp_getUser_by_id` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_getUser_by_id` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getUser_by_id`(
	IN _idusuario INT
)
BEGIN
	SELECT U.usuario, CONCAT(P.apellidos, ' ', P.nombres) as dato 
    FROM usuarios U
    INNER JOIN personas P ON U.idpersona = P.id_persona
    WHERE id_usuario = _idusuario;
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
    AND (ACT.fecha_adquisicion = _fecha_adquisicion OR _fecha_adquisicion IS NULL)
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
		NOF.idnotificacion,
		NOF.tipo,
        NOF.estado,
		NOF.mensaje,
        NOF.fecha_creacion,
        RES.descripcion desresp,
        ACT.descripcion
    FROM notificaciones NOF
    LEFT JOIN activos_responsables RES ON NOF.idusuario = RES.idusuario
    LEFT JOIN activos ACT ON RES.idactivo = ACT.idactivo
    WHERE NOF.idusuario = _idusuario
    ORDER BY NOF.fecha_creacion DESC;
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
        P.num_doc,
        P.telefono,
        P.genero
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    WHERE (R.idrol = _idrol OR _idrol IS NULL) 
    AND (U.estado = _estado OR _estado IS NULL) 
    AND (TD.idtipodoc=_idtipodoc OR _idtipodoc IS NULL)
    AND (P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_resp_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_resp_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_resp_activo`(

)
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
		WHERE idactivo = _idactivo AND es_responsable = 0;
    END IF;
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
    WHERE idactivo=_idactivo AND idusuario = _idusuario;
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

/* Procedure structure for procedure `sp_search_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo`(
	IN _descripcion VARCHAR(40)
)
BEGIN
	SELECT ACT.idactivo, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.descripcion LIKE CONCAT('%', _descripcion,'%') AND ACT.idestado!=4 
	ORDER BY SUB.subcategoria ASC;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_activo_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_activo_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_activo_resp`(
	IN _descripcion VARCHAR(40)
)
BEGIN
	SELECT DISTINCT ACT.idactivo, ACT.descripcion, SUB.subcategoria
	FROM activos ACT
    INNER JOIN activos_responsables RES ON ACT.idactivo = RES.idactivo
	INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	WHERE ACT.descripcion LIKE CONCAT('%', _descripcion,'%') AND ACT.idestado!=4 
	ORDER BY SUB.subcategoria ASC;
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
	  MAX(UBI.ubicacion) ubicacion,
	  EST.nom_estado,
      RES.autorizacion
	FROM activos_responsables RES
	INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
	INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN subcategorias SUB ON ACT.idsubcategoria = SUB.idsubcategoria
	INNER JOIN estados EST ON ACT.idestado = EST.idestado
	INNER JOIN (
		SELECT H.idactivo_resp, MAX(H.idubicacion) AS idubicacion
		FROM historial_activos H
		GROUP BY H.idactivo_resp
    )HIS ON HIS.idactivo_resp = RES.idactivo_resp
	INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    WHERE (SUB.idsubcategoria = _idsubcategoria OR _idsubcategoria IS NULL) AND
    (UBI.idubicacion = _idubicacion OR _idubicacion IS NULL) AND
    (ACT.cod_identificacion LIKE CONCAT('%', _cod_identificacion, '%') OR _cod_identificacion IS NULL) AND ACT.idestado=1
    GROUP BY ACT.idactivo
    ORDER BY RES.fecha_asignacion DESC;
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
WHERE R.idusuario = RES.idusuario) as cantidad,
        USU.estado
	FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    INNER JOIN roles ROL ON USU.idrol = ROL.idrol
    WHERE RES.idactivo = _idactivo;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_search_resp` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_resp` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_resp`(
	IN _idactivo_resp INT
)
BEGIN
	SELECT * FROM v_activo_resp WHERE idactivo_resp=_idactivo_resp;
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
		ACT.idactivo,
        ACT.idsubcategoria,
        CAT.categoria,
        ACT.idmarca,
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
	IN _idactivo INT
)
BEGIN
	SELECT DISTINCT UBI.idubicacion, UBI.ubicacion FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    WHERE RES.idactivo = _idactivo;
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
	USU.usuario,
    PER.apellidos,
    RES.fecha_asignacion,
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo;
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

/*Table structure for table `v_activo_resp` */

DROP TABLE IF EXISTS `v_activo_resp`;

/*!50001 DROP VIEW IF EXISTS `v_activo_resp` */;
/*!50001 DROP TABLE IF EXISTS `v_activo_resp` */;

/*!50001 CREATE TABLE  `v_activo_resp`(
 `idactivo_resp` int(11) ,
 `idactivo` int(11) ,
 `cod_identificacion` char(40) ,
 `descripcion` varchar(200) ,
 `subcategoria` varchar(60) ,
 `modelo` varchar(60) ,
 `marca` varchar(80) ,
 `ubicacion` varchar(60) ,
 `fecha_adquisicion` date ,
 `condicion_equipo` varchar(500) ,
 `nom_estado` varchar(50) ,
 `autorizacion` int(11) ,
 `despresp` varchar(500) ,
 `especificaciones` longtext ,
 `imagenes` longtext 
)*/;

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

/*View structure for view v_activo_resp */

/*!50001 DROP TABLE IF EXISTS `v_activo_resp` */;
/*!50001 DROP VIEW IF EXISTS `v_activo_resp` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_activo_resp` AS select `res`.`idactivo_resp` AS `idactivo_resp`,`act`.`idactivo` AS `idactivo`,`act`.`cod_identificacion` AS `cod_identificacion`,`act`.`descripcion` AS `descripcion`,`sub`.`subcategoria` AS `subcategoria`,`act`.`modelo` AS `modelo`,`mar`.`marca` AS `marca`,max(`ubi`.`ubicacion`) AS `ubicacion`,`act`.`fecha_adquisicion` AS `fecha_adquisicion`,max(`res`.`condicion_equipo`) AS `condicion_equipo`,`est`.`nom_estado` AS `nom_estado`,`res`.`autorizacion` AS `autorizacion`,`res`.`descripcion` AS `despresp`,`act`.`especificaciones` AS `especificaciones`,max(`res`.`imagenes`) AS `imagenes` from (((((((`activos_responsables` `res` join `activos` `act` on(`res`.`idactivo` = `act`.`idactivo`)) join `marcas` `mar` on(`act`.`idmarca` = `mar`.`idmarca`)) join `usuarios` `usu` on(`res`.`idusuario` = `usu`.`id_usuario`)) join `subcategorias` `sub` on(`act`.`idsubcategoria` = `sub`.`idsubcategoria`)) join `estados` `est` on(`act`.`idestado` = `est`.`idestado`)) join (select `h`.`idactivo_resp` AS `idactivo_resp`,max(`h`.`idubicacion`) AS `idubicacion` from `historial_activos` `h` group by `h`.`idactivo_resp`) `his` on(`his`.`idactivo_resp` = `res`.`idactivo_resp`)) join `ubicaciones` `ubi` on(`his`.`idubicacion` = `ubi`.`idubicacion`)) where `act`.`idestado` = 1 group by `act`.`idactivo` order by `res`.`fecha_asignacion` desc */;

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
