output to 'D:/output36.csv'.
put unformatted 'List of Document ; PositionsNr;List of Document No; List of missing document type ;':U skip.


define temp-table ttResult
 field belegList       as   character
 field positionNr      like E_BelegPos.PositionsNr
 field belegNrList     as character
 field belegMissing    as   character
 .
 
define buffer bE_BelegPos for E_BelegPos.

for each ER_BelegKopf
  where ER_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
    and ER_BelegKopf.BelegArt    = 'ERR'
  no-lock:
  
    for each ER_BelegPos
      where ER_BelegPos.Firma        = {firma/ebelkop.fir '100'}
        and ER_BelegPos.BelegArt     =  ER_BelegKopf.BelegArt
        and ER_BelegPos.ReferenzNr   =  ER_BelegKopf.ReferenzNr
      no-lock:
      
      create ttResult.
      assign
        ttResult.belegList = ttResult.belegList + ',' +  ER_BelegKopf.BelegArt
        ttResult.belegNrList = ttResult.belegNrList + ',' + string(ER_BelegKopf.BelegNummer)
        ttResult.positionNr = ER_BelegPos.PositionsNr.
      find E_WE_Pos
        where E_WE_Pos.Firma        = {firma/ebelkop.fir '100'}
          and E_WE_Pos.ReferenzNr   = ER_BelegPos.WE_ReferenzNr
          and E_WE_Pos.PositionsNr  = ER_BelegPos.WE_PositionsNr
        no-lock no-error.
        
        if available E_WE_Pos then
        do:

          find E_WE_Kopf
            where E_WE_Kopf.Firma       = {firma/ebelkop.fir '100'}
              and E_WE_Kopf.ReferenzNr  =  E_WE_Pos.ReferenzNr
            no-lock no-error.
            
            assign
              ttResult.belegList = ttResult.belegList + ',' +  'EWE'
              ttResult.belegNrList = ttResult.belegNrList + ',' + string(E_WE_Kopf.BelegNummer) .

          find E_BelegPos
            where E_BelegPos.Firma       = {firma/ebelkop.fir pACConnectionSvc:prpcCompany}
              and E_BelegPos.BelegArt    = E_WE_Pos.Herk_Belegart
              and E_BelegPos.ReferenzNr  = E_WE_Pos.Herk_ReferenzNr
              and E_BelegPos.PositionsNr = E_WE_Pos.Herk_PositionsNr
            no-lock no-error.
            
            if available E_BelegPos then
            do:
            
              find E_BelegKopf
                where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
                  and E_BelegKopf.BelegArt    = E_BelegPos.BelegArt
                  and E_BelegKopf.ReferenzNr  = E_BelegPos.ReferenzNr
                no-lock no-error.
            
              assign
                ttResult.belegList = ttResult.belegList + ',' +  E_BelegKopf.BelegArt
                ttResult.belegNrList = ttResult.belegNrList + ',' + string(E_BelegKopf.BelegNummer) .
            
              for each bE_BelegPos
                where bE_BelegPos.Firma            = {firma/ebelkop.fir '100'}
                  and bE_BelegPos.BelegArt         =  'EB'
                  and bE_BelegPos.Herk_Belegart    =  'EAA'
                  and bE_BelegPos.Herk_PositionsNr =  E_BelegPos.PositionsNr
                  and bE_BelegPos.ReferenzNr       =  E_BelegPos.ReferenzNr
                no-lock:
                
                find EA_AnfPos
                  where EA_AnfPos.Firma        = {firma/ebelkop.fir '100'}
                    and EA_AnfPos.ReferenzNr   = bE_BelegPos.Herk_ReferenzNr
                    and EA_AnfPos.PositionsNr  = bE_BelegPos.Herk_PositionsNr
                  no-lock no-error.
                  
                  if available EA_AnfPos then
                  do:
                  
                    find EA_AnfKopf
                      where EA_AnfKopf.Firma       = {firma/ebelkop.fir '100'}
                        and EA_AnfKopf.ReferenzNr  =  EA_AnfPos.ReferenzNr
                      no-lock no-error.
                      
                     assign
                       ttResult.belegList = ttResult.belegList + ',' +  'EAA'
                       ttResult.belegNrList = ttResult.belegNrList + ',' + string(EA_AnfKopf.BelegNummer) .
                      
                  
                  end. /* ? */
                  if not available EA_AnfPos then
                    ttResult.belegMissing =  ttResult.belegMissing + 'EA' .
                  
               end.
            
             end. /* ? */
             if not available E_BelegPos then
               ttResult.belegMissing =  ttResult.belegMissing + 'EB' .
        
        end. /* ? */
        
        if not available E_WE_Pos then
           ttResult.belegMissing =  ttResult.belegMissing + 'EWE' .
        
          find E_BelegPos
            where E_BelegPos.Firma       = {firma/ebelkop.fir pACConnectionSvc:prpcCompany}
              and E_BelegPos.BelegArt    = ER_BelegPos.BelegArt
              and E_BelegPos.ReferenzNr  = ER_BelegPos.ReferenzNr
              and E_BelegPos.PositionsNr = ER_BelegPos.PositionsNr
            no-lock no-error.
            
            if available E_BelegPos then
            do:
            
              find E_BelegKopf
                where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
                  and E_BelegKopf.BelegArt    =  E_BelegPos.BelegArt
                  and E_BelegKopf.ReferenzNr  =  E_BelegPos.ReferenzNr
                no-lock no-error.
            
              assign
                ttResult.belegList = ttResult.belegList + ',' +  E_BelegKopf.BelegArt
                ttResult.belegNrList = ttResult.belegNrList + ',' + string(E_BelegKopf.BelegNummer) .
            
              for each bE_BelegPos
                where bE_BelegPos.Firma            = {firma/ebelkop.fir '100'}
                  and bE_BelegPos.BelegArt         = 'EB'
                  and bE_BelegPos.Herk_Belegart    = 'EAA'
                  and bE_BelegPos.Herk_PositionsNr = E_BelegPos.PositionsNr
                  and bE_BelegPos.ReferenzNr       = E_BelegPos.ReferenzNr
                no-lock:
                
                find EA_AnfPos
                  where EA_AnfPos.Firma        = {firma/ebelkop.fir '100'}
                    and EA_AnfPos.ReferenzNr   =  bE_BelegPos.Herk_ReferenzNr
                    and EA_AnfPos.PositionsNr  =  bE_BelegPos.Herk_PositionsNr
                  no-lock no-error.
                  
                  if available EA_AnfPos then
                  do:
                  
                    find EA_AnfKopf
                      where EA_AnfKopf.Firma       = {firma/ebelkop.fir '100'}
                        and EA_AnfKopf.ReferenzNr  =  EA_AnfPos.ReferenzNr
                      no-lock no-error.
                      
                    assign
                       ttResult.belegList = ttResult.belegList + ',' +  'EAA'
                       ttResult.belegNrList = ttResult.belegNrList + ',' + string(EA_AnfKopf.BelegNummer) .
                  
                  end. /* ? */
                  if not available EA_AnfPos then
                    ttResult.belegMissing =  ttResult.belegMissing + 'EA' .
                  
                
              end.

            
            end. /* ? */
            if not available E_BelegPos then
              ttResult.belegMissing =  ttResult.belegMissing + 'EB' .

        
      end. /* ? */
end.


for each ttResult
  no-lock:
    PUT UNFORMATTED
      ttResult.BelegList      ";"
      ttResult.positionNr     ";"
      ttResult.belegNrList   ";"
      ttResult.belegMissing   skip.

end.
