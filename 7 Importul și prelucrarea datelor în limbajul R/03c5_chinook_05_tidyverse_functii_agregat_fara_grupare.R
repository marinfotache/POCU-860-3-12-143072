############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##        Case study: tidyverse queries for `chinook` database
##############################################################################
## 	  tidyverse05: Funcții agregat (count, count distinct, ...) fără grupare
## 		tidyverse05: Aggregate functions without gruping
##############################################################################
## ultima actualizare: 2023-05-30

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R/DataSets')
load("chinook.RData")


##############################################################################
##                   Câți artiști sunt în baza de date?
##############################################################################

# Solutie eronata!!! (aceasta solutie numara de cate ori apare fiecare valoare
# a `artistid` in data frame-ul `artist`)
temp <- artist %>%
     count(artistid)


# Solutie 1 - `count()`
temp <- artist %>%
     count()


# Solutie 2 - `summarise`, `n()` - echivalentl lui COUNT(*) din SQL
temp <- artist %>%
     summarise(n_of_artists = n())


# Solutie 3 - `tally()`
temp <- artist %>%
     tally()



##############################################################################
##				                     Câți clienți au fax?
##############################################################################

# sol 1
temp <- customer %>%
        filter(!is.na(fax)) %>%
        tally()

# sol 2
temp <- customer %>%
        filter(!is.na(fax)) %>%
        summarise(n_of_customers_with_faxes = n())




##############################################################################
##		Pentru câți artiști există măcar un album în baza de date?
##############################################################################


# solutie bazata pe `n_distinct`
temp <- album %>%
     summarise (n = n_distinct(artistid))


# solutie bazata pe `semi-join` si `count`
temp <- artist %>%
     semi_join(album) %>%
     count()


# solutie bazata pe `semi-join` si `summarise`+`n()`
temp <- artist %>%
     semi_join(album) %>%
     summarise (n = n())


# solutie bazata pe left_join
temp <- artist %>%
     left_join(album) %>%
     filter(!is.na(title)) %>%
     summarise (n_artists_without_records = n_distinct(artistid))



##############################################################################
##		Câți artiști nu au nici măcar un album în baza de date?
##############################################################################

temp <- artist %>%
     left_join(album) %>%
     filter(is.na(title)) %>%
     summarise (n_artists_without_records = n())


temp <- artist %>%
     anti_join(album) %>%
     summarise (n_artists_without_records = n())
     

     
##############################################################################
##               Din câte țări sunt clienții companiei?
##############################################################################

# solutie bazata pe `n_distinct`
temp <- customer %>%
     summarise (n = n_distinct(country))




############################################################################
##               Din cate orașe sunt clienții companiei?
############################################################################

# solutie bazata pe `n_distinct`
temp <- customer %>%
     summarise (n = n_distinct(paste(city, state,
                                     country, sep = ' - ')))

paste('ana', 'are', 'mere')

paste('ana', 'are', 'mere')

paste('ana', 'are', 'mere', sep = '**--')



##############################################################################
##       Câte secunde are albumul `Achtung Baby` al formației `U2`?
##############################################################################

# solutie bazata pe `summarise` si `sum`
temp <- album %>%
     filter (title == 'Achtung Baby') %>%
     semi_join(artist %>%
                    filter (name == 'U2')) %>%
     inner_join(track) %>%
     summarise(durata_sec = sum(milliseconds / 1000))




##############################################################################
##              Care este durata medie (în secunde) a pieselor
##              de pe albumul `Achtung Baby` al formației `U2`
##############################################################################

# solutie bazata pe `summarise` si `mean`
temp <- album %>%
     filter (title == 'Achtung Baby') %>%
     semi_join(artist %>%
                    filter (name == 'U2')) %>%
     inner_join(track) %>%
     summarise(durata_medie = mean(milliseconds / 1000))



##############################################################################
##          Care este durata medie a pieselor formației `U2`
##############################################################################

# solutie bazata pe `summarise` si `mean`
temp <- album %>%
     semi_join(artist %>%
                    filter (name == 'U2')) %>%
     inner_join(track) %>%
     summarise(durata_medie = mean(milliseconds / 1000))



##############################################################################
##			Care este durata medie a pieselor formației `Pink Floyd`,
##                    exprimată în minute și secunde
##############################################################################

# solutie bazata pe `summarise`, `mean` si `lubridate::seconds_to_period`
temp <- album %>%
     semi_join(artist %>%
                    filter (name == 'Pink Floyd')) %>%
     inner_join(track) %>%
     summarise(durata_medie =
          trunc(lubridate::seconds_to_period(mean(milliseconds / 1000))))


##############################################################################
##            Care este durata tuturor pieselor din baza de date
##                    exprimată în minute și secunde
##############################################################################
temp <- track %>%
     summarise(durata_totala =
          trunc(lubridate::seconds_to_period(sum(milliseconds / 1000))))


# age(ymd('2023-05-30'), ymd('1969-96-15'))


##############################################################################
##                     În ce zi a fost prima vânzare?
##############################################################################

# solutie cu functia `min`
temp <- invoice %>%
    summarise(first_day = min(invoicedate))


# solutie cu optiunea `head`
temp <- invoice %>%
    arrange (invoicedate) %>%
    head(1)  %>%
    transmute (first_day = invoicedate)

# solutie cu optiunea `tail`
temp <- invoice %>%
    arrange (desc(invoicedate)) %>%
    tail(1)  %>%
    transmute (first_day = invoicedate)


# solutie cu optiunea `top` (atentie la `-1`!!!)
temp <- invoice %>%
    distinct(invoicedate) %>%
    top_n (-1, invoicedate) %>%
    transmute (first_day = invoicedate)


# solutie cu `slice`
temp <- invoice %>%
    distinct(invoicedate) %>%
    arrange(invoicedate)  %>%
    slice(1)


# alta solutie cu `slice`
temp <- invoice %>%
    distinct(invoicedate) %>%
    arrange(desc(invoicedate))  %>%
    slice(nrow(.))


# solutie cu filtrare ce foloseste `rownum()`
temp <- invoice %>%
    distinct(invoicedate) %>%
    arrange(invoicedate)  %>%
    filter (row_number() <= 1)



##############################################################################
##                      În ce dată a fost ultima vanzare?
##############################################################################

temp <- invoice %>%
     summarise(last_day = max(invoicedate))


# solutie cu optiunea `head`
temp <- invoice %>%
    arrange (desc(invoicedate)) %>%
    head(1)  %>%
    transmute (last_day = invoicedate)


# solutie cu optiunea `tail`
temp <- invoice %>%
    arrange (invoicedate) %>%
    tail(1)  %>%
    transmute (last_day = invoicedate)


# solutie cu optiunea `top_n`
temp <- invoice %>%
    distinct(invoicedate) %>%
    top_n (1, invoicedate) %>%
    transmute (first_day = invoicedate)



##############################################################################
##                     Care a fost a doua zi cu vânzari?
##############################################################################

temp <- invoice %>%
     distinct(invoicedate) %>%
     arrange(invoicedate) %>%
     head(2) %>%
     tail(1)


temp <- invoice %>%
     distinct(invoicedate) %>%
     arrange(invoicedate) %>%
     filter(row_number() == 2)


##############################################################################
##               Probleme de rezolvat la curs/laborator/acasa
##############################################################################

#
##############################################################################
##                Cate piese sunt stocate în baza de date?
##############################################################################

# ##Care este data primei angajari in companie
#
# ##Cate piese sunt pe playlistul `Grunge`?
#
# ##Cati subordonati are, in total (pe toate nivelurile) angajatul xxxxxx?
#



##############################################################################
##             La ce întrebări răspund următoarele interogări ?
##############################################################################


##
invoice %>%
        summarise(first_day = min(invoicedate), last_day = max(invoicedate)) %>%
        mutate (range = last_day - first_day) %>%
        transmute(range)

##
temp <- track %>%
        filter (milliseconds / 1000 > mean(milliseconds/1000))


mean(track$milliseconds/1000)
