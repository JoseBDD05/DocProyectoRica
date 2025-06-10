CREATE DATABASE TERRITORIO_RICA;
USE TERRITORIO_RICA;
-- -------------------------------------------------------------------------------
CREATE TABLE USUARIO
(
USU_CVE_USUARIO		INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
USU_NOMBRE		VARCHAR(30) 	NOT NULL,
USU_APELLIDO_PATERNO	VARCHAR(30) 	NOT NULL,
USU_APELLIDO_MATERNO	VARCHAR(30) 	NOT NULL,
USU_EDAD	INT	NOT NULL,
USU_CORREO		VARCHAR(40) 	NOT NULL,
USU_USUARIO		VARCHAR(30) 	NOT NULL,
USU_CONTRASENA		VARCHAR(20) 	NOT NULL,
USU_TELEFONO		VARCHAR(10) 	NOT NULL,
USU_RUTAIMAGEN		VARCHAR(200) 	NOT NULL,
CVE_ZONA_ASIGNADA	INT 		NOT NULL,
FOREIGN KEY (CVE_ZONA_ASIGNADA) REFERENCES ZONA_ASIGNADA(CVE_ZONA_ASIGNADA) 
);
-- -------------------------------------------------------------------------------
CREATE TABLE ZONA_ASIGNADA
(
CVE_ZONA_ASIGNADA	INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
TIPO_DESCRIPCION		VARCHAR(100) 	NOT NULL
);
-- -------------------------------------------------------------------------------
CREATE TABLE GERENTE
(
GER_CVE_GERENTE		INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
GER_NOMBRE		VARCHAR(30) 	NOT NULL,
GER_APELLIDO_PATERNO	VARCHAR(30) 	NOT NULL,
GER_APELLIDO_MATERNO	VARCHAR(30) 	NOT NULL,
GER_EDAD	INT	NOT NULL,
GER_CORREO		VARCHAR(40) 	NOT NULL,
GER_USUARIO		VARCHAR(30) 	NOT NULL,
GER_CONTRASENA		VARCHAR(20) 	NOT NULL,
GER_TELEFONO		VARCHAR(10) 	NOT NULL,
GER_NSS		VARCHAR(30) 	NOT NULL,
GER_CURP		VARCHAR(30) 	NOT NULL,
GER_RFC		VARCHAR(30) 	NOT NULL,
GER_RUTAIMAGEN		VARCHAR(200) 	NOT NULL,
CVE_AREA_TRABAJO	INT 		NOT NULL,
FOREIGN KEY (CVE_AREA_TRABAJO) REFERENCES AREA_TRABAJO(CVE_AREA_TRABAJO) 
);
-- -------------------------------------------------------------------------------
CREATE TABLE AREA_TRABAJO
(
CVE_AREA_TRABAJO	INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
TRA_TIPO_DESCRIPCION		VARCHAR(100) 	NOT NULL
);
-- -------------------------------------------------------------------------------
CREATE TABLE CATEGORIA_PRODUCTOS
(
CVE_CATEGORIA	INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
CATE_NOMBRE		VARCHAR(50) 	NOT NULL,
CATE_TIPO_DESCRIPCION		VARCHAR(100) 	NOT NULL
);
-- -------------------------------------------------------------------------------
CREATE TABLE CATALOGO_PRODUCTOS
(
CVE_CATALOGO	INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
CATA_NOMBRE		VARCHAR(50) 	NOT NULL,
CVE_CATEGORIA	INT 		NOT NULL,
CATA_PRECIO		DECIMAL(4, 2) 	NOT NULL,

CATA_CODIGO_BARRAS		VARCHAR(12) 	NOT NULL,
FOREIGN KEY (CVE_CATEGORIA) REFERENCES CATEGORIA_PRODUCTOS(CVE_CATEGORIA) 
);
-- -------------------------------------------------------------------------------
CREATE TABLE CANAL_VENTA
(
CVE_CANAL INT 		NOT NULL	PRIMARY KEY AUTO_INCREMENT,
VEN_TIPO_DESCRIPCION		VARCHAR(100) 	NOT NULL
);
-- -------------------------------------------------------------------------------
CREATE TABLE CATALOGO_SKU (
    CVE_SKU INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    SKU_NUMERO VARCHAR(12) NOT NULL,
    SKU_NOMBRE_COMERCIAL VARCHAR(50) NOT NULL,
    CVE_CATEGORIA INT NOT NULL,
    SKU_VOLUMEN_ML INT NOT NULL,
    SKU_EMPAQUETADO VARCHAR(100) NOT NULL,
    CVE_CATALOGO INT NOT NULL,
    CVE_CANAL INT NOT NULL,
    SKU_STOCK INT NOT NULL,
    SKU_RUTAIMAGEN VARCHAR(200) 	NOT NULL,
    FOREIGN KEY (CVE_CATEGORIA) REFERENCES CATEGORIA_PRODUCTOS(CVE_CATEGORIA),
    FOREIGN KEY (CVE_CATALOGO) REFERENCES CATALOGO_PRODUCTOS(CVE_CATALOGO),
    FOREIGN KEY (CVE_CANAL) REFERENCES CANAL_VENTA(CVE_CANAL)
);
-- -------------------------------------------------------------------------------
CREATE TABLE VENTAS
(
CVE_VENTAS INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
VEN_FECHA DATE,
CVE_SKU INT NOT NULL,
CVE_CATEGORIA INT NOT NULL,
VEN_CANTIDAD INT NOT NULL,
VEN_PRECIO_UNITARIO DECIMAL(4, 2) 	NOT NULL,
VEN_COSTO_UNITARIO DECIMAL(4, 2) 	NOT NULL,
CVE_CANAL INT NOT NULL,
VEN_TOTAL_VENTA DECIMAL(10, 2) 	NOT NULL,
FOREIGN KEY (CVE_SKU) REFERENCES CATALOGO_SKU(CVE_SKU),
FOREIGN KEY (CVE_CANAL) REFERENCES CANAL_VENTA(CVE_CANAL),
FOREIGN KEY (CVE_CATEGORIA) REFERENCES CATEGORIA_PRODUCTOS(CVE_CATEGORIA)
);
-- -------------------------------------------------------------------------------
-- VISTA PARA LISTADO DE TIPO DE ZONAS ASIGNADAS EN LOS USUARIOS
CREATE VIEW vwZonaAsignada
AS
	SELECT 	z.CVE_ZONA_ASIGNADA AS Clave,
		concat(z.CVE_ZONA_ASIGNADA, '-', z.TIPO_DESCRIPCION ) AS Descripcion
	FROM   	zona_asignada z;
-- -------------------------------------------------------------------------------

-- VISTA PARA LISTADO DE TIPO DE AREAS DE TRABAJO PARA LOS DE VENTAS / GERENTES
CREATE VIEW vwAreaTrabajo
AS
	SELECT 	a.CVE_AREA_TRABAJO AS Clave,
		concat(a.CVE_AREA_TRABAJO, '-', a.TRA_TIPO_DESCRIPCION ) AS Descripcion
	FROM   	area_trabajo a;
-- -------------------------------------------------------------------------------

-- VISTA PARA LISTADO DE TIPOS DE CANAL DE VENTAS
CREATE VIEW vwCanalVentas
AS
	SELECT 	c.CVE_CANAL AS Clave,
		concat(c.CVE_CANAL, '-', c.VEN_TIPO_DESCRIPCION ) AS Descripcion
	FROM  canal_venta c;
-- -------------------------------------------------------------------------------

-- VISTA PARA CATEGORIA DE CADA PRODUCTO COCA COLA
CREATE VIEW vwCategoriaProductos
AS
	SELECT 	p.CVE_CATEGORIA AS Clave,
			p.CATE_NOMBRE AS Nombre,
		concat(p.CVE_CATEGORIA, '-', p.CATE_TIPO_DESCRIPCION ) AS Descripcion
	FROM  categoria_productos p;
-- -------------------------------------------------------------------------------

-- VISTA PARA CATALOGO DE CADA PRODUCTO COCA COLA
CREATE OR REPLACE VIEW vwCatalogoProductos AS
SELECT  
    t.CVE_CATALOGO AS Clave,
    t.CATA_NOMBRE AS Nombre,
    p.CATE_NOMBRE AS Categoria,
    t.CATA_PRECIO AS PrecioUnitario,
    t.CATA_CODIGO_BARRAS AS CodigoBarras
FROM  
    catalogo_productos t
    INNER JOIN categoria_productos p ON t.CVE_CATEGORIA = p.CVE_CATEGORIA;

-- -------------------------------------------------------------------------------

-- VISTA PARA CATALOGO SKU DE LA VISTA PRINCIPAL
CREATE OR REPLACE VIEW vwCatalogoSku AS
SELECT  
    s.CVE_SKU AS Clave,
    s.SKU_NUMERO AS NumeroSKU,
    s.SKU_NOMBRE_COMERCIAL AS NombreComercial,
    p.CATE_NOMBRE AS ProductoBase,
    s.SKU_VOLUMEN_ML AS VolumenML,
    s.SKU_EMPAQUETADO AS EmpaquetadoProducto,
    t.CATA_PRECIO AS PrecioUnitario,
    t.CATA_CODIGO_BARRAS AS CodigoBarras,
    CONCAT(c.CVE_CANAL, '-', c.VEN_TIPO_DESCRIPCION) AS CanalVenta,
    s.SKU_STOCK AS StockProducto,
    s.SKU_RUTAIMAGEN AS ImagenProducto
FROM  
    catalogo_sku s
    INNER JOIN catalogo_productos t ON s.CVE_CATALOGO = t.CVE_CATALOGO
    INNER JOIN categoria_productos p ON s.CVE_CATEGORIA = p.CVE_CATEGORIA
    INNER JOIN canal_venta c ON s.CVE_CANAL = c.CVE_CANAL;
-- -------------------------------------------------------------------------------

-- VISTA PARA VENTAS MENSUALES Y ANUALES
CREATE OR REPLACE VIEW vwVentasMensualesAnuales AS
SELECT  
    v.CVE_VENTAS AS Clave,
    v.VEN_FECHA AS Fecha,
    YEAR(v.VEN_FECHA) AS Anio,
    MONTH(v.VEN_FECHA) AS Mes,
    s.SKU_NOMBRE_COMERCIAL AS NombreComercial,
    v.VEN_CANTIDAD AS CantidadVendida,
    v.VEN_PRECIO_UNITARIO AS PrecioUnitario,
    v.VEN_COSTO_UNITARIO AS CostoUnitario,
    p.CATE_NOMBRE AS ProductoBase,
    v.VEN_TOTAL_VENTA AS VentaTotal,
    CONCAT(c.CVE_CANAL, '-', c.VEN_TIPO_DESCRIPCION) AS CanalVenta
FROM  
    ventas v
    INNER JOIN catalogo_sku s ON v.CVE_SKU = s.CVE_SKU
    INNER JOIN categoria_productos p ON v.CVE_CATEGORIA = p.CVE_CATEGORIA
    INNER JOIN canal_venta c ON v.CVE_CANAL = c.CVE_CANAL;

-- -------------------------------------------------------------------------------
-- Ventas totales por mes
SELECT Anio, Mes, SUM(VentaTotal) AS TotalMensual
FROM vwVentasMensualesAnuales
GROUP BY Anio, Mes
ORDER BY Anio, Mes;

-- -------------------------------------------------------------------------------
-- Utilidad bruta por producto
SELECT NombreComercial,
       SUM(VentaTotal - (CantidadVendida * CostoUnitario)) AS UtilidadBruta
FROM vwVentasMensualesAnuales
GROUP BY NombreComercial;

-- -------------------------------------------------------------------------------
-- GENERAR UNA PROCEDIMIENTO ALMACENADO PARA VALIDAR UN CONTROL DE ACCESO (USUARIO Y CONTRASEÑA)
DELIMITER $$
CREATE PROCEDURE spValidarAcceso (
    IN usuario VARCHAR(30),
    IN contrasena VARCHAR(20)
)
BEGIN
    -- Buscar en tabla USUARIO
    IF EXISTS (
        SELECT 1
        FROM USUARIO u
        WHERE u.USU_USUARIO = usuario AND u.USU_CONTRASENA = contrasena
    ) THEN
        SELECT 
            '1' AS Resultado,
            CONCAT(u.USU_NOMBRE, ' ', u.USU_APELLIDO_PATERNO, ' ', u.USU_APELLIDO_MATERNO) AS NombreCompleto,
            '' AS Ruta, -- Suponiendo que esta columna aplica solo a usuarios
            u.USU_USUARIO AS Usuario,
            'Usuario' AS Tipo
        FROM USUARIO u
        WHERE u.USU_USUARIO = usuario AND u.USU_CONTRASENA = contrasena;

    -- Buscar en tabla GERENTE
    ELSEIF EXISTS (
        SELECT 1
        FROM GERENTE g
        WHERE g.GER_USUARIO = usuario AND g.GER_CONTRASENA = contrasena
    ) THEN
        SELECT 
            '1' AS Resultado,
            CONCAT(g.GER_NOMBRE, ' ', g.GER_APELLIDO_PATERNO, ' ', g.GER_APELLIDO_MATERNO) AS NombreCompleto,
            '' AS Ruta, -- No hay ruta para gerente
            g.GER_USUARIO AS Usuario,
            'Gerente' AS Tipo
        FROM GERENTE g
        WHERE g.GER_USUARIO = usuario AND g.GER_CONTRASENA = contrasena;

    -- No encontrado
    ELSE
        SELECT '0' AS Resultado, '' AS NombreCompleto, '' AS Ruta, '' AS Usuario, '' AS Tipo;
    END IF;
END $$
DELIMITER ;


-- SECCION DE PRUEBAS
call spValidarAcceso('lbell', 'itic2025');
call spValidarAcceso('lppppp', 'itic2025');


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO PARA ALTA DE USUARIOS
--     1. NO SE PUEDE REGISTRAR UN USUARIO EXACTAMENTE CON EL MISMO NOMBRE, AP. PATERNO Y AP. MATERNO
--     2. NO SE PUEDE REGISTRAR UN USUARIO (USU_USUARIO) YA EXISTA
--     3. LA LLAVE FORANEA (CVE_ZONA_ASIGNADA) EXISTA EN SU TABLA CATALOGO
--     4. NOMBRE DEL PROCEDIMIENTO: spInsUsuario

DELIMITER $$
CREATE PROCEDURE spInsUsuario
(
	IN nombre		VARCHAR(30),
	IN paterno		VARCHAR(30),
	IN materno		VARCHAR(30),
	IN edad			INT,
	IN correo		VARCHAR(40),
	IN usuario		VARCHAR(30),
	IN contrasena	VARCHAR(20),
	IN telefono		VARCHAR(10),
	IN rutaImagen	VARCHAR(200),
	IN zonaAsignada	INT
)
BEGIN
	-- 1ERA VALIDACION: Validar que no exista un usuario con mismo nombre completo
	IF NOT EXISTS (
		SELECT 1
		FROM USUARIO
		WHERE USU_NOMBRE = nombre
		  AND USU_APELLIDO_PATERNO = paterno
		  AND USU_APELLIDO_MATERNO = materno
	) THEN

		-- 2DA VALIDACION: Validar que no exista el mismo nombre de usuario
		IF NOT EXISTS (
			SELECT 1
			FROM USUARIO
			WHERE USU_USUARIO = usuario
		) THEN

			-- 3ERA VALIDACION: Verificar que exista la zona asignada
			IF EXISTS (
				SELECT 1
				FROM ZONA_ASIGNADA
				WHERE CVE_ZONA_ASIGNADA = zonaAsignada
			) THEN

				-- INSERTAR NUEVO USUARIO
				INSERT INTO USUARIO (
					USU_NOMBRE, USU_APELLIDO_PATERNO, USU_APELLIDO_MATERNO,
					USU_EDAD, USU_CORREO, USU_USUARIO, USU_CONTRASENA,
					USU_TELEFONO, USU_RUTAIMAGEN, CVE_ZONA_ASIGNADA
				)
				VALUES (
					nombre, paterno, materno, edad, correo, usuario, contrasena,
					telefono, rutaImagen, zonaAsignada
				);

				SELECT '0' AS Resultado; -- Éxito

			ELSE
				SELECT '3' AS Resultado; -- Zona asignada no existe
			END IF;

		ELSE
			SELECT '2' AS Resultado; -- Usuario ya registrado
		END IF;

	ELSE
		SELECT '1' AS Resultado; -- Usuario con mismo nombre completo ya existe
	END IF;
END $$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SECCION DE PRUEBAS


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO PARA EDITAR LA INFORMACION DE USUARIOS
DELIMITER $$
CREATE PROCEDURE spUpdUsuario
(
	IN clave			INT,
	IN nombre			VARCHAR(30),
	IN paterno			VARCHAR(30),
	IN materno			VARCHAR(30),
	IN edad				INT,
	IN correo			VARCHAR(40),
	IN usuario			VARCHAR(30),
	IN contrasena		VARCHAR(20),
	IN telefono			VARCHAR(10),
	IN rutaImagen		VARCHAR(200),
	IN zonaAsignada		INT
)
BEGIN
	-- 1ERA VALIDACIÓN: ¿Existe el usuario con la clave?
	IF EXISTS (
		SELECT 1 FROM USUARIO WHERE USU_CVE_USUARIO = clave
	) THEN

		-- 2DA VALIDACIÓN: ¿Existe otro usuario con el mismo nombre completo?
		IF NOT EXISTS (
			SELECT 1 FROM USUARIO 
			WHERE USU_NOMBRE = nombre 
			  AND USU_APELLIDO_PATERNO = paterno 
			  AND USU_APELLIDO_MATERNO = materno
			  AND USU_CVE_USUARIO <> clave
		) THEN

			-- 3ERA VALIDACIÓN: ¿Existe otro con el mismo nombre de usuario?
			IF NOT EXISTS (
				SELECT 1 FROM USUARIO 
				WHERE USU_USUARIO = usuario
				AND USU_CVE_USUARIO <> clave
			) THEN

				-- 4TA VALIDACIÓN: ¿Existe la zona asignada?
				IF EXISTS (
					SELECT 1 FROM ZONA_ASIGNADA 
					WHERE CVE_ZONA_ASIGNADA = zonaAsignada
				) THEN

					-- ✅ ACTUALIZAR
					UPDATE USUARIO SET 
						USU_NOMBRE = nombre,
						USU_APELLIDO_PATERNO = paterno,
						USU_APELLIDO_MATERNO = materno,
						USU_EDAD = edad,
						USU_CORREO = correo,
						USU_USUARIO = usuario,
						USU_CONTRASENA = contrasena,
						USU_TELEFONO = telefono,
						USU_RUTAIMAGEN = rutaImagen,
						CVE_ZONA_ASIGNADA = zonaAsignada
					WHERE USU_CVE_USUARIO = clave;

					SELECT '0' AS Resultado; -- Éxito

				ELSE
					SELECT '4' AS Resultado; -- Zona asignada no existe
				END IF;

			ELSE
				SELECT '3' AS Resultado; -- Nombre de usuario ya existe
			END IF;

		ELSE
			SELECT '2' AS Resultado; -- Nombre completo ya registrado
		END IF;

	ELSE
		SELECT '1' AS Resultado; -- Usuario con esa clave no existe
	END IF;
END $$
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERCIONES DE DATOS EN CADA TABLA
INSERT INTO ZONA_ASIGNADA (TIPO_DESCRIPCION)
VALUES
('Morelos'),
('Hidalgo'),
('Puebla');

INSERT INTO AREA_TRABAJO (TRA_TIPO_DESCRIPCION)
VALUES
('Ventas'),
('Marketing'),
('Logística');


INSERT INTO USUARIO (
    USU_NOMBRE, USU_APELLIDO_PATERNO, USU_APELLIDO_MATERNO,
    USU_EDAD, USU_CORREO, USU_USUARIO, USU_CONTRASENA,
    USU_TELEFONO, USU_RUTAIMAGEN, CVE_ZONA_ASIGNADA)
VALUES (
    'Carlos', 'Ramírez', 'López', 29, 'carlos.ramirez@coca.com',
    'cramirez', 'rica245@', '5559876543', 'img/usuario_carlos.jpg', 1
);

INSERT INTO GERENTE (
    GER_NOMBRE, GER_APELLIDO_PATERNO, GER_APELLIDO_MATERNO,
    GER_EDAD, GER_CORREO, GER_USUARIO, GER_CONTRASENA,
    GER_TELEFONO, GER_NSS, GER_CURP, GER_RFC,
    GER_RUTAIMAGEN, CVE_AREA_TRABAJO)
VALUES (
    'Laura', 'Pérez', 'González', 42, 'laura.perez@coca.com',
    'lperez', 'ricaven32', '5551234567', '12345678901',
    'PEGL840101HMCRRS09', 'PEG840101KL3', 'img/gerente_laura.jpg', 1
);

INSERT INTO CATEGORIA_PRODUCTOS (CATE_NOMBRE, CATE_TIPO_DESCRIPCION)
VALUES
('Refrescos', 'Refrescos de la familia Coca Cola para consumo personal y familiar'),
('Refrescos de Sabores / Frutales', 'Bebidas con sabores frutales, enfocadas en un público joven o para acompañar alimentos.'),
('Bebidas de Té e Infusiones', 'Bebidas que combinan té, frutas y hierbas, generalmente sin gas.'),
('Lácteos y Alternativas Vegetales', 'Productos basados en leche o bebidas vegetales, centrados en nutrición e ingredientes naturales.'),
('Café y Bebidas Calientes', 'Bebidas basadas en café, enfocadas en calidad y experiencia gourmet.'),
('Aguas y Bebidas Funcionales', 'Productos diseñados para hidratación simple o con beneficios funcionales adicionales.');

INSERT INTO CATALOGO_PRODUCTOS (CATA_NOMBRE, CVE_CATEGORIA, CATA_PRECIO, CATA_CODIGO_BARRAS)
VALUES 
('Coca-Cola Original', 8, 22.00, '000000000001'),
('Coca-Cola Sin Azúcar', 8, 23.00, '000000000002'),
('Coca-Cola Light', 8, 25.00, '000000000003'),
('Mundet', 9, 20.00, '000000000004'),
('Sprite', 9, 21.00, '000000000005'),
('Fanta', 9, 22.00, '000000000006'),
('Fresca', 9, 22.00, '000000000007'),
('Santa Clara', 10, 30.00, '000000000008'),
('AdeS', 11, 35.00, '000000000009'),
('Fuze Tea', 10, 25.00, '000000000010'),
('Topo Chico', 13, 25.00, '000000000011'),
('Costa Coffee', 12, 25.00, '000000000012'),
('Flashlyte', 13, 25.00, '000000000013');

INSERT INTO CANAL_VENTA (VEN_TIPO_DESCRIPCION)
VALUES 
('Tiendas de autoservicio'),
('Canal tradicional'),
('Tiendas en línea');

INSERT INTO CATALOGO_SKU (
    SKU_NUMERO, SKU_NOMBRE_COMERCIAL, CVE_CATEGORIA,
    SKU_VOLUMEN_ML, SKU_EMPAQUETADO, CVE_CATALOGO,
    CVE_CANAL, SKU_STOCK, SKU_RUTAIMAGEN)
VALUES
('SKU0001', 'Coca-Cola Original', 8, 600, 'Botella PET', 14, 1, 1000, 'img/coca_original.jpg'),
('SKU0002', 'Coca-Cola Sin Azúcar', 8, 600, 'Botella PET', 15, 1, 10000, 'img/coca_zero.jpg'),
('SKU0003', 'Coca-Cola Light', 8, 600, 'Botella PET', 16, 1, 1600, 'img/coca_light.jpg'),
('SKU0004', 'Mundet Manzana', 9, 600, 'Botella PET', 17, 2, 1200, 'img/mundet.jpg'),
('SKU0005', 'Sprite', 9, 600, 'Botella PET', 18, 2, 800, 'img/sprite.jpg'),
('SKU0006', 'Fanta Naranja', 9, 600, 'Botella PET', 19, 2, 900, 'img/fanta.jpg'),
('SKU0007', 'Fresca Citrus', 9, 600, 'Botella PET', 20, 1, 900, 'img/fresca.jpg'),
('SKU0008', 'Leche Santa Clara', 10, 1000, 'Tetra Pak', 21, 3, 700, 'img/santa_clara.jpg'),
('SKU0009', 'AdeS Almendra', 11, 946, 'Tetra Pak', 22, 3, 600, 'img/ades.jpg'),
('SKU0010', 'Fuze Tea Durazno', 10, 600, 'Botella PET', 23, 3, 850, 'img/fuze_tea.jpg'),
('SKU0011', 'Topo Chico', 13, 500, 'Botella PET', 24, 2, 750, 'img/topo_chico.jpg'),
('SKU0012', 'Costa Coffee', 12, 240, 'Lata', 25, 3, 500, 'img/costa_coffee.jpg'),
('SKU0013', 'Flashlyte Hidratante', 13, 500, 'Botella PET', 26, 2, 900, 'img/flashlyte.jpg');


INSERT INTO VENTAS (
    VEN_FECHA, CVE_SKU, CVE_CATEGORIA, VEN_CANTIDAD,
    VEN_PRECIO_UNITARIO, VEN_COSTO_UNITARIO, CVE_CANAL, VEN_TOTAL_VENTA)
VALUES
('2025-06-01', 1, 8, 100, 22.00, 15.00, 1, 2200.00),
('2025-06-02', 2, 8, 80, 23.00, 15.00, 1, 1840.00),
('2025-06-02', 4, 9, 50, 20.00, 12.00, 2, 1000.00),
('2025-06-03', 7, 9, 120, 22.00, 14.50, 1, 2640.00),
('2025-06-04', 10, 10, 60, 25.00, 15.00, 2, 1500.00);

