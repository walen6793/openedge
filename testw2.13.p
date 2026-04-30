define temp-table tt_Result NO-UNDO
  field tt-Artikel     AS CHARACTER
  field tt-Bezeichnung AS CHARACTER
  field tt-KundeID     AS CHARACTER
  field tt-KundeCount     AS INTEGER
  field tt-LiefCount     AS INTEGER
  field tt-KundeName    AS CHARACTER
  field tt-LiefID       AS CHARACTER
  field tt-LiefName     AS CHARACTER

.

define buffer bS_ArtKunde FOR S_ArtKunde.
define buffer bS_ArtLief FOR E_ArtLief.


FOR EACH S_Artikel 
  where S_Artikel.Firma = {firma/sartikel.fir '100'}
    no-lock:
    FOR EACH S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = S_Artikel.Artikel
        no-lock:

      CREATE tt-Result.
        ASSIGN
          tt-Result.tt-Artikel =  bS_ArtKunde.Artikel
          tt-Result.tt-Bezeichnung =  bS_ArtikelSpr.Bezeichnung[1]
          tt-Result.tt-KundeCount  = 0
          tt-Result.tt-LiefCount  = 0     .
          
        FOR EACH bS_ArtKunde
          where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}
            and bS_ArtKunde.Artikel =  S_Artikel.Artikel
            no-lock:
              tt-Result.tt-KundeCount = tt-Result.tt-KundeCount + 1.
              if tt-Result.tt-KundeCount = 1 then
                do:
                   FIND FIRST S_Kunde
                     where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
                       and S_Kunde.Kunde  =  bS_ArtKunde.Kunde
                       no-lock no-error.
                    ASSIGN
                      tt-Result.KundeID = bS_ArtKunde.Kunde
                      tt-Result.KundeName = (IF AVAILABLE S_Kunde THEN S_Kunde.Suchbegriff else "":U).
                      

                
                end. /* ? */
                
                end.



          
