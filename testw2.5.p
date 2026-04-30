define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_Artikel for S_Artikel.
define buffer bS_Kunde for S_Kunde.
define variable cResults as character no-undo init "".





for each bS_ArtKunde 
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
        and bS_ArtKunde.Kunde >= 100000 and bS_ArtKunde.Kunde <= 100017
        
  no-lock.
  
for each bS_Artikel
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
  and bS_Artikel.Artikel = bS_ArtKunde.Artikel
  and lookup(string(bS_Artikel.Artikelart),'61,10,9,5,1') > 0
  no-lock.
  
for each bS_Kunde
  where bS_ArtKunde.Firma = {firma/sartikel.fir '100'}
  and bS_ArtKunde.Kunde = bS_Kunde.Kunde
  
  no-lock.
  
  
if available bS_Artkunde AND available bS_Artikel AND available bS_Kunde then
  do:
    cResults = cResults + " Artikel = ":U + string(bS_Artikel.Artikel) + '~n' +
    " Kunde = ":U + string(bS_ArtKunde.Kunde) + '~n' +
    " Selektion = " + string(bS_Kunde.selektion) + '~n' +
    " ArtikelArt =  " + string(bS_Artikel.Artikelart)+ '~n' + '~n' 
    .
  end.  
  else
    do:
      message
      "Error".
    end.
    end.
    end.
    end.
    
    
display
   cResults view-as editor size 100 by 100
   with width 120.
