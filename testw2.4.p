define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_ArtKunde2 for S_ArtKunde.
       
for each S_Artikel
  where S_Artikel.Firma    = {firma/sartikel.fir '100'}
  no-lock:
    find first bS_ArtKunde
      where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
        and bS_ArtKunde.Artikel = S_Artikel.Artikel
      no-lock no-error.
    
    if available S_Artikel AND available bS_ArtKunde then
     DISPLAY
        S_Artikel.Artikel LABEL "Artikel"
        S_Artikel.ArtikelArt LABEL "ArtikelArt"
        S_Artikel.LagerGewicht LABEL "LagerGeWicht"
        bS_ArtKunde.Kunde LABEL "FIRST KUNDE".


  end.
        
        
        
        
        




