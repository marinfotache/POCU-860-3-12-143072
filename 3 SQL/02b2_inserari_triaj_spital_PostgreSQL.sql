﻿/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- Script pentru popularea bazei de date TRIAJ. Sintaxa PostgreSQL


DELETE FROM triaj ;
DELETE FROM pacienti ;
DELETE FROM  garzi ;
DELETE FROM  doctori ;

INSERT INTO doctori VALUES (1, 'Vasilcu Ionel', 'chirurgie', DATE'1965-11-11') ;
INSERT INTO doctori VALUES (2, 'Georgescu Mircea', 'hepatologie', DATE'1966-01-12') ;
INSERT INTO doctori VALUES (3, 'Zahir Tudorel', 'chirurgie', DATE'1965-11-11') ;
INSERT INTO doctori VALUES (4, 'Bostan Vasile', 'cardiologie', DATE'1965-11-11') ;
INSERT INTO doctori VALUES (5, 'Popescu Ionela', 'boli interne', DATE'1965-11-11') ;

INSERT INTO garzi VALUES (1, TIMESTAMP'2008-01-03 7:00:00', TIMESTAMP'2008-01-03 18:59:59') ;
INSERT INTO garzi VALUES (2, TIMESTAMP'2008-01-03 19:00:00', TIMESTAMP'2008-01-04 6:59:59') ;
INSERT INTO garzi VALUES (3, TIMESTAMP'2008-01-04 07:00:00', TIMESTAMP'2008-01-04 17:59:59') ;
INSERT INTO garzi VALUES (4, TIMESTAMP'2008-01-04 18:00:00', TIMESTAMP'2008-01-05 05:59:59') ;
INSERT INTO garzi VALUES (1, TIMESTAMP'2008-01-05 6:00:00', TIMESTAMP'2008-01-05 13:59:59') ;
INSERT INTO garzi VALUES (2, TIMESTAMP'2008-01-05 14:00:00', TIMESTAMP'2008-01-05 21:59:59') ;
INSERT INTO garzi VALUES (5, TIMESTAMP'2008-01-05 22:00:00', TIMESTAMP'2008-01-06 8:59:59') ;


INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (1, 'Stroe Mihaela', 2601228390834, 'Bd. Cantemir, 32, Bl.G4, Sc.C, Ap.4', 'MR366766') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (2, 'Buzatu Corneliu', 1650512370514, 'Str. Desprimaveririi, 112', 'MX456783') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (3, 'Spineanu Marius', 5010101380625, 'Bd. Stefan cel Mare, 4, Bl.I1, Sc.A, Ap.24', 'MX213345') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (4, 'Bagdasar Adela', 2601002250611, 'Str. Primaverii, 17', 'MX345678') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (5, 'Ionascu Ionelia', 6001122390199, 'Str. Florilor', 'MX654322') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (6, 'Popescu Maria-Mirabela', 2721231300888, 'Bd. 22 Decembrie, 2, Bl.5, Sc.B, Ap.21', 'MX765432') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (7, 'Stroescu Mihaela Oana', 6020719120545, 'Str. Lenei Nr. 234', 'MX876567') ;
INSERT INTO pacienti (idpacient,numepacient, cnp, adresa, serie_nr_act_identitate)
	VALUES (8, 'Cazan Ana Maria', 2690202200345, 'Bd. Independentei, 87, Bl.K3, Sc.A, Ap.34', 'MX987789') ;

INSERT INTO triaj VALUES (1, TIMESTAMP'2008-01-03 7:18:00', 1, 'dureri de stomac intense', NULL, 'boli interne');
INSERT INTO triaj VALUES (2, TIMESTAMP'2008-01-03 8:45:00', 2, 'febra puternica, varsaturi', 'penicilina', 'boli interne');
INSERT INTO triaj VALUES (3, TIMESTAMP'2008-01-03 12:45:00', 3, 'deranjament stomacal', 'scobutil', NULL);
INSERT INTO triaj VALUES (4, TIMESTAMP'2008-01-03 20:45:00', 4, 'palpitatii cardiace', 'linistin', 'cardiologie');
INSERT INTO triaj VALUES (5, TIMESTAMP'2008-01-04 1:28:00', 5, 'plaga profunda picior drept', 'antibiotice, pansament', NULL);
INSERT INTO triaj VALUES (6, TIMESTAMP'2008-01-04 10:45:00', 3, 'contractii stomacale, varsaturi', NULL, 'boli interne');
INSERT INTO triaj VALUES (7, TIMESTAMP'2008-01-04 11:20:00', 7, 'fata de culoare galbena, ameteli', NULL, 'hepatologie');
INSERT INTO triaj VALUES (8, TIMESTAMP'2008-01-04 22:45:00', 8, 'dureri articulare', 'scobutil', NULL);
INSERT INTO triaj VALUES (9, TIMESTAMP'2008-01-05 6:18:00', 5, 'febra puternica, delir', 'penicilina', 'chirurgie');

