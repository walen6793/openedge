output to 'D:/output35.csv'.
put unformatted 'List of Document ; PositionsNr;List of Document No; List of missing document type ;':U skip.


define temp-table ttResult
 field belegList       as   character
 field positionNr      like E_BelegPos.PositionsNr
 field belegNrList     as character
 field belegMissing    as   character
 .

define buffer bE_BelegPos  for E_BelegPos.
define buffer bE_BelegKopf for E_BelegKopf.
define buffer bEA_AnfPos for EA_AnfPos.

for each E_BelegKopf
  where E_BelegKopf.Firma      = '100'
    and E_BelegKopf.BelegArt   = 'EB'
  no-lock:

    for each E_BelegPos
      where E_BelegPos.Firma      = '100'
        and E_BelegPos.BelegArt   = E_BelegKopf.BelegArt
        and E_BelegPos.ReferenzNr = E_BelegKopf.ReferenzNr
      no-lock:

      create ttResult.

      find first bE_BelegPos
        where bE_BelegPos.Firma            = {firma/ebelkop.fir '100'}
          and bE_BelegPos.BelegArt         = E_BelegPos.BelegArt
          and bE_BelegPos.Herk_Belegart    = 'EAA'
          and bE_BelegPos.Herk_PositionsNr = E_BelegPos.PositionsNr
          and bE_BelegPos.ReferenzNr       = E_BelegPos.ReferenzNr
        no-lock no-error.

        if not available bE_BelegPos then
          ttResult.belegMissing = ttResult.belegMissing + ',' + 'EAA' .

      if available bE_BelegPos then
      do:

        find EA_AnfPos
          where EA_AnfPos.Firma        = {firma/ebelkop.fir '100'}
            and EA_AnfPos.ReferenzNr   =  bE_BelegPos.Herk_ReferenzNr
            and EA_AnfPos.PositionsNr  =  bE_BelegPos.Herk_PositionsNr
          no-lock no-error.

        find EA_AnfKopf
          where EA_AnfKopf.Firma       = {firma/ebelkop.fir '100'}
            and EA_AnfKopf.ReferenzNr  =  EA_AnfPos.ReferenzNr
          no-lock no-error.
          
          if available EA_AnfKopf then
            assign
              ttResult.BelegList   = ttResult.BelegList + ',' + 'EAA'
              ttResult.belegNrList = ttResult.belegNrList + ',' + string(EA_AnfKopf.BelegNummer).

      end. /* ? */
      
      assign
        ttResult.positionNr  = E_BelegPos.PositionsNr
        ttResult.BelegList   = ttResult.BelegList + ',' + E_BelegPos.BelegArt
        ttResult.belegNrList = ttResult.belegNrList + ',' + string(E_BelegKopf.BelegNummer).

      find E_WE_Pos
        where E_WE_Pos.Firma             = {firma/ebelkop.fir '100'}
          and E_WE_Pos.Herk_Belegart     =  E_BelegPos.BelegArt
          and E_WE_Pos.Herk_ReferenzNr   =  E_BelegPos.ReferenzNr
          and E_WE_Pos.Herk_PositionsNr  =  E_BelegPos.PositionsNr
        no-lock no-error.

        if not available E_WE_POS then
        do:

          ttResult.belegMissing = ttResult.belegMissing + ',' + 'EWE' .

          find ER_BelegPos
            where ER_BelegPos.Firma            = {firma/ebelkop.fir '100'}
              and ER_BelegPos.BelegArt         = 'ERR'
              and ER_BelegPos.Herk_Belegart    =  E_BelegPos.BelegArt
              and ER_BelegPos.Herk_ReferenzNr  =  E_BelegPos.ReferenzNr
              and ER_BelegPos.Herk_PositionsNr =  E_BelegPos.PositionsNr
            no-lock no-error.

            if available ER_BelegPos then
            do:

              find ER_BelegKopf
                where ER_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
                  and ER_BelegKopf.BelegArt    = ER_BelegPos.BelegArt
                  and ER_BelegKopf.ReferenzNr  = ER_BelegPos.ReferenzNr
                no-lock no-error.

                if available ER_BelegKopf then
                  assign
                    ttResult.BelegList   = ttResult.BelegList + ',' + ER_BelegPos.BelegArt
                    ttResult.belegNrList = ttResult.belegNrList + ',' + string(ER_BelegKopf.BelegNummer)
                  .
                
            end.
            
            if not available ER_BelegPos then
              ttResult.belegMissing = ttResult.belegMissing + ',' + 'ERR'  .

        end.
        
        if available E_WE_Pos then
        do:

          find E_WE_Kopf
            where E_WE_Kopf.Firma       = {firma/ebelkop.fir '100'}
              and E_WE_Kopf.ReferenzNr  =  E_WE_Pos.ReferenzNr
            no-lock no-error.

            if available E_WE_Kopf then
              assign
                ttResult.BelegList   = ttResult.BelegList + ',' + 'EWE'
                ttResult.belegNrList = ttResult.belegNrList + ',' + string(E_WE_Kopf.BelegNummer)
              .

          find ER_BelegPos
            where ER_BelegPos.Firma           = {firma/ebelkop.fir '100'}
              and ER_BelegPos.BelegArt        =  'ERR'
              and ER_BelegPos.WE_ReferenzNr   =  E_WE_Pos.ReferenzNr
              and ER_BelegPos.WE_PositionsNr  =  E_WE_Pos.PositionsNr
            no-lock no-error.

            if not available ER_BelegPos then
               ttResult.belegMissing = ttResult.belegMissing + ',' + 'ERR' .

            if available ER_BelegPos then
            do:

              find ER_BelegKopf
                where ER_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
                  and ER_BelegKopf.BelegArt    = ER_BelegPos.BelegArt
                  and ER_BelegKopf.ReferenzNr  = ER_BelegPos.ReferenzNr
                no-lock no-error.
                
                if available ER_BelegKopf then
                  assign
                    ttResult.BelegList   = ttResult.BelegList + ',' + ER_BelegPos.BelegArt
                    ttResult.belegNrList = ttResult.belegNrList + ',' + string(ER_BelegKopf.BelegNummer)
                  .

            end. /* ? */

        end. /* ? */

    end.
end.

release EA_AnfKopf.

for each EA_AnfKopf
  where EA_AnfKopf.Firma       = {firma/ebelkop.fir '100'}
  no-lock:

    for each bEA_AnfPos
      where bEA_AnfPos.Firma        = {firma/ebelkop.fir '100'}
        and bEA_AnfPos.ReferenzNr   =  EA_AnfKopf.ReferenzNr
      no-lock:

      find first E_BelegPos
        where E_BelegPos.Firma            = {firma/ebelkop.fir '100'}
          and E_BelegPos.BelegArt         = 'EB'
          and E_BelegPos.Herk_Belegart    = 'EAA'
          and E_BelegPos.Herk_ReferenzNr  = bEA_AnfPos.ReferenzNr
          and E_BelegPos.Herk_PositionsNr = bEA_AnfPos.PositionsNr
        no-lock no-error.

      if not available E_BelegPos then
      do:

        create ttResult.
          assign
            ttResult.BelegList = ttResult.BelegList + ',' + 'EAA'
            ttResult.belegNrList = ttResult.belegNrList + ',' + string(EA_AnfKopf.BelegNummer)
            ttResult.belegMissing = ttResult.belegMissing + ',' + 'EB,EWE,ERR'
            .
            
      end. /* ? */
      
    end.
    
end.

for each ttResult
  no-lock:
    PUT UNFORMATTED
      ttResult.BelegList      ";"
      ttResult.positionNr     ";"
      ttResult.belegNrList   ";"
      ttResult.belegMissing   skip.

end.
