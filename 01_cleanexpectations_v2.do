/******************************************************************************
 01_cleanexpecatations.do 
 Description:
 Cleans up expectations related variables from section P of HRS, 
 renames them as necessary
 then drops raw variables
 
 Update: October 20th-- relabelled the groups. 
******************************************************************************/

rename P017 P62
rename P018 P65
rename P028 L75
rename P108 P108
rename P109 P109
rename P070 medexp5
replace P108 =.z if P108>100
replace P109 =.z if P109>100
replace P62=. if P62>100
replace P65=. if P65>100

/* rescale probablity to 0 to 1 */
foreach var in P108 P109 P62 P65{
	replace `var' = `var'/100
}

/* Assign into groups based on questions */
/* Group is a string variable. the first character denotes whether respondent 
	was assigned to P108 / P109. The second character denotes response to C001.
	The third character denotes value of randomization variable used (only for 
	P109). */
gen group="8" if !missing(P108)
replace group="9" if !missing(P109)
replace group=group+string(SRH) if group!=""

replace group=group+"4" if group=="95"&X506==1&X507==1
replace group=group+"3" if group=="95"&X506==1&X507==2
replace group=group+"2" if group=="95"&X506==2&X507==1
replace group=group+"1" if group=="95"&X506==2&X507==2

replace group=group+"3" if X511==1 & group=="94"
replace group=group+"2" if X511==2 & group=="94"
replace group=group+"1" if X511==3 & group=="94"
replace group=group+"2" if X508==1 & group=="93"
replace group=group+"1" if X508==2 & group=="93"


drop X511 X508 X506 X507 

gen event="E" if group=="85" | group=="954"
replace event="VGE" if group=="84" |group=="953" | group=="943"
replace event="GVGE" if group=="83" | group=="952" | group=="942" | group=="932"
replace event="FGVGE" if group=="82"| group=="81" | group=="951" | group=="941" | group=="931" | group=="92" |group=="91"

gen path = string(SRH) + "_" +event if !missing(SRH) & !missing(group)

gen Pbetter = P108 if strpos(group,"8") | group=="91"
replace Pbetter = 1-P109 if strpos(group,"9") & group!="91"
replace Pbetter = P109 if group=="91"
gen Pworse = 1-Pbetter

gen ctpt=4 if event=="E"
replace ctpt=3 if event=="VGE"
replace ctpt=2 if event=="GVGE"
replace ctpt=1 if event=="FGVGE"
