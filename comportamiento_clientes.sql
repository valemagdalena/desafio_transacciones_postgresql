/*
DROP DATABASE ejemplo;

CREATE DATABASE ejemplo;

\c ejemplo

psql -U valentina ejemplo < unidad2.sql */

\set AUTOCOMMIT off

/* El cliente usuario01 ha realizado la siguiente compra:
producto: producto9
cantidad: 5
fecha: fecha del sistema */

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) values (33, 1,'2021-07-28');
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (9, 33, 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
ROLLBACK;

--Verificar el stock actualizado
SELECT * FROM producto;

/*El cliente usuario02 ha realizado la siguiente compra:
producto: producto1, producto 2, producto 8
cantidad: 3 de cada producto
fecha: fecha del sistema */

BEGIN TRANSACTION;

INSERT INTO compra (id, cliente_id, fecha) values (33,2,'2021-07-28');

--Ingresar compra producto 1 (stock=6)
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (1, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto1';
SAVEPOINT checkpoint1;

--Ingresar compra producto 2 (stock=5)
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (2, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto2';
SAVEPOINT checkpoint2;

--Ingresar compra producto 8 (stock=0)
INSERT INTO detalle_compra (producto_id, compra_id, cantidad) values (8, 33, 3);
UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto8';
ROLLBACK TO checkpoint2;


-- a. Deshabilitar el AUTOCOMMIT
\set AUTOCOMMIT off
-- b. Insertar un nuevo cliente
BEGIN TRANSACTION;
INSERT INTO cliente (id, nombre, email) VALUES (11, 'usuario011', 'usuario011@gmail.com');
-- c. Confirmar que fue agregado en la tabla cliente
SELECT * FROM cliente WHERE id=11;
-- d. Realizar un ROLLBACK
ROLLBACK
-- e. Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente where id=11;
-- f. Habilitar de nuevo el AUTOCOMMIT
\set AUTOCOMMIT ON

--FIN DESAFIO--