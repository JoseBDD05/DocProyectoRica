-- VISTA PARA VENTAS MENSUALES Y ANUALES
CREATE VIEW vwVentasMensualesAnuales
AS
	SELECT 	v.CVE_VENTAS AS Clave,
			v.VEN_FECHA AS Fecha,
            s.SKU_NOMBRE_COMERCIAL AS NombreComercial,
			v.VEN_CANTIDAD AS CantidadVendida,
            v.VEN_PRECIO_UNITARIO AS PrecioUnitario,
            v.VEN_COSTO_UNITARIO AS CostoUnitario,
            p.CATE_NOMBRE AS ProductoBase,
            v.VEN_TOTAL_VENTA AS VentaTotal,
            concat(c.CVE_CANAL, '-', c.VEN_TIPO_DESCRIPCION ) AS CanalVenta
	FROM  ventas v, catalogo_sku s, categoria_productos p, canal_venta c;
    
    -- VISTA PARA CATALOGO DE CADA PRODUCTO COCA COLA
CREATE VIEW vwCatalogoProductos
AS
	SELECT 	t.CVE_CATALOGO AS Clave,
			t.CATA_NOMBRE AS Nombre,
            p.CATE_NOMBRE AS Categoria,
			t.CATA_PRECIO AS PrecioUnitario,
            t.CATA_CODIGO_BARRAS AS CodigoBarras
	FROM  catalogo_productos t, categoria_productos p;
    
    
    -- VISTA PARA CATALOGO SKU DE LA VISTA PRINCIPAL
CREATE VIEW vwCatalogoSku
AS
	SELECT 	s.CVE_SKU AS Clave,
			s.SKU_NUMERO AS NumeroSKU,
            s.SKU_NOMBRE_COMERCIAL AS NombreComercial,
			p.CATE_NOMBRE AS ProductoBase,
            s.SKU_VOLUMEN_ML AS VolumenML,
            s.SKU_EMPAQUETADO AS EmpaquetadoProducto,
            t.CATA_PRECIO AS PrecioUnitario,
            t.CATA_CODIGO_BARRAS AS CodigoBarras,
            concat(c.CVE_CANAL, '-', c.VEN_TIPO_DESCRIPCION ) AS CanalVenta,
            s.SKU_STOCK AS StockProducto,
            s.SKU_RUTAIMAGEN AS ImagenProducto
	FROM  catalogo_sku s, catalogo_productos t, categoria_productos p, canal_venta c;
-- -------------------------------------------------------------------------------