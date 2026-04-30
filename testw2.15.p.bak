define variable dKTG as date no-undo.
define variable dATG as date no-undo.

define variable dStart as date no-undo init today.
define variable iAmount as integer no-undo.
define variable iCount as integer no-undo.
define variable cHolidays  as character no-undo init "01/01/2026,13/04/2026,01/05/2026".

define buffer bE_ArtLief for E_ArtLief.

output to 'D:/output1.csv'.
put unformatted 'Lieferant ; Suchbegriff ; Description 1; Lieferzeit ; Lieferzeiteinheit ; TypeDate ; DeliveryDate ; MindestBestellmenge ;':U skip.


FOR EACH bE_ArtLief
  where bE_ArtLief.Firma      = {firma/e_artli.fir '100'}
  no-lock:
  if bE_ArtLief.Lieferzeit = 0 then
    next.
  ASSIGN
    iCount = 0
    dStart = today.
    dATG = dStart.

    FIND S_Artikel
      where S_Artikel.Firma    = {firma/sartikel.fir '100'}
        and S_Artikel.Artikel  = bE_ArtLief.Artikel
        no-lock no-error.

    FIND S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = S_Artikel.Artikel
        and S_ArtikelSpr.Sprache  = 'D'
        no-lock no-error.
        
    FIND S_Lieferant
      where S_Lieferant.Firma      = {firma/sliefera.fir '100'}
        and S_Lieferant.Lieferant  =  bE_ArtLief.Lieferant
        no-lock no-error.
        
    FIND S_Adresse
      where S_Adresse.Firma     = {firma/s_adres.fir '100'}
        and S_Adresse.AdressNr  = S_Lieferant.AdressNr
        no-lock no-error.


    if available bE_ArtLief and available S_Artikel and available S_ArtikelSpr then
    do:
      dKTG = dStart + bE_ArtLief.Lieferzeit.

      repeat while iCount < bE_ArtLief.Lieferzeit:
        dATG = dATG + 1.
        if WEEKDAY(dATG) = 1 or WEEKDAY(dATG) = 7 or lookup(string(dATG),cHolidays) > 0 then
        do:
          next.
        end.
        else
          iCount = iCount + 1.

        end.
       
       PUT UNFORMATTED
                  bE_ArtLief.Lieferant ";"
                  S_Adresse.Name1 ";"
                  S_ArtikelSpr.Bezeichnung[1] ";"
                  bE_ArtLief.Lieferzeit ";"
                  bE_ArtLief.Lieferzeiteinheit ";"
                  
                  (IF string(bE_ArtLief.Lieferzeiteinheit) = "3" then 'ATG' else if string(bE_ArtLief.Lieferzeiteinheit) = "4" then 'KTG' else "") ";"
                  (IF string(bE_ArtLief.Lieferzeiteinheit) = "3" then string(dATG) else if string(bE_ArtLief.Lieferzeiteinheit) = "4" then string(dKTG) else "") ";"
                  
                  bE_ArtLief.MindestBestellmenge ";"

                  skip.

    end.
    else


    end.










