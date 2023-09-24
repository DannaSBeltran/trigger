create database triggers_;
use triggers_;


CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(15),
    direccion VARCHAR(100)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    stock INT
);

CREATE TABLE Categorias_Productos (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50)
);

CREATE TABLE Carrito_Compras (
    id_carrito INT PRIMARY KEY,
    id_cliente INT,
    fecha_compra DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Detalle_Compras (
    id_detalle INT PRIMARY KEY,
    id_carrito INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (id_carrito) REFERENCES Carrito_Compras(id_carrito),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);
INSERT INTO Clientes (id_cliente, nombre, apellido, telefono, direccion)
VALUES
    (1, 'Jose', 'Sanchez', '123-456', '123 Plaza de bolivar'),
    (2, 'Mariana', 'Soler', '-789-101', '456 Avenida 30');
    INSERT INTO Productos (id_producto, nombre, precio, stock)
VALUES
    (1, 'Galletas', 5000,   110),
    (2, 'Dulces', 3200,     100),
    (3, 'Cafe', 7500,       205);
    
    
    INSERT INTO Categorias_Productos (id_categoria, nombre_categoria)
VALUES
    (1, 'Confinteria'),
    (2, 'Cafeteria'),
    (3, 'Panaderia');
INSERT INTO Carrito_Compras (id_carrito, id_cliente, fecha_compra)
VALUES
    (1, 1, '2023-01-26'),
    (2, 2, '2022-10-13');
    INSERT INTO Detalle_Compras (id_detalle, id_carrito, id_producto, cantidad, subtotal)
VALUES
    (1, 1, 1, 3, 15000),
    (2, 1, 2, 2, 6400);
    
    DELIMITER //
CREATE TRIGGER actualizar_inventario after INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
  DECLARE cantidad INT;
  
  SET cantidad = NEW.cantidad;
  
  UPDATE Productos SET stock = stock - cantidad WHERE id_producto = NEW.id_producto;
  
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER calcular_valor_factura
AFTER INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    DECLARE subtotal_dec DECIMAL(10, 2);
    DECLARE total_dec DECIMAL(10, 2);
    
    SELECT subtotal INTO subtotal_dec FROM Detalle_Compras WHERE id_detalle = NEW.id_detalle;
    
    SET total_dec = subtotal_dec * 1.19;
    
    UPDATE Detalle_Compras SET total = total_dec WHERE id_detalle = NEW.id_detalle;
    
    UPDATE Carrito_Compras SET total = total + total_dec WHERE id_carrito = NEW.id_carrito;
END //
DELIMITER ;

SELECT*FROM Clientes;
SELECT*FROM Productos;
SELECT*FROM Categorias_Productos;
SELECT*FROM Detalle_Compras;

INSERT INTO Detalle_Compras (id_detalle, id_carrito, id_producto, cantidad, subtotal) VALUES
(2, 2, 3, 1, 7500);
    