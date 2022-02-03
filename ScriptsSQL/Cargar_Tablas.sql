INSERT INTO perfilconductor (ID,usuario,contra)
VALUES (1,'Joaquin','1234'),
(2,'Gian','1234'),
(3,'Yoel','1234'),
(4,'Fede','1234');

INSERT INTO persona (ID,nombre,apellido,dni,rutaFoto,mail,PerfilConductor_ID)
VALUES(1,'Joaquin','Pamphile',11111111,'.static/src/img/joaquin.jpg','joacojota2@gmail.com',1),
(2,'Gian','Carzolio',22222222,'.static/src/img/gian.jpg','gian@gmail.com',2),
(3,'Yoel','Almiron',33333333,'.static/src/img/yoel.jpg','yoel@gmail.com',3),
(4,'Fede','Fernandez',44444444,'.static/src/img/fede.jpg','fede@gmail.com',4);

INSERT INTO marca (ID, nombre)
VALUES (1, 'Ford');

INSERT INTO modelo (ID,nombre,Marca_ID)
VALUES (1,'Fiesta',1);

INSERT INTO vehiculo (ID,color,patente,kilometros,seguridad,estado,Modelo_ID,PerfilConductor_ID)
VALUES (1,'rojo','ABC111',23000,1,1,1,1),
(2,'verde','ABC222',23000,1,1,1,2),
(3,'azul','ABC333',23000,1,1,1,3),
(4,'negro','ABC444',23000,1,1,1,4);

INSERT INTO pais(ID,nombre)
VALUES(1,'Argentina');

INSERT INTO provincia(ID,nombre,Pais_ID)
VALUES (1,'Rio Negro',1),
(2,'BS AS',1);

INSERT INTO localidad1(ID,nombre,codigoPostal,Provincia_ID)
VALUES(1,'Bariloche','8324',1),
(2,'La Plara','1900',2),
(3,'Cipolletti','8324',1);

INSERT INTO localidad2(ID,nombre,codigoPostal,Provincia_ID)
VALUES(1,'Bariloche','8324',1),
(2,'La Plara','1900',2),
(3,'Cipolletti','8324',1);

INSERT INTO ubicacion (ID,calle,numero,Localidad_ID)
VALUES (1, 'Los Pinos', '334', 1),
(2,'Calle 12','822',2);

INSERT INTO estadoviaje (ID,observacion)
VALUES(1,'Finalizado'),
(2,'EnCurso'),
(3,'Cancelado');

INSERT INTO estadopasajerodetalle(ID, observacion)
VALUES(1,'Admitido'),
(2,'Cancelado'),
(3,'Rechazado'),
(4,'Pendiente');

INSERT INTO viaje (ID,cantidadDeLugaresDisponibles,fecha,hora,precioDelViaje,equipaje,observacion,PerfilConductor_ID,Vehiculo_ID,Origen_ID,Destino_ID,EstadoViaje_ID)
VALUES (1,2,'2022-3-23','08:30',10000,1,'sarasa',1,1,2,1,1),
(2,0,'2022-3-30','08:30',12000,1,'sarasa',1,1,1,2,1);

INSERT INTO pasajerodetalle(ID,detalle,Persona_ID,Viaje_ID,EstadoPasajeroDetalle_ID)
VALUES(1,'sarasa',1,1,4);
