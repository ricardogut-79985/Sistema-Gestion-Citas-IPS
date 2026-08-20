-- ============================================================
-- SISTEMA DE GESTIÓN DE CITAS MÉDICAS - IPS COLOMBIA
-- Proyecto: Diseño e Implementación de Base de Datos Relacional
-- Archivo: sistema_citas_ips.sql
-- ============================================================

-- ============================================================
-- 1. TABLA: especialidad
-- Catálogo de especialidades médicas
-- ============================================================

CREATE TABLE especialidad (
    especialidad_id INT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    estado VARCHAR(15) NOT NULL,
    
    CONSTRAINT chk_especialidad_estado
        CHECK (estado IN ('ACTIVA', 'INACTIVA'))
);

-- ============================================================
-- 2. TABLA: paciente
-- Información básica de los pacientes
-- ============================================================

CREATE TABLE paciente (
    paciente_id INT PRIMARY KEY,
    tipo_documento VARCHAR(5) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    fecha_registro DATE NOT NULL,
    
    CONSTRAINT chk_paciente_tipo_documento
        CHECK (tipo_documento IN ('CC', 'TI', 'CE', 'PA')),
        
    CONSTRAINT chk_paciente_sexo
        CHECK (sexo IN ('FEMENINO', 'MASCULINO', 'OTRO'))
);

-- ============================================================
-- 3. TABLA: medico
-- Profesionales médicos vinculados a la IPS
-- ============================================================

CREATE TABLE medico (
    medico_id INT PRIMARY KEY,
    tipo_documento VARCHAR(5) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    registro_profesional VARCHAR(30) NOT NULL UNIQUE,
    especialidad_id INT NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    estado VARCHAR(15) NOT NULL,
    
    CONSTRAINT fk_medico_especialidad
        FOREIGN KEY (especialidad_id)
        REFERENCES especialidad(especialidad_id),
        
    CONSTRAINT chk_medico_tipo_documento
        CHECK (tipo_documento IN ('CC', 'CE', 'PA')),
        
    CONSTRAINT chk_medico_estado
        CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

-- ============================================================
-- 4. TABLA: consultorio
-- Recursos físicos disponibles para la consulta externa
-- ============================================================

CREATE TABLE consultorio (
    consultorio_id INT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    ubicacion VARCHAR(100) NOT NULL,
    piso INT NOT NULL,
    capacidad INT NOT NULL,
    estado VARCHAR(15) NOT NULL,
    
    CONSTRAINT chk_consultorio_piso
        CHECK (piso > 0),
        
    CONSTRAINT chk_consultorio_capacidad
        CHECK (capacidad > 0),
        
    CONSTRAINT chk_consultorio_estado
        CHECK (estado IN ('DISPONIBLE', 'MANTENIMIENTO', 'INACTIVO'))
);

-- ============================================================
-- 5. TABLA: agenda
-- Disponibilidad de médicos y consultorios
-- ============================================================

CREATE TABLE agenda (
    agenda_id INT PRIMARY KEY,
    medico_id INT NOT NULL,
    consultorio_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(15) NOT NULL,
    observacion VARCHAR(200),
    
    CONSTRAINT fk_agenda_medico
        FOREIGN KEY (medico_id)
        REFERENCES medico(medico_id),
        
    CONSTRAINT fk_agenda_consultorio
        FOREIGN KEY (consultorio_id)
        REFERENCES consultorio(consultorio_id),
        
    CONSTRAINT chk_agenda_horas
        CHECK (hora_fin > hora_inicio),
        
    CONSTRAINT chk_agenda_estado
        CHECK (estado IN ('ABIERTA', 'CERRADA', 'BLOQUEADA'))
);

-- ============================================================
-- 6. TABLA: estado_cita
-- Catálogo de estados posibles de una cita
-- ============================================================

CREATE TABLE estado_cita (
    estado_cita_id INT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    permite_atencion BOOLEAN NOT NULL
);

-- ============================================================
-- 7. TABLA: motivo_consulta
-- Catálogo de motivos de consulta
-- ============================================================

CREATE TABLE motivo_consulta (
    motivo_id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    categoria VARCHAR(50) NOT NULL
);

-- ============================================================
-- 8. TABLA: cita
-- Tabla transaccional central del sistema
-- ============================================================

CREATE TABLE cita (
    cita_id INT PRIMARY KEY,
    paciente_id INT NOT NULL,
    agenda_id INT NOT NULL,
    estado_cita_id INT NOT NULL,
    motivo_id INT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    hora_solicitud TIME NOT NULL,
    fecha_confirmacion DATE,
    observaciones VARCHAR(250),
    
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (paciente_id)
        REFERENCES paciente(paciente_id),
        
    CONSTRAINT fk_cita_agenda
        FOREIGN KEY (agenda_id)
        REFERENCES agenda(agenda_id),
        
    CONSTRAINT fk_cita_estado
        FOREIGN KEY (estado_cita_id)
        REFERENCES estado_cita(estado_cita_id),
        
    CONSTRAINT fk_cita_motivo
        FOREIGN KEY (motivo_id)
        REFERENCES motivo_consulta(motivo_id)
);

-- ============================================================
-- FIN DEL DDL
-- ============================================================
