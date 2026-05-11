output to 'D:/output33.csv'.
put unformatted 'BelegNr(EB);Lieferant;LieferantName1;BelegNr(U);Kunde;KundeName1;':U skip.
define buffer bS_Adresse for S_Adresse.


for each V_BelegKopf
  where V_BelegKopf.Firma       = {firma/vbelegko.fir '100'}
    and V_BelegKopf.BelegArt    = 'U'
  no-lock:
  
  for each V_BelegPos
    where V_BelegPos.Firma        = {firma/vbelegko.fir '100'}
      and V_BelegPos.BelegArt     = V_BelegKopf.BelegArt
      and V_BelegPos.ReferenzNr   = V_BelegKopf.ReferenzNr
    no-lock:

      find E_BelegPos
        where E_BelegPos.Firma               = {firma/ebelkop.fir '100'}
          and E_BelegPos.BelegArt            = 'EB'
          and E_BelegPos.Coverage_MRPDocType =  V_BelegPos.BelegArt
          and E_BelegPos.Coverage_Obj        =  V_BelegPos.V_BelegPos_Obj
          and E_BelegPos.Artikel             =  V_BelegPos.Artikel
        no-lock no-error.
      if available E_BelegPos then
      do:
        find E_BelegKopf
          where E_BelegKopf.Firma       = {firma/ebelkop.fir '100'}
            and E_BelegKopf.BelegArt    =  E_BelegPos.BelegArt
            and E_BelegKopf.ReferenzNr  =  E_BelegPos.ReferenzNr
          no-lock no-error.

        find S_Lieferant
          where S_Lieferant.Firma      = {firma/sliefera.fir '100'}
            and S_Lieferant.Lieferant  = E_BelegPos.Lieferant
          no-lock no-error.
          
        find S_Adresse
          where S_Adresse.Firma     = {firma/s_adres.fir '100'}
            and S_Adresse.AdressNr  =  S_Lieferant.AdressNr
          no-lock no-error.
          
        find S_Kunde
          where S_Kunde.Firma  = {firma/s_kunde.fir '100'}
            and S_Kunde.Kunde  =  V_BelegKopf.Kunde
          no-lock no-error.
          
        find bS_Adresse
          where bS_Adresse.Firma     = {firma/s_adres.fir '100'}
            and bS_Adresse.AdressNr  =  S_Kunde.AdressNr
          no-lock no-error.

          
            PUT UNFORMATTED
              E_BelegKopf.BelegNummer ';'
              
              E_BelegPos.Lieferant    ';'
              S_Adresse.Name1  ';'
              V_BelegKopf.BelegNummer ';'
              V_BelegKopf.Kunde ';'
              bS_Adresse.Name1 ';'  skip.


      end. /* ? */
   end.
end.
