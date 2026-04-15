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
    tipo VARCHAR(50)
);

-- Tabla T1_users (Registro de Identidad y Telemetría)
CREATE TABLE T1_users (
    email VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100),
    last_lat FLOAT,
    last_lon FLOAT,
    last_seen TIMESTAMP,
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 2. ENTIDADES DÉBILES (Dependientes con FK)
-- ==========================================

-- Tabla report_INDEX (Maestro de objetos)
-- Usamos VARCHAR(36) para los IDs porque tu diagrama dice que son UUIDs
CREATE TABLE report_INDEX (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(100),
    email VARCHAR(100),
    desc_short VARCHAR(255),
    category VARCHAR(50),
    lat FLOAT,
    lon FLOAT,
    status VARCHAR(20) DEFAULT 'LOST',
    photo_url VARCHAR(255),
    security_question VARCHAR(255),
    phone VARCHAR(255),          -- Dato cifrado con AES
    security_answer VARCHAR(255), -- Dato cifrado con AES
    FOREIGN KEY (email) REFERENCES T1_users(email) ON DELETE CASCADE
);

-- Tabla T7_buzon (Cola de Alertas)
CREATE TABLE T7_buzon (
    id VARCHAR(36) PRIMARY KEY,
    to_email VARCHAR(100),
    title VARCHAR(150),
    message TEXT,
    lat_objeto FLOAT,
    is_read BOOLEAN DEFAULT FALSE, -- Cambié 'read' a 'is_read' por ser palabra reservada
    FOREIGN KEY (to_email) REFERENCES T1_users(email) ON DELETE CASCADE
);

-- Tabla T8_comentarios (Muro de discusión)
CREATE TABLE T8_comentarios (
    id VARCHAR(36) PRIMARY KEY,
    report_id VARCHAR(36),
    user_name VARCHAR(100),
    text TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (report_id) REFERENCES report_INDEX(id) ON DELETE CASCADE
);