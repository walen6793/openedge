define variable cSpacial     as character no-undo init '!#$%&()*+,-./:;<=>?@[]^_`{}~~|'.
define variable cBig         as character no-undo init 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
define variable cSmall       as character no-undo init 'abcdefghijklmnopqrstuvwxyz'.
define variable cNumber      as character no-undo init '0123456789'.
define variable cPass        as character no-undo init "".

define variable iCount as integer   no-undo.
define variable iRand  as integer   no-undo.
define variable cChar1 as character no-undo.
define variable cChar2 as character no-undo.



cPass = cPass + substring(cSpacial,random(1,length(cSpacial)),1). /* ?????????????? */
 
cPass = cPass + substring(cBig,random(1,length(cBig)),1). /* ???????????? */


do iCount = 1 to 4 :
  cPass = cPass + substring(cSmall,random(1,length(cSmall)),1). /* ???????????? */
  
END.
iCount = 1.
do iCount = 1 to 2:
  cPass = cPass + substring(cNumber,random(1,length(cNumber)),1). /* ????????? */
END.
iCount = 1.

do iCount = length(cPass) to 1 by -1:

  iRand  = random(1,length(cPass)). /* ????????? */
  cChar1 = substring(cPass,iCount,1).
  cChar2 = substring(cPass,iRand,1).
  substring(cPass,iRand,1) = cChar1.  /* ?????????? ??? 1 ?? ??? 2 */
  substring(cPass,iCount ,1) = cChar2.
  END.

message
 
  cPass.
