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

    if cMes = ' ' THEN /* ????????????????????? */
        next.
    else if cMes2 <> 0 THEN
    dO:
        count2[cMes2] = count2[cMes2] + 1.
        
    
    end.
    else DO:

        cMes3 = cMes3 + cMes.
        
         count2[length(cMes3)] = 1.
       END.

end.

do iCount2 = 1 to length(cMes3) by 1:
    message
        substring(cMes3,iCount2,1) '=' count2[iCount2].
        



end.
