############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 			tidyverse04: Tratamentul valorilor lipsă
##############################################################################
## ultima actualizare: 2023-05-29

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")


##############################################################################
###                                    is.na()
##############################################################################

##############################################################################
##            Care sunt clienții individuali (non-companii)
##############################################################################

temp <- customer %>%
        filter (is.na(company))


##############################################################################
##               Care sunt clienții care reprezintă companii
##############################################################################

temp <- customer %>%
        filter (!is.na(company))



##############################################################################
##      Care sunt piesele de pe albumele formației `Black Sabbath`
##                  cărora nu li se cunoaște compozitorul
##############################################################################

# solutia bazata pe functia `is.na`
temp <- artist %>%
     filter (name == 'Black Sabbath') %>%
     select (-name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     select (name, composer) %>%
     filter (is.na(composer))


# a doua solutia bazata pe functia `is.na`
temp <- artist %>%
     filter (name == 'Black Sabbath') %>%
     inner_join(album) %>%
     inner_join(track, by = c('albumid' = 'albumid')) %>%
     transmute (track_name = name.y, composer) %>%
     filter (is.na(composer))


##############################################################################
##   Să se afișeze, sub formă de șir de caractere, orașele din care provin
## clienții (pentru a elimina confuziile, numele orașului trebuie concatenat
## cu statul și tara din care face parte orașul respectiv)
##############################################################################



#############################################################################
##  Afisati clientii in ordinea tarilor; pentru cei din tari non-federative,
##  la atributul `state`, in locul valorii NULL, afisati `-`
#############################################################################

# solutie cu `if_else`
temp <- customer %>%
    select (customerid:lastname, state) %>%
    mutate(state2 = if_else(is.na(state), '-', state))


# solutie cu `case_when`
temp <- customer %>%
    select (customerid:lastname, state) %>%
    mutate(state2 = case_when(
            is.na(state) ~ '-',
            TRUE ~ state))


# solutie cu `coalesce` - vezi mai jos
#
#


##############################################################################
###                               COALESCE
##############################################################################

##############################################################################
## Afișați clienții în ordinea țărilor; pentru cei din țări non-federative,
##   la atributul `state`, în locul valorii NULL, afișati `-`
##############################################################################

temp <- customer %>%
    select (customerid:lastname, state) %>%
    mutate(state2 = coalesce(state, '-'))


##############################################################################
## Să se afișeze, în ordine alfabetică, toate titlurile pieselor de pe
##  albumele formației `Black Sabbath`, împreuna cu autorii (compozitorii) lor;
##  acolo unde compozitorul nu este specificat (NULL), să se afișeze
##  `COMPOZITOR NECUNOSCUT`
##############################################################################

# solutie bazata pe functia `coalesce`
temp <- artist %>%
     filter (name == 'Black Sabbath') %>%
     select (-name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     transmute (name, composer = coalesce(composer, 'COMPOZITOR NECUNOSCUT')) %>%
     arrange(name)





##############################################################################
##               Probleme de rezolvat la curs/laborator/acasa
##############################################################################


# ############################################################################
# Sa se afiseze, sub forma de sir de caractere, orasele din care provin
# clientii (pentru a elimina confuziile, numele orasului trebuie concatenat
# cu statul si tara din care face parte orasul respectiv)

temp <- customer %>%
    select (city, state, country) %>%
    mutate (city_string1 = paste(city, coalesce(state, '-'), country)) %>%
    distinct(.)





############################################################################
# ##Afisati toate facturile (tabela `invoice), completand eventualele valori NULL
# ##  ale atributului `billingstate` cu valoarea tributului `billing city` de pe
# ##  aceasi linie
#



##############################################################################
##             La ce întrebări răspund următoarele interogări ?
##############################################################################
