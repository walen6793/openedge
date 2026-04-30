define variable dInput as date no-undo init today.
define variable cOutput as character no-undo.
define variable cWeekday as character no-undo init "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday".
define variable cMonth as character no-undo init "January,February,March,April,May,June,July,August,September,October,November,December".
update dInput.

cOutput = cOutput + entry(weekday(dInput),cWeekday) + " " + string(day(dInput)) + " " + entry(month(dInput),cMonth) + " " + string(year(dInput)).

message

  cOutput.
