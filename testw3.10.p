define variable cBelegArt as character no-undo init 'A,U,L,R'.
define variable i as integer no-undo.


define temp-table ttResult 
  field Kunde like S_Kunde.Kunde
  field iTotalA as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalU as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalL as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalR as decimal format "->,>>>,>>>,>>>,>>9.99"
  index idxKunde is primary unique Kunde.
  .

for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
   and lookup(V_BelegKopf.BelegArt,cBelegArt) > 0
      
  no-lock :
  find ttResult where ttResult.Kunde = V_BelegKopf.Kunde no-error.
    if not available ttResult then do:
        create ttResult.
        ttResult.Kunde = V_BelegKopf.Kunde.
    end.
   for each V_BelegPos
     where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
       and V_BelegPos.BelegArt     =  V_BelegKopf.BelegArt
       and V_BelegPos.ReferenzNr   =  V_BelegKopf.ReferenzNr
     no-lock :
     
     case V_BelegPos.BelegArt:
       when 'A' then ttResult.iTotalA =  ttResult.iTotalA + (V_BelegPos.Einzelpreis * V_BelegPos.Menge). 
       when 'U' then ttResult.iTotalU =  ttResult.iTotalU + (V_BelegPos.Einzelpreis * V_BelegPos.Menge). 
       when 'L' then ttResult.iTotalL =  ttResult.iTotalL + (V_BelegPos.Einzelpreis * V_BelegPos.Menge). 
       when 'R' then ttResult.iTotalR =  ttResult.iTotalR + (V_BelegPos.Einzelpreis * V_BelegPos.Menge). 
     end case.
   end.  

     
     
   end.


for each ttResult
  no-lock:
    display ttResult with width 200.
  end.

     




