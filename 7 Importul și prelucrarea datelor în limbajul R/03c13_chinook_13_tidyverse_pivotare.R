############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 					tidyverse13: Pivotare
##############################################################################
## ultima actualizare: 2023-05-28

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")

##############################################################################
##              Afișați, pentru fiecare client, pe coloane separate,
##                    vânzările pe anii 2010, 2011 și 2012 (6)
##############################################################################


temp <- customer %>%
     inner_join(invoice) %>%
     group_by(customer_info = paste(lastname, firstname, city, state, country, sep = ', ')) %>%
     summarise(
          sales2010 = sum(if_else(year(invoicedate) == 2010, total, 0)),
          sales2011 = sum(if_else(year(invoicedate) == 2011, total, 0)),
          sales2012 = sum(if_else(year(invoicedate) == 2012, total, 0))
     )


temp <- customer %>%
     transmute (customer_name = paste(lastname, firstname),
                city, state, country, customerid) %>%
     inner_join(
          invoice %>%
               filter (year(invoicedate) %in% c(2010, 2011, 2012)) %>%
               group_by(customerid, year = year(invoicedate)) %>%
               summarise(sales = sum(total)) %>%
               ungroup()
     ) %>%
     select(-customerid) %>%
     arrange(customer_name, year) %>%
     pivot_wider(names_from = year, values_from = sales)



##############################################################################
##              Afișați, pentru fiecare client, pe coloane separate,
##                    vânzările penttru fiecatre an
##############################################################################

temp <- customer %>%
     inner_join(invoice) %>%
     group_by(customer_info = paste(lastname, firstname, city, state, country, sep = ', '), 
              year = year(invoicedate)) %>%
     summarise(sales = sum(total)) %>%
#     ungroup() %>%
     pivot_wider(names_from = year, values_from = sales, values_fill = 0)




##############################################################################
##               Probleme de rezolvat la curs/laborator/acasa
##############################################################################

##############################################################################
##              Afișați, pentru fiecare client, pe coloane separate,
##                    vânzările pentru fircare an (2009-2013)
##############################################################################



##...
