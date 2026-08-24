SELECT
    e.nombre AS especialidad,
    COUNT(h.id_hospitalizacion) AS total_hospitalizaciones,
    AVG(h.fecha_alta - h.fecha_ingreso) AS promedio_dias_estancia
FROM hospital.hospitalizacion h
JOIN hospital.medico m
    ON h.id_medico = m.id_medico
JOIN hospital.especialidad e
    ON m.id_especialidad = e.id_especialidad
WHERE h.fecha_ingreso >= DATE '2025-01-01'
GROUP BY e.nombre
ORDER BY total_hospitalizaciones DESC;


SELECT COUNT(*) AS hospitalizaciones_sin_diagnostico
FROM hospital.hospitalizacion h
LEFT JOIN hospital.hospitalizacion_diagnostico hd
    ON h.id_hospitalizacion = hd.id_hospitalizacion
WHERE hd.id_hospitalizacion IS NULL;
