for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
    and V_BelegKopf.BelegArt    =  'U'
  no-lock :
  
find V_BelegPos
  where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
    and V_BelegPos.BelegArt     = 'U'
    and V_BelegPos.ReferenzNr   =  V_BelegKopf.ReferenzNr
    and V_BelegPos.LfdNr_SR     =  0
  no-lock no-error.
  if available V_BelegPos then 
    display
       V_BelegPos.BelegArt
       V_BelegPos.PositionsNr
       V_BelegPos.Artikel
       V_Belegpos.Einzelpreis
    .
END.
