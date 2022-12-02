/* FOR ESX */
ALTER TABLE `users` ADD `adventcalendar` LONGTEXT DEFAULT '[]';

/* FOR QBCORE */
ALTER TABLE `players` ADD `adventcalendar` LONGTEXT DEFAULT '[]';