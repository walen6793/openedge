define variable dInput   as integer   no-undo.
define variable cOnes    as character no-undo  init "one,two,tree,four,five,six,seven,eight,nine".
define variable cTwos    as character no-undo  init "ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen ".
define variable cTens    as character no-undo  init ",twenty,thirty,forty,fifty,sixty,seventy,eigthy,ninety".
update dInput label "Press number":U.



FUNCTION calculate RETURNS CHARACTER (INPUT dInput as integer):
  define variable cResult     as character   no-undo.
  define variable iHundred    as integer     no-undo.
  define variable iReminder   as integer     no-undo.
  define variable iTenx   as integer     no-undo.
  define variable iOnes   as integer     no-undo.

  iHundred  = truncate(dInput / 100,0) .
  iReminder = dInput modulo 100.

  if iHundred >= 1 THEN 
  DO:
    cResult = cResult + entry(iHundred,cOnes) + 'hundred'.
    message
      iHundred.
    END.
  if iReminder >= 10 AND iReminder <= 19 THEN 
  DO:
    
    cResult = cResult + " " + entry(iReminder - 9,cTwos).
    
  END.
  else DO:
    IF iReminder / 10 >= 2 THEN 
    DO:

      iTenx = truncate(iReminder / 10,0).
      cResult = cResult + entry(iTenx , cTens).
    END.
    IF iReminder MODULO 10 > 0 THEN 
    DO:
      iOnes   = iReminder MODULO 10.
      cResult = cResult + entry(iOnes , cOnes).
    END.
END.






  RETURN cResult.
END FUNCTION.


IF dInput > 0 AND dInput <= 999 THEN
message
  calculate(dInput).
ELSE
  message
    '0'.
  
  
