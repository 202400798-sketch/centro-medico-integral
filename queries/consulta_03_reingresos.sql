SELECT
    p.id_paciente,
    p.nombre,
    p.apellido,
    h1.id_hospitalizacion AS hospitalizacion_inicial,
    h1.fecha_alta AS fecha_alta_inicial,
    h2.id_hospitalizacion AS reingreso,
    h2.fecha_ingreso AS fecha_reingreso,
    (h2.fecha_ingreso - h1.fecha_alta) AS dias_entre_eventos
FROM hospital.paciente p
JOIN hospital.hospitalizacion h1
    ON p.id_paciente = h1.id_paciente
JOIN hospital.hospitalizacion h2
    ON p.id_paciente = h2.id_paciente
   AND h2.id_hospitalizacion <> h1.id_hospitalizacion
   AND h2.fecha_ingreso > h1.fecha_alta
   AND h2.fecha_ingreso <= h1.fecha_alta + 30
WHERE h1.fecha_ingreso >= DATE '2025-01-01'
ORDER BY dias_entre_eventos ASC;
