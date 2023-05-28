############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 					tidyverse12: Interogări recursive
##############################################################################
## ultima actualizare: 2023-05-28

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R')
load("chinook.RData")



##############################################################################
##  		A. Interogări recursive pentru probleme `pseudo-recursive`
##############################################################################

##############################################################################
##		Știind că `trackid` respectă ordinea (poziția) pieselor de pe albume,
## să se numeroteze toate piesele de pe toate albumele formației
##`Led Zeppelin`; albumele vor fi ordonate alfabetic, iar piesele după
##poziția lor în cadrul albumului (reluare)
##############################################################################

# Singura solutie `nativa` tidyverse foloseste `paste(..., collapse = ';')``
temp <- artist %>%
     rename (artist_name = name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     arrange(artist_name, title, trackid) %>%
     group_by(artist_name, title) %>%
     mutate (track_no = row_number()) %>%
     summarise(all_tracks_from_this_album = paste(paste0(track_no, ':', name), collapse = '; ')) %>%
     ungroup()


##############################################################################
##           B. Interogari recursive pentru probleme `recursive`
##############################################################################
### `tidyverse` nu are (inca) un mecanism ne-procedural pentru recursivitate.
### In functie de natura problemei, solutiile pot fi procedurale sau bazate
### pe pachete ce prelucreaza grafuri (ex. `tidygraph`)


