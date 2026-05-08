define variable i        as integer   no-undo.
define variable cBeleg   as character no-undo init 'A,U,L,R'.
define variable cPosList as character no-undo.

define temp-table ttResult no-undo
    field BelegNr as integer
    field Artikel as character
    field Pos     as character format "x(30)".

do i = 1 to num-entries(cBeleg):
    for each V_BelegKopf
        where V_BelegKopf.Firma   = {firma/vbelegko.fir '100'}
          and V_BelegKopf.BelegArt = entry(i,cBeleg)
          
          no-lock:
        for each V_BelegPos 
            where V_BelegPos.Firma      = V_BelegKopf.Firma
              and V_BelegPos.BelegArt   = V_BelegKopf.BelegArt
              and V_BelegPos.ReferenzNr = V_BelegKopf.ReferenzNr
            no-lock
            break by V_BelegPos.BelegNummer 
                  by V_BelegPos.Artikel
                  :
            if V_BelegPos.Wertposition then
              next.
            if first-of(V_BelegPos.Artikel) then 
                cPosList = "".
            cPosList = cPosList + (if cPosList = "" then "" else ",") + string(V_BelegPos.PositionsNr).
            if last-of(V_BelegPos.Artikel) then do:
                
                if num-entries(cPosList) > 1 then do:
                    create ttResult.
                    assign 
                        ttResult.BelegNr = V_BelegPos.BelegNummer
                        ttResult.Artikel = V_BelegPos.Artikel
                        ttResult.Pos     = cPosList.
                end.
            end.
        end. /* for each V_BelegPos */
    end. /* for each V_BelegKopf */
end.

for each ttResult no-lock:
    display ttResult.
end.
