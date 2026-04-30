define variable dStart     as date      no-undo init today.
define variable iInput     as integer   no-undo.             
define variable dKTG       as date      no-undo.
define variable dATG       as date      no-undo.
define variable iCount     as integer   no-undo.
define variable cHolidays  as character no-undo init "01/01/2026,13/04/2026,01/05/2026". 

update iInput label "Amount(Days)".

/*  1.KTG */

dKTG = dStart + iInput.

/* 2. ATG */
dATG = dStart.
iCount = 0.

repeat while iCount < iInput:
    dATG = dATG + 1. 
    
    
    if WEEKDAY(dATG) = 1 or WEEKDAY(dATG) = 7 or LOOKUP(string(dATG), cHolidays) > 0 then 
        next. 
    else 
        iCount = iCount + 1.
end.


message 
    "currentDate: " dStart skip(1)
    "Input: " iInput skip
    "KTG : " dKTG skip
    "ATG : " dATG 
    .
