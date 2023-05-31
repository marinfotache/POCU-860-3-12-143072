############################################################################
###      Titlul proiectului: Educație și dezvoltare în era digitală      ###
###                   Cod proiect: POCU/860/3/12/143072                  ###
###         Curs: Introducere în analiza datelor de mari dimensiuni      ###
###                       Perioada: mai-iunie 2023                       ###
############################################################################

##############################################################################
##        Studiu de caz: Interogări tidyverse pentru baza de date `chinook`
##############################################################################
## 		tidyverse11: Opțiuni OLAP
##############################################################################
## ultima actualizare: 2023-05-28

library(tidyverse)
library(lubridate)

setwd('/Users/marinfotache/OneDrive/POCU-860-3-12-143072/7 Importul și prelucrarea datelor în limbajul R/DataSets')
load("chinook.RData")

##############################################################################
##		Știind că `trackid` respectă ordinea (poziția) pieselor de pe albume,
## să se numeroteze toate piesele de pe toate albumele formației
##`Led Zeppelin`; albumele vor fi ordonate alfabetic, iar piesele după
##poziția lor în cadrul albumului
##############################################################################

# solutie cu row_number()
temp <- artist %>%
     filter (name == 'Led Zeppelin') %>%
     select (artistid) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     arrange(title, trackid) %>%
     group_by(title) %>%
     mutate (track_no = row_number()) %>%
     ungroup() %>%
     transmute (album_title = title, track_no, track_name = name) %>%
     arrange(album_title, track_no)


# solutie cu min_rank()
temp <- artist %>%
     filter (name == 'Led Zeppelin') %>%
     select (artistid) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     group_by(title) %>%
     mutate (track_no = min_rank(trackid)) %>%
     ungroup() %>%
     transmute (album_title = title, track_no, track_name = name) %>%
     arrange(album_title, track_no)


# solutie cu dense_rank() - `trackid` este oricum unic, deci `min_rank` si
# `dense_rank` genereaza, in acest caz, acelasi rezultat
temp <- artist %>%
     filter (name == 'Led Zeppelin') %>%
     select (artistid) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     group_by(title) %>%
     mutate (track_no = dense_rank(trackid)) %>%
     ungroup() %>%
     transmute (album_title = title, track_no, track_name = name) %>%
     arrange(album_title, track_no)



##############################################################################
##		Știind că `trackid` respectă ordinea (poziția) pieselor de pe albume,
## să se numeroteze toate piesele de pe toate albumele tuturor artiștilor;
##artiștii și albumele vor fi ordonate alfabetic, iar piesele după
##poziția lor în cadrul albumului
##############################################################################

# solutie cu row_number()
temp <- artist %>%
     rename (artist_name = name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     arrange(artist_name, title, trackid) %>%
     group_by(artist_name, title) %>%
     mutate (track_no = row_number()) %>%
     ungroup() %>%
     transmute (artist_name, album_title = title, track_no, track_name = name) %>%
     arrange(artist_name, album_title, track_no)


# solutie cu min_rank()
temp <- artist %>%
     rename (artist_name = name) %>%
     inner_join(album) %>%
     inner_join(track) %>%
     group_by(artist_name, title) %>%
     mutate (track_no = min_rank(trackid)) %>%
     ungroup() %>%
     transmute (artist_name, album_title = title, track_no, track_name = name) %>%
     arrange(artist_name, album_title, track_no)



##############################################################################
##        Extrageți primele trei piese de pe fiecare album al formației U2
##############################################################################
# solutii preluate din scriptul `chinook_05_tidyverse_functii_... .R`

# solutie cu `top_n`
temp <- artist %>%
        filter (name == 'U2') %>%
        inner_join(album) %>%
        transmute (artist_name = name, album_title = title, albumid) %>%
        inner_join(track) %>%
        arrange(artist_name, album_title, albumid, trackid) %>%
        group_by(artist_name, album_title, albumid) %>%
        top_n(-3, trackid) %>%
        ungroup()


# solutie cu `slice`
temp <- artist %>%
        filter (name == 'U2') %>%
        inner_join(album) %>%
        transmute (artist_name = name, album_title = title, albumid) %>%
        inner_join(track) %>%
        arrange(artist_name, album_title, albumid, trackid) %>%
        group_by(artist_name, album_title, albumid) %>%
        slice(1:3) %>%
        ungroup()



##############################################################################
##             Afisați topul albumelor lansate de formația Queen,
##                     dupa numărul de piese conținute
##############################################################################

# solutie cu min_rank()
temp <- artist %>%
        filter (name == 'Queen') %>%
        select (artistid) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(title) %>%
        summarise(n_of_tracks = n()) %>%
        ungroup() %>%
        mutate (album_rank = min_rank(desc(n_of_tracks)))


# solutie cu dense_rank()
temp <- artist %>%
        filter (name == 'Queen') %>%
        select (artistid) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(title) %>%
        summarise(n_of_tracks = n()) %>%
        ungroup() %>%
        mutate (album_rank = dense_rank(desc(n_of_tracks)))



##############################################################################
##             Care este albumul (sau albumele) formației Queen
##                      cu cele mai multe piese? (reluare)
##############################################################################

# solutie cu min_rank()
temp <- artist %>%
        filter (name == 'Queen') %>%
        select (artistid) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(title) %>%
        summarise(n_of_tracks = n()) %>%
        ungroup() %>%
        mutate (album_rank = min_rank(desc(n_of_tracks))) %>%
        filter (album_rank == 1)


##############################################################################
##	Pentru fiecare album al fiecărui artist, afișați poziția albumului (după
## numărul de piese conținute) în clasamentul pe albume ale artistului și
## poziția în clasamentul general (al albumelor tuturor artiștilor)
##############################################################################

# solutie cu min_rank()
temp <- artist %>%
        rename (artist_name = name) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(artist_name, title) %>%
        summarise (n_of_tracks = n()) %>%
        ungroup() %>%
        group_by(artist_name) %>%
        mutate(rank__artist = min_rank(desc(n_of_tracks))) %>%
        ungroup() %>%
        mutate(rank__overall = min_rank(desc(n_of_tracks))) %>%
        transmute (artist_name, album_title = title, n_of_tracks, rank__artist, rank__overall) %>%
        arrange(artist_name, album_title)


# solutie cu dense_rank()
temp <- artist %>%
        rename (artist_name = name) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(artist_name, title) %>%
        summarise (n_of_tracks = n()) %>%
        ungroup() %>%
        group_by(artist_name) %>%
        mutate(rank__artist = dense_rank(desc(n_of_tracks))) %>%
        ungroup() %>%
        mutate(rank__overall = dense_rank(desc(n_of_tracks))) %>%
        transmute (artist_name, album_title = title, n_of_tracks, rank__artist, rank__overall) %>%
        arrange(artist_name, album_title)



##############################################################################
##     Luând în calcul numărul de piese conținute, pe ce poziție se găsește
##      albumul `Machine Head` în ierarhia albumelor formației `Deep Purple`?
##############################################################################

# solutie cu dense_rank()
temp <- artist %>%
        filter (name == 'Deep Purple') %>%
        select (artistid) %>%
        inner_join(album) %>%
        inner_join(track) %>%
        group_by(title) %>%
        summarise(n_of_tracks = n()) %>%
        ungroup() %>%
        mutate (album_rank = dense_rank(desc(n_of_tracks))) %>%
        filter (title == 'Machine Head')



##############################################################################
##   Extrageți, pentru fiecare an, topul celor mai bine vândute trei piese
##############################################################################

temp <- invoice %>%
        mutate (year = lubridate::year(invoicedate)) %>%
        select (invoiceid, year) %>%
        inner_join(invoiceline) %>%
        group_by(trackid, year) %>%
        summarise(sales = quantity * unitprice) %>%
        ungroup() %>%
        inner_join(track) %>%
        transmute (year, trackid, sales, track_name = name, albumid) %>%
        inner_join(album) %>%
        inner_join(artist) %>%
        transmute (year, track_name, album_title = title, artist_name = name,
                   sales) %>%
        group_by(year) %>%
        mutate (rank_of_the_track = min_rank(desc(sales))) %>%
        filter (rank_of_the_track <= 3) %>%
        arrange(year, rank_of_the_track)



##############################################################################
##   Pentru fiecare lună cu vânzări, afișați creșterea sau scăderea valorii
##                vânzărilor, comparativ cu luna precedentă
##############################################################################

temp <- invoice %>%
        mutate (year = lubridate::year(invoicedate),
                month = lubridate::month(invoicedate)) %>%
        group_by(year, month) %>%
        summarise (sales = sum(total)) %>%
        ungroup() %>%
        arrange(year, month) %>%
        transmute (year, month, current_month__sales = sales,
                   previous_month__sales = lag(sales, default = 0),
                   difference = current_month__sales - previous_month__sales)


##############################################################################
##   Pentru fiecare lună cu vânzări, calculați creșterea sau scăderea valorii
##      vânzărilor, comparativ cu luna precedentă, însă numai în cadrul
##      anului (diferența se va calcula numai între lunile anului curent)
##############################################################################

temp <- invoice %>%
        mutate (year = lubridate::year(invoicedate),
                month = lubridate::month(invoicedate)) %>%
        group_by(year, month) %>%
        summarise (sales = sum(total)) %>%
        ungroup() %>%
        arrange(year, month) %>%
        transmute (year, month, sales) %>%
        group_by(year) %>%
        mutate (current_month__sales = sales,
                previous_month__sales = lag(sales, default = 0),
                difference = current_month__sales - previous_month__sales) %>%
        ungroup()



###############################################################################
###   Pentru fiecare lună cu vânzări, afișați vânzările cumulate de la
### începutul anului curent și vânzările cumulate de la prima vânzare 
###############################################################################

# solution with `cumsum`

temp <- invoice %>%
        mutate (year = lubridate::year(invoicedate),
                month = lubridate::month(invoicedate)) %>%
        group_by(year, month) %>%
        summarise (sales = sum(total)) %>%
        ungroup() %>%
        arrange(year, month) %>%
        transmute (year, month, sales) %>%
        group_by(year) %>%
        mutate (cumulative_sales_crt_month__within_crt_year = cumsum(sales)) %>%
        ungroup() %>%
        mutate (cumulative_sales_crt_month__overall = cumsum(sales)) 


