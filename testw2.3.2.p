define buffer bS_Artikel  for S_Artikel.
define buffer bS_Artikel2 for S_Artikel.



find first bS_Artikel 
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
  exclusive-lock
  .

find last bS_Artikel2 
  where bS_Artikel2.Firma = {firma/sartikel.fir '100'}
  exclusive-lock
  .

if available bS_Artikel AND available bS_Artikel2 then
DO:
  bS_Artikel.Selektion = string(bS_Artikel.Gewicht + bS_Artikel2.Gewicht).
  bS_Artikel2.Selektion = bS_Artikel.Selektion.
  display
    bS_Artikel.Selektion.
  END.
  else
    message
      "error"
      
