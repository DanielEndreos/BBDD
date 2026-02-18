CREATE DATABASE Tienda_DAW;


-- Clientes
CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT NOT NULL,
  nombre     VARCHAR(60)  NOT NULL,
  email      VARCHAR(100) NOT NULL UNIQUE,
  ciudad     VARCHAR(50)  NOT NULL,
  fecha_alta DATE         NOT NULL,
  PRIMARY KEY (id_cliente)
);

-- Categorías
CREATE TABLE categorias (
  id_categoria INT AUTO_INCREMENT NOT NULL,
  nombre       VARCHAR(60) NOT NULL UNIQUE,
  PRIMARY KEY (id_categoria)
);

-- Productos (1:N con categorías)

CREATE TABLE productos (
  id_producto  INT AUTO_INCREMENT NOT NULL,
  nombre       VARCHAR(80)  NOT NULL,
  precio       DECIMAL(10,2) NOT NULL,
  stock        INT NOT NULL,
  id_categoria INT NOT NULL,
 
  PRIMARY KEY (id_producto),
  
  CONSTRAINT fk_productos_categorias
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Pedidos (1:N con clientes)

CREATE TABLE pedidos (
  id_pedido   INT AUTO_INCREMENT NOT NULL,
  id_cliente  INT NOT NULL,
  fecha       DATE NOT NULL,
  estado      ENUM('PENDIENTE','PAGADO','ENVIADO','CANCELADO') NOT NULL,
  total       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id_pedido),

  CONSTRAINT fk_pedidos_clientes
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Líneas de pedido (N:M pedidos-productos) tabla intermedia

CREATE TABLE lineas_pedido (
  id_pedido       INT NOT NULL,
  id_producto     INT NOT NULL,
  cantidad        INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
 
  PRIMARY KEY (id_pedido, id_producto),

  CONSTRAINT fk_lineas_pedidos
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  
    CONSTRAINT fk_lineas_productos
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_alta) VALUES
(1,'Ana Ruiz','ana@correo.es','Sevilla','2024-01-10'),
(2,'Luis Pérez','luis@correo.es','Madrid','2024-02-05'),
(3,'Marta Gil','marta@correo.es','Valencia','2024-03-01');


INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_alta) VALUES 
(1000,'Maria Ruiz','maria@correo.es','Sevilla','2024-01-10');

select * from clientes;

INSERT INTO clientes (nombre, email, ciudad, fecha_alta) VALUES ('Pedro Ruiz','pr@correo.es','Madrid','2024-01-10');


INSERT INTO categorias (id_categoria, nombre) VALUES
(10,'Periféricos'),
(11,'Almacenamiento'),
(12,'Redes');



INSERT INTO productos (id_producto, nombre, precio, stock, id_categoria) VALUES
(100,'Teclado mecánico',79.90,15,10),
(101,'Ratón gaming',39.90,40,10),
(102,'SSD 1TB',89.00,20,11),
(103,'Router WiFi 6',129.00,8,12);

INSERT INTO pedidos (id_pedido, id_cliente, fecha, estado, total) VALUES
(500,1,'2024-05-03','PAGADO',119.80),
(501,1,'2024-05-10','PENDIENTE',89.00),
(502,2,'2024-05-12','ENVIADO',129.00),
(503,3,'2024-05-13','CANCELADO',39.90);

INSERT INTO lineas_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(500,100,1,79.90),
(500,101,1,39.90),
(501,102,1,89.00),
(502,103,1,129.00),
(503,101,1,39.90);



-- Consultas de práctica 



-- A) SELECT / WHERE / operadores


-- 1) Clientes de Sevilla
  select * from clientes
  where ciudad='sevilla';
-- 2) Productos con stock bajo (<10)
  select * from productos
  where stock <10;

-- 3) Pedidos entre dos fechas (incluye extremos)
  select * from pedidos
  where fecha BETWEEN '2024-05-01' AND '2024-05-03';

-- 4) Pedidos con estado en lista
  select * from pedidos
  where estado='en lista';

-- 5) Productos cuyo nombre empieza por 'R'
  SELECT * FROM `productos` 
  where nombre like 'R%';

-- 6) Emails que contienen 'correo'
  SELECT * FROM clientes
  where email is not null;

-- 7) Total >= 100 y NO cancelado
  Select * From pedidos
  where total >=100;

-- 8) Productos de categorías 10 o 12 (IN)
  Select * from productos
  where id_categoria in (10,12);

-- 9) Pedidos con total NO en {89,129} (NOT IN)
  Select * from pedidos
  where total not in (89,129);

-- 10) Pedidos PAGADOS o ENVIADOS (OR)
  Select * from pedidos
  where estado like "pagado" 
  or estado like "Enviado";

-- 11) Pedidos NO (PAGADO) (NOT)
  Select * from pedidos
  where estado not like "pagado";

  o

  Select * from pedidos
  where not estado ="PAGADO";

-- 12) Productos con precio entre 40 y 100
  Select * from productos
  where precio BETWEEN 40 AND 100;

-- B) ORDER BY / LIMIT / DISTINCT


-- 13) Productos más caros primero
  Select * from productos
  order by precio DESC;

-- 14) Top 2 productos con menos stock
  Select * from productos
  order by stock asc
  limit 2;

-- 15) Ciudades distintas de clientes
  Select DISTINCT ciudad from clientes;

-- 16) Pedidos: primero los más recientes
  SELECT * FROM `pedidos`
  order by fecha desc;


-- C) Agregadas + GROUP BY + HAVING


-- 17) Número de pedidos por estado
  SELECT estado, Count(*) as NumPedidos FROM `pedidos`
  GROUP by estado;

-- 18) Facturación total por estado (solo estados con total > 100)
  Select estado, sum(total) as Facturacion_Total from pedidos
  where total>100
  group by estado;

-- 19) Precio medio y stock total por categoría (en productos)
  SELECT id_categoria, avg(precio), sum(stock) FROM `productos`
  GROUP by id_categoria;

-- 20) Unidades vendidas por producto (en lineas_pedido)
  SELECT id_producto, count(*) as unidades_vendidas FROM `lineas_pedido`
  GROUP by id_producto;

-- 21) Pedido más caro y más barato (MAX/MIN)
  SELECT MAX(total) AS pedido_mas_caro, MIN(total) AS pedido_mas_barato FROM pedidos;

-- 22) Precio máximo, mínimo y medio de productos
  SELECT 
      max(precio) as Precio_Maximo, 
      min(precio) as Precio_minimo, 
      avg(precio) as Precio_Medio 
  FROM `productos`;

-- 23) Stock total en la tienda
  SELECT sum(stock) as Stock_total FROM `productos`;

-- 24) Estados con 2 o más pedidos (HAVING COUNT)
  SELECT estado, count(*) num_pedidos FROM `pedidos`
  GROUP by estado
  having num_pedidos>2;

  SELECT estado FROM `pedidos`
  GROUP by estado
  having count(*)>1;

-- D) Subconsultas (SIN JOIN): IN / NOT IN / escalares
  

-- 25) Clientes que han hecho algún pedido (IN)
  SELECT * from clientes
  where id_cliente in (select id_cliente from pedidos);

-- 26) Clientes SIN pedidos (NOT IN)
  SELECT * from clientes
  where id_cliente not in (select id_cliente from pedidos);

-- 27) Pedidos por encima de la media del total
  select * from pedidos
  where total>(SELECT avg(total) FROM `pedidos`);

-- 28) Productos que aparecen en alguna línea de pedido
  select * from productos
  where id_producto in (select id_producto from lineas_pedido);

-- 29) Productos que NO aparecen en líneas (nunca vendidos)
  SELECT * FROM productos
  where id_producto not in (select id_producto from lineas_pedido);

-- 30) Pedidos cuyo total es igual al máximo total
  SELECT * FROM `pedidos`
  where total=(select max(total) from pedidos);

-- E) EXISTS / NOT EXISTS (correlacionadas)

-- 31) Clientes que tienen al menos 1 pedido (EXISTS)
  Select * from clientes
  where exists (select * from pedidos
                where clientes.id_cliente=pedidos.id_cliente
                group by pedidos.id_cliente
                having count(*)>=1);

  o

  Select * from clientes
  where exists (select * from pedidos
              where clientes.id_cliente=pedidos.id_cliente);

-- 32) Clientes sin pedidos (NOT EXISTS)
  Select * from clientes
  where not exists (select * from pedidos
              where clientes.id_cliente=pedidos.id_cliente);

-- 33) Pedidos que tienen líneas (EXISTS)
  Select * from pedidos
  where exists (Select * from lineas_pedido
              where lineas_pedido.id_pedido=pedidos.id_pedido);

-- 34) Pedidos que NO tienen líneas (NOT EXISTS) (por si existieran)
  Select * from pedidos
  where not exists (Select * from lineas_pedido
              where lineas_pedido.id_pedido=pedidos.id_pedido);

-- 35) Para cada cliente, número de pedidos (columna calculada)
  select 
	  *,
    ( select count(*) from pedidos
      where pedidos.id_cliente = clientes.id_cliente) as Numero_pedidos
from clientes;

-- 36) Para cada pedido, número de líneas (columna calculada)
  select
    *,
    ( select count(*) from lineas_pedido
      where lineas_pedido.id_pedido = pedidos.id_pedido) as Numero_lineas
  from pedidos;


-- F) Funciones de fecha y texto


-- 37) Clientes dados de alta en 2024 (YEAR)
  select * from clientes
  where YEAR(fecha_alta) = 2024;

-- 38) Pedidos del mes de mayo (MONTH)
  select * from clientes
  where MONTH(fecha_alta) = 5;

-- 39) Emails en mayúsculas (UPPER)
  select upper(email) from clientes;

-- 40) Longitud del nombre del producto (CHAR_LENGTH)
  SELECT 
      nombre, 
      char_length(nombre) as longitudNombre 
  FROM `productos`;


-- F) INSERT / UPDATE / DELETE (PRUEBAS)
-- OJO: Estas sentencias CAMBIAN datos!!!!

-- 41) Insertar un cliente nuevo con todos los atributos
  INSERT INTO clientes (nombre, email, ciudad, fecha_alta) VALUES
  ("Daniel", "d.meco@hotmail.com", "Valencia", "2026-02-18");

-- 42) Subir stock a 25 del producto 103
  UPDATE productos
  SET stock = 25
  where id_producto=103;

-- 43) Rebajar un 10% los productos de precio > 100
  Update `productos`
  Set precio = precio*0.9
  where precio>100;

-- 44) Poner stock a 0 a productos sin ventas (NOT IN)
  UPDATE `productos` 
  SET stock = 0
  where id_producto not in (select id_producto from lineas_pedido);

-- 45) Borrar pedidos cancelados
  DELETE FROM `pedidos` 
  WHERE estado="CANCELADO";

-- 46) Borrar líneas de un pedido concreto
  DELETE FROM lineas_pedido
  WHERE id_pedido = 500;

-- 47) Borrar clientes sin pedidos (siempre que no estén referenciados)
  delete from clientes
  where not exists (select * from pedidos
              where clientes.id_cliente=pedidos.id_cliente);


-- G) ALTER TABLE (estructura) 
-- OJO: Esto MODIFICA la estructura de las tablas!!!!

-- 48) Añadir columna teléfono a clientes
  ALTER TABLE clientes
  add telefono varchar(20);

-- 49) Cambiar longitud del nombre en productos
  ALTER TABLE productos
  modify  nombre VARCHAR(85)  NOT NULL;

-- 50) Renombrar columna total -> total_eur 
  ALTER TABLE pedidos
  change total total_eur DECIMAL(10,2) NOT NULL DEFAULT 0.00;





