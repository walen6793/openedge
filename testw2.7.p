define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_Artikel for S_Artikel.
define variable cArtikel as character no-undo.
define variable iCount as integer no-undo.
define variable i as integer no-undo.
define variable j as integer no-undo.
define variable cOne as character no-undo.
define variable cCurrent as character no-undo.


for each bS_ArtKunde
  where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}
  no-lock:
    if available bS_ArtKunde then
      DO:
        if cArtikel <> '' then
          cArtikel = cArtikel + ',' + string(bS_ArtKunde.Artikel).
        else
          cArtikel = bS_ArtKunde.Artikel.
      END.

    end.


do i = 1 to num-entries(cArtikel):

  cCurrent = entry(i,cArtikel).
  iCount = 0.
    do j = 1 to num-entries(cArtikel):
      if entry(j,cArtikel) = cCurrent then
        do:
          iCount = iCount + 1.
        end.
      .
       
    end.
    
   
    if iCount = 1 and lookup(cCurrent,cOne) = 0 then
      do:
        if cOne <> '' then
          cOne = cOne + ',' + cCurrent .
        else
          cOne = cCurrent.
        
      
    
      
      end.
      
end.

message
  cOne.
