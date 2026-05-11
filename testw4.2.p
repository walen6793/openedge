for each E_BelegKopf
  where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
    and E_BelegKopf.BelegNummer = 50200566
  no-lock:

    for each E_BelegPos
      where E_BelegPos.Firma        = {firma/ebelkop.fir '100'}
        and E_BelegPos.BelegArt     = E_BelegKopf.BelegArt
        and E_BelegPos.ReferenzNr   = E_BelegKopf.ReferenzNr
      no-lock:

    find S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = E_BelegPos.Artikel
        and S_ArtikelSpr.Sprache  = 'D'
      no-lock no-error.
      
        display
          E_BelegKopf.BelegNummer
          E_BelegKopf.BelegDatum
          E_BelegPos.PositionsNr
          E_BelegPos.Artikel
          S_ArtikelSpr.Bezeichnung[1]
          E_BelegPos.Menge
          E_BelegPos.Einzelpreis
          'Gesamtpreis = ' (E_BelegPos.Menge * E_BelegPos.Einzelpreis)  format "->,>>>,>>>,>>>,>>9.99"
          with width 200.
     end.
end.
