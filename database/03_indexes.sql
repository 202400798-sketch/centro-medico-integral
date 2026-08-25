-- ============================================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_paciente_apellido
ON hospital.paciente(apellido);

CREATE INDEX IF NOT EXISTS idx_cita_paciente
ON hospital.cita(id_paciente);

CREATE INDEX IF NOT EXISTS idx_cita_medico
ON hospital.cita(id_medico);

CREATE INDEX IF NOT EXISTS idx_cita_fecha
ON hospital.cita(fecha_hora);

CREATE INDEX IF NOT EXISTS idx_hosp_paciente
ON hospital.hospitalizacion(id_paciente);

CREATE INDEX IF NOT EXISTS idx_hosp_fecha_ingreso
ON hospital.hospitalizacion(fecha_ingreso);

CREATE INDEX IF NOT EXISTS idx_hosp_medico
ON hospital.hospitalizacion(id_medico);

CREATE INDEX IF NOT EXISTS idx_hd_diagnostico
ON hospital.hospitalizacion_diagnostico(id_diagnostico);

CREATE INDEX IF NOT EXISTS idx_receta_paciente
ON hospital.receta(id_paciente);

CREATE INDEX IF NOT EXISTS idx_receta_fecha
ON hospital.receta(fecha_receta);

CREATE INDEX IF NOT EXISTS idx_detalle_medicamento
ON hospital.detalle_receta(id_medicamento);

CREATE INDEX IF NOT EXISTS idx_dispensacion_fecha
ON hospital.dispensacion(fecha_dispensacion);
