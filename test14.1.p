define variable cPassword    as character           no-undo init 'AB123;XY_456;99-ZZ;A1B2C3;abcd1234;a-b-c-d;ABC;A23456789;-ABC123;A*BC123;ZZZ-123'.
define variable cSpacial     as character           no-undo init '!#$%&()*+,-./:;<=>?@[]^_{}~`|'.
define variable cNumber      as character           no-undo init '1234567890'.

define variable cPassArr     as character extent 30 no-undo.
define variable iCount       as integer             no-undo.
define variable iCount2      as integer             no-undo.
define variable iCountUDSC   as integer             no-undo.
define variable cValid       as character           no-undo init ''.
define variable cInvalid     as character           no-undo init ''.

define variable lIsBad as logical no-undo.

cValid = 'Valid = '.
cInvalid = 'Invalid = '.


DO iCount = 1 to NUM-ENTRIES(cPassword,';'):
  cPassArr[iCount] = entry(iCount,cPassword,';').
  iCountUDSC = 0.
  lIsBad = FALSE.
  if (length(cPassArr[iCount]) >= 5) AND (length(cPassArr[iCount]) <= 8) AND  INDEX(cNumber,substring(cPassArr[iCount],1,1)) = 0
                                     THEN
    DO:
      DO iCount2 = 1 to length(cPassArr[iCount]):
        IF INDEX(cSpacial,substring(cPassArr[iCount],iCount2,1)) > 0 THEN /* ????????????????????? */
          DO:
            
            IF substring(cPassArr[iCount],iCount2,1) = '-' THEN
              DO:
                IF iCountUDSC < 2 THEN
                  DO:
                    iCountUDSC = iCountUDSC + 1.
                    IF iCountUDSC > 1 THEN lIsBad = TRUE.
                  END.
                ELSE
                  DO:
                    cInvalid = cInvalid + ' , ' + cPassArr[iCount].
                    lIsBad = TRUE.
                  END.

              END.
            ELSE
              DO:
                cInvalid = cInvalid + ' , ' + cPassArr[iCount].
                LEAVE.
              END.
    IF lIsBad = FALSE THEN
      DO:
        cValid = cValid + cPassArr[iCount].
      END.
      
    END.
    END.


END.
ELSE
     DO:
       cInvalid = cInvalid + ' , ' + cPassArr[iCount].
     END.
 message
   cValid.




END.
message
  cValid skip
  cInvalid.
