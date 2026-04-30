define temp-table tt-Result
  field tt-Artikel     AS CHARACTER FORMAT 'x(60)'
  field tt-Bezeichnung1 AS CHARACTER


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
  where S_Artikel.Firma  = {firma/sartikel.fir '100'}
    no-lock:

    CREATE tt-Result.
        ASSIGN
          tt-Result.tt-Artikel =  S_Artikel.Artikel

          tt-Result.tt-KundeCount  = 0
          tt-Result.tt-LiefCount  = 0     .

    FIND S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = S_Artikel.Artikel
        and S_ArtikelSpr.Sprache = 'D'
        no-lock no-error.

        if available S_ArtikelSpr then
        ASSIGN
          tt-Result.tt-Bezeichnung1 =  S_ArtikelSpr.Bezeichnung[1] +  " " + S_ArtikelSpr.Bezeichnung[2] .



        FOR EACH bS_ArtKunde
          where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}
            and bS_ArtKunde.Artikel =  S_Artikel.Artikel
            no-lock:


              tt-Result.tt-KundeCount = tt-Result.tt-KundeCount + 1.


              if tt-Result.tt-KundeCount = 1 then
                do:
                   FIND S_Kunde
                     where S_Kunde.Firma  = {firma/sartkund.fir '100'}
                       and S_Kunde.Kunde  =  bS_ArtKunde.Kunde
                       no-lock no-error.
                    ASSIGN
                      tt-Result.tt-KundeID = string(bS_ArtKunde.Kunde)
                      tt-Result.tt-KundeName = (IF AVAILABLE S_Kunde THEN S_Kunde.Suchbegriff else "":U).

                end. /* ? */
        end. /* for each bS_ArtKunde */

        FOR EACH bS_ArtLief
          where bS_ArtLief.Firma      = {firma/e_artli.fir '100'}

            and  bS_ArtLief.Artikel = S_Artikel.Artikel
            no-lock:
              tt-Result.tt-LiefCount = tt-Result.tt-LiefCount + 1.
              if tt-Result.tt-LiefCount = 1 then
                do:
                  FIND S_Lieferant

                    where S_Lieferant.Firma = {firma/sliefera.fir '100'}
                    AND S_Lieferant.Lieferant = bS_ArtLief.Lieferant
                    no-lock no-error.
                    ASSIGN
                      tt-Result.tt-LiefID = string(bS_ArtLief.Lieferant)
                      tt-Result.tt-LiefName = (IF AVAILABLE S_Lieferant THEN S_Lieferant.Suchbegriff else "":U ).
                end.
        end. /* for each bS_ArtLief */

end. /* for each S_Artikel */

FOR EACH tt-Result
  WHERE tt-Result.tt-KundeCount = 1
    and tt-Result.tt-LiefCount = 1
    no-lock:
        DISPLAY tt-Result.tt-Artikel
                tt-Result.tt-Bezeichnung1
                tt-Result.tt-KundeID
                tt-Result.tt-KundeName
                tt-Result.tt-LiefID
                tt-Result.tt-LiefName
        WITH FRAME fRes 20 DOWN SCREEN-IO.

END. /* for each tt_Result */
                      
