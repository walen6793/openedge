define buffer bS_Artikel for S_Artikel.
define buffer bS_ArtKunde for S_ArtKunde.
define buffer bS_Kunde for S_Kunde.

FOR EACH bS_ArtKunde
  WHERE bS_ArtKunde.Firma = {firma/sartkund.fir '100'}
  AND bS_ArtKunde.Artikel BEGINS '3'
  NO-LOCK :
  
    FIND bS_Artikel where
      bS_Artikel.Firma = bS_ArtKunde.Firma
      AND bS_Artikel.Artikel = bS_ArtKunde.Artikel
      no-lock no-error.
      
    FIND bS_Kunde where
      bS_Kunde.Firma = bS_ArtKunde.Firma
      AND bS_Kunde.Kunde = bS_ArtKunde.Kunde
      no-lock no-error.
      
    FIND S_Adresse 
        where S_Adresse.Firma    = '':U
          AND S_Adresse.AdressNr = bS_Kunde.AdressNr
        no-lock no-error.
      
  
    FIND S_ArtikelSpr where
      S_ArtikelSpr.Firma = bS_ArtKunde.Firma
      AND S_ArtikelSpr.Artikel = bS_Artikel.Artikel
      AND S_ArtikelSpr.Sprache = bS_Kunde.Sprache
      no-lock no-error.
    
    
     
      
      
    display
      "Artikel" bS_ArtKunde.Artikel skip
      "Bezeichunug1" S_ArtikelSpr.Bezeichnung[1] skip
      "Bezeichunug2" S_ArtikelSpr.Bezeichnung[2] skip
      "Kunde" bS_Kunde.Kunde skip
      "S_Adresse Name" (if available S_Adresse then S_Adresse.Suchbegriff
                         else
                           '':U) skip
      "S_Adresse TELEFON" (if available S_Adresse then 
                     S_Adresse.Telefon
                   else
                     '':U)
     
      
      .
      
      
     
      
    end.
    
