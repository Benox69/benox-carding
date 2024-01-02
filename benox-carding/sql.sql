CREATE TABLE `available_cards` (
  `card_number` varchar(19) NOT NULL,
  `ccv` int(3) NOT NULL,
  `date` varchar(10) NOT NULL,
  `money` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
