define variable cMessage as character no-undo.
define variable lExist as logical no-undo.
define variable iCount as integer no-undo.
define variable tempRand as integer no-undo.

define variable i as integer no-undo.
define variable j as integer no-undo.
define variable iTemp as integer no-undo.

define variable iSwap as logical no-undo.





do while iCount < 5:
  tempRand = RANDOM(0,100).
  if CAN-DO(string(tempRand),cMessage) THEN
    lExist = false.
    else DO:
      cMessage = cMessage + "," + string(tempRand).
      lExist = true.
      iCount = iCount + 1.
      END.
  end.
message
  cMessage.

DO i = 1 to 5 :
  iSwap = false.
  DO j = 1 to 5 - i :
    if []
    
    






    
