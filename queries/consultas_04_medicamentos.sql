SELECT
    m.nombre AS medicamento,
    m.tipo,
    COUNT(dr.id_detalle) AS veces_recetadas,
    SUM(dr.cantidad) AS unidades_prescritas
FROM hospital.detalle_receta dr
JOIN hospital.medicamento m
    ON dr.id_medicamento = m.id_medicamento
JOIN hospital.receta r
    ON dr.id_receta = r.id_receta
GROUP BY
    m.id_medicamento,
    m.nombre,
    m.tipo
ORDER BY
    veces_recetadas DESC;
