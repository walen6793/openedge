output to 'D:/output34.csv'.
put unformatted 'BelegArt;Artikel;Menge(U); Einzelpreis(U);Gesamtpreis(U); Menge(EB); Einzelpreis(EB);Gesamtpreis(EB); Gewinn;':U skip.

define variable dTotalV as decimal no-undo.
define variable dTotalE as decimal no-undo.

define temp-table ttResult
  field BelegArtU like V_BelegPos.BelegArt
  field Artikel like S_Artikel.Artikel
  field MengeU like V_BelegPos.Menge
  field EinzelpreisU like V_BelegPos.Einzelpreis
  field GesamtpreisU AS decimal
  field MengeEB like E_BelegPos.Menge
  field EinzelpreisEB like E_BelegPos.Einzelpreis
  field GesamtpreisEB AS decimal
  field Gewinn AS decimal

  .




for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
    and V_BelegKopf.BelegArt    =  'U'
  no-lock:

    for each V_BelegPos
      where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
        and V_BelegPos.BelegArt     =  V_BelegKopf.BelegArt
        and V_BelegPos.ReferenzNr   =  V_BelegKopf.ReferenzNr
      no-lock break by V_BelegPos.Artikel:

        find E_BelegPos
          where E_BelegPos.Firma               = {firma/ebelkop.fir '100'}
            and E_BelegPos.BelegArt            = 'EB'
            and E_BelegPos.Coverage_MRPDocType = V_BelegPos.BelegArt
            and E_BelegPos.Coverage_Obj        = V_BelegPos.V_BelegPos_Obj
            and E_BelegPos.Artikel             = V_BelegPos.Artikel
          no-lock no-error.

          if available E_BelegPos then
          do:

            find E_BelegKopf
            where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
              and E_BelegKopf.BelegArt    = E_BelegPos.BelegArt
              and E_BelegKopf.ReferenzNr  = E_BelegPos.ReferenzNr
            no-lock no-error.

              dTotalV = dTotalV + (V_BelegPos.Menge * V_BelegPos.Einzelpreis).

              dTotalE = dTotalE + (E_BelegPos.Menge * E_BelegPos.Einzelpreis).
              
              if last-of(V_BelegPos.Artikel) then
              do:
              
                create ttResult.
                assign
                  ttResult.BelegArtU        =  V_BelegKopf.BelegArt
                  ttResult.Artikel            =  V_BelegPos.Artikel
                  ttResult.MengeU           =  V_BelegPos.Menge
                  ttResult.EinzelpreisU     =  V_BelegPos.Einzelpreis
                  ttResult.GesamtpreisU     =  dTotalV
                  ttResult.MengeEB          =  E_BelegPos.Menge
                  ttResult.EinzelpreisEB    =  E_BelegPos.Einzelpreis
                  ttResult.GesamtpreisEB    =  dTotalE
                  ttResult.Gewin            =  dTotalV - dTotalE
                   dTotalV = 0
                   dTotalE = 0
                  .

              end. /* ? */
              
          end.

      end.



end.

for each ttResult
  no-lock:
    PUT UNFORMATTED
      ttResult.BelegArtU      ";"
        ttResult.Artikel        ";"
        ttResult.MengeU         ";"
        ttResult.EinzelpreisU   ";"
        ttResult.GesamtpreisU   ";"
        ttResult.MengeEB        ";"
        ttResult.EinzelpreisEB  ";"
        ttResult.GesamtpreisEB  ";"
        ttResult.Gewinn         skip.
end.
