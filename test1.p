define variable iAmount as integer no-undo.
define variable cProduct as character no-undo.
define variable iPrice as integer no-undo.
define variable iTotal as integer no-undo.
define variable iMoney as integer no-undo.
define variable iExchange as integer no-undo.
update cProduct.
update iAmount.
case cProduct:
    when 'A':U then do:
        iPrice = 10.
        end.

    when 'B':U then do:
        iPrice = 41.
        end.

    when 'C':U then do:
        iPrice = 32.
        end.

    when 'D':U then do:
        iPrice = 77.
        end.

    when 'E':U then do:
        iPrice = 105.
        end.

    when 'F':U then do:
        iPrice = 8.
        end.
    otherwise do:
        message
            'No have product':U skip
            view-as alert-box
            title program-name(1).
     end.
end case.

iTotal = iPrice * iAmount.

display iTotal.

update iMoney.

iExchange = iTotal - iMoney .

display iExchange.
