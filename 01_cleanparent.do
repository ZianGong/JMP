/* clean parent health variables */

/* always use same sex parent */ 

recode F001 F011 F009 F019 (5=0) (8=.) (9=.)
recode F002 F012 (998=.) (999=.)

gen parentalive=F001 if female==1
replace parentalive=F011 if female==0
gen parentdead= 1 - parentalive
/*
gen parentage=F002 if female==1 
replace parentage=F012 if female==0

gen parentill=F009 if female==1
replace parentill=F019 if female==0

gen parentagealive = parentage*parentalive
gen parentagedeath = parentage*parentdead
egen parentagebin = cut(parentage), at(40, 65, 70, 75, 80, 85, 100)
*/

drop F*
