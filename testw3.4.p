

current-window:width = 150.

define variable iTotal AS decimal.
define temp-table Result
  field tt-BelegNumber like V_BelegPos.BelegNummer
  field tt-Artikel like V_BelegPos.Artikel
  field tt-BelegArt like V_BelegPos.BelegArt
  field tt-PositionNr like V_BelegPos.PositionsNr
  field tt-Einzelpreis like V_BelegPos.Einzelpreis
  field tt-Menge like V_BelegPos.Menge
  field tt-Total as decimal format "->,>>>,>>>,>>>,>>9.99".
  
for each V_BelegPos
  where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
    and V_BelegPos.BelegArt     = 'U'
  no-lock break by V_BelegPos.BelegNummer by V_BelegPos.PositionsNr :
  
  if first-of(V_BelegPos.BelegNummer) then
  do:
    
     iTotal = 0.
  end.
  iTotal = iTotal + (V_BelegPos.Einzelpreis * V_BelegPos.Menge ).  

  create Result.
  ASSIGN
    Result.tt-BelegNumber = V_BelegPos.BelegNummer
    Result.tt-Artikel = V_BelegPos.Artikel
    Result.tt-BelegArt = V_BelegPos.BelegArt
    Result.tt-PositionNr = V_BelegPos.PositionsNr
    Result.tt-Einzelpreis = V_BelegPos.Einzelpreis
    Result.tt-Menge= V_BelegPos.Menge
    Result.tt-Total = iTotal
  .
  
  
end.

for each Result
  no-lock:
DISPLAY
    Result.tt-BelegNumber
    Result.tt-Artikel 
    Result.tt-BelegArt 
    Result.tt-PositionNr 
    Result.tt-Einzelpreis 
    Result.tt-Menge
    Result.tt-Total FORMAT "->,>>>,>>>,>>>,>>9.99"
    with width 200
    .
    end.

  
