define variable cList as character no-undo init 'a,u,l,r,g'.
define variable i as integer no-undo.

do i = 1 to num-entries(cList):
  for each V_BelegKopf
    where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
      and V_BelegKopf.BelegArt    = entry(i,cList)
    no-lock:
    DISPLAY
     V_BelegKopf.BelegNummer
     V_BelegKopf.BelegArt
     V_BelegKopf.ReferenzNr.
  end.

end. /* ? */
