define variable cMessages as character no-undo init "this is a message to be count".
define variable iCount as integer no-undo.
define variable cMes as character no-undo.
define variable cMes2 as integer no-undo.
define variable cMes3 as character no-undo init "".
define variable count2 as integer extent 30 no-undo.
define variable index1 as integer no-undo.
define variable iCount2 as integer no-undo.
define variable count1 as integer no-undo.

count1 = 0.
iCount2 = 0.

do iCount = 1 to length(cMessages) by 1:
    cMes = substring(cMessages,iCount,1).
    cMes2 = INDEX(cMes3,cMes).

    if cMes = ' ' THEN
        next.
    else if cMes2 <> 0 THEN

        count2[cMes2] = count2[cMes2] + 1.
         message
            cMes2.
    else DO:
        cMes3 = cMes3 + cMes.
         count2[iCount] = 1.
       END.

end.

do iCount2 = 1 to 30 by 1:
    message
        count2[iCount] '=' skip
        count2[iCount2].



end.
