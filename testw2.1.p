define buffer bS_Artikel for S_Artikel.

find first bS_Artikel
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
  AND bS_Artikel.Artikel begins '21'.  


if available bS_Artikel then
  display
    bS_Artikel.Artikel.
    
else
  display
    "Error".


