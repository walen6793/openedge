
define variable addi as integer no-undo.
define variable sub as integer no-undo.
define variable multlip as integer no-undo.
define variable divine as decimal no-undo.
define variable num1 as integer no-undo.
define variable num2 as integer no-undo.

update num1.
update num2.
if num2 = 0 THEN

    






procedure calculate:
   define input parameter num1 as decimal.
   define input parameter num2 as decimal.
   define output parameter addi as decimal.
   define output parameter sub as decimal.
   define output parameter multlip as decimal.
   define output parameter divine as decimal.
   addi = num1 + num2.
   sub = num1 - num2.
   multlip = num1 * num2.
   divine = num1 / num2.

   
   end.
run calculate(num1,num2,output addi,output sub,output multlip,output divine).
display
    'addi = ':U addi skip
    'sub = ':U sub skip
    'multi = ':U multlip skip
    'divine = ':U divine.
