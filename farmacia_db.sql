-- =========================================================================
-- SISTEMA DE FARMACIA - PROGRAMA COMERCIAL 2026
-- Script completo de creacion de base de datos para MySQL
-- Motor: InnoDB | Charset: utf8mb4
-- Todas las relaciones son 1:M (segun diagrama relacional, sin M:N implicito)
-- =========================================================================

CREATE DATABASE IF NOT EXISTS farmacia_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE farmacia_db;

SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------------------------
-- Tabla: casa_medica
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `casa_medica`;
CREATE TABLE `casa_medica` (
  `id_casa_medica`     INT NOT NULL AUTO_INCREMENT,
  `nombre_casa_medica` VARCHAR(150) NOT NULL,
  `estado_casa_medica` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_casa_medica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: proveedor  (FK -> casa_medica)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `proveedor`;
CREATE TABLE `proveedor` (
  `id_proveedor`                 INT NOT NULL AUTO_INCREMENT,
  `id_casa_medica`                INT NOT NULL,
  `nombre_proveedor`              VARCHAR(150) NOT NULL,
  `telefono_proveedor`            VARCHAR(20),
  `direccion_proveedor`           VARCHAR(255),
  `correo_proveedor`              VARCHAR(150),
  `total_adquirido_proveedor`     DECIMAL(12,2) NOT NULL DEFAULT 0,
  `cantidad_adquirido_proveedor`  INT NOT NULL DEFAULT 0,
  `estado_proveedor`              TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proveedor`),
  KEY `fk_proveedor_casa_medica` (`id_casa_medica`),
  CONSTRAINT `fk_proveedor_casa_medica`
    FOREIGN KEY (`id_casa_medica`) REFERENCES `casa_medica` (`id_casa_medica`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: compras  (FK -> proveedor)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `compras`;
CREATE TABLE `compras` (
  `id_compra`     INT NOT NULL AUTO_INCREMENT,
  `id_proveedor`  INT NOT NULL,
  `fecha_compra`  DATE NOT NULL,
  `total_compra`  DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado_compra` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_compra`),
  KEY `fk_compras_proveedor` (`id_proveedor`),
  CONSTRAINT `fk_compras_proveedor`
    FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: presentacion
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `presentacion`;
CREATE TABLE `presentacion` (
  `id_presentacion`     INT NOT NULL AUTO_INCREMENT,
  `nombre_presentacion` VARCHAR(100) NOT NULL,
  `estado_presentacion` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_presentacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: medicamento  (FK -> presentacion)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `medicamento`;
CREATE TABLE `medicamento` (
  `id_medicamento`                INT NOT NULL AUTO_INCREMENT,
  `id_presentacion`               INT NOT NULL,
  `codigo_barras_medicamento`     VARCHAR(50),
  `nombre_medicamento`            VARCHAR(150) NOT NULL,
  `cantidad_por_paquete`          INT NOT NULL DEFAULT 1,
  `precio_mayorista`              DECIMAL(10,2) NOT NULL DEFAULT 0,
  `precio_minimo`                 DECIMAL(10,2) NOT NULL DEFAULT 0,
  `precio_venta`                  DECIMAL(10,2) NOT NULL DEFAULT 0,
  `componente_activo`             VARCHAR(150),
  `venta_libre`                   TINYINT(1) NOT NULL DEFAULT 1,
  `existencia_total_medicamento`  INT NOT NULL DEFAULT 0,
  `estado_medicamento`            TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_medicamento`),
  UNIQUE KEY `uq_medicamento_codigo_barras` (`codigo_barras_medicamento`),
  KEY `fk_medicamento_presentacion` (`id_presentacion`),
  CONSTRAINT `fk_medicamento_presentacion`
    FOREIGN KEY (`id_presentacion`) REFERENCES `presentacion` (`id_presentacion`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: detalle_compra  (FK -> compras, proveedor, medicamento)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `detalle_compra`;
CREATE TABLE `detalle_compra` (
  `id_detalle_compra` INT NOT NULL AUTO_INCREMENT,
  `id_compra`         INT NOT NULL,
  `id_proveedor`      INT NOT NULL,
  `id_medicamento`    INT NOT NULL,
  `cantidad_compra`   INT NOT NULL DEFAULT 0,
  `subtotal_compra`   DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado_compra`     TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_compra`),
  KEY `fk_detalle_compra_compra` (`id_compra`),
  KEY `fk_detalle_compra_proveedor` (`id_proveedor`),
  KEY `fk_detalle_compra_medicamento` (`id_medicamento`),
  CONSTRAINT `fk_detalle_compra_compra`
    FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_compra_proveedor`
    FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_detalle_compra_medicamento`
    FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: lote  (FK -> medicamento)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `lote`;
CREATE TABLE `lote` (
  `id_lote`           INT NOT NULL AUTO_INCREMENT,
  `id_medicamento`    INT NOT NULL,
  `fecha_produccion`  DATE NOT NULL,
  `fecha_vencimiento` DATE NOT NULL,
  `precio_lote`       DECIMAL(10,2) NOT NULL DEFAULT 0,
  `existencia_lote`   INT NOT NULL DEFAULT 0,
  `estado_lote`       TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lote`),
  KEY `fk_lote_medicamento` (`id_medicamento`),
  CONSTRAINT `fk_lote_medicamento`
    FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: cliente
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `id_cliente`     INT NOT NULL AUTO_INCREMENT,
  `nombre_cliente` VARCHAR(150) NOT NULL,
  `nit_cliente`    VARCHAR(20) DEFAULT 'CF',
  `estado_cliente` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: roles
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id_rol`     INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL,
  `estado_rol` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: usuarios  (FK -> roles)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id_usuario`       INT NOT NULL AUTO_INCREMENT,
  `id_rol`           INT NOT NULL,
  `usuario`          VARCHAR(50) NOT NULL,
  `password`         VARCHAR(255) NOT NULL,
  `nombre_usuario`   VARCHAR(150) NOT NULL,
  `telefono_usuario` VARCHAR(20),
  `correo_usuario`   VARCHAR(150),
  `dpi_usuario`      VARCHAR(20),
  `estado_usuario`   TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  KEY `fk_usuarios_roles` (`id_rol`),
  CONSTRAINT `fk_usuarios_roles`
    FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: venta  (FK -> usuarios, cliente)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `venta`;
CREATE TABLE `venta` (
  `id_venta`    INT NOT NULL AUTO_INCREMENT,
  `id_usuario`  INT NOT NULL,
  `id_cliente`  INT NOT NULL,
  `fecha_venta` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_venta` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado_venta` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_venta`),
  KEY `fk_venta_usuario` (`id_usuario`),
  KEY `fk_venta_cliente` (`id_cliente`),
  CONSTRAINT `fk_venta_usuario`
    FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_venta_cliente`
    FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: detalle_venta  (FK -> venta, medicamento)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `detalle_venta`;
CREATE TABLE `detalle_venta` (
  `id_detalle_venta`       INT NOT NULL AUTO_INCREMENT,
  `id_venta`               INT NOT NULL,
  `id_medicamento`         INT NOT NULL,
  `cantidad_detalle_venta` INT NOT NULL DEFAULT 0,
  `subtotal_detalle_venta` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado_detalle_venta`   TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_venta`),
  KEY `fk_detalle_venta_venta` (`id_venta`),
  KEY `fk_detalle_venta_medicamento` (`id_medicamento`),
  CONSTRAINT `fk_detalle_venta_venta`
    FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_venta_medicamento`
    FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: metodos_pago
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `metodos_pago`;
CREATE TABLE `metodos_pago` (
  `id_metodo_pago`     INT NOT NULL AUTO_INCREMENT,
  `nombre_metodo_pago` VARCHAR(50) NOT NULL,
  `cuenta_metodo_pago` VARCHAR(100),
  `estado_metodo_pago` TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------------------
-- Tabla: detalle_metodos_pago  (FK -> venta, metodos_pago)
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS `detalle_metodos_pago`;
CREATE TABLE `detalle_metodos_pago` (
  `id_detalle_metodos_pago`      INT NOT NULL AUTO_INCREMENT,
  `id_venta`                     INT NOT NULL,
  `id_metodo_pago`                INT NOT NULL,
  `cantidad_detalle_metodos_pago` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `estado_detalle_metodos_pago`   TINYINT(1) NOT NULL DEFAULT 1,
  `createdAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detalle_metodos_pago`),
  KEY `fk_detalle_metodos_pago_venta` (`id_venta`),
  KEY `fk_detalle_metodos_pago_metodo` (`id_metodo_pago`),
  CONSTRAINT `fk_detalle_metodos_pago_venta`
    FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_metodos_pago_metodo`
    FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo_pago`)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- DATOS INICIALES (seed basico para poder empezar a trabajar)
-- =========================================================================

INSERT INTO `roles` (`nombre_rol`, `estado_rol`) VALUES
('Administrador', 1),
('Vendedor', 1),
('Bodeguero', 1);

-- Password: "admin123" (hash bcrypt de ejemplo, se recomienda regenerarlo)
INSERT INTO `usuarios` (`id_rol`, `usuario`, `password`, `nombre_usuario`, `telefono_usuario`, `correo_usuario`, `dpi_usuario`, `estado_usuario`) VALUES
(1, 'admin', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8Q1Y5c1DZ1p2H8Rjv1yb1o9pxu8s0e', 'Administrador General', '00000000', 'admin@farmacia.com', '0000000000000', 1);

INSERT INTO `metodos_pago` (`nombre_metodo_pago`, `cuenta_metodo_pago`, `estado_metodo_pago`) VALUES
('Efectivo', NULL, 1),
('Tarjeta de credito', NULL, 1),
('Tarjeta de debito', NULL, 1),
('Transferencia bancaria', 'Cta. 000-000000-0', 1);

INSERT INTO `presentacion` (`nombre_presentacion`, `estado_presentacion`) VALUES
('Tabletas', 1),
('Jarabe', 1),
('Capsulas', 1),
('Inyeccion', 1),
('Crema', 1);

INSERT INTO `cliente` (`nombre_cliente`, `nit_cliente`, `estado_cliente`) VALUES
('Consumidor Final', 'CF', 1);

INSERT INTO `casa_medica` (`nombre_casa_medica`, `estado_casa_medica`) VALUES
('Laboratorios Bayer', 1),
('Laboratorios Roche', 1);

-- =========================================================================
-- Fin del script
-- =========================================================================
