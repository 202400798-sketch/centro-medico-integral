SELECT
    d.nombre AS diagnostico,
    COUNT(h.id_hospitalizacion) AS total_hospitalizaciones,
    ROUND(
        AVG(h.fecha_alta - h.fecha_ingreso),
        2
    ) AS promedio_dias_estancia
FROM hospital.hospitalizacion h
JOIN hospital.hospitalizacion_diagnostico hd
    ON h.id_hospitalizacion = hd.id_hospitalizacion
JOIN hospital.diagnostico d
    ON hd.id_diagnostico = d.id_diagnostico
WHERE hd.tipo_diagnostico = 'Principal'
  AND h.fecha_ingreso BETWEEN DATE '2025-01-01'
                          AND DATE '2026-12-31'
GROUP BY d.nombre
ORDER BY promedio_dias_estancia DESC;
