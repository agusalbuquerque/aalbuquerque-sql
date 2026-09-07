USE Ventas_Tech_DB;
GO

-- =====================================================
-- CONSULTA 1 - VISTA BASE DEL PROYECTO
-- INNER JOIN
-- =====================================================

SELECT
    v.fecha_venta AS Fecha,
    c.id_cliente AS ID_Cliente,
    c.nombre AS Nombre_Cliente,
    c.email AS Email_Cliente,
    c.ciudad AS Ciudad,
    p.id_producto AS ID_Producto,
    p.nombre_producto AS Producto,
    cat.nombre_categoria AS Categoria,
    v.cantidad AS Cantidad,
    v.precio_unitario AS Precio_Unitario,
    (v.cantidad * v.precio_unitario) AS Total_Venta
FROM dbo.ventas AS v
INNER JOIN dbo.clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- =====================================================
-- CONSULTA 2 - CLIENTES SIN VENTAS
-- LEFT JOIN
-- =====================================================

SELECT
    c.nombre AS Nombre_Cliente,
    c.email AS Email,
    c.fecha_registro AS Fecha_Registro
FROM dbo.clientes AS c
LEFT JOIN dbo.ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS  NULL;

-- =====================================================
-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- LEFT JOIN
-- =====================================================

SELECT
    p.nombre_producto AS Producto,
    cat.nombre_categoria AS Categoria,
    p.precio AS Precio
FROM dbo.productos AS p
INNER JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- =====================================================
-- CONSULTA 4 - CONSOLIDADO POR ORIGEN
-- UNION ALL
-- =====================================================

SELECT
    canal,
    SUM(total) AS Total_Facturado
FROM (

    SELECT
        fecha_venta AS fecha,
        (cantidad * precio_unitario) AS total,
        'Periodo 05-10 Marzo' AS canal
    FROM dbo.ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        (cantidad * precio_unitario) AS total,
        'Periodo 11-15 Marzo' AS canal
    FROM dbo.ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'

) AS ventas_consolidadas

GROUP BY canal
ORDER BY canal;
