############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 			tidyverse09:  Echivalențe `tidyverse` ale subconsultărilor SQL
##             incluse în clauzele FROM si SELECT. Diviziune relationala (2)
##############################################################################
## ultima actualizare: 2023-05-28


library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")



############################################################################
###     Echivalențe `tidyverse` ale subconsultarilor SQL în clauza FROM
############################################################################


##############################################################################
##       Care sunt celelalte albume ale artistului sau formației care a
##                  lansat albumul `Houses of the Holy` (reluare)
##############################################################################

# solutie preluata din scriptul anterior (care emuleaza logica interogarii SQL de mai sus)
temp <- album %>%
     filter (title == 'Houses Of The Holy') %>%
     select (artistid) %>%
     inner_join(album) %>%
     inner_join(artist)



##############################################################################
##			Care sunt piesele comune (cu acelasi titlu) de pe
##			albumele `Fear Of The Dark` si `A Real Live One`
##					ale formatiei 'Iron Maiden' (reluare)
##############################################################################

# o solutie relativ apropiata logicii SQL din scriptul `chinook_09_sql...`
temp <- artist %>%
     filter (name == 'Iron Maiden') %>%
     select (artistid) %>%
     inner_join(album) %>%
     filter (title == 'Fear Of The Dark') %>%
     select (albumid) %>%
     inner_join(track) %>%
     select (name) %>%
          inner_join(
     artist %>%
          filter (name == 'Iron Maiden') %>%
          select (artistid) %>%
          inner_join(album) %>%
          filter (title == 'A Real Live One') %>%
          select (albumid) %>%
          inner_join(track) %>%
          select (name)
          )


##############################################################################
##            Care sunt facturile din prima zi de vânzări? (reluare)
##############################################################################


# toate solutile din scriptul anterior (`chinook_08_tidyverse...`) care nu
# folosesc `pull()` se apropie de logica SQL din scriptul `chinook_09_sql...`

# ...incercam si o solutie noua
temp <- min(invoice$invoicedate) %>%
     enframe() %>%
     transmute (invoicedate = value) %>%
     inner_join(invoice)



##############################################################################
##       Care sunt facturile din prima săptămână de vânzări? (reluare)
##############################################################################


# ... solutie noua:
temp <- seq(
          min(trunc(invoice$invoicedate)),
          (min(trunc(invoice$invoicedate)) +
                 lubridate::period(days = 7)),
          by = 'day') %>%
     enframe() %>%
     transmute (invoicedate = value) %>%
     inner_join(invoice)




##############################################################################
##     Care sunt albumele formației Led Zeppelin care au mai multe piese
##                           decât albumul `IV`? (reluare)
##############################################################################

# intrucat theta-jonctiunea nu e posibila in tidyverse, ramanem la cele
# doua solutii din scriptul precedent (cea de mai jos este a doua)
temp <- artist %>%
     inner_join(album) %>%
     filter (name == 'Led Zeppelin') %>%
     select (-name) %>%
     inner_join(track) %>%
     group_by(title) %>%
     summarise (n_of_tracks = n()) %>%
     ungroup() %>%
     mutate (n_of_tracks_IV = if_else(title == 'IV', n_of_tracks, 0L)) %>%  # `0L` is compulsory!!!
     mutate (n_of_tracks_IV = max(n_of_tracks_IV)) %>%
     filter (n_of_tracks > n_of_tracks_IV)



##############################################################################
##              Afișați, pentru fiecare client, pe coloane separate,
##                    vânzările pe anii 2010, 2011 și 2012 (3)
##############################################################################

# solutia cea mai eleganta se bazeaza pe `pivot_wider`
temp <- invoice %>%
     transmute (customerid, total, year = lubridate::year(invoicedate)) %>%
     filter (year %in% c(2010, 2011, 2012)) %>%
     group_by(customerid, year) %>%
     summarise(sales = sum(total)) %>%
     ungroup() %>%
     inner_join(customer %>%
                     transmute (customerid, customer_name = paste(lastname, firstname),
                                state, country)) %>%
     pivot_wider(names_from = year, values_from = sales, values_fill = 0) %>%
     arrange(customer_name)



##############################################################################
##  Calculați ponderea fiecărei luni calendaristice în vânzările anului 2010
##############################################################################

temp <- 1:12 %>%
     enframe() %>%
     transmute (month = value) %>%
     left_join(
          invoice %>%
               filter (lubridate::year(invoicedate) == 2010) %>%
               mutate(month = lubridate::month(invoicedate)) %>%
               group_by(month) %>%
               summarise (monthly_sales = sum(total)) %>%
               ungroup()
     ) %>%
     mutate (sales_2010 = sum(monthly_sales),
             month_share = round(monthly_sales / sales_2010,2))




##############################################################################
##                      Diviziune relațională (2)
##############################################################################


##############################################################################
##   Care sunt artiștii cu vânzări în toate orașele din 'United Kingdom' din
##                         care provin clienții (reluare)
##############################################################################

# o solutie care transpune logica diviziunii relationale
temp <- dplyr::setdiff(
     artist %>%
          transmute(artist_name = name ),
     artist %>%
               transmute(artist_name = name ) %>%
               mutate (foo = 1) %>%
          inner_join(
               customer %>%
                    filter (country ==  'United Kingdom') %>%
                    distinct(city) %>%
                    mutate (foo = 1)
          ) %>%
          select (-foo) %>%
          anti_join(
               artist %>%
                    rename(artist_name = name ) %>%
                    inner_join(album) %>%
                    inner_join(track) %>%
                    select (-unitprice) %>%
                    inner_join(invoiceline) %>%
                    inner_join(invoice) %>%
                    inner_join(customer) %>%
                    filter (country ==  'United Kingdom') %>%
                    distinct(artist_name, city)
          )   %>%
     transmute(artist_name)
     )



##############################################################################
##	 Care sunt artiștii cu vânzări în toți anii (adică, în fiecare an) din
##                       intervalul 2009-2012
##############################################################################

# o solutie care transpune logica diviziunii relationale
temp <- dplyr::setdiff(
     artist %>%
          transmute(artist_name = name ),
     artist %>%
               transmute(artist_name = name ) %>%
               mutate (foo = 1) %>%
          inner_join(
               2009:2012 %>%
                    enframe() %>%
                    transmute (year = value) %>%
                    mutate (foo = 1)
          ) %>%
          select (-foo) %>%
          anti_join(
               artist %>%
                    rename(artist_name = name ) %>%
                    inner_join(album) %>%
                    inner_join(track) %>%
                    select (-unitprice) %>%
                    inner_join(invoiceline) %>%
                    inner_join(invoice) %>%
                    mutate (year = lubridate::year(invoicedate)) %>%
                    inner_join(
                         2009:2012 %>%
                              enframe() %>%
                              transmute (year = value)
                              ) %>%
                    distinct(artist_name, year)
          ) %>%
     transmute(artist_name)
     )



##############################################################################
##	 Care sunt artiștii pentru care au fost vânzări măcar (cel puțin)
##         în toți anii în care s-au vândut piese ale formației `Queen`
##############################################################################

# solutie mai apropiata de logica `non-divizionala`
temp <- artist %>%                                      #---------------------
     filter (name == 'Queen') %>%                       #
     select (artistid) %>%                              #
     inner_join(album) %>%                              #   here we get the
     inner_join(track) %>%                              #  all the sales
     select (-unitprice) %>%                            #  years for
     inner_join(invoiceline) %>%                        #  artist/band
     inner_join(invoice) %>%                            #  `Queen`
     mutate (year = lubridate::year(invoicedate)) %>%   #
     distinct (year)  %>%                               #--------------------
     mutate (n_of_years_queen = n()) %>%    # add a column with the number of years for `Queen`
     inner_join(
          artist %>%                                   #-------------------
               rename (artist_name  = name) %>%        #
               inner_join(album) %>%                   #  here we get
               inner_join(track) %>%                   #  all the sales years
               select (-unitprice) %>%                 #    for each artist,
               inner_join(invoiceline) %>%             #  i.e.
               inner_join(invoice) %>%                 #  all distinct
               mutate (year =                          #  values
                    lubridate::year(invoicedate)) %>%  #  (artist_name, year)
               distinct (artist_name, year)            #-------------------
     )  %>%
          # at this point, we have all (artist_name, year) combinations,
          # but only for "Queen years";
          #    next, we'll compute the number of years for each artist
          #    (carrying the `n_of_years_queen`)
     group_by(artist_name, n_of_years_queen) %>%
     tally() %>%
     ungroup() %>%
     filter (n == n_of_years_queen)




# solutie apropiata de logica diviziunii relationale
temp <- artist %>%
     rename (artist_name = name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     select (-unitprice) %>%
     inner_join(invoiceline) %>%
     inner_join(invoice) %>%
     mutate (year = lubridate::year(invoicedate)) %>%
     distinct (artist_name, year)  %>%
     arrange (artist_name, year)  %>%
     inner_join(
          artist %>%
          filter (name == 'Queen') %>%
          select (artistid) %>%
          inner_join(album) %>%
          inner_join(track) %>%
          select (-unitprice) %>%
          inner_join(invoiceline) %>%
          inner_join(invoice) %>%
          mutate (year = lubridate::year(invoicedate)) %>%
          distinct (year)
     ) %>%
     group_by(artist_name) %>%
     summarise (years = paste(year, collapse = '|')) %>%
     ungroup() %>%

     inner_join(

               artist %>%
                    filter (name == 'Queen') %>%
                    select (artistid) %>%
                    inner_join(album) %>%
                    inner_join(track) %>%
                    select (-unitprice) %>%
                    inner_join(invoiceline) %>%
                    inner_join(invoice) %>%
                    mutate (year = lubridate::year(invoicedate)) %>%
                    distinct (year)  %>%
                    arrange(year) %>%
                    summarise (years = paste(year, collapse = '|'))

     )



##############################################################################
##      Echivalente `tidyverse` ale subconsultarilor SQL in clauza SELECT
##############################################################################

####
#### Logica  `tidyverse` nu se pliaza "direct" pe problematica subconsultarilor din SQL;
####      in schimb, toate problemele care in SQL se folosesc subconsultari,
####      cu sau fara corelare, au solutii in `tidyverse`
####





##############################################################################
##               Probleme de rezolvat la curs/laborator/acasa
##############################################################################



##############################################################################
##             Care este albumul (sau albumele) formației Queen
##                      cu cele mai multe piese? (reluare)
##############################################################################


##############################################################################
##	 Care sunt artiștii cu vânzări în toate țările din urmatorul set:
## ('USA', 'France', 'United Kingdom', 'Spain') (reluare)
##############################################################################



##############################################################################
##             La ce întrebări răspund următoarele interogări ?
##############################################################################
