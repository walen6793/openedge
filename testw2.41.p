define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_ArtKunde2 for S_ArtKunde.
define buffer bS_Artikel for S_Artikel.






for each bS_ArtKunde 
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
  no-lock.
  display
    " Artkunde = " bS_ArtKunde.Artikel .
  

find first bS_ArtKunde2 
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
   no-lock.
   
end.

for each bS_Artikel
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
    AND bS_Artikel.Artikel = bS_ArtKunde2.Artikel
      no-lock.
    

if available bS_ArtKunde2 AND available bS_Artikel then 
  display
    "Artikel = " bS_ArtKunde2.Artikel  skip
    "ArtikelArt = " bS_Artikel.ArtikelArt skip
    "LagerGewicht = " bS_Artikel.LagerGewicht skip
    "Kunde = " bS_ArtKunde2.kunde
    
    
    .
    end.
    
    
