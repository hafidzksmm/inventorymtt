-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2025 at 12:50 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mttech`
--

-- --------------------------------------------------------

--
-- Table structure for table `asset_jual`
--

CREATE TABLE `asset_jual` (
  `id` int(11) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `jenis` varchar(255) NOT NULL,
  `ukuran` varchar(255) NOT NULL,
  `dimensi` varchar(255) NOT NULL,
  `qty` int(11) NOT NULL,
  `satuan` varchar(255) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `asset_jual`
--

INSERT INTO `asset_jual` (`id`, `nama_barang`, `jenis`, `ukuran`, `dimensi`, `qty`, `satuan`, `lokasi`, `created_at`) VALUES
(76, 'Kabel listrik', 'Serabut', '24,6M', '3 x 6mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(77, 'Kabel listrik', 'Serabut', '5M', '4 x 6mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(78, 'Kabel listrik', 'Serabut', '2M (4Pcs)', '5 x 6mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(79, 'Kabel listrik', 'Tunggal', '2M ', '3 x 2,5 mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(80, 'Kabel listrik', 'Tunggal', '2,5M', '4 x 2,5 mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(81, 'Kabel listrik', 'Tunggal', '3M', '5 x 2,5 mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(82, 'Kabel listrik', 'Tunggal', '5M', '3 x 6 mm', 1, 'pcs', 'power', '2025-10-15 03:26:31'),
(83, 'kabel patchcord', 'Kabel utp', '1M', '', 82, 'pcs', 'management', '2025-10-15 03:26:31'),
(84, 'kabel patchcord', 'Kabel utp', '1,5M', '', 2, 'pcs', 'management', '2025-10-15 03:26:31'),
(85, 'kabel patchcord', 'Kabel utp', '2,5M', '', 1, 'pcs', 'management', '2025-10-15 03:26:31'),
(86, 'kabel patchcord', 'Kabel utp', '3M', '', 10, 'pcs', 'management', '2025-10-15 03:26:31'),
(87, 'kabel patchcord', 'lc to lc', '1M', '', 45, 'pcs', 'data', '2025-10-15 03:26:31'),
(88, 'kabel patchcord', 'lc to lc', '1,5M', '', 34, 'pcs', 'data', '2025-10-15 03:26:31'),
(89, 'kabel patchcord', 'lc to lc', '3M', '', 187, 'pcs', 'data', '2025-10-15 03:26:31'),
(90, 'kabel patchcord', 'lc to lc', '5M', '', 4, 'pcs', 'data', '2025-10-15 03:26:31'),
(91, 'kabel patchcord', 'lc to lc', '10M', '', 16, 'pcs', 'data', '2025-10-15 03:26:31'),
(92, 'kabel patchcord', 'lc to lc', '30M', '', 1, 'pcs', 'data', '2025-10-15 03:26:31'),
(93, 'kabel patchcord', 'lc to lc', '50M', '', 2, 'pcs', 'data', '2025-10-15 03:26:31'),
(94, 'Modul\r\n(Transceiver)', 'SFP', '1G', 'Dell', 6, 'pcs', 'data', '2025-10-15 04:25:27'),
(95, 'Modul\r\n(Transceiver)', 'SFP', '1G', 'FINISAR', 2, 'pcs', 'data', '2025-10-15 04:25:27'),
(96, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Dell', 4, 'pcs', 'data', '2025-10-15 04:25:27'),
(97, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'D-Link', 42, 'pcs', 'data', '2025-10-15 04:25:27'),
(98, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Edge-Core', 6, 'pcs', 'data', '2025-10-15 04:25:27'),
(99, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Huawei', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(100, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Lenovo', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(101, 'Modul\r\n(Transceiver)', 'SFP+', '25G', 'Dell', 9, 'pcs', 'data', '2025-10-15 04:25:27'),
(102, 'Modul\r\n(Transceiver)', 'Konverter \r\nSFP to RJ45', '1G', 'Copper', 2, 'pcs', 'data', '2025-10-15 04:25:27'),
(103, 'Modul\r\n(Transceiver)', 'Konverter \r\nSFP to RJ46', '1G', 'Nokia', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(104, 'Modul\r\n(Transceiver)', 'Konverter \r\nSFP to RJ47', '1G', 'Avago', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(105, 'Modul\r\n(Transceiver)', 'Konverter \r\nSFP to RJ48', '1G', 'Linktel', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(106, 'Modul\r\n(Transceiver)', 'Konverter \r\nSFP to RJ49', '10 G', 'NETLINE', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(107, 'Modul\r\n(Transceiver)', 'QSFP', '100G', 'Dell', 10, 'pcs', 'data', '2025-10-15 04:25:27'),
(108, 'Modul\r\n(Transceiver)', 'MPO', '100G', 'Dell', 4, 'pcs', 'data', '2025-10-15 04:25:27'),
(109, 'Konverter\r\nVGA', 'Mini DP to VGA', '', '', 48, 'pcs', 'data', '2025-10-15 04:25:27'),
(110, 'Konverter\r\nVGA', '', '', '', 33, 'pcs', 'data', '2025-10-15 04:25:27'),
(111, 'RAM', '16GB', '', '', 316, 'pcs', 'data', '2025-10-15 04:25:27'),
(112, 'RAM', '4GB', '', '', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(113, 'Kabel\r\nKVM', 'Digital', '', '', 5, 'pcs', 'data', '2025-10-15 04:25:27'),
(114, 'Kabel\r\nKVM', 'IP', '', '', 5, 'pcs', 'data', '2025-10-15 04:25:27'),
(115, 'Kabel\r\nKVM', 'Analog', '', '', 123, 'pcs', 'data', '2025-10-15 04:25:27'),
(116, 'Kabel\r\nKVM', 'PS/2', '', '', 5, 'pcs', 'data', '2025-10-15 04:25:27'),
(117, 'Kabel\r\nKVM', 'DAC', '', '', 1, 'pcs', 'data', '2025-10-15 04:25:27'),
(118, 'Hard disk', 'SAS 2.5 inc', '1.2 TB', 'HGST', 2, 'pcs', 'data', '2025-10-15 04:25:27');

-- --------------------------------------------------------

--
-- Table structure for table `inventaris`
--

CREATE TABLE `inventaris` (
  `id` int(11) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `merk` varchar(255) NOT NULL,
  `deskripsi` varchar(1000) NOT NULL,
  `dimensi` varchar(255) NOT NULL,
  `qty` int(11) NOT NULL,
  `satuan` varchar(255) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inventaris`
--

INSERT INTO `inventaris` (`id`, `nama_barang`, `merk`, `deskripsi`, `dimensi`, `qty`, `satuan`, `lokasi`, `created_at`) VALUES
(620, 'Mobil', 'Mitsubisi Xpander Exceed', 'Transmisi Matic 1500cc, 7 seats', '459x175x175cm', 1, 'unit', 'Teras Depan', '2025-10-10 03:22:39'),
(621, 'Motor', 'Honda Beat deluxe keyless', '110cc', '187x67x108cm', 1, 'unit', 'Teras Depan', '2025-10-10 03:22:39'),
(622, 'Layar Interaktif', 'Acer Model Acer ALTOS IWB86', 'OS: Android 13 ram 4gb storage 32gb, Windows 11 homesl, RAM 8GB, Storage 256GB, Processor Intel i7-1185G7', '196x25x117cm', 1, 'unit ', 'Ruang Staff', '2025-10-10 03:22:39'),
(623, 'Bracket', 'Acer', 'Bracket besi Acer', '107x66x150cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(624, 'Laptop', 'Macbook', 'Processor Apple M3, RAM 16GB, SSD 512GB\n(Andy, Ridhon)', '31 x 21 x 2 cm', 2, 'unit', 'Ruang Staff', '2025-10-10 03:27:49'),
(625, ' Laptop', 'Lenovo model V14G3iAP', ' Intel® Core™ i3-1215U, Ram 8GB DDR4, 256GB SSD\n(Bayu, Andika, Yosep)', '32 x 21 x 20cm', 3, 'unit', 'Ruang Teknis', '2025-10-10 03:28:28'),
(626, ' Laptop', 'Acer Aspire One 722', 'CPU :AMD Dual-Core c60. 2GB/ 320GB', '29x20x4cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(627, ' Laptop', 'Lenovo model V14G3iAP', ' Intel® Core™ i3-1215U, Ram 8GB DDR4, 256GB SSD\n(Rani, Aida)', '32 x 21 x 20cm', 2, 'unit', 'Ruang Admin', '2025-10-10 03:28:52'),
(628, ' Laptop', 'Lenovo model V14G3iAP', ' Intel® Core™ i3-1215U, Ram 8GB DDR4, 256GB SSD\n(Angky)', '32 x 21 x 20cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:29:27'),
(629, 'Mini PC', 'Intel NUC7i7BNH', 'Windows 10, RAM 16GB, Storage 512GB, Processor Intel i7-7567U', '10x10x5cm', 1, 'unit ', 'Ruang Staff', '2025-10-10 03:22:39'),
(630, ' Monitor', 'Weyon WY-A24', ' HD 1680x1050, HDMI, VGA, RF, AV, USB, Remote', '74x8x44cm', 1, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(631, ' Monitor', 'Xiaomi', 'Dolby Audio, HDMI, VGA 50W', '72x42cm', 2, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(632, ' Monitor', '  Tagvision', 'Respone Time 5ms, Wide, 1920x1080 FULL HD', '56x5x34cm', 2, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(633, 'Monitor ', '  LG LED 19EN33', '18.5inch, 1366*768, Aspect Ratio 16:9', '44x3x27cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(634, 'AC', '  Daikin FTK025UVM4', '1 PK, 9000 BTU/h, 810 Watt', '77x22x23cm', 1, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(635, 'AC', '  Gree', 'Standard 1 PK', '74x22x23cm', 1, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(636, 'AC', '  Daikin FTKQ50UVMA', '2 PK, 17.100 BTU/h, 1800W', '77x22x23cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(637, 'AC', '  Daikin FTKQ25UVM4', '1 PK, 9000 BTU/h, 810 Watt', '77x22x23cm', 1, 'unit', 'Ruang Admin', '2025-10-10 03:22:39'),
(638, 'AC', '  Daikin FTKQ15UVM4', '1/2 PK, 5.100 BTU/h, 420W', '28 x 77 x 22cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(639, ' Firewall', 'Shopos XGS 136', 'RAM & Storage: 8 GB RAM, 64 GB SSD, Ports: 10x GbE, 2x 2.5GbE (PoE), 2x SFP (fiber), VPN IPsec: 6.3 Gbps, 30-60W', '32x22x5cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(640, 'Router WiFi', '  Tenda AC7', 'WiFi dual-band AC1200 (WiFi 5), 1xWAN, 3xLAN', '22x15x4cm', 1, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(641, 'Router WiFi', '  Dlink dir 612  N300', '5 MODE, kecepatan hingga 300Mbps ', '18x15x 3cm', 2, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(642, 'Router WiFi', '  Totolink AC 1200 Wireless', 'Dual-band, Kecepatan 300Mbps', ' 11 x 6 x 7 cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(643, 'Router WiFi', '  Dlink DIR-615', '1 WAN, 4 LAN', '18x13x3cm', 1, 'unit', 'Ruang Admin', '2025-10-10 03:22:39'),
(644, 'Router WiFi', '  Dlink DIR-822 AC 1200', 'High speeds of up to 867Mbps (5GHz) and 300Mbps (2.4GHz)', '44x25x15cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(645, 'Router', 'Mikrotik HUBLite RB941-2nD', 'RAM 32MB, Flash 16MB, 4 × RJ-45 10/100 Mbps, 5V, 3W', '12x9x3cm', 2, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(646, 'Router', 'Mikrotik Model RB4011', 'RAM 1GB, Flash MB NAND, 10 × Gigabit RJ-45 ports, 1 port SFP+ (10 Gbps)', '23x12x3cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(647, ' Printer', 'EPSON L3250', 'Print, Scan & Copy, 5760 x 1440 dpi, 12/0.7 Watt', '37x34x18cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(648, ' NVR', 'NVR1108HS-W-S2', '8 Record Channel, Storage 8TB', '26x5x23cm', 1, 'unit ', 'Ruang Staff', '2025-10-10 03:22:39'),
(649, 'CCTV', 'V380 Y33', '2MP, Full HD, Night Vision, Motion Detect', '8.6 x 8.5 x 11 cm', 1, 'unit', 'Ruang Staff', '2025-10-10 03:22:39'),
(650, 'CCTV', 'V380 Y33', '2MP, Resolusi 1080p,Night Vision, Motion Detect', '8.6 x 8.5 x 11 cm', 2, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(651, 'CCTV', 'V380 Y33', '2MP, Full HD, Night Vision, Motion Detect', '8.6 x 8.5 x 11 cm', 3, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(652, 'CCTV', 'Imou', 'Night Vision, Motion Detect', '8.6 x 8.5 x 11 cm', 2, 'unit', 'Balkon Depan', '2025-10-10 03:22:39'),
(653, 'Modem Starlink', 'VTR-211', 'Wi-Fi Technology 802.11ac Dual Band, Teknologi Wi-Fi Standar IEEE 802.11a/b/g/n/ac, Wi-Fi 5, WPA2', '19x6x26cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(654, 'Dish Starlink', 'Strarlink', 'IP54, 50-75 W, Bidang Pandang 110°, Orientasi Mandiri dengan Motor', '31x51x45cm', 1, 'unit', 'Balkon Depan', '2025-10-10 03:22:39'),
(655, 'Paper Shredder', 'Deli ET101SC', 'Kapasitas Tabung : 10 Liter,  Kapasitas Penghancuran 6 lembar A4 70 gsm', '31x11x37cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(656, 'Smartlock', 'Taffhome model XR24-Black', 'Unlock with PIN, Card, and Fingerprint', '17x7x37cm', 1, 'unit', 'Gudang', '2025-10-10 03:22:39'),
(657, 'Power Supply', '60-12', 'model out=12v ihp =185-240v AC 50hz', '8x11x4cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(658, 'Power Supply', 'PSU S120 12', 'AC Input 110/220V, DC Output 12V 10A', '8x11x4cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(659, 'Bor Battery', '  Gtools GT04', '3 mode drill (sekrup, besi , beton / impact palu), dinamo racing brushless high rpm 2200', '21x17x6cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(660, 'Access Door', 'Hikvision DS-K1T320MFK', '2.4-inch LCD Display Fingerprint Access Control Terminal, Built-in Mifare card reading module, Communication: TCP/IP，EHome; 1000 users, 1000 fingerprints, 1000 card and Max. 100,000 event records;', '13x14x5cm', 1, 'unit', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(661, 'Dispenser', 'Toshiba RWF-W1917TN(K)', '3 Tempereatur Setting, Child Safety Lock, 2 Liter', '31x36x100cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(662, 'Dispenser', 'Arasi model ABD04C-Black', 'Hot water and Cool Water', '40x36x109cm', 1, 'pcs', 'Gudang', '2025-10-10 03:22:39'),
(663, 'Kipas', 'Sanex SF-1208B', 'Besi alumunium, 45W, 220V', '44x44x140cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(664, 'Kipas', 'Cosmos 16XDC', '3 mode kecepatan', '44x44x100cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(665, 'Sofa', '-', 'Warna abu-abu, bahan kayu, busa dan kain', '183x37x85cm', 1, 'set', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(666, 'Extend sofa', '-', 'Warna abu-abu, bahan kayu, busa dan kain', '70x95x43cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(667, 'Kursi', 'Informa', 'Kuris putar 360 derajat, Roda anti selip', '60x60x95cm', 4, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(668, 'Kursi Kerja', 'Informa', 'Kuris putar 360 derajat, Roda anti selip', '60x50x94cm', 2, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(669, 'Kursi kerja', 'Informa', 'Kuris putar 360 derajat, Roda anti selip', '61x50x97cm', 3, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(670, 'Kursi Tamu', 'Informa', 'bahan besi, busa dan kayu, dilenkai dengan senderan', '53x53x76cm', 2, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(671, 'Kursi Meeting', 'Informa', 'Kursi lipat, bahan besi', '45x95cm', 6, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(672, 'Kursi Resepsionis', 'Informa', 'bahan besi dan busa', '36x36x47cm', 2, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(673, 'Meja', '-', 'Bahan Kayu dengam 4 Laci  ', '160x80x75cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(674, 'Meja', '-', 'Bahan Kayu dengam 4 Laci  ', '160x85x76cm', 2, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(675, 'Meja', '-', 'Bahan kaca, kayu dan kain', '70x40x41cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(676, 'Meja kerja', 'Informa', 'Bahan HPL', '120x60x76cm', 2, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(677, 'Meja Kerja', 'Informa', 'Bahan HPL', ' 120x60x76cm', 2, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(678, 'Meja Kerja', 'Informa', 'Bahan HPL', ' 140x74x76cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(679, 'Meja Tamu', 'Informa', 'Kaca dengan 3 kaki', ' 42x42x53cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(680, 'Meja Meeting ', 'Informa', 'Bahan kayu dan besi, bisa di bongkar  ', '220x120x75cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(681, 'Lemari Plastik', 'TABITHA', '8 pintu, bisa di rakit', '50x42x144cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(682, 'Lemari Plastik', 'TABITHA', '6 pintu, bisa di rakit', '50x52x112cm', 2, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(683, 'Lemari Besi', 'Informa', '5 Pintu, bahan besi dan kaca', '120x40x185cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(684, 'Lemari Besi', 'Informa', 'Dapat di bongkar, tatakan bahan hpl, 4 tingkat', '80x40x180cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(685, 'Lemari Plastik', 'TABITHA', '8 pintu, bisa di rakit', '50x43x144cm', 2, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(686, 'Lemari Besi', 'Informa', 'Bahan besi dan kaca, 4 pintu', ' 80x40x180cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(687, 'Lemari Besi Kecil', 'Informa', 'Bahan besi, 2 Pintu', ' 91x45x75cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(688, 'Rak Besi', '-', ' Bisa di rakit, bahan besi dan stainless, dengan 4 roda', '71x34x125cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(689, 'Rak Besi', '-', 'Bahan full besi, bisa di bongkar, 5 tingkatan', '100x50x201cm', 2, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(690, 'Rak Besi', '-', 'Dapat di bongkar, tatakan bahan hpl, 4 tingkat', '119x40x197cm', 2, 'pcs', 'Gudang', '2025-10-10 03:22:39'),
(691, 'Rak Kecil', '-', 'Rangka besi dan tatakan bahan HPL', '50x25x97cm', 1, 'pcs', 'Gudang', '2025-10-10 03:22:39'),
(692, 'Rak piring', '-', 'bahan stainless', '39x24x31cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(693, 'Rak Sepatu Kecil', 'Calista', 'Bahan Plastik', '56x26x41cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(694, 'Rak Sepatu besar', '-', 'Bahan Plastik', '63x27x65cm', 2, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(695, 'Rak Barang', '-', 'Bahan besi dan plastik', '35x20x87cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(696, 'Rak Sepatu besar', '-', 'bahan besi dan kan, bisa di rakit', '56x27x123cm', 1, 'pcs', 'Teras Depan', '2025-10-10 03:22:39'),
(697, 'Rak sepatu kecil', 'Calista', 'bahan plastik bisa di rakit', '58x22x47cm', 1, 'pcs', 'Teras Depan', '2025-10-10 03:22:39'),
(698, 'Tas Toolkit Kecil', 'Taffware', 'Material kain', '36x21x21cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(699, 'Tas Toolkit Besar', 'Taffware', 'Material kan, dengan 8 kantong di bagian samping', '52x27x30cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(700, 'White Board Besar', '-', 'Papan tulis putih Dinding', '245x123cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(701, 'White Board Kecil', '-', 'Papan tulis putih Dinding', '61x41cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(702, 'White Board', '-', 'Papan tulis putih Dinding', '245x123cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(703, 'Box S', 'AKAKO Karbon Box', 'Bahan Plastik, dengan kuncian di tutupnya', '38x24x22cm', 4, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(704, 'Box M', 'AKAKO Karbon Box', 'Bahan Plastik, dengan kuncian di tutupnya', '44x30x27cm', 3, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(705, 'Box L', 'AKAKO Karbon Box', 'Bahan Plastik, dengan kuncian di tutupnya', '60x39x36cm', 4, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(706, 'Box XL', 'AKAKO Karbon Box', 'Bahan Plastik, dengan kuncian di tutupnya', '65x50x45cm', 3, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(707, 'Tempat Sampah', 'Komet Star', 'Bahan Plastik', '27x27x53cm', 1, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(708, 'Tempat Sampah', 'Yutaka', 'Bahan Plastik', '23x31x65cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(709, 'Tempat Sampah', 'Yutaka', 'Bahan Plastik', '33x37x69cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(710, 'Tempat Sampah', 'Yutaka', 'Bahan Plastik, diameter 100cm', '54x42x85cm', 1, 'pcs', 'Teras Depan', '2025-10-10 03:22:39'),
(711, 'Box Tissue', '-', 'Bahan plastik dengan design minimalis', '22x13x10cm', 2, 'pcs', 'Ruang Staff', '2025-10-10 03:22:39'),
(712, 'Box Tissue', '-', 'Bahan plastik dengan design minimalis', '22x13x10cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(713, 'Troli', '-', 'Bahan besi, Roda 4', '90x45x25cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(714, 'Tangga portable', 'MLHY', 'Dapat di atur ketinggiannya, portabel', '69x18x89cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(715, 'Vacum Cleaner', 'Model YCQ-2022S', '1800W, 220V 50Hz, Stainless steel  18L', '33x33x42cm', 1, 'unit', 'Ruang Teknis', '2025-10-10 03:22:39'),
(716, 'Pengharum Ruangan', '  Stella', 'Stella Matic, timer otomatis', '11x9x21cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(717, 'Pengharum Ruangan', '  Stella', 'Stella Matic, timer otomatis', '11x9x21cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(718, 'Bell', 'OEM RB-C847 ', '3 mode pilihan suara, bahan plastik, 4 tingkatan volume suara', '6x4x3cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(719, 'Obeng kit', 'Jakemy Tools', 'Lengkap dengan macam- macam jenis mata obeng', '23x6x17cm', 1, 'set', 'Ruang Teknis', '2025-10-10 03:22:39'),
(720, 'Ordner', 'Benex', 'foldable, system pengunci H-lock', '7x28x35cm', 8, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(721, 'Ordner', 'Bantex', 'foldable, system pengunci H-lock', '10x27x35cm', 3, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(722, 'Pembolong Kertas', '  Joyko PHJ-30XL', ' Pembolong Kertas Kecil No 30 XL - 2 Lubang', '10.2x4.6x6cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(723, 'Pembolong Kertas', '  Kenko', 'Material baja, 2 lubang, 7mm', '11x16x8cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(724, 'Gunting', 'Joyko SC 838 ', 'Stainless Steel', '16x6cm', 1, 'pcs', 'Ruang Teknis', '2025-10-10 03:22:39'),
(725, 'Gunting', 'Joyko', 'Stainless Steel', '16x6cm', 2, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(726, 'Streppless', 'Kenko', 'Bahan Stainless Steel', '44 x 9.5 x 26 cm', 2, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(727, 'Cutter', 'ReType L-500', 'High Quality auto lock', '16x4cm', 2, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(728, 'Ruller', 'Butterfly ', 'Penggaris 30cm material Acrylic', '30cm', 2, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(729, 'Stempel', 'INK Stamp', 'Stempel logo Media Touch Technology K17', '4,1x7,6cm', 1, 'pcs', 'Ruang Admin', '2025-10-10 03:22:39'),
(730, 'Dekorasi MTT Besar', '-', 'Dilengkapi dengan lampu hiasan', '56x27x123cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(731, 'Dekorasi MTT Kecil', '-', 'Dilengkapi dengan lampu hiasan', '58x22x47cm', 1, 'pcs', 'Ruang Resepsionis', '2025-10-10 03:22:39'),
(732, 'Sapu', '2 macan', 'Sapu ijuk', 'panjang 110cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(733, 'Sapu', '2 macan', 'Sapu ijuk', 'panjang 118cm', 3, 'pcs', 'Teras Depan', '2025-10-10 03:22:39'),
(734, 'Pengki', 'Apolo', 'bahan plastik', 'panjang 100cm', 1, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(735, 'Pel', '-', 'bahan serat kain', 'panjang 150cm', 3, 'pcs', 'Teras Depan', '2025-10-10 03:22:39'),
(736, 'Galon', 'Galon Cleo', '15L', '40x10x50cm', 5, 'pcs', 'Dapur', '2025-10-10 03:22:39'),
(737, 'Jemuran', '-', 'bahan stainless, bisa di bongkar pasang', '177x12x120cm', 1, 'pcs', 'Balkon Belakang', '2025-10-10 03:22:39');

-- --------------------------------------------------------

--
-- Table structure for table `inventaryprojek`
--

CREATE TABLE `inventaryprojek` (
  `id` int(11) NOT NULL,
  `item_barang` varchar(255) NOT NULL,
  `jenis` varchar(255) NOT NULL,
  `tipe` varchar(255) NOT NULL,
  `merk` varchar(255) NOT NULL,
  `ukuran` varchar(255) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inventaryprojek`
--

INSERT INTO `inventaryprojek` (`id`, `item_barang`, `jenis`, `tipe`, `merk`, `ukuran`, `jumlah`, `lokasi`, `created_at`) VALUES
(232, 'Kabel Listrik', 'Serabut', '3 x 6mm', '', '24,6M', 1, 'POWER', '2025-10-15 03:48:00'),
(233, 'Kabel Listrik', 'Serabut', '4 x 6mm', '', '5M', 1, 'POWER', '2025-10-15 03:48:00'),
(234, 'Kabel Listrik', 'Serabut', '5 x 6mm', '', '2M (4Pcs)', 1, 'POWER', '2025-10-15 03:48:00'),
(235, 'Kabel Listrik', 'Tunggal', '3 x 2,5mm', '', '2M ', 1, 'POWER', '2025-10-15 03:48:00'),
(236, 'Kabel Listrik', 'Tunggal', '4 x 2,5mm', '', '2,5M', 1, 'POWER', '2025-10-15 03:48:00'),
(237, 'Kabel Listrik', 'Tunggal', '5 x 2,5mm', '', '3M', 1, 'POWER', '2025-10-15 03:48:00'),
(238, 'Kabel Listrik', 'Tunggal', '3 x 6mm', '', '5M', 1, 'POWER', '2025-10-15 03:48:00'),
(239, 'Kabel Power', 'C13', '', '', '', 78, 'POWER', '2025-10-15 03:48:00'),
(240, 'Kabel Power', 'C13 to C14', '', '', '', 33, 'POWER', '2025-10-15 03:48:00'),
(241, 'Kabel Power', 'C19 to C20', '', '', '', 9, 'POWER', '2025-10-15 03:48:00'),
(242, 'Industrial\r\nSocket', 'Male', '', '', '', 3, 'POWER', '2025-10-15 03:48:00'),
(243, 'Industrial\r\nSocket', 'Female', '', '', '', 0, 'POWER', '2025-10-15 03:48:00'),
(244, 'Industrial\r\nSocket', '1 Set', '', '', '', 1, 'POWER', '2025-10-15 03:48:00'),
(245, 'Konektor', 'C14', '', '', '', 23, 'POWER', '2025-10-15 03:48:00'),
(246, 'Konektor', 'C20', '', '', '', 1, 'POWER', '2025-10-15 03:48:00'),
(247, 'Kabel\r\nUTP', 'Pabrikan', 'Abu-Abu', '', '1M', 84, 'MANAGEMENT', '2025-10-15 03:48:00'),
(248, 'Kabel\r\nUTP', '', 'Biru', '', '3M', 9, 'MANAGEMENT', '2025-10-15 03:48:00'),
(249, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '1M', 3, 'MANAGEMENT', '2025-10-15 03:48:00'),
(250, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '2M', 2, 'MANAGEMENT', '2025-10-15 03:48:00'),
(251, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '3M', 7, 'MANAGEMENT', '2025-10-15 03:48:00'),
(252, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '5M', 3, 'MANAGEMENT', '2025-10-15 03:48:00'),
(253, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '6,5M', 1, 'MANAGEMENT', '2025-10-15 03:48:00'),
(254, 'Kabel\r\nUTP', 'Crafting', 'Potongan\r\nMentah', '', '7,5M', 1, 'MANAGEMENT', '2025-10-15 03:48:00'),
(255, 'Kabel\r\nUTP', 'Crafting', 'Non \r\nPlugboots', '', '1M', 0, 'MANAGEMENT', '2025-10-15 03:48:00'),
(256, 'Kabel\r\nUTP', 'Crafting', 'Non \r\nPlugboots', '', '2M', 12, 'MANAGEMENT', '2025-10-15 03:48:00'),
(257, 'Kabel\r\nUTP', 'Crafting', 'Non \r\nPlugboots', '', '3M', 1, 'MANAGEMENT', '2025-10-15 03:48:00'),
(258, 'Kabel\r\nUTP', 'Crafting', 'Non \r\nPlugboots', '', '4M', 4, 'MANAGEMENT', '2025-10-15 03:48:00'),
(259, 'Kabel\r\nUTP', 'Crafting', 'Non \r\nPlugboots', '', '8M', 0, 'MANAGEMENT', '2025-10-15 03:48:00'),
(260, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '1M', 0, 'MANAGEMENT', '2025-10-15 03:48:00'),
(261, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '2M', 12, 'MANAGEMENT', '2025-10-15 03:48:00'),
(262, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '3M', 0, 'MANAGEMENT', '2025-10-15 03:48:00'),
(263, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '4M', 20, 'MANAGEMENT', '2025-10-15 03:48:00'),
(264, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '5M', 13, 'MANAGEMENT', '2025-10-15 03:48:00'),
(265, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '5,5M', 1, 'MANAGEMENT', '2025-10-15 03:48:00'),
(266, 'Kabel\r\nUTP', 'Crafting', 'Plugboots\r\n+\r\nKonektor', '', '7,5M', 1, 'MANAGEMENT', '2025-10-15 03:48:00'),
(267, 'Konektor', 'RJ45', '', '', '', 1450, 'MANAGEMENT', '2025-10-15 03:48:00'),
(268, 'Kabel UTP', 'Dus', '', '', '', 2, 'MANAGEMENT', '2025-10-15 03:48:00'),
(269, 'Plugboots', '', 'Hitam', '', '', 300, 'MANAGEMENT', '2025-10-15 03:48:00'),
(270, 'Plugboots', '', 'Abu-Abu', '', '', 200, 'MANAGEMENT', '2025-10-15 03:48:00'),
(271, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '1M', 43, 'DATA', '2025-10-15 03:48:00'),
(272, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '1,5M', 35, 'DATA', '2025-10-15 03:48:00'),
(273, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '3M', 199, 'DATA', '2025-10-15 03:48:00'),
(274, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '5M', 4, 'DATA', '2025-10-15 03:48:00'),
(275, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '10M', 14, 'DATA', '2025-10-15 03:48:00'),
(276, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '30M', 1, 'DATA', '2025-10-15 03:48:00'),
(277, 'Kabel\r\nPatchcord', 'LC to LC', '', '', '50M', 2, 'DATA', '2025-10-15 03:48:00'),
(278, 'Modul\r\n(Transceiver)', 'SFP+', '1G', 'Dell', '', 6, 'DATA', '2025-10-15 03:48:00'),
(279, 'Modul\r\n(Transceiver)', 'SFP+', '1G', 'FINISAR', '', 2, 'DATA', '2025-10-15 03:48:00'),
(280, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Dell', '', 4, 'DATA', '2025-10-15 03:48:00'),
(281, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'D-Link', '', 17, 'DATA', '2025-10-15 03:48:00'),
(282, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Edge-Core', '', 3, 'DATA', '2025-10-15 03:48:00'),
(283, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Huawei', '', 1, 'DATA', '2025-10-15 03:48:00'),
(284, 'Modul\r\n(Transceiver)', 'SFP+', '10G', 'Lenovo', '', 1, 'DATA', '2025-10-15 03:48:00'),
(285, 'Modul\r\n(Transceiver)', 'SFP+', '25G', 'Dell', '', 1, 'DATA', '2025-10-15 03:48:00'),
(286, 'Modul\r\n(Transceiver)', 'RJ45', '1G', 'Copper', '', 4, 'DATA', '2025-10-15 03:48:00'),
(287, 'Modul\r\n(Transceiver)', 'RJ45', '1G', 'Nokia', '', 1, 'DATA', '2025-10-15 03:48:00'),
(288, 'Modul\r\n(Transceiver)', 'RJ45', '1G', 'Avago', '', 1, 'DATA', '2025-10-15 03:48:00'),
(289, 'Modul\r\n(Transceiver)', 'RJ45', '1G', 'Linktel', '', 1, 'DATA', '2025-10-15 03:48:00'),
(290, 'Modul\r\n(Transceiver)', 'RJ45', '10 G', 'NETLINE', '', 1, 'DATA', '2025-10-15 03:48:00'),
(291, 'Modul\r\n(Transceiver)', 'QSFP', '100G', 'Dell', '', 10, 'DATA', '2025-10-15 03:48:00'),
(292, 'Modul\r\n(Transceiver)', 'MPO', '100G', 'Dell', '', 4, 'DATA', '2025-10-15 03:48:00'),
(293, 'Konverter\r\nVGA', 'Mini DP to VGA', 'Hitam', '', '', 48, 'DLL', '2025-10-15 03:48:00'),
(294, 'Konverter\r\nVGA', '', 'Putih', '', '', 33, 'DLL', '2025-10-15 03:48:00'),
(295, 'RAM', '16GB', '', '', '', 310, 'DLL', '2025-10-15 03:48:00'),
(296, 'RAM', '4GB', '', '', '', 1, 'DLL', '2025-10-15 03:48:00'),
(297, 'Kabel\r\nKVM', 'Digital', '', '', '', 4, 'DLL', '2025-10-15 03:48:00'),
(298, 'Kabel\r\nKVM', 'IP', '', '', '', 5, 'DLL', '2025-10-15 03:48:00'),
(299, 'Kabel\r\nKVM', 'Analog', '', '', '', 107, 'DLL', '2025-10-15 03:48:00'),
(300, 'Kabel\r\nKVM', 'PS/2', '', '', '', 5, 'DLL', '2025-10-15 03:48:00'),
(301, 'Kabel\r\nKVM', 'DAC', '', '', '', 1, 'DLL', '2025-10-15 03:48:00'),
(302, 'Kabel Ties', '', 'Kecil', '', '3,6 x 150', 8, 'DLL', '2025-10-15 03:48:00'),
(303, 'Kabel Ties', '', 'Sedang', '', '7,6 x 300', 4, 'DLL', '2025-10-15 03:48:00'),
(304, 'Kabel Ties', '', 'Besar', '', '7,6 x 500', 11, 'DLL', '2025-10-15 03:48:00'),
(305, 'Hard disk', '', 'HGST', '', '1,2 TB', 2, 'DLL', '2025-10-15 03:48:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'apis', 'apis@gmail.com', '$2b$10$fO2SjqWET4CaAEPUtWfJE.FLvL99StZWYs2XdondJGCcAmi2IJVKm', 'user', '2025-10-16 10:25:25'),
(7, 'nuzul', 'nuzul@gmail.com', '$2b$10$R6UOyr27XlJnJr/WqqIbP.dRkfnxdD.YH1zuoNwVfZaEhk.r6mDbG', 'user', '2025-10-16 10:25:47'),
(8, 'otepganz', 'otep@mttech.co.id', '$2b$10$jyta/OpL38HaCXNZbP7tQOYveJVsgiMuLtlk7qjYqQUkG9vakeW.W', 'admin', '2025-10-16 10:29:01'),
(9, 'alpin', 'alpin@m.com', '$2b$10$GWbeMEiUz9aK8NMF9mzMpee8g3clS6FSrYK0uESdPZnEYSUzIQlsm', 'user', '2025-10-16 10:39:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asset_jual`
--
ALTER TABLE `asset_jual`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventaris`
--
ALTER TABLE `inventaris`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventaryprojek`
--
ALTER TABLE `inventaryprojek`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asset_jual`
--
ALTER TABLE `asset_jual`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `inventaris`
--
ALTER TABLE `inventaris`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=771;

--
-- AUTO_INCREMENT for table `inventaryprojek`
--
ALTER TABLE `inventaryprojek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
