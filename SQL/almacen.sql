-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-02-2026 a las 12:18:59
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `almacen`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `OfertasxPais` (`procedencia` CHAR(30), `dto` INT)   BEGIN
SELECT nombreproducto as PRODUCTO, precio as "PRECIO", precio-precio*(dto/100) as "OFERTA %", pais as PAIS FROM productos WHERE pais = procedencia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Productos_del_proveedor` (`proveedor` CHAR(9))   BEGIN
SELECT nombreproducto, descripcion, pais FROM productos WHERE CIF = proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Productos_stock` (`cantidad` INT)   BEGIN
SELECT nombreproducto, descripcion, pais FROM productos WHERE stock < cantidad;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `costepais` (`procedencia` VARCHAR(30)) RETURNS INT(11)  BEGIN
DECLARE numero INT;
select sum(precio*stock) into numero from productos group by procedencia having productos.pais = procedencia;
RETURN numero;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `cuantos` (`nacion` VARCHAR(30)) RETURNS INT(11)  BEGIN
DECLARE N, numero INT;
select count(*) into numero from productos where (pais = nacion);
Set N = numero;
RETURN N;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `valorproductospais` (`procedencia` VARCHAR(30)) RETURNS INT(11)  BEGIN
DECLARE numero INT;
select sum(precio*stock) into numero from productos group by pais having pais = procedencia;
RETURN numero;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `valorxpais` (`procedencia` VARCHAR(30)) RETURNS INT(11)  BEGIN
DECLARE numero INT;
select sum(precio*stock) into numero from productos group by procedencia having procedencia;
RETURN numero;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `valorxprocede` (`procedencia` VARCHAR(30)) RETURNS INT(11)  BEGIN
DECLARE numero INT;
select sum(precio*stock) into numero from productos group by procedencia having procedencia in (select distinct pais from productos where pais = procedencia);

RETURN numero;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `generapedido`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `generapedido` (
`Proveedor` varchar(30)
,`Producto` varchar(30)
,`Unidades` bigint(12)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historico`
--

CREATE TABLE `historico` (
  `ID` int(11) NOT NULL,
  `login` varchar(30) NOT NULL,
  `passw` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nomape` varchar(50) NOT NULL,
  `poblacion` varchar(50) DEFAULT NULL,
  `telefono` varchar(9) DEFAULT NULL,
  `imagen` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `historico`
--

INSERT INTO `historico` (`ID`, `login`, `passw`, `email`, `nomape`, `poblacion`, `telefono`, `imagen`) VALUES
(103, '22222222N', 'fb77679472331e0296215ba6206d1293', 'mabosa@gmail.com', 'Manuela Bono Sánchez', 'Adra', '606334618', 'historico/20260118-120109_22222222N.jpg'),
(104, '23344567V', '93a0a0ef175a74a0ab3f5087b607d5de', 'marupe@mail.com', 'María Ruiz Pérez', 'Adra', '654123474', 'historico/20260118-120107_23344567V.jpg'),
(107, '32324456K', '93a0a0ef175a74a0ab3f5087b607d5de', 'juloga2@gmai.com', 'Julia López Garcés', 'Adra', '695231472', 'historico/20260115-070105_32324456K.jpg'),
(110, '34444222N', '93a0a0ef175a74a0ab3f5087b607d5de', 'ansifer@gmail.com', 'Antonio Sierra Fernández', 'Roquetas de Mar', '606284618', 'historico/20260118-120123_34444222N.jpg'),
(113, '44444444G', '93a0a0ef175a74a0ab3f5087b607d5de', 'ansava@gmail.com', 'Antonio Sánchez Vazquez', 'El Ejido', '537975312', 'historico/20260118-120155_44444444G.jpg'),
(116, '45454545H', '6a52797885494d535fe7ab99e9902045', 'mibalo@mail.com', 'Miguel Baena López', 'Roquetas de Mar', '606284618', 'historico/20260115-070157_45454545H.JPG'),
(121, '12121212F', '6a52797885494d535fe7ab99e9902045', 'misaco@mail.com', 'Miguel Sanz Contreras', 'Suflí', '678665444', 'historico/20260118-120134_12121212F.png'),
(131, '21212121f', '6a52797885494d535fe7ab99e9902045', 'malovi@mail.com', 'María López Vicente', 'Adra', '660556443', 'historico/20260115-070141_21212121F.jpg');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `pedidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `pedidos` (
`nombreproducto` varchar(30)
,`precio` float
,`stock` int(11)
,`Proveedor` char(9)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `prodprov`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `prodprov` (
`PRODUCTO` varchar(30)
,`PROVEEDOR` varchar(30)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombreproducto` varchar(30) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `precio` float DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `foto` varchar(100) DEFAULT NULL,
  `pais` varchar(30) DEFAULT NULL,
  `CIF` char(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombreproducto`, `descripcion`, `precio`, `stock`, `foto`, `pais`, `CIF`) VALUES
(1, 'Procesadores i5', 'Procesadores intel i5', 90, 50, '1_i5.png', 'Corea', 'A12121212'),
(2, 'Disco SSD 1T Kinstong', 'Disco duro 1T Kinstong', 80, 10, '2_ssd-K1.png', 'España', 'B34343434'),
(3, 'Procesador Rizen 7', 'Procesador AMD Rizen 7', 150, 90, '3_ryzen7.png', 'China', 'B34343434'),
(4, 'Rartón logitech cable', 'Ratón óptico con cable', 7, 100, '4_ratonlogitech.png', 'Japón', 'A12121212'),
(5, 'Impresora Laserjet M209d', 'Impresora láser monocromo para oficina', 90, 10, '5_impresora.png', 'Japón', 'C56565656'),
(11, 'Smartwatch huawei', 'Reloj inteligente de la marca huawei whatch gt5', 190, 5, '11_Smartwatch.png', 'Corea', 'A12121212'),
(12, 'USB 32Gb Kinstong', 'Memoria USB Kinstong de 32Gb de capacidad', 12, 10, '12_USB32K.png', 'España', 'B34343434'),
(13, 'USB 16GB Kinstong', 'Memoria USB Kinstong de 16Gb de capacidad', 8, 9, '13_USB16K.png', 'China', 'B34343434'),
(14, 'Ratón wireless SIN cable', 'Ratón óptico SIN cable con conexión wireless, por bluetooth y recargable', 9, 10, '14_ratonwireless.jpg', 'Japón', 'A12121212'),
(15, 'Base dock externa', 'Base dock externa para conectar discos al pc por USB', 90, 10, '15_basedock.png', 'Japón', 'C56565656');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `CIFprov` char(9) NOT NULL,
  `nombreprov` varchar(30) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `nacionalidad` varchar(30) DEFAULT NULL,
  `representante` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`CIFprov`, `nombreprov`, `direccion`, `nacionalidad`, `representante`, `email`, `telefono`) VALUES
('A12121212', 'Zara', 'C/ Luz 5', 'España', 'A. Pérez', 'aperez@mail.com', '612121212'),
('B34343434', 'Mercadona', 'C/ Luna 3', 'España', 'C. García', 'cgarcia@mail.com', '634343434'),
('B67676767', 'MICROSOFT', 'C/ Luna 23', 'Estadounidense', 'B. Gates', 'microsoft@mail.com', '950676767'),
('C56565656', 'Carrefour', 'C/ Sol 1', 'España', 'J. Sánchez', 'jsanchez@mail.com', '656565656'),
('Q3435367J', 'El Corte Inglés', 'Avda de los ingleses, 34', 'Española', 'Paco López', 'cingles@mail.com', '950323636');

--
-- Disparadores `proveedores`
--
DELIMITER $$
CREATE TRIGGER `altaprov` AFTER INSERT ON `proveedores` FOR EACH ROW BEGIN 
INSERT INTO usuarios (login, passw, email, nomape, telefono, imagen) VALUES (NEW.CIFProv, md5("cambiarlaclave") , NEW.nombreprov, NEW.email, NEW.telefono, CONCAT("imagenes/",NEW.CIFProv, "PNG")); 
END
$$
DELIMITER ;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `login` varchar(30) NOT NULL,
  `passw` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nomape` varchar(50) NOT NULL,
  `poblacion` varchar(50) DEFAULT NULL,
  `telefono` varchar(9) DEFAULT NULL,
  `imagen` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `login`, `passw`, `email`, `nomape`, `poblacion`, `telefono`, `imagen`) VALUES
(101, '17513693N', 'fd66a24e5ae306aa6ced0e1207add8ce', 'albosi@gmail.com', 'Alfonso Bonillo Sierra', 'Roquetas de Mar', '606284618', 'imagenes/17513693N.png'),
(102, '21122113N', 'fb77679472331e0296215ba6206d1293', 'enradu@mail.com', 'Enrique Ramirez Duran', 'El Ejido', '603212445', 'IMAGENES/21122113N.JPG'),
(105, '24444222N', 'fd66a24e5ae306aa6ced0e1207add8ce', 'malogo@mail.com', 'Manuel López Gómez', 'Roquetas de Mar', '606060606', 'imagenes/24444222N.png'),
(106, '27513693N', '93a0a0ef175a74a0ab3f5087b607d5de', 'camilo@gmail.com', 'Carlos Miranda López', 'Roquetas de Mar', '606284618', 'imagenes/27513693N.jpg'),
(108, '33333333H', '93a0a0ef175a74a0ab3f5087b607d5de', 'magaga@mail.com', 'Mario García García', 'Cádiz', '665554443', 'imagenes/33333333H.jpg'),
(111, '34455654V', '93a0a0ef175a74a0ab3f5087b607d5de', 'andosa@mail.com', 'Antonio Dominguez Sánchez', 'Adra', '68899902', 'imagenes/34455654V.png'),
(112, '42622143M', '93a0a0ef175a74a0ab3f5087b607d5de', 'anruma@gmail.com', 'Ángela Ruiz Martínez', 'Vícar', '426221143', 'imagenes/42622143M.png'),
(114, '56655665F', '6a52797885494d535fe7ab99e9902045', 'juheva@mail.com', 'Juan Hernández Valle', 'Adra', '655449009', 'imagenes/56655665F.png'),
(124, '89898989F', '6a52797885494d535fe7ab99e9902045', 'jugaji@mail.com', 'Julian García Jiménez', 'La Puebla', '640334226', 'imagenes/89898989F.png'),
(125, '56565643G', '6a52797885494d535fe7ab99e9902045', 'franga@gmail.com', 'Francisco Antón García', 'Roquetas de Mar', '606284618', 'imagenes/56565643G.png'),
(128, '11223332G', '6a52797885494d535fe7ab99e9902045', 'franga@gmail.com', 'Francisca García', 'Roquetas de Mar', '060628461', 'imagenes/111222111G.png'),
(130, '111222333H', '6a52797885494d535fe7ab99e9902045', 'misato@mail.com', 'IES TURANIANA', 'Roquetas de Mar', '060628461', 'imagenes/111222333H.png'),
(135, '36766766T', '7d5c861599dda092bf59234f6fe57e64', 'alfbon@mail.com', 'ALF BON', NULL, '950667667', 'imagenes/66766766T.PNG'),
(137, 'B67676767', '7d5c861599dda092bf59234f6fe57e64', 'microsoft@mail.com', 'MICROSOFT', NULL, '950676767', 'imagenes/B67676767.png'),
(138, 'B67676767', '7d5c861599dda092bf59234f6fe57e64', 'microsoft@mail.com', 'MICROSOFT', NULL, '950676767', 'imagenes/B67676767.png');

-- --------------------------------------------------------

--
-- Estructura para la vista `generapedido`
--
DROP TABLE IF EXISTS `generapedido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `generapedido`  AS 
SELECT `proveedores`.`nombreprov` AS `Proveedor`, `pedidos`.`nombreproducto` AS `Producto`, `pedidos`.`stock`* 3 AS `Unidades` 
FROM (`pedidos` join `proveedores`) WHERE `proveedores`.`CIFprov` = `pedidos`.`Proveedor` ORDER BY `proveedores`.`nombreprov` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `pedidos`
--
DROP TABLE IF EXISTS `pedidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pedidos`  AS 
SELECT `productos`.`nombreproducto` AS `nombreproducto`, `productos`.`precio` AS `precio`, `productos`.`stock` AS `stock`, `productos`.`CIF` AS `Proveedor` 
FROM `productos` 
WHERE `productos`.`stock` <= 20 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `prodprov`
--
DROP TABLE IF EXISTS `prodprov`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `prodprov`  AS 
SELECT `productos`.`nombreproducto` AS `PRODUCTO`, `proveedores`.`nombreprov` AS `PROVEEDOR` 
FROM (`productos` join `proveedores`) 
WHERE `productos`.`CIF` = `proveedores`.`CIFprov` 
ORDER BY `proveedores`.`nombreprov` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `historico`
--
ALTER TABLE `historico`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `CIF_idx` (`CIF`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`CIFprov`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `historico`
--
ALTER TABLE `historico`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=139;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `CIF` FOREIGN KEY (`CIF`) REFERENCES `proveedores` (`CIFprov`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
