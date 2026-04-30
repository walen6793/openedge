define variable cMessages as character no-undo init '3a4v1tw5'.
define variable cResult as character no-undo init ''.
define variable i as integer no-undo.
define variable j as integer no-undo.

update cMessages.
i = 1.
do while i <= length(cMessages):
  DO:
    if substring(cMessages, i, 1) >= '0' AND substring(cMessages, i, 1) <= '9' then do:
        i = i + 1.
        next. /* ???? */
    end.
    if  i + 1 <= length(cMessages) AND
        substring(cMessages,i + 1,1) >= '0' AND substring(cMessages,i + 1,1) <= '9' THEN
      DO:
        do j = 1 to integer(substring(cMessages,i + 1,1)):
          cResult = cResult + substring(cMessages,i,1).
          END.
        i = i + 2.
      END.
    else do:
       cResult = cResult + substring(cMessages,i,1).
       i = i + 1.
    END.
  END.
END.
   message
          cResult.
    
    
