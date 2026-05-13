define temp-table ttResult
  field BelegNr                      like E_BelegKopf.BelegNummer
  field Artikel                      like S_Artikel.Artikel
  field MengeEB                      like E_BelegPos.Menge
  field LiefermengeEWE               like E_WE_Pos.LieferMenge
  field dOutQTY                      as decimal
  .

output to 'D:/output37.csv'.
put unformatted 'BelegNummer (EB);Artikel;Menge(EB);LieferMenge(EWE);Outstanding Quantity ;':U skip.

for each E_BelegKopf
  where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
    and E_BelegKopf.BelegArt    = 'EB'
  no-lock:

  for each E_BelegPos
    where E_BelegPos.Firma        = {firma/ebelkop.fir '100'}
      and E_BelegPos.BelegArt     = E_BelegKopf.BelegArt
      and E_BelegPos.ReferenzNr   = E_BelegKopf.ReferenzNr
    no-lock:

    find E_WE_Pos
      where E_WE_Pos.Firma       = {firma/ebelkop.fir pACConnectionSvc:prpcCompany}
        and E_WE_Pos.ReferenzNr  = E_BelegPos.ReferenzNr
        and E_WE_Pos.PositionsNr = E_BelegPos.PositionsNr
      no-lock no-error.

      if available E_WE_Pos then
      do:
        
        if E_WE_Pos.LieferMenge >= E_BelegPos.Menge then
          next.
        
        
        find E_WE_Kopf
          where E_WE_Kopf.Firma       = {firma/ebelkop.fir '100'}
            and E_WE_Kopf.ReferenzNr  = E_WE_Pos.ReferenzNr
          no-lock no-error.

          if not available E_WE_Kopf then
            next.

        create ttResult.
        assign
          ttResult.BelegNr        = E_BelegKopf.BelegNummer
          ttResult.Artikel        = E_BelegPos.Artikel
          ttResult.MengeEB        = E_BelegPos.Menge
          ttResult.LiefermengeEWE = E_WE_Pos.LieferMenge
          ttResult.dOutQTY        = E_BelegPos.Menge - E_WE_Pos.LieferMenge
        .

      end. /* ? */
  end.
end.
for each ttResult
  no-lock:

    PUT UNFORMATTED
      ttResult.BelegNr      ";"
      ttResult.Artikel     ";"
      ttResult.MengeEB    ";"
      ttResult.LiefermengeEWE  ";"
      ttResult.dOutQTY skip.
end.


