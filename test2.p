define variable cMess as character no-undo.
define variable cMessages as character format 'x(50)' no-undo.
define variable iCount as integer no-undo.

cMessages = 'This is a message to convert':U.
do iCount = length(cMessages) to 1 by -1:
    cMess = cMess + substring(cMessages,iCount,1).
    
end.
message cMess.
