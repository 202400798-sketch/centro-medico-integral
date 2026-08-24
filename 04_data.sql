-- ============================================================
-- ESPECIALIDADES
-- ============================================================

INSERT INTO hospital.especialidad (nombre, descripcion)
VALUES
('Cardiología', 'Atención de enfermedades del corazón'),
('Pediatría', 'Atención médica de niños y adolescentes'),
('Dermatología', 'Diagnóstico y tratamiento de enfermedades de la piel'),
('Neurología', 'Atención de enfermedades del sistema nervioso'),
('Ginecología', 'Atención integral de la salud femenina'),
('Traumatología', 'Atención de lesiones y enfermedades musculoesqueléticas'),
('Endocrinología', 'Atención de trastornos hormonales y metabólicos'),
('Neumología', 'Atención de enfermedades respiratorias'),
('Gastroenterología', 'Atención de enfermedades digestivas'),
('Medicina Interna', 'Atención integral del adulto')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================
-- DIAGNÓSTICOS
-- ============================================================

INSERT INTO hospital.diagnostico (nombre, descripcion)
VALUES
('Hipertensión arterial', 'Presión arterial elevada'),
('Diabetes mellitus tipo 2', 'Alteración crónica de la glucosa'),
('Neumonía', 'Infección pulmonar'),
('Gastritis', 'Inflamación del revestimiento del estómago'),
('Asma', 'Enfermedad inflamatoria de las vías respiratorias'),
('Migraña', 'Trastorno caracterizado por cefalea recurrente'),
('Infección urinaria', 'Infección del tracto urinario'),
('Fractura de extremidad', 'Lesión ósea por traumatismo'),
('Obesidad', 'Acumulación excesiva de grasa corporal'),
('Anemia', 'Disminución de hemoglobina en sangre'),
('Bronquitis', 'Inflamación de los bronquios'),
('Arritmia', 'Alteración del ritmo cardíaco'),
('Colitis', 'Inflamación del colon'),
('Apendicitis', 'Inflamación del apéndice'),
('Infección respiratoria', 'Infección de las vías respiratorias')
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================
-- MEDICAMENTOS
-- ============================================================

INSERT INTO hospital.medicamento
(nombre, tipo, fabricante, stock)
VALUES
('Paracetamol 500mg', 'Analgésico', 'Laboratorios SV', 850),
('Ibuprofeno 400mg', 'Antiinflamatorio', 'Farmacéutica Central', 620),
('Amoxicilina 500mg', 'Antibiótico', 'Laboratorios Vida', 480),
('Omeprazol 20mg', 'Gastroprotector', 'Farmacéutica Nacional', 700),
('Losartán 50mg', 'Antihipertensivo', 'Laboratorios SV', 550),
('Metformina 850mg', 'Antidiabético', 'Laboratorios Vida', 640),
('Salbutamol 100mcg', 'Broncodilatador', 'Respira Pharma', 300),
('Atorvastatina 20mg', 'Hipolipemiante', 'Farmacéutica Central', 450),
('Amlodipino 5mg', 'Antihipertensivo', 'Laboratorios Salud', 500),
('Azitromicina 500mg', 'Antibiótico', 'Laboratorios SV', 390),
('Loratadina 10mg', 'Antialérgico', 'Farmacéutica Nacional', 420),
('Diclofenaco 50mg', 'Antiinflamatorio', 'Laboratorios Vida', 510),
('Enalapril 10mg', 'Antihipertensivo', 'Laboratorios Salud', 460),
('Acetaminofén 650mg', 'Analgésico', 'Farmacéutica Central', 730),
('Omeprazol 40mg', 'Gastroprotector', 'Laboratorios SV', 350),
('Ceftriaxona 1g', 'Antibiótico', 'Laboratorios Vida', 220),
('Insulina NPH', 'Antidiabético', 'Salud Pharma', 180),
('Prednisona 20mg', 'Corticosteroide', 'Farmacéutica Nacional', 250),
('Budesonida', 'Corticosteroide inhalado', 'Respira Pharma', 160),
('Amoxicilina/Clavulanato', 'Antibiótico', 'Laboratorios Salud', 320)
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO hospital.medico
(
    nombre,
    apellido,
    id_especialidad,
    telefono,
    email
)
SELECT
    (ARRAY[
        'Sebastian','María','José','Rebeca','Luis',
        'Sofía','Daniel','Gabriela','Miguel','Laura'
    ])[1 + ((g - 1) % 10)],

    (ARRAY[
        'Hernández','Martínez','García','López','Rodríguez',
        'Flores','Ramírez','Castro','Mendoza','Torres'
    ])[1 + ((g - 1) % 10)],

    1 + ((g - 1) % 10),

    '7000-' || LPAD(g::text, 4, '0'),

    'medico' || g || '@centromedicointegral.com'

FROM generate_series(1, 30) AS g

ON CONFLICT (email) DO NOTHING;



SELECT
    email,
    COUNT(*) AS cantidad
FROM hospital.medico
GROUP BY email
HAVING COUNT(*) > 1;


SELECT
    id_medico,
    nombre,
    apellido,
    id_especialidad,
    telefono,
    email
FROM hospital.medico
ORDER BY id_medico;

WITH datos AS (
    SELECT
        id_paciente,
        ROW_NUMBER() OVER (ORDER BY id_paciente) AS g
    FROM hospital.paciente
)
UPDATE hospital.paciente p
SET
    nombre = (ARRAY[
        'Juan','María','Carlos','Ana','José',
        'Sofía','Daniel','Laura','Miguel','Gabriela',
        'Luis','Andrea','Pedro','Valeria','Roberto'
    ])[1 + ((datos.g - 1) % 15)],

    apellido = (ARRAY[
        'Hernández','Martínez','García','López','Rodríguez',
        'Flores','Ramírez','Castro','Mendoza','Torres'
    ])[1 + (((datos.g + 3) - 1) % 10)]

FROM datos
WHERE p.id_paciente = datos.id_paciente;

INSERT INTO hospital.cita
(
    id_paciente,
    id_medico,
    fecha_hora,
    motivo,
    estado
)
SELECT
    1 + ((g - 1) % 300),
    1 + ((g - 1) % 30),
    TIMESTAMP '2025-01-01 08:00:00'
        + ((g * 2) % 650) * INTERVAL '1 day'
        + ((g % 10) * INTERVAL '1 hour'),

    (ARRAY[
        'Control general',
        'Seguimiento de tratamiento',
        'Dolor persistente',
        'Consulta preventiva',
        'Control de enfermedad crónica',
        'Evaluación de síntomas',
        'Revisión de resultados',
        'Consulta especializada'
    ])[1 + ((g - 1) % 8)],

    (ARRAY[
        'Programada',
        'Atendida',
        'Atendida',
        'Atendida',
        'Cancelada',
        'No asistio'
    ])[1 + ((g - 1) % 6)]

FROM generate_series(1, 600) AS g;

INSERT INTO hospital.hospitalizacion
(
    id_paciente,
    id_medico,
    fecha_ingreso,
    fecha_alta,
    motivo,
    estado
)
SELECT
    h.id_paciente,
    1 + ((h.id_hospitalizacion + 5) % 30),

    -- Reingreso entre 5 y 30 días después del alta inicial
    h.fecha_alta + (5 + (h.id_paciente % 26)),

    -- Alta del reingreso entre 2 y 7 días después
    h.fecha_alta
        + (5 + (h.id_paciente % 26))
        + (2 + (h.id_paciente % 6)),

    (ARRAY[
        'Reingreso por complicación',
        'Control de descompensación',
        'Persistencia de síntomas',
        'Complicación post-alta'
    ])[1 + ((h.id_paciente - 1) % 4)],

    'Alta'

FROM hospital.hospitalizacion h
WHERE h.id_hospitalizacion BETWEEN 1 AND 100;

INSERT INTO hospital.hospitalizacion_diagnostico
(
    id_hospitalizacion,
    id_diagnostico,
    tipo_diagnostico
)
SELECT
    h.id_hospitalizacion,
    d.id_diagnostico,
    'Principal'
FROM
(
    SELECT
        id_hospitalizacion,
        ROW_NUMBER() OVER (ORDER BY id_hospitalizacion) AS numero
    FROM hospital.hospitalizacion
) h
JOIN
(
    SELECT
        id_diagnostico,
        ROW_NUMBER() OVER (ORDER BY id_diagnostico) AS numero
    FROM hospital.diagnostico
) d
ON
    CASE
        WHEN h.numero <= (
            SELECT COUNT(*) * 0.22
            FROM hospital.hospitalizacion
        ) THEN 1

        WHEN h.numero <= (
            SELECT COUNT(*) * 0.41
            FROM hospital.hospitalizacion
        ) THEN 2

        WHEN h.numero <= (
            SELECT COUNT(*) * 0.57
            FROM hospital.hospitalizacion
        ) THEN 3

        WHEN h.numero <= (
            SELECT COUNT(*) * 0.71
            FROM hospital.hospitalizacion
        ) THEN 4

        WHEN h.numero <= (
            SELECT COUNT(*) * 0.84
            FROM hospital.hospitalizacion
        ) THEN 5

        ELSE 6
    END = d.numero;

INSERT INTO hospital.detalle_receta
(
    id_receta,
    id_medicamento,
    dosis,
    frecuencia,
    duracion_dias,
    cantidad
)
SELECT
    r.id_receta,
    m.id_medicamento,

    CASE MOD(m.numero_medicamento, 4)
        WHEN 0 THEN '1 tableta'
        WHEN 1 THEN '2 tabletas'
        WHEN 2 THEN '5 ml'
        ELSE '1 cápsula'
    END AS dosis,

    CASE MOD(m.numero_medicamento, 4)
        WHEN 0 THEN 'Cada 8 horas'
        WHEN 1 THEN 'Cada 12 horas'
        WHEN 2 THEN 'Una vez al día'
        ELSE 'Cada 24 horas'
    END AS frecuencia,

    5 + MOD(r.numero_receta + m.numero_medicamento, 15) AS duracion_dias,

    10 + MOD(r.numero_receta * m.numero_medicamento, 30) AS cantidad

FROM
(
    SELECT
        id_receta,
        ROW_NUMBER() OVER (ORDER BY id_receta) AS numero_receta
    FROM hospital.receta
) r

CROSS JOIN
(
    SELECT
        id_medicamento,
        ROW_NUMBER() OVER (ORDER BY id_medicamento) AS numero_medicamento
    FROM hospital.medicamento
) m

WHERE r.numero_receta <=
    CASE m.numero_medicamento
        WHEN 1 THEN 34
        WHEN 2 THEN 25
        WHEN 3 THEN 18
        WHEN 4 THEN 8
        WHEN 5 THEN 31
        WHEN 6 THEN 6
        WHEN 7 THEN 22
        WHEN 8 THEN 15
        WHEN 9 THEN 28
        WHEN 10 THEN 11
        WHEN 11 THEN 37
        WHEN 12 THEN 4
        WHEN 13 THEN 20
        WHEN 14 THEN 13
        WHEN 15 THEN 29
        WHEN 16 THEN 9
        WHEN 17 THEN 17
        WHEN 18 THEN 5
        WHEN 19 THEN 24
        WHEN 20 THEN 2
    END;
