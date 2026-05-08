define variable cBelegArt as character no-undo init 'A,U,L,R'.
define variable i as integer no-undo.
define variable cBelegTotal as character no-undo init 'iTotalA,iTotalU,iTotalL,iTotalR'.

define temp-table ttResult
  field Kunde like S_Kunde.Kunde
  field iTotalA as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalU as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalL as decimal format "->,>>>,>>>,>>>,>>9.99"
  field iTotalR as decimal format "->,>>>,>>>,>>>,>>9.99"
  index idxKunde is primary unique Kunde.
  .
define temp-table ttMinMax
  field BelegArt  like V_BelegPos.BelegArt
  field maxKunde like S_Kunde.Kunde
  field iMax as decimal format "->,>>>,>>>,>>>,>>9.99"
  field minKunde like S_Kunde.Kunde
  field iMin as decimal format "->,>>>,>>>,>>>,>>9.99"
  index idxBelegArt is primary unique BelegArt.
  .
define variable dCurrentValue as decimal no-undo.  


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
do i = 1 to num-entries(cBelegArt):
    create ttMinMax.
    assign 
        ttMinMax.BelegArt = entry(i, cBelegArt)
        ttMinMax.iMin     = 999999999999.
    
    for each ttResult no-lock:   
        case ttMinMax.BelegArt:
            when 'A' then dCurrentValue = ttResult.iTotalA.
            when 'U' then dCurrentValue = ttResult.iTotalU.
            when 'L' then dCurrentValue = ttResult.iTotalL.
            when 'R' then dCurrentValue = ttResult.iTotalR.
        end case.

        
        if dCurrentValue = 0 then next.

        
        if dCurrentValue > ttMinMax.iMax then 
            assign ttMinMax.iMax     = dCurrentValue
                   ttMinMax.maxKunde = ttResult.Kunde.

       
        if dCurrentValue < ttMinMax.iMin then 
            assign ttMinMax.iMin     = dCurrentValue
                   ttMinMax.minKunde = ttResult.Kunde.
    end.
end.


for each ttMinMax no-lock by lookup(ttMinMax.BelegArt, "A,U,L,R"):
    display 
        ttMinMax.BelegArt
        ttMinMax.maxKunde
        ttMinMax.iMax      format "->,>>>,>>>,>>>,>>9.99"
        ttMinMax.minKunde
        ttMinMax.iMin     format "->,>>>,>>>,>>>,>>9.99"
        with width 150.
end.

    
    






