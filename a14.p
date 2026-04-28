define temp-table tt-export no-undo
    field tt-Artikel   LIKE  S_Artikel.Artikel
    field tt-Bezeichnung1 LIKE S_ArtikelSpr.Bezeichnung[1]
    field tt-RelateTO AS CHARACTER FORMAT 'x(60)'
    .
define buffer bS_ArtKunde FOR S_ArtKunde.
define buffer bS_ArtLief FOR E_ArtLief.
define variable cFirstChar AS CHARACTER.

FOR EACH S_Artikel WHERE S_Artikel.Firma = {firma/sartikel.firma '100'} no-lock:
    IF NOT CAN-FIND(FIRST bS_ArtKunde WHERE bS_ArtKunde.Firma = {firma/sartkund.firma '100'}
                                      AND bS_ArtKunde.Artikel = S_Artikel.Artikel)
       AND NOT CAN-FIND(FIRST bS_ArtLief WHERE bS_ArtLief.Firma = {firma/sartlief.firma '100'}
                                      AND bS_ArtLief.Artikel = S_Artikel.Artikel) THEN
        NEXT.
    FIND S_ArtikelSpr WHERE S_ArtikelSpr.Firma = {firma/sartikel.firma '100'} 
        AND S_ArtikelSpr.Artikel = S_Artikel.Artikel
        AND S_ArtikelSpr.Sprache = 'D' 
        no-lock no-error.

CREATE tt-export.
    ASSIGN
      tt-export.tt-Artikel = S_Artikel.Artikel
      tt-export.tt-Bezeichnung1 = (IF AVAILABLE S_ArtikelSpr THEN S_ArtikelSpr.Bezeichnung[1] ELSE '').
      cFirstChar = SUBSTRING(S_Artikel.Artikel,1,1).




IF LOOKUP (cFirstChar,'1,3,5,7,9') > 0 THEN
  DO:
    FIND LAST bS_ArtKunde WHERE bS_ArtKunde.Firma = {firma/sartkund.firma '100'}
                            AND bS_ArtKunde.Artikel = S_Artikel.Artikel
                            NO-LOCK NO-ERROR.
    IF AVAILABLE bS_ArtKunde THEN
      tt-export.tt-RelateTO = "Kunde : " + bS_ArtKunde.Kunde.
END.
ELSE IF LOOKUP (cFirstChar,'2,4,6,8') > 0 THEN
  DO:
    FIND LAST bS_ArtLief WHERE bS_ArtLief.Firma = {firma/sartlief.firma '100'}
                            AND bS_ArtLief.Artikel = S_Artikel.Artikel
                            NO-LOCK NO-ERROR.
    IF AVAILABLE bS_ArtLief THEN
      tt-export.tt-RelateTo = "Lieferant : " + bS_ArtLief.Lieferant.
END.
ELSE 
  DO:
    FIND FIRST bS_ArtKunde WHERE bS_ArtKunde.Firma = {firma/sartkund.firma '100'}
                            AND bS_ArtKunde.Artikel = S_Artikel.Artikel
                            NO-LOCK NO-ERROR.
    
    FIND FIRST bS_ArtLief WHERE bS_ArtLief.Firma = {firma/sartlief.firma '100'}
                            AND bS_ArtLief.Artikel = S_Artikel.Artikel
                            NO-LOCK NO-ERROR.
    tt-export.tt-RelateTO = (IF AVAILABLE bS_ArtKunde THEN "Kunde : " + bS_ArtKunde.Kunde else "") + 
                            (IF AVAILABLE bS_ArtKunde AND AVAILABLE bS_ArtLief THEN " " ELSE "") +
                            (IF AVAILABLE bS_ArtLief THEN " Lieferant : " + bS_ArtLief.Lieferant else "").



  END.
END.

OUTPUT TO ""

PUT UNFORMATTED 'Artikel,Bezeichnung,RelateTO' SKIP.

FOR EACH tt-export:
    PUT UNFORMATTED
        tt-export.tt-Artikel ','
        tt-export.tt-Bezeichnung1 ','
        tt-export.tt-RelateTO SKIP.
        END.
        OUTPUT CLOSE.


        
    
