/* 01_cleanrand.do 
clean variables from RAND data file */

/*drink cat. variable*/
drop drink
gen drink=0 if drinkd==0
gen drinkw = drinkd*drinkn

replace drink=1 if drink==. & female& drinkw<=7 & drinkn<=3 
replace drink=1 if drink==. & female==0 & drinkw<=14 & drinkn<=4
replace drink=2 if drink==. & drinkw!=.
label define drklbl 0 "don't drink" 1 "moderate" 2 " heavy"
label values drink drklbl

gen drinkm = (drink==1)
gen drinkh = (drink==2)

drop drinkd drinkn drinkw
/* NIAA def of moderate drinking
female: <=3/day and <=7/week
male: <=4/day and <=14/week
*/


/*smoke cat. variable*/
gen smoke=0 if smokev==0
replace smoke=1 if smokev==1 & smoken==0
replace smoke=2 if smoken==1
lab define smklbl 0 "never smoke" 1 "ever smoke" 2 "smoke now"
label val smoke smklbl

rename iearn income
rename atotw totwealth
rename atotf finwealth

/* parent death or ill 

gen parentage = dadage if female==0
replace parentage=momage if female==1
gen parentill = rfdieill if female==0
replace parentill = rmdieill if female==1
*/

/* wealth and income*/
gen lwealth = log(totwealth)
gen lincome = log(income)
replace lincome=0 if income==0

