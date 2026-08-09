-- ============================================================================================================================
-- BASE DE DATOS: SISTEMA DE GESTIÓN DE MAQUINARIA Y TRANSPORTE
-- Versión: 2.0 - Revisada y Corregida
-- Descripción: Script completo con DDL, correcciones, nuevas tablas e INSERTs de datos
-- Modelos: Copo de Nieve (Geografía, Catálogos) y Estrella (Analítica)
-- ============================================================================================================================

CREATE DATABASE GestionMaquinaria
   
GO
USE GestionMaquinaria;
GO

-- ============================================================================================================================
-- MÓDULO 1 — GEOGRAFÍA  (Modelo Copo de Nieve: Pais → Departamento → Municipio)
-- ============================================================================================================================

CREATE TABLE Geografia_Pais (
    id_pais         INT             NOT NULL IDENTITY(1,1),
    nombre_pais     VARCHAR(80)     NOT NULL,
    codigo_iso      CHAR(3)         NOT NULL,
    moneda_oficial  VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_Pais              PRIMARY KEY (id_pais),
    CONSTRAINT UQ_Pais_codigo_iso   UNIQUE (codigo_iso),
    CONSTRAINT UQ_Pais_nombre       UNIQUE (nombre_pais)
);
GO

CREATE TABLE Geografia_DepartamentoGeo (
    id_depto_geo    INT             NOT NULL IDENTITY(1,1),
    id_pais         INT             NOT NULL,
    nombre_depto    VARCHAR(80)     NOT NULL,
    codigo_depto    VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_DepartamentoGeo   PRIMARY KEY (id_depto_geo),
    CONSTRAINT FK_DeptoGeo_Pais     FOREIGN KEY (id_pais) REFERENCES Geografia_Pais(id_pais)
);
GO

CREATE TABLE Geografia_Municipio (
    id_municipio        INT             NOT NULL IDENTITY(1,1),
    id_depto_geo        INT             NOT NULL,
    nombre_municipio    VARCHAR(80)     NOT NULL,
    codigo_postal       VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_Municipio         PRIMARY KEY (id_municipio),
    CONSTRAINT FK_Municipio_Depto   FOREIGN KEY (id_depto_geo) REFERENCES Geografia_DepartamentoGeo(id_depto_geo)
);
GO
select * from Geografia_Pais
Delete from Geografia_Pais
-- INSERTs: Geografía
SET IDENTITY_INSERT Geografia_Pais ON;
INSERT INTO Geografia_Pais (id_pais, nombre_pais, codigo_iso, moneda_oficial) VALUES
(300, 'Guatemala',      'GTM', 'Quetzal'),
(301, 'Mexico',         'MEX', 'Peso Mexicano'),
(302, 'Honduras',       'HND', 'Lempira'),
(303, 'El Salvador',    'SLV', 'Dolar'),
(304, 'Costa Rica',     'CRI', 'Colon'),
(305, 'Panama',         'PAN', 'Balboa'),
(306, 'Nicaragua',      'NIC', 'Cordoba'),
(307, 'Belize',         'BLZ', 'Dolar Beliceno'),
(308, 'Colombia',       'COL', 'Peso Colombiano'),
(309, 'Estados Unidos', 'USA', 'Dolar');
SET IDENTITY_INSERT Geografia_Pais OFF;
GO
 
-- Nota: id_pais en esta tabla referencia exactamente los valores 300, 301, 302... de arriba
SET IDENTITY_INSERT Geografia_DepartamentoGeo ON;
INSERT INTO Geografia_DepartamentoGeo (id_depto_geo, id_pais, nombre_depto, codigo_depto) VALUES
(100, 300, 'Guatemala',      'GT-GU'),   -- id_pais=300 = Guatemala
(101, 300, 'Escuintla',      'GT-ES'),
(102, 300, 'Quetzaltenango', 'GT-QZ'),
(103, 300, 'Sacatepequez',   'GT-SA'),
(104, 300, 'Chiquimula',     'GT-CQ'),
(105, 300, 'Izabal',         'GT-IZ'),
(106, 300, 'Alta Verapaz',   'GT-AV'),
(107, 300, 'San Marcos',     'GT-SM'),
(108, 301, 'Peten',        'GT-PN'),
(109 , 302, 'Jutiapa',         'GT-JT');   
SET IDENTITY_INSERT Geografia_DepartamentoGeo OFF;
GO
 
-- Nota: id_depto_geo referencia exactamente los valores 100-109 de arriba
SET IDENTITY_INSERT Geografia_Municipio ON;
INSERT INTO Geografia_Municipio (id_municipio, id_depto_geo, nombre_municipio, codigo_postal) VALUES
(200, 100, 'Ciudad de Guatemala', '01001'),   -- id_depto_geo=100 = Guatemala
(201, 100, 'Mixco',               '01057'),
(202, 100, 'Villa Nueva',         '01064'),
(203, 100, 'Petapa',              '01062'),
(204, 100, 'San Miguel Petapa',   '01061'),
(205, 101, 'Escuintla',           '05001'),   -- id_depto_geo=101 = Escuintla
(206, 101, 'Santa Lucia Cotz.',   '05005'),
(207, 101, 'Puerto San Jose',     '05010'),
(208, 102, 'Quetzaltenango',      '09001'),   -- id_depto_geo=102
(209, 103, 'Antigua Guatemala',   '03001'),   -- id_depto_geo=103 = Sacatepequez
(210, 104, 'Chiquimula',          '20001'),   -- id_depto_geo=104
(211, 105, 'Puerto Barrios',      '18001'),   -- id_depto_geo=105 = Izabal
(212, 105, 'Livingston',          '18002'),
(213, 106, 'Coban',               '16001'),   -- id_depto_geo=106 = Alta Verapaz
(214, 107, 'San Marcos',          '12001'),   -- id_depto_geo=107
(215, 108, 'Peten',               '10020'),  -- id_depto_geo=108 = Chiapas (Mexico)
(216, 109, 'Jutiapa',             '10021'),  -- id_depto_geo=109 = Cortes (Honduras)
(217, 100, 'Amatitlan',           '01069'),
(218, 101, 'Palin',               '05003'),
(219, 102, 'Coatepeque',          '09007'),
(220, 103, 'Ciudad Vieja',        '03002'),
(221, 105, 'Morales',             '18003'),
(222, 106, 'Chamelco',            '16002'),
(223, 100, 'Chinautla',           '01002');
SET IDENTITY_INSERT Geografia_Municipio OFF;
GO
 
-- ============================================================================================================================
-- MÓDULO 2 — CATÁLOGOS  (Copo de Nieve: nodos hoja del esquema)
-- ============================================================================================================================

CREATE TABLE Catalogo_Marca (
    id_marca        INT             NOT NULL IDENTITY(1,1),
    nombre_marca    VARCHAR(80)     NOT NULL,
    pais_origen     VARCHAR(60)     NOT NULL,
    sitio_web       VARCHAR(120)    NOT NULL,
    CONSTRAINT PK_Marca         PRIMARY KEY (id_marca),
    CONSTRAINT UQ_Marca_nombre  UNIQUE (nombre_marca)
);
GO

CREATE TABLE Catalogo_CategoriaMaquinaria (
    id_categoria            INT             NOT NULL IDENTITY(1,1),
    nombre_categoria        VARCHAR(80)     NOT NULL,
    descripcion             VARCHAR(500)    NOT NULL,
    requiere_operador_cert  CHAR(2)         NOT NULL DEFAULT 'SI',   -- reemplaza BIT
    CONSTRAINT PK_CategoriaMaquinaria   PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_Categoria_nombre      UNIQUE (nombre_categoria),
    CONSTRAINT CK_Categoria_cert        CHECK (requiere_operador_cert IN ('SI','NO'))
);
GO

CREATE TABLE Catalogo_TipoMantenimiento (
    id_tipo_mant        INT             NOT NULL IDENTITY(1,1),
    nombre_tipo         VARCHAR(80)     NOT NULL,
    descripcion         VARCHAR(500)    NOT NULL,
    periodicidad_horas  INT             NOT NULL DEFAULT 250,
    CONSTRAINT PK_TipoMantenimiento     PRIMARY KEY (id_tipo_mant),
    CONSTRAINT UQ_TipoMant_nombre       UNIQUE (nombre_tipo)
);
GO

CREATE TABLE Catalogo_TipoIncidente (
    id_tipo_inc              INT             NOT NULL IDENTITY(1,1),
    nombre_tipo              VARCHAR(80)     NOT NULL,
    nivel_gravedad           VARCHAR(20)     NOT NULL,
    requiere_reporte_externo CHAR(2)         NOT NULL DEFAULT 'NO',  -- reemplaza BIT
    CONSTRAINT PK_TipoIncidente         PRIMARY KEY (id_tipo_inc),
    CONSTRAINT UQ_TipoInc_nombre        UNIQUE (nombre_tipo),
    CONSTRAINT CK_TipoInc_gravedad      CHECK (nivel_gravedad  IN ('Leve','Moderado','Grave','Critico')),
    CONSTRAINT CK_TipoInc_reporte       CHECK (requiere_reporte_externo IN ('SI','NO'))
);
GO

CREATE TABLE Catalogo_TipoCarga (
    id_tipo_carga       INT             NOT NULL IDENTITY(1,1),
    nombre_tipo_carga   VARCHAR(80)     NOT NULL,
    nivel_control       VARCHAR(20)     NOT NULL,
    requiere_inspeccion CHAR(2)         NOT NULL DEFAULT 'SI',       -- reemplaza BIT
    descripcion         VARCHAR(500)    NOT NULL,
    CONSTRAINT PK_TipoCarga         PRIMARY KEY (id_tipo_carga),
    CONSTRAINT UQ_TipoCarga_nombre  UNIQUE (nombre_tipo_carga),
    CONSTRAINT CK_TipoCarga_control CHECK (nivel_control IN ('Bajo','Medio','Alto')),
    CONSTRAINT CK_TipoCarga_insp    CHECK (requiere_inspeccion IN ('SI','NO'))
);
GO
SELECt * from Catalogo_Marca
-- INSERTs: Catálogos
SET IDENTITY_INSERT Catalogo_Marca ON;
INSERT INTO Catalogo_Marca (id_marca, nombre_marca, pais_origen, sitio_web) VALUES
(500, 'Caterpillar',   'Estados Unidos', 'https://www.caterpillar.com'),
(501, 'Komatsu',       'Japon',          'https://www.komatsu.com'),
(502, 'Volvo CE',      'Suecia',         'https://www.volvoce.com'),
(503, 'Liebherr',      'Alemania',       'https://www.liebherr.com'),
(504, 'John Deere',    'Estados Unidos', 'https://www.deere.com'),
(505, 'Hitachi',       'Japon',          'https://www.hitachicm.com'),
(506, 'Case',          'Estados Unidos', 'https://www.casece.com'),
(507, 'Terex',         'Estados Unidos', 'https://www.terex.com'),
(508, 'JCB',           'Reino Unido',    'https://www.jcb.com'),
(509, 'Hyundai CE',    'Corea del Sur',  'https://www.hd-xite.com'),
(510, 'Mack Trucks',   'Estados Unidos', 'https://www.macktrucks.com'),
(511, 'Kenworth',      'Estados Unidos', 'https://www.kenworth.com'),
(512, 'Freightliner',  'Estados Unidos', 'https://www.freightliner.com'),
(513, 'Mercedes-Benz', 'Alemania',       'https://www.mercedes-benz-trucks.com'),
(514, 'Scania',        'Suecia',         'https://www.scania.com');
SET IDENTITY_INSERT Catalogo_Marca OFF;
GO

 
SET IDENTITY_INSERT Catalogo_CategoriaMaquinaria ON;
INSERT INTO Catalogo_CategoriaMaquinaria (id_categoria, nombre_categoria, descripcion, requiere_operador_cert) VALUES
(600, 'Excavadora',           'Maquina de orugas o ruedas con brazo articulado y balde.',           'SI'),
(601, 'Cargador Frontal',     'Equipo con cuchara frontal para carga y transporte.',                 'SI'),
(602, 'Grua Torre',           'Grua fija para obras de construccion en altura.',                     'SI'),
(603, 'Bulldozer',            'Tractor de orugas para empuje y nivelacion de terreno.',              'SI'),
(604, 'Compactadora',         'Equipo para compactacion de suelos y asfalto.',                       'NO'),
(605, 'Retroexcavadora',      'Equipo combinado con cuchara frontal y brazo excavador trasero.',     'SI'),
(606, 'Grua Movil',           'Grua autopropulsada con capacidad de traslado.',                      'SI'),
(607, 'Montacargas',          'Equipo industrial para elevacion de cargas en almacenes.',            'SI'),
(608, 'Mezcladora',           'Maquina para mezcla de concreto en obra.',                           'NO'),
(609, 'Perforadora',          'Equipo para perforacion de suelo y roca.',                           'SI'),
(610, 'Camion Volquete',      'Camion con caja basculante para transporte de material.',             'SI'),
(611, 'Cisterna',             'Camion con tanque para transporte de liquidos.',                      'SI'),
(612, 'Plataforma Elevadora', 'Equipo para trabajo en alturas con canastilla.',                      'SI'),
(613, 'Generador Industrial', 'Equipo de generacion electrica para obra.',                          'NO'),
(614, 'Mini Excavadora',      'Excavadora compacta para espacios reducidos.',                        'SI'),
(615, 'Vibro Compactadora',   'Rodillo vibratorio para compactacion de capas.',                     'NO'),
(616, 'Grua Articulada',      'Grua con brazo articulado para carga y descarga.',                   'SI'),
(617, 'Dumper Articulado',    'Camion articulado para terrenos sin pavimentar.',                     'SI'),
(618, 'Pavimentadora',        'Maquina para colocacion de asfalto en carreteras.',                  'SI'),
(619, 'Motoniveladora',       'Equipo para nivelacion y conformacion de terrenos.',                  'SI');
SET IDENTITY_INSERT Catalogo_CategoriaMaquinaria OFF;
GO

SET IDENTITY_INSERT Catalogo_TipoMantenimiento ON;
INSERT INTO Catalogo_TipoMantenimiento (id_tipo_mant, nombre_tipo, descripcion, periodicidad_horas) VALUES
(700, 'Mantenimiento Preventivo 250h',  'Cambio de aceite, filtros y revision general cada 250h.',           250),
(701, 'Mantenimiento Preventivo 500h',  'Inspeccion de sistemas hidraulicos y electricos cada 500h.',        500),
(702, 'Mantenimiento Preventivo 1000h', 'Revision completa de tren de rodaje y motor cada 1000h.',           1000),
(703, 'Mantenimiento Correctivo',       'Reparacion de falla o averia detectada.',                           0),
(704, 'Mantenimiento Predictivo',       'Diagnostico basado en analisis de aceite y vibraciones.',           500),
(705, 'Revision Pre-Operacional',       'Inspeccion visual y funcional antes de iniciar operaciones.',       8),
(706, 'Cambio de Neumaticos',           'Sustitucion de neumaticos por desgaste o dano.',                    2000),
(707, 'Revision de Frenos',             'Inspeccion y ajuste del sistema de frenos.',                        500),
(708, 'Calibracion de Sensores',        'Ajuste y calibracion de sensores electronicos.',                   1000),
(709, 'Lavado y Limpieza General',      'Limpieza profunda del equipo por dentro y fuera.',                  0);
SET IDENTITY_INSERT Catalogo_TipoMantenimiento OFF;
GO
 
SET IDENTITY_INSERT Catalogo_TipoIncidente ON;
INSERT INTO Catalogo_TipoIncidente (id_tipo_inc, nombre_tipo, nivel_gravedad, requiere_reporte_externo) VALUES
(800, 'Accidente de Transito',        'Grave',    'SI'),
(801, 'Volcamiento de Equipo',        'Critico',  'SI'),
(802, 'Falla Mecanica en Ruta',       'Moderado', 'NO'),
(803, 'Incendio de Equipo',           'Critico',  'SI'),
(804, 'Colision con Infraestructura', 'Grave',    'SI'),
(805, 'Caida de Carga',               'Grave',    'SI'),
(806, 'Accidente con Peaton',         'Critico',  'SI'),
(807, 'Robo de Equipo',               'Grave',    'SI'),
(808, 'Dano a Propiedad Privada',     'Moderado', 'SI'),
(809, 'Accidente Laboral Leve',       'Leve',     'NO'),
(810, 'Atropellamiento Fatal',        'Critico',  'SI'),
(811, 'Explosion de Neumatico',       'Moderado', 'NO'),
(812, 'Fuga de Combustible',          'Moderado', 'SI'),
(813, 'Lesion de Operador',           'Grave',    'SI'),
(814, 'Dano a Mercancia',             'Leve',     'NO');
SET IDENTITY_INSERT Catalogo_TipoIncidente OFF;
GO

SET IDENTITY_INSERT Catalogo_TipoCarga ON;
INSERT INTO Catalogo_TipoCarga (id_tipo_carga, nombre_tipo_carga, nivel_control, requiere_inspeccion, descripcion) VALUES
(900, 'Carga General',           'Bajo',  'NO', 'Mercancia comun sin requerimientos especiales.'),
(901, 'Carga Perecedera',        'Alto',  'SI', 'Productos que requieren refrigeracion y control de tiempo.'),
(902, 'Carga Peligrosa',         'Alto',  'SI', 'Materiales inflamables, toxicos o corrosivos. Norma ADR.'),
(903, 'Carga Fragil',            'Medio', 'SI', 'Productos que pueden danarse facilmente durante el transporte.'),
(904, 'Carga a Granel',          'Medio', 'NO', 'Mercancia sin empaquetar como granos o minerales.'),
(905, 'Carga Refrigerada',       'Alto',  'SI', 'Productos que necesitan cadena de frio documentada.'),
(906, 'Carga Sobredimensionada', 'Alto',  'SI', 'Carga que excede las dimensiones estandar permitidas.'),
(907, 'Carga Electronica',       'Medio', 'SI', 'Equipos electronicos sensibles a impacto y humedad.'),
(908, 'Carga Textil',            'Bajo',  'NO', 'Ropa y productos textiles en general.'),
(909, 'Carga Automotriz',        'Medio', 'SI', 'Repuestos, vehiculos y maquinaria de transporte.');
SET IDENTITY_INSERT Catalogo_TipoCarga OFF;
GO
 

-- ============================================================================================================================
-- MÓDULO 3 — PROVEEDORES (nueva tabla)
-- ============================================================================================================================

CREATE TABLE Proveedor_Proveedor (
    id_proveedor        INT             NOT NULL IDENTITY(1,1),
    nombre_empresa      VARCHAR(150)    NOT NULL,
    nit_proveedor       VARCHAR(20)     NOT NULL,
    tipo_servicio       VARCHAR(60)     NOT NULL,
    nombre_contacto     VARCHAR(100)    NOT NULL,
    telefono_principal  VARCHAR(20)     NOT NULL,
    telefono_secundario VARCHAR(20)     NOT NULL,
    correo_comercial    VARCHAR(100)    NOT NULL,
    pagina_web          VARCHAR(150)    NOT NULL,
    id_municipio        INT             NOT NULL,
    direccion           VARCHAR(200)    NOT NULL,
    activo              CHAR(2)         NOT NULL DEFAULT 'SI',
    CONSTRAINT PK_Proveedor             PRIMARY KEY (id_proveedor),
    CONSTRAINT UQ_Proveedor_nit         UNIQUE (nit_proveedor),
    CONSTRAINT UQ_Proveedor_correo      UNIQUE (correo_comercial),
    CONSTRAINT FK_Proveedor_Municipio   FOREIGN KEY (id_municipio) REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Proveedor_tipo        CHECK (tipo_servicio IN ('Repuestos','Combustible','Mantenimiento','Neumaticos','Lubricantes','Transporte','Seguros','Otros')),
    CONSTRAINT CK_Proveedor_activo      CHECK (activo IN ('SI','NO'))
);
GO

SET IDENTITY_INSERT Proveedor_Proveedor ON;
INSERT INTO Proveedor_Proveedor (id_proveedor, nombre_empresa, nit_proveedor, tipo_servicio, nombre_contacto, telefono_principal, telefono_secundario, correo_comercial, pagina_web, id_municipio, direccion) VALUES
(1000, 'Repuestos Industriales GT S.A.',   '4500001-1', 'Repuestos',    'Roberto Morales', '22881100', '55981100', 'ventas@repuestosgt.com',       'https://www.repuestosgt.com',      200, '6a Avenida 12-50 Zona 9, Guatemala'),
(1001, 'Combustibles del Sur S.A.',        '4500002-2', 'Combustible',  'Ana Fuentes',     '78821200', '55821200', 'comercial@combustiblessur.com', 'https://www.combustiblessur.com',  205, 'Km 62 Carretera al Pacifico, Escuintla'),
(1002, 'TallerMaq Express S.A.',           '4500003-3', 'Mantenimiento','Sergio Juarez',   '22563300', '55563300', 'servicio@tallermaq.com',       'https://www.tallermaq.com',        200, '11 Calle 5-40 Zona 1, Guatemala'),
(1003, 'Neumaticos de Guatemala S.A.',     '4500004-4', 'Neumaticos',   'Carmen Lopez',    '23341400', '55341400', 'ventas@neumaticosgt.com',      'https://www.neumaticosgt.com',     201, 'Calzada Roosevelt 28-60, Mixco'),
(1004, 'Lubricantes Centroamerica S.A.',   '4500005-5', 'Lubricantes',  'Pedro Alvarado',  '24561500', '55561500', 'gerencia@lubricentro.com',     'https://www.lubricentro.com',      202, 'Avenida Las Americas 10-20 Zona 13'),
(1005, 'Transportes Unidos S.A.',          '4500006-6', 'Transporte',   'Luis Castro',     '22771600', '55771600', 'logistica@transunidos.com',    'https://www.transunidos.com',      200, 'Bulevar El Naranjo Km 14.5, Mixco'),
(1006, 'Seguros Industriales GT S.A.',     '4500007-7', 'Seguros',      'Maria Gonzalez',  '23311700', '55311700', 'polizas@segurosingt.com',      'https://www.segurosingt.com',      200, '10 Calle 3-17 Zona 10, Guatemala'),
(1007, 'Filtros y Repuestos CR S.A.',      '4500008-8', 'Repuestos',    'Jorge Ramos',     '78551800', '55551800', 'ventas@filtroscr.com',         'https://www.filtroscr.com',        208, '4a Calle 20-15 Zona 3, Quetzaltenango'),
(1008, 'Combustibles del Norte S.A.',      '4500009-9', 'Combustible',  'Claudia Mendez',  '79221900', '55221900', 'ventas@combunorte.com',        'https://www.combunorte.com',       213, '2a Avenida Final, Coban'),
(1009, 'Maquinaria y Servicio Total S.A.', '4500010-0', 'Mantenimiento','Ernesto Barrios', '22662000', '55662000', 'soporte@maqservicio.com',      'https://www.maqservicio.com',      209, 'Calle del Arco 5-15, Antigua Guatemala');
SET IDENTITY_INSERT Proveedor_Proveedor OFF;
GO

-- ============================================================================================================================
-- MÓDULO 4 — MAQUINARIA Y EQUIPOS
-- ============================================================================================================================

CREATE TABLE Maquinaria_Bodega (
    id_bodega           INT             NOT NULL IDENTITY(1,1),
    nombre_bodega       VARCHAR(100)    NOT NULL,
    id_municipio        INT             NOT NULL,
    direccion           VARCHAR(200)    NOT NULL,
    capacidad_equipos   INT             NOT NULL DEFAULT 20,
    responsable         VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Bodega                PRIMARY KEY (id_bodega),
    CONSTRAINT FK_Bodega_Municipio      FOREIGN KEY (id_municipio) REFERENCES Geografia_Municipio(id_municipio)
);
GO

CREATE TABLE Maquinaria_ModeloMaquinaria (
    id_modelo           INT             NOT NULL IDENTITY(1,1),
    id_marca            INT             NOT NULL,
    id_categoria        INT             NOT NULL,
    nombre_modelo       VARCHAR(80)     NOT NULL,
    anio_fabricacion    INT             NOT NULL,
    peso_toneladas      DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    potencia_hp         INT             NOT NULL DEFAULT 0,
    CONSTRAINT PK_ModeloMaquinaria  PRIMARY KEY (id_modelo),
    CONSTRAINT FK_Modelo_Marca      FOREIGN KEY (id_marca)     REFERENCES Catalogo_Marca(id_marca),
    CONSTRAINT FK_Modelo_Categoria  FOREIGN KEY (id_categoria) REFERENCES Catalogo_CategoriaMaquinaria(id_categoria),
    CONSTRAINT CK_Modelo_anio       CHECK (anio_fabricacion BETWEEN 1950 AND 2100)
);
GO

CREATE TABLE Maquinaria_Maquinaria (
    id_maquinaria       INT             NOT NULL IDENTITY(1,1),
    id_modelo           INT             NOT NULL,
    numero_serie        VARCHAR(60)     NOT NULL,
    placa               VARCHAR(20)     NOT NULL,
    anio_adquisicion    INT             NOT NULL,
    costo_adquisicion   DECIMAL(14,2)   NOT NULL,
    estado_equipo       VARCHAR(20)     NOT NULL DEFAULT 'Disponible',
    horas_uso_total     DECIMAL(10,2)   NOT NULL DEFAULT 0,
    ubicacion_actual    VARCHAR(150)    NOT NULL DEFAULT 'Bodega Central',
    id_bodega           INT             NOT NULL,
    fecha_registro      DATE            NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT PK_Maquinaria            PRIMARY KEY (id_maquinaria),
    CONSTRAINT UQ_Maquinaria_serie      UNIQUE (numero_serie),
    CONSTRAINT UQ_Maquinaria_placa      UNIQUE (placa),
    CONSTRAINT FK_Maquinaria_Modelo     FOREIGN KEY (id_modelo) REFERENCES Maquinaria_ModeloMaquinaria(id_modelo),
    CONSTRAINT FK_Maquinaria_Bodega     FOREIGN KEY (id_bodega) REFERENCES Maquinaria_Bodega(id_bodega),
    CONSTRAINT CK_Maquinaria_estado     CHECK (estado_equipo IN ('Disponible','Alquilado','Mantenimiento','Baja','Traslado')),
    CONSTRAINT CK_Maquinaria_horas      CHECK (horas_uso_total >= 0),
    CONSTRAINT CK_Maquinaria_costo      CHECK (costo_adquisicion > 0)
);
GO

CREATE TABLE Maquinaria_AccesorioMaquinaria (
    id_accesorio            INT             NOT NULL IDENTITY(1,1),
    id_maquinaria           INT             NOT NULL,
    nombre_accesorio        VARCHAR(100)    NOT NULL,
    numero_serie_acc        VARCHAR(60)     NOT NULL,
    estado                  VARCHAR(20)     NOT NULL DEFAULT 'Bueno',
    incluido_en_alquiler    CHAR(2)         NOT NULL DEFAULT 'SI',  -- reemplaza BIT
    CONSTRAINT PK_Accesorio             PRIMARY KEY (id_accesorio),
    CONSTRAINT FK_Accesorio_Maquinaria  FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT CK_Accesorio_estado      CHECK (estado IN ('Bueno','Danado','Baja')),
    CONSTRAINT CK_Accesorio_alquiler    CHECK (incluido_en_alquiler IN ('SI','NO'))
);
GO

SET IDENTITY_INSERT Maquinaria_Bodega ON;
INSERT INTO Maquinaria_Bodega (id_bodega, nombre_bodega, id_municipio, direccion, capacidad_equipos, responsable) VALUES
(50, 'Bodega Central Guatemala', 200, 'Km 15.5 Bulevar El Naranjo, Zona 4 Mixco',        30, 'Ing. Roberto Alvarez'),
(51, 'Bodega Escuintla Sur',     205, 'Km 65 Ruta al Pacifico, Escuintla',               20, 'Ing. Luis Monroy'),
(52, 'Bodega Xela Occidente',    208, '4a Calle 8-22 Zona Industrial, Quetzaltenango',   15, 'Ing. Mario Perez'),
(53, 'Bodega Coban Norte',       213, 'Av. 15 de Septiembre 3-10, Coban',                10, 'Ing. Carlos Chub'),
(54, 'Bodega Puerto Barrios',    211, 'Muelle Industrial, Puerto Barrios, Izabal',        25, 'Ing. Ana Lopez');
SET IDENTITY_INSERT Maquinaria_Bodega OFF;
GO
 
-- Nota: id_marca referencia 500..514, id_categoria referencia 600..619
SET IDENTITY_INSERT Maquinaria_ModeloMaquinaria ON;
INSERT INTO Maquinaria_ModeloMaquinaria (id_modelo, id_marca, id_categoria, nombre_modelo, anio_fabricacion, peso_toneladas, potencia_hp) VALUES
(2000, 500, 600, 'CAT 320',           2018, 20.50, 148),
(2001, 501, 600, 'Komatsu PC210',     2019, 21.30, 155),
(2002, 500, 601, 'CAT 950M',          2020, 18.70, 218),
(2003, 501, 603, 'Komatsu D85',       2017, 26.40, 240),
(2004, 502, 600, 'Volvo EC380',       2021, 38.00, 296),   -- categoria Excavadora=600
(2005, 503, 606, 'Liebherr LTM 1100', 2019, 60.00, 503),
(2006, 504, 605, 'John Deere 310L',   2020,  8.60,  74),
(2007, 505, 600, 'Hitachi ZX200',     2018, 20.00, 148),
(2008, 506, 601, 'Case 821G',         2021, 18.50, 218),
(2009, 508, 605, 'JCB 3CX',           2022,  8.90, 100),
(2010, 500, 610, 'CAT 745',           2020, 42.80, 490),
(2011, 510, 611, 'Mack Granite 6x4',  2019, 16.00, 415),
(2012, 511, 610, 'Kenworth T800',     2021, 15.80, 450),
(2013, 500, 604, 'CAT CS56',          2020, 11.20, 120),
(2014, 501, 614, 'Komatsu PC55MR',    2022,  5.80,  43),
(2015, 502, 619, 'Volvo G946B',       2021, 19.80, 215),
(2016, 500, 617, 'CAT 745C',          2022, 43.00, 495),
(2017, 503, 616, 'Liebherr LTF 1045', 2020, 45.00, 350),
(2018, 504, 618, 'John Deere P524',   2021, 18.00, 185),
(2019, 505, 609, 'Hitachi ZX33U',     2023,  3.50,  22);
SET IDENTITY_INSERT Maquinaria_ModeloMaquinaria OFF;
GO
 
-- Nota: id_modelo referencia 2000..2019, id_bodega referencia 50..54
SET IDENTITY_INSERT Maquinaria_Maquinaria ON;
INSERT INTO Maquinaria_Maquinaria (id_maquinaria, id_modelo, numero_serie, placa, anio_adquisicion, costo_adquisicion, estado_equipo, horas_uso_total, ubicacion_actual, id_bodega) VALUES
(3000, 2000, 'CAT320-2018-001',  'M-001-GTQ', 2018,  850000.00, 'Disponible',    1250.50, 'Bodega Central Guatemala', 50),
(3001, 2001, 'KOM210-2019-001',  'M-002-GTQ', 2019,  920000.00, 'Alquilado',     2100.00, 'Zona 10 Guatemala',        50),
(3002, 2002, 'CAT950-2020-001',  'M-003-GTQ', 2020,  780000.00, 'Disponible',     890.00, 'Bodega Central Guatemala', 50),
(3003, 2003, 'KOMD85-2017-001',  'M-004-GTQ', 2017, 1150000.00, 'Mantenimiento', 4500.00, 'Taller Express',           50),
(3004, 2004, 'VOLEC-2021-001',   'M-005-GTQ', 2021, 1800000.00, 'Alquilado',      630.00, 'Proyecto Carretera CA-9',  51),
(3005, 2005, 'LIEBR-2019-001',   'M-006-GTQ', 2019, 3500000.00, 'Disponible',    1100.00, 'Bodega Escuintla',         51),
(3006, 2006, 'JD310L-2020-001',  'M-007-GTQ', 2020,  320000.00, 'Alquilado',      780.00, 'Residencial Los Pinos',    50),
(3007, 2007, 'HITZ200-2018-001', 'M-008-GTQ', 2018,  870000.00, 'Disponible',    2250.00, 'Bodega Xela',              52),
(3008, 2008, 'CASE821-2021-001', 'M-009-GTQ', 2021,  750000.00, 'Disponible',     410.00, 'Bodega Xela',              52),
(3009, 2009, 'JCB3CX-2022-001',  'M-010-GTQ', 2022,  290000.00, 'Alquilado',      185.00, 'Edificio Zona 10',         50),
(3010, 2010, 'CAT745-2020-001',  'M-011-GTQ', 2020, 1650000.00, 'Disponible',    3100.00, 'Bodega Central Guatemala', 50),
(3011, 2011, 'MACKG-2019-001',   'M-012-GTQ', 2019,  680000.00, 'Alquilado',     4200.00, 'Ruta CA-9 Norte',          50),
(3012, 2012, 'KENW-2021-001',    'M-013-GTQ', 2021,  720000.00, 'Disponible',    1800.00, 'Bodega Puerto Barrios',    54),
(3013, 2013, 'CATCS-2020-001',   'M-014-GTQ', 2020,  420000.00, 'Disponible',     650.00, 'Bodega Escuintla',         51),
(3014, 2014, 'KOM55-2022-001',   'M-015-GTQ', 2022,  210000.00, 'Alquilado',      220.00, 'Hospital Nacional',        50),
(3015, 2015, 'VOLG946-2021-001', 'M-016-GTQ', 2021,  980000.00, 'Traslado',      1450.00, 'En ruta a Coban',          53),
(3016, 2016, 'CAT745C-2022-001', 'M-017-GTQ', 2022, 1700000.00, 'Disponible',     320.00, 'Bodega Coban',             53),
(3017, 2017, 'LIEBLTF-2020-001', 'M-018-GTQ', 2020, 2800000.00, 'Disponible',     900.00, 'Bodega Central Guatemala', 50),
(3018, 2018, 'JDP524-2021-001',  'M-019-GTQ', 2021, 1200000.00, 'Alquilado',      510.00, 'Carretera al Atlantico',   54),
(3019, 2019, 'HITZ33-2023-001',  'M-020-GTQ', 2023,  180000.00, 'Disponible',      90.00, 'Bodega Central Guatemala', 50);
SET IDENTITY_INSERT Maquinaria_Maquinaria OFF;
GO
 
-- Nota: id_maquinaria referencia 3000..3019
SET IDENTITY_INSERT Maquinaria_AccesorioMaquinaria ON;
INSERT INTO Maquinaria_AccesorioMaquinaria (id_accesorio, id_maquinaria, nombre_accesorio, numero_serie_acc, estado, incluido_en_alquiler) VALUES
(4000, 3000, 'Balde Estandar 0.9m3',   'ACC-001-BAL', 'Bueno',  'SI'),
(4001, 3000, 'Martillo Hidraulico',     'ACC-001-MHD', 'Bueno',  'SI'),
(4002, 3001, 'Balde Profundo 1.2m3',   'ACC-002-BAL', 'Bueno',  'SI'),
(4003, 3002, 'Horquilla Cargador',      'ACC-003-HRQ', 'Bueno',  'SI'),
(4004, 3003, 'Cuchilla Angulable',      'ACC-004-CUA', 'Bueno',  'SI'),
(4005, 3004, 'Cuchara de Drenaje',      'ACC-005-CUD', 'Bueno',  'SI'),
(4006, 3005, 'Gancho para Eslingas',    'ACC-006-GNH', 'Bueno',  'SI'),
(4007, 3006, 'Retropalin Extendible',   'ACC-007-RET', 'Bueno',  'SI'),
(4008, 3007, 'Balde Lateral',           'ACC-008-BAL', 'Danado', 'NO'),
(4009, 3009, 'Balde Compacto 0.2m3',   'ACC-010-BAL', 'Bueno',  'SI'),
(4010, 3010, 'Caja Volcadora Reforzada','ACC-011-CVR', 'Bueno',  'SI'),
(4011, 3011, 'Tanque Auxiliar 200L',    'ACC-012-TNK', 'Bueno',  'SI'),
(4012, 3014, 'Balde Mini 0.15m3',       'ACC-015-BAL', 'Bueno',  'SI'),
(4013, 3017, 'Flecha Telescopica 50m',  'ACC-018-FTL', 'Bueno',  'SI'),
(4014, 3019, 'Perforador de Roca 80mm', 'ACC-020-PRF', 'Bueno',  'SI');
SET IDENTITY_INSERT Maquinaria_AccesorioMaquinaria OFF;
GO
-- ============================================================================================================================
-- MÓDULO 5 — RECURSOS HUMANOS
-- ============================================================================================================================

CREATE TABLE RRHH_Cargo (
    id_cargo            INT             NOT NULL IDENTITY(1,1),
    nombre_cargo        VARCHAR(80)     NOT NULL,
    nivel_jerarquico    INT             NOT NULL,
    salario_base        DECIMAL(10,2)   NOT NULL,
    requiere_licencia   CHAR(2)         NOT NULL DEFAULT 'NO',  -- reemplaza BIT
    CONSTRAINT PK_Cargo             PRIMARY KEY (id_cargo),
    CONSTRAINT UQ_Cargo_nombre      UNIQUE (nombre_cargo),
    CONSTRAINT CK_Cargo_nivel       CHECK (nivel_jerarquico BETWEEN 1 AND 5),
    CONSTRAINT CK_Cargo_salario     CHECK (salario_base > 0),
    CONSTRAINT CK_Cargo_licencia    CHECK (requiere_licencia IN ('SI','NO'))
);
GO

CREATE TABLE RRHH_DepartamentoEmpresa (
    id_departamento_emp INT             NOT NULL IDENTITY(1,1),
    nombre_departamento VARCHAR(80)     NOT NULL,
    descripcion         VARCHAR(500)    NOT NULL,
    id_gerente          INT                 NULL,
    CONSTRAINT PK_DepartamentoEmpresa   PRIMARY KEY (id_departamento_emp),
    CONSTRAINT UQ_Depto_nombre          UNIQUE (nombre_departamento)
);
GO

CREATE TABLE RRHH_Empleado (
    id_empleado             INT             NOT NULL IDENTITY(1,1),
    dpi                     VARCHAR(20)     NOT NULL,
    nombre                  VARCHAR(60)     NOT NULL,
    apellido                VARCHAR(60)     NOT NULL,
    id_cargo                INT             NOT NULL,
    id_departamento_emp     INT             NOT NULL,
    fecha_contratacion      DATE            NOT NULL,
    salario_actual          DECIMAL(10,2)   NOT NULL,
    telefono                VARCHAR(20)     NOT NULL,
    correo_corporativo      VARCHAR(100)    NOT NULL,
    estado                  VARCHAR(15)     NOT NULL DEFAULT 'Activo',
    id_municipio            INT             NOT NULL,
    CONSTRAINT PK_Empleado              PRIMARY KEY (id_empleado),
    CONSTRAINT UQ_Empleado_dpi          UNIQUE (dpi),
    CONSTRAINT UQ_Empleado_correo       UNIQUE (correo_corporativo),
    CONSTRAINT FK_Empleado_Cargo        FOREIGN KEY (id_cargo)              REFERENCES RRHH_Cargo(id_cargo),
    CONSTRAINT FK_Empleado_Depto        FOREIGN KEY (id_departamento_emp)   REFERENCES RRHH_DepartamentoEmpresa(id_departamento_emp),
    CONSTRAINT FK_Empleado_Municipio    FOREIGN KEY (id_municipio)          REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Empleado_estado       CHECK (estado IN ('Activo','Inactivo','Suspendido')),
    CONSTRAINT CK_Empleado_salario      CHECK (salario_actual > 0)
);
GO

ALTER TABLE RRHH_DepartamentoEmpresa
    ADD CONSTRAINT FK_Depto_Gerente FOREIGN KEY (id_gerente) REFERENCES RRHH_Empleado(id_empleado);
GO

CREATE TABLE RRHH_CertificacionConductor (
    id_cert                 INT             NOT NULL IDENTITY(1,1),
    id_empleado             INT             NOT NULL,
    entidad_certificadora   VARCHAR(100)    NOT NULL,
    numero_certificado      VARCHAR(60)     NOT NULL,
    tipo_licencia           VARCHAR(40)     NOT NULL,
    fecha_emision           DATE            NOT NULL,
    fecha_vencimiento       DATE            NOT NULL,
    estado_cert             VARCHAR(20)     NOT NULL DEFAULT 'Vigente',
    CONSTRAINT PK_CertificacionConductor    PRIMARY KEY (id_cert),
    CONSTRAINT UQ_Cert_numero               UNIQUE (numero_certificado),
    CONSTRAINT FK_Cert_Empleado             FOREIGN KEY (id_empleado) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Cert_estado               CHECK (estado_cert IN ('Vigente','Vencida','Revocada')),
    CONSTRAINT CK_Cert_fechas               CHECK (fecha_vencimiento > fecha_emision)
);
GO

select * from RRHH_Cargo
SET IDENTITY_INSERT RRHH_Cargo ON;
INSERT INTO RRHH_Cargo (id_cargo, nombre_cargo, nivel_jerarquico, salario_base, requiere_licencia) VALUES
(400, 'Gerente General',          1, 35000.00, 'NO'),
(401, 'Gerente de Operaciones',   1, 28000.00, 'NO'),
(402, 'Gerente Financiero',       1, 28000.00, 'NO'),
(403, 'Gerente de RRHH',          1, 25000.00, 'NO'),
(404, 'Jefe de Logistica',        2, 18000.00, 'NO'),
(405, 'Operador de Maquinaria A', 3,  9500.00, 'SI'),
(406, 'Operador de Maquinaria B', 3,  8500.00, 'SI'),
(407, 'Conductor de Transporte',  3,  7800.00, 'SI'),
(408, 'Tecnico Mecanico',         3,  8000.00, 'NO'),
(409, 'Inspector de Carga',       3,  7500.00, 'NO'),
(410, 'Ejecutivo de Ventas',      2, 12000.00, 'NO'),
(411, 'Auxiliar Contable',        4,  5500.00, 'NO'),
(412, 'Asistente Administrativo', 4,  5000.00, 'NO'),
(413, 'Bodeguero',                4,  5200.00, 'NO'),
(414, 'Auxiliar de Mantenimiento',4,  5800.00, 'NO');
SET IDENTITY_INSERT RRHH_Cargo OFF;
GO
 
SET IDENTITY_INSERT RRHH_DepartamentoEmpresa ON;
INSERT INTO RRHH_DepartamentoEmpresa (id_departamento_emp, nombre_departamento, descripcion) VALUES
(450, 'Gerencia General',   'Direccion estrategica y toma de decisiones de alto nivel.'),
(451, 'Operaciones',        'Gestion de traslados, rutas y operacion de maquinaria en campo.'),
(452, 'Finanzas',           'Control contable, facturacion, pagos y presupuesto empresarial.'),
(453, 'Recursos Humanos',   'Reclutamiento, nominas, capacitaciones y bienestar del personal.'),
(454, 'Ventas y Contratos', 'Atencion a clientes, generacion de contratos y seguimiento comercial.'),
(455, 'Mantenimiento',      'Mantenimiento preventivo y correctivo de toda la flota de maquinaria.'),
(456, 'Logistica',          'Planificacion de rutas, coordinacion de transportistas y aduanas.'),
(457, 'Tecnologia',         'Administracion de sistemas, bases de datos y soporte informatico.');
SET IDENTITY_INSERT RRHH_DepartamentoEmpresa OFF;
GO
 
-- Nota: id_cargo ref 400..414, id_departamento_emp ref 450..457, id_municipio ref 200..223
SET IDENTITY_INSERT RRHH_Empleado ON;
INSERT INTO RRHH_Empleado (id_empleado, dpi, nombre, apellido, id_cargo, id_departamento_emp, fecha_contratacion, salario_actual, telefono, correo_corporativo, estado, id_municipio) VALUES
(5000, '1234567890101', 'Carlos',   'Mendoza',   400, 450, '2018-01-15', 35000.00, '55100001', 'c.mendoza@maqgt.com',   'Activo', 200),
(5001, '1234567890202', 'Ana',      'Fuentes',   401, 451, '2018-03-10', 28000.00, '55100002', 'a.fuentes@maqgt.com',   'Activo', 201),
(5002, '1234567890303', 'Roberto',  'Lima',      402, 452, '2019-01-20', 28000.00, '55100003', 'r.lima@maqgt.com',      'Activo', 200),
(5003, '1234567890404', 'Sandra',   'Barrios',   403, 453, '2019-06-01', 25000.00, '55100004', 's.barrios@maqgt.com',   'Activo', 202),
(5004, '1234567890505', 'Miguel',   'Giron',     404, 456, '2020-02-14', 18000.00, '55100005', 'm.giron@maqgt.com',     'Activo', 200),
(5005, '1234567890606', 'Jose',     'Ruiz',      405, 451, '2020-05-01',  9500.00, '55100006', 'j.ruiz@maqgt.com',      'Activo', 201),
(5006, '1234567890707', 'Pedro',    'Orozco',    406, 451, '2020-06-15',  8500.00, '55100007', 'p.orozco@maqgt.com',    'Activo', 200),
(5007, '1234567890808', 'Luis',     'Castillo',  407, 456, '2020-07-01',  7800.00, '55100008', 'l.castillo@maqgt.com',  'Activo', 203),
(5008, '1234567890909', 'Mario',    'Diaz',      408, 455, '2021-01-10',  8000.00, '55100009', 'm.diaz@maqgt.com',      'Activo', 200),
(5009, '1234567891010', 'Elena',    'Morales',   409, 456, '2021-03-05',  7500.00, '55100010', 'e.morales@maqgt.com',   'Activo', 201),
(5010, '1234567891111', 'Jorge',    'Velasquez', 410, 454, '2019-08-12', 12000.00, '55100011', 'j.velasquez@maqgt.com', 'Activo', 200),
(5011, '1234567891212', 'Maria',    'Escobar',   411, 452, '2020-09-01',  5500.00, '55100012', 'm.escobar@maqgt.com',   'Activo', 202),
(5012, '1234567891313', 'Diego',    'Salguero',  412, 453, '2021-11-20',  5000.00, '55100013', 'd.salguero@maqgt.com',  'Activo', 200),
(5013, '1234567891414', 'Carmen',   'Lemus',     413, 455, '2022-01-08',  5200.00, '55100014', 'c.lemus@maqgt.com',     'Activo', 205),
(5014, '1234567891515', 'Oscar',    'Ramirez',   414, 455, '2022-04-18',  5800.00, '55100015', 'o.ramirez@maqgt.com',   'Activo', 206),
(5015, '1234567891616', 'Fernando', 'Aju',       407, 456, '2021-06-01',  7800.00, '55100016', 'f.aju@maqgt.com',       'Activo', 200),
(5016, '1234567891717', 'Hector',   'Tahay',     407, 456, '2020-09-15',  7800.00, '55100017', 'h.tahay@maqgt.com',     'Activo', 201),
(5017, '1234567891818', 'Blanca',   'Coy',       409, 456, '2022-02-01',  7500.00, '55100018', 'b.coy@maqgt.com',       'Activo', 208),
(5018, '1234567891919', 'Raul',     'Chun',      408, 455, '2019-11-10',  8000.00, '55100019', 'r.chun@maqgt.com',      'Activo', 213),
(5019, '1234567892020', 'Wendy',    'Pop',       410, 454, '2023-03-01', 12000.00, '55100020', 'w.pop@maqgt.com',       'Activo', 200);
SET IDENTITY_INSERT RRHH_Empleado OFF;
GO
 
-- Asignar gerentes — id_gerente referencia id_empleado (5000..5019)
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5000 WHERE id_departamento_emp = 450;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5001 WHERE id_departamento_emp = 451;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5002 WHERE id_departamento_emp = 452;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5003 WHERE id_departamento_emp = 453;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5010 WHERE id_departamento_emp = 454;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5008 WHERE id_departamento_emp = 455;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5004 WHERE id_departamento_emp = 456;
UPDATE RRHH_DepartamentoEmpresa SET id_gerente = 5012 WHERE id_departamento_emp = 457;
GO
 
-- Nota: id_empleado referencia 5000..5019
SET IDENTITY_INSERT RRHH_CertificacionConductor ON;
INSERT INTO RRHH_CertificacionConductor (id_cert, id_empleado, entidad_certificadora, numero_certificado, tipo_licencia, fecha_emision, fecha_vencimiento, estado_cert) VALUES
(6000, 5005, 'Departamento de Transito Guatemala', 'LIC-101-2023', 'Tipo A', '2023-01-10', '2026-01-10', 'Vigente'),
(6001, 5006, 'Departamento de Transito Guatemala', 'LIC-102-2022', 'Tipo B', '2022-03-15', '2025-03-15', 'Vigente'),
(6002, 5007, 'Departamento de Transito Guatemala', 'LIC-103-2023', 'Tipo C', '2023-05-20', '2026-05-20', 'Vigente'),
(6003, 5008, 'Departamento de Transito Guatemala', 'LIC-104-2021', 'Tipo M', '2021-07-12', '2024-07-12', 'Vencida'),
(6004, 5015, 'Departamento de Transito Guatemala', 'LIC-105-2022', 'Tipo A', '2022-09-01', '2025-09-01', 'Vigente'),
(6005, 5016, 'Departamento de Transito Guatemala', 'LIC-106-2023', 'Tipo B', '2023-02-18', '2026-02-18', 'Vigente'),
(6006, 5004, 'Departamento de Transito Guatemala', 'LIC-107-2021', 'Tipo C', '2021-11-30', '2024-11-30', 'Vencida'),
(6007, 5009, 'Departamento de Transito Guatemala', 'LIC-108-2023', 'Tipo A', '2023-08-25', '2026-08-25', 'Vigente'),
(6008, 5017, 'Departamento de Transito Guatemala', 'LIC-109-2022', 'Tipo B', '2022-12-05', '2025-12-05', 'Vigente'),
(6009, 5019, 'Departamento de Transito Guatemala', 'LIC-110-2023', 'Tipo M', '2023-06-14', '2026-06-14', 'Vigente');
SET IDENTITY_INSERT RRHH_CertificacionConductor OFF;
GO

-- ============================================================================================================================
-- MÓDULO 6 — CLIENTES Y OPERADORES DEL CLIENTE
-- ============================================================================================================================

CREATE TABLE Contratos_Cliente (
    id_cliente      INT             NOT NULL IDENTITY(1,1),
    nit_cliente     VARCHAR(20)     NOT NULL,
    razon_social    VARCHAR(150)    NOT NULL,
    tipo_cliente    VARCHAR(30)     NOT NULL DEFAULT 'Empresa',
    telefono        VARCHAR(20)     NOT NULL,
    correo          VARCHAR(100)    NOT NULL,
    fecha_registro  DATE            NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    id_municipio    INT             NOT NULL,
    activo          CHAR(2)         NOT NULL DEFAULT 'SI',   -- reemplaza BIT
    CONSTRAINT PK_Cliente           PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_Cliente_nit       UNIQUE (nit_cliente),
    CONSTRAINT FK_Cliente_Municipio FOREIGN KEY (id_municipio) REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Cliente_tipo      CHECK (tipo_cliente IN ('Individual','Empresa','Gobierno')),
    CONSTRAINT CK_Cliente_activo    CHECK (activo IN ('SI','NO'))
);
GO

CREATE TABLE Contratos_ContactoCliente (
    id_contacto         INT             NOT NULL IDENTITY(1,1),
    id_cliente          INT             NOT NULL,
    nombre_contacto     VARCHAR(100)    NOT NULL,
    cargo               VARCHAR(80)     NOT NULL,
    telefono_directo    VARCHAR(20)     NOT NULL,
    correo_contacto     VARCHAR(100)    NOT NULL,
    es_principal        CHAR(2)         NOT NULL DEFAULT 'NO',  -- reemplaza BIT
    CONSTRAINT PK_ContactoCliente       PRIMARY KEY (id_contacto),
    CONSTRAINT FK_Contacto_Cliente      FOREIGN KEY (id_cliente) REFERENCES Contratos_Cliente(id_cliente),
    CONSTRAINT CK_Contacto_principal    CHECK (es_principal IN ('SI','NO'))
);
GO

CREATE TABLE Contratos_OperadorCliente (
    id_operador_cliente INT             NOT NULL IDENTITY(1,1),
    id_cliente          INT             NOT NULL,
    nombre              VARCHAR(60)     NOT NULL,
    apellido            VARCHAR(60)     NOT NULL,
    dpi                 VARCHAR(20)     NOT NULL,
    telefono            VARCHAR(20)     NOT NULL,
    licencia_operacion  VARCHAR(60)     NOT NULL,
    tipo_licencia       VARCHAR(40)     NOT NULL,
    vencimiento_licencia DATE           NOT NULL,
    activo              CHAR(2)         NOT NULL DEFAULT 'SI',  -- reemplaza BIT
    CONSTRAINT PK_OperadorCliente       PRIMARY KEY (id_operador_cliente),
    CONSTRAINT UQ_OperadorCliente_dpi   UNIQUE (dpi),
    CONSTRAINT FK_OpCliente_Cliente     FOREIGN KEY (id_cliente) REFERENCES Contratos_Cliente(id_cliente),
    CONSTRAINT CK_OperadorCliente_activo CHECK (activo IN ('SI','NO'))
);
GO

SET IDENTITY_INSERT Contratos_Cliente ON;
INSERT INTO Contratos_Cliente (id_cliente, nit_cliente, razon_social, tipo_cliente, telefono, correo, id_municipio, activo) VALUES
(7000, '7001001-1', 'Constructora Moderna S.A.',       'Empresa',    '23310001', 'info@constructoramoderna.com',   200, 'SI'),
(7001, '7001002-2', 'Grupo Vial Centroam. S.A.',        'Empresa',    '23310002', 'contacto@grupovialca.com',       201, 'SI'),
(7002, '7001003-3', 'Residenciales del Valle S.A.',      'Empresa',    '23310003', 'info@residencialesdelvalle.com', 202, 'SI'),
(7003, '7001004-4', 'Inversiones Comerciales GT S.A.',  'Empresa',    '23310004', 'info@inversionescomgt.com',      209, 'SI'),
(7004, '7001005-5', 'Agroindustrias del Sur S.A.',       'Empresa',    '23310005', 'info@agroindustriasdelsu.com',   205, 'SI'),
(7005, '7001006-6', 'Ministerio de Salud Publica',       'Gobierno',   '23310006', 'compras@mspas.gob.gt',           200, 'SI'),
(7006, '7001007-7', 'Energia Renovable de GT S.A.',      'Empresa',    '23310007', 'info@energiagt.com',             206, 'SI'),
(7007, '7001008-8', 'Infraestructura Vial S.A.',         'Empresa',    '23310008', 'licitaciones@infravial.com',     214, 'SI'),
(7008, '7001009-9', 'Deportes y Recreacion GT S.A.',     'Empresa',    '23310009', 'info@deportesgt.com',            208, 'SI'),
(7009, '7001010-0', 'Parque Industrial Zona Norte S.A.', 'Empresa',    '23310010', 'info@parqueindustrial.com',      209, 'SI'),
(7010, '7001011-1', 'Conglomerado Portuario S.A.',       'Empresa',    '23310011', 'operaciones@conglopuerto.com',   211, 'SI'),
(7011, '7001012-2', 'Mineria Central S.A.',              'Empresa',    '23310012', 'info@mineriacentral.com',        213, 'SI'),
(7012, '7001013-3', 'Autopistas del Pacifico S.A.',      'Empresa',    '23310013', 'info@autopistaspacifico.com',    214, 'SI'),
(7013, '7001014-4', 'Hospital Privado Occidente S.A.',   'Empresa',    '23310014', 'compras@hospitalocc.com',        208, 'SI'),
(7014, '7001015-5', 'LogiPort Operaciones S.A.',          'Empresa',    '23310015', 'info@logiport.com',              211, 'SI'),
(7015, '7001016-6', 'Fernando Jimenez (Individual)',      'Individual', '55190016', 'fjimenez@personal.com',          200, 'SI'),
(7016, '7001017-7', 'Hermanos Lopez y Cia.',             'Empresa',    '23310017', 'contacto@hnolopez.com',          201, 'SI'),
(7017, '7001018-8', 'Cerveceria Regional S.A.',           'Empresa',    '23310018', 'logistica@cerveceriareg.com',    202, 'SI'),
(7018, '7001019-9', 'Textiles de Exportacion S.A.',       'Empresa',    '23310019', 'info@textilesexp.com',           209, 'SI'),
(7019, '7001020-0', 'Gobierno Municipal de Mixco',        'Gobierno',   '23310020', 'obras@munimixco.gob.gt',         201, 'SI');
SET IDENTITY_INSERT Contratos_Cliente OFF;
GO
 
-- Nota: id_cliente referencia 7000..7019
SET IDENTITY_INSERT Contratos_ContactoCliente ON;
INSERT INTO Contratos_ContactoCliente (id_contacto, id_cliente, nombre_contacto, cargo, telefono_directo, correo_contacto, es_principal) VALUES
(8000, 7000, 'Roberto Aju',       'Gerente de Proyectos',    '55201001', 'r.aju@constructoramoderna.com',      'SI'),
(8001, 7001, 'Mirna Lopez',       'Jefa de Compras',          '55201002', 'm.lopez@grupovialca.com',             'SI'),
(8002, 7002, 'Ernesto Chavarria', 'Director Tecnico',         '55201003', 'e.chavarria@residencialesdelvalle.com','SI'),
(8003, 7003, 'Patricia Barrios',  'Administradora',           '55201004', 'p.barrios@inversionescomgt.com',      'SI'),
(8004, 7004, 'Luis Portillo',     'Gerente Agricola',         '55201005', 'l.portillo@agroindustriasdelsu.com',  'SI'),
(8005, 7005, 'Dra. Carmen Soto',  'Directora Administrativa', '55201006', 'c.soto@mspas.gob.gt',                'SI'),
(8006, 7006, 'Ing. Pablo Cuc',    'Director de Proyectos',    '55201007', 'p.cuc@energiagt.com',                'SI'),
(8007, 7007, 'Ing. Mario Tzoc',   'Jefe de Obra',             '55201008', 'm.tzoc@infravial.com',               'SI'),
(8008, 7008, 'Laura Samayoa',     'Coordinadora',             '55201009', 'l.samayoa@deportesgt.com',           'SI'),
(8009, 7009, 'Lic. Alvaro Mus',   'Gerente General',          '55201010', 'a.mus@parqueindustrial.com',         'SI');
SET IDENTITY_INSERT Contratos_ContactoCliente OFF;
GO
 
SET IDENTITY_INSERT Contratos_OperadorCliente ON;
INSERT INTO Contratos_OperadorCliente (id_operador_cliente, id_cliente, nombre, apellido, dpi, telefono, licencia_operacion, tipo_licencia, vencimiento_licencia, activo) VALUES
(9000, 7000, 'Carlos',  'Mendoza',   '3000000010101', '55510001', 'LIC-OP-201', 'Tipo A', '2026-01-10', 'SI'),
(9001, 7001, 'Luis',    'Ramirez',   '3000000020202', '55510002', 'LIC-OP-202', 'Tipo B', '2026-03-15', 'SI'),
(9002, 7002, 'Jose',    'Hernandez', '3000000030303', '55510003', 'LIC-OP-203', 'Tipo C', '2026-05-20', 'SI'),
(9003, 7003, 'Miguel',  'Lopez',     '3000000040404', '55510004', 'LIC-OP-204', 'Tipo M', '2026-07-12', 'SI'),
(9004, 7004, 'Pedro',   'Castillo',  '3000000050505', '55510005', 'LIC-OP-205', 'Tipo A', '2025-09-01', 'NO'),
(9005, 7005, 'Juan',    'Morales',   '3000000060606', '55510006', 'LIC-OP-206', 'Tipo B', '2026-02-18', 'SI'),
(9006, 7006, 'Mario',   'Gomez',     '3000000070707', '55510007', 'LIC-OP-207', 'Tipo C', '2026-11-30', 'SI'),
(9007, 7007, 'Diego',   'Perez',     '3000000080808', '55510008', 'LIC-OP-208', 'Tipo A', '2025-08-25', 'SI'),
(9008, 7008, 'Andres',  'Diaz',      '3000000090909', '55510009', 'LIC-OP-209', 'Tipo B', '2026-12-05', 'SI'),
(9009, 7009, 'Oscar',   'Reyes',     '3000000101010', '55510010', 'LIC-OP-210', 'Tipo M', '2026-06-14', 'SI');
SET IDENTITY_INSERT Contratos_OperadorCliente OFF;
GO

-- ============================================================================================================================
-- MÓDULO 7 — CONTRATOS Y FACTURACIÓN
-- ============================================================================================================================

CREATE TABLE Contratos_Tarifa (
    id_tarifa           INT             NOT NULL IDENTITY(1,1),
    id_categoria        INT             NOT NULL,
    id_modelo           INT             NOT NULL,
    tarifa_diaria       DECIMAL(10,2)   NOT NULL,
    tarifa_semanal      DECIMAL(10,2)   NOT NULL,
    tarifa_mensual      DECIMAL(10,2)   NOT NULL,
    incluye_operador    CHAR(2)         NOT NULL DEFAULT 'NO',   -- reemplaza BIT
    vigente_desde       DATE            NOT NULL,
    vigente_hasta       DATE            NOT NULL DEFAULT '2099-12-31',
    CONSTRAINT PK_Tarifa            PRIMARY KEY (id_tarifa),
    CONSTRAINT FK_Tarifa_Categoria  FOREIGN KEY (id_categoria) REFERENCES Catalogo_CategoriaMaquinaria(id_categoria),
    CONSTRAINT FK_Tarifa_Modelo     FOREIGN KEY (id_modelo)    REFERENCES Maquinaria_ModeloMaquinaria(id_modelo),
    CONSTRAINT CK_Tarifa_diaria     CHECK (tarifa_diaria > 0),
    CONSTRAINT CK_Tarifa_operador   CHECK (incluye_operador IN ('SI','NO'))
);
GO

CREATE TABLE Contratos_ContratoAlquiler (
    id_contrato             INT             NOT NULL IDENTITY(1,1),
    numero_contrato         VARCHAR(30)     NOT NULL,
    id_cliente              INT             NOT NULL,
    id_empleado_ventas      INT             NOT NULL,
    fecha_inicio            DATE            NOT NULL,
    fecha_fin_estimada      DATE            NOT NULL,
    fecha_fin_real          DATE                NULL,
    estado_contrato         VARCHAR(20)     NOT NULL DEFAULT 'Activo',
    valor_total             DECIMAL(14,2)   NOT NULL,
    moneda                  VARCHAR(5)      NOT NULL DEFAULT 'GTQ',
    observaciones           VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones',
    fecha_registro          DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ContratoAlquiler      PRIMARY KEY (id_contrato),
    CONSTRAINT UQ_Contrato_numero       UNIQUE (numero_contrato),
    CONSTRAINT FK_Contrato_Cliente      FOREIGN KEY (id_cliente)         REFERENCES Contratos_Cliente(id_cliente),
    CONSTRAINT FK_Contrato_Empleado     FOREIGN KEY (id_empleado_ventas) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Contrato_estado       CHECK (estado_contrato IN ('Activo','Cerrado','Cancelado','Suspendido')),
    CONSTRAINT CK_Contrato_fechas       CHECK (fecha_fin_estimada >= fecha_inicio),
    CONSTRAINT CK_Contrato_valor        CHECK (valor_total > 0)
);
GO

CREATE TABLE Contratos_DetalleContrato (
    id_detalle          INT             NOT NULL IDENTITY(1,1),
    id_contrato         INT             NOT NULL,
    id_maquinaria       INT             NOT NULL,
    fecha_entrega       DATE            NOT NULL,
    fecha_devolucion    DATE                NULL,
    tarifa_diaria       DECIMAL(10,2)   NOT NULL,
    dias_contratados    INT             NOT NULL,
    subtotal            AS (tarifa_diaria * dias_contratados) PERSISTED,
    CONSTRAINT PK_DetalleContrato       PRIMARY KEY (id_detalle),
    CONSTRAINT FK_Detalle_Contrato      FOREIGN KEY (id_contrato)   REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT FK_Detalle_Maquinaria    FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT CK_Detalle_tarifa        CHECK (tarifa_diaria > 0),
    CONSTRAINT CK_Detalle_dias          CHECK (dias_contratados > 0)
);
GO

CREATE TABLE Contratos_AsignacionOperadorCliente (
    id_asig_op_cliente  INT             NOT NULL IDENTITY(1,1),
    id_detalle_contrato INT             NOT NULL,
    id_operador_cliente INT             NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE                NULL,
    observaciones       VARCHAR(500)    NOT NULL DEFAULT 'Asignacion sin observaciones',
    CONSTRAINT PK_AsignacionOpCliente       PRIMARY KEY (id_asig_op_cliente),
    CONSTRAINT FK_AsigOp_Detalle            FOREIGN KEY (id_detalle_contrato) REFERENCES Contratos_DetalleContrato(id_detalle),
    CONSTRAINT FK_AsigOp_OperadorCliente    FOREIGN KEY (id_operador_cliente) REFERENCES Contratos_OperadorCliente(id_operador_cliente)
);
GO

CREATE TABLE Contratos_ProyectoCliente (
    id_proyecto         INT             NOT NULL IDENTITY(1,1),
    id_cliente          INT             NOT NULL,
    nombre_proyecto     VARCHAR(150)    NOT NULL,
    id_municipio        INT             NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin_estimada  DATE            NOT NULL,
    descripcion         VARCHAR(500)    NOT NULL,
    estado_proyecto     VARCHAR(20)     NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_ProyectoCliente       PRIMARY KEY (id_proyecto),
    CONSTRAINT FK_Proyecto_Cliente      FOREIGN KEY (id_cliente)   REFERENCES Contratos_Cliente(id_cliente),
    CONSTRAINT FK_Proyecto_Municipio    FOREIGN KEY (id_municipio) REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Proyecto_estado       CHECK (estado_proyecto IN ('Activo','Completado','Suspendido'))
);
GO

CREATE TABLE Contratos_ContratoProyecto (
    id_cont_proy    INT             NOT NULL IDENTITY(1,1),
    id_contrato     INT             NOT NULL,
    id_proyecto     INT             NOT NULL,
    observaciones   VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones adicionales',
    CONSTRAINT PK_ContratoProyecto      PRIMARY KEY (id_cont_proy),
    CONSTRAINT FK_ContProy_Contrato     FOREIGN KEY (id_contrato) REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT FK_ContProy_Proyecto     FOREIGN KEY (id_proyecto) REFERENCES Contratos_ProyectoCliente(id_proyecto),
    CONSTRAINT UQ_ContProy              UNIQUE (id_contrato, id_proyecto)
);
GO

CREATE TABLE Contratos_Factura (
    id_factura          INT             NOT NULL IDENTITY(1,1),
    id_contrato         INT             NOT NULL,
    numero_factura      VARCHAR(30)     NOT NULL,
    fecha_emision       DATE            NOT NULL,
    monto_subtotal      DECIMAL(12,2)   NOT NULL,
    monto_impuesto      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    monto_total         AS (monto_subtotal + monto_impuesto) PERSISTED,
    estado_pago         VARCHAR(20)     NOT NULL DEFAULT 'Pendiente',
    fecha_vencimiento   DATE            NOT NULL,
    CONSTRAINT PK_Factura           PRIMARY KEY (id_factura),
    CONSTRAINT UQ_Factura_numero    UNIQUE (numero_factura),
    CONSTRAINT FK_Factura_Contrato  FOREIGN KEY (id_contrato) REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT CK_Factura_estado    CHECK (estado_pago IN ('Pendiente','Pagada','Vencida','Anulada')),
    CONSTRAINT CK_Factura_subtotal  CHECK (monto_subtotal > 0)
);
GO

CREATE TABLE Contratos_Pago (
    id_pago                 INT             NOT NULL IDENTITY(1,1),
    id_factura              INT             NOT NULL,
    fecha_pago              DATE            NOT NULL,
    monto_pagado            DECIMAL(12,2)   NOT NULL,
    metodo_pago             VARCHAR(40)     NOT NULL,
    referencia_bancaria     VARCHAR(60)     NOT NULL,
    id_empleado_registra    INT             NOT NULL,
    CONSTRAINT PK_Pago              PRIMARY KEY (id_pago),
    CONSTRAINT FK_Pago_Factura      FOREIGN KEY (id_factura)            REFERENCES Contratos_Factura(id_factura),
    CONSTRAINT FK_Pago_Empleado     FOREIGN KEY (id_empleado_registra)  REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Pago_metodo       CHECK (metodo_pago IN ('Transferencia','Cheque','Efectivo','Deposito','Tarjeta')),
    CONSTRAINT CK_Pago_monto        CHECK (monto_pagado > 0)
);
GO

-- Nota: id_categoria ref 600..619, id_modelo ref 2000..2019
SET IDENTITY_INSERT Contratos_Tarifa ON;
INSERT INTO Contratos_Tarifa (id_tarifa, id_categoria, id_modelo, tarifa_diaria, tarifa_semanal, tarifa_mensual, incluye_operador, vigente_desde, vigente_hasta) VALUES
(10000, 600, 2000,  1200.00,  7500.00, 28000.00, 'SI', '2024-01-01', '2099-12-31'),
(10001, 600, 2001,  1300.00,  8000.00, 30000.00, 'SI', '2024-01-01', '2099-12-31'),
(10002, 601, 2002,  1000.00,  6200.00, 23000.00, 'SI', '2024-01-01', '2099-12-31'),
(10003, 603, 2003,  1500.00,  9500.00, 35000.00, 'SI', '2024-01-01', '2099-12-31'),
(10004, 600, 2004,  1800.00, 11000.00, 42000.00, 'SI', '2024-01-01', '2099-12-31'),
(10005, 606, 2005,  3500.00, 22000.00, 80000.00, 'SI', '2024-01-01', '2099-12-31'),
(10006, 605, 2006,   700.00,  4200.00, 15500.00, 'NO', '2024-01-01', '2099-12-31'),
(10007, 600, 2007,  1200.00,  7500.00, 28000.00, 'SI', '2024-01-01', '2099-12-31'),
(10008, 601, 2008,   980.00,  6000.00, 22000.00, 'NO', '2024-01-01', '2099-12-31'),
(10009, 605, 2009,   650.00,  3900.00, 14500.00, 'NO', '2024-01-01', '2099-12-31'),
(10010, 610, 2010,  2000.00, 12500.00, 46000.00, 'SI', '2024-01-01', '2099-12-31'),
(10011, 611, 2011,  1800.00, 11000.00, 40000.00, 'SI', '2024-01-01', '2099-12-31'),
(10012, 610, 2012,  1900.00, 12000.00, 44000.00, 'SI', '2024-01-01', '2099-12-31'),
(10013, 604, 2013,   800.00,  4800.00, 17500.00, 'NO', '2024-01-01', '2099-12-31'),
(10014, 614, 2014,   550.00,  3300.00, 12000.00, 'NO', '2024-01-01', '2099-12-31'),
(10015, 619, 2015,  1400.00,  8700.00, 32000.00, 'SI', '2024-01-01', '2099-12-31'),
(10016, 617, 2016,  2100.00, 13000.00, 48000.00, 'SI', '2024-01-01', '2099-12-31'),
(10017, 616, 2017,  3200.00, 20000.00, 75000.00, 'SI', '2024-01-01', '2099-12-31'),
(10018, 618, 2018,  1600.00, 10000.00, 37000.00, 'SI', '2024-01-01', '2099-12-31'),
(10019, 609, 2019,   480.00,  2900.00, 10500.00, 'NO', '2024-01-01', '2099-12-31');
SET IDENTITY_INSERT Contratos_Tarifa OFF;
GO
 
-- Nota: id_cliente ref 7000..7019, id_empleado_ventas ref 5000..5019
SET IDENTITY_INSERT Contratos_ContratoAlquiler ON;
INSERT INTO Contratos_ContratoAlquiler (id_contrato, numero_contrato, id_cliente, id_empleado_ventas, fecha_inicio, fecha_fin_estimada, fecha_fin_real, estado_contrato, valor_total, moneda, observaciones) VALUES
(11000, 'CONT-2024-001', 7000, 5010, '2024-01-10', '2024-03-10', '2024-03-08', 'Cerrado',     72000.00, 'GTQ', 'Contrato Edificio Zona 10'),
(11001, 'CONT-2024-002', 7001, 5010, '2024-02-01', '2024-06-01', NULL,         'Activo',      88000.00, 'GTQ', 'Ampliacion Carretera CA-9'),
(11002, 'CONT-2024-003', 7002, 5019, '2024-03-15', '2024-06-15', '2024-06-10', 'Cerrado',     45000.00, 'GTQ', 'Urbanizacion Residencial'),
(11003, 'CONT-2024-004', 7003, 5019, '2024-04-01', '2024-08-01', NULL,         'Activo',      65000.00, 'GTQ', 'Centro Comercial Norte'),
(11004, 'CONT-2024-005', 7004, 5010, '2024-05-10', '2024-08-10', '2024-08-05', 'Cerrado',     38000.00, 'GTQ', 'Planta de Produccion Palin'),
(11005, 'CONT-2024-006', 7005, 5019, '2024-06-01', '2024-10-01', NULL,         'Activo',      52000.00, 'GTQ', 'Remodelacion Hospital'),
(11006, 'CONT-2024-007', 7006, 5010, '2024-07-05', '2024-11-05', NULL,         'Cancelado',   95000.00, 'GTQ', 'Proyecto Hidroelectrico suspendido'),
(11007, 'CONT-2024-008', 7007, 5019, '2024-08-10', '2025-01-10', NULL,         'Activo',     120000.00, 'GTQ', 'Puente Vehicular Ruta CA-14'),
(11008, 'CONT-2024-009', 7008, 5010, '2024-09-01', '2025-01-01', NULL,         'Activo',      78000.00, 'GTQ', 'Complejo Deportivo'),
(11009, 'CONT-2024-010', 7009, 5019, '2024-10-15', '2025-04-15', NULL,         'Activo',     145000.00, 'GTQ', 'Parque Industrial Zona Norte');
SET IDENTITY_INSERT Contratos_ContratoAlquiler OFF;
GO
 
-- Nota: id_contrato ref 11000..11009, id_maquinaria ref 3000..3019
SET IDENTITY_INSERT Contratos_DetalleContrato ON;
INSERT INTO Contratos_DetalleContrato (id_detalle, id_contrato, id_maquinaria, fecha_entrega, fecha_devolucion, tarifa_diaria, dias_contratados) VALUES
(12000, 11000, 3000, '2024-01-10', '2024-03-08', 1200.00,  60),
(12001, 11001, 3004, '2024-02-01', NULL,          1800.00, 120),
(12002, 11002, 3006, '2024-03-15', '2024-06-10',  700.00,  87),
(12003, 11003, 3009, '2024-04-01', NULL,           650.00, 122),
(12004, 11004, 3002, '2024-05-10', '2024-08-05', 1000.00,  87),
(12005, 11005, 3014, '2024-06-01', NULL,           550.00, 122),
(12006, 11006, 3005, '2024-07-05', NULL,          3500.00, 123),
(12007, 11007, 3018, '2024-08-10', NULL,          1600.00, 153),
(12008, 11008, 3010, '2024-09-01', NULL,          2000.00, 122),
(12009, 11009, 3011, '2024-10-15', NULL,          1800.00, 182);
SET IDENTITY_INSERT Contratos_DetalleContrato OFF;
GO
 
-- Nota: id_detalle_contrato ref 12000..12009, id_operador_cliente ref 9000..9009
SET IDENTITY_INSERT Contratos_AsignacionOperadorCliente ON;
INSERT INTO Contratos_AsignacionOperadorCliente (id_asig_op_cliente, id_detalle_contrato, id_operador_cliente, fecha_inicio, fecha_fin, observaciones) VALUES
(13000, 12000, 9000, '2024-01-10', '2024-03-08', 'Asignacion completa contrato edificio.'),
(13001, 12001, 9001, '2024-02-01', NULL,          'Operador activo en ruta CA-9.'),
(13002, 12002, 9002, '2024-03-15', '2024-06-10', 'Finalizo con cierre del contrato residencial.'),
(13003, 12003, 9003, '2024-04-01', NULL,          'Asignado en centro comercial norte.'),
(13004, 12004, 9004, '2024-05-10', '2024-08-05', 'Trabajo finalizado exitosamente.'),
(13005, 12005, 9005, '2024-06-01', NULL,          'Operador activo en proyecto hospital.'),
(13006, 12006, 9006, '2024-07-05', NULL,          'Cancelacion anticipada proyecto hidroelectrico.'),
(13007, 12007, 9007, '2024-08-10', NULL,          'Operador activo en puente CA-14.'),
(13008, 12008, 9008, '2024-09-01', NULL,          'Asignado complejo deportivo.'),
(13009, 12009, 9009, '2024-10-15', NULL,          'Asignacion vigente parque industrial.');
SET IDENTITY_INSERT Contratos_AsignacionOperadorCliente OFF;
GO
 
-- Nota: id_cliente ref 7000..7009, id_municipio ref 200..223
SET IDENTITY_INSERT Contratos_ProyectoCliente ON;
INSERT INTO Contratos_ProyectoCliente (id_proyecto, id_cliente, nombre_proyecto, id_municipio, fecha_inicio, fecha_fin_estimada, descripcion, estado_proyecto) VALUES
(14000, 7000, 'Edificio Corporativo Zona 10',   200, '2024-01-10', '2024-06-10', 'Construccion de edificio de 8 niveles zona corporativa.', 'Completado'),
(14001, 7001, 'Ampliacion Carretera CA-9',      205, '2024-02-01', '2024-08-01', 'Mejora y ampliacion de infraestructura vial nacional.',   'Activo'),
(14002, 7002, 'Urbanizacion Residencial Mixco', 201, '2024-03-15', '2024-09-15', 'Desarrollo de viviendas de interes social.',              'Suspendido'),
(14003, 7003, 'Centro Comercial del Norte',     202, '2024-04-01', '2024-10-01', 'Construccion de plaza comercial con 80 locales.',         'Activo'),
(14004, 7004, 'Planta de Produccion Palin',     218, '2024-05-10', '2024-11-10', 'Instalacion industrial para produccion agricola.',        'Completado'),
(14005, 7005, 'Remodelacion Hospital Regional', 200, '2024-06-01', '2024-12-01', 'Modernizacion de instalaciones medicas de urgencias.',    'Activo'),
(14006, 7006, 'Proyecto Hidroelectrico Xela',   208, '2024-07-05', '2025-01-05', 'Generacion de energia limpia capacidad 25MW.',            'Suspendido'),
(14007, 7007, 'Puente Vehicular Ruta CA-14',    211, '2024-08-10', '2025-02-10', 'Construccion de puente de 120m sobre Rio Dulce.',         'Activo'),
(14008, 7008, 'Complejo Deportivo Municipal',   208, '2024-09-01', '2025-03-01', 'Instalaciones deportivas con cancha y piscina olimpica.', 'Activo'),
(14009, 7009, 'Parque Industrial Norte GT',     200, '2024-10-15', '2025-04-15', 'Zona industrial con 30 naves de 500m2 cada una.',         'Activo');
SET IDENTITY_INSERT Contratos_ProyectoCliente OFF;
GO
 
SET IDENTITY_INSERT Contratos_ContratoProyecto ON;
INSERT INTO Contratos_ContratoProyecto (id_cont_proy, id_contrato, id_proyecto, observaciones) VALUES
(15000, 11000, 14000, 'Contrato vinculado a proyecto principal de construccion.'),
(15001, 11001, 14001, 'Maquinaria asignada a obra vial ampliacion CA-9.'),
(15002, 11002, 14002, 'Apoyo en movimiento de tierras residencial Mixco.'),
(15003, 11003, 14003, 'Proyecto comercial en ejecucion zona norte.'),
(15004, 11004, 14004, 'Contrato finalizado exitosamente dentro del plazo.'),
(15005, 11005, 14005, 'Servicio activo en hospital modernizacion.'),
(15006, 11006, 14006, 'Contrato cancelado por suspension de proyecto hidroelectrico.'),
(15007, 11007, 14007, 'Construccion de infraestructura vial puente CA-14.'),
(15008, 11008, 14008, 'Proyecto deportivo en desarrollo municipal.'),
(15009, 11009, 14009, 'Contrato vigente con prorroga aprobada para parque industrial.');
SET IDENTITY_INSERT Contratos_ContratoProyecto OFF;
GO
 
SET IDENTITY_INSERT Contratos_Factura ON;
INSERT INTO Contratos_Factura (id_factura, id_contrato, numero_factura, fecha_emision, monto_subtotal, monto_impuesto, estado_pago, fecha_vencimiento) VALUES
(16000, 11000, 'FAC-2024-001', '2024-01-15', 24000.00, 2880.00, 'Pagada',    '2024-02-15'),
(16001, 11000, 'FAC-2024-002', '2024-02-15', 24000.00, 2880.00, 'Pagada',    '2024-03-15'),
(16002, 11001, 'FAC-2024-003', '2024-02-15', 22000.00, 2640.00, 'Pagada',    '2024-03-15'),
(16003, 11001, 'FAC-2024-004', '2024-03-15', 22000.00, 2640.00, 'Pagada',    '2024-04-15'),
(16004, 11002, 'FAC-2024-005', '2024-03-20', 22500.00, 2700.00, 'Pagada',    '2024-04-20'),
(16005, 11003, 'FAC-2024-006', '2024-04-10', 32500.00, 3900.00, 'Pendiente', '2024-05-10'),
(16006, 11004, 'FAC-2024-007', '2024-05-15', 19000.00, 2280.00, 'Pagada',    '2024-06-15'),
(16007, 11005, 'FAC-2024-008', '2024-06-10', 26000.00, 3120.00, 'Pendiente', '2024-07-10'),
(16008, 11007, 'FAC-2024-009', '2024-08-15', 60000.00, 7200.00, 'Pendiente', '2024-09-15'),
(16009, 11009, 'FAC-2024-010', '2024-10-20', 72500.00, 8700.00, 'Pendiente', '2024-11-20');
SET IDENTITY_INSERT Contratos_Factura OFF;
GO
 
-- Nota: id_factura ref 16000..16009, id_empleado_registra ref 5011 (Auxiliar Contable)
SET IDENTITY_INSERT Contratos_Pago ON;
INSERT INTO Contratos_Pago (id_pago, id_factura, fecha_pago, monto_pagado, metodo_pago, referencia_bancaria, id_empleado_registra) VALUES
(17000, 16000, '2024-02-14', 26880.00, 'Transferencia', 'REF-BAC-001-2024', 5011),
(17001, 16001, '2024-03-14', 26880.00, 'Transferencia', 'REF-BAC-002-2024', 5011),
(17002, 16002, '2024-03-14', 24640.00, 'Cheque',        'CHQ-001-2024',     5011),
(17003, 16003, '2024-04-14', 24640.00, 'Transferencia', 'REF-BAC-003-2024', 5011),
(17004, 16004, '2024-04-19', 25200.00, 'Deposito',      'DEP-001-2024',     5011),
(17005, 16006, '2024-06-14', 21280.00, 'Transferencia', 'REF-BAC-004-2024', 5011);
SET IDENTITY_INSERT Contratos_Pago OFF;
GO
 
-- ============================================================================================================================
-- MÓDULO 8 — OPERACIONES: RUTAS Y TRASLADOS
-- ============================================================================================================================

CREATE TABLE Operaciones_VehiculoTransporte (
    id_vehiculo             INT             NOT NULL IDENTITY(1,1),
    placa                   VARCHAR(20)     NOT NULL,
    tipo_vehiculo           VARCHAR(50)     NOT NULL,
    id_marca                INT             NOT NULL,
    capacidad_toneladas     DECIMAL(8,2)    NOT NULL,
    anio                    INT             NOT NULL,
    estado_vehiculo         VARCHAR(20)     NOT NULL DEFAULT 'Operativo',
    numero_poliza_seguro    VARCHAR(60)     NOT NULL,
    vencimiento_poliza      DATE            NOT NULL,
    CONSTRAINT PK_VehiculoTransporte    PRIMARY KEY (id_vehiculo),
    CONSTRAINT UQ_Vehiculo_placa        UNIQUE (placa),
    CONSTRAINT FK_Vehiculo_Marca        FOREIGN KEY (id_marca) REFERENCES Catalogo_Marca(id_marca),
    CONSTRAINT CK_Vehiculo_estado       CHECK (estado_vehiculo IN ('Operativo','Mantenimiento','Baja')),
    CONSTRAINT CK_Vehiculo_capacidad    CHECK (capacidad_toneladas > 0)
);
GO

CREATE TABLE Operaciones_Ruta (
    id_ruta                 INT             NOT NULL IDENTITY(1,1),
    nombre_ruta             VARCHAR(120)    NOT NULL,
    id_municipio_origen     INT             NOT NULL,
    id_municipio_destino    INT             NOT NULL,
    distancia_km            DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    es_internacional        CHAR(2)         NOT NULL DEFAULT 'NO',    -- reemplaza BIT
    nivel_riesgo            VARCHAR(20)     NOT NULL DEFAULT 'Medio',
    observaciones           VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones',
    CONSTRAINT PK_Ruta              PRIMARY KEY (id_ruta),
    CONSTRAINT FK_Ruta_Origen       FOREIGN KEY (id_municipio_origen)  REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT FK_Ruta_Destino      FOREIGN KEY (id_municipio_destino) REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Ruta_riesgo       CHECK (nivel_riesgo IN ('Bajo','Medio','Alto')),
    CONSTRAINT CK_Ruta_municipios   CHECK (id_municipio_origen <> id_municipio_destino),
    CONSTRAINT CK_Ruta_internac     CHECK (es_internacional IN ('SI','NO'))
);
GO

CREATE TABLE Operaciones_TrasladoMaquinaria (
    id_traslado             INT             NOT NULL IDENTITY(1,1),
    id_maquinaria           INT             NOT NULL,
    id_ruta                 INT             NOT NULL,
    id_vehiculo_transporte  INT             NOT NULL,
    id_conductor            INT             NOT NULL,
    id_contrato             INT             NOT NULL,
    fecha_salida            DATETIME        NOT NULL,
    fecha_llegada_estimada  DATETIME        NOT NULL,
    fecha_llegada_real      DATETIME            NULL,
    estado_traslado         VARCHAR(20)     NOT NULL DEFAULT 'Programado',
    costo_traslado          DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    observaciones           VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones',
    CONSTRAINT PK_TrasladoMaquinaria        PRIMARY KEY (id_traslado),
    CONSTRAINT FK_Traslado_Maquinaria       FOREIGN KEY (id_maquinaria)        REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Traslado_Ruta             FOREIGN KEY (id_ruta)              REFERENCES Operaciones_Ruta(id_ruta),
    CONSTRAINT FK_Traslado_Vehiculo         FOREIGN KEY (id_vehiculo_transporte) REFERENCES Operaciones_VehiculoTransporte(id_vehiculo),
    CONSTRAINT FK_Traslado_Conductor        FOREIGN KEY (id_conductor)         REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_Traslado_Contrato         FOREIGN KEY (id_contrato)          REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT CK_Traslado_estado           CHECK (estado_traslado IN ('Programado','En_Transito','Completado','Cancelado')),
    CONSTRAINT CK_Traslado_fechas           CHECK (fecha_llegada_estimada > fecha_salida)
);
GO

-- Nota: id_marca ref 510..514 (Mack=510, Kenworth=511, Freightliner=512, Mercedes=513, Scania=514)
SET IDENTITY_INSERT Operaciones_VehiculoTransporte ON;
INSERT INTO Operaciones_VehiculoTransporte (id_vehiculo, placa, tipo_vehiculo, id_marca, capacidad_toneladas, anio, estado_vehiculo, numero_poliza_seguro, vencimiento_poliza) VALUES
(18000, 'VT-001-GTQ', 'Plataforma Baja',       510, 40.00, 2020, 'Operativo',     'POL-SEG-001-2024', '2025-06-30'),
(18001, 'VT-002-GTQ', 'Plataforma Baja',       510, 40.00, 2019, 'Operativo',     'POL-SEG-002-2024', '2025-06-30'),
(18002, 'VT-003-GTQ', 'Camion Grua',           511, 25.00, 2021, 'Operativo',     'POL-SEG-003-2024', '2025-07-31'),
(18003, 'VT-004-GTQ', 'Camion de Carga',       512, 20.00, 2020, 'Operativo',     'POL-SEG-004-2024', '2025-08-31'),
(18004, 'VT-005-GTQ', 'Plataforma Extensible', 513, 60.00, 2022, 'Operativo',     'POL-SEG-005-2024', '2025-09-30'),
(18005, 'VT-006-GTQ', 'Camion Grua',           514, 30.00, 2018, 'Mantenimiento', 'POL-SEG-006-2024', '2025-05-31'),
(18006, 'VT-007-GTQ', 'Plataforma Baja',       510, 40.00, 2023, 'Operativo',     'POL-SEG-007-2024', '2025-10-31'),
(18007, 'VT-008-GTQ', 'Camion de Carga',       511, 15.00, 2021, 'Operativo',     'POL-SEG-008-2024', '2025-11-30'),
(18008, 'VT-009-GTQ', 'Semirremolque',         512, 28.00, 2020, 'Operativo',     'POL-SEG-009-2024', '2025-12-31'),
(18009, 'VT-010-GTQ', 'Plataforma Baja',       513, 55.00, 2022, 'Operativo',     'POL-SEG-010-2024', '2026-01-31');
SET IDENTITY_INSERT Operaciones_VehiculoTransporte OFF;
GO
 
-- Nota: id_municipio_origen y _destino ref 200..223
SET IDENTITY_INSERT Operaciones_Ruta ON;
INSERT INTO Operaciones_Ruta (id_ruta, nombre_ruta, id_municipio_origen, id_municipio_destino, distancia_km, es_internacional, nivel_riesgo, observaciones) VALUES
(19000, 'Ruta Guatemala - Escuintla',    200, 205,  90.00, 'NO', 'Bajo',  'Autopista de 4 carriles, ruta comercial principal.'),
(19001, 'Ruta Guatemala - Xela',         200, 208, 205.00, 'NO', 'Medio', 'Ruta serpentina con curvas pronunciadas.'),
(19002, 'Ruta Guatemala - Coban',        200, 213, 218.00, 'NO', 'Alto',  'Carretera estrecha con neblina frecuente.'),
(19003, 'Ruta Guatemala - Pto Barrios',  200, 211, 295.00, 'NO', 'Medio', 'Ruta Atlantic con paso por varios municipios.'),
(19004, 'Ruta Escuintla - Pto San Jose', 205, 207,  45.00, 'NO', 'Bajo',  'Acceso a puerto maritimo del Pacifico.'),
(19005, 'Ruta Xela - San Marcos',        208, 214,  37.00, 'NO', 'Medio', 'Ruta montanosa con pendientes elevadas.'),
(19006, 'Ruta Guatemala - Antigua',      200, 209,  45.00, 'NO', 'Bajo',  'Ruta turistica bien mantenida.'),
(19007, 'Ruta Guatemala - Mixco',        200, 201,  12.00, 'NO', 'Bajo',  'Ruta urbana con trafico intenso.'),
(19008, 'Ruta Coban - Peten',         213, 222,  22.00, 'NO', 'Medio', 'Carretera secundaria en buenas condiciones.'),
(19009, 'Ruta Guatemala - Comapa', 200, 215, 380.00, 'NO', 'Alto',  'Carretera secundaria en buenas condiciones.');
SET IDENTITY_INSERT Operaciones_Ruta OFF;
GO
 
-- Nota: id_maquinaria ref 3000..3019, id_ruta ref 19000..19009,
--       id_vehiculo_transporte ref 18000..18009, id_conductor ref 5000..5019,
--       id_contrato ref 11000..11009
SELECT * FROM Operaciones_TrasladoMaquinaria
SET IDENTITY_INSERT Operaciones_TrasladoMaquinaria ON;

INSERT INTO Operaciones_TrasladoMaquinaria 
(id_traslado, id_maquinaria, id_ruta, id_vehiculo_transporte, id_conductor, id_contrato, fecha_salida, fecha_llegada_estimada, fecha_llegada_real, estado_traslado, costo_traslado, observaciones) 
VALUES
(20000, 3000, 19000, 18000, 5007, 11000, '20240109 08:00:00', '20240109 12:00:00', '20240109 12:00:00', 'Completado', 3500.00, 'Traslado sin incidentes.'),
(20001, 3004, 19001, 18004, 5015, 11001, '20240131 09:00:00', '20240201 10:00:00', '20240201 10:00:00', 'Completado', 8000.00, 'Leve retraso por inspeccion de caminos.'),
(20002, 3006, 19007, 18001, 5016, 11002, '20240314 07:30:00', '20240314 11:00:00', '20240314 11:00:00', 'Completado', 800.00, 'Traslado urbano exitoso.'),
(20003, 3009, 19006, 18002, 5007, 11003, '20240331 06:00:00', '20240331 09:30:00', '20240331 09:30:00', 'Completado', 1200.00, 'Traslado rapido a Antigua.'),
(20004, 3002, 19000, 18003, 5015, 11004, '20240509 08:15:00', '20240509 13:00:00', '20240509 13:00:00', 'Completado', 3200.00, 'Traslado hacia Palin exitoso.'),
(20005, 3014, 19007, 18000, 5016, 11005, '20240531 07:45:00', '20240531 10:30:00', '20240531 10:30:00', 'Completado', 900.00, 'Mini excavadora entregada en hospital.'),
(20006, 3005, 19002, 18004, 5007, 11006, '20240704 09:00:00', '20240704 11:00:00', NULL, 'Cancelado', 0.00, 'Traslado cancelado por suspension de contrato.'),
(20007, 3018, 19003, 18008, 5015, 11007, '20240809 05:30:00', '20240809 18:00:00', '20240809 18:00:00', 'Completado', 9500.00, 'Traslado largo con carga sobredimensionada.'),
(20008, 3010, 19000, 18006, 5016, 11008, '20240831 08:00:00', '20240831 14:00:00', '20240831 14:00:00', 'Completado', 4200.00, 'Camion volquete para complejo deportivo.'),
(20009, 3011, 19003, 18009, 5007, 11009, '20241014 06:00:00', '20241014 20:00:00', NULL, 'En_Transito', 11000.00, 'En ruta hacia Puerto Barrios zona industrial.');

SET IDENTITY_INSERT Operaciones_TrasladoMaquinaria OFF;
GO

-- ============================================================================================================================
-- MÓDULO 9 — ADUANAS Y CONTROL FRONTERIZO
-- ============================================================================================================================

CREATE TABLE Aduanas_Aduana (
    id_aduana           INT             NOT NULL IDENTITY(1,1),
    nombre_aduana       VARCHAR(100)    NOT NULL,
    id_municipio        INT             NOT NULL,
    id_pais             INT             NOT NULL,
    tipo_aduana         VARCHAR(40)     NOT NULL,
    horario_operacion   VARCHAR(60)     NOT NULL,
    activa              CHAR(2)         NOT NULL DEFAULT 'SI',   -- reemplaza BIT
    CONSTRAINT PK_Aduana                PRIMARY KEY (id_aduana),
    CONSTRAINT FK_Aduana_Municipio      FOREIGN KEY (id_municipio) REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT FK_Aduana_Pais           FOREIGN KEY (id_pais)      REFERENCES Geografia_Pais(id_pais),
    CONSTRAINT CK_Aduana_tipo           CHECK (tipo_aduana IN ('Terrestre','Maritima','Aerea')),
    CONSTRAINT CK_Aduana_activa         CHECK (activa IN ('SI','NO'))
);
GO

CREATE TABLE Aduanas_CruceFronterizo (
    id_cruce                INT             NOT NULL IDENTITY(1,1),
    id_traslado             INT             NOT NULL,
    id_aduana_salida        INT             NOT NULL,
    id_aduana_entrada       INT             NOT NULL,
    fecha_hora_salida       DATETIME        NOT NULL,
    fecha_hora_entrada      DATETIME            NULL,
    numero_declaracion      VARCHAR(60)     NOT NULL,
    estado_cruce            VARCHAR(20)     NOT NULL DEFAULT 'Pendiente',
    tiempo_retraso_horas    DECIMAL(6,2)    NOT NULL DEFAULT 0,
    motivo_retraso          VARCHAR(500)    NOT NULL DEFAULT 'Sin retraso',
    CONSTRAINT PK_CruceFronterizo       PRIMARY KEY (id_cruce),
    CONSTRAINT FK_Cruce_Traslado        FOREIGN KEY (id_traslado)      REFERENCES Operaciones_TrasladoMaquinaria(id_traslado),
    CONSTRAINT FK_Cruce_AduanaSalida    FOREIGN KEY (id_aduana_salida) REFERENCES Aduanas_Aduana(id_aduana),
    CONSTRAINT FK_Cruce_AduanaEntrada   FOREIGN KEY (id_aduana_entrada)REFERENCES Aduanas_Aduana(id_aduana),
    CONSTRAINT CK_Cruce_estado          CHECK (estado_cruce IN ('Pendiente','Aprobado','Retenido','Rechazado')),
    CONSTRAINT CK_Cruce_aduanas         CHECK (id_aduana_salida <> id_aduana_entrada),
    CONSTRAINT CK_Cruce_retraso         CHECK (tiempo_retraso_horas >= 0)
);
GO

CREATE TABLE Aduanas_DocumentoAduanero (
    id_doc_aduanero     INT             NOT NULL IDENTITY(1,1),
    id_cruce            INT             NOT NULL,
    tipo_documento      VARCHAR(60)     NOT NULL,
    numero_documento    VARCHAR(80)     NOT NULL,
    fecha_emision       DATE            NOT NULL,
    fecha_vencimiento   DATE            NOT NULL,
    entidad_emisora     VARCHAR(100)    NOT NULL,
    estado_documento    VARCHAR(20)     NOT NULL DEFAULT 'Vigente',
    archivo_digital     VARCHAR(255)    NOT NULL DEFAULT 'pendiente_digitalizacion',
    CONSTRAINT PK_DocumentoAduanero     PRIMARY KEY (id_doc_aduanero),
    CONSTRAINT UQ_DocAduanero_numero    UNIQUE (numero_documento),
    CONSTRAINT FK_DocAduanero_Cruce     FOREIGN KEY (id_cruce) REFERENCES Aduanas_CruceFronterizo(id_cruce),
    CONSTRAINT CK_DocAduanero_estado    CHECK (estado_documento IN ('Vigente','Vencido','Rechazado','Anulado')),
    CONSTRAINT CK_DocAduanero_tipo      CHECK (tipo_documento IN ('Manifiesto','Permiso','Declaracion','Carta_Porte','Certificado'))
);
GO

-- Nota: id_municipio ref 200..223, id_pais ref 300..309
SET IDENTITY_INSERT Aduanas_Aduana ON;
INSERT INTO Aduanas_Aduana (id_aduana, nombre_aduana, id_municipio, id_pais, tipo_aduana, horario_operacion, activa) VALUES
(21000, 'Aduana Central Guatemala',    200, 300, 'Terrestre', '24/7',           'SI'),
(21001, 'Aduana Puerto San Jose',      207, 300, 'Maritima',  '06:00 - 22:00', 'SI'),
(21002, 'Aduana Aeropuerto La Aurora', 200, 300, 'Aerea',     '24/7',           'SI'),
(21003, 'Aduana Tecun Uman',           214, 300, 'Terrestre', '08:00 - 18:00', 'SI'),
(21004, 'Aduana Valle Nuevo',          210, 300, 'Terrestre', '08:00 - 20:00', 'SI'),
(21005, 'Aduana Puerto Barrios',       211, 300, 'Maritima',  '06:00 - 22:00', 'SI'),
(21006, 'Aduana Ciudad Hidalgo MX',    215, 301, 'Terrestre', '07:00 - 19:00', 'SI'),  -- Mexico=301
(21007, 'Aduana El Florido HN',        216, 302, 'Terrestre', '08:00 - 18:00', 'SI'),  -- Honduras=302
(21008, 'Aduana Corinto HN',           216, 302, 'Terrestre', '08:00 - 18:00', 'NO'),
(21009, 'Aduana La Hachadura SV',      214, 303, 'Terrestre', '08:00 - 20:00', 'SI');  -- El Salvador=303
SET IDENTITY_INSERT Aduanas_Aduana OFF;
GO
 
-- Nota: id_traslado ref 20000..20009, id_aduana_salida/_entrada ref 21000..21009
SET IDENTITY_INSERT Aduanas_CruceFronterizo ON;

INSERT INTO Aduanas_CruceFronterizo 
(id_cruce, id_traslado, id_aduana_salida, id_aduana_entrada, fecha_hora_salida, fecha_hora_entrada, numero_declaracion, estado_cruce, tiempo_retraso_horas, motivo_retraso) 
VALUES
(22000, 20001, 21000, 21006, '20240131 05:30:00', '20240131 07:00:00', 'DEC-GT-001-2024', 'Aprobado',  0.00, 'Sin retraso'),
(22001, 20007, 21000, 21007, '20240809 05:00:00', '20240809 07:30:00', 'DEC-GT-002-2024', 'Aprobado',  0.00, 'Sin retraso'),
(22002, 20004, 21000, 21003, '20240509 06:30:00', NULL,                  'DEC-GT-003-2024', 'Pendiente', 0.00, 'Documentacion en revision'),
(22003, 20008, 21000, 21005, '20240831 06:30:00', '20240831 09:00:00', 'DEC-GT-004-2024', 'Aprobado',  0.50, 'Revision de peso vehiculo');

SET IDENTITY_INSERT Aduanas_CruceFronterizo OFF;
GO
 
-- Nota: id_cruce ref 22000..22003
SET IDENTITY_INSERT Aduanas_DocumentoAduanero ON;
INSERT INTO Aduanas_DocumentoAduanero (id_doc_aduanero, id_cruce, tipo_documento, numero_documento, fecha_emision, fecha_vencimiento, entidad_emisora, estado_documento, archivo_digital) VALUES
(23000, 22000, 'Manifiesto',  'MAN-GT-001-2024', '2024-01-31', '2024-04-30', 'SAT Guatemala',           'Vigente', 'docs/manifiesto_001_2024.pdf'),
(23001, 22000, 'Carta_Porte', 'CTP-GT-001-2024', '2024-01-31', '2024-04-30', 'Transportes Unidos S.A.', 'Vigente', 'docs/cartaporte_001_2024.pdf'),
(23002, 22001, 'Manifiesto',  'MAN-GT-002-2024', '2024-08-09', '2024-11-09', 'SAT Guatemala',           'Vigente', 'docs/manifiesto_002_2024.pdf'),
(23003, 22001, 'Declaracion', 'DEC-GT-002-2024', '2024-08-09', '2024-11-09', 'SAT Guatemala',           'Vigente', 'docs/declaracion_002_2024.pdf'),
(23004, 22002, 'Permiso',     'PER-GT-003-2024', '2024-05-09', '2024-08-09', 'SEGEPLAN Guatemala',      'Vigente', 'docs/permiso_003_2024.pdf'),
(23005, 22003, 'Certificado', 'CER-GT-004-2024', '2024-08-31', '2024-11-30', 'SAT Guatemala',           'Vigente', 'docs/certificado_004_2024.pdf');
SET IDENTITY_INSERT Aduanas_DocumentoAduanero OFF;
GO
 

-- ============================================================================================================================
-- MÓDULO 10 — VERIFICACIÓN DE CARGA Y MERCADERÍA
-- ============================================================================================================================

CREATE TABLE Carga_RegistroCarga (
    id_carga                INT             NOT NULL IDENTITY(1,1),
    id_traslado             INT             NOT NULL,
    id_tipo_carga           INT             NOT NULL,
    descripcion_carga       VARCHAR(500)    NOT NULL,
    peso_declarado_kg       DECIMAL(10,2)   NOT NULL,
    volumen_declarado_m3    DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    valor_declarado         DECIMAL(14,2)   NOT NULL DEFAULT 0.00,
    CONSTRAINT PK_RegistroCarga     PRIMARY KEY (id_carga),
    CONSTRAINT FK_Carga_Traslado    FOREIGN KEY (id_traslado)   REFERENCES Operaciones_TrasladoMaquinaria(id_traslado),
    CONSTRAINT FK_Carga_TipoCarga   FOREIGN KEY (id_tipo_carga) REFERENCES Catalogo_TipoCarga(id_tipo_carga),
    CONSTRAINT CK_Carga_peso        CHECK (peso_declarado_kg > 0)
);
GO

CREATE TABLE Carga_InspeccionCarga (
    id_inspeccion           INT             NOT NULL IDENTITY(1,1),
    id_carga                INT             NOT NULL,
    id_inspector            INT             NOT NULL,
    fecha_inspeccion        DATETIME        NOT NULL,
    momento_inspeccion      VARCHAR(20)     NOT NULL,
    peso_verificado_kg      DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    volumen_verificado_m3   DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    resultado               VARCHAR(20)     NOT NULL,
    observaciones           VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones',
    CONSTRAINT PK_InspeccionCarga       PRIMARY KEY (id_inspeccion),
    CONSTRAINT FK_Inspeccion_Carga      FOREIGN KEY (id_carga)     REFERENCES Carga_RegistroCarga(id_carga),
    CONSTRAINT FK_Inspeccion_Inspector  FOREIGN KEY (id_inspector) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Inspeccion_momento    CHECK (momento_inspeccion IN ('Pre_Traslado','Durante','Post_Traslado')),
    CONSTRAINT CK_Inspeccion_resultado  CHECK (resultado IN ('Conforme','No_Conforme','Alerta'))
);
GO

CREATE TABLE Carga_AlertaCarga (
    id_alerta               INT             NOT NULL IDENTITY(1,1),
    id_inspeccion           INT             NOT NULL,
    tipo_alerta             VARCHAR(60)     NOT NULL,
    descripcion_alerta      VARCHAR(500)    NOT NULL,
    fecha_alerta            DATETIME        NOT NULL DEFAULT GETDATE(),
    estado_alerta           VARCHAR(20)     NOT NULL DEFAULT 'Abierta',
    id_empleado_atiende     INT             NOT NULL,
    resolucion              VARCHAR(500)    NOT NULL DEFAULT 'Pendiente resolucion',
    fecha_resolucion        DATE                NULL,
    CONSTRAINT PK_AlertaCarga           PRIMARY KEY (id_alerta),
    CONSTRAINT FK_Alerta_Inspeccion     FOREIGN KEY (id_inspeccion)       REFERENCES Carga_InspeccionCarga(id_inspeccion),
    CONSTRAINT FK_Alerta_Empleado       FOREIGN KEY (id_empleado_atiende) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Alerta_tipo           CHECK (tipo_alerta IN ('Peso','Volumen','Tipo_Carga','Documental','Inconsistencia')),
    CONSTRAINT CK_Alerta_estado         CHECK (estado_alerta IN ('Abierta','En_Revision','Cerrada'))
);
GO

-- Nota: id_traslado ref 20000..20009, id_tipo_carga ref 900..909
SET IDENTITY_INSERT Carga_RegistroCarga ON;
INSERT INTO Carga_RegistroCarga (id_carga, id_traslado, id_tipo_carga, descripcion_carga, peso_declarado_kg, volumen_declarado_m3, valor_declarado) VALUES
(24000, 20000, 900, 'Herramientas y materiales de construccion general.',      2500.00,  4.50,   85000.00),
(24001, 20001, 906, 'Excavadora Volvo sobredimensionada para obra vial.',     38000.00, 45.00, 1800000.00),
(24002, 20002, 900, 'Retroexcavadora y accesorios de operacion.',             8600.00,  12.00,  320000.00),
(24003, 20003, 903, 'Mini excavadora con embalaje protector.',                5800.00,   8.00,  210000.00),
(24004, 20004, 900, 'Cargador frontal y herramientas de campo.',             18700.00,  22.00,  780000.00),
(24005, 20005, 903, 'Mini excavadora con componentes fragiles.',              5800.00,   8.00,  210000.00),
(24006, 20007, 906, 'Pavimentadora sobredimensionada para carretera.',       18000.00,  25.00, 1200000.00),
(24007, 20008, 900, 'Camion volquete para proyecto deportivo.',              42800.00,  50.00, 1650000.00),
(24008, 20009, 906, 'Cisterna de gran capacidad sobredimensionada.',         16000.00,  30.00,  680000.00),
(24009, 20001, 902, 'Combustible diesel de reserva para equipo en obra.',      800.00,   1.00,    6400.00);
SET IDENTITY_INSERT Carga_RegistroCarga OFF;
GO
 
-- Nota: id_carga ref 24000..24009, id_inspector ref 5009 y 5017 (Inspectores de Carga)
select * from Carga_InspeccionCarga
SET IDENTITY_INSERT Carga_InspeccionCarga ON;

INSERT INTO Carga_InspeccionCarga 
(id_inspeccion, id_carga, id_inspector, fecha_inspeccion, momento_inspeccion, peso_verificado_kg, volumen_verificado_m3, resultado, observaciones) 
VALUES
(25000, 24000, 5009, '20240109 05:30:00', 'Pre_Traslado',  2510.00,  4.50, 'Conforme',    'Peso coincide con declaracion.'),
(25001, 24001, 5009, '20240131 04:30:00', 'Pre_Traslado', 38050.00, 45.00, 'Conforme',    'Maquinaria correctamente asegurada.'),
(25002, 24002, 5017, '20240314 06:30:00', 'Pre_Traslado',  8620.00, 12.00, 'Conforme',    'Inspeccion rutinaria aprobada.'),
(25003, 24003, 5009, '20240331 05:30:00', 'Pre_Traslado',  5850.00,  8.10, 'Alerta',      'Volumen ligeramente superior al declarado.'),
(25004, 24004, 5017, '20240509 05:30:00', 'Pre_Traslado', 18750.00, 22.00, 'Conforme',    'Sin observaciones.'),
(25005, 24005, 5009, '20240531 06:30:00', 'Pre_Traslado',  5800.00,  8.00, 'Conforme',    'Embalaje protector verificado.'),
(25006, 24006, 5017, '20240809 04:00:00', 'Pre_Traslado', 18050.00, 25.00, 'Conforme',    'Permiso sobredimension validado.'),
(25007, 24007, 5009, '20240831 05:30:00', 'Pre_Traslado', 42850.00, 50.00, 'Conforme',    'Camion volquete asegurado correctamente.'),
(25008, 24008, 5017, '20241014 03:30:00', 'Pre_Traslado', 16100.00, 30.00, 'Alerta',      'Peso 100kg mayor al declarado en manifiesto.'),
(25009, 24003, 5009, '20240331 09:00:00', 'Post_Traslado', 5850.00,  8.10, 'No_Conforme', 'Discrepancia de volumen confirmada post entrega.');

SET IDENTITY_INSERT Carga_InspeccionCarga OFF;
GO
-- Nota: id_inspeccion ref 25000..25009, id_empleado_atiende ref 5000..5019
SET IDENTITY_INSERT Carga_AlertaCarga ON;
INSERT INTO Carga_AlertaCarga (id_alerta, id_inspeccion, tipo_alerta, descripcion_alerta, fecha_alerta, estado_alerta, id_empleado_atiende, resolucion, fecha_resolucion) VALUES
(26000, 25003, 'Volumen',        'Volumen verificado es 0.10m3 mayor al declarado en contrato.',    '20240331 09:30:00', 'Cerrada',     5004, 'Se actualizo manifiesto de carga y se notifico al cliente.', '2024-04-01'),
(26001, 25008, 'Peso',           'Peso verificado supera en 100kg el peso declarado en manifiesto.','20241014 04:00:00', 'En_Revision', 5004, 'En proceso de verificacion con el transportista.',          NULL),
(26002, 25009, 'Inconsistencia', 'Volumen no coincide entre inspeccion pre y post traslado.',       '20240331 10:00:00', 'Cerrada',     5001, 'Se determino diferencia por reacomodo de carga en ruta.',   '2024-04-02');
SET IDENTITY_INSERT Carga_AlertaCarga OFF;
GO
 
-- ============================================================================================================================
-- MÓDULO 11 — MANTENIMIENTO Y COMBUSTIBLE
-- ============================================================================================================================

CREATE TABLE Mantenimiento_Repuesto (
    id_repuesto         INT             NOT NULL IDENTITY(1,1),
    codigo_repuesto     VARCHAR(40)     NOT NULL,
    nombre_repuesto     VARCHAR(100)    NOT NULL,
    id_marca            INT             NOT NULL,
    unidad_medida       VARCHAR(20)     NOT NULL,
    precio_unitario     DECIMAL(10,2)   NOT NULL,
    stock_actual        INT             NOT NULL DEFAULT 0,
    stock_minimo        INT             NOT NULL DEFAULT 1,
    id_proveedor        INT             NOT NULL,
    CONSTRAINT PK_Repuesto              PRIMARY KEY (id_repuesto),
    CONSTRAINT UQ_Repuesto_codigo       UNIQUE (codigo_repuesto),
    CONSTRAINT FK_Repuesto_Marca        FOREIGN KEY (id_marca)      REFERENCES Catalogo_Marca(id_marca),
    CONSTRAINT FK_Repuesto_Proveedor    FOREIGN KEY (id_proveedor)  REFERENCES Proveedor_Proveedor(id_proveedor),
    CONSTRAINT CK_Repuesto_precio       CHECK (precio_unitario > 0),
    CONSTRAINT CK_Repuesto_stock        CHECK (stock_actual >= 0)
);
GO

CREATE TABLE Mantenimiento_OrdenMantenimiento (
    id_orden_mant           INT             NOT NULL IDENTITY(1,1),
    id_maquinaria           INT             NOT NULL,
    id_tipo_mant            INT             NOT NULL,
    id_tecnico              INT             NOT NULL,
    id_proveedor_externo    INT                 NULL,
    fecha_programada        DATE            NOT NULL,
    fecha_realizada         DATE                NULL,
    horas_maquina_al_mant   DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    costo_total             DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    estado                  VARCHAR(20)     NOT NULL DEFAULT 'Programado',
    descripcion_trabajo     VARCHAR(500)    NOT NULL,
    CONSTRAINT PK_OrdenMantenimiento    PRIMARY KEY (id_orden_mant),
    CONSTRAINT FK_OrdenMant_Maquinaria  FOREIGN KEY (id_maquinaria)       REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_OrdenMant_Tipo        FOREIGN KEY (id_tipo_mant)        REFERENCES Catalogo_TipoMantenimiento(id_tipo_mant),
    CONSTRAINT FK_OrdenMant_Tecnico     FOREIGN KEY (id_tecnico)          REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_OrdenMant_Proveedor   FOREIGN KEY (id_proveedor_externo)REFERENCES Proveedor_Proveedor(id_proveedor),
    CONSTRAINT CK_OrdenMant_estado      CHECK (estado IN ('Programado','En_Proceso','Completado','Cancelado'))
);
GO

CREATE TABLE Mantenimiento_DetalleMantenimientoRepuesto (
    id_det_rep          INT             NOT NULL IDENTITY(1,1),
    id_orden_mant       INT             NOT NULL,
    id_repuesto         INT             NOT NULL,
    cantidad_usada      DECIMAL(8,2)    NOT NULL,
    precio_al_momento   DECIMAL(10,2)   NOT NULL,
    CONSTRAINT PK_DetalleMantenimientoRepuesto  PRIMARY KEY (id_det_rep),
    CONSTRAINT FK_DetRep_Orden                  FOREIGN KEY (id_orden_mant) REFERENCES Mantenimiento_OrdenMantenimiento(id_orden_mant),
    CONSTRAINT FK_DetRep_Repuesto               FOREIGN KEY (id_repuesto)   REFERENCES Mantenimiento_Repuesto(id_repuesto),
    CONSTRAINT CK_DetRep_cantidad               CHECK (cantidad_usada > 0),
    CONSTRAINT CK_DetRep_precio                 CHECK (precio_al_momento > 0)
);
GO

CREATE TABLE Mantenimiento_RegistroCombustible (
    id_combustible          INT             NOT NULL IDENTITY(1,1),
    id_maquinaria           INT             NOT NULL,
    id_empleado             INT             NOT NULL,
    id_proveedor            INT             NOT NULL,
    fecha_carga             DATETIME        NOT NULL DEFAULT GETDATE(),
    litros_cargados         DECIMAL(8,2)    NOT NULL,
    tipo_combustible        VARCHAR(30)     NOT NULL,
    costo_por_litro         DECIMAL(6,2)    NOT NULL,
    costo_total             AS (litros_cargados * costo_por_litro) PERSISTED,
    horas_maquina           DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    proveedor_combustible   VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_RegistroCombustible       PRIMARY KEY (id_combustible),
    CONSTRAINT FK_Combustible_Maquinaria    FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Combustible_Empleado      FOREIGN KEY (id_empleado)   REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_Combustible_Proveedor     FOREIGN KEY (id_proveedor)  REFERENCES Proveedor_Proveedor(id_proveedor),
    CONSTRAINT CK_Combustible_tipo          CHECK (tipo_combustible IN ('Diesel','Gasolina','Gas_LP')),
    CONSTRAINT CK_Combustible_litros        CHECK (litros_cargados > 0)
);
GO

-- Nota: id_marca ref 500..514, id_proveedor ref 1000..1009
SET IDENTITY_INSERT Mantenimiento_Repuesto ON;
INSERT INTO Mantenimiento_Repuesto (id_repuesto, codigo_repuesto, nombre_repuesto, id_marca, unidad_medida, precio_unitario, stock_actual, stock_minimo, id_proveedor) VALUES
(27000, 'REP-CAT-001', 'Filtro de Aceite CAT',          500, 'Unidad',  350.00,  25, 5,  1000),
(27001, 'REP-CAT-002', 'Filtro de Combustible CAT',      500, 'Unidad',  280.00,  20, 5,  1000),
(27002, 'REP-KOM-001', 'Filtro de Aceite Komatsu',       501, 'Unidad',  380.00,  18, 5,  1000),
(27003, 'REP-CAT-003', 'Aceite Motor CAT DEO 15W-40',    500, 'Litro',    85.00, 200, 50, 1004),
(27004, 'REP-KOM-002', 'Aceite Hidraulico Komatsu HD30', 501, 'Litro',    90.00, 150, 40, 1004),
(27005, 'REP-GEN-001', 'Correa Dentada Universal',        500, 'Unidad',  620.00,  10, 3,  1000),
(27006, 'REP-CAT-004', 'Bateria 12V 120Ah CAT',          500, 'Unidad', 1800.00,   8, 2,  1000),
(27007, 'REP-GEN-002', 'Kit de Sellos Hidraulicos',       501, 'Juego',   950.00,  12, 4,  1000),
(27008, 'REP-NEU-001', 'Neumatico 23.5R25 Todo Terreno', 500, 'Unidad',12500.00,   4, 2,  1003),
(27009, 'REP-NEU-002', 'Neumatico 17.5R25 Industrial',   501, 'Unidad', 9800.00,   6, 2,  1003),
(27010, 'REP-GEN-003', 'Grasa de Trabajo Pesado 5kg',    500, 'Bote',    480.00,  30, 8,  1004),
(27011, 'REP-CAT-005', 'Elemento de Filtro de Aire CAT', 500, 'Unidad',  420.00,  15, 4,  1000),
(27012, 'REP-KOM-003', 'Faja de Distribucion Komatsu',   501, 'Unidad',  780.00,   8, 3,  1000),
(27013, 'REP-GEN-004', 'Bomba de Agua Universal',        500, 'Unidad', 2200.00,   5, 2,  1000),
(27014, 'REP-GEN-005', 'Pastillas de Freno Industriales',500, 'Juego',  1150.00,  10, 3,  1000);
SET IDENTITY_INSERT Mantenimiento_Repuesto OFF;
GO
 
-- Nota: id_maquinaria ref 3000..3019, id_tipo_mant ref 700..709,
--       id_tecnico ref 5000..5019, id_proveedor_externo ref 1000..1009
SET IDENTITY_INSERT Mantenimiento_OrdenMantenimiento ON;
INSERT INTO Mantenimiento_OrdenMantenimiento (id_orden_mant, id_maquinaria, id_tipo_mant, id_tecnico, id_proveedor_externo, fecha_programada, fecha_realizada, horas_maquina_al_mant, costo_total, estado, descripcion_trabajo) VALUES
(28000, 3003, 703, 5008, 1002, '2024-01-15', '2024-01-18', 4450.00,  8500.00, 'Completado', 'Reparacion de sistema hidraulico por perdida de presion.'),
(28001, 3000, 700, 5008, NULL, '2024-02-01', '2024-02-01', 1250.00,  1800.00, 'Completado', 'Cambio de aceite y filtros a las 1250 horas.'),
(28002, 3001, 701, 5008, NULL, '2024-03-01', '2024-03-02', 2100.00,  3200.00, 'Completado', 'Inspeccion de sistema electrico e hidraulico.'),
(28003, 3004, 701, 5008, 1002, '2024-04-01', '2024-04-03',  620.00,  4500.00, 'Completado', 'Revision integral de grua excavadora Volvo.'),
(28004, 3007, 700, 5014, NULL, '2024-04-15', '2024-04-15', 2200.00,  1750.00, 'Completado', 'Mantenimiento preventivo 250 horas Hitachi.'),
(28005, 3002, 705, 5008, NULL, '2024-05-01', NULL,          850.00,     0.00, 'Programado', 'Revision pre-operacional cargador frontal.'),
(28006, 3009, 700, 5014, NULL, '2024-05-15', '2024-05-15',  185.00,  1200.00, 'Completado', 'Primer mantenimiento JCB 3CX.'),
(28007, 3013, 700, 5008, NULL, '2024-06-01', '2024-06-02',  630.00,  1500.00, 'Completado', 'Cambio de aceite y filtros compactadora.'),
(28008, 3008, 702, 5008, 1002, '2024-07-01', '2024-07-05',  380.00, 12000.00, 'Completado', 'Revision completa de 1000 horas cargador Case.'),
(28009, 3019, 705, 5014, NULL, '2024-10-01', '2024-10-01',   90.00,   800.00, 'Completado', 'Primera revision pre-operacional Hitachi nuevo.');
SET IDENTITY_INSERT Mantenimiento_OrdenMantenimiento OFF;
GO
 
-- Nota: id_orden_mant ref 28000..28009, id_repuesto ref 27000..27014
SET IDENTITY_INSERT Mantenimiento_DetalleMantenimientoRepuesto ON;
INSERT INTO Mantenimiento_DetalleMantenimientoRepuesto (id_det_rep, id_orden_mant, id_repuesto, cantidad_usada, precio_al_momento) VALUES
(29000, 28000, 27004, 10.00, 90.00),
(29001, 28000, 27007,  1.00, 950.00),
(29002, 28001, 27000,  1.00, 350.00),
(29003, 28001, 27003, 12.00, 85.00),
(29004, 28001, 27011,  1.00, 420.00),
(29005, 28002, 27002,  1.00, 380.00),
(29006, 28002, 27004,  8.00, 90.00),
(29007, 28003, 27004, 20.00, 90.00),
(29008, 28003, 27007,  2.00, 950.00),
(29009, 28004, 27000,  1.00, 350.00),
(29010, 28004, 27003, 10.00, 85.00),
(29011, 28006, 27000,  1.00, 350.00),
(29012, 28006, 27003,  8.00, 85.00),
(29013, 28007, 27000,  1.00, 350.00),
(29014, 28008, 27002,  1.00, 380.00),
(29015, 28008, 27004, 15.00, 90.00),
(29016, 28008, 27007,  3.00, 950.00);
SET IDENTITY_INSERT Mantenimiento_DetalleMantenimientoRepuesto OFF;
GO
 
-- Nota: id_maquinaria ref 3000..3019, id_empleado ref 5013 (Bodeguero),
--       id_proveedor ref 1001 (Combustibles del Sur) y 1008 (Combustibles del Norte)
SET IDENTITY_INSERT Mantenimiento_RegistroCombustible ON;
INSERT INTO Mantenimiento_RegistroCombustible (id_combustible, id_maquinaria, id_empleado, id_proveedor, fecha_carga, litros_cargados, tipo_combustible, costo_por_litro, horas_maquina, proveedor_combustible) VALUES
(30000, 3000, 5013, 1001, '20240120 08:00:00', 150.00, 'Diesel', 32.50, 1255.00, 'Combustibles del Sur S.A.'),
(30001, 3001, 5013, 1001, '20240210 07:30:00', 180.00, 'Diesel', 32.50, 2110.00, 'Combustibles del Sur S.A.'),
(30002, 3003, 5013, 1008, '20240120 09:00:00', 200.00, 'Diesel', 32.00, 4505.00, 'Combustibles del Norte S.A.'),
(30003, 3004, 5013, 1001, '20240215 06:30:00', 250.00, 'Diesel', 32.50,  635.00, 'Combustibles del Sur S.A.'),
(30004, 3006, 5013, 1001, '20240401 08:00:00', 120.00, 'Diesel', 32.50,  785.00, 'Combustibles del Sur S.A.'),
(30005, 3007, 5013, 1008, '20240420 08:30:00', 160.00, 'Diesel', 32.00, 2260.00, 'Combustibles del Norte S.A.'),
(30006, 3010, 5013, 1001, '20240905 07:00:00', 220.00, 'Diesel', 32.50, 3105.00, 'Combustibles del Sur S.A.'),
(30007, 3011, 5013, 1001, '20241001 06:30:00', 190.00, 'Diesel', 32.50, 4210.00, 'Combustibles del Sur S.A.'),
(30008, 3014, 5013, 1001, '20240615 08:00:00',  80.00, 'Diesel', 32.50,  225.00, 'Combustibles del Sur S.A.'),
(30009, 3018, 5013, 1008, '20240815 07:30:00', 200.00, 'Diesel', 32.00,  515.00, 'Combustibles del Norte S.A.');
SET IDENTITY_INSERT Mantenimiento_RegistroCombustible OFF;
GO
-- ============================================================================================================================
-- MÓDULO 12 — INCIDENTES Y SEGUROS
-- ============================================================================================================================

CREATE TABLE Incidentes_SeguroMaquinaria (
    id_seguro           INT             NOT NULL IDENTITY(1,1),
    id_maquinaria       INT             NOT NULL,
    id_proveedor        INT             NOT NULL,
    aseguradora         VARCHAR(100)    NOT NULL,
    numero_poliza       VARCHAR(60)     NOT NULL,
    tipo_cobertura      VARCHAR(80)     NOT NULL,
    fecha_inicio        DATE            NOT NULL,
    fecha_vencimiento   DATE            NOT NULL,
    prima_anual         DECIMAL(10,2)   NOT NULL,
    estado_poliza       VARCHAR(20)     NOT NULL DEFAULT 'Activa',
    CONSTRAINT PK_SeguroMaquinaria      PRIMARY KEY (id_seguro),
    CONSTRAINT UQ_Seguro_poliza         UNIQUE (numero_poliza),
    CONSTRAINT FK_Seguro_Maquinaria     FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Seguro_Proveedor      FOREIGN KEY (id_proveedor)  REFERENCES Proveedor_Proveedor(id_proveedor),
    CONSTRAINT CK_Seguro_estado         CHECK (estado_poliza IN ('Activa','Vencida','Cancelada')),
    CONSTRAINT CK_Seguro_fechas         CHECK (fecha_vencimiento > fecha_inicio),
    CONSTRAINT CK_Seguro_prima          CHECK (prima_anual > 0)
);
GO

CREATE TABLE Incidentes_Incidente (
    id_incidente            INT             NOT NULL IDENTITY(1,1),
    id_tipo_inc             INT             NOT NULL,
    id_maquinaria           INT             NOT NULL,
    id_traslado             INT                 NULL,
    id_empleado_reporta     INT             NOT NULL,
    id_operador_cliente     INT                 NULL,
    fecha_hora_ocurrencia   DATETIME        NOT NULL,
    id_municipio            INT             NOT NULL,
    descripcion             VARCHAR(1000)   NOT NULL,
    danos_estimados         DECIMAL(12,2)   NOT NULL DEFAULT 0,
    estado_incidente        VARCHAR(20)     NOT NULL DEFAULT 'Abierto',
    CONSTRAINT PK_Incidente             PRIMARY KEY (id_incidente),
    CONSTRAINT FK_Incidente_Tipo        FOREIGN KEY (id_tipo_inc)         REFERENCES Catalogo_TipoIncidente(id_tipo_inc),
    CONSTRAINT FK_Incidente_Maquinaria  FOREIGN KEY (id_maquinaria)       REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Incidente_Traslado    FOREIGN KEY (id_traslado)         REFERENCES Operaciones_TrasladoMaquinaria(id_traslado),
    CONSTRAINT FK_Incidente_Empleado    FOREIGN KEY (id_empleado_reporta) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_Incidente_OpCliente   FOREIGN KEY (id_operador_cliente) REFERENCES Contratos_OperadorCliente(id_operador_cliente),
    CONSTRAINT FK_Incidente_Municipio   FOREIGN KEY (id_municipio)        REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Incidente_estado      CHECK (estado_incidente IN ('Abierto','En_Investigacion','Cerrado')),
    CONSTRAINT CK_Incidente_danos       CHECK (danos_estimados >= 0)
);
GO

-- ============================================================================================================================
-- MÓDULO 13 — REGISTRO DE FALLECIDOS EN ACCIDENTES DE TRANSPORTE (nueva tabla)
-- ============================================================================================================================

CREATE TABLE Incidentes_RegistroFallecido (
    id_fallecido            INT             NOT NULL IDENTITY(1,1),
    id_incidente            INT             NOT NULL,
    tipo_victima            VARCHAR(30)     NOT NULL,
    nombre_completo         VARCHAR(150)    NOT NULL,
    dpi_victima             VARCHAR(20)     NOT NULL,
    id_empleado_vinculado   INT                 NULL,
    id_operador_cliente     INT                 NULL,
    fecha_fallecimiento     DATE            NOT NULL,
    causa_fallecimiento     VARCHAR(200)    NOT NULL,
    lugar_fallecimiento     VARCHAR(200)    NOT NULL,
    id_municipio            INT             NOT NULL,
    numero_acta_defuncion   VARCHAR(60)     NOT NULL,
    observaciones           VARCHAR(500)    NOT NULL DEFAULT 'En proceso de investigacion',
    CONSTRAINT PK_RegistroFallecido         PRIMARY KEY (id_fallecido),
    CONSTRAINT UQ_Fallecido_dpi             UNIQUE (dpi_victima),
    CONSTRAINT UQ_Fallecido_acta            UNIQUE (numero_acta_defuncion),
    CONSTRAINT FK_Fallecido_Incidente       FOREIGN KEY (id_incidente)         REFERENCES Incidentes_Incidente(id_incidente),
    CONSTRAINT FK_Fallecido_Empleado        FOREIGN KEY (id_empleado_vinculado) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_Fallecido_OpCliente       FOREIGN KEY (id_operador_cliente)   REFERENCES Contratos_OperadorCliente(id_operador_cliente),
    CONSTRAINT FK_Fallecido_Municipio       FOREIGN KEY (id_municipio)          REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT CK_Fallecido_tipo            CHECK (tipo_victima IN ('Empleado','Operador_Cliente','Tercero','Peaton'))
);
GO

-- Nota: id_maquinaria ref 3000..3019, id_proveedor ref 1006 (Seguros Industriales GT)
SET IDENTITY_INSERT Incidentes_SeguroMaquinaria ON;
INSERT INTO Incidentes_SeguroMaquinaria (id_seguro, id_maquinaria, id_proveedor, aseguradora, numero_poliza, tipo_cobertura, fecha_inicio, fecha_vencimiento, prima_anual, estado_poliza) VALUES
(31000, 3000, 1006, 'Seguros Industriales GT', 'POL-IND-001-2024', 'Cobertura Todo Riesgo',          '2024-01-01', '2024-12-31',  42000.00, 'Activa'),
(31001, 3001, 1006, 'Seguros Industriales GT', 'POL-IND-002-2024', 'Cobertura Todo Riesgo',          '2024-01-01', '2024-12-31',  46000.00, 'Activa'),
(31002, 3002, 1006, 'Seguros Industriales GT', 'POL-IND-003-2024', 'Responsabilidad Civil',          '2024-01-01', '2024-12-31',  39000.00, 'Activa'),
(31003, 3003, 1006, 'Seguros Industriales GT', 'POL-IND-004-2024', 'Cobertura Todo Riesgo',          '2024-01-01', '2024-12-31',  57500.00, 'Activa'),
(31004, 3004, 1006, 'Seguros Industriales GT', 'POL-IND-005-2024', 'Cobertura Todo Riesgo Ampliada', '2024-01-01', '2024-12-31',  90000.00, 'Activa'),
(31005, 3005, 1006, 'Seguros Industriales GT', 'POL-IND-006-2024', 'Cobertura Todo Riesgo Premium',  '2024-01-01', '2024-12-31', 175000.00, 'Activa'),
(31006, 3006, 1006, 'Seguros Industriales GT', 'POL-IND-007-2024', 'Responsabilidad Civil',          '2024-01-01', '2024-12-31',  16000.00, 'Activa'),
(31007, 3007, 1006, 'Seguros Industriales GT', 'POL-IND-008-2024', 'Cobertura Todo Riesgo',          '2024-01-01', '2024-12-31',  43500.00, 'Activa'),
(31008, 3008, 1006, 'Seguros Industriales GT', 'POL-IND-009-2024', 'Responsabilidad Civil',          '2024-01-01', '2024-12-31',  37500.00, 'Activa'),
(31009, 3009, 1006, 'Seguros Industriales GT', 'POL-IND-010-2024', 'Cobertura Basica',               '2024-01-01', '2024-12-31',  14500.00, 'Activa');
SET IDENTITY_INSERT Incidentes_SeguroMaquinaria OFF;
GO
 
-- Nota: id_tipo_inc ref 800..814, id_maquinaria ref 3000..3019,
--       id_traslado ref 20000..20009, id_empleado_reporta ref 5000..5019,
--       id_operador_cliente ref 9000..9009, id_municipio ref 200..223
SET IDENTITY_INSERT Incidentes_Incidente ON;

INSERT INTO Incidentes_Incidente 
(id_incidente, id_tipo_inc, id_maquinaria, id_traslado, id_empleado_reporta, id_operador_cliente, fecha_hora_ocurrencia, id_municipio, descripcion, danos_estimados, estado_incidente) 
VALUES
(32000, 802, 3003, NULL,  5008, NULL, '20240110 14:30:00', 200, 'Falla mecanica en sistema hidraulico durante operacion en proyecto.', 45000.00, 'Cerrado'),
(32001, 800, 3004, 20001, 5001, 9001, '20240201 09:15:00', 205, 'Colision menor con vehiculo estacionado durante maniobra de descarga.', 18000.00, 'Cerrado'),
(32002, 809, 3006, 20002, 5009, 9002, '20240314 15:00:00', 201, 'Golpe leve del operador con estructura durante maniobra. Sin lesion grave.', 0.00, 'Cerrado'),
(32003, 811, 3011, 20009, 5001, NULL, '20241014 10:30:00', 211, 'Explosion de neumatico trasero en ruta a Puerto Barrios sin lesionados.', 12500.00, 'En_Investigacion'),
(32004, 810, 3004, 20001, 5001, 9001, '20240201 11:45:00', 205, 'Fallecimiento de operador del cliente posterior a colision registrada.', 0.00, 'Cerrado');

SET IDENTITY_INSERT Incidentes_Incidente OFF;
GO
 
-- Nota: id_incidente ref 32000..32004, id_operador_cliente ref 9001, id_municipio ref 205
SET IDENTITY_INSERT Incidentes_RegistroFallecido ON;
INSERT INTO Incidentes_RegistroFallecido (id_fallecido, id_incidente, tipo_victima, nombre_completo, dpi_victima, id_empleado_vinculado, id_operador_cliente, fecha_fallecimiento, causa_fallecimiento, lugar_fallecimiento, id_municipio, numero_acta_defuncion, observaciones) VALUES
(33000, 32004, 'Operador_Cliente', 'Luis Ramirez Orozco', '3000000020202', NULL, 9001, '2024-02-01', 'Traumatismo craneoencefalico grave posterior a colision vehicular en ruta.', 'Km 65 Carretera al Pacifico, Escuintla', 205, 'ACTA-DEF-ES-001-2024', 'Caso cerrado. Indemnizacion pagada a beneficiarios. Expediente completo en RRHH.');
SET IDENTITY_INSERT Incidentes_RegistroFallecido OFF;
GO
-- ============================================================================================================================
-- MÓDULO 14 — SEGURIDAD DE BASE DE DATOS
-- ============================================================================================================================

CREATE TABLE Seguridad_RolSistema (
    id_rol          INT             NOT NULL IDENTITY(1,1),
    nombre_rol      VARCHAR(60)     NOT NULL,
    descripcion     VARCHAR(500)    NOT NULL,
    nivel_acceso    INT             NOT NULL,
    CONSTRAINT PK_RolSistema    PRIMARY KEY (id_rol),
    CONSTRAINT UQ_Rol_nombre    UNIQUE (nombre_rol),
    CONSTRAINT CK_Rol_nivel     CHECK (nivel_acceso BETWEEN 1 AND 5)
);
GO

CREATE TABLE Seguridad_Permiso (
    id_permiso      INT             NOT NULL IDENTITY(1,1),
    nombre_permiso  VARCHAR(80)     NOT NULL,
    modulo          VARCHAR(60)     NOT NULL,
    tipo_accion     VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_Permiso           PRIMARY KEY (id_permiso),
    CONSTRAINT UQ_Permiso_nombre    UNIQUE (nombre_permiso),
    CONSTRAINT CK_Permiso_accion    CHECK (tipo_accion IN ('SELECT','INSERT','UPDATE','DELETE','EXECUTE'))
);
GO

CREATE TABLE Seguridad_RolPermiso (
    id_rol_permiso  INT             NOT NULL IDENTITY(1,1),
    id_rol          INT             NOT NULL,
    id_permiso      INT             NOT NULL,
    CONSTRAINT PK_RolPermiso            PRIMARY KEY (id_rol_permiso),
    CONSTRAINT FK_RolPermiso_Rol        FOREIGN KEY (id_rol)    REFERENCES Seguridad_RolSistema(id_rol),
    CONSTRAINT FK_RolPermiso_Permiso    FOREIGN KEY (id_permiso)REFERENCES Seguridad_Permiso(id_permiso),
    CONSTRAINT UQ_RolPermiso            UNIQUE (id_rol, id_permiso)
);
GO

CREATE TABLE Seguridad_UsuarioSistema (
    id_usuario      INT             NOT NULL IDENTITY(1,1),
    id_empleado     INT             NOT NULL,
    username        VARCHAR(50)     NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    ultimo_acceso   DATETIME            NULL,
    activo          CHAR(2)         NOT NULL DEFAULT 'SI',   -- reemplaza BIT
    id_rol          INT             NOT NULL,
    CONSTRAINT PK_UsuarioSistema        PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_Usuario_empleado      UNIQUE (id_empleado),
    CONSTRAINT UQ_Usuario_username      UNIQUE (username),
    CONSTRAINT FK_Usuario_Empleado      FOREIGN KEY (id_empleado) REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_Usuario_Rol           FOREIGN KEY (id_rol)      REFERENCES Seguridad_RolSistema(id_rol),
    CONSTRAINT CK_Usuario_activo        CHECK (activo IN ('SI','NO'))
);
GO

-- Bitácora (reemplaza AuditoriaLog)

    drop table Seguridad_Bitacora
CREATE TABLE Seguridad_Bitacora (
    id_bitacora             BIGINT          NOT NULL IDENTITY(1,1),
    id_usuario              INT                 NULL,
    tabla_afectada          VARCHAR(80)     NOT NULL,
    accion                  VARCHAR(20)     NOT NULL,
    id_registro_afectado    INT                 NULL,
    fecha_hora              DATETIME        NOT NULL DEFAULT GETDATE(),
    valor_anterior          NVARCHAR(MAX)       NULL,
    valor_nuevo             NVARCHAR(MAX)       NULL,
    ip_origen               VARCHAR(45)     NOT NULL DEFAULT '0.0.0.0',
    nombre_usuario          VARCHAR(50)     NOT NULL DEFAULT 'sistema',
    CONSTRAINT PK_Bitacora              PRIMARY KEY (id_bitacora),
--    CONSTRAINT FK_Bitacora_Usuario      FOREIGN KEY (id_usuario) REFERENCES Seguridad_UsuarioSistema(id_usuario),
    CONSTRAINT CK_Bitacora_accion       CHECK (accion IN ('INSERT','UPDATE','DELETE','SELECT','LOGIN','LOGOUT'))
);
GO

CREATE TABLE Seguridad_Notificacion (
    id_notificacion         INT             NOT NULL IDENTITY(1,1),
    id_usuario_destino      INT             NOT NULL,
    tipo_notificacion       VARCHAR(60)     NOT NULL,
    mensaje                 VARCHAR(1000)   NOT NULL,
    fecha_generacion        DATETIME        NOT NULL DEFAULT GETDATE(),
    leida                   CHAR(2)         NOT NULL DEFAULT 'NO',   -- reemplaza BIT
    id_referencia           INT                 NULL,
    tabla_referencia        VARCHAR(80)     NOT NULL DEFAULT 'Sin_referencia',
    CONSTRAINT PK_Notificacion      PRIMARY KEY (id_notificacion),
    CONSTRAINT FK_Notif_Usuario     FOREIGN KEY (id_usuario_destino) REFERENCES Seguridad_UsuarioSistema(id_usuario),
    CONSTRAINT CK_Notif_tipo        CHECK (tipo_notificacion IN ('Vencimiento','Alerta','Incidente','Mantenimiento','Contrato','Stock')),
    CONSTRAINT CK_Notif_leida       CHECK (leida IN ('SI','NO'))
);
GO

SET IDENTITY_INSERT Seguridad_RolSistema ON;
INSERT INTO Seguridad_RolSistema (id_rol, nombre_rol, descripcion, nivel_acceso) VALUES
(34000, 'Administrador', 'Acceso total al sistema. Gestiona usuarios y configuraciones.', 1),
(34001, 'Gerente',       'Acceso a reportes, aprobacion de contratos y supervision general.', 2),
(34002, 'Supervisor',    'Gestion de operaciones, maquinaria y personal a cargo.', 3),
(34003, 'Operativo',     'Registro de operaciones diarias, traslados y mantenimientos.', 4),
(34004, 'Solo_Lectura',  'Consulta de informacion sin capacidad de modificacion.', 5);
SET IDENTITY_INSERT Seguridad_RolSistema OFF;
GO
 
SET IDENTITY_INSERT Seguridad_Permiso ON;
INSERT INTO Seguridad_Permiso (id_permiso, nombre_permiso, modulo, tipo_accion) VALUES
(35000, 'VER_CONTRATOS',     'Contratos',  'SELECT'),
(35001, 'CREAR_CONTRATOS',   'Contratos',  'INSERT'),
(35002, 'EDITAR_CONTRATOS',  'Contratos',  'UPDATE'),
(35003, 'ELIMINAR_CONTRATOS','Contratos',  'DELETE'),
(35004, 'VER_MAQUINARIA',    'Maquinaria', 'SELECT'),
(35005, 'CREAR_MAQUINARIA',  'Maquinaria', 'INSERT'),
(35006, 'EDITAR_MAQUINARIA', 'Maquinaria', 'UPDATE'),
(35007, 'VER_EMPLEADOS',     'RRHH',       'SELECT'),
(35008, 'CREAR_EMPLEADOS',   'RRHH',       'INSERT'),
(35009, 'VER_REPORTES',      'Analitica',  'SELECT'),
(35010, 'EJECUTAR_REPORTES', 'Analitica',  'EXECUTE'),
(35011, 'VER_BITACORA',      'Seguridad',  'SELECT'),
(35012, 'GESTIONAR_USUARIOS','Seguridad',  'INSERT'),
(35013, 'VER_INCIDENTES',    'Incidentes', 'SELECT'),
(35014, 'CREAR_INCIDENTES',  'Incidentes', 'INSERT');
SET IDENTITY_INSERT Seguridad_Permiso OFF;
GO
 
SET IDENTITY_INSERT Seguridad_RolPermiso ON;
INSERT INTO Seguridad_RolPermiso (id_rol_permiso, id_rol, id_permiso) VALUES
-- Administrador (34000): todos los permisos
(36000, 34000, 35000),(36001, 34000, 35001),(36002, 34000, 35002),(36003, 34000, 35003),
(36004, 34000, 35004),(36005, 34000, 35005),(36006, 34000, 35006),(36007, 34000, 35007),
(36008, 34000, 35008),(36009, 34000, 35009),(36010, 34000, 35010),(36011, 34000, 35011),
(36012, 34000, 35012),(36013, 34000, 35013),(36014, 34000, 35014),
-- Gerente (34001)
(36015, 34001, 35000),(36016, 34001, 35001),(36017, 34001, 35002),(36018, 34001, 35004),
(36019, 34001, 35007),(36020, 34001, 35009),(36021, 34001, 35010),(36022, 34001, 35013),
-- Supervisor (34002)
(36023, 34002, 35000),(36024, 34002, 35004),(36025, 34002, 35007),(36026, 34002, 35009),
(36027, 34002, 35013),(36028, 34002, 35014),
-- Operativo (34003)
(36029, 34003, 35000),(36030, 34003, 35004),(36031, 34003, 35013),(36032, 34003, 35014),
-- Solo_Lectura (34004)
(36033, 34004, 35000),(36034, 34004, 35004),(36035, 34004, 35009);
SET IDENTITY_INSERT Seguridad_RolPermiso OFF;
GO
 
-- Nota: id_empleado ref 5000..5019, id_rol ref 34000..34004
SET IDENTITY_INSERT Seguridad_UsuarioSistema ON;

INSERT INTO Seguridad_UsuarioSistema 
(id_usuario, id_empleado, username, password_hash, ultimo_acceso, activo, id_rol) 
VALUES
(37000, 5000, 'c.mendoza',   '5e884898da28047151d0e56f8dc62927273ec1328737723a5a7d4c07f6ec2bab', '20241015 08:30:00', 'SI', 34000),
(37001, 5001, 'a.fuentes',   '5e884898da28047151d0e56f8dc62927273ec1328737723b5a7d4c07f6ec2bab', '20241015 07:45:00', 'SI', 34001),
(37002, 5002, 'r.lima',      '5e884898da28047151d0e56f8dc62927273ec1328737723c5a7d4c07f6ec2bab', '20241014 17:00:00', 'SI', 34001),
(37003, 5003, 's.barrios',   '5e884898da28047151d0e56f8dc62927273ec1328737723d5a7d4c07f6ec2bab', '20241015 08:00:00', 'SI', 34001),
(37004, 5004, 'm.giron',     '5e884898da28047151d0e56f8dc62927273ec1328737723e5a7d4c07f6ec2bab', '20241015 06:30:00', 'SI', 34002),
(37005, 5008, 'm.diaz',      '5e884898da28047151d0e56f8dc62927273ec1328737723f5a7d4c07f6ec2bab', '20241014 16:00:00', 'SI', 34002),
(37006, 5009, 'e.morales',   '5e884898da28047151d0e56f8dc629272740c1328737723a5a7d4c07f6ec2bab', '20241015 07:00:00', 'SI', 34003),
(37007, 5010, 'j.velasquez', '5e884898da28047151d0e56f8dc629272740c1328737723b5a7d4c07f6ec2bab', '20241015 09:00:00', 'SI', 34002),
(37008, 5011, 'm.escobar',   '5e884898da28047151d0e56f8dc629272740c1328737723c5a7d4c07f6ec2bab', '20241015 08:45:00', 'SI', 34003),
(37009, 5014, 'o.ramirez',   '5e884898da28047151d0e56f8dc629272740c1328737723d5a7d4c07f6ec2bab', '20241014 15:30:00', 'SI', 34003);

SET IDENTITY_INSERT Seguridad_UsuarioSistema OFF;
GO
 
-- Nota: id_usuario ref 37000..37009
SET IDENTITY_INSERT Seguridad_Bitacora ON;

INSERT INTO Seguridad_Bitacora 
(id_bitacora, id_usuario, tabla_afectada, accion, id_registro_afectado, fecha_hora, valor_anterior, valor_nuevo, ip_origen, nombre_usuario) 
VALUES
(38000, 37000, 'Contratos_ContratoAlquiler',       'INSERT', 11009, '20241015 09:05:00', NULL, '{"numero_contrato":"CONT-2024-010","valor_total":145000}', '192.168.1.10', 'c.mendoza'),
(38001, 37001, 'Maquinaria_Maquinaria',            'UPDATE', 3003,  '20240118 18:00:00', '{"estado_equipo":"Mantenimiento"}', '{"estado_equipo":"Disponible"}', '192.168.1.11', 'a.fuentes'),
(38002, 37004, 'Operaciones_TrasladoMaquinaria',   'INSERT', 20009, '20241014 08:30:00', NULL, '{"id_maquinaria":3011,"id_ruta":19003,"estado":"En_Transito"}', '192.168.1.15', 'm.giron'),
(38003, 37005, 'Mantenimiento_OrdenMantenimiento', 'UPDATE', 28000, '20240118 17:45:00', '{"estado":"En_Proceso"}', '{"estado":"Completado","costo_total":8500}', '192.168.1.19', 'm.diaz'),
(38004, 37000, 'Seguridad_UsuarioSistema',         'LOGIN',  37000, '20241015 08:30:00', NULL, NULL, '192.168.1.10', 'c.mendoza');

SET IDENTITY_INSERT Seguridad_Bitacora OFF;
GO
 
-- Nota: id_usuario_destino ref 37000..37009, id_referencia referencia al PK de la tabla referenciada
SET IDENTITY_INSERT Seguridad_Notificacion ON;
INSERT INTO Seguridad_Notificacion (id_notificacion, id_usuario_destino, tipo_notificacion, mensaje, leida, id_referencia, tabla_referencia) VALUES
(39000, 37000, 'Vencimiento',   'La poliza de seguro POL-IND-001-2024 vence en 30 dias. Renovar antes del 31-DIC-2024.',         'NO', 31000, 'Incidentes_SeguroMaquinaria'),
(39001, 37001, 'Mantenimiento', 'La maquinaria CAT 320 (M-001) tiene mantenimiento preventivo programado para el 01-FEB-2024.', 'SI', 28001, 'Mantenimiento_OrdenMantenimiento'),
(39002, 37004, 'Alerta',        'Alerta de peso detectada en inspeccion de carga del traslado 10. Revisar inmediatamente.',      'NO', 26001, 'Carga_AlertaCarga'),
(39003, 37007, 'Contrato',      'El contrato CONT-2024-010 fue creado exitosamente por valor de Q145,000.00.',                   'SI', 11009, 'Contratos_ContratoAlquiler'),
(39004, 37005, 'Incidente',     'Se registro un incidente tipo explosion de neumatico en traslado 10. Requiere investigacion.',  'NO', 32003, 'Incidentes_Incidente');
SET IDENTITY_INSERT Seguridad_Notificacion OFF;
GO
 
-- ============================================================================================================================
-- MÓDULO 15 — ANALÍTICA / OLAP  (Modelo Estrella — tabla de hechos central)
-- ============================================================================================================================

CREATE TABLE Analitica_CostoOperativo (
    id_costo        INT             NOT NULL IDENTITY(1,1),
    id_maquinaria   INT             NOT NULL,
    id_contrato     INT             NOT NULL,
    tipo_costo      VARCHAR(60)     NOT NULL,
    mes             TINYINT         NOT NULL,
    anio            SMALLINT        NOT NULL,
    monto           DECIMAL(12,2)   NOT NULL,
    descripcion     VARCHAR(500)    NOT NULL,
    CONSTRAINT PK_CostoOperativo        PRIMARY KEY (id_costo),
    CONSTRAINT FK_Costo_Maquinaria      FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Costo_Contrato        FOREIGN KEY (id_contrato)   REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT CK_Costo_tipo            CHECK (tipo_costo IN ('Combustible','Mantenimiento','Traslado','Seguro','Administrativo','Otro')),
    CONSTRAINT CK_Costo_mes             CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT CK_Costo_monto           CHECK (monto > 0)
);
GO

CREATE TABLE Analitica_IndicadorRendimiento (
    id_indicador    INT             NOT NULL IDENTITY(1,1),
    id_maquinaria   INT             NOT NULL,
    id_empleado     INT             NOT NULL,
    tipo_indicador  VARCHAR(60)     NOT NULL,
    mes             TINYINT         NOT NULL,
    anio            SMALLINT        NOT NULL,
    valor_indicador DECIMAL(10,4)   NOT NULL,
    unidad_medida   VARCHAR(30)     NOT NULL,
    observaciones   VARCHAR(500)    NOT NULL DEFAULT 'Sin observaciones adicionales',
    CONSTRAINT PK_IndicadorRendimiento  PRIMARY KEY (id_indicador),
    CONSTRAINT FK_Indicador_Maquinaria  FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Indicador_Empleado    FOREIGN KEY (id_empleado)   REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT CK_Indicador_mes         CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT CK_Indicador_tipo        CHECK (tipo_indicador IN ('Utilizacion','Consumo_Combustible','Productividad','Disponibilidad','MTTR','MTBF'))
);
GO

CREATE TABLE Analitica_HistorialUbicacionMaquinaria (
    id_historial        INT             NOT NULL IDENTITY(1,1),
    id_maquinaria       INT             NOT NULL,
    id_municipio        INT             NOT NULL,
    fecha_hora_registro DATETIME        NOT NULL DEFAULT GETDATE(),
    latitud             DECIMAL(10,6)   NOT NULL DEFAULT 0.000000,
    longitud            DECIMAL(10,6)   NOT NULL DEFAULT 0.000000,
    fuente_registro     VARCHAR(40)     NOT NULL DEFAULT 'Manual',
    id_traslado         INT                 NULL,
    CONSTRAINT PK_HistorialUbicacion        PRIMARY KEY (id_historial),
    CONSTRAINT FK_Historial_Maquinaria      FOREIGN KEY (id_maquinaria) REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_Historial_Municipio       FOREIGN KEY (id_municipio)  REFERENCES Geografia_Municipio(id_municipio),
    CONSTRAINT FK_Historial_Traslado        FOREIGN KEY (id_traslado)   REFERENCES Operaciones_TrasladoMaquinaria(id_traslado),
    CONSTRAINT CK_Historial_fuente          CHECK (fuente_registro IN ('Manual','Sistema','Traslado','GPS'))
);
GO

-- Nota: id_maquinaria ref 3000..3019, id_contrato ref 11000..11009
SET IDENTITY_INSERT Analitica_CostoOperativo ON;
INSERT INTO Analitica_CostoOperativo (id_costo, id_maquinaria, id_contrato, tipo_costo, mes, anio, monto, descripcion) VALUES
(40000, 3000, 11000, 'Combustible',   1, 2024,  4875.00, 'Consumo diesel enero CAT 320 proyecto Zona 10.'),
(40001, 3000, 11000, 'Mantenimiento', 2, 2024,  1800.00, 'Cambio aceite y filtros 1250 horas.'),
(40002, 3000, 11000, 'Seguro',        1, 2024,  3500.00, 'Cuota mensual seguro todo riesgo.'),
(40003, 3001, 11001, 'Combustible',   2, 2024,  5850.00, 'Consumo diesel febrero Komatsu CA-9.'),
(40004, 3003, 11000, 'Mantenimiento', 1, 2024,  8500.00, 'Reparacion sistema hidraulico Komatsu D85.'),
(40005, 3004, 11001, 'Combustible',   2, 2024,  8125.00, 'Consumo Volvo EC380 obra vial.'),
(40006, 3004, 11001, 'Traslado',      2, 2024,  8000.00, 'Costo traslado GT-Xela traslado 20001.'),
(40007, 3004, 11001, 'Seguro',        2, 2024,  7500.00, 'Prima mensual seguro Volvo.'),
(40008, 3011, 11009, 'Combustible',  10, 2024,  6175.00, 'Consumo Mack Granite ruta Atlantic.'),
(40009, 3011, 11009, 'Traslado',     10, 2024, 11000.00, 'Costo traslado GT-Puerto Barrios en transito.');
SET IDENTITY_INSERT Analitica_CostoOperativo OFF;
GO
 
-- Nota: id_maquinaria ref 3000..3019, id_empleado ref 5000..5019
SET IDENTITY_INSERT Analitica_IndicadorRendimiento ON;
INSERT INTO Analitica_IndicadorRendimiento (id_indicador, id_maquinaria, id_empleado, tipo_indicador, mes, anio, valor_indicador, unidad_medida, observaciones) VALUES
(41000, 3000, 5005, 'Utilizacion',         1, 2024,   85.50, 'Porcentaje', 'Alta utilizacion en proyecto zona 10.'),
(41001, 3000, 5005, 'Consumo_Combustible', 1, 2024,   12.00, 'L/hora',    'Consumo dentro del rango esperado.'),
(41002, 3001, 5005, 'Utilizacion',         2, 2024,   92.00, 'Porcentaje', 'Maquinaria alquilada todo el mes.'),
(41003, 3004, 5005, 'Disponibilidad',      2, 2024,   98.00, 'Porcentaje', 'Equipo sin paros no programados.'),
(41004, 3003, 5008, 'MTTR',                1, 2024,   72.00, 'Horas',     'Tiempo de reparacion sistema hidraulico.'),
(41005, 3003, 5008, 'MTBF',                1, 2024, 1500.00, 'Horas',     'Tiempo promedio entre fallas del bulldozer.'),
(41006, 3007, 5008, 'Productividad',       4, 2024,   95.00, 'Porcentaje', 'Alta productividad post mantenimiento.'),
(41007, 3009, 5006, 'Utilizacion',         4, 2024,   88.00, 'Porcentaje', 'JCB activo en proyecto edificio.'),
(41008, 3011, 5007, 'Consumo_Combustible',10, 2024,   28.00, 'L/hora',    'Consumo elevado por carga sobredimensionada.'),
(41009, 3014, 5005, 'Disponibilidad',      6, 2024,  100.00, 'Porcentaje', 'Mini excavadora sin fallas desde entrega.');
SET IDENTITY_INSERT Analitica_IndicadorRendimiento OFF;
GO
 
-- Nota: id_maquinaria ref 3000..3019, id_municipio ref 200..223, id_traslado ref 20000..20009
SET IDENTITY_INSERT Analitica_HistorialUbicacionMaquinaria ON;

INSERT INTO Analitica_HistorialUbicacionMaquinaria 
(id_historial, id_maquinaria, id_municipio, fecha_hora_registro, latitud, longitud, fuente_registro, id_traslado) 
VALUES
(42000, 3000, 200, '20240101 07:00:00', 14.634915, -90.506882, 'Sistema',  NULL),
(42001, 3000, 205, '20240109 10:00:00', 14.308159, -90.785381, 'Traslado', 20000),
(42002, 3004, 200, '20240131 05:00:00', 14.634915, -90.506882, 'Sistema',  NULL),
(42003, 3004, 208, '20240201 11:30:00', 14.838959, -91.523080, 'Traslado', 20001),
(42004, 3006, 200, '20240314 07:00:00', 14.634915, -90.506882, 'Manual',   NULL),
(42005, 3006, 201, '20240314 08:45:00', 14.630570, -90.606575, 'Traslado', 20002),
(42006, 3011, 200, '20241014 04:00:00', 14.634915, -90.506882, 'GPS',      NULL),
(42007, 3011, 211, '20241014 12:30:00', 15.730800, -88.593900, 'GPS',      20009),
(42008, 3010, 200, '20240901 06:00:00', 14.634915, -90.506882, 'Sistema',  NULL),
(42009, 3018, 211, '20240809 12:30:00', 15.730800, -88.593900, 'Traslado', 20007);

SET IDENTITY_INSERT Analitica_HistorialUbicacionMaquinaria OFF;
GO
-- ============================================================================================================================
-- FIN DEL SCRIPT — GestionMaquinaria v2.0
-- ============================================================================================================================

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================================================================================
-- SECCIÓN 1: TRIGGERS (15 en total)
-- ============================================================================================================================

-- -------------------------------------------------------
-- TRIGGER 1: Auditar cambios de estado en Maquinaria (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_AuditarEstadoMaquinaria
ON Maquinaria_Maquinaria
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(estado_equipo)
    BEGIN
        INSERT INTO Seguridad_Bitacora (
            tabla_afectada, accion, id_registro_afectado,
            fecha_hora, valor_anterior, valor_nuevo, nombre_usuario
        )
        SELECT
            'Maquinaria_Maquinaria',
            'UPDATE',
            i.id_maquinaria,
            GETDATE(),
            d.estado_equipo,
            i.estado_equipo,
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.id_maquinaria = d.id_maquinaria;
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 2: Al registrar un mantenimiento, cambiar estado de maquinaria a 'Mantenimiento' (AFTER INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_EstadoMaquinariaAlCrearOrden
ON Mantenimiento_OrdenMantenimiento
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Maquinaria_Maquinaria
    SET estado_equipo = 'Mantenimiento'
    FROM Maquinaria_Maquinaria m
    INNER JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
    WHERE i.estado = 'En_Proceso';
END;
GO

-- -------------------------------------------------------
-- TRIGGER 3: Al completar un mantenimiento, liberar la maquinaria a 'Disponible' (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_LiberarMaquinariaPostMantenimiento
ON Mantenimiento_OrdenMantenimiento
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(estado)
    BEGIN
        UPDATE Maquinaria_Maquinaria
        SET estado_equipo = 'Disponible'
        FROM Maquinaria_Maquinaria m
        INNER JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
        WHERE i.estado = 'Completado'
          AND m.estado_equipo = 'Mantenimiento';
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 4: Evitar alquilar maquinaria que no está 'Disponible' (INSTEAD OF INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ValidarDisponibilidadAlquiler
ON Contratos_DetalleContrato
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Maquinaria_Maquinaria m ON i.id_maquinaria = m.id_maquinaria
        WHERE m.estado_equipo <> 'Disponible'
    )
    BEGIN
        RAISERROR('No se puede alquilar maquinaria que no está en estado Disponible.', 16, 1);
        RETURN;
    END

    INSERT INTO Contratos_DetalleContrato
        (id_contrato, id_maquinaria, fecha_entrega, fecha_devolucion, tarifa_diaria, dias_contratados)
    SELECT id_contrato, id_maquinaria, fecha_entrega, fecha_devolucion, tarifa_diaria, dias_contratados
    FROM inserted;

    -- Marcar la maquinaria como alquilada
    UPDATE Maquinaria_Maquinaria
    SET estado_equipo = 'Alquilado'
    FROM Maquinaria_Maquinaria m
    INNER JOIN inserted i ON m.id_maquinaria = i.id_maquinaria;
END;
GO

-- -------------------------------------------------------
-- TRIGGER 5: Registrar automáticamente en bitácora cada nuevo contrato (AFTER INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_BitacoraContratos
ON Contratos_ContratoAlquiler
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Seguridad_Bitacora (
        tabla_afectada, accion, id_registro_afectado,
        fecha_hora, valor_nuevo, nombre_usuario
    )
    SELECT
        'Contratos_ContratoAlquiler',
        'INSERT',
        i.id_contrato,
        GETDATE(),
        CONCAT('{"numero_contrato":"', i.numero_contrato, '","valor_total":', i.valor_total, '}'),
        SYSTEM_USER
    FROM inserted i;
END;
GO

-- -------------------------------------------------------
-- TRIGGER 6: Impedir eliminar empleados con contratos activos (INSTEAD OF DELETE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ProtegerEmpleadoConContrato
ON RRHH_Empleado
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM deleted d
        INNER JOIN Contratos_ContratoAlquiler c ON d.id_empleado = c.id_empleado_ventas
        WHERE c.estado_contrato = 'Activo'
    )
    BEGIN
        RAISERROR('No se puede eliminar un empleado con contratos activos asignados.', 16, 1);
        RETURN;
    END

    DELETE FROM RRHH_Empleado
    WHERE id_empleado IN (SELECT id_empleado FROM deleted);
END;
GO

-- -------------------------------------------------------
-- TRIGGER 7: Al insertar un incidente crítico, crear notificación automática (AFTER INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_NotificacionIncidenteCritico
ON Incidentes_Incidente
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_usuario_admin INT;
    SELECT TOP 1 @id_usuario_admin = id_usuario
    FROM Seguridad_UsuarioSistema
    WHERE id_rol = (SELECT id_rol FROM Seguridad_RolSistema WHERE nombre_rol = 'Administrador');

    IF @id_usuario_admin IS NOT NULL
    BEGIN
        INSERT INTO Seguridad_Notificacion (
            id_usuario_destino, tipo_notificacion, mensaje,
            id_referencia, tabla_referencia
        )
        SELECT
            @id_usuario_admin,
            'Incidente',
            CONCAT('Incidente registrado en maquinaria ID ', i.id_maquinaria, ': ', LEFT(i.descripcion, 100)),
            i.id_incidente,
            'Incidentes_Incidente'
        FROM inserted i
        INNER JOIN Catalogo_TipoIncidente t ON i.id_tipo_inc = t.id_tipo_inc
        WHERE t.nivel_gravedad IN ('Grave', 'Critico');
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 8: Actualizar horas de uso de maquinaria al completar mantenimiento (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ActualizarHorasUsoMaquinaria
ON Mantenimiento_OrdenMantenimiento
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(horas_maquina_al_mant)
    BEGIN
        UPDATE Maquinaria_Maquinaria
        SET horas_uso_total = i.horas_maquina_al_mant
        FROM Maquinaria_Maquinaria m
        INNER JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
        WHERE i.horas_maquina_al_mant > m.horas_uso_total;
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 9: Validar que el stock no quede negativo al usar repuestos (AFTER INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ValidarStockRepuesto
ON Mantenimiento_DetalleMantenimientoRepuesto
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Mantenimiento_Repuesto r ON i.id_repuesto = r.id_repuesto
        WHERE r.stock_actual < i.cantidad_usada
    )
    BEGIN
        RAISERROR('Stock insuficiente para uno o más repuestos solicitados.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Mantenimiento_Repuesto
    SET stock_actual = stock_actual - CAST(i.cantidad_usada AS INT)
    FROM Mantenimiento_Repuesto r
    INNER JOIN inserted i ON r.id_repuesto = i.id_repuesto;
END;
GO

-- -------------------------------------------------------
-- TRIGGER 10: Registrar historial de ubicación al completar un traslado (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_HistorialUbicacionTraslado
ON Operaciones_TrasladoMaquinaria
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(estado_traslado)
    BEGIN
        INSERT INTO Analitica_HistorialUbicacionMaquinaria (
            id_maquinaria, id_municipio, fecha_hora_registro,
            fuente_registro, id_traslado
        )
        SELECT
            i.id_maquinaria,
            r.id_municipio_destino,
            GETDATE(),
            'Traslado',
            i.id_traslado
        FROM inserted i
        INNER JOIN Operaciones_Ruta r ON i.id_ruta = r.id_ruta
        WHERE i.estado_traslado = 'Completado';
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 11: Impedir contratos con fechas inválidas (INSTEAD OF INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ValidarFechasContrato
ON Contratos_ContratoAlquiler
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE fecha_fin_estimada < fecha_inicio
    )
    BEGIN
        RAISERROR('La fecha fin estimada no puede ser anterior a la fecha de inicio del contrato.', 16, 1);
        RETURN;
    END

    INSERT INTO Contratos_ContratoAlquiler (
        numero_contrato, id_cliente, id_empleado_ventas,
        fecha_inicio, fecha_fin_estimada, fecha_fin_real,
        estado_contrato, valor_total, moneda, observaciones
    )
    SELECT numero_contrato, id_cliente, id_empleado_ventas,
           fecha_inicio, fecha_fin_estimada, fecha_fin_real,
           estado_contrato, valor_total, moneda, observaciones
    FROM inserted;
END;
GO

-- -------------------------------------------------------
-- TRIGGER 12: Alerta automática cuando stock de repuesto baja del mínimo (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_AlertaStockMinimo
ON Mantenimiento_Repuesto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(stock_actual)
    BEGIN
        DECLARE @id_admin_usuario INT;
        SELECT TOP 1 @id_admin_usuario = id_usuario
        FROM Seguridad_UsuarioSistema
        WHERE id_rol = (SELECT id_rol FROM Seguridad_RolSistema WHERE nombre_rol = 'Administrador');

        IF @id_admin_usuario IS NOT NULL
        BEGIN
            INSERT INTO Seguridad_Notificacion (
                id_usuario_destino, tipo_notificacion, mensaje,
                id_referencia, tabla_referencia
            )
            SELECT
                @id_admin_usuario,
                'Stock',
                CONCAT('Repuesto "', i.nombre_repuesto, '" bajo del stock mínimo. Stock actual: ', i.stock_actual),
                i.id_repuesto,
                'Mantenimiento_Repuesto'
            FROM inserted i
            INNER JOIN deleted d ON i.id_repuesto = d.id_repuesto
            WHERE i.stock_actual < i.stock_minimo
              AND d.stock_actual >= d.stock_minimo;
        END
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 13: Registrar en bitácora eliminación de registros de carga (AFTER DELETE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_BitacoraEliminacionCarga
ON Carga_RegistroCarga
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Seguridad_Bitacora (
        tabla_afectada, accion, id_registro_afectado,
        fecha_hora, valor_anterior, nombre_usuario
    )
    SELECT
        'Carga_RegistroCarga',
        'DELETE',
        d.id_carga,
        GETDATE(),
        CONCAT('{"id_traslado":', d.id_traslado, ',"peso_kg":', d.peso_declarado_kg, '}'),
        SYSTEM_USER
    FROM deleted d;
END;
GO

-- -------------------------------------------------------
-- TRIGGER 14: Cerrar contrato automáticamente al registrar fecha_fin_real (AFTER UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CerrarContratoAutomatico
ON Contratos_ContratoAlquiler
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(fecha_fin_real)
    BEGIN
        UPDATE Contratos_ContratoAlquiler
        SET estado_contrato = 'Cerrado'
        FROM Contratos_ContratoAlquiler c
        INNER JOIN inserted i ON c.id_contrato = i.id_contrato
        WHERE i.fecha_fin_real IS NOT NULL
          AND i.estado_contrato = 'Activo';
    END
END;
GO

-- -------------------------------------------------------
-- TRIGGER 15: Evitar insertar facturas duplicadas por número (INSTEAD OF INSERT)
-- -------------------------------------------------------
CREATE OR ALTER TRIGGER trg_ValidarFacturaDuplicada
ON Contratos_Factura
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Contratos_Factura f ON i.numero_factura = f.numero_factura
    )
    BEGIN
        RAISERROR('Ya existe una factura con ese número. No se permiten duplicados.', 16, 1);
        RETURN;
    END

    INSERT INTO Contratos_Factura (
        id_contrato, numero_factura, fecha_emision,
        monto_subtotal, monto_impuesto, estado_pago, fecha_vencimiento
    )
    SELECT id_contrato, numero_factura, fecha_emision,
           monto_subtotal, monto_impuesto, estado_pago, fecha_vencimiento
    FROM inserted;
END;
GO


-- ============================================================================================================================
-- SECCIÓN 2: PROCEDIMIENTOS ALMACENADOS (15 en total)
-- ============================================================================================================================

-- -------------------------------------------------------
-- PROC 1: Resumen de maquinaria con su marca, categoría y bodega (JOIN + info)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ResumenMaquinaria
AS
BEGIN
    SELECT
        m.id_maquinaria,
        m.placa,
        mm.nombre_modelo,
        ma.nombre_marca,
        cat.nombre_categoria,
        m.estado_equipo,
        m.horas_uso_total,
        m.costo_adquisicion,
        b.nombre_bodega,
        mun.nombre_municipio
    FROM Maquinaria_Maquinaria m
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    INNER JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
    INNER JOIN Maquinaria_Bodega b ON m.id_bodega = b.id_bodega
    INNER JOIN Geografia_Municipio mun ON b.id_municipio = mun.id_municipio
    ORDER BY ma.nombre_marca, mm.nombre_modelo;
END;
GO

-- -------------------------------------------------------
-- PROC 2: Contratos activos con datos del cliente y vendedor (JOIN múltiple)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ContratosActivos
AS
BEGIN
    SELECT
        c.numero_contrato,
        c.fecha_inicio,
        c.fecha_fin_estimada,
        c.valor_total,
        c.estado_contrato,
        cl.razon_social AS cliente,
        cl.tipo_cliente,
        e.nombre + ' ' + e.apellido AS vendedor,
        DATEDIFF(DAY, c.fecha_inicio, c.fecha_fin_estimada) AS duracion_dias,
        mun.nombre_municipio AS municipio_cliente
    FROM Contratos_ContratoAlquiler c
    INNER JOIN Contratos_Cliente cl ON c.id_cliente = cl.id_cliente
    INNER JOIN RRHH_Empleado e ON c.id_empleado_ventas = e.id_empleado
    INNER JOIN Geografia_Municipio mun ON cl.id_municipio = mun.id_municipio
    WHERE c.estado_contrato = 'Activo'
    ORDER BY c.fecha_inicio DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 3: Promedio de costo de adquisición por categoría de maquinaria (AVG + GROUP BY + JOIN)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_PromedioCostoAdquisicionPorCategoria
AS
BEGIN
    SELECT
        cat.nombre_categoria,
        COUNT(m.id_maquinaria)          AS total_equipos,
        AVG(m.costo_adquisicion)        AS promedio_costo,
        MIN(m.costo_adquisicion)        AS costo_minimo,
        MAX(m.costo_adquisicion)        AS costo_maximo,
        SUM(m.costo_adquisicion)        AS costo_total_flota
    FROM Maquinaria_Maquinaria m
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
    GROUP BY cat.nombre_categoria
    ORDER BY promedio_costo DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 4: Reporte de mantenimientos con costo total por maquinaria (SUM + GROUP BY + JOIN)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CostoMantenimientoPorMaquinaria
AS
BEGIN
    SELECT
        m.placa,
        mm.nombre_modelo,
        ma.nombre_marca,
        COUNT(o.id_orden_mant)          AS total_ordenes,
        SUM(o.costo_total)              AS costo_total_mantenimiento,
        AVG(o.costo_total)              AS costo_promedio_por_orden,
        MAX(o.costo_total)              AS orden_mas_costosa,
        SUM(o.horas_maquina_al_mant)    AS horas_acumuladas
    FROM Mantenimiento_OrdenMantenimiento o
    INNER JOIN Maquinaria_Maquinaria m ON o.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    WHERE o.estado = 'Completado'
    GROUP BY m.placa, mm.nombre_modelo, ma.nombre_marca
    ORDER BY costo_total_mantenimiento DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 5: Buscar contratos de un cliente por NIT (parámetro de entrada)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ContratrosPorCliente
    @nit_cliente VARCHAR(20)
AS
BEGIN
    SELECT
        c.numero_contrato,
        c.fecha_inicio,
        c.fecha_fin_estimada,
        c.valor_total,
        c.estado_contrato,
        c.observaciones,
        d.id_maquinaria,
        mm.nombre_modelo,
        ma.nombre_marca,
        d.tarifa_diaria,
        d.dias_contratados,
        d.subtotal
    FROM Contratos_ContratoAlquiler c
    INNER JOIN Contratos_Cliente cl ON c.id_cliente = cl.id_cliente
    INNER JOIN Contratos_DetalleContrato d ON c.id_contrato = d.id_contrato
    INNER JOIN Maquinaria_Maquinaria m ON d.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    WHERE cl.nit_cliente = @nit_cliente
    ORDER BY c.fecha_inicio DESC;
END;
GO


-- -------------------------------------------------------
-- PROC 6: Insertar nuevo empleado con validación (parámetros entrada + OUTPUT)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_InsertarEmpleado
    @dpi             VARCHAR(20),
    @nombre          VARCHAR(60),
    @apellido        VARCHAR(60),
    @id_cargo        INT,
    @id_depto        INT,
    @fecha_contrato  DATE,
    @salario         DECIMAL(10,2),
    @telefono        VARCHAR(20),
    @correo          VARCHAR(100),
    @id_municipio    INT,
    @id_nuevo        INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM RRHH_Empleado WHERE dpi = @dpi)
    BEGIN
        RAISERROR('Ya existe un empleado con ese DPI.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM RRHH_Cargo WHERE id_cargo = @id_cargo)
    BEGIN
        RAISERROR('El cargo especificado no existe.', 16, 1);
        RETURN;
    END

    INSERT INTO RRHH_Empleado (dpi, nombre, apellido, id_cargo, id_departamento_emp,
        fecha_contratacion, salario_actual, telefono, correo_corporativo, id_municipio)
    VALUES (@dpi, @nombre, @apellido, @id_cargo, @id_depto,
        @fecha_contrato, @salario, @telefono, @correo, @id_municipio);

    SET @id_nuevo = SCOPE_IDENTITY();
END;
GO

-- -------------------------------------------------------
-- PROC 7: Top 5 maquinarias con más horas de uso (MAX + ORDER BY + JOIN)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_TopMaquinariasMasUsadas
AS
BEGIN
    SELECT TOP 5
        m.placa,
        mm.nombre_modelo,
        ma.nombre_marca,
        cat.nombre_categoria,
        m.horas_uso_total,
        m.estado_equipo,
        m.costo_adquisicion,
        b.nombre_bodega
    FROM Maquinaria_Maquinaria m
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    INNER JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
    INNER JOIN Maquinaria_Bodega b ON m.id_bodega = b.id_bodega
    ORDER BY m.horas_uso_total DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 8: Consumo total y promedio de combustible por maquinaria (SUM + AVG + GROUP BY)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ConsumoCombustiblePorMaquinaria
AS
BEGIN
    SELECT
        m.placa,
        mm.nombre_modelo,
        COUNT(rc.id_combustible)        AS total_cargas,
        SUM(rc.litros_cargados)         AS total_litros,
        AVG(rc.litros_cargados)         AS promedio_litros_por_carga,
        SUM(rc.costo_total)             AS costo_total_combustible,
        AVG(rc.costo_por_litro)         AS precio_promedio_litro,
        MAX(rc.litros_cargados)         AS carga_maxima
    FROM Mantenimiento_RegistroCombustible rc
    INNER JOIN Maquinaria_Maquinaria m ON rc.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    GROUP BY m.placa, mm.nombre_modelo
    ORDER BY total_litros DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 9: Reporte de incidentes con gravedad y maquinaria involucrada (JOIN + filtro)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ReporteIncidentesPorGravedad
    @nivel_gravedad VARCHAR(20) = NULL
AS
BEGIN
    SELECT
        i.id_incidente,
        t.nombre_tipo            AS tipo_incidente,
        t.nivel_gravedad,
        m.placa,
        mm.nombre_modelo,
        e.nombre + ' ' + e.apellido AS reportado_por,
        i.fecha_hora_ocurrencia,
        mun.nombre_municipio     AS lugar_ocurrencia,
        i.danos_estimados,
        i.estado_incidente,
        i.descripcion
    FROM Incidentes_Incidente i
    INNER JOIN Catalogo_TipoIncidente t ON i.id_tipo_inc = t.id_tipo_inc
    INNER JOIN Maquinaria_Maquinaria m ON i.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN RRHH_Empleado e ON i.id_empleado_reporta = e.id_empleado
    INNER JOIN Geografia_Municipio mun ON i.id_municipio = mun.id_municipio
    WHERE (@nivel_gravedad IS NULL OR t.nivel_gravedad = @nivel_gravedad)
    ORDER BY i.fecha_hora_ocurrencia DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 10: Total facturado y pagado por cliente (SUM + LEFT JOIN + GROUP BY)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_FacturacionPorCliente
AS
BEGIN
    SELECT
        cl.razon_social,
        cl.nit_cliente,
        cl.tipo_cliente,
        COUNT(DISTINCT c.id_contrato)   AS total_contratos,
        COUNT(f.id_factura)             AS total_facturas,
        SUM(f.monto_subtotal)           AS total_subtotal,
        SUM(f.monto_impuesto)           AS total_impuesto,
        SUM(f.monto_total)              AS total_facturado,
        SUM(ISNULL(p.monto_pagado, 0))  AS total_pagado,
        SUM(f.monto_total) - SUM(ISNULL(p.monto_pagado, 0)) AS saldo_pendiente
    FROM Contratos_Cliente cl
    INNER JOIN Contratos_ContratoAlquiler c ON cl.id_cliente = c.id_cliente
    INNER JOIN Contratos_Factura f ON c.id_contrato = f.id_contrato
    LEFT JOIN Contratos_Pago p ON f.id_factura = p.id_factura
    GROUP BY cl.razon_social, cl.nit_cliente, cl.tipo_cliente
    ORDER BY total_facturado DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 11: Actualizar salario de empleados de un departamento (parámetros + UPDATE)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_ActualizarSalarioDepartamento
    @id_departamento    INT,
    @porcentaje_aumento DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF @porcentaje_aumento <= 0 OR @porcentaje_aumento > 50
    BEGIN
        RAISERROR('El porcentaje de aumento debe estar entre 0 y 50.', 16, 1);
        RETURN;
    END

    UPDATE RRHH_Empleado
    SET salario_actual = salario_actual * (1 + @porcentaje_aumento / 100)
    WHERE id_departamento_emp = @id_departamento
      AND estado = 'Activo';

    SELECT @@ROWCOUNT AS empleados_actualizados;
END;
GO

-- -------------------------------------------------------
-- PROC 12: Traslados con ruta, conductor y maquinaria (JOIN múltiple + filtro por estado)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_TrasladosPorEstado
    @estado VARCHAR(20) = 'En_Transito'
AS
BEGIN
    SELECT
        t.id_traslado,
        m.placa                         AS maquinaria_placa,
        mm.nombre_modelo,
        r.nombre_ruta,
        orig.nombre_municipio           AS municipio_origen,
        dest.nombre_municipio           AS municipio_destino,
        r.distancia_km,
        r.nivel_riesgo,
        e.nombre + ' ' + e.apellido     AS conductor,
        v.placa                         AS vehiculo_placa,
        v.tipo_vehiculo,
        t.fecha_salida,
        t.fecha_llegada_estimada,
        t.fecha_llegada_real,
        t.costo_traslado,
        t.estado_traslado
    FROM Operaciones_TrasladoMaquinaria t
    INNER JOIN Maquinaria_Maquinaria m ON t.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Operaciones_Ruta r ON t.id_ruta = r.id_ruta
    INNER JOIN Geografia_Municipio orig ON r.id_municipio_origen = orig.id_municipio
    INNER JOIN Geografia_Municipio dest ON r.id_municipio_destino = dest.id_municipio
    INNER JOIN RRHH_Empleado e ON t.id_conductor = e.id_empleado
    INNER JOIN Operaciones_VehiculoTransporte v ON t.id_vehiculo_transporte = v.id_vehiculo
    WHERE t.estado_traslado = @estado
    ORDER BY t.fecha_salida DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 13: Costos operativos totales por mes y año (SUM + GROUP BY + JOIN)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CostosOperativosMensuales
    @anio SMALLINT = 2024
AS
BEGIN
    SELECT
        co.anio,
        co.mes,
        co.tipo_costo,
        COUNT(*)                AS cantidad_registros,
        SUM(co.monto)           AS total_mes,
        AVG(co.monto)           AS promedio_por_registro,
        MAX(co.monto)           AS monto_maximo,
        mm.nombre_modelo,
        ma.nombre_marca
    FROM Analitica_CostoOperativo co
    INNER JOIN Maquinaria_Maquinaria m ON co.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    WHERE co.anio = @anio
    GROUP BY co.anio, co.mes, co.tipo_costo, mm.nombre_modelo, ma.nombre_marca
    ORDER BY co.mes, total_mes DESC;
END;
GO

-- -------------------------------------------------------
-- PROC 14: Certificaciones vencidas o próximas a vencer de conductores (JOIN + DATEDIFF)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_CertificacionesPorVencer
    @dias_alerta INT = 90
AS
BEGIN
    SELECT
        e.nombre + ' ' + e.apellido     AS empleado,
        c.nombre_cargo,
        cc.tipo_licencia,
        cc.numero_certificado,
        cc.entidad_certificadora,
        cc.fecha_emision,
        cc.fecha_vencimiento,
        DATEDIFF(DAY, GETDATE(), cc.fecha_vencimiento) AS dias_para_vencer,
        cc.estado_cert,
        mun.nombre_municipio            AS municipio_empleado
    FROM RRHH_CertificacionConductor cc
    INNER JOIN RRHH_Empleado e ON cc.id_empleado = e.id_empleado
    INNER JOIN RRHH_Cargo c ON e.id_cargo = c.id_cargo
    INNER JOIN Geografia_Municipio mun ON e.id_municipio = mun.id_municipio
    WHERE DATEDIFF(DAY, GETDATE(), cc.fecha_vencimiento) <= @dias_alerta
       OR cc.estado_cert = 'Vencida'
    ORDER BY dias_para_vencer ASC;
END;
GO

-- -------------------------------------------------------
-- PROC 15: Indicadores de rendimiento promedio por maquinaria (AVG + GROUP BY + JOIN)
-- -------------------------------------------------------
CREATE OR ALTER PROCEDURE sp_IndicadoresRendimientoResumen
AS
BEGIN
    SELECT
        m.placa,
        mm.nombre_modelo,
        ma.nombre_marca,
        cat.nombre_categoria,
        ir.tipo_indicador,
        ir.unidad_medida,
        AVG(ir.valor_indicador)         AS promedio_indicador,
        MAX(ir.valor_indicador)         AS valor_maximo,
        MIN(ir.valor_indicador)         AS valor_minimo,
        COUNT(ir.id_indicador)          AS total_registros,
        ir.anio
    FROM Analitica_IndicadorRendimiento ir
    INNER JOIN Maquinaria_Maquinaria m ON ir.id_maquinaria = m.id_maquinaria
    INNER JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo = mm.id_modelo
    INNER JOIN Catalogo_Marca ma ON mm.id_marca = ma.id_marca
    INNER JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
    GROUP BY m.placa, mm.nombre_modelo, ma.nombre_marca,
             cat.nombre_categoria, ir.tipo_indicador, ir.unidad_medida, ir.anio
    ORDER BY ir.tipo_indicador, promedio_indicador DESC;
END;
GO


-- ============================================================================================================================
-- CONSULTAS DE PRUEBA RÁPIDA  (ejecuta cada una individualmente)
-- ============================================================================================================================

EXEC sp_ResumenMaquinaria;
EXEC sp_ContratosActivos;
EXEC sp_PromedioCostoAdquisicionPorCategoria;
EXEC sp_CostoMantenimientoPorMaquinaria;
EXEC sp_ContratrosPorCliente @nit_cliente = '7001001-1';
EXEC sp_TopMaquinariasMasUsadas;
EXEC sp_ConsumoCombustiblePorMaquinaria;
EXEC sp_ReporteIncidentesPorGravedad @nivel_gravedad = 'Critico';
EXEC sp_FacturacionPorCliente;
EXEC sp_TrasladosPorEstado @estado = 'Completado';
EXEC sp_CostosOperativosMensuales @anio = 2024;
EXEC sp_CertificacionesPorVencer @dias_alerta = 365;
EXEC sp_IndicadoresRendimientoResumen;
GO

CREATE OR ALTER TRIGGER trg_DetectarCambioEstado
ON Maquinaria_Maquinaria
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- IF UPDATE(columna) verifica si esa columna fue modificada
    IF UPDATE(estado_equipo)
    BEGIN
        INSERT INTO Seguridad_Bitacora (
            tabla_afectada, accion, id_registro_afectado,
            valor_anterior, valor_nuevo, nombre_usuario
        )
        SELECT
            'Maquinaria_Maquinaria', 'UPDATE', i.id_maquinaria,
            d.estado_equipo,   -- valor ANTES (tabla deleted)
            i.estado_equipo,   -- valor DESPUÉS (tabla inserted)
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.id_maquinaria = d.id_maquinaria;
    END
END



select * from RRHH_Empleado
select * from Seguridad_Bitacora

CREATE TRIGGER ejercicio1_examen
on RRHH_Empleado 

after update

as
Begin
    IF update (Salario_actual)
    Begin
    Insert into Seguridad_Bitacora (
     tabla_afectada, accion, id_registro_afectado,
     valor_anterior, valor_nuevo, nombre_usuario
     )
    
    select 'RRHH_Empleado', 'UPDATE', i.id_empleado,
            cast( d.salario_actual) as varchar,   -- valor ANTES (tabla deleted)
            cast(i.salario_actual) as varchar,   -- valor DESPUÉS (tabla inserted)
            SYSTEM_USER
        FROM inserted i
        INNER JOIN deleted d ON i.id_empleado = d.id_empleado;
        WHERE i.salario_actual <> d.salario_actual;
   END
end;



select * from Contratos_Factura

Create trigger ejemplo2_examen
on Contratos_factura
Instead of insert
as
 begin
        IF EXISTS (
        SELECT 1 FROM inserted
        WHERE DATEDIFF(DAY, fecha_emision, fecha_vencimiento) < 15
    )
    begin
            RAISERROR ('fecha de vencimiento 15 dias despues de la emision')
    end
    return;

        INSERT INTO Contratos_Factura (
        id_contrato, numero_factura, fecha_emision,
        monto_subtotal, monto_impuesto, estado_pago, fecha_vencimiento
    )
    SELECT id_contrato, numero_factura, fecha_emision,
           monto_subtotal, monto_impuesto, estado_pago, fecha_vencimiento
    FROM inserted;

 end;

 select * from Operaciones_TrasladoMaquinaria
 Create trigger ejercicio3_examen
 on Operaciones_TrasladoMaquinaria
 after insert
 as
 begin
          SET NOCOUNT ON;
    UPDATE Maquinaria_Maquinaria
    SET estado_equipo = 'Traslado'
    FROM Maquinaria_Maquinaria mq
    INNER JOIN inserted i ON mq.id_maquinaria = i.id_maquinaria
    WHERE i.estado_traslado = 'En_Transito';
end;


Select * from Incidentes_RegistroFallecido

CREATE TRIGGER ejercicio4_examen
ON Incidentes_RegistroFallecido
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Usamos IF EXISTS para ver si el usuario intentó borrar algo
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Usamos RAISERROR en lugar de PRINT para que sea un error real
        RAISERROR ('Los registros de fallecidos no pueden eliminarse por política de la empresa.', 16, 1);
        RETURN;
    END
END;

select * from Incidentes_Incidente
select * from Maquinaria_Maquinaria

CREATE TRIGGER ejercicio5_examen
on Incidentes_incidente 
after Insert
as
begin
     
           SELECT I.id_maquinaria, M.estado_equipo from
           Incidentes_Incidente I inner join Maquinaria_Maquinaria M
           on
           I.id_maquinaria= M.id_maquinaria where M.estado_equipo= 'Disponible'
         
          print ('hay una maquinaria disponible')

end;




-- procdures examen
select *from RRHH_Empleado
select * from RRHH_Cargo

CREATE PROCEDURE sp_SalarioPromedioPorCargo 
AS
BEGIN
    SET NOCOUNT ON;
    select nombre_cargo, salario_base, 
    *from RRHH_Cargo C where salario_base 
EnD;

CREATE OR ALTER PROCEDURE sp_SalarioPromedioPorCargo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        c.nombre_cargo,
        c.nivel_jerarquico,
        COUNT(e.id_empleado)     AS total_empleados,
        AVG(e.salario_actual)    AS salario_promedio,
        MIN(e.salario_actual)    AS salario_minimo,
        MAX(e.salario_actual)    AS salario_maximo,
        SUM(e.salario_actual)    AS costo_total_cargo
    FROM RRHH_Cargo c
    INNER JOIN RRHH_Empleado e ON c.id_cargo = e.id_cargo
    WHERE e.estado = 'Activo'
    GROUP BY c.nombre_cargo, c.nivel_jerarquico
    ORDER BY salario_promedio DESC;

END;
exec sp_SalarioPromedioPorCargo


select * from Maquinaria_Maquinaria
select * from Maquinaria_ModeloMaquinaria
select *from Catalogo_CategoriaMaquinaria

Select c.nombre_categoria, count(m.id_modelo) as Total_maquinas
from Maquinaria_Maquinaria m
inner join Maquinaria_ModeloMaquinaria mm on m.id_modelo=mm.id_modelo 
inner join Catalogo_CategoriaMaquinaria c on c.id_categoria=mm.id_categoria
group by c.nombre_categoria
order by Total_maquinas



--trigger

select * from Contratos_ContratoAlquiler
select * from Maquinaria_Maquinaria

create trigger ejrcicio1_parcial2
on Contratos_contratoAlquiler
after insert
as
begin
      update Maquinaria_Maquinaria
      set mq.estado_equipo ='Disponible';
      from Maquinaria_Maquinaria mq
      inner join inserted i on mq.id_maquinaria=i.id_maquinaria
      where i.estado_equipo='Alquilado';

end;


      CREATE TRIGGER trg_AlquilarMaquinaria
ON Contratos_DetalleContrato -- Tabla correcta según el ejercicio
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE mq
    SET mq.estado_equipo = 'Alquilado' -- Lo que queremos lograr
    FROM Maquinaria_Maquinaria mq
    INNER JOIN inserted i ON mq.id_maquinaria = i.id_maquinaria;
    -- Quitamos el WHERE porque queremos que TODA máquina insertada en 
    -- el detalle pase a estar alquilada.
END;

select* from Maquinaria_Maquinaria
select * from Catalogo_CategoriaMaquinaria
select *from Maquinaria_ModeloMaquinaria
select * from Catalogo_Marca

create procedure sp_MaquinariaDisponible 
as
begin
    SET NOCOUNT ON;
    select 
        m.placa as Placa,
        mm.nombre_modelo as Nombre_Modelo,
        c.nombre_categoria as Nombre_Categoria,
        m.costo_adquisicion AS Costo_Maquinaria,
        m.horas_uso_total as Total_Horas_de_uso

    from Maquinaria_Maquinaria m
    inner join  Maquinaria_ModeloMaquinaria mm on m.id_modelo=mm.id_modelo
    inner join Catalogo_CategoriaMaquinaria c on mm.id_categoria=c.id_categoria
    WHERE m.estado_equipo = 'Disponible';

END;




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ============================================================
-- PUNTO 1 — HERENCIA OOP: Maquinaria → Neumáticos / Oruga
-- DÓNDE: después de la tabla Maquinaria_Maquinaria (Módulo 4)
-- QUÉ HACE: agrega columna TipoMaquinaria a la tabla
--           existente y crea las dos subtablas hijas
-- TABLAS AFECTADAS: Maquinaria_Maquinaria (ALTER),
--                   Maquinaria_Neumaticos (NUEVA),
--                   Maquinaria_Oruga (NUEVA)
-- ============================================================

-- Paso 1A: agregar columna TipoMaquinaria a la tabla existente
-- (ya tienes 20 máquinas insertadas, por eso DEFAULT 'Neumaticos')
ALTER TABLE Maquinaria_Maquinaria
    ADD tipo_maquinaria VARCHAR(12) NOT NULL
        CONSTRAINT DF_Maq_Tipo DEFAULT 'Neumaticos',
        CONSTRAINT CK_Maq_Tipo CHECK (tipo_maquinaria IN ('Neumaticos','Oruga'));
GO


-- Paso 1B: actualizar las máquinas de oruga que ya existen
-- Bulldozer Komatsu D85 (id 3003) y CAT 745C (3016) son de oruga
-- Revisa tus datos y ajusta los IDs según corresponda
UPDATE Maquinaria_Maquinaria
SET tipo_maquinaria = 'Oruga'
WHERE id_maquinaria IN (3003, 3016);
-- Agrega aquí más IDs si tienes más máquinas de oruga
GO

-- Paso 1C: subtabla para máquinas de neumáticos
-- MISMO id_maquinaria que la tabla base (herencia tabla-por-tipo)
CREATE TABLE Maquinaria_MaquinariaNeumaticos (
    id_maquinaria           INT          NOT NULL,
    cantidad_neumaticos     TINYINT      NOT NULL DEFAULT 4,
    medida_neumatico        VARCHAR(30)  NOT NULL DEFAULT 'Sin datos',
    tipo_neumatico          VARCHAR(50)  NOT NULL DEFAULT 'Sin datos',
    marca_neumatico         VARCHAR(50)  NOT NULL DEFAULT 'Sin datos',
    fecha_ultimo_cambio     DATE             NULL,
    horas_ultimo_cambio     DECIMAL(10,2)    NULL,
    presion_recomendada_psi SMALLINT         NULL,
    CONSTRAINT PK_MaqNeu    PRIMARY KEY (id_maquinaria),
    CONSTRAINT FK_MaqNeu_Maquinaria
        FOREIGN KEY (id_maquinaria)
        REFERENCES Maquinaria_Maquinaria(id_maquinaria)
        ON DELETE CASCADE
);
GO

-- Paso 1D: subtabla para máquinas de oruga
CREATE TABLE Maquinaria_MaquinariaOruga (
    id_maquinaria           INT          NOT NULL,
    tipo_oruga              VARCHAR(30)  NOT NULL DEFAULT 'Acero',
    ancho_oruga_pulgadas    DECIMAL(6,2)     NULL,
    longitud_oruga_m        DECIMAL(6,2)     NULL,
    numero_zapatas          SMALLINT         NULL,
    tension_recomendada     VARCHAR(40)  NOT NULL DEFAULT 'Sin datos',
    fecha_ultima_revision   DATE             NULL,
    horas_ultima_revision   DECIMAL(10,2)    NULL,
    estado_oruga            VARCHAR(20)  NOT NULL DEFAULT 'Bueno'
        CONSTRAINT CK_EstadoOruga CHECK (estado_oruga IN
            ('Bueno','Regular','Desgastado','Necesita cambio')),
    CONSTRAINT PK_MaqOru    PRIMARY KEY (id_maquinaria),
    CONSTRAINT FK_MaqOru_Maquinaria
        FOREIGN KEY (id_maquinaria)
        REFERENCES Maquinaria_Maquinaria(id_maquinaria)
        ON DELETE CASCADE
);
GO

-- Paso 1E: poblar las subtablas con las máquinas existentes
-- Neumáticos — todas excepto las de oruga (3003, 3016)
INSERT INTO Maquinaria_MaquinariaNeumaticos (id_maquinaria, cantidad_neumaticos)
SELECT id_maquinaria, 4
FROM Maquinaria_Maquinaria
WHERE tipo_maquinaria = 'Neumaticos';
GO

-- Oruga — solo las marcadas como oruga
INSERT INTO Maquinaria_MaquinariaOruga (id_maquinaria, tipo_oruga)
SELECT id_maquinaria, 'Acero'
FROM Maquinaria_Maquinaria
WHERE tipo_maquinaria = 'Oruga';
GO


-- ID 3000
UPDATE Maquinaria_MaquinariaNeumaticos
SET tipo_neumatico = 'Radial OTR', marca_neumatico = 'Michelin', fecha_ultimo_cambio = '2025-06-15', horas_ultimo_cambio = 1250.50, presion_recomendada_psi = 45
WHERE id_maquinaria = 3000;

-- ID 3001
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '12.00R24', tipo_neumatico = 'Tracción Heavy Duty', marca_neumatico = 'Goodyear', fecha_ultimo_cambio = '2025-08-22', horas_ultimo_cambio = 840.00, presion_recomendada_psi = 115
WHERE id_maquinaria = 3001;

-- ID 3002
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '12.00R24', tipo_neumatico = 'Direccional', marca_neumatico = 'Goodyear', fecha_ultimo_cambio = '2025-09-01', horas_ultimo_cambio = 910.20, presion_recomendada_psi = 120
WHERE id_maquinaria = 3002;

-- ID 3004
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '23.5R25', tipo_neumatico = 'Tubeless Earthmover', marca_neumatico = 'Bridgestone', fecha_ultimo_cambio = '2024-11-10', horas_ultimo_cambio = 3100.25, presion_recomendada_psi = 65
WHERE id_maquinaria = 3004;

-- ID 3005
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '23.5R25', tipo_neumatico = 'Tubeless Earthmover', marca_neumatico = 'Bridgestone', fecha_ultimo_cambio = '2025-01-15', horas_ultimo_cambio = 1500.00, presion_recomendada_psi = 65
WHERE id_maquinaria = 3005;

-- ID 3006
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '26.5R25', tipo_neumatico = 'Radial Roca L5', marca_neumatico = 'Michelin', fecha_ultimo_cambio = '2025-03-20', horas_ultimo_cambio = 2150.40, presion_recomendada_psi = 70
WHERE id_maquinaria = 3006;

-- ID 3007
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '20.5R25', tipo_neumatico = 'Direccional OTR', marca_neumatico = 'Continental', fecha_ultimo_cambio = '2025-02-18', horas_ultimo_cambio = 1800.00, presion_recomendada_psi = 55
WHERE id_maquinaria = 3007;

-- ID 3008
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '18.00R33', tipo_neumatico = 'E4 Volquete Minero', marca_neumatico = 'Yokohama', fecha_ultimo_cambio = '2024-08-05', horas_ultimo_cambio = 4200.15, presion_recomendada_psi = 105
WHERE id_maquinaria = 3008;

-- ID 3009
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '18.00R33', tipo_neumatico = 'E4 Volquete Minero', marca_neumatico = 'Yokohama', fecha_ultimo_cambio = '2024-09-12', horas_ultimo_cambio = 3950.00, presion_recomendada_psi = 105
WHERE id_maquinaria = 3009;

-- ID 3010
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '14.00R24', tipo_neumatico = 'Motoniveladora G2', marca_neumatico = 'Firestone', fecha_ultimo_cambio = '2025-05-14', horas_ultimo_cambio = 1100.30, presion_recomendada_psi = 40
WHERE id_maquinaria = 3010;

-- ID 3011
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '14.00R24', tipo_neumatico = 'Motoniveladora G2', marca_neumatico = 'Firestone', fecha_ultimo_cambio = '2025-07-19', horas_ultimo_cambio = 750.60, presion_recomendada_psi = 40
WHERE id_maquinaria = 3011;

-- ID 3012
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '16.9-24', tipo_neumatico = 'Industrial R4', marca_neumatico = 'BKT', fecha_ultimo_cambio = '2025-10-02', horas_ultimo_cambio = 520.00, presion_recomendada_psi = 35
WHERE id_maquinaria = 3012;

-- ID 3013
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '19.5L-24', tipo_neumatico = 'Retroexcavadora Trasero', marca_neumatico = 'Michelin', fecha_ultimo_cambio = '2025-11-20', horas_ultimo_cambio = 310.45, presion_recomendada_psi = 38
WHERE id_maquinaria = 3013;

-- ID 3014
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '11R22.5', tipo_neumatico = 'Mixto Obra', marca_neumatico = 'Pirelli', fecha_ultimo_cambio = '2026-01-05', horas_ultimo_cambio = 150.00, presion_recomendada_psi = 110
WHERE id_maquinaria = 3014;

-- ID 3015
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '11R22.5', tipo_neumatico = 'Mixto Obra', marca_neumatico = 'Pirelli', fecha_ultimo_cambio = '2026-01-12', horas_ultimo_cambio = 90.00, presion_recomendada_psi = 110
WHERE id_maquinaria = 3015;

-- ID 3017
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '29.5R25', tipo_neumatico = 'Dumper Articulado', marca_neumatico = 'Goodyear', fecha_ultimo_cambio = '2024-05-17', horas_ultimo_cambio = 4800.20, presion_recomendada_psi = 75
WHERE id_maquinaria = 3017;

-- ID 3018
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '29.5R25', tipo_neumatico = 'Dumper Articulado', marca_neumatico = 'Goodyear', fecha_ultimo_cambio = '2024-06-01', horas_ultimo_cambio = 4610.00, presion_recomendada_psi = 75
WHERE id_maquinaria = 3018;

-- ID 3019
UPDATE Maquinaria_MaquinariaNeumaticos
SET medida_neumatico = '10.00-20', tipo_neumatico = 'Excavadora Neumáticos', marca_neumatico = 'Camso', fecha_ultimo_cambio = '2025-04-24', horas_ultimo_cambio = 1340.70, presion_recomendada_psi = 95
WHERE id_maquinaria = 3019;
GO


-- ID 3003 (Bulldozer Komatsu D85)
UPDATE Maquinaria_MaquinariaOruga
SET tipo_oruga = 'Acero Alta Resistencia',
    ancho_oruga_pulgadas = 24.00,
    longitud_oruga_m = 3.25,
    numero_zapatas = 41,
    tension_recomendada = '25-30 mm de flecha',
    fecha_ultima_revision = '2026-01-10',
    horas_ultima_revision = 4500.80,
    estado_oruga = 'Bueno'
WHERE id_maquinaria = 3003;

-- ID 3016 (CAT 745C o Excavadora pesada de cadenas)
UPDATE Maquinaria_MaquinariaOruga
SET tipo_oruga = 'Acero Reforzado Manganeso',
    ancho_oruga_pulgadas = 32.00,
    longitud_oruga_m = 4.10,
    numero_zapatas = 49,
    tension_recomendada = '30-45 mm de flecha',
    fecha_ultima_revision = '2025-11-05',
    horas_ultima_revision = 2800.10,
    estado_oruga = 'Regular'
WHERE id_maquinaria = 3016;
GO


select * from Maquinaria_Maquinaria
select * from  Maquinaria_MaquinariaNeumaticos
select * from Maquinaria_MaquinariaOruga

-- ============================================================
-- PUNTO 2 — FLETES POR DEPARTAMENTO (22 de Guatemala)
-- DÓNDE: después del Módulo 1 Geografía
-- QUÉ HACE: crea tabla TarifaFlete vinculada a
--           Geografia_DepartamentoGeo que ya existe
-- TABLAS AFECTADAS: TarifaFlete (NUEVA)
-- NOTA: tu tabla Geografia_DepartamentoGeo solo tiene
--       10 departamentos (IDs 100-109). Los fletes se
--       agregan para esos 10 + puedes ampliar la tabla
--       geo si necesitas los 22 completos
-- ============================================================

CREATE TABLE Operaciones_TarifaFlete (
    id_tarifa_flete     INT           NOT NULL IDENTITY(1,1),
    id_depto_geo        INT           NOT NULL,
    tipo_maquinaria     VARCHAR(12)   NOT NULL DEFAULT 'Ambos'
        CONSTRAINT CK_Flete_tipo CHECK (tipo_maquinaria IN
            ('Neumaticos','Oruga','Ambos')),
    costo_flete_q       DECIMAL(10,2) NOT NULL,
    costo_flete_doble_q DECIMAL(10,2) NOT NULL,  -- ida y vuelta
    incluye_cama_baja   CHAR(2)       NOT NULL DEFAULT 'SI'
        CONSTRAINT CK_Flete_cama CHECK (incluye_cama_baja IN ('SI','NO')),
    nota_adicional      VARCHAR(200)  NOT NULL DEFAULT 'Sin observaciones',
    vigente             CHAR(2)       NOT NULL DEFAULT 'SI'
        CONSTRAINT CK_Flete_vigente CHECK (vigente IN ('SI','NO')),
    CONSTRAINT PK_TarifaFlete   PRIMARY KEY (id_tarifa_flete),
    CONSTRAINT FK_Flete_Depto   FOREIGN KEY (id_depto_geo)
        REFERENCES Geografia_DepartamentoGeo(id_depto_geo)
);
GO

-- Tarifas para los departamentos que ya tienes en tu BD
-- (id_depto_geo 100-109 según tus INSERTs del Módulo 1)
-- Precios realistas en Quetzales para cama baja ~20 toneladas
INSERT INTO Operaciones_TarifaFlete
    (id_depto_geo, tipo_maquinaria, costo_flete_q, costo_flete_doble_q, nota_adicional)
VALUES
(100, 'Ambos', 1500.00,  2500.00, 'Guatemala capital y área metropolitana'),
(101, 'Ambos', 2800.00,  4500.00, 'Escuintla - ruta al Pacífico'),
(102, 'Ambos', 5500.00,  9000.00, 'Quetzaltenango - ruta serpentina'),
(103, 'Ambos', 2000.00,  3500.00, 'Sacatepéquez - La Antigua'),
(104, 'Ambos', 5000.00,  8000.00, 'Chiquimula - Nororiente'),
(105, 'Ambos', 8000.00, 13000.00, 'Izabal - Puerto Barrios, ruta larga'),
(106, 'Ambos', 6000.00, 10000.00, 'Alta Verapaz - Cobán, carretera estrecha'),
(107, 'Ambos', 6500.00, 10500.00, 'San Marcos - zona fronteriza'),
(108, 'Ambos', 5000.00,  8000.00, 'Petén - requiere permisos especiales'),
(109, 'Ambos', 4000.00,  6500.00, 'Jutiapa - Suroriente');
GO

-- ============================================================
-- Si quieres los 22 departamentos completos, primero inserta
-- los 12 que faltan en Geografia_DepartamentoGeo:
-- ============================================================
-- OPCIONAL — descomenta si necesitas los 22 completos:
select * from Geografia_DepartamentoGeo
SET IDENTITY_INSERT Geografia_DepartamentoGeo ON;
INSERT INTO Geografia_DepartamentoGeo
    (id_depto_geo, id_pais, nombre_depto, codigo_depto) VALUES
(110, 300, 'Chimaltenango',   'GT-CM'),
(111, 300, 'Santa Rosa',      'GT-SR'),
(112, 300, 'Sololá',          'GT-SO'),
(113, 300, 'Totonicapán',     'GT-TO'),
(114, 300, 'Suchitepéquez',   'GT-SU'),
(115, 300, 'Retalhuleu',      'GT-RE'),
(116, 300, 'Huehuetenango',   'GT-HU'),
(117, 300, 'Quiché',          'GT-QC'),
(118, 300, 'Baja Verapaz',    'GT-BV'),
(119, 300, 'El Progreso',     'GT-EP'),
(120, 300, 'Zacapa',          'GT-ZA'),
(121, 300, 'Jalapa',          'GT-JA');
SET IDENTITY_INSERT Geografia_DepartamentoGeo OFF;
GO

UPDATE Geografia_DepartamentoGeo
SET id_pais = 300
WHERE id_depto_geo IN (108, 109);

-- Verificar que quedó bien
SELECT id_depto_geo, id_pais, nombre_depto
FROM Geografia_DepartamentoGeo
WHERE id_depto_geo IN (108, 109);
-- Y luego inserta sus tarifas en Operaciones_TarifaFlete
*/


-- ============================================================
-- PUNTO 3 — TARIFA DE RENTA POR HORA (realista)
-- DÓNDE: en el Módulo 7 Contratos, junto a Contratos_Tarifa
-- QUÉ HACE: agrega columna tarifa_por_hora a la tabla
--           Contratos_Tarifa ya existente
-- TABLAS AFECTADAS: Contratos_Tarifa (ALTER)
-- NOTA: ya tienes tarifa_diaria, semanal y mensual.
--       Simplemente dividimos la diaria entre 9 horas
--       promedio para tener la referencia por hora.
--       También agrega consumo combustible real (PDF 416F2)
-- ============================================================

ALTER TABLE Contratos_Tarifa
    ADD tarifa_por_hora        DECIMAL(10,2) NULL,
        horas_minimas_cobro    DECIMAL(5,2)  NOT NULL DEFAULT 4,
        recargo_nocturno_porc  DECIMAL(5,2)  NOT NULL DEFAULT 25.00,
        consumo_gal_hora       DECIMAL(5,2)  NOT NULL DEFAULT 2.30,
        costo_galon_diesel_q   DECIMAL(8,2)  NOT NULL DEFAULT 32.00;
GO

-- Calcular tarifa_por_hora automáticamente desde tarifa_diaria
-- (asumiendo 9 horas productivas por día — basado en PDF real)
UPDATE Contratos_Tarifa
SET tarifa_por_hora = ROUND(tarifa_diaria / 9.0, 2);
GO

-- Actualizar consumo real según tipo de maquinaria
-- Basado en PDF retroexcavadora 416F2: 2.0-2.7 gal/hora
UPDATE ct
SET ct.consumo_gal_hora =
    CASE mm.id_categoria
        WHEN 600 THEN 2.50  -- Excavadora grande
        WHEN 601 THEN 2.20  -- Cargador frontal
        WHEN 603 THEN 3.00  -- Bulldozer
        WHEN 604 THEN 1.80  -- Compactadora
        WHEN 605 THEN 2.30  -- Retroexcavadora (PDF real 416F2)
        WHEN 606 THEN 4.50  -- Grúa móvil grande
        WHEN 610 THEN 3.50  -- Camión volquete
        WHEN 611 THEN 3.00  -- Cisterna
        WHEN 614 THEN 1.20  -- Mini excavadora
        WHEN 617 THEN 3.80  -- Dumper articulado
        WHEN 619 THEN 2.80  -- Motoniveladora
        ELSE 2.30           -- Default general
    END
FROM Contratos_Tarifa ct
JOIN Maquinaria_ModeloMaquinaria mm ON ct.id_modelo = mm.id_modelo;
GO


-- ============================================================
-- PUNTO 4 — REGISTRO DE TRABAJO: CONTROL INGRESOS/EGRESOS
-- DÓNDE: módulo nuevo, después del Módulo 7 Contratos
-- QUÉ HACE: crea la tabla central de control financiero
--           por servicio/día de trabajo. Se vincula a
--           Maquinaria_Maquinaria, RRHH_Empleado,
--           Contratos_Cliente y Contratos_ContratoAlquiler
-- TABLAS AFECTADAS: RegistroTrabajo (NUEVA)
-- NOTA: las columnas HorasUtiles, TotalCobrado,
--       TotalEgresos, UtilidadNeta y MargenGanancia
--       son CALCULADAS — SQL Server las genera solas,
--       nunca las insertes manualmente
-- ============================================================

CREATE TABLE Operaciones_RegistroTrabajo (
    id_registro         INT           NOT NULL IDENTITY(1,1),
    id_maquinaria       INT           NOT NULL,
    id_empleado         INT           NOT NULL,  -- piloto/operador
    id_cliente          INT               NULL,
    id_contrato         INT               NULL,
    id_depto_geo        INT               NULL,

    -- Tiempo de trabajo
    fecha               DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    hora_inicial        TIME          NOT NULL,
    hora_final          TIME          NOT NULL,

    -- Horas útiles — calculada automáticamente
    horas_utiles AS (
        CAST(DATEDIFF(MINUTE, hora_inicial, hora_final) AS DECIMAL(6,2)) / 60
    ) PERSISTED,

    -- Cobro al cliente
    precio_por_hora     DECIMAL(10,2) NOT NULL
        CONSTRAINT CK_RT_precio CHECK (precio_por_hora > 0),

    -- Total cobrado — calculado automáticamente
    total_cobrado AS (
        CAST(DATEDIFF(MINUTE, hora_inicial, hora_final) AS DECIMAL(10,2))
        / 60 * precio_por_hora
    ) PERSISTED,

    -- Combustible (del horómetro real — como en el PDF)
    horometro_combustible   DECIMAL(10,2)    NULL,
    hora_combustible        TIME             NULL,
    galonaje_combustible    DECIMAL(8,2)     NULL,
    costo_combustible       DECIMAL(10,2) NOT NULL DEFAULT 0
        CONSTRAINT CK_RT_comb CHECK (costo_combustible >= 0),

    -- Promedio gal/hora — calculado automáticamente
    promedio_gal_hora AS (
        CASE
            WHEN galonaje_combustible IS NOT NULL
                 AND DATEDIFF(MINUTE, hora_inicial, hora_final) > 0
            THEN CAST(galonaje_combustible AS DECIMAL(10,4))
                 / (CAST(DATEDIFF(MINUTE, hora_inicial, hora_final)
                    AS DECIMAL(10,4)) / 60)
            ELSE NULL
        END
    ) PERSISTED,

    -- Mantenimiento y costos extras del día
    costo_mantenimiento     DECIMAL(10,2) NOT NULL DEFAULT 0
        CONSTRAINT CK_RT_mant CHECK (costo_mantenimiento >= 0),
    desc_mantenimiento      VARCHAR(500)  NOT NULL DEFAULT 'Sin mantenimiento',

    -- Pago al piloto/operador
    tipo_pago_piloto    VARCHAR(10)   NOT NULL DEFAULT 'Hora'
        CONSTRAINT CK_RT_tipopago CHECK (tipo_pago_piloto IN ('Hora','Comision')),
    tarifa_hora_piloto  DECIMAL(10,2)     NULL,
    porcentaje_comision DECIMAL(5,2)      NULL,
    pago_piloto         DECIMAL(10,2) NOT NULL DEFAULT 0
        CONSTRAINT CK_RT_pago CHECK (pago_piloto >= 0),

    -- Flete (si aplica traslado de maquinaria ese día)
    incluye_flete       CHAR(2)       NOT NULL DEFAULT 'NO'
        CONSTRAINT CK_RT_flete CHECK (incluye_flete IN ('SI','NO')),
    costo_flete         DECIMAL(10,2) NOT NULL DEFAULT 0,

    -- TOTALES CALCULADOS AUTOMÁTICAMENTE
    total_egresos AS (
        costo_combustible + costo_mantenimiento + pago_piloto + costo_flete
    ) PERSISTED,

    utilidad_neta AS (
        (CAST(DATEDIFF(MINUTE, hora_inicial, hora_final) AS DECIMAL(10,2))
         / 60 * precio_por_hora)
        - (costo_combustible + costo_mantenimiento + pago_piloto + costo_flete)
    ) PERSISTED,

    margen_ganancia AS (
        CASE
            WHEN (CAST(DATEDIFF(MINUTE, hora_inicial, hora_final)
                  AS DECIMAL(10,2)) / 60 * precio_por_hora) > 0
            THEN (
                (CAST(DATEDIFF(MINUTE, hora_inicial, hora_final)
                 AS DECIMAL(10,2)) / 60 * precio_por_hora)
                - (costo_combustible + costo_mantenimiento + pago_piloto + costo_flete)
            ) / (CAST(DATEDIFF(MINUTE, hora_inicial, hora_final)
                 AS DECIMAL(10,2)) / 60 * precio_por_hora) * 100
            ELSE NULL
        END
    ) PERSISTED,

    -- Extra
    ubicacion           VARCHAR(200)  NOT NULL DEFAULT 'Sin especificar',
    descripcion         VARCHAR(500)  NOT NULL DEFAULT 'Sin descripcion',
    cancelado           CHAR(2)       NOT NULL DEFAULT 'NO'
        CONSTRAINT CK_RT_cancel CHECK (cancelado IN ('SI','NO')),
    fecha_registro      DATETIME      NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_RegistroTrabajo   PRIMARY KEY (id_registro),
    CONSTRAINT FK_RT_Maquinaria     FOREIGN KEY (id_maquinaria)
        REFERENCES Maquinaria_Maquinaria(id_maquinaria),
    CONSTRAINT FK_RT_Empleado       FOREIGN KEY (id_empleado)
        REFERENCES RRHH_Empleado(id_empleado),
    CONSTRAINT FK_RT_Cliente        FOREIGN KEY (id_cliente)
        REFERENCES Contratos_Cliente(id_cliente),
    CONSTRAINT FK_RT_Contrato       FOREIGN KEY (id_contrato)
        REFERENCES Contratos_ContratoAlquiler(id_contrato),
    CONSTRAINT FK_RT_Depto          FOREIGN KEY (id_depto_geo)
        REFERENCES Geografia_DepartamentoGeo(id_depto_geo)
);
GO

-- Trigger: calcula pago_piloto automáticamente al insertar
-- (no tienes que calcularlo tú — el trigger lo hace)
CREATE OR ALTER TRIGGER trg_RT_CalcularPagoPiloto
ON Operaciones_RegistroTrabajo
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Validación: horas > 0 si hay cobro
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE DATEDIFF(MINUTE, hora_inicial, hora_final) <= 0
    )
    BEGIN
        RAISERROR('Error: hora_final debe ser mayor a hora_inicial.', 16, 1);
        RETURN;
    END;

    INSERT INTO Operaciones_RegistroTrabajo (
        id_maquinaria, id_empleado, id_cliente, id_contrato, id_depto_geo,
        fecha, hora_inicial, hora_final, precio_por_hora,
        horometro_combustible, hora_combustible, galonaje_combustible, costo_combustible,
        costo_mantenimiento, desc_mantenimiento,
        tipo_pago_piloto, tarifa_hora_piloto, porcentaje_comision, pago_piloto,
        incluye_flete, costo_flete,
        ubicacion, descripcion, cancelado
    )
    SELECT
        i.id_maquinaria, i.id_empleado, i.id_cliente, i.id_contrato, i.id_depto_geo,
        i.fecha, i.hora_inicial, i.hora_final, i.precio_por_hora,
        i.horometro_combustible, i.hora_combustible, i.galonaje_combustible,
        i.costo_combustible,
        i.costo_mantenimiento, i.desc_mantenimiento,
        i.tipo_pago_piloto, i.tarifa_hora_piloto, i.porcentaje_comision,
        -- Calcular pago piloto según tipo
        pago_piloto = CASE
            WHEN i.tipo_pago_piloto = 'Hora' THEN
                ISNULL(i.tarifa_hora_piloto, 0) *
                (CAST(DATEDIFF(MINUTE, i.hora_inicial, i.hora_final)
                 AS DECIMAL(10,2)) / 60)
            WHEN i.tipo_pago_piloto = 'Comision' THEN
                (CAST(DATEDIFF(MINUTE, i.hora_inicial, i.hora_final)
                 AS DECIMAL(10,2)) / 60 * i.precio_por_hora)
                * ISNULL(i.porcentaje_comision, 0) / 100
            ELSE 0
        END,
        i.incluye_flete, i.costo_flete,
        i.ubicacion, i.descripcion, ISNULL(i.cancelado, 'NO')
    FROM inserted i;
END;
GO

-- Vistas de reporte para RegistroTrabajo
CREATE OR ALTER VIEW vw_GananciaPorDia AS
SELECT
    fecha,
    COUNT(*)              AS total_trabajos,
    SUM(horas_utiles)     AS total_horas,
    SUM(total_cobrado)    AS ingreso_total,
    SUM(total_egresos)    AS egresos_total,
    SUM(utilidad_neta)    AS utilidad_total,
    AVG(margen_ganancia)  AS margen_promedio_porc
FROM Operaciones_RegistroTrabajo
GROUP BY fecha;
GO

CREATE OR ALTER VIEW vw_GananciaPorCliente AS
SELECT
    c.razon_social        AS cliente,
    COUNT(*)              AS servicios,
    SUM(rt.total_cobrado) AS ingreso,
    SUM(rt.utilidad_neta) AS utilidad,
    AVG(rt.margen_ganancia) AS margen_porc
FROM Operaciones_RegistroTrabajo rt
JOIN Contratos_Cliente c ON rt.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.razon_social;
GO

CREATE OR ALTER VIEW vw_ConsumoCombustible AS
SELECT
    m.numero_serie        AS maquinaria,
    COUNT(*)              AS dias_registrados,
    SUM(rt.galonaje_combustible) AS total_galones,
    SUM(rt.costo_combustible)    AS costo_total,
    AVG(rt.promedio_gal_hora)    AS promedio_gal_hora
FROM Operaciones_RegistroTrabajo rt
JOIN Maquinaria_Maquinaria m ON rt.id_maquinaria = m.id_maquinaria
WHERE rt.galonaje_combustible IS NOT NULL
GROUP BY m.id_maquinaria, m.numero_serie;
GO

-- ============================================================
-- DATOS: Operaciones_RegistroTrabajo
-- Basado en datos reales del PDF retroexcavadora 416F2 2021
-- Empleados piloto: 5005=Jose Ruiz, 5006=Pedro Orozco,
--                   5007=Luis Castillo, 5015=Fernando Aju,
--                   5016=Hector Tahay
-- Maquinaria: 3000=CAT320, 3001=Komatsu, 3006=JD310L
--             3009=JCB3CX, 3014=KomPC55MR
-- Clientes: 7000=Constructora, 7001=Grupo Vial,
--           7002=Residenciales, 7003=Inversiones
-- ============================================================
USE GestionMaquinaria;
GO

-- NOTA: Las columnas calculadas (horas_utiles, total_cobrado,
-- promedio_gal_hora, total_egresos, utilidad_neta,
-- margen_ganancia) NO se insertan — SQL Server las calcula solo.
-- El trigger trg_CalcularPagoPiloto calcula pago_piloto.

-- 1. Apagar el Trigger y activar identidad
DISABLE TRIGGER trg_RT_CalcularPagoPiloto ON Operaciones_RegistroTrabajo;
SET IDENTITY_INSERT Operaciones_RegistroTrabajo ON;

-- 2. Tu INSERT original (con el Registro 2 corregido en las horas)
INSERT INTO Operaciones_RegistroTrabajo (id_registro, id_maquinaria, ...) 
VALUES (1, 3000, ...);

-- 3. Volver a encender todo
SET IDENTITY_INSERT Operaciones_RegistroTrabajo OFF;
ENABLE TRIGGER trg_RT_CalcularPagoPiloto ON Operaciones_RegistroTrabajo;

SET IDENTITY_INSERT Operaciones_RegistroTrabajo ON;

INSERT INTO Operaciones_RegistroTrabajo (
    id_registro,
    id_maquinaria, id_empleado, id_cliente, id_contrato, id_depto_geo,
    fecha, hora_inicial, hora_final,
    precio_por_hora,
    horometro_combustible, hora_combustible, galonaje_combustible, costo_combustible,
    costo_mantenimiento, desc_mantenimiento,
    tipo_pago_piloto, tarifa_hora_piloto, porcentaje_comision, pago_piloto,
    incluye_flete, costo_flete,
    ubicacion, descripcion, cancelado
) VALUES

-- ── SEMANA 1: CAT 320 (3000) piloteado por Jose Ruiz (5005) ──────────────
-- Registro 1: 29/05 - Cantera Vado Hondo, 9 horas, Q275/h (del PDF real)
(1, 3000,5005,7000,11000,100,
 '2024-05-29','06:00','15:00', 275.00,
 6.00,'11:30',35.00,830.00,
 285.00,'Engrasadora, 2 botes grasa, 2 wipe',
 'Hora',250.00,NULL,2250.00,
 'NO',0,'Cantera Vado Hondo','Corte y carga de material','NO'),

-- Cambia la sección del Registro 2 por esta:
(2, 3000,5005,7000,11000,100,
 '2024-05-31','07:00','16:42', 300.00, -- Ajustado a horario diurno (9.7 horas)
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2425.00,
 'NO',0,'Famaconsa','Corte y carga en Famaconsa','NO'),

-- Registro 3: 01/06 - Famaconsa, 9.6 horas, Q300/h
(3, 3000,5005,7000,11000,100,
 '2024-06-01','06:00','15:36', 300.00,
 25.00,'11:00',NULL,600.00,
 70.00,'2 tubos de grasa',
 'Hora',250.00,NULL,2400.00,
 'NO',0,'Famaconsa','Corte y carga en Famaconsa','NO'),

-- Registro 4: 02/06 - Famaconsa, 8.6 horas, Q300/h
(4, 3000,5005,7000,11000,100,
 '2024-06-02','06:00','14:36', 300.00,
 35.50,'12:00',NULL,875.00,
 70.00,'2 tubos de grasa',
 'Hora',250.00,NULL,2150.00,
 'NO',0,'Famaconsa','Corte y carga en Famaconsa','NO'),

-- Registro 5: 03/06 - Cantera Vado Hondo, 10 horas, Q275/h
(5, 3000,5005,7000,11000,100,
 '2024-06-03','06:00','16:00', 275.00,
 44.60,'14:30',NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2500.00,
 'NO',0,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- Registro 6: 04/06 - Cantera Vado Hondo, 10 horas, Q275/h
(6, 3000,5005,7000,11000,100,
 '2024-06-04','06:00','16:00', 275.00,
 54.60,'11:30',35.00,830.00,
 283.00,'1 tubo grasa + bomba para fulear + 1 wipe',
 'Hora',250.00,NULL,2500.00,
 'NO',0,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- Registro 7: 05/06 - Cantera Vado Hondo, 10 horas, Q275/h
(7, 3000,5005,7000,11000,100,
 '2024-06-05','06:00','16:00', 275.00,
 64.60,'00:00',23.00,475.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2500.00,
 'SI',800.00,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- Registro 8: 06/06 - Cantera Vado Hondo, 8 horas, Q275/h
(8, 3000,5005,7000,11000,100,
 '2024-06-06','06:00','14:00', 275.00,
 NULL,NULL,NULL,300.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2000.00,
 'NO',0,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- Registro 9: 07/06 - Cantera Vado Hondo, 10 horas, Q275/h
(9, 3000,5005,7000,11000,100,
 '2024-06-07','06:00','16:00', 275.00,
 82.60,'11:30',35.00,830.00,
 71.00,'1 tubo de grasa + 3m manguera',
 'Hora',250.00,NULL,2500.00,
 'NO',0,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- Registro 10: 08/06 - Cantera Vado Hondo, 8 horas, Q275/h
(10, 3000,5005,7000,11000,100,
 '2024-06-08','06:00','14:00', 275.00,
 92.60,'19:00',26.00,615.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2000.00,
 'NO',0,'Cantera Vado Hondo','Trabajo en cantera','NO'),

-- ── SEMANA 2: JCB 3CX (3009) piloteado por Pedro Orozco (5006) ───────────
-- Registro 11: Residencial Los Pinos, 8 horas, Q275/h
(11, 3009,5006,7002,11002,100,
 '2024-06-10','07:00','15:00', 275.00,
 185.00,'12:00',18.00,450.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,1760.00,
 'NO',0,'Residencial Los Pinos','Excavacion para cimientos','NO'),

-- Registro 12: Residencial Los Pinos, 9 horas, Q275/h
(12, 3009,5006,7002,11002,100,
 '2024-06-11','07:00','16:00', 275.00,
 NULL,NULL,NULL,0.00,
 150.00,'Cambio de filtro hidraulico',
 'Hora',220.00,NULL,1980.00,
 'NO',0,'Residencial Los Pinos','Excavacion para cimientos','NO'),

-- Registro 13: Residencial Los Pinos, 7 horas, Q275/h
(13, 3009,5006,7002,11002,100,
 '2024-06-12','08:00','15:00', 275.00,
 190.00,'13:00',20.00,480.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,1540.00,
 'NO',0,'Residencial Los Pinos','Nivelacion de terreno','NO'),

-- Registro 14: Edificio Zona 10, 8 horas, Q300/h (precio especial zona urbana)
(14, 3009,5006,7000,11000,100,
 '2024-06-14','06:00','14:00', 300.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,1760.00,
 'SI',800.00,'Edificio Zona 10','Excavacion sotano edificio','NO'),

-- Registro 15: Edificio Zona 10, 7.8 horas, Q275/h
(15, 3009,5006,7000,11000,100,
 '2024-06-17','06:00','13:48', 275.00,
 200.00,'12:00',22.00,530.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,1716.00,
 'NO',0,'Edificio Zona 10','Excavacion sotano edificio','NO'),

-- ── SEMANA 3: John Deere 310L (3006) piloteado por Luis Castillo (5007) ──
-- Registro 16: Corrales el Molino, 8 horas, Q300/h
(16, 3006,5007,7003,11003,100,
 '2024-07-01','07:00','15:00', 300.00,
 780.00,'12:00',33.56,780.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,240.00,
 'NO',0,'Corrales el Molino','Nivelacion y compactacion','NO'),

-- Registro 17: Corrales el Molino, 7 horas, Q300/h
(17, 3006,5007,7003,11003,100,
 '2024-07-02','07:00','14:00', 300.00,
 NULL,NULL,NULL,0.00,
 200.00,'Ajuste de retropalin',
 'Comision',NULL,10.00,210.00,
 'NO',0,'Corrales el Molino','Nivelacion de acceso','NO'),

-- Registro 18: Corrales el Molino, 9 horas, Q300/h
(18, 3006,5007,7003,11003,100,
 '2024-07-03','06:00','15:00', 300.00,
 795.00,'11:00',29.08,670.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,270.00,
 'SI',1200.00,'Corrales el Molino','Movimiento de tierra','NO'),

-- Registro 19: Corrales el Molino, 8.7 horas, Q300/h
(19, 3006,5007,7003,11003,100,
 '2024-07-05','07:00','15:42', 300.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,261.00,
 'NO',0,'Corrales el Molino','Excavacion de zanjones','NO'),

-- Registro 20: Brisas de San Jose, 5 horas, Q300/h (servicio especial)
(20, 3006,5007,7001,11001,100,
 '2024-07-06','07:00','12:00', 300.00,
 800.00,'10:00',22.93,550.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,150.00,
 'NO',0,'Brisas de San Jose','Nivelacion para vialidad','NO'),

-- ── SEMANA 4: Komatsu PC55 Mini (3014) por Fernando Aju (5015) ───────────
-- Registro 21: Hospital Nacional, 8 horas, Q275/h
(21, 3014,5015,7005,11005,100,
 '2024-07-10','07:00','15:00', 275.00,
 220.00,'12:00',15.94,420.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1600.00,
 'NO',0,'Hospital Nacional','Excavacion para ampliacion','NO'),

-- Registro 22: Hospital Nacional, 9 horas, Q275/h
(22, 3014,5015,7005,11005,100,
 '2024-07-11','07:00','16:00', 275.00,
 NULL,NULL,NULL,0.00,
 120.00,'Grasa para articulaciones',
 'Hora',200.00,NULL,1800.00,
 'NO',0,'Hospital Nacional','Excavacion sotano ampliacion','NO'),

-- Registro 23: Hospital Nacional, 7 horas, Q275/h
(23, 3014,5015,7005,11005,100,
 '2024-07-12','08:00','15:00', 275.00,
 225.00,'13:00',12.53,330.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1400.00,
 'NO',0,'Hospital Nacional','Limpieza de excavacion','NO'),

-- Registro 24: Hospital Nacional, 6 horas, Q300/h (precio premium urgente)
(24, 3014,5015,7005,11005,100,
 '2024-07-13','06:00','12:00', 300.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1200.00,
 'SI',900.00,'Hospital Nacional','Trabajo urgente ampliacion','NO'),

-- Registro 25: Proyecto Carretera CA-9, 8 horas, Q300/h
(25, 3014,5015,7001,11001,101,
 '2024-07-15','06:00','14:00', 300.00,
 228.00,'11:00',21.00,500.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1600.00,
 'NO',0,'Carretera CA-9 Km 45','Excavacion cunetas','NO'),

-- ── SEMANA 5: CAT 320 (3000) por Hector Tahay (5016) ────────────────────
-- Registro 26: Cantera Vado Hondo, 10 horas, Q275/h
(26, 3000,5016,7000,11000,100,
 '2024-08-01','06:00','16:00', 275.00,
 402.70,'16:00',14.17,335.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,2000.00,
 'NO',0,'Cantera Vado Hondo','Corte y carga material','NO'),

-- Registro 27: Cantera Vado Hondo, 8 horas, Q275/h
(27, 3000,5016,7000,11000,100,
 '2024-08-02','06:00','14:00', 275.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1600.00,
 'NO',0,'Cantera Vado Hondo','Corte y carga material','NO'),

-- Registro 28: Cantera Vado Hondo, 9 horas, Q275/h
(28, 3000,5016,7000,11000,100,
 '2024-08-05','06:00','15:00', 275.00,
 409.40,'10:00',29.00,700.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1800.00,
 'NO',0,'Cantera Vado Hondo','Extraccion material','NO'),

-- Registro 29: Cantera Vado Hondo, 7 horas, Q275/h (dia corto)
(29, 3000,5016,7000,11000,100,
 '2024-08-06','07:00','14:00', 275.00,
 419.90,'11:00',NULL,605.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1400.00,
 'NO',0,'Cantera Vado Hondo','Corte y carga material','NO'),

-- Registro 30: Cantera Vado Hondo, 4.5 horas, Q275/h (medio dia)
(30, 3000,5016,7000,11000,100,
 '2024-08-07','07:00','11:30', 275.00,
 422.20,'09:00',32.50,796.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,900.00,
 'NO',0,'Cantera Vado Hondo','Limpieza de frente','NO'),

-- ── SEMANA 6: Komatsu PC210 (3001) por Jose Ruiz (5005) ──────────────────
-- Registro 31: Ampliacion Carretera CA-9, 8 horas, Q300/h
(31, 3001,5005,7001,11001,101,
 '2024-08-15','06:00','14:00', 300.00,
 2100.00,'10:00',29.00,700.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2000.00,
 'NO',0,'Carretera CA-9','Movimiento de tierra vial','NO'),

-- Registro 32: Ampliacion Carretera CA-9, 8.2 horas, Q275/h
(32, 3001,5005,7001,11001,101,
 '2024-08-19','06:00','14:12', 275.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2050.00,
 'NO',0,'Carretera CA-9','Corte de talud','NO'),

-- Registro 33: Ampliacion Carretera CA-9, 8.3 horas, Q275/h
(33, 3001,5005,7001,11001,101,
 '2024-08-20','06:00','14:18', 275.00,
 2115.00,'10:30',35.00,720.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,2075.00,
 'SI',1200.00,'Carretera CA-9','Excavacion de cunetas','NO'),

-- Registro 34: Ampliacion Carretera CA-9, 7.1 horas, Q275/h
(34, 3001,5005,7001,11001,101,
 '2024-08-23','07:00','14:06', 275.00,
 NULL,NULL,NULL,0.00,
 400.00,'Reparacion de manguera pata',
 'Hora',250.00,NULL,1775.00,
 'NO',0,'Carretera CA-9','Compactacion de subbase','NO'),

-- Registro 35: Ampliacion Carretera CA-9, 6.1 horas, Q275/h
(35, 3001,5005,7001,11001,101,
 '2024-08-25','07:00','13:06', 275.00,
 2120.00,'09:30',30.00,725.00,
 0.00,'Sin mantenimiento',
 'Hora',250.00,NULL,1525.00,
 'NO',0,'Carretera CA-9','Relleno y compactacion','NO'),

-- ── SEMANA 7: JD 310L (3006) por Luis Castillo (5007) ────────────────────
-- Registro 36: Parque Industrial Norte, 8 horas, Q300/h
(36, 3006,5007,7009,11009,100,
 '2024-10-15','06:00','14:00', 300.00,
 NULL,NULL,NULL,0.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,240.00,
 'NO',0,'Parque Industrial Norte','Excavacion de cimientos','NO'),

-- Registro 37: Parque Industrial Norte, 9.3 horas, Q300/h
(37, 3006,5007,7009,11009,100,
 '2024-10-16','06:00','15:18', 300.00,
 800.00,'16:00',30.00,716.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,279.00,
 'NO',0,'Parque Industrial Norte','Movimiento de tierra','NO'),

-- Registro 38: Parque Industrial Norte, 7.3 horas, Q275/h
(38, 3006,5007,7009,11009,100,
 '2024-10-17','07:00','14:18', 275.00,
 NULL,NULL,NULL,0.00,
 1675.00,'5 dientes cucharon trasero y pasadores',
 'Comision',NULL,10.00,200.75,
 'NO',0,'Parque Industrial Norte','Excavacion de zanjones','NO'),

-- Registro 39: Parque Industrial Norte, 9.4 horas, Q300/h
(39, 3006,5007,7009,11009,100,
 '2024-10-19','06:00','15:24', 300.00,
 813.00,'07:00',30.00,720.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,10.00,282.00,
 'NO',0,'Parque Industrial Norte','Movimiento de tierra','NO'),

-- Registro 40: Parque Industrial Norte, 7.4 horas, Q275/h
(40, 3006,5007,7009,11009,100,
 '2024-10-22','07:00','14:24', 275.00,
 NULL,NULL,NULL,0.00,
 765.00,'1 cubeta de hidraulico Caterpillar',
 'Comision',NULL,10.00,203.50,
 'NO',0,'Parque Industrial Norte','Compactacion de plataforma','NO'),

-- ── SEMANA 8: Registros de comisión vs hora para comparar ────────────────
-- Registro 41: CAT 320 por Jose Ruiz, pago por comision (15%)
(41, 3000,5005,7007,11007,105,
 '2024-11-01','06:00','14:00', 300.00,
 920.00,'12:00',33.00,800.00,
 0.00,'Sin mantenimiento',
 'Comision',NULL,15.00,360.00,
 'SI',9500.00,'Puente Vehicular CA-14','Excavacion pilotes de puente','NO'),

-- Registro 42: CAT 320 por Jose Ruiz, dia de 10 horas Q300
(42, 3000,5005,7007,11007,105,
 '2024-11-02','06:00','16:00', 300.00,
 NULL,NULL,NULL,0.00,
 200.00,'Ajuste de cuchara',
 'Comision',NULL,15.00,450.00,
 'NO',0,'Puente Vehicular CA-14','Excavacion de estribos','NO'),

-- Registro 43: JCB 3CX por Pedro Orozco en Complejo Deportivo
(43, 3009,5006,7008,11008,102,
 '2024-11-05','07:00','16:00', 275.00,
 205.00,'12:00',24.00,580.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,1980.00,
 'NO',0,'Complejo Deportivo Municipal','Excavacion para piscina olimpica','NO'),

-- Registro 44: JCB 3CX por Pedro Orozco, dia completo
(44, 3009,5006,7008,11008,102,
 '2024-11-06','07:00','15:30', 275.00,
 NULL,NULL,NULL,0.00,
 350.00,'Cambio de aceite hidraulico',
 'Hora',220.00,NULL,1870.00,
 'NO',0,'Complejo Deportivo Municipal','Excavacion cancha principal','NO'),

-- Registro 45: Komatsu PC55 en Remodelacion Hospital, mantenimiento alto
(45, 3014,5015,7005,11005,100,
 '2024-11-10','07:00','14:00', 275.00,
 235.00,'12:00',15.94,420.00,
 580.00,'Servicio 750 horas completo',
 'Hora',200.00,NULL,1400.00,
 'NO',0,'Hospital Regional','Excavacion para nueva ala','NO'),

-- ── REGISTROS ADICIONALES variados ───────────────────────────────────────
-- Registro 46: Dia con flete y alto mantenimiento
(46, 3001,5005,7001,11001,101,
 '2024-09-06','06:00','14:42', 300.00,
 2110.00,'11:00',20.05,490.00,
 1675.00,'5 dientes cucharon trasero + pasadores y seguros',
 'Hora',250.00,NULL,2175.00,
 'SI',1200.00,'Carretera CA-9 Norte','Excavacion de drenajes','NO'),

-- Registro 47: Dia con costo combustible alto (diesel caro)
(47, 3000,5016,7000,11000,100,
 '2024-09-11','06:00','14:00', 275.00,
 533.80,'10:30',35.00,840.00,
 0.00,'Sin mantenimiento',
 'Hora',200.00,NULL,1600.00,
 'SI',1625.00,'Cantera Vado Hondo','Extraccion material','NO'),

-- Registro 48: Dia con perdida (egresos > ingresos — para ejemplo de reporte)
(48, 3006,5007,7003,11003,100,
 '2024-09-14','06:00','11:30', 300.00,
 664.50,'14:00',24.00,585.00,
 1000.00,'Cambio de cucharon trasero completo',
 'Comision',NULL,10.00,165.00,
 'SI',5700.00,'Corrales Camino el Molino','Trabajo con llanta dañada','NO'),

-- Registro 49: Dia de solo 4 horas (minimo de cobro)
(49, 3009,5006,7000,11000,100,
 '2024-09-17','07:00','11:00', 300.00,
 667.30,'08:50',8.47,207.00,
 0.00,'Sin mantenimiento',
 'Hora',220.00,NULL,880.00,
 'NO',0,'Corrales Llano Calderon','Trabajo de manana','NO'),

-- Registro 50: Servicio especial zona norte, precio premium Q475/h
(50, 3014,5015,7011,11005,106,
 '2024-12-05','07:00','09:00', 475.00,
 240.00,'11:00',6.17,155.00,
 300.00,'Juego de llaves torch',
 'Hora',200.00,NULL,400.00,
 'NO',0,'Terreno el Caminero','Servicio especial zona norte','NO');

SET IDENTITY_INSERT Operaciones_RegistroTrabajo OFF;
GO

-- ============================================================
-- VERIFICAR los datos insertados con columnas calculadas
-- ============================================================
SELECT
    id_registro,
    id_maquinaria,
    fecha,
    hora_inicial,
    hora_final,
    horas_utiles,           -- calculada
    precio_por_hora,
    total_cobrado,          -- calculada
    costo_combustible,
    costo_mantenimiento,
    pago_piloto,
    costo_flete,
    total_egresos,          -- calculada
    utilidad_neta,          -- calculada
    ROUND(margen_ganancia,2) AS margen_porc, -- calculada
    ubicacion
FROM Operaciones_RegistroTrabajo
ORDER BY fecha, hora_inicial;
GO

-- ── Resumen financiero de los 50 registros ─────────────────
SELECT
    COUNT(*)                    AS total_registros,
    SUM(horas_utiles)           AS total_horas,
    SUM(total_cobrado)          AS total_ingreso_q,
    SUM(costo_combustible)      AS total_combustible_q,
    SUM(costo_mantenimiento)    AS total_mantenimiento_q,
    SUM(pago_piloto)            AS total_pilotos_q,
    SUM(costo_flete)            AS total_fletes_q,
    SUM(total_egresos)          AS total_egresos_q,
    SUM(utilidad_neta)          AS utilidad_total_q,
    AVG(margen_ganancia)        AS margen_promedio_porc,
    AVG(promedio_gal_hora)      AS consumo_prom_gal_hora
FROM Operaciones_RegistroTrabajo
WHERE cancelado = 'NO';
GO

-- ── Ranking de utilidad por maquinaria ─────────────────────
SELECT
    m.placa,
    mm.nombre_modelo,
    COUNT(rt.id_registro)   AS dias_trabajados,
    SUM(rt.horas_utiles)    AS total_horas,
    SUM(rt.total_cobrado)   AS total_cobrado,
    SUM(rt.total_egresos)   AS total_egresos,
    SUM(rt.utilidad_neta)   AS utilidad_neta,
    AVG(rt.margen_ganancia) AS margen_promedio
FROM Operaciones_RegistroTrabajo rt
JOIN Maquinaria_Maquinaria m        ON rt.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo      = mm.id_modelo
WHERE rt.cancelado = 'NO'
GROUP BY m.placa, mm.nombre_modelo
ORDER BY utilidad_neta DESC;
GO

-- ── Ranking de pilotos por utilidad generada ───────────────
SELECT
    e.nombre + ' ' + e.apellido AS piloto,
    COUNT(rt.id_registro)       AS dias_trabajados,
    SUM(rt.horas_utiles)        AS total_horas,
    SUM(rt.pago_piloto)         AS total_pagado_piloto,
    SUM(rt.total_cobrado)       AS total_generado,
    SUM(rt.utilidad_neta)       AS utilidad_generada,
    AVG(rt.margen_ganancia)     AS margen_promedio
FROM Operaciones_RegistroTrabajo rt
JOIN RRHH_Empleado e ON rt.id_empleado = e.id_empleado
WHERE rt.cancelado = 'NO'
GROUP BY e.id_empleado, e.nombre, e.apellido
ORDER BY utilidad_generada DESC;
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ============================================================
-- BITÁCORA AUTOMÁTICA POR USUARIO SQL SERVER
-- Sin SP de login — captura SYSTEM_USER directamente
-- Cualquier cambio de usuario_administrador, usuario_gerente
-- o usuario_supervisor aparece automáticamente en Seguridad_Bitacora
-- ============================================================
USE GestionMaquinaria;
GO

-- ── Regenerar triggers capturando SYSTEM_USER ──────────────
CREATE OR ALTER PROCEDURE sp_CrearTriggersBitacora AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @tabla NVARCHAR(100), @pkCol NVARCHAR(100),
            @sql   NVARCHAR(MAX);

    DECLARE cur CURSOR FOR
        SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME NOT IN ('Seguridad_Bitacora');
    OPEN cur; FETCH NEXT FROM cur INTO @tabla;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Obtener PK de la tabla
        SELECT TOP 1 @pkCol = c.COLUMN_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
        JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c
            ON tc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
           AND tc.TABLE_NAME      = c.TABLE_NAME
        WHERE tc.TABLE_NAME      = @tabla
          AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY';

        IF @pkCol IS NULL
            SELECT TOP 1 @pkCol = COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = @tabla
            ORDER BY ORDINAL_POSITION;

        -- TRIGGER INSERT
        SET @sql = N'
CREATE OR ALTER TRIGGER trg_Bit_' + @tabla + N'_I
ON [dbo].[' + @tabla + N'] AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Seguridad_Bitacora
        (tabla_afectada, accion, id_registro_afectado,
         valor_nuevo, nombre_usuario, ip_origen)
    SELECT
        ''' + @tabla + N''',
        ''INSERT'',
        TRY_CAST(i.' + QUOTENAME(@pkCol) + N' AS INT),
        (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        SYSTEM_USER,
        ''0.0.0.0''
    FROM inserted i;
END;';
        EXEC sp_executesql @sql;

        -- TRIGGER UPDATE
        SET @sql = N'
CREATE OR ALTER TRIGGER trg_Bit_' + @tabla + N'_U
ON [dbo].[' + @tabla + N'] AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Seguridad_Bitacora
        (tabla_afectada, accion, id_registro_afectado,
         valor_anterior, valor_nuevo, nombre_usuario, ip_origen)
    SELECT
        ''' + @tabla + N''',
        ''UPDATE'',
        TRY_CAST(i.' + QUOTENAME(@pkCol) + N' AS INT),
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        SYSTEM_USER,
        ''0.0.0.0''
    FROM inserted i
    JOIN deleted d
        ON i.' + QUOTENAME(@pkCol) + N' = d.' + QUOTENAME(@pkCol) + N';
END;';
        EXEC sp_executesql @sql;

        -- TRIGGER DELETE
        SET @sql = N'
CREATE OR ALTER TRIGGER trg_Bit_' + @tabla + N'_D
ON [dbo].[' + @tabla + N'] AFTER DELETE AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Seguridad_Bitacora
        (tabla_afectada, accion, id_registro_afectado,
         valor_anterior, nombre_usuario, ip_origen)
    SELECT
        ''' + @tabla + N''',
        ''DELETE'',
        TRY_CAST(d.' + QUOTENAME(@pkCol) + N' AS INT),
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        SYSTEM_USER,
        ''0.0.0.0''
    FROM deleted d;
END;';
        EXEC sp_executesql @sql;

        PRINT 'OK: ' + @tabla;
        FETCH NEXT FROM cur INTO @tabla;
    END;
    CLOSE cur; DEALLOCATE cur;
    PRINT '=== Triggers listos — capturan SYSTEM_USER automaticamente ===';
END;
GO

-- Ejecutar para crear/actualizar todos los triggers
EXEC sp_CrearTriggersBitacora;
GO

-- ============================================================
-- PRUEBA: conectarse como cada usuario y hacer un cambio
-- ============================================================

-- ── Simular usuario_administrador ─────────────────────────
EXECUTE AS LOGIN = 'usuario_administrador';
    UPDATE Catalogo_Marca
    SET pais_origen = 'Estados Unidos de America'
    WHERE id_marca = 500;
REVERT;

-- ── Simular usuario_gerente ────────────────────────────────
EXECUTE AS LOGIN = 'usuario_gerente';
    UPDATE Contratos_ContratoAlquiler
    SET observaciones = 'Contrato revisado por gerente'
    WHERE id_contrato = 11001;
REVERT;

-- ── Simular usuario_supervisor ─────────────────────────────
EXECUTE AS LOGIN = 'usuario_supervisor';
    UPDATE Maquinaria_Maquinaria
    SET ubicacion_actual = 'Proyecto Zona 10 - Actualizado'
    WHERE id_maquinaria = 3000;
REVERT;
GO

-- ============================================================
-- VER RESULTADO EN BITÁCORA
-- Debe mostrar cada usuario con su cambio
-- ============================================================
SELECT
    b.id_bitacora,
    b.nombre_usuario    AS usuario_que_cambio,
    b.tabla_afectada    AS tabla,
    b.accion,
    b.id_registro_afectado,
    b.valor_anterior,
    b.valor_nuevo,
    b.fecha_hora
FROM Seguridad_Bitacora b
WHERE b.nombre_usuario IN (
    'usuario_administrador',
    'usuario_gerente',
    'usuario_supervisor'
)
ORDER BY b.fecha_hora DESC;
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ============================================================
-- PUNTO 3: BACKUP Y RESTORE — GestionMaquinaria
-- ============================================================
USE master;
GO

-- ───────────────────────────────────────────────────────────
-- OPCIÓN A: BACKUP COMPLETO (Full Backup)
-- Guarda toda la base de datos en un archivo .bak
-- ───────────────────────────────────────────────────────────
DECLARE @Path VARCHAR(255);
DECLARE @FileName VARCHAR(100);
DECLARE @FullPath VARCHAR(500);

-- 1. Definimos la carpeta base
SET @Path = 'C:\Backups\';

-- 2. Creamos el nombre del archivo con la fecha
DECLARE @Path VARCHAR(255);
DECLARE @FileName VARCHAR(100);
DECLARE @FullPath VARCHAR(500);
SET @FileName = 'GestionMaquinariabk' + 
                REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120), ':', '-'), ' ', '_') + '.bak';

-- 3. Concatenamos todo
DECLARE @Path VARCHAR(255);
DECLARE @FileName VARCHAR(100);
DECLARE @FullPath VARCHAR(500);
SET @FullPath = @Path + @FileName;



-- 2. Definir ruta y nombre


    DECLARE @RutaSegura VARCHAR(500) = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\';
DECLARE @NombreArchivo VARCHAR(500) = @RutaSegura + 'GestionMaquinariabk' + 
                                     REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120), ':', '-'), ' ', '_') + '.bak';

BACKUP DATABASE [GestionMaquinaria]
TO DISK = @NombreArchivo
WITH 
    FORMAT, 
    INIT, 
    NAME = 'GestionMaquinaria Full Backup',
    COMPRESSION, 
    STATS = 10;

-- Esto es para que veas dónde quedó guardado exactamente en los mensajes
PRINT 'El backup se ha guardado en: ' + @NombreArchivo;
GO


ce "El conjunto de copia de seguridad es válido" → OK
GO

-- ───────────────────────────────────────────────────────────
-- VER historial de backups realizados
-- ───────────────────────────────────────────────────────────
SELECT
    bs.database_name                AS base_datos,
    bs.type                         AS tipo_backup,   -- D=Full, I=Diff, L=Log
    CASE bs.type
        WHEN 'D' THEN 'Full'
        WHEN 'I' THEN 'Diferencial'
        WHEN 'L' THEN 'Log'
    END                             AS descripcion,
    bs.backup_start_date            AS inicio,
    bs.backup_finish_date           AS fin,
    DATEDIFF(MINUTE, bs.backup_start_date, bs.backup_finish_date) AS minutos,
    CAST(bs.backup_size/1024/1024 AS DECIMAL(10,2)) AS tamanio_mb,
    bmf.physical_device_name        AS archivo
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = 'GestionMaquinaria'
ORDER BY bs.backup_finish_date DESC;
GO

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================
-- PUNTO 4: Triggers de negocio con RAISERROR específicos
-- ============================================================
USE GestionMaquinaria;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 1: Maquinaria no puede tener horas negativas
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarHorasMaquinaria
ON Maquinaria_Maquinaria
AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE horas_uso_total < 0)
    BEGIN
        RAISERROR(
            'ERROR MAQUINARIA-001: Las horas de uso no pueden ser negativas. Valor ingresado invalido.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE costo_adquisicion <= 0)
    BEGIN
        RAISERROR(
            'ERROR MAQUINARIA-002: El costo de adquisicion debe ser mayor a Q0.00.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 2: Empleado no puede tener salario menor al mínimo
-- Salario mínimo Guatemala 2024 = Q3,230.00
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarSalarioMinimo
ON RRHH_Empleado
AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @salario_minimo DECIMAL(10,2) = 3230.00;

    IF EXISTS (SELECT 1 FROM inserted WHERE salario_actual < @salario_minimo)
    BEGIN
        RAISERROR(
            'ERROR RRHH-001: El salario Q%.2f es menor al salario minimo de Guatemala Q3,230.00. Operacion cancelada.',
            16, 1,
            @salario_minimo
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- DPI debe tener exactamente 13 dígitos
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(dpi) <> 13)
    BEGIN
        RAISERROR(
            'ERROR RRHH-002: El DPI debe tener exactamente 13 digitos. Verifique el numero ingresado.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 3: Contrato no puede tener valor negativo ni cero
--            La fecha fin no puede ser antes que la de inicio
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarContrato
ON Contratos_ContratoAlquiler
AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE valor_total <= 0)
    BEGIN
        RAISERROR(
            'ERROR CONTRATO-001: El valor total del contrato debe ser mayor a Q0.00. Verifique el monto.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE fecha_fin_estimada < fecha_inicio)
    BEGIN
        RAISERROR(
            'ERROR CONTRATO-002: La fecha de finalizacion no puede ser anterior a la fecha de inicio del contrato.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE fecha_inicio < CAST(GETDATE()-365 AS DATE))
    BEGIN
        RAISERROR(
            'ERROR CONTRATO-003: La fecha de inicio no puede ser mayor a 1 anio en el pasado. Verifique la fecha.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 4: Factura no puede vencer antes de ser emitida
--            Monto subtotal debe ser positivo
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarFactura
ON Contratos_Factura
AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE fecha_vencimiento <= fecha_emision)
    BEGIN
        RAISERROR(
            'ERROR FACTURA-001: La fecha de vencimiento debe ser posterior a la fecha de emision de la factura.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE monto_subtotal <= 0)
    BEGIN
        RAISERROR(
            'ERROR FACTURA-002: El monto subtotal de la factura debe ser mayor a Q0.00.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE monto_impuesto < 0)
    BEGIN
        RAISERROR(
            'ERROR FACTURA-003: El impuesto no puede ser negativo.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validar que el vencimiento sea al menos 15 días después de emisión
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(DAY,fecha_emision,fecha_vencimiento) < 15)
    BEGIN
        RAISERROR(
            'ERROR FACTURA-004: La factura debe tener al menos 15 dias de plazo entre emision y vencimiento.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 5: Stock de repuesto no puede quedar negativo
--            Alerta si baja del mínimo
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarStockRepuestoCompleto
ON Mantenimiento_Repuesto
AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE stock_actual < 0)
    BEGIN
        RAISERROR(
            'ERROR STOCK-001: El stock actual no puede ser negativo. Verifique la cantidad disponible.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE precio_unitario <= 0)
    BEGIN
        RAISERROR(
            'ERROR STOCK-002: El precio unitario del repuesto debe ser mayor a Q0.00.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Advertencia de stock bajo (no cancela la operación)
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id_repuesto=d.id_repuesto
               WHERE i.stock_actual < i.stock_minimo AND d.stock_actual >= d.stock_minimo)
    BEGIN
        RAISERROR(
            'ADVERTENCIA STOCK-003: Uno o mas repuestos bajaron del nivel minimo de stock. Revisar y reabastecer.',
            10, 1  -- severidad 10 = advertencia, NO cancela
        );
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 6: Traslado no puede iniciar si el vehículo
--            tiene póliza de seguro vencida
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarPolizaVehiculo
ON Operaciones_TrasladoMaquinaria
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Operaciones_VehiculoTransporte v
            ON i.id_vehiculo_transporte = v.id_vehiculo
        WHERE v.vencimiento_poliza < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR(
            'ERROR TRASLADO-001: El vehiculo asignado tiene la poliza de seguro VENCIDA. No se puede iniciar el traslado.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Operaciones_VehiculoTransporte v
            ON i.id_vehiculo_transporte = v.id_vehiculo
        WHERE v.estado_vehiculo <> 'Operativo'
    )
    BEGIN
        RAISERROR(
            'ERROR TRASLADO-002: El vehiculo asignado no esta en estado Operativo. Solo se pueden usar vehiculos operativos.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM inserted WHERE fecha_llegada_estimada <= fecha_salida)
    BEGIN
        RAISERROR(
            'ERROR TRASLADO-003: La fecha de llegada estimada debe ser posterior a la fecha de salida.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 7: Licencia del conductor debe estar vigente
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarLicenciaConductor
ON Operaciones_TrasladoMaquinaria
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN RRHH_CertificacionConductor cc ON i.id_conductor = cc.id_empleado
        WHERE cc.estado_cert = 'Vencida'
          AND NOT EXISTS (
              SELECT 1 FROM RRHH_CertificacionConductor cc2
              WHERE cc2.id_empleado = i.id_conductor
                AND cc2.estado_cert = 'Vigente'
          )
    )
    BEGIN
        RAISERROR(
            'ERROR CONDUCTOR-001: El conductor asignado no tiene licencia vigente. Verifique las certificaciones del empleado.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 8: Incidente crítico bloquea la maquinaria
--            automáticamente y crea notificación
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_IncidenteCriticoBloqueaMaquina
ON Incidentes_Incidente
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Si el incidente es Crítico o Grave, poner máquina en Baja temporal
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Catalogo_TipoIncidente ti ON i.id_tipo_inc = ti.id_tipo_inc
        WHERE ti.nivel_gravedad IN ('Critico', 'Grave')
    )
    BEGIN
        -- Cambiar estado de maquinaria
        UPDATE Maquinaria_Maquinaria
        SET estado_equipo = 'Mantenimiento'
        FROM Maquinaria_Maquinaria m
        JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
        JOIN Catalogo_TipoIncidente ti ON i.id_tipo_inc = ti.id_tipo_inc
        WHERE ti.nivel_gravedad IN ('Critico', 'Grave')
          AND m.estado_equipo NOT IN ('Baja', 'Mantenimiento');

        -- Advertencia en pantalla
        RAISERROR(
            'ALERTA INCIDENTE-001: Incidente CRITICO o GRAVE registrado. Maquinaria puesta en estado Mantenimiento automaticamente. Notificar al gerente.',
            10, 1  -- severidad 10 = no cancela, solo avisa
        );
    END
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 9: Pago no puede superar el monto de la factura
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarMontoPago
ON Contratos_Pago
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que el monto pagado no exceda lo facturado
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Contratos_Factura f ON i.id_factura = f.id_factura
        WHERE i.monto_pagado > f.monto_total
    )
    BEGIN
        RAISERROR(
            'ERROR PAGO-001: El monto pagado (Q%.2f) supera el total de la factura. No se permite sobrepago.',
            16, 1, 0
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- No pagar facturas ya pagadas o anuladas
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Contratos_Factura f ON i.id_factura = f.id_factura
        WHERE f.estado_pago IN ('Pagada', 'Anulada')
    )
    BEGIN
        RAISERROR(
            'ERROR PAGO-002: No se puede registrar un pago sobre una factura que ya esta Pagada o Anulada.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Al pagar, actualizar estado de factura a Pagada
    UPDATE Contratos_Factura
    SET estado_pago = 'Pagada'
    FROM Contratos_Factura f
    JOIN inserted i ON f.id_factura = i.id_factura;
END;
GO

-- ───────────────────────────────────────────────────────────
-- TRIGGER 10: No se puede borrar maquinaria con contratos
--             activos o traslados en curso
-- ───────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ProtegerMaquinariaActiva
ON Maquinaria_Maquinaria
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar contratos activos
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Contratos_DetalleContrato dc ON d.id_maquinaria = dc.id_maquinaria
        JOIN Contratos_ContratoAlquiler ca ON dc.id_contrato = ca.id_contrato
        WHERE ca.estado_contrato = 'Activo'
    )
    BEGIN
        RAISERROR(
            'ERROR MAQUINARIA-003: No se puede eliminar una maquinaria que tiene contratos ACTIVOS asignados. Cierre o cancele el contrato primero.',
            16, 1
        );
        RETURN;
    END

    -- Verificar traslados en curso
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Operaciones_TrasladoMaquinaria t ON d.id_maquinaria = t.id_maquinaria
        WHERE t.estado_traslado = 'En_Transito'
    )
    BEGIN
        RAISERROR(
            'ERROR MAQUINARIA-004: No se puede eliminar una maquinaria que tiene un traslado EN TRANSITO. Espere a que el traslado se complete.',
            16, 1
        );
        RETURN;
    END

    -- Si no hay conflictos, permitir el borrado
    DELETE FROM Maquinaria_Maquinaria
    WHERE id_maquinaria IN (SELECT id_maquinaria FROM deleted);
END;
GO

-- ── Probar los triggers con casos de error ─────────────────

-- Prueba 1: horas negativas → debe dar ERROR MAQUINARIA-001
UPDATE Maquinaria_Maquinaria SET horas_uso_total = -50 WHERE id_maquinaria = 3000;

-- Prueba 2: salario menor al mínimo → ERROR RRHH-001
UPDATE RRHH_Empleado SET salario_actual = 1500 WHERE id_empleado = 5005;

-- Prueba 3: fecha fin antes que inicio → ERROR CONTRATO-002
UPDATE Contratos_ContratoAlquiler
SET fecha_fin_estimada = '2020-01-01' WHERE id_contrato = 11001;

-- Prueba 4: pagar factura ya pagada → ERROR PAGO-002
INSERT INTO Contratos_Pago (id_factura,fecha_pago,monto_pagado,metodo_pago,referencia_bancaria,id_empleado_registra)
VALUES (16000, GETDATE(), 1000, 'Efectivo', 'TEST-001', 5011);
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================
-- PUNTO 5: Consulta principal por cada tabla + qué hace
-- ============================================================
USE GestionMaquinaria;
GO

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 1 — GEOGRAFÍA (3 tablas)                        │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Geografia_Pais
-- QUÉ HACE: Lista todos los países con su moneda.
--           Útil para saber en qué países opera la empresa.
SELECT id_pais, nombre_pais, codigo_iso, moneda_oficial
FROM Geografia_Pais ORDER BY nombre_pais;

-- TABLA: Geografia_DepartamentoGeo
-- QUÉ HACE: Muestra los 22 departamentos de Guatemala
--           con su código oficial. Confirma que todos
--           tienen id_pais=300 (Guatemala).
SELECT d.id_depto_geo, d.nombre_depto, d.codigo_depto, p.nombre_pais
FROM Geografia_DepartamentoGeo d
JOIN Geografia_Pais p ON d.id_pais = p.id_pais
WHERE p.codigo_iso = 'GTM'
ORDER BY d.nombre_depto;

-- TABLA: Geografia_Municipio
-- QUÉ HACE: Lista todos los municipios con su departamento.
--           Permite saber a qué zona pertenece cada municipio.
SELECT m.nombre_municipio, d.nombre_depto, m.codigo_postal
FROM Geografia_Municipio m
JOIN Geografia_DepartamentoGeo d ON m.id_depto_geo = d.id_depto_geo
ORDER BY d.nombre_depto, m.nombre_municipio;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 2 — CATÁLOGOS (5 tablas)                        │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Catalogo_Marca
-- QUÉ HACE: Lista todas las marcas de maquinaria
--           con su país de origen y sitio web.
SELECT nombre_marca, pais_origen, sitio_web
FROM Catalogo_Marca ORDER BY pais_origen, nombre_marca;

-- TABLA: Catalogo_CategoriaMaquinaria
-- QUÉ HACE: Lista todas las categorías de equipo.
--           Muestra cuáles requieren operador certificado.
SELECT nombre_categoria, descripcion, requiere_operador_cert
FROM Catalogo_CategoriaMaquinaria
ORDER BY requiere_operador_cert DESC, nombre_categoria;

-- TABLA: Catalogo_TipoMantenimiento
-- QUÉ HACE: Lista tipos de mantenimiento ordenados por
--           frecuencia (periodicidad). Útil para planificar
--           mantenimientos preventivos por horómetro.
SELECT nombre_tipo, periodicidad_horas, descripcion
FROM Catalogo_TipoMantenimiento
ORDER BY periodicidad_horas;

-- TABLA: Catalogo_TipoIncidente
-- QUÉ HACE: Lista incidentes ordenados por gravedad.
--           Identifica cuáles requieren reporte externo
--           (IGSS, policía, aseguradora).
SELECT nombre_tipo, nivel_gravedad, requiere_reporte_externo
FROM Catalogo_TipoIncidente
ORDER BY CASE nivel_gravedad
    WHEN 'Critico'  THEN 1 WHEN 'Grave'    THEN 2
    WHEN 'Moderado' THEN 3 WHEN 'Leve'     THEN 4
END;

-- TABLA: Catalogo_TipoCarga
-- QUÉ HACE: Lista tipos de carga con nivel de control.
--           Determina cuáles necesitan inspección obligatoria.
SELECT nombre_tipo_carga, nivel_control, requiere_inspeccion, descripcion
FROM Catalogo_TipoCarga
ORDER BY nivel_control DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 3 — PROVEEDORES (1 tabla)                       │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Proveedor_Proveedor
-- QUÉ HACE: Lista todos los proveedores activos agrupados
--           por tipo de servicio. Muestra contacto principal
--           y teléfono para llamadas rápidas.
SELECT tipo_servicio, nombre_empresa, nombre_contacto,
    telefono_principal, activo
FROM Proveedor_Proveedor
WHERE activo = 'SI'
ORDER BY tipo_servicio, nombre_empresa;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 4 — MAQUINARIA (6 tablas)                       │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Maquinaria_Bodega
-- QUÉ HACE: Muestra la capacidad de cada bodega vs cuántos
--           equipos tiene actualmente. Detecta bodegas llenas.
SELECT b.nombre_bodega, b.responsable, b.capacidad_equipos,
    COUNT(m.id_maquinaria)    AS equipos_actuales,
    b.capacidad_equipos - COUNT(m.id_maquinaria) AS espacios_libres
FROM Maquinaria_Bodega b
LEFT JOIN Maquinaria_Maquinaria m ON b.id_bodega = m.id_bodega
GROUP BY b.id_bodega, b.nombre_bodega, b.responsable, b.capacidad_equipos
ORDER BY espacios_libres;

-- TABLA: Maquinaria_ModeloMaquinaria
-- QUÉ HACE: Muestra todos los modelos con marca, categoría,
--           peso y potencia. Útil para cotizar y comparar
--           equipos antes de alquilar.
SELECT mm.nombre_modelo, ma.nombre_marca, cat.nombre_categoria,
    mm.anio_fabricacion, mm.peso_toneladas, mm.potencia_hp
FROM Maquinaria_ModeloMaquinaria mm
JOIN Catalogo_Marca ma               ON mm.id_marca     = ma.id_marca
JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
ORDER BY cat.nombre_categoria, mm.peso_toneladas DESC;

-- TABLA: Maquinaria_Maquinaria
-- QUÉ HACE: Inventario completo de toda la flota con estado
--           actual, horas de uso y tipo (neumáticos/oruga).
--           Es el reporte principal de disponibilidad.
SELECT m.placa, mm.nombre_modelo, ma.nombre_marca,
    cat.nombre_categoria, m.tipo_maquinaria,
    m.estado_equipo, m.horas_uso_total,
    m.ubicacion_actual, b.nombre_bodega
FROM Maquinaria_Maquinaria m
JOIN Maquinaria_ModeloMaquinaria mm   ON m.id_modelo    = mm.id_modelo
JOIN Catalogo_Marca ma                ON mm.id_marca     = ma.id_marca
JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
JOIN Maquinaria_Bodega b              ON m.id_bodega     = b.id_bodega
ORDER BY m.estado_equipo, cat.nombre_categoria;

-- TABLA: Maquinaria_MaquinariaNeumaticos
-- QUÉ HACE: Muestra el estado de los neumáticos de cada
--           máquina. Detecta cuáles necesitan cambio próximo.
SELECT m.placa, mm.nombre_modelo, n.cantidad_neumaticos,
    n.medida_neumatico, n.marca_neumatico,
    n.fecha_ultimo_cambio,
    DATEDIFF(DAY, n.fecha_ultimo_cambio, GETDATE()) AS dias_desde_cambio,
    n.presion_recomendada_psi
FROM Maquinaria_MaquinariaNeumaticos n
JOIN Maquinaria_Maquinaria m        ON n.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo     = mm.id_modelo
ORDER BY dias_desde_cambio DESC;

-- TABLA: Maquinaria_MaquinariaOruga
-- QUÉ HACE: Muestra el estado de las orugas. Detecta
--           cuáles están desgastadas o necesitan cambio.
SELECT m.placa, mm.nombre_modelo, o.tipo_oruga,
    o.estado_oruga, o.numero_zapatas,
    o.fecha_ultima_revision,
    DATEDIFF(DAY, o.fecha_ultima_revision, GETDATE()) AS dias_sin_revision
FROM Maquinaria_MaquinariaOruga o
JOIN Maquinaria_Maquinaria m        ON o.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo     = mm.id_modelo
ORDER BY CASE o.estado_oruga
    WHEN 'Necesita cambio' THEN 1 WHEN 'Desgastado' THEN 2
    WHEN 'Regular' THEN 3 WHEN 'Bueno' THEN 4
END;

-- TABLA: Maquinaria_AccesorioMaquinaria
-- QUÉ HACE: Lista accesorios por máquina con estado.
--           Detecta accesorios dañados que no deben
--           incluirse en alquiler.
SELECT m.placa, a.nombre_accesorio, a.estado,
    a.incluido_en_alquiler, a.numero_serie_acc
FROM Maquinaria_AccesorioMaquinaria a
JOIN Maquinaria_Maquinaria m ON a.id_maquinaria = m.id_maquinaria
ORDER BY a.estado DESC, m.placa;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 5 — RECURSOS HUMANOS (5 tablas)                 │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: RRHH_Cargo
-- QUÉ HACE: Lista todos los cargos con salario base
--           ordenados jerárquicamente.
SELECT nivel_jerarquico, nombre_cargo,
    salario_base, requiere_licencia
FROM RRHH_Cargo
ORDER BY nivel_jerarquico, salario_base DESC;

-- TABLA: RRHH_DepartamentoEmpresa
-- QUÉ HACE: Lista departamentos con el nombre de su gerente.
--           Muestra la estructura organizacional de la empresa.
SELECT d.nombre_departamento, d.descripcion,
    e.nombre + ' ' + e.apellido AS gerente
FROM RRHH_DepartamentoEmpresa d
LEFT JOIN RRHH_Empleado e ON d.id_gerente = e.id_empleado
ORDER BY d.nombre_departamento;

-- TABLA: RRHH_Empleado
-- QUÉ HACE: Lista todo el personal activo con cargo,
--           departamento y salario. Es el directorio
--           completo de empleados.
SELECT e.nombre + ' ' + e.apellido AS empleado,
    c.nombre_cargo, d.nombre_departamento,
    e.salario_actual, e.estado,
    e.telefono, e.correo_corporativo
FROM RRHH_Empleado e
JOIN RRHH_Cargo c               ON e.id_cargo            = c.id_cargo
JOIN RRHH_DepartamentoEmpresa d ON e.id_departamento_emp = d.id_departamento_emp
WHERE e.estado = 'Activo'
ORDER BY c.nivel_jerarquico, e.apellido;

-- TABLA: RRHH_CertificacionConductor
-- QUÉ HACE: Lista las licencias de operación con días
--           para vencer. Alerta sobre licencias próximas
--           a vencer o ya vencidas.
SELECT e.nombre + ' ' + e.apellido AS conductor,
    cc.tipo_licencia, cc.numero_certificado,
    cc.fecha_vencimiento, cc.estado_cert,
    DATEDIFF(DAY, GETDATE(), cc.fecha_vencimiento) AS dias_para_vencer,
    CASE
        WHEN cc.estado_cert = 'Vencida' THEN 'VENCIDA'
        WHEN DATEDIFF(DAY,GETDATE(),cc.fecha_vencimiento) <= 30 THEN 'VENCE PRONTO'
        ELSE 'VIGENTE'
    END AS alerta
FROM RRHH_CertificacionConductor cc
JOIN RRHH_Empleado e ON cc.id_empleado = e.id_empleado
ORDER BY dias_para_vencer;

-- TABLA: RRHH_TarifaPiloto
-- QUÉ HACE: Muestra la tarifa actual de cada piloto
--           con su tipo de pago (hora o comisión).
--           Útil para nómina y control de costos.
SELECT e.nombre + ' ' + e.apellido AS piloto,
    c.nombre_cargo,
    tp.tarifa_por_hora, tp.tipo_pago,
    tp.porcentaje_comision,
    tp.fecha_vigencia, tp.activo
FROM RRHH_TarifaPiloto tp
JOIN RRHH_Empleado e ON tp.id_empleado = e.id_empleado
JOIN RRHH_Cargo c    ON e.id_cargo     = c.id_cargo
WHERE tp.activo = 'SI'
ORDER BY tp.tarifa_por_hora DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 6 — CLIENTES (3 tablas)                         │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Contratos_Cliente
-- QUÉ HACE: Lista todos los clientes activos con cuántos
--           contratos tiene cada uno. Identifica los
--           clientes más importantes.
SELECT cl.razon_social, cl.tipo_cliente, cl.telefono,
    COUNT(ca.id_contrato)     AS total_contratos,
    SUM(ca.valor_total)       AS valor_total_contratos,
    cl.activo
FROM Contratos_Cliente cl
LEFT JOIN Contratos_ContratoAlquiler ca ON cl.id_cliente = ca.id_cliente
GROUP BY cl.id_cliente, cl.razon_social, cl.tipo_cliente,
    cl.telefono, cl.activo
ORDER BY valor_total_contratos DESC;

-- TABLA: Contratos_ContactoCliente
-- QUÉ HACE: Lista los contactos principales de cada cliente.
--           Muestra a quién llamar para gestiones comerciales.
SELECT cl.razon_social AS cliente,
    cc.nombre_contacto, cc.cargo,
    cc.telefono_directo, cc.correo_contacto,
    cc.es_principal
FROM Contratos_ContactoCliente cc
JOIN Contratos_Cliente cl ON cc.id_cliente = cl.id_cliente
WHERE cc.es_principal = 'SI'
ORDER BY cl.razon_social;

-- TABLA: Contratos_OperadorCliente
-- QUÉ HACE: Lista los operadores enviados por cada cliente,
--           con su licencia y fecha de vencimiento.
--           Detecta operadores con licencia próxima a vencer.
SELECT cl.razon_social AS cliente,
    oc.nombre + ' ' + oc.apellido AS operador,
    oc.tipo_licencia, oc.vencimiento_licencia, oc.activo,
    DATEDIFF(DAY, GETDATE(), oc.vencimiento_licencia) AS dias_vence_licencia
FROM Contratos_OperadorCliente oc
JOIN Contratos_Cliente cl ON oc.id_cliente = cl.id_cliente
ORDER BY dias_vence_licencia;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 7 — CONTRATOS Y FACTURACIÓN (8 tablas)          │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Contratos_Tarifa
-- QUÉ HACE: Muestra todas las tarifas con precio por hora,
--           consumo de combustible estimado y mínimo de horas.
SELECT cat.nombre_categoria, mm.nombre_modelo,
    ct.tarifa_diaria, ct.tarifa_por_hora,
    ct.horas_minimas_cobro, ct.consumo_gal_hora,
    ct.incluye_operador
FROM Contratos_Tarifa ct
JOIN Catalogo_CategoriaMaquinaria cat ON ct.id_categoria = cat.id_categoria
JOIN Maquinaria_ModeloMaquinaria mm   ON ct.id_modelo    = mm.id_modelo
ORDER BY ct.tarifa_diaria DESC;

-- TABLA: Contratos_ContratoAlquiler
-- QUÉ HACE: Dashboard de contratos. Muestra activos,
--           cerrados y cancelados con cliente y valor.
--           Es el reporte gerencial principal.
SELECT c.numero_contrato, cl.razon_social AS cliente,
    c.fecha_inicio, c.fecha_fin_estimada,
    DATEDIFF(DAY, c.fecha_inicio, GETDATE()) AS dias_transcurridos,
    c.valor_total, c.estado_contrato,
    e.nombre + ' ' + e.apellido             AS vendedor
FROM Contratos_ContratoAlquiler c
JOIN Contratos_Cliente cl   ON c.id_cliente         = cl.id_cliente
JOIN RRHH_Empleado e        ON c.id_empleado_ventas = e.id_empleado
ORDER BY c.estado_contrato, c.fecha_inicio DESC;

-- TABLA: Contratos_DetalleContrato
-- QUÉ HACE: Detalle de maquinaria por contrato con subtotal
--           calculado. Permite ver cuánto aporta cada equipo
--           al valor total del contrato.
SELECT c.numero_contrato, m.placa, mm.nombre_modelo,
    dc.fecha_entrega, dc.fecha_devolucion,
    dc.tarifa_diaria, dc.dias_contratados, dc.subtotal
FROM Contratos_DetalleContrato dc
JOIN Contratos_ContratoAlquiler c ON dc.id_contrato   = c.id_contrato
JOIN Maquinaria_Maquinaria m      ON dc.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo    = mm.id_modelo
ORDER BY c.numero_contrato, dc.subtotal DESC;

-- TABLA: Contratos_AsignacionOperadorCliente
-- QUÉ HACE: Muestra qué operador del cliente está
--           asignado a qué contrato y máquina.
SELECT c.numero_contrato,
    oc.nombre + ' ' + oc.apellido AS operador_cliente,
    oc.tipo_licencia, a.fecha_inicio, a.fecha_fin,
    CASE WHEN a.fecha_fin IS NULL THEN 'Activa' ELSE 'Finalizada' END AS estado_asignacion
FROM Contratos_AsignacionOperadorCliente a
JOIN Contratos_OperadorCliente oc    ON a.id_operador_cliente  = oc.id_operador_cliente
JOIN Contratos_DetalleContrato dc    ON a.id_detalle_contrato  = dc.id_detalle
JOIN Contratos_ContratoAlquiler c    ON dc.id_contrato         = c.id_contrato
ORDER BY a.fecha_inicio DESC;

-- TABLA: Contratos_ProyectoCliente
-- QUÉ HACE: Lista todos los proyectos con su estado
--           y fecha estimada de finalización.
SELECT p.nombre_proyecto, cl.razon_social AS cliente,
    mun.nombre_municipio AS ubicacion,
    p.fecha_inicio, p.fecha_fin_estimada,
    p.estado_proyecto,
    DATEDIFF(DAY, GETDATE(), p.fecha_fin_estimada) AS dias_para_finalizar
FROM Contratos_ProyectoCliente p
JOIN Contratos_Cliente cl    ON p.id_cliente   = cl.id_cliente
JOIN Geografia_Municipio mun ON p.id_municipio = mun.id_municipio
ORDER BY p.estado_proyecto, dias_para_finalizar;

-- TABLA: Contratos_ContratoProyecto
-- QUÉ HACE: Muestra qué contratos están vinculados
--           a qué proyectos (relación N:N).
SELECT c.numero_contrato, p.nombre_proyecto,
    cl.razon_social AS cliente, cp.observaciones
FROM Contratos_ContratoProyecto cp
JOIN Contratos_ContratoAlquiler c ON cp.id_contrato = c.id_contrato
JOIN Contratos_ProyectoCliente p  ON cp.id_proyecto = p.id_proyecto
JOIN Contratos_Cliente cl         ON c.id_cliente   = cl.id_cliente
ORDER BY cl.razon_social;

-- TABLA: Contratos_Factura
-- QUÉ HACE: Estado de cuenta de todas las facturas.
--           Detecta facturas pendientes y vencidas.
--           Es el reporte de cobranza principal.
SELECT f.numero_factura, c.numero_contrato, cl.razon_social,
    f.fecha_emision, f.fecha_vencimiento,
    f.monto_subtotal, f.monto_impuesto, f.monto_total,
    f.estado_pago,
    CASE
        WHEN f.estado_pago = 'Pendiente'
             AND f.fecha_vencimiento < CAST(GETDATE() AS DATE)
             THEN 'VENCIDA'
        WHEN f.estado_pago = 'Pendiente' THEN 'POR COBRAR'
        WHEN f.estado_pago = 'Pagada'    THEN 'PAGADA'
        ELSE f.estado_pago
    END AS alerta_cobro
FROM Contratos_Factura f
JOIN Contratos_ContratoAlquiler c ON f.id_contrato = c.id_contrato
JOIN Contratos_Cliente cl         ON c.id_cliente  = cl.id_cliente
ORDER BY alerta_cobro DESC, f.fecha_vencimiento;

-- TABLA: Contratos_Pago
-- QUÉ HACE: Historial de pagos recibidos con método
--           y referencia bancaria. Útil para conciliación.
SELECT f.numero_factura, cl.razon_social AS cliente,
    p.fecha_pago, p.monto_pagado,
    p.metodo_pago, p.referencia_bancaria,
    e.nombre + ' ' + e.apellido AS registrado_por
FROM Contratos_Pago p
JOIN Contratos_Factura f          ON p.id_factura           = f.id_factura
JOIN Contratos_ContratoAlquiler c ON f.id_contrato          = c.id_contrato
JOIN Contratos_Cliente cl         ON c.id_cliente           = cl.id_cliente
JOIN RRHH_Empleado e              ON p.id_empleado_registra = e.id_empleado
ORDER BY p.fecha_pago DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 8 — OPERACIONES (4 tablas)                      │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Operaciones_VehiculoTransporte
-- QUÉ HACE: Inventario de vehículos de transporte con
--           estado de póliza. Detecta pólizas vencidas
--           que impiden hacer traslados.
SELECT placa, tipo_vehiculo, capacidad_toneladas,
    estado_vehiculo, vencimiento_poliza,
    DATEDIFF(DAY, GETDATE(), vencimiento_poliza) AS dias_vence_poliza,
    CASE
        WHEN vencimiento_poliza < CAST(GETDATE() AS DATE) THEN ' VENCIDA'
        WHEN DATEDIFF(DAY,GETDATE(),vencimiento_poliza) <= 30 THEN 'PRÓXIMA'
        ELSE 'VIGENTE'
    END AS estado_poliza
FROM Operaciones_VehiculoTransporte
ORDER BY dias_vence_poliza;

-- TABLA: Operaciones_Ruta
-- QUÉ HACE: Lista todas las rutas con distancia y nivel
--           de riesgo. Ayuda a planificar traslados seguros.
SELECT r.nombre_ruta,
    orig.nombre_municipio AS origen,
    dest.nombre_municipio AS destino,
    r.distancia_km, r.nivel_riesgo, r.es_internacional
FROM Operaciones_Ruta r
JOIN Geografia_Municipio orig ON r.id_municipio_origen  = orig.id_municipio
JOIN Geografia_Municipio dest ON r.id_municipio_destino = dest.id_municipio
ORDER BY CASE r.nivel_riesgo
    WHEN 'Alto' THEN 1 WHEN 'Medio' THEN 2 WHEN 'Bajo' THEN 3
END, r.distancia_km DESC;

-- TABLA: Operaciones_TrasladoMaquinaria
-- QUÉ HACE: Reporte de todos los traslados con estado.
--           Detecta traslados en tránsito y calcula
--           si llegaron a tiempo.
SELECT m.placa, r.nombre_ruta,
    e.nombre + ' ' + e.apellido AS conductor,
    t.fecha_salida, t.fecha_llegada_estimada, t.fecha_llegada_real,
    t.estado_traslado, t.costo_traslado,
    CASE WHEN t.fecha_llegada_real > t.fecha_llegada_estimada
         THEN 'CON RETRASO'
         WHEN t.fecha_llegada_real IS NULL THEN 'EN RUTA'
         ELSE 'A TIEMPO'
    END AS puntualidad
FROM Operaciones_TrasladoMaquinaria t
JOIN Maquinaria_Maquinaria m         ON t.id_maquinaria        = m.id_maquinaria
JOIN Operaciones_Ruta r              ON t.id_ruta              = r.id_ruta
JOIN RRHH_Empleado e                 ON t.id_conductor         = e.id_empleado
ORDER BY t.fecha_salida DESC;

-- TABLA: Operaciones_TarifaFlete
-- QUÉ HACE: Lista los costos de flete por departamento.
--           Compara costo sencillo vs doble (ida y vuelta).
SELECT d.nombre_depto, tf.tipo_maquinaria,
    tf.costo_flete_q       AS flete_sencillo_q,
    tf.costo_flete_doble_q AS flete_doble_q,
    tf.incluye_cama_baja, tf.nota_adicional
FROM Operaciones_TarifaFlete tf
JOIN Geografia_DepartamentoGeo d ON tf.id_depto_geo = d.id_depto_geo
ORDER BY tf.costo_flete_q;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULOS 9-10 — ADUANAS Y CARGA (6 tablas)              │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Aduanas_Aduana
-- QUÉ HACE: Lista aduanas activas con horario y país.
SELECT a.nombre_aduana, p.nombre_pais, a.tipo_aduana,
    a.horario_operacion, a.activa
FROM Aduanas_Aduana a
JOIN Geografia_Pais p ON a.id_pais = p.id_pais
ORDER BY p.nombre_pais, a.nombre_aduana;

-- TABLA: Aduanas_CruceFronterizo
-- QUÉ HACE: Historial de cruces fronterizos con estado
--           y tiempo de retraso registrado.
SELECT c.numero_declaracion, sal.nombre_aduana AS salida,
    ent.nombre_aduana AS entrada,
    c.fecha_hora_salida, c.estado_cruce,
    c.tiempo_retraso_horas, c.motivo_retraso
FROM Aduanas_CruceFronterizo c
JOIN Aduanas_Aduana sal ON c.id_aduana_salida  = sal.id_aduana
JOIN Aduanas_Aduana ent ON c.id_aduana_entrada = ent.id_aduana
ORDER BY c.fecha_hora_salida DESC;

-- TABLA: Aduanas_DocumentoAduanero
-- QUÉ HACE: Lista documentos aduaneros con vencimiento.
--           Detecta documentos vencidos que bloquean
--           futuros cruces fronterizos.
SELECT da.tipo_documento, da.numero_documento,
    da.entidad_emisora, da.fecha_vencimiento,
    da.estado_documento,
    DATEDIFF(DAY, GETDATE(), da.fecha_vencimiento) AS dias_vence
FROM Aduanas_DocumentoAduanero da
ORDER BY dias_vence;

-- TABLA: Carga_RegistroCarga
-- QUÉ HACE: Lista todas las cargas declaradas con peso,
--           volumen y valor. Útil para control de carga
--           sobredimensionada.
SELECT tc.nombre_tipo_carga, tc.nivel_control,
    rc.descripcion_carga, rc.peso_declarado_kg,
    rc.volumen_declarado_m3, rc.valor_declarado
FROM Carga_RegistroCarga rc
JOIN Catalogo_TipoCarga tc ON rc.id_tipo_carga = tc.id_tipo_carga
ORDER BY rc.peso_declarado_kg DESC;

-- TABLA: Carga_InspeccionCarga
-- QUÉ HACE: Resultados de inspecciones. Detecta alertas
--           y no conformidades para seguimiento.
SELECT ic.momento_inspeccion, ic.resultado,
    rc.descripcion_carga,
    ic.peso_verificado_kg, ic.volumen_verificado_m3,
    e.nombre + ' ' + e.apellido AS inspector,
    ic.observaciones, ic.fecha_inspeccion
FROM Carga_InspeccionCarga ic
JOIN Carga_RegistroCarga rc ON ic.id_carga    = rc.id_carga
JOIN RRHH_Empleado e        ON ic.id_inspector = e.id_empleado
ORDER BY CASE ic.resultado
    WHEN 'No_Conforme' THEN 1 WHEN 'Alerta' THEN 2 WHEN 'Conforme' THEN 3
END, ic.fecha_inspeccion DESC;

-- TABLA: Carga_AlertaCarga
-- QUÉ HACE: Lista alertas de carga abiertas con empleado
--           responsable. Es el reporte de seguimiento de
--           problemas de carga pendientes.
SELECT a.tipo_alerta, a.descripcion_alerta,
    a.estado_alerta, a.fecha_alerta,
    e.nombre + ' ' + e.apellido AS responsable,
    a.resolucion, a.fecha_resolucion
FROM Carga_AlertaCarga a
JOIN RRHH_Empleado e ON a.id_empleado_atiende = e.id_empleado
WHERE a.estado_alerta <> 'Cerrada'
ORDER BY a.fecha_alerta DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 11 — MANTENIMIENTO (4 tablas)                   │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Mantenimiento_Repuesto
-- QUÉ HACE: Inventario de repuestos con alerta de stock
--           bajo. Permite planificar compras antes de
--           quedarse sin material.
SELECT r.nombre_repuesto, ma.nombre_marca, r.unidad_medida,
    r.precio_unitario, r.stock_actual, r.stock_minimo,
    r.stock_actual - r.stock_minimo AS diferencia,
    CASE WHEN r.stock_actual = 0           THEN '🔴 SIN STOCK'
         WHEN r.stock_actual < r.stock_minimo THEN '🟡 STOCK BAJO'
         ELSE '🟢 OK'
    END AS estado_stock
FROM Mantenimiento_Repuesto r
JOIN Catalogo_Marca ma ON r.id_marca = ma.id_marca
ORDER BY estado_stock, r.nombre_repuesto;

-- TABLA: Mantenimiento_OrdenMantenimiento
-- QUÉ HACE: Lista todas las órdenes de mantenimiento
--           con costo y técnico responsable.
--           Dashboard del departamento de mantenimiento.
SELECT m.placa, tm.nombre_tipo, om.fecha_programada,
    om.fecha_realizada, om.costo_total, om.estado,
    e.nombre + ' ' + e.apellido AS tecnico,
    om.descripcion_trabajo
FROM Mantenimiento_OrdenMantenimiento om
JOIN Maquinaria_Maquinaria m       ON om.id_maquinaria = m.id_maquinaria
JOIN Catalogo_TipoMantenimiento tm ON om.id_tipo_mant  = tm.id_tipo_mant
JOIN RRHH_Empleado e               ON om.id_tecnico    = e.id_empleado
ORDER BY CASE om.estado
    WHEN 'En_Proceso' THEN 1 WHEN 'Programado' THEN 2
    WHEN 'Completado' THEN 3 WHEN 'Cancelado'  THEN 4
END, om.fecha_programada DESC;

-- TABLA: Mantenimiento_DetalleMantenimientoRepuesto
-- QUÉ HACE: Detalle de repuestos usados por cada orden.
--           Permite calcular costo real de cada mantenimiento.
SELECT m.placa, r.nombre_repuesto, dm.cantidad_usada,
    dm.precio_al_momento,
    dm.cantidad_usada * dm.precio_al_momento AS total_repuesto,
    om.fecha_realizada
FROM Mantenimiento_DetalleMantenimientoRepuesto dm
JOIN Mantenimiento_OrdenMantenimiento om ON dm.id_orden_mant = om.id_orden_mant
JOIN Maquinaria_Maquinaria m             ON om.id_maquinaria = m.id_maquinaria
JOIN Mantenimiento_Repuesto r            ON dm.id_repuesto   = r.id_repuesto
ORDER BY m.placa, total_repuesto DESC;

-- TABLA: Mantenimiento_RegistroCombustible
-- QUÉ HACE: Historial de cargas de combustible por máquina.
--           Calcula costo total y detecta consumo anormal.
SELECT m.placa, rc.fecha_carga, rc.litros_cargados,
    rc.costo_por_litro, rc.costo_total,
    rc.tipo_combustible, rc.horas_maquina,
    e.nombre + ' ' + e.apellido AS registrado_por
FROM Mantenimiento_RegistroCombustible rc
JOIN Maquinaria_Maquinaria m ON rc.id_maquinaria = m.id_maquinaria
JOIN RRHH_Empleado e         ON rc.id_empleado   = e.id_empleado
ORDER BY rc.fecha_carga DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULOS 12-13 — INCIDENTES (3 tablas)                  │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Incidentes_SeguroMaquinaria
-- QUÉ HACE: Estado de pólizas de seguro por maquinaria.
--           Detecta pólizas por vencer y calcula prima mensual.
SELECT m.placa, sm.aseguradora, sm.tipo_cobertura,
    sm.prima_anual,
    ROUND(sm.prima_anual / 12, 2)             AS prima_mensual,
    sm.fecha_vencimiento, sm.estado_poliza,
    DATEDIFF(DAY, GETDATE(), sm.fecha_vencimiento) AS dias_vence
FROM Incidentes_SeguroMaquinaria sm
JOIN Maquinaria_Maquinaria m ON sm.id_maquinaria = m.id_maquinaria
ORDER BY dias_vence;

-- TABLA: Incidentes_Incidente
-- QUÉ HACE: Reporte de todos los incidentes con gravedad
--           y daños estimados. Es el reporte de seguridad
--           más importante de la empresa.
SELECT ti.nombre_tipo, ti.nivel_gravedad,
    m.placa, mun.nombre_municipio AS lugar,
    i.fecha_hora_ocurrencia, i.danos_estimados,
    i.estado_incidente,
    e.nombre + ' ' + e.apellido AS reportado_por
FROM Incidentes_Incidente i
JOIN Catalogo_TipoIncidente ti   ON i.id_tipo_inc        = ti.id_tipo_inc
JOIN Maquinaria_Maquinaria m     ON i.id_maquinaria      = m.id_maquinaria
JOIN RRHH_Empleado e             ON i.id_empleado_reporta = e.id_empleado
JOIN Geografia_Municipio mun     ON i.id_municipio        = mun.id_municipio
ORDER BY CASE ti.nivel_gravedad
    WHEN 'Critico' THEN 1 WHEN 'Grave' THEN 2
    WHEN 'Moderado' THEN 3 WHEN 'Leve' THEN 4
END, i.fecha_hora_ocurrencia DESC;

-- TABLA: Incidentes_RegistroFallecido
-- QUÉ HACE: Registro legal de fallecidos en accidentes.
--           Incluye número de acta de defunción para
--           trámites legales e indemnizaciones.
SELECT rf.nombre_completo, rf.tipo_victima,
    rf.fecha_fallecimiento, rf.causa_fallecimiento,
    rf.lugar_fallecimiento, rf.numero_acta_defuncion,
    mun.nombre_municipio, rf.observaciones
FROM Incidentes_RegistroFallecido rf
JOIN Geografia_Municipio mun ON rf.id_municipio = mun.id_municipio
ORDER BY rf.fecha_fallecimiento DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 14 — SEGURIDAD (6 tablas)                       │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Seguridad_RolSistema
-- QUÉ HACE: Lista los roles del sistema con nivel de acceso.
SELECT nivel_acceso, nombre_rol, descripcion
FROM Seguridad_RolSistema ORDER BY nivel_acceso;

-- TABLA: Seguridad_Permiso
-- QUÉ HACE: Catálogo de todos los permisos disponibles
--           agrupados por módulo.
SELECT modulo, tipo_accion, nombre_permiso
FROM Seguridad_Permiso
ORDER BY modulo, tipo_accion;

-- TABLA: Seguridad_RolPermiso
-- QUÉ HACE: Muestra qué permisos tiene cada rol.
--           Es la matriz completa de autorización.
SELECT r.nombre_rol, r.nivel_acceso,
    p.modulo, p.tipo_accion, p.nombre_permiso
FROM Seguridad_RolPermiso rp
JOIN Seguridad_RolSistema r ON rp.id_rol     = r.id_rol
JOIN Seguridad_Permiso p    ON rp.id_permiso = p.id_permiso
ORDER BY r.nivel_acceso, p.modulo;

-- TABLA: Seguridad_UsuarioSistema
-- QUÉ HACE: Lista todos los usuarios del sistema con
--           su rol y último acceso. Detecta usuarios
--           inactivos o sin acceso reciente.
SELECT u.username, e.nombre + ' ' + e.apellido AS empleado,
    r.nombre_rol, u.ultimo_acceso, u.activo,
    DATEDIFF(DAY, u.ultimo_acceso, GETDATE()) AS dias_sin_acceso
FROM Seguridad_UsuarioSistema u
JOIN RRHH_Empleado e        ON u.id_empleado = e.id_empleado
JOIN Seguridad_RolSistema r ON u.id_rol      = r.id_rol
ORDER BY dias_sin_acceso DESC;

-- TABLA: Seguridad_Bitacora
-- QUÉ HACE: Auditoría completa de todos los cambios.
--           Muestra quién, qué, cuándo y el valor
--           antes y después de cada operación.
SELECT TOP 50
    b.nombre_usuario     AS quien_lo_hizo,
    b.tabla_afectada     AS en_que_tabla,
    b.accion             AS que_hizo,
    b.id_registro_afectado AS registro_pk,
    b.valor_anterior,
    b.valor_nuevo,
    b.fecha_hora
FROM Seguridad_Bitacora b
ORDER BY b.fecha_hora DESC;

-- TABLA: Seguridad_Notificacion
-- QUÉ HACE: Notificaciones pendientes de leer por usuario.
--           Alertas de vencimientos, incidentes y contratos.
SELECT u.username AS destinatario,
    n.tipo_notificacion, n.mensaje,
    n.leida, n.fecha_generacion, n.tabla_referencia
FROM Seguridad_Notificacion n
JOIN Seguridad_UsuarioSistema u ON n.id_usuario_destino = u.id_usuario
WHERE n.leida = 'NO'
ORDER BY n.fecha_generacion DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 15 — ANALÍTICA (3 tablas)                       │
-- └─────────────────────────────────────────────────────────┘

-- TABLA: Analitica_CostoOperativo
-- QUÉ HACE: Costos operativos por mes y tipo (combustible,
--           mantenimiento, traslado). Permite ver en qué
--           gasta más cada máquina mes a mes.
SELECT mm.nombre_modelo, m.placa, co.mes, co.anio,
    co.tipo_costo, co.monto, co.descripcion
FROM Analitica_CostoOperativo co
JOIN Maquinaria_Maquinaria m        ON co.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo      = mm.id_modelo
ORDER BY co.anio DESC, co.mes DESC, co.monto DESC;

-- TABLA: Analitica_IndicadorRendimiento
-- QUÉ HACE: KPIs de rendimiento (utilización, consumo,
--           MTTR, MTBF) por máquina y mes.
--           Es el tablero de control operativo.
SELECT m.placa, mm.nombre_modelo,
    ir.tipo_indicador, ir.mes, ir.anio,
    ir.valor_indicador, ir.unidad_medida,
    ir.observaciones
FROM Analitica_IndicadorRendimiento ir
JOIN Maquinaria_Maquinaria m        ON ir.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo      = mm.id_modelo
ORDER BY ir.tipo_indicador, ir.anio DESC, ir.mes DESC;

-- TABLA: Analitica_HistorialUbicacionMaquinaria
-- QUÉ HACE: Rastrea dónde ha estado cada máquina.
--           Muestra el historial de movimientos
--           con coordenadas GPS cuando disponibles.
SELECT m.placa, mun.nombre_municipio,
    hu.fecha_hora_registro, hu.fuente_registro,
    hu.latitud, hu.longitud
FROM Analitica_HistorialUbicacionMaquinaria hu
JOIN Maquinaria_Maquinaria m  ON hu.id_maquinaria = m.id_maquinaria
JOIN Geografia_Municipio mun  ON hu.id_municipio  = mun.id_municipio
ORDER BY m.placa, hu.fecha_hora_registro DESC;

-- ┌─────────────────────────────────────────────────────────┐
-- │ MÓDULO 16 — REGISTRO DE TRABAJO (1 tabla)              │
-- └─────────────────────────────────────────────────────────┘
select *from Operaciones_RegistroTrabajo
-- TABLA: Operaciones_RegistroTrabajo
-- QUÉ HACE: El reporte financiero más importante.
--           Muestra cada día de trabajo con horas,
--           cobrado, gastos, pago al piloto y
--           UTILIDAD NETA calculada automáticamente.
SELECT e.nombre + ' ' + e.apellido AS piloto,
    rt.fecha, m.placa,
    rt.hora_inicial, rt.hora_final,
    rt.horas_utiles,
    rt.precio_por_hora,
    rt.total_cobrado        AS cobrado_al_cliente,
    rt.costo_combustible,
    rt.costo_mantenimiento,
    rt.pago_piloto,
    rt.total_egresos,
    rt.utilidad_neta,
    rt.margen_ganancia      AS margen_porc,
    cl.razon_social         AS cliente,
    rt.ubicacion
FROM Operaciones_RegistroTrabajo rt
JOIN RRHH_Empleado e         ON rt.id_empleado   = e.id_empleado
JOIN Maquinaria_Maquinaria m ON rt.id_maquinaria = m.id_maquinaria
LEFT JOIN Contratos_Cliente cl ON rt.id_cliente  = cl.id_cliente
WHERE rt.cancelado = 'NO'
ORDER BY rt.fecha DESC, e.apellido;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================
-- PUNTO 1: USUARIOS, ROLES Y PERMISOS — GestionMaquinaria
-- Estilo dinámico con GRANT sobre todas las tablas
-- ============================================================

USE master;
GO

-- ============================================================
-- PASO 1: Crear LOGINS a nivel del servidor
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_administrador')
    CREATE LOGIN usuario_administrador WITH PASSWORD = 'Admin@2024';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_gerente')
    CREATE LOGIN usuario_gerente      WITH PASSWORD = 'Gerente@2024';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usuario_supervisor')
    CREATE LOGIN usuario_supervisor   WITH PASSWORD = 'Super@2024';



-- ============================================================
-- PASO 2: Cambiar a GestionMaquinaria y crear USUARIOS
-- ============================================================
USE GestionMaquinaria;
GO


DROP USER IF EXISTS usuario_administrador;
DROP USER IF EXISTS usuario_gerente;
DROP USER IF EXISTS usuario_supervisor;


CREATE USER usuario_administrador FOR LOGIN usuario_administrador;
CREATE USER usuario_gerente       FOR LOGIN usuario_gerente;
CREATE USER usuario_supervisor    FOR LOGIN usuario_supervisor;

GO

-- ============================================================
-- PASO 3: Crear ROLES
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='rol_administrador' AND type='R') CREATE ROLE rol_administrador;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='rol_gerente'       AND type='R') CREATE ROLE rol_gerente;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='rol_supervisor'    AND type='R') CREATE ROLE rol_supervisor;

GO

-- ============================================================
-- PASO 4: Asignar PERMISOS a cada rol
-- ============================================================


-- ----------------------------------------------------------
-- ROL ADMINISTRADOR — Control total de la base de datos
-- Equivale a db_owner
-- ----------------------------------------------------------
GRANT CONTROL ON DATABASE::GestionMaquinaria TO rol_administrador;
GO

-- ----------------------------------------------------------
-- ROL GERENTE — SELECT + INSERT + UPDATE + DELETE
-- en todas las tablas, generado dinámicamente
-- ----------------------------------------------------------
DECLARE @sql_gerente NVARCHAR(MAX) = N'';
SELECT @sql_gerente += 'GRANT SELECT, INSERT, UPDATE, DELETE ON [' + s.name + '].[' + t.name + '] TO [rol_gerente];' + CHAR(13)
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;
EXEC sp_executesql @sql_gerente;
GO

-- ----------------------------------------------------------
-- ROL SUPERVISOR — SELECT + INSERT + UPDATE
-- No puede borrar registros (sin DELETE)
-- ----------------------------------------------------------
DECLARE @sql_supervisor NVARCHAR(MAX) = N'';
SELECT @sql_supervisor += 'GRANT SELECT, INSERT, UPDATE ON [' + s.name + '].[' + t.name + '] TO [rol_supervisor];' + CHAR(13)
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;
EXEC sp_executesql @sql_supervisor;
GO



-- Deny explícito de DELETE y UPDATE para operativo
DENY UPDATE ON SCHEMA::dbo TO rol_operativo;
DENY DELETE ON SCHEMA::dbo TO rol_operativo;
GO

-- ============================================================
-- PASO 5: Asignar USUARIOS a sus ROLES
-- ============================================================



-- Administrador total
ALTER ROLE rol_administrador ADD MEMBER usuario_administrador;
-- También asignar a db_owner para control total absoluto
ALTER ROLE db_owner          ADD MEMBER usuario_administrador;

-- Gerente: puede todo menos crear objetos
ALTER ROLE rol_gerente       ADD MEMBER usuario_gerente;

-- Supervisor: puede leer, insertar y editar
ALTER ROLE rol_supervisor    ADD MEMBER usuario_supervisor;


-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================

-- Ver todos los usuarios creados en la BD
SELECT
    dp.name             AS usuario,
    dp.type_desc        AS tipo,
    sl.name             AS login_servidor
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sl ON dp.sid = sl.sid
WHERE dp.name IN (
    'usuario_administrador',
    'usuario_gerente','usuario_supervisor'
)
ORDER BY dp.name;

-- Ver a qué rol pertenece cada usuario
SELECT
    r.name  AS rol,
    m.name  AS usuario,
    CASE r.name
        WHEN 'rol_administrador' THEN 'CONTROL TOTAL — Administrador'
        WHEN 'rol_gerente'       THEN 'SELECT+INSERT+UPDATE+DELETE — Gerente'
        WHEN 'rol_supervisor'    THEN 'SELECT+INSERT+UPDATE — Supervisor'
        WHEN 'db_owner'          THEN 'Propietario de BD'
    END     AS descripcion
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id   = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE m.name IN (
   'usuario_administrador',
    'usuario_gerente','usuario_supervisor'
)
ORDER BY r.name;

-- Ver permisos efectivos de cada rol sobre las tablas
SELECT
    dp.name                          AS rol,
    perm.permission_name             AS permiso,
    perm.state_desc                  AS estado,
    ISNULL(OBJECT_NAME(perm.major_id),'(BD completa)') AS objeto
FROM sys.database_permissions perm
JOIN sys.database_principals dp ON perm.grantee_principal_id = dp.principal_id
WHERE dp.name IN (
    'rol_administrador',
    'rol_gerente','rol_supervisor'
)
ORDER BY dp.name, permiso;
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================
-- TEMA 2: Catalogo_Marca con ruta a JSON local
-- Ruta: C:\Users\josej\Documents\Estudios2025\
--        Basedatos2\Proyectobd2\json\
-- ============================================================

-- Primero actualizar los sitio_web para que apunten a JSON locales
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\caterpillar.pdf'  WHERE id_marca = 500;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\komatsu.pdf'       WHERE id_marca = 501;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\volvo_ce.pdf'      WHERE id_marca = 502;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\liebherr.pdf'      WHERE id_marca = 503;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\john_deere.pdf'    WHERE id_marca = 504;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\hitachi.pdf'       WHERE id_marca = 505;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\case.pdf'          WHERE id_marca = 506;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\terex.pdf'         WHERE id_marca = 507;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\jcb.pdf'           WHERE id_marca = 508;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\hyundai_ce.pdf'    WHERE id_marca = 509;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\mack_trucks.pdf'   WHERE id_marca = 510;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\kenworth.pdf'      WHERE id_marca = 511;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\freightliner.pdf'  WHERE id_marca = 512;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\mercedes_benz.pdf' WHERE id_marca = 513;
UPDATE Catalogo_Marca SET sitio_web = 'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\scania.pdf'        WHERE id_marca = 514;
GO
UPDATE documentos_json SET modelos_en_flota = 'Sin modelos en flota' WHERE nombre_marca = 'Terex';
UPDATE documentos_json SET modelos_en_flota = 'Sin modelos en flota' WHERE nombre_marca = 'Hyundai CE';
UPDATE documentos_json SET modelos_en_flota = 'Sin modelos en flota' WHERE nombre_marca = 'Freightliner';
UPDATE documentos_json SET modelos_en_flota = 'Sin modelos en flota' WHERE nombre_marca = 'Mercedes-Benz';
UPDATE documentos_json SET modelos_en_flota = 'Sin modelos en flota' WHERE nombre_marca = 'Scania';

select * from documentos_json
CREATE TABLE documentos_json (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    id_marca    INT,
    nombre_marca NVARCHAR(100),
    pais_origen  NVARCHAR(100),
    fundacion    INT,
    sede         NVARCHAR(200),
    descripcion  NVARCHAR(500),
    productos_principales NVARCHAR(MAX),
    modelos_en_flota      NVARCHAR(MAX),
    ruta         NVARCHAR(500)
);

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(500, 'Caterpillar', 'Estados Unidos', 1925, 'Deerfield, Illinois, EE.UU.',
'Caterpillar Inc. es el mayor fabricante mundial de maquinaria de construccion y mineria.',
'Excavadoras (320, 336, 390) | Bulldozers (D6, D8, D11) | Cargadores frontales (950M, 966, 982) | Camiones articulados (745, 770) | Motoniveladoras (120, 140, 160) | Retroexcavadoras (416F2, 420, 430)',
'M-001-GTQ: CAT 320 | M-003-GTQ: CAT 950M | M-011-GTQ: CAT 745 | M-014-GTQ: CAT CS56 | M-017-GTQ: CAT 745C',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Caterpillar.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(501, 'Komatsu', 'Japon', 1921, 'Minato, Tokyo, Japon',
'Komatsu Ltd. es el segundo mayor fabricante de maquinaria de construccion y mineria del mundo.',
'Excavadoras (PC210, PC360, PC490) | Bulldozers (D51, D85, D155) | Cargadores frontales (WA320, WA500) | Mini excavadoras (PC55MR, PC88MR) | Camiones de acarreo (HD325, HD785)',
'M-002-GTQ: Komatsu PC210 | M-004-GTQ: Komatsu D85 | M-015-GTQ: Komatsu PC55MR',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Komatsu.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(502, 'Volvo CE', 'Suecia', 1832, 'Gothenburg, Suecia',
'Volvo Construction Equipment es un fabricante sueco de equipos de construccion.',
'Excavadoras (EC220, EC380, EC950) | Cargadores de ruedas (L90, L120, L260) | Articulados (A25, A40) | Motoniveladoras (G930, G960) | Pavimentadoras (P6820)',
'M-005-GTQ: Volvo EC380 | M-016-GTQ: Volvo G946B',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Volvo_CE.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(503, 'Liebherr', 'Alemania', 1949, 'Bulle, Suiza / Biberach, Alemania',
'Liebherr es un grupo familiar multinacional que fabrica gruas y maquinaria de construccion.',
'Gruas torre (EC-B, L1, ECH) | Gruas moviles (LTM 1100, LTM 1500) | Gruas articuladas (LTF 1045) | Excavadoras (R 906, R 950) | Camiones mineros (T 264)',
'M-006-GTQ: Liebherr LTM 1100 | M-018-GTQ: Liebherr LTF 1045',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Liebherr.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(504, 'John Deere', 'Estados Unidos', 1837, 'Moline, Illinois, EE.UU.',
'Deere & Company es un fabricante estadounidense de maquinaria agricola, de construccion y forestal.',
'Retroexcavadoras (310L, 410L, 710L) | Excavadoras (350G, 470G) | Pavimentadoras (P524B, P820A) | Cargadores (544, 744, 844) | Motoniveladoras (670GP, 872GP)',
'M-007-GTQ: John Deere 310L | M-019-GTQ: John Deere P524',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\John_Deere.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(505, 'Hitachi', 'Japon', 1910, 'Chiyoda, Tokyo, Japon',
'Hitachi Construction Machinery fabrica excavadoras y equipos de movimiento de tierra.',
'Excavadoras (ZX200, ZX350, ZX890) | Mini excavadoras (ZX33U, ZX55U) | Perforadoras (ZX33U adaptado) | Cargadores de ruedas (ZW310)',
'M-008-GTQ: Hitachi ZX200 | M-020-GTQ: Hitachi ZX33U',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Hitachi.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(506, 'Case', 'Estados Unidos', 1842, 'Racine, Wisconsin, EE.UU.',
'Case Construction Equipment fabrica una amplia gama de equipos de construccion.',
'Cargadores frontales (821G, 921G) | Retroexcavadoras (580N, 695ST) | Excavadoras (CX220D, CX490D) | Motoniveladoras (856D, 872D)',
'M-009-GTQ: Case 821G',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Case.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(507, 'Terex', 'Estados Unidos', 1925, 'Norwalk, Connecticut, EE.UU.',
'Terex Corporation fabrica equipos de construccion, levantamiento y manejo de materiales.',
'Gruas telescopicas (RT, AC series) | Plataformas elevadoras (AWP, boom lifts) | Camiones de obra (TA25, TA400) | Procesadoras de materiales',
NULL,
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Terex.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(508, 'JCB', 'Reino Unido', 1945, 'Rocester, Staffordshire, Reino Unido',
'JCB es un fabricante britanico de equipos de construccion, conocido por sus retroexcavadoras.',
'Retroexcavadoras (3CX, 4CX, 5CX) | Mini excavadoras (8008, 8016, 8085) | Cargadores (407, 417, 437) | Dumpers (1T, 3T, 10T) | Telehandlers (525, 535, 540)',
'M-010-GTQ: JCB 3CX',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\JCB.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(509, 'Hyundai CE', 'Corea del Sur', 1985, 'Seoul, Corea del Sur',
'HD Hyundai Construction Equipment fabrica excavadoras, cargadores y otros equipos de construccion.',
'Excavadoras (HX145A, HX380A) | Cargadores de ruedas (HL955A) | Mini excavadoras (R25Z, R55W) | Compactadoras (HDC80)',
NULL,
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Hyundai_CE.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(510, 'Mack Trucks', 'Estados Unidos', 1900, 'Greensboro, Carolina del Norte, EE.UU.',
'Mack Trucks es un fabricante estadounidense de camiones pesados de construccion y transporte.',
'Camiones Granite (6x4, 6x6, 8x4) | Camiones Anthem (semirremolque) | Camiones Pinnacle (carretera) | Camiones LR (residuos solidos)',
'M-012-GTQ: Mack Granite 6x4',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Mack_Trucks.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(511, 'Kenworth', 'Estados Unidos', 1923, 'Kirkland, Washington, EE.UU.',
'Kenworth Truck Company fabrica camiones pesados de alta calidad.',
'Kenworth T800 (construccion pesada) | Kenworth T680 (carretera larga) | Kenworth W900 (clasico americano) | Kenworth C500 (mineria y construccion)',
'M-013-GTQ: Kenworth T800',
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Kenworth.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(512, 'Freightliner', 'Estados Unidos', 1942, 'Portland, Oregon, EE.UU.',
'Freightliner Trucks es la marca de camiones pesados mas vendida en America del Norte.',
'Cascadia (carretera eficiente) | Coronado (carga pesada) | 122SD (construccion y mineria) | 114SD (servicio municipal)',
NULL,
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Freightliner.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(513, 'Mercedes-Benz', 'Alemania', 1926, 'Stuttgart, Baden-Wurttemberg, Alemania',
'Mercedes-Benz Trucks fabrica camiones pesados de alta tecnologia para transporte.',
'Actros (carretera de largo recorrido) | Arocs (construccion y mineria) | Atego (distribucion urbana) | Axor (transporte regional)',
NULL,
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Mercedes-Benz.pdf');

INSERT INTO documentos_json (id_marca, nombre_marca, pais_origen, fundacion, sede, descripcion, productos_principales, modelos_en_flota, ruta) VALUES
(514, 'Scania', 'Suecia', 1891, 'Sodertalje, Suecia',
'Scania AB es un fabricante sueco de camiones y autobuses pesados, parte del Grupo Volkswagen.',
'Serie R (carretera premium) | Serie S (cabina alta premium) | Serie G (todo terreno) | Serie P (distribucion urbana)',
NULL,
'C:\Users\josej\Documents\Estudios2025\Basedatos2\Proyectobd2\json\Scania.pdf');

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\
-- ── CONSULTA 1: Base para Power BI — combustible por máquina ── pendiente
-- (Usar como tabla en Power BI)
SELECT
    m.placa,
    mm.nombre_modelo,
    ma.nombre_marca,
    cat.nombre_categoria,
    m.tipo_maquinaria,
    -- Desde RegistroCombustible
    rc.fecha_carga,
    YEAR(rc.fecha_carga)                    AS anio,
    MONTH(rc.fecha_carga)                   AS mes,
    DATENAME(MONTH, rc.fecha_carga)         AS nombre_mes,
    rc.litros_cargados,
    rc.costo_por_litro,
    rc.costo_total                          AS costo_combustible,
    rc.horas_maquina 

FROM Mantenimiento_RegistroCombustible rc
JOIN Maquinaria_Maquinaria m           ON rc.id_maquinaria = m.id_maquinaria
JOIN Maquinaria_ModeloMaquinaria mm ON m.id_modelo      = mm.id_modelo
JOIN Catalogo_Marca ma              ON mm.id_marca       = ma.id_marca
JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria
LEFT JOIN Operaciones_RegistroTrabajo rt ON rc.id_maquinaria = rt.id_maquinaria
    AND CAST(rc.fecha_carga AS DATE) = rt.fecha;



-- ── CONSULTA 2: KPIs consolidados por maquinaria ──
-- (Segunda tabla en Power BI)
SELECT
    m.placa,
    mm.nombre_modelo,
    ma.nombre_marca,
    cat.nombre_categoria,
    m.tipo_maquinaria,
    m.estado_equipo,
    m.horas_uso_total,

    -- Combustible: viene de su propia subconsulta
    ISNULL(comb.total_litros,      0)  AS total_litros_diesel,
    ISNULL(comb.total_costo,       0)  AS total_costo_combustible,
    ISNULL(comb.precio_prom,       0)  AS precio_prom_litro,
    ISNULL(comb.total_cargas,      0)  AS total_cargas,

    -- Trabajo: viene de su propia subconsulta
    ISNULL(trab.total_horas,       0)  AS total_horas_trabajadas,
    ISNULL(trab.total_ingreso,     0)  AS total_ingreso,
    ISNULL(trab.total_egresos,     0)  AS total_egresos,
    ISNULL(trab.total_utilidad,    0)  AS total_utilidad,
    ISNULL(trab.margen_prom,       0)  AS margen_promedio,
    ISNULL(trab.consumo_gal_hora,  0)  AS consumo_prom_gal_hora,

    -- Mantenimiento: viene de su propia subconsulta
    ISNULL(mant.total_costo_mant,  0)  AS total_costo_mantenimiento,
    ISNULL(mant.total_ordenes,     0)  AS total_ordenes_mantenimiento,

    -- Seguro: viene de su propia subconsulta
    ISNULL(seg.prima_total,        0)  AS prima_seguro_anual,

    -- Costo operativo real (combustible + mantenimiento)
    ISNULL(comb.total_costo, 0)
    + ISNULL(mant.total_costo_mant, 0) AS costo_operativo_total,

    -- Rentabilidad real
    CASE
        WHEN ISNULL(trab.total_ingreso, 0) > 0
        THEN ROUND(
            ISNULL(trab.total_utilidad, 0)
            / ISNULL(trab.total_ingreso, 1) * 100, 2)
        ELSE 0
    END                                AS rentabilidad_porc

FROM Maquinaria_Maquinaria m
JOIN Maquinaria_ModeloMaquinaria mm   ON m.id_modelo    = mm.id_modelo
JOIN Catalogo_Marca ma                ON mm.id_marca     = ma.id_marca
JOIN Catalogo_CategoriaMaquinaria cat ON mm.id_categoria = cat.id_categoria

-- Subconsulta combustible
LEFT JOIN (
    SELECT id_maquinaria,
        SUM(litros_cargados)  AS total_litros,
        SUM(costo_total)      AS total_costo,
        AVG(costo_por_litro)  AS precio_prom,
        COUNT(id_combustible) AS total_cargas
    FROM Mantenimiento_RegistroCombustible
    GROUP BY id_maquinaria
) comb ON m.id_maquinaria = comb.id_maquinaria

-- Subconsulta trabajo
LEFT JOIN (
    SELECT id_maquinaria,
        SUM(horas_utiles)     AS total_horas,
        SUM(total_cobrado)    AS total_ingreso,
        SUM(total_egresos)    AS total_egresos,
        SUM(utilidad_neta)    AS total_utilidad,
        AVG(margen_ganancia)  AS margen_prom,
        AVG(promedio_gal_hora) AS consumo_gal_hora
    FROM Operaciones_RegistroTrabajo
    WHERE cancelado = 'NO'
    GROUP BY id_maquinaria
) trab ON m.id_maquinaria = trab.id_maquinaria

-- Subconsulta mantenimiento
LEFT JOIN (
    SELECT id_maquinaria,
        SUM(costo_total)      AS total_costo_mant,
        COUNT(id_orden_mant)  AS total_ordenes
    FROM Mantenimiento_OrdenMantenimiento
    WHERE estado = 'Completado'
    GROUP BY id_maquinaria
) mant ON m.id_maquinaria = mant.id_maquinaria

-- Subconsulta seguro
LEFT JOIN (
    SELECT id_maquinaria,
        SUM(prima_anual)      AS prima_total
    FROM Incidentes_SeguroMaquinaria
    WHERE estado_poliza = 'Activa'
    GROUP BY id_maquinaria
) seg ON m.id_maquinaria = seg.id_maquinaria

ORDER BY total_litros_diesel DESC;
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================


-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 1: Auditar cambio de estado en Maquinaria
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 1: Auditar estado maquinaria';
EXECUTE AS LOGIN = 'usuario_supervisor';
    UPDATE Maquinaria_Maquinaria
    SET estado_equipo = 'Mantenimiento'
    WHERE id_maquinaria = 3000;
REVERT;

-- Verificar bitácora
SELECT TOP 1 nombre_usuario, tabla_afectada, accion,
    valor_anterior, valor_nuevo, fecha_hora
FROM Seguridad_Bitacora
WHERE tabla_afectada = 'Maquinaria_Maquinaria'
ORDER BY fecha_hora DESC;
-- ✓ Debe mostrar: usuario_supervisor | UPDATE | Disponible → Mantenimiento
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 2: Crear orden → maquinaria pasa a Mantenimiento
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 2: Orden de mantenimiento cambia estado';
-- Primero dejar disponible
UPDATE Maquinaria_Maquinaria SET estado_equipo='Disponible' WHERE id_maquinaria=3002;

INSERT INTO Mantenimiento_OrdenMantenimiento
    (id_maquinaria,id_tipo_mant,id_tecnico,fecha_programada,
     horas_maquina_al_mant,costo_total,estado,descripcion_trabajo)
VALUES (3002,700,5008,CAST(GETDATE() AS DATE),890,1500,'En_Proceso','Prueba trigger 2');

SELECT estado_equipo FROM Maquinaria_Maquinaria WHERE id_maquinaria=3002;
-- ✓ Debe mostrar: Mantenimiento
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 3: Completar orden → maquinaria regresa a Disponible
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 3: Completar orden libera maquinaria';
DECLARE @id_ord INT;
SELECT TOP 1 @id_ord=id_orden_mant FROM Mantenimiento_OrdenMantenimiento
WHERE id_maquinaria=3002 AND estado='En_Proceso'
ORDER BY id_orden_mant DESC;

UPDATE Mantenimiento_OrdenMantenimiento
SET estado='Completado', fecha_realizada=CAST(GETDATE() AS DATE)
WHERE id_orden_mant=@id_ord;

SELECT estado_equipo FROM Maquinaria_Maquinaria WHERE id_maquinaria=3002;
-- ✓ Debe mostrar: Disponible
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 4: No alquilar maquinaria en Mantenimiento
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 4: Bloquear alquiler si no está Disponible';
-- Poner en mantenimiento primero
UPDATE Maquinaria_Maquinaria SET estado_equipo='Mantenimiento' WHERE id_maquinaria=3002;

-- Intentar alquilar → DEBE FALLAR con error
BEGIN TRY
    INSERT INTO Contratos_DetalleContrato
        (id_contrato,id_maquinaria,fecha_entrega,tarifa_diaria,dias_contratados)
    VALUES (11001,3002,'2024-12-01',1000,30);
    PRINT 'ERROR: No bloqueó el alquiler';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;

-- Restaurar
UPDATE Maquinaria_Maquinaria SET estado_equipo='Disponible' WHERE id_maquinaria=3002;
GO
-----------------------------------------------------prueba trigger
select * from Contratos_DetalleContrato
-- 1. Forzamos a la máquina a estar en 'Mantenimiento'
UPDATE Maquinaria_Maquinaria 
SET estado_equipo = 'Mantenimiento' 
WHERE id_maquinaria = 3002;
GO

-- 2. Intentamos meter el alquiler (Esto te va a tirar el error en letras rojas)
INSERT INTO Contratos_DetalleContrato
    (id_contrato, id_maquinaria, fecha_entrega, tarifa_diaria, dias_contratados)
VALUES 
    (11001, 3002, '2024-12-01', 1000, 30);
GO

SELECT
    b.id_bitacora,
    b.nombre_usuario    AS usuario_que_cambio,
    b.tabla_afectada    AS tabla,
    b.accion,
    b.id_registro_afectado,
    b.valor_anterior,
    b.valor_nuevo,
    b.fecha_hora
FROM Seguridad_Bitacora b
ORDER BY b.fecha_hora DESC;
GO

-- 3. Dejamos la máquina como estaba originalmente
UPDATE Maquinaria_Maquinaria 
SET estado_equipo = 'Disponible' 
WHERE id_maquinaria = 3002;
GO
-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 5: Bitácora automática al crear contrato
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 5: Bitácora de nuevo contrato';
EXECUTE AS LOGIN = 'usuario_gerente';
    INSERT INTO Contratos_ContratoAlquiler
        (numero_contrato,id_cliente,id_empleado_ventas,
         fecha_inicio,fecha_fin_estimada,estado_contrato,valor_total)
    VALUES ('CONT-PRUEBA-001',7000,5010,
            '2025-01-01','2025-03-01','Activo',50000);
REVERT;

SELECT TOP 1 nombre_usuario, tabla_afectada, accion, valor_nuevo
FROM Seguridad_Bitacora
WHERE tabla_afectada='Contratos_ContratoAlquiler' AND accion='INSERT'
ORDER BY fecha_hora DESC;
-- ✓ Debe mostrar: usuario_gerente | INSERT | {numero_contrato...}

-- Limpiar prueba
DELETE FROM Contratos_ContratoAlquiler WHERE numero_contrato='CONT-PRUEBA-001';
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 6: No borrar empleado con contratos activos
-- ──────────────────────────────────────────────────────────
select * from RRHH_Empleado
PRINT '-- TRIGGER 6: Proteger empleado con contratos activos';
BEGIN TRY
    DELETE FROM RRHH_Empleado WHERE id_empleado=5010;
    PRINT 'ERROR: No bloqueó el borrado';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO

----------------------------------------------------------------prueba


-- Ejecuta esto directamente para ver el error nativo en rojo
DELETE FROM RRHH_Empleado 
WHERE id_empleado = 5010;
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 9: Stock insuficiente de repuesto
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 9: Bloquear uso si no hay stock';
-- Stock actual de 27000 = 25 unidades
BEGIN TRY
    INSERT INTO Mantenimiento_DetalleMantenimientoRepuesto
        (id_orden_mant,id_repuesto,cantidad_usada,precio_al_momento)
    VALUES (28001,27000,9999,350); -- pedir 9999 unidades → debe fallar
    PRINT 'ERROR: No bloqueó stock insuficiente';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 11: Fechas inválidas en contrato
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 11: Fecha fin anterior a inicio';
BEGIN TRY
    INSERT INTO Contratos_ContratoAlquiler
        (numero_contrato,id_cliente,id_empleado_ventas,
         fecha_inicio,fecha_fin_estimada,estado_contrato,valor_total)
    VALUES ('CONT-ERROR-001',7000,5010,
            '2025-06-01','2025-01-01','Activo',10000);
    PRINT 'ERROR: No bloqueó fechas inválidas';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ──────────────────────────────────────────────────────────
-- PRUEBA TRIGGER 15: Factura duplicada
-- ──────────────────────────────────────────────────────────
PRINT '-- TRIGGER 15: Bloquear factura duplicada';
BEGIN TRY
    INSERT INTO Contratos_Factura
        (id_contrato,numero_factura,fecha_emision,
         monto_subtotal,monto_impuesto,estado_pago,fecha_vencimiento)
    VALUES (11000,'FAC-2024-001','2024-01-15',
            5000,600,'Pendiente','2024-02-15');
    PRINT 'ERROR: No bloqueó factura duplicada';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================
-- PRUEBAS DE STORED PROCEDURES
-- ============================================================
PRINT '=== PRUEBAS DE STORED PROCEDURES ===';

EXEC sp_ResumenMaquinaria
;-- ✓ Debe listar 20 máquinas con marca, categoría y bodega

EXEC sp_ContratosActivos;
-- ✓ Debe mostrar contratos en estado Activo

EXEC sp_PromedioCostoAdquisicionPorCategoria;
-- ✓ Promedio de costo por tipo de maquinaria

EXEC sp_CostoMantenimientoPorMaquinaria;
-- ✓ Costo total de mantenimiento por máquina

EXEC sp_ContratrosPorCliente @nit_cliente='7001001-1';
-- ✓ Contratos de Constructora Moderna S.A.

EXEC sp_TopMaquinariasMasUsadas;
-- ✓ Top 5 máquinas con más horas

EXEC sp_ConsumoCombustiblePorMaquinaria;
-- ✓ Litros y costo por máquina

EXEC sp_ReporteIncidentesPorGravedad @nivel_gravedad='Critico';
-- ✓ Solo incidentes críticos

EXEC sp_FacturacionPorCliente;
-- ✓ Facturado vs pagado por cliente

EXEC sp_TrasladosPorEstado @estado='Completado';
-- ✓ Traslados terminados

EXEC sp_CostosOperativosMensuales @anio=2024;
-- ✓ Costos mes a mes 2024

EXEC sp_CertificacionesPorVencer @dias_alerta=365;
-- ✓ Licencias vencidas o que vencen en 1 año

EXEC sp_IndicadoresRendimientoResumen;
-- ✓ KPIs promedio por máquina

-- SP con OUTPUT
DECLARE @nuevo_id INT;
EXEC sp_InsertarEmpleado
    @dpi='9999999990101', @nombre='Prueba', @apellido='Empleado',
    @id_cargo=405, @id_depto=451, @fecha_contrato='2024-01-01',
    @salario=8000, @telefono='55000000', @correo='prueba@maqgt.com',
    @id_municipio=200, @id_nuevo=@nuevo_id OUTPUT;
SELECT @nuevo_id AS nuevo_empleado_id;
-- ✓ Debe crear empleado y devolver su ID

-- Limpiar prueba de empleado
DELETE FROM RRHH_Empleado WHERE dpi='9999999990101';
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================================
-- TRIGGERS NUEVOS: ALQUILER Y COMBUSTIBLE
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- TRIGGER A: Al devolver maquinaria, cambiarla a Disponible
-- (cuando se registra fecha_devolucion en DetalleContrato)
-- ──────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_DevolucionMaquinaria
ON Contratos_DetalleContrato
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(fecha_devolucion)
    BEGIN
        -- Si se registra fecha de devolución, liberar la máquina
        UPDATE Maquinaria_Maquinaria
        SET estado_equipo = 'Disponible'
        FROM Maquinaria_Maquinaria m
        JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
        WHERE i.fecha_devolucion IS NOT NULL
          AND m.estado_equipo = 'Alquilado';

        -- Registrar en bitácora
        INSERT INTO Seguridad_Bitacora
            (tabla_afectada, accion, id_registro_afectado,
             valor_nuevo, nombre_usuario)
        SELECT
            'Maquinaria_Maquinaria', 'UPDATE',
            i.id_maquinaria,
            CONCAT('{"estado":"Disponible","motivo":"Devolucion de alquiler",',
                   '"fecha_devolucion":"', i.fecha_devolucion, '"}'),
            SYSTEM_USER
        FROM inserted i
        WHERE i.fecha_devolucion IS NOT NULL;
    END
END;
GO

-- ──────────────────────────────────────────────────────────
-- TRIGGER B: Validar que maquinaria alquilada no
--            se traslade sin autorización
-- ──────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarTrasladoSiAlquilado
ON Operaciones_TrasladoMaquinaria
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Si la máquina está Alquilada, bloquear traslado
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Maquinaria_Maquinaria m ON i.id_maquinaria = m.id_maquinaria
        WHERE m.estado_equipo = 'Alquilado'
    )
    BEGIN
        RAISERROR(
            'ERROR ALQUILER-001: No se puede trasladar una maquinaria que esta actualmente ALQUILADA. Espere la devolucion o cancele el contrato primero.',
            16, 1
        );
        RETURN;
    END

    -- Si está en Mantenimiento, tampoco
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Maquinaria_Maquinaria m ON i.id_maquinaria = m.id_maquinaria
        WHERE m.estado_equipo = 'Mantenimiento'
    )
    BEGIN
        RAISERROR(
            'ERROR ALQUILER-002: No se puede trasladar una maquinaria en estado MANTENIMIENTO.',
            16, 1
        );
        RETURN;
    END

    -- Permitir el traslado
INSERT INTO Operaciones_TrasladoMaquinaria
        (id_maquinaria, id_ruta, id_vehiculo_transporte, id_conductor,
         id_contrato, fecha_salida, fecha_llegada_estimada,
         estado_traslado, costo_traslado, observaciones)
    SELECT
        id_maquinaria, id_ruta, id_vehiculo_transporte, id_conductor,
        id_contrato, fecha_salida, fecha_llegada_estimada,
        estado_traslado, costo_traslado, observaciones
    FROM inserted

    -- Cambiar estado a Traslado (Limpio y usando el alias)
    UPDATE m
    SET m.estado_equipo = 'Traslado'
    FROM Maquinaria_Maquinaria m
    JOIN inserted i ON m.id_maquinaria = i.id_maquinaria
END
GO

-- ──────────────────────────────────────────────────────────
-- TRIGGER C: Registrar automáticamente el combustible
--            en Analitica_CostoOperativo al cargar diesel
-- ──────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_RegistrarCostoCombustibleAnalitica
ON Mantenimiento_RegistroCombustible
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Buscar el contrato activo de esa máquina
    DECLARE @id_contrato INT;
    SELECT TOP 1 @id_contrato = ca.id_contrato
    FROM Contratos_DetalleContrato dc
    JOIN Contratos_ContratoAlquiler ca ON dc.id_contrato = ca.id_contrato
    JOIN inserted i ON dc.id_maquinaria = i.id_maquinaria
    WHERE ca.estado_contrato = 'Activo'
    ORDER BY ca.fecha_inicio DESC;

    -- Si tiene contrato activo, registrar el costo en Analítica
    IF @id_contrato IS NOT NULL
    BEGIN
        INSERT INTO Analitica_CostoOperativo
            (id_maquinaria, id_contrato, tipo_costo, mes, anio, monto, descripcion)
        SELECT
            i.id_maquinaria,
            @id_contrato,
            'Combustible',
            MONTH(i.fecha_carga),
            YEAR(i.fecha_carga),
            i.costo_total,
            CONCAT('Carga diesel: ', i.litros_cargados,
                   ' litros @ Q', i.costo_por_litro,
                   '/litro. Horometro: ', i.horas_maquina)
        FROM inserted i;
    END

    -- Validar que litros sean razonables (no más de 500 por carga)
    IF EXISTS (SELECT 1 FROM inserted WHERE litros_cargados > 500)
    BEGIN
        RAISERROR(
            'ADVERTENCIA COMBUSTIBLE-001: Se registraron mas de 500 litros en una sola carga. Verifique el dato.',
            10, 1  -- severidad 10: advertencia, no cancela
        );
    END
END;
GO

-- ──────────────────────────────────────────────────────────
-- TRIGGER D: Al cancelar un contrato,
--            liberar todas las máquinas asociadas
-- ──────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_LiberarMaquinariaAlCancelarContrato
ON Contratos_ContratoAlquiler
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(estado_contrato)
    BEGIN
        -- Si el contrato pasa a Cancelado o Cerrado
        IF EXISTS (SELECT 1 FROM inserted
                   WHERE estado_contrato IN ('Cancelado','Cerrado'))
        BEGIN
            -- Liberar todas las máquinas del contrato
            UPDATE Maquinaria_Maquinaria
            SET estado_equipo = 'Disponible'
            FROM Maquinaria_Maquinaria m
            JOIN Contratos_DetalleContrato dc ON m.id_maquinaria = dc.id_maquinaria
            JOIN inserted i ON dc.id_contrato = i.id_contrato
            WHERE m.estado_equipo = 'Alquilado'
              AND i.estado_contrato IN ('Cancelado','Cerrado');

            -- Registrar en bitácora
            INSERT INTO Seguridad_Bitacora
                (tabla_afectada, accion, id_registro_afectado,
                 valor_anterior, valor_nuevo, nombre_usuario)
            SELECT
                'Contratos_ContratoAlquiler', 'UPDATE',
                i.id_contrato,
                CONCAT('{"estado_anterior":"', d.estado_contrato, '"}'),
                CONCAT('{"estado_nuevo":"',    i.estado_contrato,
                       '","maquinarias_liberadas":"SI"}'),
                SYSTEM_USER
            FROM inserted i
            JOIN deleted d ON i.id_contrato = d.id_contrato
            WHERE i.estado_contrato IN ('Cancelado','Cerrado');
        END
    END
END;
GO

-- ──────────────────────────────────────────────────────────
-- TRIGGER E: Verificar que no se alquile la misma máquina
--            en dos contratos activos al mismo tiempo
-- ──────────────────────────────────────────────────────────
CREATE OR ALTER TRIGGER trg_ValidarMaquinaSinDobleAlquiler
ON Contratos_DetalleContrato
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;

    -- Buscar si esa máquina ya está en otro detalle de contrato activo
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Contratos_DetalleContrato dc
            ON i.id_maquinaria = dc.id_maquinaria
           AND i.id_detalle   <> dc.id_detalle  -- diferente fila
        JOIN Contratos_ContratoAlquiler ca
            ON dc.id_contrato = ca.id_contrato
        WHERE ca.estado_contrato = 'Activo'
          AND dc.fecha_devolucion IS NULL  -- aún no devuelta
    )
    BEGIN
        -- Revertir el INSERT
        DELETE FROM Contratos_DetalleContrato
        WHERE id_detalle IN (SELECT id_detalle FROM inserted);

        RAISERROR(
            'ERROR ALQUILER-003: Esa maquinaria ya esta asignada a otro contrato ACTIVO sin fecha de devolucion. No se puede alquilar dos veces al mismo tiempo.',
            16, 1
        );
        RETURN;
    END
END;
GO

-- ============================================================
-- PRUEBAS DE LOS NUEVOS TRIGGERS
-- ============================================================

-- Prueba Trigger A: Devolución libera máquina
PRINT '-- TRIGGER A: Devolucion de maquinaria';
UPDATE Contratos_DetalleContrato
SET fecha_devolucion = CAST(GETDATE() AS DATE)
WHERE id_detalle = 12002;  -- JD310L del contrato 11002
SELECT estado_equipo FROM Maquinaria_Maquinaria WHERE id_maquinaria=3006;
-- ✓ Debe mostrar: Disponible
GO

-- Prueba Trigger B: No trasladar máquina alquilada

PRINT '-- TRIGGER B: No trasladar maquinaria alquilada';
BEGIN TRY
    INSERT INTO Operaciones_TrasladoMaquinaria
        (id_maquinaria,id_ruta,id_vehiculo_transporte,id_conductor,
         id_contrato,fecha_salida,fecha_llegada_estimada,estado_traslado)
    VALUES (3001,19000,18000,5007,11001,
            GETDATE(),DATEADD(HOUR,5,GETDATE()),'Programado');
    PRINT 'ERROR: No bloqueó traslado de máquina alquilada';
END TRY
BEGIN CATCH
    PRINT '✓ CORRECTO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Prueba Trigger C: Combustible registra en analítica
PRINT '-- TRIGGER C: Combustible se guarda en Analítica';
DECLARE @count_antes INT, @count_despues INT;
SELECT @count_antes = COUNT(*) FROM Analitica_CostoOperativo
WHERE tipo_costo='Combustible';

INSERT INTO Mantenimiento_RegistroCombustible
    (id_maquinaria,id_empleado,id_proveedor,fecha_carga,
     litros_cargados,tipo_combustible,costo_por_litro,
     horas_maquina,proveedor_combustible)
VALUES (3004,5013,1001,GETDATE(),200,'Diesel',32.50,640,'Prueba trigger C');

SELECT @count_despues = COUNT(*) FROM Analitica_CostoOperativo
WHERE tipo_costo='Combustible';

IF @count_despues > @count_antes
    PRINT '✓ CORRECTO: Combustible registrado en Analítica';
ELSE
    PRINT 'SIN CONTRATO ACTIVO: La máquina 3004 no tiene contrato activo actualmente';
GO

-- Prueba Trigger D: Cancelar contrato libera máquinas

select * from Contratos_ContratoAlquiler


PRINT '-- TRIGGER D: Cancelar contrato libera máquinas';
-- Ver estado antes
select  estado_contrato, numero_contrato, id_contrato from Contratos_ContratoAlquiler where id_contrato=11009

UPDATE Contratos_ContratoAlquiler
SET estado_contrato='Cancelado', fecha_fin_real='2025-04-15'
WHERE id_contrato=11009;

-- Ver estado después
select  estado_contrato, numero_contrato, id_contrato from Contratos_ContratoAlquiler where id_contrato=11009
-- ✓ Debe mostrar: Disponible
-- Revertir para no dañar datos
UPDATE Contratos_ContratoAlquiler
SET estado_contrato='Activo',fecha_fin_real= NULL WHERE id_contrato=11009;
GO

-- ============================================================
-- RESUMEN FINAL — Ver bitácora de todas las pruebas
-- ============================================================
SELECT
    b.nombre_usuario     AS usuario,
    b.tabla_afectada     AS tabla,
    b.accion,
    b.id_registro_afectado,
    b.valor_anterior,
    b.valor_nuevo,
    b.fecha_hora
FROM Seguridad_Bitacora b
WHERE b.fecha_hora >= DATEADD(HOUR,-1,GETDATE())
ORDER BY b.fecha_hora DESC;
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------


-- VISTA 1
-- Vista general de maquinaria.
-- =====================================================
CREATE VIEW vw_maquinaria_general AS
SELECT M.id_maquinaria,
MM.nombre_modelo,
M.numero_serie,
M.estado_equipo
FROM Maquinaria_Maquinaria M
INNER JOIN Maquinaria_ModeloMaquinaria MM
ON M.id_modelo = MM.id_modelo;
GO

-- VISTA 2
-- Vista de empleados activos.
-- =====================================================
CREATE VIEW vw_empleados_activos AS
SELECT nombre,
apellido,
salario_actual
FROM RRHH_Empleado
WHERE estado = 'Activo';
GO

-- VISTA 3
-- Vista de contratos activos.
-- =====================================================
CREATE VIEW vw_contratos_activos AS
SELECT numero_contrato,
valor_total,
estado_contrato
FROM Contratos_ContratoAlquiler
WHERE estado_contrato = 'Activo';
GO

-- VISTA 4
-- Vista de clientes.
-- =====================================================
CREATE VIEW vw_clientes AS
SELECT razon_social,
telefono,
correo
FROM Contratos_Cliente;
GO

-- VISTA 5
-- Vista de pagos realizados.
-- =====================================================

CREATE VIEW vw_pagos AS
SELECT id_pago,
monto_pagado,
fecha_pago
FROM Contratos_Pago;
GO

-- VISTA 6
-- Vista de mantenimiento.
-- =====================================================
CREATE VIEW vw_mantenimiento AS
SELECT id_orden_mant,
fecha_programada,
costo_total
FROM Mantenimiento_OrdenMantenimiento;
GO

-- VISTA 7
-- Vista de costos operativos.
-- =====================================================

CREATE VIEW vw_costos_operativos AS
SELECT monto,
tipo_costo, anio
FROM Analitica_CostoOperativo;
GO

-- VISTA 8
-- Vista de combustible.
-- =====================================================

CREATE VIEW vw_combustible AS
SELECT fecha_carga,
litros_cargados
FROM Mantenimiento_RegistroCombustible;
GO

-- VISTA 9
-- Vista de incidentes.
-- =====================================================

CREATE VIEW vw_incidentes AS
SELECT descripcion,
fecha_hora_ocurrencia
FROM Incidentes_Incidente;
GO

-- VISTA 10
-- Vista de usuarios.
-- =====================================================

CREATE VIEW vw_usuarios AS
SELECT username,
activo
FROM Seguridad_UsuarioSistema;
GO

-- VISTA 11
-- Vista de proveedores.
-- =====================================================
select * from Proveedor_Proveedor
CREATE VIEW vw_proveedores AS 
SELECT nombre_empresa,
telefono_principal
FROM Proveedor_Proveedor as vw;
GO

-- VISTA 12
-- Vista de traslados.
-- =====================================================
CREATE VIEW vw_traslados AS
SELECT id_traslado,
fecha_salida
FROM Operaciones_TrasladoMaquinaria;
GO

-- VISTA 13
-- Vista de facturación.
-- =====================================================
select * from Contratos_Factura
CREATE VIEW vw_facturacion AS
SELECT numero_factura,
monto_total
FROM Contratos_Factura;
GO

-- VISTA 14
-- Vista de auditoría.
-- =====================================================

CREATE VIEW vw_bitacora AS
SELECT valor_nuevo,
accion
FROM Seguridad_Bitacora;
GO

-- VISTA 15
-- Vista de rutas.
-- =====================================================
CREATE VIEW vw_rutas AS
SELECT nombre_ruta,
distancia_km
FROM Operaciones_Ruta;
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @id_contrato INT = 5;
DECLARE @id_maquinaria INT = 102;
DECLARE @fecha_entrega DATE = '2026-06-01';
DECLARE @fecha_devolucion DATE = '2026-06-15';
DECLARE @tarifa DECIMAL(10,2) = 150.00;
DECLARE @dias INT = 14;

BEGIN TRANSACTION;

    -- 1. Bloqueamos el contrato maestro para edición. 
    -- Nadie más puede modificar este contrato ni cerrarlo mientras decidimos.
    CREATE PROCEDURE sp_InsertarDetalleContratoSeguro
    @id_contrato INT,
    @id_maquinaria INT,
    @fecha_entrega DATE,
    @fecha_devolucion DATE,
    @tarifa_diaria DECIMAL(10,2),
    @dias_contratados INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- 1. Bloqueamos el contrato maestro
            DECLARE @estado VARCHAR(20);
            SELECT @estado = estado_contrato 
            FROM Contratos_ContratoAlquiler WITH (UPDLOCK, HOLDLOCK)
            WHERE id_contrato = @id_contrato;

            IF @estado <> 'Activo'
            BEGIN
                THROW 51000, 'El contrato no está activo, no se pueden añadir elementos.', 1;
            END

            -- 2. Verificación de seguridad: Evitar doble reserva de la máquina
            IF EXISTS (
                SELECT 1 
                FROM Contratos_DetalleContrato WITH (UPDLOCK, HOLDLOCK)
                WHERE id_maquinaria = @id_maquinaria
                  AND (@fecha_entrega <= fecha_devolucion OR fecha_devolucion IS NULL)
                  AND (@fecha_devolucion >= fecha_entrega)
            )
            BEGIN
                THROW 51000, 'La maquinaria ya se encuentra rentada para esas fechas.', 1;
            END

            -- 3. Insertar el detalle si todo está bien
            INSERT INTO Contratos_DetalleContrato (id_contrato, id_maquinaria, fecha_entrega, fecha_devolucion, tarifa_diaria, dias_contratados)
            VALUES (@id_contrato, @id_maquinaria, @fecha_entrega, @fecha_devolucion, @tarifa_diaria, @dias_contratados);

            -- 4. Actualizar el valor total del contrato maestro
            UPDATE Contratos_ContratoAlquiler
            SET valor_total = valor_total + (@tarifa_diaria * @dias_contratados)
            WHERE id_contrato = @id_contrato;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si algo falla, deshacemos los cambios para seguridad
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        -- Reenviamos el error para que la aplicación se entere
        THROW;
    END CATCH
END;

GO

EXEC sp_InsertarDetalleContratoSeguro 
    @id_contrato = 11000, -- <--- AQUÍ PON EL ID REAL QUE ENCONTRASTE
    @id_maquinaria = 99, 
    @fecha_entrega = '2026-06-01', 
    @fecha_devolucion = '2026-06-10', 
    @tarifa_diaria = 100.00, 
    @dias_contratados = 9;









    -------------------------------------------------------------------------------------------------------------
    SELECT
    b.id_bitacora,
    b.nombre_usuario    AS usuario_que_cambio,
    b.tabla_afectada    AS tabla,
    b.accion,
    b.id_registro_afectado,
    b.valor_anterior,
    b.valor_nuevo,
    b.fecha_hora
FROM Seguridad_Bitacora b
WHERE b.nombre_usuario IN (
    'usuario_administrador',
    'usuario_gerente',
    'usuario_supervisor'
)
ORDER BY b.fecha_hora DESC;
GO