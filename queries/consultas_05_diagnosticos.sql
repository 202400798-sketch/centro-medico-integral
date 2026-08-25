SELECT
    d.nombre AS diagnostico,
    COUNT(DISTINCT hd.id_hospitalizacion) AS total_hospitalizaciones
FROM hospital.hospitalizacion_diagnostico hd
JOIN hospital.diagnostico d
    ON hd.id_diagnostico = d.id_diagnostico
WHERE hd.tipo_diagnostico = 'Principal'
GROUP BY
    d.id_diagnostico,
    d.nombre
ORDER BY
    total_hospitalizaciones DESC;
