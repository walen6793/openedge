define variable cMessage as character no-undo init '01.06.2025,15250.75;02.06.2025,12300.00;03.06.2025,17800.00;04.06.2025,9900.50;05.06.2025,0;06.06.2025,10500.25;07.06.2025,8600.00;08.06.2025,12000.00;09.06.2025,15700.75;10.06.2025,0'.
define variable cDateArray as character extent 20 no-undo.
define variable cSalesArray as character extent 20 no-undo.
define variable cMessageArray as character extent 20 no-undo.
define variable dTotalSales as decimal no-undo.
define variable dAVGSales as decimal no-undo.
define variable dMin as decimal no-undo init 99999999.
define variable dMax as decimal no-undo init 0.
define variable dMinDate as character no-undo.
define variable dMaxDate as character no-undo.



define variable iCount as integer no-undo.

SESSION:NUMERIC-FORMAT = "AMERICAN".


/* ? */
DO iCount = 1 TO NUM-ENTRIES(cMessage,';'):
  cMessageArray[iCount] = entry(iCount,cMessage,';'). /* ??????? , list , ??????? */
  cDateArray[iCount] = entry(1,cMessageArray[iCount],',').    /* ??????????????? ??? ?????????? */
  cSalesArray[iCount] = entry(2,cMessageArray[iCount],',').   
  
  dTotalSales = dTotalSales + decimal(cSalesArray[iCount]).
  
  if (decimal(cSalesArray[iCount]) < dMin) AND iCount > 0 THEN /* ???????????????????? min ??? */
    DO:
      
      dMin = decimal(cSalesArray[iCount]).
      dMinDate = cDateArray[iCount].
    END.
    else if (decimal(cSalesArray[iCount]) = dMin) AND (dMin <> 99999999) THEN  /* ???????????????????? */
    DO:
      dMinDate = dMinDate + " " + cDateArray[iCount].
      
    END.
  
  if (decimal(cSalesArray[iCount]) > dMax ) AND iCount > 0 THEN 
    DO:
      
      dMax = decimal(cSalesArray[iCount]).
      dMaxDate = cDateArray[iCount].
      
    END.
    else if (decimal(cSalesArray[iCount]) = dMax ) AND (dMax <> 0) THEN 
    DO:
      dMaxDate = dMaxDate + " " + cDateArray[iCount].
      
    END.
  
  
END.
dAVGSales = dTotalSales / NUM-ENTRIES(cMessage,';'). /* ??????????? */
message
  'Total = ':U dTotalSales skip
  'Min = ':U dMin skip
  'MinDate = ':U dMinDate skip 
  'max = ':U dMax skip
  'maxDate = ':U dMaxDate skip 
  'AVG = ':U dAVGSales .
.
