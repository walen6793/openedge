define variable iPrice as integer no-undo.
define variable cArtikel as character FORMAT 'x(60)' no-undo.


update iPrice LABEL 'Price'  .

update cArtikel LABEL 'Artikel' .



FIND S_Artikel
  where S_Artikel.Firma    = {firma/sartikel.fir '100'}
    and S_Artikel.Artikel  = cArtikel
    exclusive-lock no-error.
  if available S_Artikel then
  do:
    FIND LAST S_ArtPreiseDatum
      where S_ArtPreiseDatum.Firma        = {firma/sartprda.fir '100'}
        and S_ArtPreiseDatum.Artikel      =  S_Artikel.Artikel
        and S_ArtPreiseDatum.PreisGruppe  =  'GD'
        exclusive-lock no-error.
    if available S_ArtPreiseDatum then

    do:
    ASSIGN
      S_ArtPreiseDatum.gueltig_bis = TODAY - 1
      .
    CREATE S_ArtPreiseDatum.
    ASSIGN
      S_ArtPreiseDatum.Firma        = {firma/sartprda.fir '100'}
      S_ArtPreiseDatum.Artikel      =  S_Artikel.Artikel
      S_ArtPreiseDatum.PreisGruppe  =  'GD'
      S_ArtPreiseDatum.gueltig_ab = TODAY
    .
    CREATE S_ArtPreiseStaffel.
    ASSIGN
      S_ArtPreiseStaffel.Firma         = {firma/sartprda.fir '100'}
      S_ArtPreiseStaffel.Artikel       = S_ArtPreiseDatum.Artikel
      S_ArtPreiseStaffel.PreisGruppe   = S_ArtPreiseDatum.PreisGruppe
      S_ArtPreiseStaffel.gueltig_ab    = S_ArtPreiseDatum.gueltig_ab
      S_ArtPreiseStaffel.gueltig_bis   = S_ArtPreiseDatum.gueltig_bis
      S_ArtPreiseStaffel.StaffelMenge  = 0
      S_ArtPreiseStaffel.Preis         = iPrice
      .
    end. /* ? */
    else
    do:
      CREATE S_ArtPreiseDatum.
      ASSIGN
        S_ArtPreiseDatum.Firma        = {firma/sartprda.fir '100'}
        S_ArtPreiseDatum.Artikel      =  S_Artikel.Artikel
        S_ArtPreiseDatum.PreisGruppe  =  'GD'
        S_ArtPreiseDatum.gueltig_ab = TODAY

    .
      CREATE S_ArtPreiseStaffel.
      ASSIGN
        S_ArtPreiseStaffel.Firma         = {firma/sartprda.fir '100'}
        S_ArtPreiseStaffel.Artikel       = S_ArtPreiseDatum.Artikel
        S_ArtPreiseStaffel.PreisGruppe   = S_ArtPreiseDatum.PreisGruppe
        S_ArtPreiseStaffel.gueltig_ab    = S_ArtPreiseDatum.gueltig_ab
        S_ArtPreiseStaffel.gueltig_bis   = S_ArtPreiseDatum.gueltig_bis
        S_ArtPreiseStaffel.StaffelMenge  = 0
        S_ArtPreiseStaffel.Preis         = iPrice
        .
    end. /* ? */

   end. /* ? */
   else
   do:
   
      message
        'Not Found Artikel' .
   
   end. /* ? */









