DROP DATABASE IF EXISTS gamp;
CREATE DATABASE GAMP;
USE gamp;

create table tareas
(
	idtarea		int auto_increment primary key,
    idusuario	int	not null,
    fecha_inicio	date	not null,
    hora_inicio		time	not null,
    idestado			int		null default 8,
	CONSTRAINT fk_idusuario	FOREIGN KEY (idusuario) REFERENCES usuarios (id_usuario),
    CONSTRAINT fk_estado	FOREIGN KEY (idestado) REFERENCES estados (idestado)
)ENGINE=INNODB	;

CREATE TABLE activos_tarea
(
	idactivos_tarea		int not null,
    idtarea				int not null,
    idactivo			int not null,
    CONSTRAINT fk_idtareaAVT foreign key (idtarea) references tareas (idtarea),
    CONSTRAINT fk_idactivoAVT foreign key (idactivo) references activos (idactivo)
)ENGINE=INNODB;

CREATE TABLE tareas_mantenimiento
(
	idtm	INT auto_increment primary key,
    idtarea					INT NOT NULL,
    descripcion				varchar(300) not null,
    fecha_inicio			date	null default now(),
    hora_inicio				time	null default now(),
    fecha_finalizado 		date	null,
    hora_finalizado			time	null,
    tiempo_ejecutado		time	null,
    CONSTRAINT fk_idtareaTM	FOREIGN KEY (idtarea) REFERENCES tareas (idtarea)
)ENGINE=INNODB;

CREATE TABLE evidencias
(
	idevidencia		INT auto_increment primary key,
    idtm			INT not null,
    evidencia		int not null,
    CONSTRAINT fk_idtmEV foreign key (idtm) references tareas_mantenimiento (idtm)
)ENGINE=INNODB;

