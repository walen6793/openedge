define buffer bS_Artikel for S_Artikel.
define buffer bS_ArtKunde for S_ArtKunde.

find first bS_Artikel
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
  AND bS_Artikel.Artikel begins '10'
  no-lock.  
  
  if available bS_Artikel then
    message
      'Compleate'.
  else
    message
      "Error".

find last bS_ArtKunde 
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
  and bS_ArtKunde.Artikel = bS_Artikel.Artikel
  no-lock.
  
  if available bS_ArtKunde then
    display
      bS_ArtKunde.kunde.
      
   else
     display
       "Error2".
