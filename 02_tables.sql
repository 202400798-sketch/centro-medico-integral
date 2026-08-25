-- ============================================================
-- PROYECTO INTEGRADOR
-- CENTRO MEDICO INTEGRAL
-- SERVICIOS DE SALUD Y HOSPITALES
-- CREACIÓN DE TABLAS
-- ============================================================

-- ============================================================
-- 1. ESPECIALIDAD
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.especialidad (
    id_especialidad INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- ============================================================
-- 2. MÉDICO
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.medico (
    id_medico INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_especialidad INTEGER NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,

    CONSTRAINT fk_medico_especialidad
        FOREIGN KEY (id_especialidad)
        REFERENCES hospital.especialidad(id_especialidad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 3. PACIENTE
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.paciente (
    id_paciente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    dui VARCHAR(10) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    direccion VARCHAR(255),

    CONSTRAINT chk_fecha_nacimiento
        CHECK (fecha_nacimiento <= CURRENT_DATE)
);

-- ============================================================
-- 4. DIAGNÓSTICO
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.diagnostico (
    id_diagnostico INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- ============================================================
-- 5. CITA
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.cita (
    id_cita INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL,

    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES hospital.paciente(id_paciente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_cita_medico
        FOREIGN KEY (id_medico)
        REFERENCES hospital.medico(id_medico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_estado_cita
        CHECK (estado IN ('Programada', 'Atendida', 'Cancelada', 'No asistio'))
);

-- ============================================================
-- 6. HOSPITALIZACIÓN
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.hospitalizacion (
    id_hospitalizacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_alta DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL,

    CONSTRAINT fk_hosp_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES hospital.paciente(id_paciente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_hosp_medico
        FOREIGN KEY (id_medico)
        REFERENCES hospital.medico(id_medico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_fechas_hospitalizacion
        CHECK (fecha_alta >= fecha_ingreso),

    CONSTRAINT chk_estado_hospitalizacion
        CHECK (estado IN ('Alta', 'En seguimiento', 'Fallecido'))
);

-- ============================================================
-- 7. RELACIÓN HOSPITALIZACIÓN - DIAGNÓSTICO
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.hospitalizacion_diagnostico (
    id_hospitalizacion INTEGER NOT NULL,
    id_diagnostico INTEGER NOT NULL,
    tipo_diagnostico VARCHAR(20) NOT NULL,

    PRIMARY KEY (id_hospitalizacion, id_diagnostico),

    CONSTRAINT fk_hd_hospitalizacion
        FOREIGN KEY (id_hospitalizacion)
        REFERENCES hospital.hospitalizacion(id_hospitalizacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_hd_diagnostico
        FOREIGN KEY (id_diagnostico)
        REFERENCES hospital.diagnostico(id_diagnostico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_tipo_diagnostico
        CHECK (tipo_diagnostico IN ('Principal', 'Secundario'))
);

-- ============================================================
-- 8. MEDICAMENTO
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.medicamento (
    id_medicamento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    tipo VARCHAR(100) NOT NULL,
    fabricante VARCHAR(150) NOT NULL,
    stock INTEGER NOT NULL,

    CONSTRAINT chk_stock
        CHECK (stock >= 0)
);

-- ============================================================
-- 9. RECETA
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.receta (
    id_receta INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_paciente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    fecha_receta DATE NOT NULL,

    CONSTRAINT fk_receta_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES hospital.paciente(id_paciente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_receta_medico
        FOREIGN KEY (id_medico)
        REFERENCES hospital.medico(id_medico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- 10. DETALLE DE RECETA
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.detalle_receta (
    id_detalle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_receta INTEGER NOT NULL,
    id_medicamento INTEGER NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(100) NOT NULL,
    duracion_dias INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,

    CONSTRAINT fk_detalle_receta
        FOREIGN KEY (id_receta)
        REFERENCES hospital.receta(id_receta)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES hospital.medicamento(id_medicamento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_duracion
        CHECK (duracion_dias > 0),

    CONSTRAINT chk_cantidad
        CHECK (cantidad > 0)
);

-- ============================================================
-- 11. DISPENSACIÓN
-- ============================================================

CREATE TABLE IF NOT EXISTS hospital.dispensacion (
    id_dispensacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_detalle INTEGER NOT NULL,
    fecha_dispensacion DATE NOT NULL,
    cantidad_dispensada INTEGER NOT NULL,

    CONSTRAINT fk_dispensacion_detalle
        FOREIGN KEY (id_detalle)
        REFERENCES hospital.detalle_receta(id_detalle)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_cantidad_dispensada
        CHECK (cantidad_dispensada > 0)
);
