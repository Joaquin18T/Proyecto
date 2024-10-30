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
(1,2,1,1,'14-EP','123ABC','2024-10-30','Laptop 14-EP 16 RAM','{\"ram\":\"16GB\", \"disco\":\"solido\"}'),
(2,10,1,1,'Monitor 4K','MON123','2024-10-30','Monitor LG de 27 pulgadas','{\"resolucion\":\"3840x2160\"}'),
(3,11,2,1,'Teclado Mecánico','TEC123','2024-10-30','Teclado mecánico HP','{\"tipo\":\"mecánico\", \"conectividad\":\"inalámbrico\"}'),
(4,7,4,1,'Compresor Industrial','COMP123','2024-10-30','Compresor Caterpillar de 10HP','{\"potencia\":\"10HP\"}'),
(5,6,5,1,'Camión de Carga Hyundai','CAM123','2024-10-30','Camión de carga pesada Hyundai','{\"capacidad\":\"10 toneladas\"}'),
(6,9,2,1,'L3110','IMP123','2024-10-30','Impresora HP L3110','{\"capacidad\":\"200 kilogramos\"}'),
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
(1,1,2,'0','2024-10-30',NULL,'En perfectas condiciones','{\"imagen1\":\"http://nose/que/poner\"}','equipo de trabajo',1,1),
(2,1,3,'0','2024-10-30',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/lg_ultragear.jpg\"}','Asignación a usuario',6,1),
(3,2,4,'0','2024-10-30',NULL,'Este activo esta sin problemas','{\"imagen1\":\"https://ejemplo.com/imagenes/hp_pavilion.jpg\"}','Uso diario',1,1),
(4,3,5,'0','2024-10-30',NULL,'En buenas condiciones','{\"imagen1\":\"https://ejemplo.com/imagenes/caterpillar_320.jpg\"}','Asignación a proyecto',8,1),
(5,4,6,'0','2024-10-30',NULL,'Tienes fallos en el motor','{\"imagen1\":\"https://ejemplo.com/imagenes/nissan_frontier.jpg\"}','Camioneta de trabajo',14,1),
(6,5,7,'0','2024-10-30',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/hyundai_generator.jpg\"}','Generador de respaldo',12,1),
(7,6,8,'0','2024-10-30',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/hp_laserjet.jpg\"}','Impresión de documentos',8,1),
(8,7,9,'0','2024-10-30',NULL,'Usado','{\"imagen1\":\"https://ejemplo.com/imagenes/lg_gram.jpg\"}','Laptop para administración',10,1),
(9,8,10,'0','2024-10-30',NULL,'Nuevo','{\"imagen1\":\"https://ejemplo.com/imagenes/abb_robot_irb.jpg\"}','Robot para automatización',14,1),
(10,9,11,'0','2024-10-30',NULL,'Usado','{\"imagen1\":\"https://ejemplo.com/imagenes/fenwick_forklift.jpg\"}','Montacargas para logística',14,1);

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
(3,'Equipo de Produccion'),
(2,'Equipo Pesado'),
(1,'Tecnologia'),
(4,'Transporte');

/*Table structure for table `comentarios_odt` */

DROP TABLE IF EXISTS `comentarios_odt`;

CREATE TABLE `comentarios_odt` (
  `idcomentario` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  `comentario` varchar(300) DEFAULT NULL,
  `revisadoPor` int(11) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detalles_marca_subcategoria` */

insert  into `detalles_marca_subcategoria`(`iddetalle_marca_sub`,`idmarca`,`idsubcategoria`) values 
(1,1,1),
(2,1,2),
(3,2,2),
(4,4,3),
(5,7,3),
(6,5,4),
(7,6,5),
(8,3,5),
(9,6,6),
(10,3,6),
(11,4,7),
(12,8,8),
(13,2,9),
(14,1,10),
(15,1,11);

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

/*Table structure for table `historial_activos` */

DROP TABLE IF EXISTS `historial_activos`;

CREATE TABLE `historial_activos` (
  `idhistorial_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo_resp` int(11) DEFAULT NULL,
  `idubicacion` int(11) NOT NULL,
  `accion` varchar(30) DEFAULT NULL,
  `responsable_accion` int(11) DEFAULT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`idhistorial_activo`),
  KEY `fk_idactivo_resp` (`idactivo_resp`),
  KEY `fk_idubicacion` (`idubicacion`),
  KEY `fk_usuario_his` (`responsable_accion`),
  CONSTRAINT `fk_idactivo_resp` FOREIGN KEY (`idactivo_resp`) REFERENCES `activos_responsables` (`idactivo_resp`),
  CONSTRAINT `fk_idubicacion` FOREIGN KEY (`idubicacion`) REFERENCES `ubicaciones` (`idubicacion`),
  CONSTRAINT `fk_usuario_his` FOREIGN KEY (`responsable_accion`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_activos` */

insert  into `historial_activos`(`idhistorial_activo`,`idactivo_resp`,`idubicacion`,`accion`,`responsable_accion`,`fecha_movimiento`) values 
(1,2,3,NULL,NULL,'2024-10-30 14:38:21'),
(2,3,2,NULL,NULL,'2024-10-30 14:38:21'),
(3,4,1,NULL,NULL,'2024-10-30 14:38:21'),
(4,5,4,NULL,NULL,'2024-10-30 14:38:21'),
(5,6,2,NULL,NULL,'2024-10-30 14:38:21'),
(6,7,3,NULL,NULL,'2024-10-30 14:38:21'),
(7,8,4,NULL,NULL,'2024-10-30 14:38:21'),
(8,9,5,NULL,NULL,'2024-10-30 14:38:21'),
(9,10,2,NULL,NULL,'2024-10-30 14:38:21');

/*Table structure for table `historial_odt` */

DROP TABLE IF EXISTS `historial_odt`;

CREATE TABLE `historial_odt` (
  `idhistorial` int(11) NOT NULL AUTO_INCREMENT,
  `idorden_trabajo` int(11) NOT NULL,
  PRIMARY KEY (`idhistorial`),
  KEY `fk_idodt_hist` (`idorden_trabajo`),
  CONSTRAINT `fk_idodt_hist` FOREIGN KEY (`idorden_trabajo`) REFERENCES `odt` (`idorden_trabajo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `historial_odt` */

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

/*Table structure for table `notificaciones_activos` */

DROP TABLE IF EXISTS `notificaciones_activos`;

CREATE TABLE `notificaciones_activos` (
  `idnotificacion_activo` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo_resp` int(11) DEFAULT NULL,
  `tipo` varchar(30) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `notificaciones_activos` */

/*Table structure for table `notificaciones_mantenimiento` */

DROP TABLE IF EXISTS `notificaciones_mantenimiento`;

CREATE TABLE `notificaciones_mantenimiento` (
  `idnotificacion_mantenimiento` int(11) NOT NULL AUTO_INCREMENT,
  `idactivo` int(11) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `mensaje` varchar(250) NOT NULL,
  `fecha_programada` date NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) NOT NULL,
  `visto` char(1) NOT NULL,
  PRIMARY KEY (`idnotificacion_mantenimiento`),
  KEY `fk_idactivo_noti_mantenimiento` (`idactivo`),
  CONSTRAINT `fk_idactivo_noti_mantenimiento` FOREIGN KEY (`idactivo`) REFERENCES `activos` (`idactivo`)
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
  `fecha_vencimiento` date NOT NULL,
  `hora_vencimiento` time NOT NULL,
  `idestado` int(11) DEFAULT 9,
  `incompleto` tinyint(1) DEFAULT 1,
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(14,2,'54321098','Hernández','Lucía','F','555-1920');

/*Table structure for table `plandetareas` */

DROP TABLE IF EXISTS `plandetareas`;

CREATE TABLE `plandetareas` (
  `idplantarea` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(80) NOT NULL,
  `incompleto` tinyint(1) DEFAULT 1,
  `eliminado` tinyint(1) DEFAULT 0,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  PRIMARY KEY (`idplantarea`),
  UNIQUE KEY `uk_descripcion_plan` (`descripcion`)
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
(1,2,1,'2024-10-30','pendiente','Para el proyecto X',1,NULL,NULL);

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
  `idestado` int(11) NOT NULL,
  `trabajado` tinyint(1) NOT NULL,
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
(1,'lugar 1'),
(2,'lugar 2'),
(3,'lugar 3'),
(4,'lugar 4'),
(5,'lugar 5'),
(6,'No Definida');

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
(4,4,2,'pablo35a','$2y$10$0xJpbL03XkLI5Zz/lCfyVu6HTYSDKKUpEfLF6BywNTBDJofh9YNlO','1',7),
(5,4,2,'r.avalos','$2y$10$VrxeMCQteaNdX6LwxoZEYevp8BCwKTpIKTVebChbXcxnNX7BTIFaW','1',7),
(6,5,1,'p.avalos','$2y$10$j1KccY6Iex7h19WR0pfMpumhp.dsjJkBCcFUbtVwbPCHw7hECJNyW','1',7),
(7,6,1,'garcia.juan','contrasena1','1',7),
(8,7,2,'perez.ana','contrasena2','1',7),
(9,8,1,'lopez.carlos','contrasena3','1',7),
(10,9,2,'martinez.laura','contrasena4','1',7),
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
    IN _clasificacion INT
)
BEGIN
	UPDATE detalle_odt SET
    fecha_final = _fechafinal,
    tiempo_ejecucion = _tiempoejecucion,
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

/* Procedure structure for procedure `actualizarFechaVencimientoOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `actualizarFechaVencimientoOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizarFechaVencimientoOdt`(
	IN _idodt INT,
    IN _fecha_vencimiento DATE,
    IN _hora_vencimiento TIME
)
BEGIN
	UPDATE odt SET
    fecha_vencimiento = _fecha_vencimiento,
    hora_vencimiento = _hora_vencimiento
    WHERE idorden_trabajo = _idodt;
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
    IN _idestado INT)
BEGIN
    UPDATE tareas 
    SET 
		idtipo_prioridad = _idtipo_prioridad,
		descripcion = _descripcion,
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
	IN _descripcion VARCHAR(30)
)
BEGIN
    DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
	END;
    
    INSERT INTO plandetareas (descripcion, incompleto)
    VALUES (_descripcion, true);
    
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
        idplantarea, idtipo_prioridad, descripcion, idestado
    )
    VALUES (
        _idplantarea, _idtipo_prioridad, _descripcion, _idestado
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
	SELECT ACTV.idactivo_vinculado, ACT.cod_identificacion,ACT.descripcion,ACT.idactivo,SCAT.subcategoria, MAR.marca, ACT.modelo FROM activos_vinculados_tarea ACTV
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

/* Procedure structure for procedure `obtenerEvidenciasDiagnostico` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerEvidenciasDiagnostico` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerEvidenciasDiagnostico`( 
	IN _iddiagnostico INT
)
BEGIN
	SELECT * FROM evidencias_diagnostico WHERE iddiagnostico = _iddiagnostico;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerHistorialOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerHistorialOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerHistorialOdt`()
BEGIN
	SELECT 
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
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento,
        
        EST.nom_estado,
        ODT.incompleto

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
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, ODT.fecha_vencimiento, 
             PERCRE.nombres, PERCRE.apellidos, TAR.idtarea, EST.nom_estado;
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerOdtporId` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerOdtporId` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerOdtporId`( 
    IN _idodt INT
)
BEGIN
	SELECT * FROM odt ODT
    INNER JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    WHERE ODT.idorden_trabajo = _idodt;
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
        incompleto
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
        ODT.hora_inicio,
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento
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
	SELECT * FROM tareas WHERE idtarea = _idtarea;
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
        GROUP_CONCAT(ACT.descripcion SEPARATOR ', ') AS activos, -- Concatenar activos
        TP.tipo_prioridad AS prioridad,
        EST.nom_estado,
        PT.eliminado,
        PT.incompleto
    FROM tareas TAR
    INNER JOIN plandetareas PT ON PT.idplantarea = TAR.idplantarea
    INNER JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    INNER JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    INNER JOIN tipo_prioridades TP ON TP.idtipo_prioridad = TAR.idtipo_prioridad
    INNER JOIN estados EST ON EST.idestado = TAR.idestado
    WHERE PT.eliminado = 0 AND PT.incompleto = 0
    GROUP BY TAR.idtarea; -- Agrupar por tarea
END */$$
DELIMITER ;

/* Procedure structure for procedure `obtenerTareasOdt` */

/*!50003 DROP PROCEDURE IF EXISTS  `obtenerTareasOdt` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerTareasOdt`()
BEGIN
    SELECT 
        ODT.idorden_trabajo,
        GROUP_CONCAT(DISTINCT CONCAT(PERRES.nombres, ' ', PERRES.apellidos) SEPARATOR ', ') AS responsables,
        TAR.descripcion AS tarea,
        ODT.fecha_inicio,
        ODT.fecha_vencimiento,
        ODT.hora_vencimiento,
        CONCAT(PERCRE.nombres, ' ', PERCRE.apellidos) AS creador,
        CONCAT(PERCO.nombres, ' ', PERCO.apellidos) as revisado_por,
        TAR.idtarea AS idtarea,
        GROUP_CONCAT(DISTINCT ACT.descripcion SEPARATOR ', ') AS activos,
        EST.nom_estado,
        ODT.incompleto,
        DODT.clasificacion
    FROM odt ODT
    LEFT JOIN responsables_asignados_odt RA ON RA.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USURES ON USURES.id_usuario = RA.idresponsable
    LEFT JOIN personas PERRES ON PERRES.id_persona = USURES.idpersona
    LEFT JOIN usuarios USUCRE ON USUCRE.id_usuario = ODT.creado_por
    LEFT JOIN personas PERCRE ON PERCRE.id_persona = USUCRE.idpersona
    LEFT JOIN tareas TAR ON TAR.idtarea = ODT.idtarea
    LEFT JOIN activos_vinculados_tarea AVT ON AVT.idtarea = TAR.idtarea
    LEFT JOIN activos ACT ON ACT.idactivo = AVT.idactivo
    LEFT JOIN estados EST ON EST.idestado = ODT.idestado
    LEFT JOIN detalle_odt DODT ON DODT.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN comentarios_odt CO ON CO.idorden_trabajo = ODT.idorden_trabajo
    LEFT JOIN usuarios USUCO ON USUCO.id_usuario = CO.revisadoPor
    LEFT JOIN personas PERCO ON PERCO.id_persona = USUCO.idpersona
    GROUP BY ODT.idorden_trabajo, TAR.descripcion, ODT.fecha_inicio, ODT.fecha_vencimiento, 
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
	SELECT TAR.idtarea, PT.descripcion as plan_tarea, TP.tipo_prioridad, TAR.descripcion ,ES.nom_estado FROM tareas TAR
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
        
	INSERT INTO detalle_odt (idorden_trabajo, clasificacion)	
		VALUES (_idorden_trabajo, _clasificacion);
        
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
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO historial_odt (idorden_trabajo)	
		VALUES (_idorden_trabajo);	
        
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
    IN _hora_inicio	TIME,
    IN _fecha_vencimiento DATE,
    IN _hora_vencimiento	TIME
)
BEGIN
	-- Declaracion de variables
	DECLARE existe_error INT DEFAULT 0;
    
    -- Manejador de excepciones
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		BEGIN
        SET existe_error = 1;
        END;
        
	INSERT INTO odt (idtarea, creado_por, fecha_inicio, hora_inicio, fecha_vencimiento, hora_vencimiento)
		VALUES (_idtarea, _creado_por, _fecha_inicio, _hora_inicio, _fecha_vencimiento, _hora_vencimiento);
        
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
	EST.idestado >1 AND EST.idestado<5;
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

/* Procedure structure for procedure `sp_add_solicitud` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_add_solicitud` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_solicitud`(
	IN _idusuario INT,
    IN _idactivo INT,
    IN _motivo_solicitud VARCHAR(500)
)
BEGIN
	INSERT INTO solicitudes_activos (idusuario, idactivo, motivo_solicitud) VALUES
		(_idusuario, _idactivo, _motivo_solicitud);
	SELECT @@last_insert_id as idsolicitud;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_check_solicitud` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_check_solicitud` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_check_solicitud`(
	IN _idsolicitud INT,
    IN _idactivo INT,
    IN _idusuario INT,
    IN _estado_solicitud ENUM('pendiente', 'aprobado','rechazado'), -- (se elegira el estado si es aprobado o rechazado)
    IN _idautorizador INT,
    IN _coment_autorizador VARCHAR(500)
)
BEGIN
	UPDATE solicitudes_activos SET
    idactivo = _idactivo,
    idusuario = _idusuario,
    estado_solicitud = _estado_solicitud,
    idautorizador = _idautorizador,
    coment_autorizador = _coment_autorizador,
    fecha_respuesta = NOW()
    WHERE idsolicitud = _idsolicitud;
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

/* Procedure structure for procedure `sp_detalle_notificacion_activo` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_detalle_notificacion_activo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_notificacion_activo`(
    IN _idnotificacion_activo INT
)
BEGIN
    SELECT
        ACT.idactivo,
        RES.idactivo_resp,
        ACT.cod_identificacion,
        ACT.descripcion,
        NA.fecha_creacion,
        MAR.marca,
        ACT.modelo,
        RES.condicion_equipo,
        RES.fecha_asignacion,
        UBI.ubicacion
    FROM historial_activos HIS
    INNER JOIN ubicaciones UBI ON HIS.idubicacion = UBI.idubicacion
    INNER JOIN activos_responsables RES ON HIS.idactivo_resp = RES.idactivo_resp
    INNER JOIN notificaciones_activos NA ON RES.idactivo_resp = NA.idactivo_resp
    INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
    INNER JOIN marcas MAR ON ACT.idmarca = MAR.idmarca
    WHERE NA.idnotificacion_activo = _idnotificacion_activo;
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
		U.estado
	FROM usuarios U
    INNER JOIN roles R ON U.idrol = R.idrol
    INNER JOIN personas P ON U.idpersona = P.id_persona
    INNER JOIN tipo_doc TD ON P.idtipodoc = TD.idtipodoc
    AND (P.num_doc LIKE CONCAT('%', _numdoc ,'%') OR _numdoc IS NULL)
    AND (P.apellidos LIKE CONCAT('%', _dato ,'%') OR P.nombres LIKE CONCAT('%', _dato ,'%') OR _dato IS NULL);
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
		NA.idactivo_resp,
		NA.idnotificacion_activo,
		NA.tipo,
		NA.visto,
		NA.mensaje,
		ACT.descripcion as descripcion_activo,
		RES.descripcion
		FROM notificaciones_activos NA
		INNER JOIN activos_responsables RES ON NA.idactivo_resp = RES.idactivo_resp
		INNER JOIN activos ACT ON RES.idactivo = ACT.idactivo
        WHERE RES.idusuario = _idusuario
        ORDER BY NA.fecha_creacion;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_list_pass` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_list_pass` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_list_pass`(
	IN _estado_solicitud ENUM('pendiente','aprobado','rechazado')
)
BEGIN
		SELECT
		SOL.idsolicitud,
		USU.usuario,
        USU.id_usuario,
        ACT.idactivo,
        ACT.modelo,
        ACT.cod_identificacion,
        SOL.fecha_solicitud,
        SOL.estado_solicitud
        FROM solicitudes_activos SOL
        INNER JOIN usuarios USU ON SOL.idusuario = USU.id_usuario
        INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
        WHERE SOL.estado_solicitud = _estado_solicitud;
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
		WHERE idactivo = _idactivo AND es_responsable = 0 AND fecha_designacion IS NULL;
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
    WHERE idactivo=_idactivo AND idusuario = _idusuario AND fecha_designacion IS NULL;
END */$$
DELIMITER ;

/* Procedure structure for procedure `sp_request_duplicate` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_request_duplicate` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_request_duplicate`(
	IN _idusuario INT,
	IN _idactivo INT
)
BEGIN
	SELECT
		COUNT(*) as cantidad
        FROM solicitudes_activos
        WHERE idusuario=_idusuario AND idactivo=_idactivo AND(estado_solicitud='pendiente' OR estado_solicitud='aprobado');
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

/* Procedure structure for procedure `sp_search_solicitud` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_search_solicitud` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_solicitud`(
	IN _valor VARCHAR(50)
)
BEGIN
	SELECT
		SOL.idsolicitud,
        USU.id_usuario,
        ACT.idactivo,
        USU.usuario,
        ACT.descripcion
	FROM solicitudes_activos SOL
    INNER JOIN usuarios USU ON SOL.idusuario = USU.id_usuario
    INNER JOIN activos ACT ON SOL.idactivo = ACT.idactivo
    WHERE 
    SOL.estado_solicitud='aprobado' AND
    (USU.usuario LIKE CONCAT('%',_valor, '%')
    OR
    ACT.descripcion LIKE CONCAT('%',_valor,'%'));
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
    PER.nombres,
    RES.es_responsable
    FROM activos_responsables RES
    INNER JOIN usuarios USU ON RES.idusuario = USU.id_usuario
    INNER JOIN personas PER ON USU.idpersona = PER.id_persona
    WHERE RES.idactivo = _idactivo AND RES.fecha_designacion IS NULL;
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

/*Table structure for table `v_all_solicitudes` */

DROP TABLE IF EXISTS `v_all_solicitudes`;

/*!50001 DROP VIEW IF EXISTS `v_all_solicitudes` */;
/*!50001 DROP TABLE IF EXISTS `v_all_solicitudes` */;

/*!50001 CREATE TABLE  `v_all_solicitudes`(
 `idsolicitud` int(11) ,
 `usuario` varchar(120) ,
 `modelo` varchar(60) ,
 `cod_identificacion` char(40) ,
 `fecha_solicitud` date ,
 `estado_solicitud` enum('pendiente','aprobado','rechazado') 
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

/*View structure for view v_all_solicitudes */

/*!50001 DROP TABLE IF EXISTS `v_all_solicitudes` */;
/*!50001 DROP VIEW IF EXISTS `v_all_solicitudes` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_all_solicitudes` AS select `sol`.`idsolicitud` AS `idsolicitud`,`usu`.`usuario` AS `usuario`,`act`.`modelo` AS `modelo`,`act`.`cod_identificacion` AS `cod_identificacion`,`sol`.`fecha_solicitud` AS `fecha_solicitud`,`sol`.`estado_solicitud` AS `estado_solicitud` from ((`solicitudes_activos` `sol` join `usuarios` `usu` on(`sol`.`idusuario` = `usu`.`id_usuario`)) join `activos` `act` on(`sol`.`idactivo` = `act`.`idactivo`)) */;

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
