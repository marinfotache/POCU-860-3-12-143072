﻿/*
Titlul proiectului: Educație și dezvoltare în era digitală
Cod proiect: POCU/860/3/12/143072 
Curs: Introducere în analiza datelor de mari dimensiuni
Perioada: mai-iunie 2023 
*/

-- Script pentru creare bazei de date TRIAJ. Sintaxa PostgreSQL


DROP TABLE IF EXISTS triaj ;
DROP TABLE IF EXISTS pacienti ;
DROP TABLE IF EXISTS garzi ;
DROP TABLE IF EXISTS doctori ;

CREATE TABLE doctori (
  iddoctor SERIAL CONSTRAINT pk_doctori PRIMARY KEY,
  numedoctor VARCHAR(50) NOT NULL,
  specialitate VARCHAR(40) NOT NULL,
  datanasterii DATE
  );

CREATE TABLE garzi (
  iddoctor SMALLINT NOT NULL REFERENCES doctori (iddoctor) ON UPDATE CASCADE,
  inceput_garda TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  sfirsit_garda TIMESTAMP,
  CONSTRAINT pk_garzi PRIMARY KEY (inceput_garda)
  ) ;
--  CONSTRAINT pk_garzi PRIMARY KEY (iddoctor, inceput_garda)


CREATE TABLE pacienti (
  idpacient SERIAL CONSTRAINT pk_pacienti PRIMARY KEY,
  numepacient VARCHAR(60),
  CNP NUMERIC(13),
  adresa VARCHAR(100),
  loc VARCHAR(30),
  judet CHAR(2),
  tara VARCHAR(30) DEFAULT 'Romania',
  serie_nr_act_identitate VARCHAR(20)
  ); 
  
CREATE TABLE triaj (
  idexaminare BIGSERIAL CONSTRAINT pk_internari PRIMARY KEY,
  dataora_examinare TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  idpacient INTEGER NOT NULL CONSTRAINT fk_internari_pacienti
    REFERENCES pacienti (idpacient)  ON UPDATE CASCADE,
  simptome VARCHAR(500) NOT NULL,
  tratament_imediat VARCHAR(500),
  sectie_destinatie VARCHAR(30)
  );  

 