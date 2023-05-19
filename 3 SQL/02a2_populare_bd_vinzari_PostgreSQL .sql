﻿/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- Script pentru popularea bazei de date VANZARI. Sintaxa PostgreSQL


DELETE FROM incasfact ;
DELETE FROM incasari ;
DELETE FROM liniifact ;
DELETE FROM facturi ;
DELETE FROM produse ;
DELETE FROM persclienti ;
DELETE FROM persoane ;
DELETE FROM clienti ;
DELETE FROM coduri_postale ;
DELETE FROM judete ;

INSERT INTO judete VALUES ('IS', 'Iasi', 'Moldova');
INSERT INTO judete VALUES ('VN', 'Vrancea', 'Moldova');
INSERT INTO judete VALUES ('NT', 'Neamt', 'Moldova');
INSERT INTO judete VALUES ('SV', 'Suceava', 'Moldova');
INSERT INTO judete VALUES ('VS', 'Vaslui', 'Moldova');
INSERT INTO judete VALUES ('TM', 'Timis', 'Banat');
INSERT INTO judete VALUES ('DJ', 'Dolj', 'Oltenia');

INSERT INTO coduri_postale VALUES ('700505', 'Iasi', 'IS');
INSERT INTO coduri_postale VALUES ('701150', 'Pascani', 'IS');
INSERT INTO coduri_postale VALUES ('706500', 'Vaslui', 'VS');
INSERT INTO coduri_postale VALUES ('705300', 'Focsani', 'VN');
INSERT INTO coduri_postale VALUES ('706400', 'Birlad', 'VS');
INSERT INTO coduri_postale VALUES ('705800', 'Suceava', 'SV');
INSERT INTO coduri_postale VALUES ('705550', 'Roman', 'NT');
INSERT INTO coduri_postale VALUES ('701900', 'Timisoara', 'TM');

INSERT INTO clienti VALUES (1001, 'Client 1 SRL', 'R1001', 'Tranzitiei, 13 bis', '700505', NULL) ;
INSERT INTO clienti (codcl, dencl, codfiscal, codpost, telefon) VALUES (1002,'Client 2 SA', 'R1002', '700505', '0232212121') ;
INSERT INTO clienti VALUES (1003, 'Client 3 SRL', 'R1003', 'Prosperitatii, 22',
    '706500','0235222222') ;
INSERT INTO clienti (codcl, dencl, adresa, codpost)
    VALUES (1004, 'Client 4', 'Sapientei, 56', '701150') ;
INSERT INTO clienti VALUES (1005, 'Client 5 SRL', 'R1005', NULL,
    '701900', '0567111111')  ;
INSERT INTO clienti VALUES (1006, 'Client 6 SA', 'R1006', 'Pacientei, 33',
    '705550', NULL)  ;
INSERT INTO clienti VALUES (1007, 'Client 7 SRL', 'R1007', 'Victoria Capitalismului, 2',
    '701900', '0567121212')  ;


INSERT INTO persoane VALUES ('CNP1', 'Ioan', 'Vasile', 'I.L.Caragiale, 22',	'B',
    '700505', '123456', '987654', '0742222222', NULL)  ;
INSERT INTO persoane VALUES ('CNP2', 'Vasile', 'Ion', NULL,	'B',
    '700505', '234567', '876543', '0794222223', 'Ion@a.ro')  ;
INSERT INTO persoane VALUES ('CNP3', 'Popovici', 'Ioana', 'V.Micle, Bl.I, Sc.B,Ap.2', 'F',
    '701150', '345678', NULL, '0744222224', NULL)  ;
INSERT INTO persoane VALUES ('CNP4', 'Lazar', 'Caraion', 'M.Eminescu, 42', 'B',
    '706500', '456789', NULL, '0235222225', NULL)  ;
INSERT INTO persoane VALUES ('CNP5', 'Iurea', 'Simion', 'I.Creanga, 44 bis', 'B',
    '706500', '567890', '543210', NULL, NULL)  ;
INSERT INTO persoane VALUES ('CNP6', 'Vasc', 'Simona', 'M.Eminescu, 13', 'F',
    '701150', NULL, '432109', '0794222227', NULL) ;
INSERT INTO persoane VALUES ('CNP7', 'Popa', 'Ioanid', 'I.Ion, Bl.H2, Sc.C, Ap.45', 'B',
    '701900', '789012', '321098', NULL, NULL) ;
INSERT INTO persoane VALUES ('CNP8', 'Bogacs', 'Ildiko', 'I.V.Viteazu, 67', 'F',
    '705550', '890123', '210987', '0722222299', NULL) ;
INSERT INTO persoane VALUES ('CNP9', 'Ioan', 'Vasilica', 'Garii, Bl.B4, Sc.A, Ap.1', 'F',
    '701900', '901234', '109876', '0779422223', NULL) ;

INSERT INTO persclienti VALUES ('CNP1', 1001, 'Director general')  ;
INSERT INTO persclienti VALUES ('CNP2', 1002, 'Director general')  ;
INSERT INTO persclienti VALUES ('CNP3', 1002, 'Sef aprovizionare')  ;
INSERT INTO persclienti VALUES ('CNP4', 1003, 'Sef aprovizionare')  ;
INSERT INTO persclienti VALUES ('CNP5', 1003, 'Director financiar')  ;
INSERT INTO persclienti VALUES ('CNP6', 1004, 'Director general')  ;
INSERT INTO persclienti VALUES ('CNP7', 1005, 'Sef aprovizionare')  ;
INSERT INTO persclienti VALUES ('CNP8', 1006, 'Director financiar')  ;
INSERT INTO persclienti VALUES ('CNP9', 1007, 'Sef aprovizionare')  ;

INSERT INTO produse VALUES (1, 'Produs 1','buc', 'Tigari', .24) ;
INSERT INTO produse VALUES (2, 'Produs 2','kg', 'Bere', 0.12) ;
INSERT INTO produse VALUES (3, 'Produs 3','kg', 'Bere', 0.24) ;
INSERT INTO produse VALUES (4, 'Produs 4','l', 'Dulciuri', .12) ;
INSERT INTO produse VALUES (5, 'Produs 5','buc', 'Tigari', .24) ;
INSERT INTO produse VALUES (6, 'Produs 6','p250g', 'Cafea', .24) ;

INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1111, DATE'2013-08-01', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (1112, DATE'2013-08-01', 1005, 'Probleme cu transportul');
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1113, DATE'2013-08-01', 1002);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1114, DATE'2013-08-01', 1006);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1115, DATE'2013-08-02', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (1116, DATE'2013-08-02', 1007, 
	'Pretul propus initial a fost modificat');
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1117, DATE'2013-08-03', 1001);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1118, DATE'2013-08-04', 1001);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1119, DATE'2013-08-07', 1003);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1120, DATE'2013-08-07', 1001);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1121, DATE'2013-08-07', 1004);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (1122, DATE'2013-08-07', 1005);


INSERT INTO facturi (nrfact, datafact, codcl) VALUES (2111, DATE'2013-08-14', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (2112, DATE'2013-08-14', 1005,
        'Probleme cu transportul');
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (2113, DATE'2013-08-14', 1002);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (2115, DATE'2013-08-15', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (2116, DATE'2013-08-15', 1007,
        'Pretul propus initial a fost modificat');
INSERT INTO facturi (nrfact, datafact, codcl)
    VALUES (2117, DATE'2013-08-16', 1001);
INSERT INTO facturi (nrfact, datafact, codcl)
    VALUES (2118, DATE'2013-08-16', 1001);
INSERT INTO facturi (nrfact, datafact, codcl)
    VALUES (2119, DATE'2013-08-21', 1003);
INSERT INTO facturi (nrfact, datafact, codcl)
    VALUES (2121, DATE'2013-08-21', 1004);
INSERT INTO facturi (nrfact, datafact, codcl)
    VALUES (2122, DATE'2013-08-22', 1005);


INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3111, DATE'2013-09-01', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (3112, DATE'2013-09-01', 1005,
        'Probleme cu transportul');
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3113, DATE'2013-09-02', 1002);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3115, DATE'2013-09-02', 1001);
INSERT INTO facturi (nrfact, datafact, codcl, obs) VALUES (3116, DATE'2013-09-10', 1007,
        'Pretul propus initial a fost modificat');
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3117, DATE'2013-09-10', 1001);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3118, DATE'2013-09-17', 1001);
INSERT INTO facturi (nrfact, datafact, codcl) VALUES (3119, DATE'2013-10-07', 1003);


INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1111, 1, 1, 50, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1111, 2, 2, 75, 1050) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1111, 3, 5, 500, 7060) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1112, 1, 2, 80, 1030) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1112, 2, 3, 40, 750) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1113, 1, 2, 100, 975) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1114, 1, 2, 70, 1070) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1114, 2, 4, 30, 1705) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1114, 3, 5, 700, 7064) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1115, 1, 2, 150, 925) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1116, 1, 2, 125, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1117, 1, 2, 100, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1117, 2, 1, 100, 950) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1118, 1, 2, 30, 1100) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1118, 2, 1, 150, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1119, 1, 2, 35, 1090) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1119, 2, 3, 40, 700) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1119, 3, 4, 50, 1410) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1119, 4, 5, 750, 6300) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1120, 1, 2, 80, 1120) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1121, 1, 5, 550, 7064) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (1121, 2, 2, 100, 1050) ;

INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2111, 1, 1, 57, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2111, 2, 2, 79, 1050) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2111, 3, 5, 510, 7060) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2112, 1, 2, 85, 1030) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2112, 2, 3, 65, 750) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2113, 1, 2, 120, 975) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2115, 1, 2, 110, 925) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2116, 1, 2, 135, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2117, 1, 2, 150, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2117, 2, 1, 110, 950) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2118, 1, 2, 39, 1100) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2118, 2, 1, 120, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2119, 1, 2, 35, 1090) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2119, 2, 3, 40, 700) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2119, 3, 4, 55, 1410) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2119, 4, 5, 755, 6300) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2121, 1, 5, 550, 7064) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (2121, 2, 2, 103, 1050) ;


INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3111, 1, 1, 57, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3111, 2, 2, 79, 1050) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3111, 3, 5, 510, 7060) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3112, 1, 2, 85, 1030) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3112, 2, 3, 65, 750) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3113, 1, 2, 120, 975) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3115, 1, 2, 110, 925) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3116, 1, 2, 135, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3117, 1, 2, 150, 1000) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3117, 2, 1, 110, 950) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3118, 1, 2, 39, 1100) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3118, 2, 1, 120, 930) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3119, 1, 2, 35, 1090) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3119, 2, 3, 40, 700) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3119, 3, 4, 55, 1410) ;
INSERT INTO liniifact (nrfact, linie, codpr, cantitate, pretunit) VALUES (3119, 4, 5, 755, 6300) ;


INSERT INTO incasari VALUES (1234, DATE'2013-08-12', 'OP', '121', DATE'2013-08-10' ) ;
INSERT INTO incasari VALUES (1235, DATE'2013-08-18', 'CEC', '212', DATE'2013-08-17') ;
INSERT INTO incasari VALUES (1236, DATE'2013-09-07', 'OP', '321', DATE'2013-09-05') ;
INSERT INTO incasari VALUES (1237, DATE'2013-09-08', 'CEC', '445', DATE'2013-09-06') ;
INSERT INTO incasari VALUES (1238, DATE'2013-09-08', 'OP', '532', DATE'2013-09-06') ;
INSERT INTO incasari VALUES (1239, DATE'2013-09-09', 'OP', '622', DATE'2013-09-07') ;
INSERT INTO incasari VALUES (1240, DATE'2013-09-09', 'OP', '432', DATE'2013-09-05') ;
INSERT INTO incasari VALUES (1241, DATE'2013-09-18', 'OP', '213', DATE'2013-09-11') ;


INSERT INTO incasfact VALUES (1234,	1111, 4527400) ;
INSERT INTO incasfact VALUES (1235,	1112, 129488) ;
INSERT INTO incasfact VALUES (1235,	2112, 158506) ;
INSERT INTO incasfact VALUES (1236,	1113, 50000) ;
INSERT INTO incasfact VALUES (1236,	2113, 50000) ;
INSERT INTO incasfact VALUES (1236,	3113, 50000) ;
INSERT INTO incasfact VALUES (1237,	1114, 6272728) ;
INSERT INTO incasfact VALUES (1238,	1115, 70000) ;
INSERT INTO incasfact VALUES (1238,	1117, 100000) ;
INSERT INTO incasfact VALUES (1238,	1118, 100000) ;
INSERT INTO incasfact VALUES (1238,	1120, 70000) ;
INSERT INTO incasfact VALUES (1239,	1116, 130200) ;
INSERT INTO incasfact VALUES (1240,	1119, 6015408) ;
INSERT INTO incasfact VALUES (1241,	1121, 4935248) ;
INSERT INTO incasfact VALUES (1241,	2121, 4938776) ;

 
