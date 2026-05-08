define temp-table ttResult
  field KundeID LIKE S_Kunde.Kunde
  field Name1 LIKE S_Adresse.Name1
  field BelegNrU LIKE V_BelegKopf.BelegNummer
  field BelegNrL  LIKE V_BelegKopf.BelegNummer
  field AdoptL AS LOGICAL
  field BelegNrR  LIKE V_BelegKopf.BelegNummer
  field AdoptR AS LOGICAL
  field Pos AS CHARACTER
  field Artikel LIKE S_Artikel.Artikel
  field Bezeichnung1 AS CHARACTER
  .
define buffer bV_BelegPos for V_Belegpos.
define buffer bxV_BelegPos for V_Belegpos.

OUTPUT TO "D:\output17.csv".
PUT UNFORMATTED 'KundeID;Name1;RelateTO;BelegNrU;AdoptL;BelegNrR;AdoptR;Pos;Artikel;Bezeichnung1' SKIP.
for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
    and V_BelegKopf.BelegArt    = 'u'
  no-lock:
    for each V_BelegPos
      where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
        and V_BelegPos.BelegArt     = V_BelegKopf.BelegArt
        and V_BelegPos.ReferenzNr   = V_BelegKopf.ReferenzNr
      no-lock:
      create ttResult.
      
      
      for each bV_BelegPos
        where bV_BelegPos.Firma            = {firma/vbelegko.fir '100'}
          and bV_BelegPos.BelegArt         =  'L'
          and bV_BelegPos.Herk_BelegArt    = V_BelegPos.BelegArt
          and bV_BelegPos.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
          and bV_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
        no-lock:
        assign
          ttResult.BelegNrL = bV_BelegPos.BelegNummer
          ttResult.AdoptL   = yes.
      find first bxV_BelegPos
        where bxV_BelegPos.Firma            = {firma/vbelegko.fir '100'}
          and bxV_BelegPos.BelegArt         = 'R'
          and bxV_BelegPos.Herk_BelegArt    = bV_BelegPos.BelegArt
          and bxV_BelegPos.Herk_ReferenzNr  = bV_BelegPos.ReferenzNr
          and bxV_BelegPos.Herk_PositionsNr = bV_BelegPos.PositionsNr
        no-lock no-error.
      if available bxV_BelegPos then
        assign
          ttResult.BelegNrR = bxV_BelegPos.BelegNummer
          ttResult.AdoptR   = yes.
      release bxV_BelegPos.
      end.
      find first bxV_BelegPos
        where bxV_BelegPos.Firma            = {firma/vbelegko.fir '100'}
          and bxV_BelegPos.BelegArt         = 'R'
          and bxV_BelegPos.Herk_BelegArt    = V_BelegPos.BelegArt
          and bxV_BelegPos.Herk_ReferenzNr  = V_BelegPos.ReferenzNr
          and bxV_BelegPos.Herk_PositionsNr = V_BelegPos.PositionsNr
        no-lock no-error.
      if available bxV_BelegPos then
        assign
          ttResult.BelegNrR = bxV_BelegPos.BelegNummer
          ttResult.AdoptR   = yes.


      FIND S_Kunde
         where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
           and S_Kunde.Kunde  = V_BelegKopf.Kunde
         no-lock no-error.
     FIND S_Adresse
       where S_Adresse.Firma     = {firma/s_adres.fir '100'}
         and S_Adresse.AdressNr  =  S_Kunde.AdressNr
       no-lock no-error.
     FIND S_ArtikelSpr
       where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
         and S_ArtikelSpr.Artikel  = V_BelegPos.Artikel
         and S_ArtikelSpr.Sprache  = 'D'
       no-lock no-error.

      assign
          ttResult.KundeID      = V_BelegKopf.Kunde
          ttResult.BelegNrU     = (if available V_BelegKopf then V_BelegKopf.BelegNummer else 0)
          ttResult.Name1        = (if available S_Adresse then S_Adresse.Name1 else "")
          ttResult.Pos          = string(V_BelegPos.PositionsNr)
          ttResult.Artikel      = V_BelegPos.Artikel
          ttResult.Bezeichnung1 = S_ArtikelSpr.Bezeichnung[1].
    end.
end.










for each ttResult
  no-lock:
   PUT UNFORMATTED
    ttResult.KundeID ';'
    ttResult.Name1 ';'
    ttResult.BelegNrU ';'
    ttResult.BelegNrL ';'
    ttResult.AdoptL ';'
    ttResult.BelegNrR ';'
    ttResult.AdoptR ';'
    ttResult.Pos ';'
    ttResult.Artikel ';'
    ttResult.Bezeichnung1 skip.
      end.
  
