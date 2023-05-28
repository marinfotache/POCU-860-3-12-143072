############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 		tidyverse10: Soluții echivalente expresiilor tabele din SQL
##############################################################################
## ultima actualizare: 2023-05-28


library(tidyverse)
library(lubridate)
setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")


###
###
###  logica `tidyverse` nu se pliaza pe expresii tabela; toate solutiile SQL din scriptul
###   `chinook_10_sql_expresii_tabele.sql` au echivalente in precedentele scripturi `tidyverse`:
###   `chinook_08_tidyverse_subconsultari_in_where_si_having.R`
###   `chinook_09_tidyverse_subconsultari_in_from_si_select.R`
###
