define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_Artikel for S_Artikel.


FOR EACH bS_Artikel 
  WHERE bS_Artikel.Firma   = {firma/sartkund.fir '100'}
  NO-LOCK :
    IF NOT CAN-FIND(first bS_ArtKunde
                    WHERE bS_ArtKunde.Firma  = bS_Artikel.Firma
                      AND bS_ArtKunde.Artikel = bS_Artikel.Artikel) then
      do:
        display
          bS_Artikel.Artikel 
          bS_Artikel.ArtikelArt 
          bS_Artikel.Suchbegriff.
    end.
end.
     
