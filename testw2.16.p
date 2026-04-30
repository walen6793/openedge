define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_ArtLief for E_ArtLief.

define temp-table tt-export no-undo
  field tt-Artikel LIKE S_Artikel.Artikel
  field tt-Firma LIKE S_Artikel.Firma
  field tt-Bezeichnung1 LIKE S_ArtikelSpr.Bezeichnung
  field tt-type AS CHARACTER FORMAT 'x(10)'
  field tt-KunLief AS CHARACTER FORMAT 'x(60)'
  field tt-Name1   AS CHARACTER FORMAT 'x(60)'

    .


FOR EACH bS_ArtKunde
    where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}
    no-lock:

    if can-find(first bS_ArtLief
        where bS_ArtLief.Firma      = {firma/e_artli.fir '100'}
          and bS_ArtLief.Artikel    = bS_ArtKunde.Artikel
        ) then
    do:
      find S_Artikel
        where S_Artikel.Firma    = {firma/sartikel.fir '100'}
          and S_Artikel.Artikel  = bS_ArtKunde.Artikel
        no-lock no-error.
      find S_ArtikelSpr
        where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
          and S_ArtikelSpr.Artikel  = S_Artikel.Artikel
          and S_ArtikelSpr.Sprache  = 'D'
        no-lock no-error.
      find S_Kunde
        where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
          and S_Kunde.Kunde  =  bS_ArtKunde.Kunde
        no-lock no-error.
      find S_Adresse
        where S_Adresse.Firma     = {firma/s_adres.fir }
          and S_Adresse.AdressNr  = S_Kunde.AdressNr
        no-lock no-error.

       CREATE tt-export.
         ASSIGN
           tt-export.tt-Firma        = S_Artikel.Firma
           tt-export.tt-Artikel      = S_Artikel.Artikel
           tt-export.tt-Bezeichnung1 = S_ArtikelSpr.Bezeichnung[1]
           tt-export.tt-type         = 'K'
           tt-export.tt-KunLief      = string(bS_ArtKunde.Kunde)
           tt-export.tt-Name1        = S_Adresse.Name1.

           
        

         
      
    end. /* ? */
END.

FOR EACH bS_ArtLief
  where bS_ArtLief.Firma      = {firma/e_artli.fir '100'}
    no-lock:
    
    if can-find(first bS_ArtKunde
      where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}
        and bS_ArtKunde.Artikel = bS_ArtLief.Artikel
      ) then
    do:
      find S_Artikel
        where S_Artikel.Firma    = {firma/sartikel.fir '100'}
          and S_Artikel.Artikel  =  bS_ArtLief.Artikel
        no-lock no-error.
      find S_Lieferant
        where S_Lieferant.Firma      = {firma/sliefera.fir '100'}
          and S_Lieferant.Lieferant  =  bS_Artlief.Lieferant
        no-lock no-error.
      find S_Adresse
        where S_Adresse.Firma     = {firma/s_adres.fir '100'}
          and S_Adresse.AdressNr  = S_Lieferant.AdressNr
        no-lock no-error.
      CREATE tt-export.
        ASSIGN
          tt-export.tt-Firma          = S_Artikel.Firma
          tt-export.tt-Artikel        = S_Artikel.Artikel
          tt-export.tt-Bezeichnung1   = S_ArtikelSpr.Bezeichnung[1]
          tt-export.tt-type           = 'L'
          tt-export.tt-KunLief        = string(bS_ArtLief.Lieferant) 
          tt-export.tt-Name1        = S_Adresse.Name1.

       
    
    end. /* ? */
END.

OUTPUT TO "D:\output16.csv".

PUT UNFORMATTED 'Firma;Artikel;Bezeichnung1;type;No;Name;' SKIP.
   FOR EACH tt-export:
    PUT UNFORMATTED
        tt-export.tt-Firma ';'
        tt-export.tt-Artikel ';'
        tt-export.tt-Bezeichnung1 ';'
        tt-export.tt-type ';'
        tt-export.tt-KunLief ';'
        tt-export.tt-Name1 SKIP.

        END.
        OUTPUT CLOSE.
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
