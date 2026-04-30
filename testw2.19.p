define buffer bE_ArtLiefDatum for E_ArtLiefDatum.


define temp-table tt-Result no-undo
  field tt-Artikel  LIKE S_Artikel.Artikel
  field tt-SuppierName AS CHARACTER FORMAT 'x(60)'
  field tt-MinCost AS DECIMAL
  field tt-KundeName    AS CHARACTER FORMAT 'x(60)'
  field tt-MaxCost AS DECIMAL
  field tt-Profit  AS DECIMAL
  .


FOR EACH S_Artikel
  where S_Artikel.Firma        = {firma/sartikel.fir '100'}
    no-lock :
    if can-find(first E_ArtLiefStaffel
                where E_ArtLiefStaffel.Firma  = {firma/e_artli.fir '100'}
                  and E_ArtLiefStaffel.Artikel       = S_Artikel.Artikel)
                and can-find(first S_ArtKundeStaffel
                where S_ArtKundeStaffel.Firma        = {firma/sartkund.fir '100'}
                  and S_ArtKundeStaffel.Artikel = S_Artikel.Artikel)
                   then
     do:
       message
         S_Artikel.Artikel.
       CREATE tt-Result.
         tt-Result.tt-Artikel = S_Artikel.Artikel.
       FOR EACH E_ArtLiefStaffel
          where E_ArtLiefStaffel.Firma         = {firma/e_artli.fir '100'}
            and E_ArtLiefStaffel.Artikel       = S_Artikel.Artikel
          no-lock BY E_ArtLiefStaffel.Preis:


            FIND FIRST S_Lieferant
              where S_Lieferant.Firma      = {firma/sliefera.fir '100'}
                and S_Lieferant.Lieferant  = E_ArtLiefStaffel.Lieferant
                no-lock no-error.
            ASSIGN
              tt-Result.tt-SuppierName = S_Lieferant.Suchbegriff
              tt-Result.tt-MinCost     = E_ArtLiefStaffel.Preis
            .
            LEAVE.





     end. /* ? */

     FOR EACH S_ArtKundeStaffel
       where S_ArtKundeStaffel.Firma         = {firma/sartkund.fir '100'}
         and S_ArtKundeStaffel.Artikel       = S_Artikel.Artikel
         no-lock by S_ArtKundeStaffel.Preis DESCENDING :

       if available S_ArtKundeStaffel then

       do:
         FIND FIRST S_Kunde
           where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
             and S_Kunde.Kunde  =  S_ArtKundeStaffel.Kunde
             no-lock no-error.
         ASSIGN
           tt-Result.tt-KundeName = S_Kunde.Suchbegriff
           tt-Result.tt-MaxCost   = S_ArtKundeStaffel.Preis
         .
         LEAVE.


       end. /* ? */





    end.

    tt-Result.tt-Profit = tt-Result.tt-MaxCost - tt-Result.tt-MinCost.
   end.


end.

FOR EACH tt-Result:
   DISPLAY
      tt-Result.tt-Artikel      LABEL "Artikel"
      tt-Result.tt-SuppierName  LABEL "supplier name1"
      tt-Result.tt-MinCost      LABEL "cost price"
      tt-Result.tt-KundeName    LABEL "customer name"
      tt-Result.tt-MaxCost      LABEL "selling price"
      tt-Result.tt-Profit       LABEL "profit."
      WITH FRAME fReport 20 DOWN.
      .
      end.












