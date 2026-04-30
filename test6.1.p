define variable iPoint as integer no-undo.
define variable iCount as integer no-undo.
define variable cGrade as integer extent 5 no-undo.
define variable iPointArr as character extent 5 no-undo.
define variable grade as character no-undo.



function gradeCal returns character
  (iPoint as integer):
  if iPoint >= 80 THEN
    grade = 'A'.
    else if iPoint  >= 70 THEN
      grade = 'B'.
    else if iPoint >= 60 THEN
      grade = 'C'.
    else if iPoint >= 50 THEN
      grade = 'D'.
    else if iPoint >= 0 AND iPoint < 50 THEN
      grade = 'E'.
    else
      grade = 'Error'.
    return grade.
    end.

do iCount = 1 to 5 by 1:
  update iPoint.
  iPointArr[iCount] = gradeCal(iPoint).
  cGrade[iCount] = iPoint.
end.
iCount = 1.
do iCount = 1 to extent(cGrade) :

  message
      cGrade[iCount] '=' iPointArr[iCount] skip.
    
end.
