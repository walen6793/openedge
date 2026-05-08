
define temp-table ttResult
  
  field iMonth  as integer
  field iYear   as integer
  field dTotalMonth   as decimal  format '->>>,>>>,>>9.99' 
  field dTotalYear   as decimal format '->>>,>>>,>>9.99' 
  .
define variable dTotalMonth as decimal no-undo.
define variable dTotalYear as decimal no-undo.
 
for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
    and V_BelegKopf.BelegArt    = 'U'
  no-lock break 
                by YEAR(V_BelegKopf.BelegDatum)
                by MONTH(V_BelegKopf.BelegDatum):
  for each V_BelegPos
    where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
      and V_BelegPos.BelegArt     = V_BelegKopf.BelegArt
      and V_BelegPos.ReferenzNr   = V_BelegKopf.ReferenzNr
    no-lock :


   
    
    dTotalMonth = dTotalMonth + (V_BelegPos.Einzelpreis * V_BelegPos.Menge).
    
    end.
    if last-of(MONTH(V_BelegKopf.BelegDatum)) then
    do:
      dTotalYear = dTotalYear + dTotalMonth.
    create ttResult.

    assign
      ttResult.iMonth        = MONTH(V_BelegKopf.BelegDatum)
      ttResult.iYear         = YEAR(V_BelegKopf.BelegDatum)
      ttResult.dTotalMonth   = dTotalMonth
      ttResult.dTotalYear    = dTotalYear
      .
      dTotalMonth = 0.
    end.  
   if last-of(YEAR(V_BelegKopf.BelegDatum)) then
    do:
      dTotalYear = 0.

    end.
   
end.
for each ttResult
  no-lock:
  display
    ttResult.

    end.
