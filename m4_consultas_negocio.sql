USE Ventas_Tech_DB;
GO

-- =====================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio
-- =====================================================

SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado,
    COUNT(*) AS Cantidad_Pedidos,
    AVG(cantidad * precio_unitario) AS Ticket_Promedio
FROM dbo.ventas
EXTRACT GROUP BY MONTH(fecha_venta);


-- =====================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Top 5 productos por total facturado
-- =====================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS Unidades_Vendidas,
    SUM(cantidad * precio_unitario) AS Total_Generado
FROM dbo.ventas
GROUP BY id_producto
ORDER BY Total_Generado DESC;


-- =====================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- Clientes que realizaron más de un pedido
-- =====================================================

SELECT
    id_cliente,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(cantidad * precio_unitario) AS Total_Gastado
FROM dbo.ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;


-- =====================================================
-- CONSULTA 4 - MESES POR ENCIMA / DEBAJO DEL PROMEDIO
-- =====================================================

SELECT
    Mes,
    Total_Facturado,
    Promedio_General,
    CASE
        WHEN Total_Facturado > Promedio_General THEN 'Por encima'
        WHEN Total_Facturado < Promedio_General THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS Comparacion_Promedio
FROM (
    SELECT
        MONTH(fecha_venta) AS Mes,
        SUM(cantidad * precio_unitario) AS Total_Facturado,
        AVG(SUM(cantidad * precio_unitario)) OVER () AS Promedio_General
    FROM dbo.ventas
    GROUP BY MONTH(fecha_venta)
) AS Resumen_Mensual
ORDER BY mes;


-- =====================================================
-- HALLAZGOS
-- =====================================================

-- 1. El producto 1 es el producto con mayor facturación,
--    generando $3.600 sobre un total de $6.444, es decir
--    que concentra casi el 56% de la facturación total.

-- 2. Los cinco clientes realizaron más de un pedido,
--    por lo que todos califican como clientes recurrentes.
--    Asimismo, los clientes 1 y 5 presentan un gasto
--    considerablemente superior al resto de los clientes.

-- 3. Todas las ventas cargadas corresponden a marzo de 2024,
--    por lo que todavía no es posible realizar una comparación
--    significativa entre distintos meses. 