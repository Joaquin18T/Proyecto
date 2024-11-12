-- DROP DATABASE IF EXISTS db_cmms;
CREATE DATABASE db_cmms;
USE db_cmms;
-- AGG LOS CAMPOS CREATE UPDATE
-- TABLAS DE PERMISOS
CREATE TABLE perfiles
(
	idperfil 	INT AUTO_INCREMENT PRIMARY KEY,
    perfil      VARCHAR(30) NOT NULL,
    nombrecorto CHAR(3) NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_perfil UNIQUE(perfil),
    CONSTRAINT uk_nombrecorto UNIQUE(nombrecorto)
)ENGINE = INNODB;

CREATE TABLE modulos
(
	idmodulo	INT AUTO_INCREMENT PRIMARY KEY,
    modulo 		VARCHAR(30) NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_modulo UNIQUE(modulo)
)ENGINE=INNODB;

CREATE TABLE vistas
(
	idvista	INT AUTO_INCREMENT PRIMARY KEY,
    idmodulo 	INT NULL,
    ruta		VARCHAR(50) NOT NULL,
    isVisible   CHAR(1) NOT NULL,
    texto		VARCHAR(20) NULL,
    icono		VARCHAR(20) NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_idmodulo FOREIGN KEY (idmodulo) REFERENCES modulos (idmodulo),
    CONSTRAINT uk_ruta	UNIQUE(ruta),
    CONSTRAINT chk_isVisible CHECK (isVisible IN('1','0'))
)ENGINE = INNODB;


CREATE TABLE permisos
(
	idpermiso 	INT AUTO_INCREMENT PRIMARY KEY,
    idperfil 	INT NOT NULL,
    idvista 	INT NOT NULL,
    create_at 	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_idperfil_per FOREIGN KEY(idperfil) REFERENCES perfiles(idperfil),
    CONSTRAINT fk_idvista_per FOREIGN KEY(idvista) REFERENCES vistas(idvista),
    CONSTRAINT uk_idperfil_idvista UNIQUE(idperfil, idvista)
)ENGINE=INNODB;

-- FIN TABLAS DE PERMISOS

CREATE TABLE tipo_doc
(
  idtipodoc   int auto_increment primary key,
  tipodoc     varchar(50) not null,
  create_at	DATETIME NOT NULL DEFAULT NOW()
)ENGINE=INNODB;

CREATE TABLE PERSONAS
(
	id_persona    int auto_increment  primary key,
	idtipodoc     int                 not null,
	num_doc       varchar(20)         not null,
	apellidos     varchar(100)        not null,
	nombres	      varchar(100)        not null,
	genero        char(1)             not null,
	telefono      char(15)		      null,
    create_at	  DATETIME			  NOT NULL DEFAULT NOW(),
    update_at	  DATETIME			  NULL, 
	constraint    uk_telefono         UNIQUE(telefono),
	constraint    uk_num_doc          UNIQUE(num_doc),
	constraint    fk_idtipodoc        foreign key (idtipodoc) references TIPO_DOC (idtipodoc),
	constraint    chk_genero          CHECK(genero IN('M', 'F'))
)ENGINE=INNODB;

CREATE TABLE areas
(
	idarea	INT AUTO_INCREMENT PRIMARY KEY,
    area	VARCHAR(60) NOT NULL,	-- UK
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_area UNIQUE(area)
)ENGINE=INNODB;

-- TABLA ESTADOS
CREATE TABLE tipo_estados
(
	idtipo_estado INT AUTO_INCREMENT PRIMARY KEY,
    tipo_estado   VARCHAR(50) NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_tipo_estado UNIQUE(tipo_estado)
)ENGINE=INNODB;

CREATE TABLE estados
(
	idestado 	INT AUTO_INCREMENT PRIMARY KEY,
    idtipo_estado INT NOT NULL,
    nom_estado	VARCHAR(50) NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_idtipo_estado FOREIGN KEY(idtipo_estado) REFERENCES tipo_estados(idtipo_estado),
    CONSTRAINT uk_nom_estado UNIQUE(idtipo_estado, nom_estado)
)ENGINE=INNODB;

-- FIN TABLA ESTADOS

-- VARBINARY:
-- Su caracteristica principal es que puedes cambiar su longitud segun tus necesidades (flexibilidad)
-- Tambien agrega un nivel de seguridad
-- mas info: https://nelkodev.com/blog/manejo-eficiente-de-datos-con-varbinary-en-mysql/
CREATE TABLE USUARIOS
(
  idusuario		int auto_increment primary key,
  idpersona	  	int not null,
  nom_usuario     	varchar(120) not null,
  claveacceso 	VARBINARY(255) not null, 
  estado	  	TINYINT DEFAULT 1,  -- 1 , 0
  perfil		CHAR(3) NOT NULL, -- ADM, RSP, TNC
  idperfil 		INT NOT NULL,
  idarea		INT NOT NULL,
  responsable_area TINYINT DEFAULT 0, -- 1 Y 0
  create_at		DATETIME NOT NULL DEFAULT NOW(),
  update_at	 	 DATETIME			  NULL,
  CONSTRAINT fk_persona_user FOREIGN KEY (idpersona) REFERENCES personas(id_persona),
  CONSTRAINT uk_idpersona_user UNIQUE(idpersona,nom_usuario),
  CONSTRAINT fk_idperfil_user FOREIGN KEY (idperfil) REFERENCES perfiles(idperfil),
  CONSTRAINT fk_idarea_user FOREIGN KEY (idarea) REFERENCES areas(idarea)
)ENGINE=INNODB;

CREATE TABLE categorias
(
	idcategoria		INT AUTO_INCREMENT PRIMARY KEY,
    categoria		VARCHAR(60) NOT NULL,	-- UK
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_categoria UNIQUE(categoria)
)ENGINE=INNODB;

CREATE TABLE subcategorias
(
	idsubcategoria	INT AUTO_INCREMENT PRIMARY KEY,
    idcategoria		INT NOT NULL,
    subcategoria	VARCHAR(60) NOT NULL,	-- UK
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_subcategoria UNIQUE(subcategoria),
    CONSTRAINT fk_categoria FOREIGN KEY (idcategoria) REFERENCES categorias (idcategoria)
)ENGINE=INNODB;

CREATE TABLE marcas
(
	idmarca		INT AUTO_INCREMENT PRIMARY KEY,
    marca		VARCHAR(80) NOT NULL, 	-- UK
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT uk_marca UNIQUE(marca)
)ENGINE=INNODB;

CREATE TABLE detalles_marca_subcategoria
(
	iddetalle_marca_sub INT AUTO_INCREMENT PRIMARY KEY,
    idmarca		INT NOT NULL,
    idsubcategoria INT NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_idmarca_detalle FOREIGN KEY (idmarca) REFERENCES marcas (idmarca),
    CONSTRAINT fk_idsubcategoria FOREIGN KEY (idsubcategoria) REFERENCES subcategorias (idsubcategoria)
)ENGINE = INNODB;

CREATE TABLE activos
(
	idactivo			INT AUTO_INCREMENT PRIMARY KEY,
    idsubcategoria		INT			NOT NULL,
    idmarca				INT 		NOT NULL,
    idestado			INT 		NOT NULL DEFAULT 1,
    modelo				VARCHAR(60) NULL,
    cod_identificacion	VARCHAR(40) NOT NULL, -- VARCHAR para mayor flexibilidad
    fecha_adquisicion	DATE 		NOT NULL,
    descripcion			VARCHAR(200) NULL,
    especificaciones	JSON 		NOT NULL,
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    update_at	 	 DATETIME			  NULL,
    CONSTRAINT fkidmarca	 FOREIGN KEY (idmarca)	REFERENCES marcas(idmarca),
    CONSTRAINT fk_actsubcategoria FOREIGN KEY(idsubcategoria) REFERENCES subcategorias(idsubcategoria),
    CONSTRAINT fk_idestado FOREIGN KEY (idestado) REFERENCES estados(idestado),
    CONSTRAINT uk_cod_identificacion UNIQUE(cod_identificacion)
)ENGINE=INNODB;

-- SI SE CAMBIA DE AREA DE UN ACTIVO, SE REGISTRA EN ACTIVOS_ASIGNADOS
CREATE TABLE activos_asignados
(
	idactivo_asig	INT AUTO_INCREMENT PRIMARY KEY,
    idarea				INT NOT NULL,
    idactivo			INT NOT NULL,
    fecha_asignacion 	DATE NOT NULL DEFAULT NOW(),
    -- descripcion_asig	VARCHAR(100) NOT NULL, -- OR NULL?
    condicion_asig      VARCHAR(500) NOT NULL,
    imagenes			JSON NOT NULL,
    idestado			INT NOT NULL,
    create_at			DATETIME NOT NULL DEFAULT NOW(),
	update_at	 		DATETIME			  NULL,
    CONSTRAINT fk_idarea_asig FOREIGN KEY (idarea) REFERENCES areas(idarea),
    CONSTRAINT fk_idactivo_asig FOREIGN KEY (idactivo) REFERENCES activos (idactivo),
    CONSTRAINT fk_estado_asig FOREIGN KEY (idestado) REFERENCES estados (idestado)
)ENGINE=INNODB;


CREATE TABLE historial_asignaciones_activos
(
	idhistorial_activo 	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo_asig		INT NULL,
    idresponsable 		INT NULL,
    fecha_movimiento 	DATETIME NOT NULL DEFAULT NOW(),
    coment_adicional    VARCHAR(500) NULL,
    CONSTRAINT fk_idactivo_asig_his FOREIGN KEY (idactivo_asig)REFERENCES activos_asignados(idactivo_asig),
    CONSTRAINT fk_responsable_his FOREIGN KEY(idresponsable) REFERENCES usuarios (idusuario)
)ENGINE=INNODB;

CREATE TABLE notificaciones_asignaciones
(
	idnotificacion_activo	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo_asig			INT NULL, 
    tipo					VARCHAR(90) NOT NULL,
    mensaje					VARCHAR(250) NOT NULL,
    fecha_creacion			DATETIME NOT NULL DEFAULT NOW(),
    visto					TINYINT(1) NOT NULL DEFAULT 0,
	update_at	 		DATETIME			  NULL,
    -- idactivo 				INT  NULL,
    CONSTRAINT fk_idasignacion_nof FOREIGN KEY(idactivo_asig) REFERENCES activos_asignados (idactivo_asig),
    CONSTRAINT chk_visto CHECK (visto IN(1,0))
    -- CONSTRAINT fk_idactivo_noti_activo FOREIGN KEY(idactivo) REFERENCES activos(idactivo)
)ENGINE = INNODB;

CREATE TABLE bajas_activo
(
	idbaja_activo	INT AUTO_INCREMENT PRIMARY KEY,
    idactivo		INT NOT NULL,
    fecha_baja		DATETIME NOT NULL DEFAULT NOW(),
    motivo			VARCHAR(250) NOT NULL,
    coment_adicionales VARCHAR(250) NULL,
    ruta_doc		VARCHAR(250) NOT NULL,
    idusuario_aprobacion		INT NOT NULL, -- QUIEN APROBO LA BAJA
    create_at	DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_activo_baja_activo FOREIGN KEY (idactivo) REFERENCES activos(idactivo),
    CONSTRAINT fk_usuario_baja_activo FOREIGN KEY (idusuario_aprobacion) REFERENCES usuarios(idusuario),
    CONSTRAINT uk_ruta_doc UNIQUE(ruta_doc) 
)
ENGINE=INNODB;