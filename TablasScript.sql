-- Creamos la base de datos para tu proyecto y la seleccionamos
CREATE DATABASE IF NOT EXISTS lostnet_db;
USE lostnet_db;

-- ==========================================
-- 1. ENTIDADES FUERTES (Independientes)
-- ==========================================

-- Catálogo de Puntos Seguros
CREATE TABLE puntos_seguros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150),
    lat FLOAT,
    lon FLOAT,
    tipo VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVO'  -- Bandera para borrado lógico
);

-- Tabla t1_users (Registro de Identidad, Telemetría y Gamificación)
CREATE TABLE t1_users (
    email VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100),
    last_lat FLOAT,
    last_lon FLOAT,
    last_seen TIMESTAMP,
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_type VARCHAR(20) DEFAULT 'BUSCADOR',  -- Extensión de Gamificación
    badge VARCHAR(20) DEFAULT 'NINGUNO',       -- Extensión de Gamificación
    status VARCHAR(20) DEFAULT 'ACTIVO'        -- Bandera para borrado lógico
);

-- ==========================================
-- 2. ENTIDADES DÉBILES (Dependientes con FK)
-- ==========================================

-- Tabla report_index (Maestro de objetos)
CREATE TABLE report_index (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(100),
    email VARCHAR(100),
    desc_short VARCHAR(255),
    category VARCHAR(50),
    lat FLOAT,
    lon FLOAT,
    status VARCHAR(20) DEFAULT 'LOST',         -- Bandera de estado del objeto y borrado lógico
    photo_url VARCHAR(255),
    security_question VARCHAR(255),
    phone VARCHAR(255),          -- Dato cifrado con AES
    security_answer VARCHAR(255), -- Dato cifrado con AES
    FOREIGN KEY (email) REFERENCES t1_users(email) ON DELETE CASCADE
);

-- Tabla t7_buzon (Cola de Alertas)
CREATE TABLE t7_buzon (
    id VARCHAR(36) PRIMARY KEY,
    to_email VARCHAR(100),
    title VARCHAR(150),
    message TEXT,
    lat_objeto FLOAT,
    is_read BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'ACTIVO',       -- Bandera para borrado lógico
    FOREIGN KEY (to_email) REFERENCES t1_users(email) ON DELETE CASCADE
);

-- Tabla t8_comentarios (Muro de discusión)
CREATE TABLE t8_comentarios (
    id VARCHAR(36) PRIMARY KEY,
    report_id VARCHAR(36),
    user_name VARCHAR(100),
    text TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVO',       -- Bandera para borrado lógico
    FOREIGN KEY (report_id) REFERENCES report_index(id) ON DELETE CASCADE
);
