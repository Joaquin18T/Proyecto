DROP DATABASE IF EXISTS gamp;
CREATE DATABASE GAMP;
USE gamp;

CREATE TABLE TIPO_DOC
(
  idtipodoc   int auto_increment primary key,
  tipodoc     varchar(50) not null
)ENGINE=INNODB;


CREATE TABLE PERSONAS
(
	id_persona    int auto_increment  primary key,
	idtipodoc     int                 not null,
	num_doc       varchar(50)         not null,
	apellidos     varchar(100)        not null,
	nombres	      varchar(100)        not null,
	genero        char(1)             not null,
	telefono      char(9)		      null,
	constraint    uk_telefono         UNIQUE(telefono),
	constraint    uk_num_doc          UNIQUE(num_doc),
	constraint    fk_idtipodoc        foreign key (idtipodoc) references TIPO_DOC (idtipodoc),
	constraint    chk_genero          CHECK(genero IN('M', 'F'))
)ENGINE=INNODB;


CREATE TABLE ROLES
(
  idrol		int auto_increment primary key,
  rol 		varchar(20)	not null,
  CONSTRAINT uk_rol UNIQUE(rol)
)ENGINE=INNODB;

CREATE TABLE permisos
(
	idpermiso 	INT AUTO_INCREMENT PRIMARY KEY,
    idrol		INT NOT NULL,
    permiso  	JSON NOT NULL,
    CONSTRAINT fk_idrol FOREIGN KEY(idrol) REFERENCES roles(idrol)
)ENGINE=INNODB;

CREATE TABLE estados
(
	idestado 	INT AUTO_INCREMENT PRIMARY KEY,
    tipo_estado VARCHAR(50) NOT NULL,
    nom_estado	VARCHAR(50) NOT NULL,
    CONSTRAINT uk_nom_estado UNIQUE(nom_estado)
)ENGINE=INNODB;

CREATE TABLE frecuencias
(
	idfrecuencia	INT auto_increment primary key,
    frecuencia		varchar(20) not null
)ENGINE=INNODB;

CREATE TABLE USUARIOS
(
  id_usuario	int auto_increment primary key,
  idpersona	  	int not null,
  idrol		    int not null,
  usuario     	varchar(120) not null,
  contrasena 	varchar(120) not null,
  estado	  	CHAR(1) DEFAULT '1',  -- 1 , 0
  asignacion	int		null default 7,
  CONSTRAINT fk_persona1 FOREIGN KEY (idpersona) REFERENCES PERSONAS(id_persona),
  CONSTRAINT fk_rol1 FOREIGN KEY (idrol) REFERENCES roles (idrol),
  CONSTRAINT uk_idpersonaUser1 UNIQUE(idpersona,usuario),
  CONSTRAINT fk_asignacion1 FOREIGN KEY (asignacion) REFERENCES estados (idestado)
)ENGINE=INNODB;

CREATE TABLE categorias
(
	idcategoria		INT AUTO_INCREMENT PRIMARY KEY,
    categoria		VARCHAR(60) NOT NULL,	-- UK
    CONSTRAINT uk_categoria UNIQUE(categoria)
)ENGINE=INNODB;

CREATE TABLE subcategorias
(
	idsubcategoria	INT AUTO_INCREMENT PRIMARY KEY,
    idcategoria		INT NOT NULL,
    subcategoria	VARCHAR(60) NOT NULL,	-- UK
    CONSTRAINT uk_subcategoria UNIQUE(subcategoria),
    CONSTRAINT fk_categoria FOREIGN KEY (idcategoria) REFERENCES categorias (idcategoria)
)ENGINE=INNODB;

CREATE TABLE marcas
(
	idmarca		INT AUTO_INCREMENT PRIMARY KEY,
    marca		VARCHAR(80) NOT NULL, 	-- UK
    CONSTRAINT uk_marca UNIQUE(marca)
)ENGINE=INNODB;

CREATE TABLE detalles_marca_subcategoria
(
	iddetalle_marca_sub INT AUTO_INCREMENT PRIMARY KEY,
    idmarca		INT NOT NULL,
    idsubcategoria INT NOT NULL,
    CONSTRAINT fk_idmarca_detalle FOREIGN KEY (idmarca) REFERENCES marcas (idmarca),
    CONSTRAINT fk_idsubcategoria FOREIGN KEY (idsubcategoria) REFERENCES subcategorias (idsubcategoria)
)ENGINE = INNODB;

CREATE TABLE ubicaciones
(
	idubicacion	INT AUTO_INCREMENT PRIMARY KEY,
    ubicacion	VARCHAR(60) NOT NULL,	-- UK
    CONSTRAINT uk_ubicacion UNIQUE(ubicacion)
)ENGINE=INNODB;

CREATE TABLE activos
(
	idactivo			INT AUTO_INCREMENT PRIMARY KEY,
    idsubcategoria		INT			NOT NULL,
    idmarca				INT 		NOT NULL,
    idestado			INT 		NOT NULL DEFAULT 1,
    modelo				VARCHAR(60) NULL,
    cod_identificacion	CHAR(40) 	NOT NULL,
    fecha_adquisicion	DATE 		NOT NULL,
    descripcion			VARCHAR(200) NULL,
    especificaciones	JSON 		NOT NULL,
    CONSTRAINT fkidmarca	 FOREIGN KEY (idmarca)	REFERENCES marcas(idmarca),
    CONSTRAINT fk_actsubcategoria FOREIGN KEY(idsubcategoria) REFERENCES subcategorias(idsubcategoria),
    CONSTRAINT fk_idestado FOREIGN KEY (idestado) REFERENCES estados(idestado),
    CONSTRAINT uk_cod_identificacion UNIQUE(cod_identificacion)
    -- CONSTRAINT uk_activo UNIQUE(idsubcategoria, idmarca, modelo) -- 10/10
)ENGINE=INNODB;

CREATE TABLE especificacionesDefecto
(
	idespecificacionD	INT AUTO_INCREMENT PRIMARY KEY,
    idsubcategoria		INT NOT NULL,
    especificaciones 	JSON NOT NULL,
    CONSTRAINT uk_subcategoria_especificacion UNIQUE(idsubcategoria, especificaciones)
)ENGINE=INNODB;

CREATE TABLE solicitudes_activos
(
	idsolicitud			INT AUTO_INCREMENT PRIMARY KEY,
    idusuario			INT NOT NULL,
    idactivo			INT NOT NULL,
    fecha_solicitud 	DATE NOT NULL DEFAULT NOW(),
    estado_solicitud 	ENUM('pendiente', 'aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
    motivo_solicitud	VARCHAR(500) NULL,
    idautorizador		INT NOT NULL,
    fecha_respuesta		DATE NULL,
    coment_autorizador 	VARCHAR(500) NULL,
    CONSTRAINT fk_usuario_sol FOREIGN KEY (idusuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_activo_sol  FOREIGN KEY (idactivo) REFERENCES activos (idactivo),
    CONSTRAINT chk_resp_sol CHECK(fecha_respuesta>=fecha_solicitud)
)
ENGINE=INNODB;


-- TABLA CONTROLADA POR LOS ADMINISTRADORES
CREATE TABLE activos_responsables
(
	idactivo_resp		INT AUTO_INCREMENT PRIMARY KEY,
    idactivo			INT NOT NULL,
    idusuario			INT NOT NULL,
    es_responsable 		CHAR(1) NOT NULL DEFAULT '0',
    fecha_asignacion 	DATE NOT NULL DEFAULT NOW(),
    fecha_designacion	DATE NULL,
    condicion_equipo	VARCHAR(500),
    imagenes			JSON NOT NULL,
    descripcion			VARCHAR(500) NOT NULL,
    autorizacion		INT NOT NULL,	-- USER ROL ADMIN (validar en codigo)
    solicitud			INT NOT NULL,   
    CONSTRAINT fk_activo_resp FOREIGN KEY(idactivo) REFERENCES activos(idactivo),
    CONSTRAINT fk_user_resp	  FOREIGN KEY(idusuario) REFERENCES usuarios(id_usuario),
	CONSTRAINT	fk_autorizacion FOREIGN KEY (autorizacion) REFERENCES usuarios (id_usuario),
    CONSTRAINT	fk_solicitud FOREIGN KEY(solicitud) REFERENCES usuarios(id_usuario),
    CONSTRAINT chk_es_responsable CHECK(es_responsable IN('1','0'))
    -- CONSTRAINT chk_fech_desig CHECK(fecha_designacion>fecha_asignacion)
)ENGINE=INNODB;

CREATE TABLE historial_activos
(
	idhistorial_activo 	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo_resp		INT NULL,
	idubicacion			INT	NOT NULL,
    accion 				VARCHAR(30) NULL,
    responsable_accion 	INT NULL,
    fecha_movimiento 	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_idactivo_resp FOREIGN KEY (idactivo_resp)REFERENCES activos_responsables(idactivo_resp),
	CONSTRAINT fk_idubicacion	FOREIGN KEY(idubicacion) REFERENCES ubicaciones(idubicacion),
    CONSTRAINT fk_usuario_his FOREIGN KEY(responsable_accion) REFERENCES usuarios (id_usuario)
)ENGINE=INNODB;


CREATE TABLE bajas_activo
(
	idbaja_activo	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo		INT NOT NULL,
    fecha_baja		DATETIME NOT NULL DEFAULT NOW(),
    motivo			VARCHAR(250) NOT NULL,
    coment_adicionales VARCHAR(250) NULL,
    ruta_doc		VARCHAR(250) NOT NULL,
    aprobacion		INT NOT NULL, -- QUIEN APROBO LA BAJA
    CONSTRAINT fk_activo_baja_activo FOREIGN KEY (idactivo) REFERENCES activos(idactivo),
    CONSTRAINT fk_usuario_baja_activo FOREIGN KEY (aprobacion) REFERENCES usuarios(id_usuario),
    CONSTRAINT uk_ruta_doc UNIQUE(ruta_doc) -- Modificacion 12-10
)
ENGINE=INNODB;

CREATE TABLE notificaciones_activos
(
	idnotificacion_activo	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo_resp			INT NULL, 
    tipo					VARCHAR(30) NOT NULL,
    mensaje					VARCHAR(250) NOT NULL,
    fecha_creacion			DATETIME NOT NULL DEFAULT NOW(),
    visto					CHAR(1) NOT NULL DEFAULT('0'),
    idactivo 				INT  NULL,
    CONSTRAINT fk_idactivo_resp_nof FOREIGN KEY(idactivo_resp) REFERENCES activos_responsables (idactivo_resp),
    CONSTRAINT chk_visto CHECK (visto IN('1','0')),
    CONSTRAINT fk_idactivo_noti_activo FOREIGN KEY(idactivo) REFERENCES activos(idactivo)
)ENGINE = INNODB;

CREATE TABLE notificaciones_mantenimiento
(
	idnotificacion_mantenimiento	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo						INT NOT NULL,
    tipo							VARCHAR(30) NOT NULL,
    mensaje							VARCHAR(250) NOT NULL,
    fecha_programada				DATE NOT NULL,
    fecha_creacion					DATETIME NOT NULL DEFAULT NOW(),
    estado							VARCHAR(20) NOT NULL,
    visto							CHAR(1) NOT NULL,
    CONSTRAINT fk_idactivo_noti_mantenimiento FOREIGN KEY(idactivo) REFERENCES activos(idactivo)
    -- validar que la fecha programada sea mayor que la fecha actual
)ENGINE = INNODB;
-- ********************************* TABLAS ROYER *************************************
-- 12/10/2024

DROP TABLE IF EXISTS `plandetareas`;
CREATE TABLE `plandetareas`
(
	idplantarea		int			auto_increment primary key,
    descripcion		varchar(80)	not null,    
	incompleto 		boolean		null default true,
    eliminado		boolean		null default false,
    create_at		datetime	not null default now(),
    update_at		datetime	null,
    CONSTRAINT uk_descripcion_plan UNIQUE(descripcion)
)ENGINE=INNODB; -- CHECK

DROP TABLE IF EXISTS `tipo_prioridades`;
CREATE TABLE `tipo_prioridades`
(
	idtipo_prioridad	int	auto_increment primary key,
    tipo_prioridad		varchar(10)	not null
)ENGINE=INNODB;

DROP TABLE IF EXISTS `tareas`;
CREATE TABLE `tareas`
(
	idtarea				int	 			auto_increment 				primary key,
    idplantarea			int				not null,
    idtipo_prioridad	int 			not null,
    descripcion			varchar(200)	not null,
    idsubcategoria		int				not null,
    intervalo			int				not null,
    idfrecuencia 		int				not null,
	idestado			int				not null,
    trabajado			boolean			not null default false,
    pausado				boolean 		not null default false,
    create_at			datetime		not null default now(),
    update_at			datetime		null,
    CONSTRAINT	fk_idplantarea		foreign key (idplantarea) 		REFERENCES plandetareas (idplantarea) ON DELETE CASCADE,
    CONSTRAINT	fk_idtipo_prioridad	foreign key (idtipo_prioridad) 	REFERENCES tipo_prioridades (idtipo_prioridad),
    CONSTRAINT	fk_descripcion_tarea 		unique(descripcion),
	CONSTRAINT	fk_idestado2		foreign key (idestado)			REFERENCES estados (idestado),
	CONSTRAINT fk_idsubcategoria_plan FOREIGN KEY (idsubcategoria) references subcategorias (idsubcategoria),
    CONSTRAINT fk_idfrecuencia FOREIGN KEY (idfrecuencia) references frecuencias (idfrecuencia)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `odt`;
CREATE TABLE `odt`
(
	idorden_trabajo		int		auto_increment		primary key,
    idtarea				int	 	not null,
    creado_por			int		not null,
	fecha_inicio		date		not null,
    hora_inicio			time		not null,    
    idestado			int		null default 9,
    incompleto 		boolean		null default true,
    eliminado		boolean		null default false,
    CONSTRAINT 			fk_idtarea4					FOREIGN KEY (idtarea)					REFERENCES tareas 	(idtarea) ON DELETE CASCADE,
    CONSTRAINT			fk_creado_por				foreign key (creado_por) 				REFERENCES usuarios	(id_usuario),
    CONSTRAINT			fk_idestado4				FOREIGN KEY	(idestado)					REFERENCES estados	(idestado)
)ENGINE=INNODB;	

DROP TABLE IF EXISTS `tipo_diagnosticos`;
CREATE TABLE `tipo_diagnosticos`
(
	idtipo_diagnostico		int auto_increment primary key,
    tipo_diagnostico		varchar(30)			not null
)ENGINE=INNODB;

DROP TABLE IF EXISTS `diagnosticos`;
CREATE TABLE `diagnosticos`
(
	iddiagnostico		int	auto_increment primary key,
    idorden_trabajo		int	not null,
	idtipo_diagnostico	int	not null,
    diagnostico			varchar(300)	default null,
    CONSTRAINT			fk_idorden_trabajo3		foreign key (idorden_trabajo)	references odt (idorden_trabajo) ON DELETE CASCADE,
    CONSTRAINT			fk_idtipo_diagnostico	foreign key (idtipo_diagnostico) references tipo_diagnosticos (idtipo_diagnostico)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `evidencias_diagnostico`;
CREATE TABLE `evidencias_diagnostico`
(
	idevidencias_diagnostico	int	auto_increment primary key,
    iddiagnostico				int not null,
    evidencia					VARCHAR(80)	not null,
	CONSTRAINT 					fk_iddiagnostico	foreign key (iddiagnostico) references diagnosticos (iddiagnostico) ON DELETE CASCADE
)ENGINE=INNODB;	

DROP TABLE IF EXISTS `responsables_asignados_odt`;
CREATE TABLE `responsables_asignados_odt`
(
	idresponsable_asignado			int								auto_increment 			primary key,
	idorden_trabajo					int not null,
    idresponsable					int	not null,
	CONSTRAINT 	fk_idodt			foreign key (idorden_trabajo)	REFERENCES odt 			(idorden_trabajo) ON DELETE CASCADE,
    CONSTRAINT	fk_idresponsable	foreign key (idresponsable) 	REFERENCES usuarios 	(id_usuario)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `activos_vinculados_tarea`;
CREATE TABLE `activos_vinculados_tarea`
(
	idactivo_vinculado	int			auto_increment primary key,
    idtarea				int 		not null,
    idactivo			int 		not null,
    create_at			datetime	not null default now(),
    update_at			datetime	null,
    CONSTRAINT fk_idtarea5		foreign key (idtarea) references tareas (idtarea) ON DELETE CASCADE,
    CONSTRAINT fk_idactivo3		FOREIGN KEY (idactivo) REFERENCES activos (idactivo)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `detalle_odt`;
CREATE TABLE `detalle_odt`
(
	iddetalleodt		int 		auto_increment 		primary key,
    idorden_trabajo		int			not null,
    fecha_inicial		datetime	not null default now(),
    fecha_final 		datetime	null,
    tiempo_ejecucion	time		null,
    intervalos_ejecutados int		not null,
    clasificacion		int			null,
	CONSTRAINT			fk_orden_trabajo2	foreign key (idorden_trabajo) references odt (idorden_trabajo) ON DELETE CASCADE,
    CONSTRAINT			fk_clasificacion	foreign key (clasificacion) references estados (idestado)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `comentarios_odt`;
CREATE TABLE `comentarios_odt`
(
	idcomentario		int			 	auto_increment		primary key,
    idorden_trabajo		int			 	not null,   
    comentario			varchar(300) 	null,
    revisadoPor			int		 		not null,
    CONSTRAINT 			fk_idorden_trabajo	foreign key (idorden_trabajo) references odt (idorden_trabajo) ON DELETE CASCADE,
    CONSTRAINT 			fk_revisadoPor		foreign key (revisadoPor) references usuarios (id_usuario)
)ENGINE=INNODB;

DROP TABLE IF EXISTS `historial_odt`;
CREATE TABLE `historial_odt`
(
	idhistorial			int		auto_increment primary key,
	idorden_trabajo		int 	not null,
    constraint fk_idodt_hist foreign key (idorden_trabajo) references odt (idorden_trabajo)
)ENGINE=INNODB;
