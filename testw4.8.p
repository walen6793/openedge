define variable dMin          as decimal no-undo.
define variable dMax          as decimal no-undo.
define variable iLieferantMax as integer no-undo.
define variable iLieferantMin as integer no-undo.
define variable dTotal        as decimal no-undo.
define variable dTemp         as decimal no-undo.


for each ER_BelegKopf
  where ER_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
    and ER_BelegKopf.BelegArt    =  'ERR'
  no-lock break by ER_BelegKopf.Lieferant:

  for each ER_BelegPos
    where ER_BelegPos.Firma        = {firma/ebelkop.fir '100'}
      and ER_BelegPos.BelegArt     =  ER_BelegKopf.BelegArt
      and ER_BelegPos.ReferenzNr   =  ER_BelegKopf.ReferenzNr
    no-lock:

    dTemp  = dTemp + (ER_BelegPos.Einzelpreis * ER_BelegPos.Menge).

  end.

  if last-of(ER_BelegKopf.Lieferant) then
  do:

    if dTemp > dMax then
    do:

      assign
        dMax = dTemp
        iLieferantMax = ER_BelegKopf.Lieferant.

    end. /* ? */

    if dMin = 0 and iLieferantMin = 0 then
    
      assign
        dMin = dTemp
        iLieferantMin = ER_BelegKopf.Lieferant.

    if dTemp < dMin then
    do:

      assign
        dMin = dTemp
        iLieferantMin = ER_BelegKopf.Lieferant .

    end. /* ? */
    
    dTemp = 0.

  end.
end.

display
   'Max = '            string(dMax)
   'MaxLieferant  = '  string(iLieferantMax)
   'Min = '            dMin
   'MinLieferant = '   iLieferantMin .
