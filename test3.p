define variable cMessages as character no-undo.
define variable cMessages2 as character no-undo init "".

define variable i as integer no-undo.

define variable cMessages3 as character no-undo.
define variable cMessages4 as character no-undo.
cMessages = 'artikel,kunde,lieferchien,rechnung'.


do i = 1 to NUM-ENTRIES(cMessages):
    cMessages4 = ENTRY(i,cMessages). /* ?????????*/
    cMessages3 = REPLACE(cMessages4,"e","T"). /* */
    cMessages2 = cMessages2 + substring(cMessages3,1,3) + "PROALPHA".
message
    cMessages2.

end.
message
    cMessages2.
