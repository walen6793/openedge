define buffer bV_BelegPos for V_BelegPos.

define temp-table Result
  field tt-Kunde like V_BelegKopf.Kunde
  field tt-Name1 like S_Adresse.Name1
  field tt-BelegNrA like V_BelegKopf.BelegNummer
  field tt-BelegNrU like V_BelegKopf.BelegNummer
  field tt-Pos like V_BelegPos.PositionsNr
  field tt-Artikel like V_BelegPos.Artikel
  field tt-Bezeichnung as character
  field tt-Adoption as logical.
  
FOR EACH V_BelegPos
  where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
    and V_BelegPos.BelegArt     = 'A'
    no-lock :
    
    FIND V_BelegKopf
      where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
        and V_BelegKopf.BelegArt    = V_BelegPos.BelegArt
        and V_BelegKopf.ReferenzNr  = V_BelegPos.ReferenzNr
        no-lock no-error.
    FIND S_Kunde
      where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
        and S_Kunde.Kunde  =  V_BelegKopf.Kunde
        no-lock no-error.
        
    FIND S_Adresse
      where S_Adresse.Firma     = {firma/s_adres.fir '100'}
        and S_Adresse.AdressNr  = S_Kunde.AdressNr
        no-lock no-error.

    FIND FIRST bV_BelegPos
      where bV_BelegPos.Firma            = {firma/vbelegko.fir '100'}
        and bV_BelegPos.BelegArt         =  'U'
        and bV_BelegPos.Herk_BelegArt    =  V_BelegPos.BelegArt
        and bV_BelegPos.Herk_ReferenzNr  =  V_BelegPos.ReferenzNr
        and bV_BelegPos.Herk_PositionsNr =  V_BelegPos.PositionsNr
              
        no-lock no-error.

    FIND S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = V_BelegPos.Artikel
        and S_ArtikelSpr.Sprache  = 'D'
    no-lock no-error.
    
    
    create Result.
    ASSIGN
      Result.tt-Kunde = V_BelegKopf.Kunde
      Result.tt-Name1 = S_Adresse.Name1
      Result.tt-BelegNrA = V_BelegPos.BelegNummer
      Result.tt-BelegNrU = (IF AVAILABLE bV_BelegPos then bV_BelegPos.BelegNummer else 0)
      Result.tt-Adoption = (IF AVAILABLE bV_BelegPos then yes else no )
      Result.tt-Pos = V_BelegPos.PositionsNr
      Result.tt-Artikel = V_BelegPos.Artikel
      Result.tt-Bezeichnung = (IF available S_ArtikelSpr then string(S_ArtikelSpr.Bezeichnung[1]) else "").
end.

for each Result 
  no-lock by Result.tt-BelegNrA:
  DISPLAY
    Result.tt-Kunde
    Result.tt-Name1
    Result.tt-BelegNrA
    Result.tt-BelegNrU
    Result.tt-Adoption
    Result.tt-Pos
    Result.tt-Artikel
    Result.tt-Bezeichnung 
    with width 200
    .
end.
  

