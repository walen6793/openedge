for each EA_AnfKopf
  where EA_AnfKopf.Firma       = {firma/ebelkop.fir '100'}
  no-lock:

    for each EA_AnfPos
      where EA_AnfPos.Firma        = {firma/ebelkop.fir '100'}
        and EA_AnfPos.ReferenzNr   =  EA_AnfKopf.ReferenzNr
      no-lock:

    find S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = EA_AnfPos.Artikel
        and S_ArtikelSpr.Sprache  = 'D'
      no-lock no-error.


        display
          EA_AnfKopf.BelegNummer
          EA_AnfKopf.BelegDatum
          EA_AnfPos.PositionsNr
          EA_AnfPos.Artikel
          S_ArtikelSpr.Bezeichnung[1].

      end.
end.
