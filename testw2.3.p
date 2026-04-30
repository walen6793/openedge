define buffer bS_Artikel  for S_Artikel.
define buffer bS_Artikel2 for S_Artikel.
define variable lTrue  as logical no-undo.
define variable lTrue2 as logical no-undo.


find first bS_Artikel 
  where bS_Artikel.Firma = {firma/sartikel.fir '100'}
  exclusive-lock
  .
  if available bS_Artikel then
    lTrue = true.
      
  else
      lTrue = false.
      
 
find last bS_Artikel2 
  where bS_Artikel2.Firma = {firma/sartikel.fir '100'}
  exclusive-lock
  .

  if available bS_Artikel2 then
  DO:
    lTrue2 = true.
   
 END.
   else
   DO:
     lTrue2 = false.
     END.
.
   
if (lTrue = true) AND (lTrue2 = true) then
DO:
  bS_Artikel.Selektion = string(bS_Artikel.Gewicht + bS_Artikel2.Gewicht).
  display
    bS_Artikel.Selektion.
  END.
  else
    message
      "error"
      
