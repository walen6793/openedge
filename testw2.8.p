define buffer bS_ArtKunde for S_ArtKunde.

define variable cKunde as character no-undo.
define variable iCount as integer no-undo.
define variable i as integer no-undo.
define variable j as integer no-undo.
define variable cCurrent as character no-undo.
define variable cMax as character no-undo.
define variable iMax as integer no-undo.


for each bS_ArtKunde
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
  no-lock:
    if cKunde <> '' then
      cKunde = cKunde + ',' + string(bS_ArtKunde.Kunde).
    else
      cKunde = string(bS_ArtKunde.Kunde).
  end.




do i = 1 to num-entries(cKunde):
  cCurrent = entry(i,cKunde).
  iCount = 0.
  do j = 1 to num-entries(cKunde):
    if entry(j,cKunde) = cCurrent then
      do:
         iCount = iCount + 1.
         
      
      end. /* ? */

     
  
  end. /* end j */
  if iCount > iMax then
    do:
       iMax = iCount.
       cMax = cCurrent.
    
    end. /* ? */
  
  
end. /* ? */

message
  " Amount  = " iMax skip
  " Kunde = " cMax .

