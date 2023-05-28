############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 			tidyverse07: Joncțiuni externe (OUTER JOIN)
##############################################################################
## ultima actualizare: 2023-05-28

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")


##############################################################################
##   Care sunt artiștii care, momentan, nu au niciun album preluat în BD?
##############################################################################

# solutie bazata pe diferenta (`dplyr::setdiff`) si `semi_join`
temp <- dplyr::setdiff(
     artist,
     artist %>%
          semi_join(album)
     ) %>%
     arrange(name)


# solutie bazata pe `anti_join`
temp <- artist %>%
     anti_join(album) %>%
     arrange(name)


# solutie bazata pe `left_join`
temp <- artist %>%
     left_join(album) %>%
     filter (is.na(albumid)) %>%
     arrange(name)



##############################################################################
## Extrageți numărul albumelor fiecarui artist; pentru artiștii (actualmente)
##					fără albume, să se afișeze `0`
##############################################################################

# solutie bazata pe `left_join` si `count` - solutie eronata
# (cei care nu au nicun album apar cu 1 (datorita `count`-ului))
temp <- artist %>%
     left_join(album) %>%
     count(name) %>%
     arrange(name)


# solutie corecta bazata pe `sum(if_else(...`
temp <- artist %>%
        left_join(album) %>%
        group_by(name) %>%
        summarise(n = sum(if_else(is.na(title), 0, 1)))


# solutie corecta bazata pe `sum(case_when(...`
temp <- artist %>%
        left_join(album) %>%
        group_by(name) %>%
        summarise(n = sum(
                case_when(
                        is.na(title) ~ 0,
                        TRUE ~ 1
                        )))



##############################################################################
##   Care sunt artiștii care, momentan, nu au niciun album preluat în BD? (2)
##############################################################################

# asa cum am vazut mai sus, solutia bazata pe `left_join` si `count`
# NU FUNCTIONEAZA!!!
temp <- artist %>%
     left_join(album) %>%
     count(name, na.rm = TRUE) %>%
     filter ( n == 0) %>%
     arrange(name)


# ...nici solutia bazata pe `left_join`, `group_by` si `tally` NU FUNCTIONEAZA!!!
temp <- artist %>%
     left_join(album) %>%
     group_by(name) %>%
     tally() %>%
     ungroup() %>%
     filter ( n == 0) %>%
     arrange(name)


# ...nici solutia bazata pe `left_join`, `group_by` si `tally` NU FUNCTIONEAZA!!!...
temp <- artist %>%
     left_join(album) %>%
     group_by(name) %>%
     summarise(n = n()) %>%
     ungroup() %>%
     filter ( n == 0) %>%
     arrange(name)


# ... insa poate fi pusa la punct folosind ideea de mai sus (`sum(if_else...`)
temp <- artist %>%
     left_join(album) %>%
     group_by(name) %>%
     summarise(n = sum(if_else(is.na(title), 0, 1))) %>%
     ungroup() %>%
     filter ( n == 0) %>%
     arrange(name)



##############################################################################
##            Afisați, pentru TOȚI clienții din baza de date,
##       vânzările pe anul 2010 (în raport trebuie incluși și clienții
##                pentru care nu sunt vânzari în 2010)
##############################################################################

# solutie bazata pe `if_else`
temp <- customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid,
                              year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2010) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = if_else(is.na(year), 2010, year),
            sales = if_else(is.na(sales), 0, sales))


# solutie bazata pe `case_when`
temp <- customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid, year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2010) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = case_when(
                is.na(year) ~ 2010,
                TRUE ~ year),
            sales = case_when(
                is.na(sales) ~ 0,
                TRUE ~ sales))


# solutie bazata pe `coalesce`
temp <- customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid,
                              year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2010) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = coalesce(year, 2010), sales = coalesce(sales, 0))



##############################################################################
##            Afișati, pentru fiecare client, pe trei linii separate,
##                    vânzările pe anii 2010, 2011 și 2012 (2)
##############################################################################

# solutie corecta & completa
temp <- bind_rows(

     # 2010
     customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid, year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2010) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = coalesce(year, 2010), sales = coalesce(sales, 0)),

     # 2011
     customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid, year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2011) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = coalesce(year, 2011), sales = coalesce(sales, 0)),

     # 2012
     customer %>%
     select (customerid:lastname, city:country) %>%
          left_join(
               invoice %>%
                    transmute(customerid, year = lubridate::year(lubridate::ymd(invoicedate)),
                              total) %>%
                    filter (year == 2012) %>%
               group_by(customerid, year) %>%
               summarise (sales = sum(total))
          ) %>%
     mutate(year = coalesce(year, 2012), sales = coalesce(sales, 0))
     ) %>%
     transmute(customer_name = paste(lastname, firstname), city, state,
               country, year, sales) %>%
     arrange(customer_name, city, state, country, year)



##############################################################################
##                Afișați, pentru fiecare client, pe coloane separate,
##                      vânzările pe anii 2010, 2011 și 2012 (2)
##############################################################################


# solutie bazata pe jonctiune externa
temp <-
     customer %>%
          select (customerid:lastname, city:country) %>%

          left_join(   # 2010
               invoice %>%
                    filter(lubridate::year(lubridate::ymd(invoicedate)) == 2010) %>%
                    transmute(customerid, total) %>%
                    group_by(customerid) %>%
                    summarise (sales2010 = sum(total))
               ) %>%
          mutate(sales2010 = coalesce(sales2010, 0)) %>%

          left_join(   # 2011
               invoice %>%
                    filter(lubridate::year(lubridate::ymd(invoicedate)) == 2011) %>%
                    transmute(customerid, total) %>%
                    group_by(customerid) %>%
                    summarise (sales2011 = sum(total))
               ) %>%
          mutate(sales2011 = coalesce(sales2011, 0)) %>%

               left_join(   # 2012
               invoice %>%
                    filter(lubridate::year(lubridate::ymd(invoicedate)) == 2012) %>%
                    transmute(customerid, total) %>%
                    group_by(customerid) %>%
                    summarise (sales2012 = sum(total))
               ) %>%
          mutate(sales2012 = coalesce(sales2012, 0)) %>%
     transmute(customer_name = paste(lastname, firstname), city, state, country,
               sales2010, sales2011, sales2012) %>%
     arrange(customer_name, city, state, country)





##############################################################################
##               Probleme de rezolvat la curs/laborator/acasa
##############################################################################
#
# ##Obtineti un raport in care linii sunt asociate fiecarui artist,
# ##  iar coloanele fiecarui gen muzical (prima coloana va fi numele artistului);
# ##  calculati numarul de piese ale fiecarui artist pe fiecare gen muzical
#




##############################################################################
##             La ce întrebări răspund următoarele interogări ?
##############################################################################

##
temp <- artist %>%
        filter(name == 'U2') %>%
        select (artistid) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        select(-unitprice) %>%
        rename (track_name = name, album_title = title) %>%
        left_join(invoiceline) %>%
        mutate(sales = coalesce(quantity * unitprice, 0)) %>%
        group_by(track_name, album_title) %>%
        summarise(sales = sum(sales)) %>%
        arrange(album_title, track_name)
