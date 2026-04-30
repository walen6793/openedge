define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_Artikel for S_Artikel.
define variable cArtikel as character no-undo .
define variable iCount as integer no-undo.
define variable i as integer no-undo.
define variable j as integer no-undo.
define variable cCurrent as character no-undo.
define variable iMax as integer no-undo.
define variable cMax as character no-undo.
define variable cKunde as character no-undo.


for each bS_ArtKunde
  where bS_ArtKunde.Firma   = {firma/sartkund.fir '100'}

  no-lock:
    DO:
      if available bS_ArtKunde AND cArtikel <> "" then
      do:
        
         cArtikel = cArtikel + ',' + bS_ArtKunde.Artikel   .
        

      end. /* ? */
      else
        do:
          cArtikel = bS_ArtKunde.Artikel.
        end.
      .
    END.
END.



do i = 1 to num-entries(cArtikel) :
  cCurrent = entry(i,cArtikel).
  iCount = 0.
    do j = 1 to num-entries(cArtikel):
      if entry(j,cArtikel) = cCurrent then
        iCount = iCount + 1 .
    end.
   if iCount > iMax then
   do:
     iMax = iCount.
     cMax = cCurrent.
   end.
 
end.

for each S_ArtKunde
  where S_ArtKunde.Firma  = {firma/sartkund.fir '100'} 
   and S_ArtKunde.Artikel = cMax
  no-lock :
    cKunde = cKunde + ' ' + string(S_ArtKunde.Kunde).
   
   end.

message
  cKunde.

display
  ' cMax  = ' cMax  skip
  ' Kunde = ' cKunde format 'x(40)':U skip
  
  ' iMax  =  ' iMax
  .
  
   
    

