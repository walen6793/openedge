define variable cMessage  as character no-undo.
define variable iCount    as integer   no-undo.
define variable tempRand  as integer   no-undo.

define variable i         as integer   no-undo.
define variable j         as integer   no-undo.
define variable iTemp     as integer   no-undo.
define variable iSwap     as logical   no-undo.
define variable iList     as integer   extent 5 no-undo.



do while iCount < 5:
    tempRand = RANDOM(0, 100).
    if NOT CAN-DO(cMessage, string(tempRand)) THEN DO:
        cMessage = (if cMessage = "" then "" else cMessage + ",") + string(tempRand).
        iCount = iCount + 1.
        /*Array for Sort */
        iList[iCount] = tempRand.
    END.
end.

message " Ori : " cMessage .


do i = 1 to 5:
    iSwap = false.
    do j = 1 to 5 - i:
        if iList[j] > iList[j + 1] then do:
            assign iTemp      = iList[j]
                   iList[j]   = iList[j + 1]
                   iList[j + 1] = iTemp
                   iSwap      = true.
        end.
    end.
    if not iSwap then leave.
end.


message "Low to high: " iList[1] "," iList[2] "," iList[3] "," iList[4] "," iList[5] skip
        "Min: " iList[1] skip
        "Max: " iList[5]
        .

do i = 1 to 5:
    iSwap = false.
    do j = 1 to 5 - i:
        if iList[j] < iList[j + 1] then do:
            assign iTemp      = iList[j]
                   iList[j]   = iList[j + 1]
                   iList[j + 1] = iTemp
                   iSwap      = true.
        end.
    end.
    if not iSwap then leave.
end.

message "High to low : " iList[1] "," iList[2] "," iList[3] "," iList[4] "," iList[5]
        .
