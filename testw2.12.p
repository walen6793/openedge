define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_ArtLief for E_ArtLief.
define variable cSpecial as character no-undo init '0,1,10,15'.
define variable cMessage as character no-undo.

output to 'D:/output1.csv'.
put unformatted 'Teile; Description 1; ArtikelArt ; Supplier; Name;':U skip.


for each S_Artikel
  where S_Artikel.Firma = {firma/sartkund.fir '100'}
   no-lock:

  if not lookup(string(S_Artikel.ArtikelArt),cSpecial) > 0 then
    do:
          IF NOT CAN-FIND(FIRST bS_ArtKunde
                           where bS_ArtKunde.Firma= S_Artikel.Firma 
                           and bS_ArtKunde.Artikel = S_Artikel.Artikel) 
             AND CAN-FIND(First bS_ArtLief 
                           where bS_ArtLief.firma = S_Artikel.Firma
                           and bS_ArtLief.Artikel = S_Artikel.Artikel)
          then 
            do:
              FIND S_ArtikelSpr
                where S_ArtikelSpr.Firma = S_Artikel.Firma
                AND S_ArtikelSpr.Artikel = S_Artikel.Artikel
               AND S_ArtikelSpr.Sprache = 'D'
                no-lock no-error.
              
              FIND FIRST bS_ArtLief 
                where bS_ArtLief.Firma = {firma/sartkund.fir '100'}
                and bS_ArtLief.Artikel = S_Artikel.Artikel
                no-lock no-error.
                
                FIND S_Lieferant 
                  where S_Lieferant.Firma = bS_ArtLief.Firma
                  and S_Lieferant.Lieferant = bS_ArtLief.Lieferant
                  no-lock no-error.
                                    
                
                PUT UNFORMATTED
                  bS_ArtLief.Artikel ","
                 S_ArtikelSpr.Bezeichnung[1] ","
                  S_Artikel.ArtikelArt ","
                  bS_ArtLief.Lieferant ","
                  S_Lieferant.Suchbegriff
                  skip.
                  
                
                
                
                            end.
            
            
      
      
      
    end.

end.
message
  cMessage.

