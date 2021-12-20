drop database hospital;
create database hospital;
	use hospital;

create table horario (
		idHorario int auto_increment primary key not null,

		lunes1 varchar(2),
		lunes2 varchar(2),
		martes1 varchar(2),
		martes2 varchar(2),
		miercoles1 varchar(2),
		miercoles2 varchar(2),
		jueves1 varchar(2),
		jueves2 varchar(2),
		viernes1 varchar(2),
		viernes2 varchar(2)
);
create table diagnostico (
		idDiagnostico int auto_increment primary key not null,
		diagnostico varchar(30)
);

create table medicamento (
	idMedicamento int auto_increment primary key not null,
	medicamento varchar(50)
);

create table medico (
		idMedico int auto_increment primary key not null,
		nombre varchar(50),
		especialidad varchar (50),
		/*disponibilidad enum('Si','No'),*/
		idHorario int, FOREIGN KEY (idHorario) REFERENCES horario (idHorario)
);

create table paciente (
		idPaciente int auto_increment primary key not null,
		nombre varchar(50)
);


create table cita (
		idCita int auto_increment primary key not null,
		fecha date,
		idMedicoG int, FOREIGN KEY (idMedicoG) REFERENCES medico (idMedico),
		idMedicoE int, FOREIGN KEY (idMedicoE) REFERENCES medico (idMedico),
		idPaciente int, FOREIGN KEY (idPaciente) REFERENCES paciente (idPaciente),
		idDiagnostico int, FOREIGN KEY (idDiagnostico) REFERENCES diagnostico (idDiagnostico),
		idMedicamento int, FOREIGN key (idMedicamento) REFERENCES medicamento (idMedicamento),
		cantidad varchar (5)
		/*signosVitales varchar(10)*/

);

load data local infile 'horario.csv' into table horario fields
terminated by ',' lines terminated by '\n';
select * from horario;


load data local infile 'tratamiento.csv' into table diagnostico fields
terminated by ',' lines terminated by '\n';
select * from diagnostico;

load data local infile 'medicamento.csv' into table medicamento fields
terminated by ',' lines terminated by '\n';
select * from medicamento;


load data local infile 'medico.csv' into table medico fields
terminated by ',' lines terminated by '\n';
select * from medico;

load data local infile 'paciente.csv' into table paciente fields
terminated by ',' lines terminated by '\n';
select * from paciente;

load data local infile 'cita.csv' into table cita fields
terminated by ',' lines terminated by '\n';
select * from cita;


CREATE VIEW VW1 AS
SELECT p.nombre AS paciente,h.miercoles1 AS horario1, h.miercoles2 AS horario2, m.nombre AS medico, c.fecha AS cita
FROM paciente AS p, horario AS h, medico AS m, cita AS c
WHERE h.idHorario=m.idHorario 
AND m.idMedico = c.idMedicoE 
AND c.idPaciente = p.idPaciente
AND c.fecha = '2020/01/22'\G;

SELECT * from vw1;


CREATE VIEW vw2 AS
SELECT m.nombre AS medico, m.especialidad AS especialidad
FROM medico AS m;
SELECT * FROM vw2;

DELIMITER $
CREATE PROCEDURE sp1(in var1 varchar(50))
BEGIN
SELECT c.fecha AS cita, m.nombre AS medico, d.diagnostico AS diagnostico
FROM cita AS c, medico AS m, diagnostico AS d, paciente AS p
WHERE m.idMedico = c.idMedicoE
AND c.idDiagnostico = d.idDiagnostico
AND c.idPaciente = p.idPaciente
AND p.nombre LIKE var1;
END $
DELIMITER ;
CALL sp1('%KLIDZZMAN%') \G;


DELIMITER $
CREATE PROCEDURE sp2(in var2 varchar(50))
BEGIN
SELECT c.idCita AS cita, c.fecha AS fecha, p.nombre AS paciente, d.diagnostico AS diagnostico
FROM medico AS m, cita AS c, diagnostico AS d, paciente AS p
WHERE m.idMedico = c.idMedicoE
AND c.idPaciente = p.idPaciente
AND d.idDiagnostico = c.idDiagnostico
AND m.nombre LIKE var2;
END $
DELIMITER ;
CALL sp2('%DANIELA%') \G;