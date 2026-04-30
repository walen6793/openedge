define variable cRecord   as character format 'x(50)':U no-undo.
define variable cFilePath as character                   no-undo.
define variable iCreated as integer no-undo.
define variable iUpdated as integer no-undo.
define variable iTotal as integer no-undo.

define variable cArtikel as character no-undo.
define variable cBezeichnung1 as character no-undo.
define variable cBezeichnung2 as character no-undo.


define stream   sInput.

assign
  cFilePath = 'D:\walen\message.csv':U
  .

input stream sInput from value (cFilePath).
import stream sInput unformatted cRecord.
Import_Record:
repeat:
  
  import stream sInput unformatted cRecord.

  if cRecord = '' then next.


  assign
    cArtikel = entry(1,cRecord,';':U)
    cBezeichnung1 = entry(2,cRecord,';':U)
    cBezeichnung2 = entry(3,cRecord,';':U)
    iTotal = iTotal + 1.
    
  find S_Artikel
    where S_Artikel.Firma    = {firma/sartikel.fir '100'}
      and S_Artikel.Artikel  =  cArtikel
    exclusive-lock no-error.
  if available S_Artikel then
  do:
    FIND S_ArtikelSpr
      where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
        and S_ArtikelSpr.Artikel  = S_Artikel.Artikel
        and S_ArtikelSpr.Sprache  = 'D'
        exclusive-lock no-error.

    ASSIGN
      S_ArtikelSpr.Bezeichnung[1] = cBezeichnung1
      S_ArtikelSpr.Bezeichnung[2] = cBezeichnung2
    .
    iUpdated = iUpdated + 1.
    
  end.
  else
    do:
      CREATE S_Artikel.
      ASSIGN
        S_Artikel.Firma   = {firma/sartikel.fir '100'}
        S_Artikel.Artikel =  cArtikel
      .
      find S_ArtikelSpr
        where S_ArtikelSpr.Firma    = {firma/sartikel.fir '100'}
          and S_ArtikelSpr.Artikel  =  cArtikel
          and S_ArtikelSpr.Sprache  =  'D'
        exclusive-lock no-error.
        if not available S_ArtikelSpr then
        do:
          CREATE S_ArtikelSpr.

            ASSIGN
              S_ArtikelSpr.Firma            = {firma/sartikel.fir '100'}
              S_ArtikelSpr.Artikel          =  cArtikel
              S_ArtikelSpr.Sprache          = 'D'
              S_ArtikelSpr.Bezeichnung[1]   = cBezeichnung1
              S_ArtikelSpr.Bezeichnung[2]   = cBezeichnung2.
        end. /* ? */
        iCreated = iCreated + 1.
      
    end.
    end.
  

display
  iTotal "~n"
  iCreated "~n"
  iUpdated "~n".


input stream sInput close.




 /* Import_Record */
