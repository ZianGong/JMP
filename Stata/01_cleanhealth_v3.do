/******************************************************************************
 01_cleanhealth.do 
 Description:
 Cleans up health related variables from section C of HRS, 
 renames them as necessary
 then drops raw variables
******************************************************************************/

/* Subjective health outcome *************************************************/

rename C001 SRH
replace SRH=. if SRH>5

/* Label health outcome-- 6 indicates deceased if included in sample */
recode SRH (5=1) (4=2) (3=3) (2=4) (1=5)
label define fivept 5 "Excellent" 4 "Very good" 3 "Good" 2 "Fair" 1 "Poor"
label values SRH fivept

/*******************************************************************************
Mobility, fine motor and functional limitations
*******************************************************************************/
/* Mobility, fine motor and functional limitations */
gen MFFL1 = (G003 == 1 | G003 == 6 |G003 == 7)
gen MFFL2 = (G004 == 1 | G004 == 6 |G004 == 7)
gen MFFL3 = (G005 == 1 | G005 == 6 |G005 == 7)
gen MFFL4 = (G006 == 1 | G006 == 6 |G006 == 7)
replace MFFL4 =1 if G007 == 1 | G007 == 6 |G007 == 7
gen MFFL5 = (G008 == 1 | G008 == 6 |G008 == 7)
gen MFFL6 = (G009 == 1 | G009 == 6 |G009 == 7)
gen MFFL7 = (G010 == 1 | G010 == 6 |G010 == 7)
gen MFFL8 = (G011 == 1 | G011 == 6 |G011 == 7)
gen MFFL9 = (G012 == 1 | G012 == 6 |G012 == 7)

/*******************************************************************************
Activities of daily living
*******************************************************************************/
gen ADL1 = (G014==1 | G014==6 | G014==7) /*dressing*/
gen ADL2 = (G016==1 | G016==6 | G016==7)  /*walk*/
gen ADL3 = (G021==1 | G021==6 | G021==7) /* showering*/
gen ADL4 = (G023==1 | G023==6 | G023==7) /* eating*/
gen ADL5 = (G025==1 | G025==6 | G025==7) /* bed*/
gen ADL6 = (G030==1 | G030==6 | G030==7) /*toilet*/
egen ADL = rowmax(ADL1 ADL2 ADL3 ADL4 ADL5) /* has at least one ADL */ 


/*******************************************************************************
Instrucmental Activities of daily living
*******************************************************************************/
gen IADL1 = (G040==1 | G040==6 | G040==7) /* map */ 
gen IADL2 = (G041==1 | G042==1 )/* cooking*/
gen IADL3 = (G044==1 | G045==1) /* groceries*/
gen IADL4 = (G047==1 | G048==1) /* phone*/
gen IADL5 = (G050==1 | G051==1 | G052==1) /*meidcations*/
gen IADL6 = (G058==1) /*housework*/
gen IADL7 = (G059==1 | G060==1) /* money*/ 
egen IADL = rowmax (IADL1 IADL2 IADL3 IADL4 IADL5 IADL5 IADL6 IADL7)



/*******************************************************************************
Doctor-diagnosed health conditions
*******************************************************************************//* Objective health outcomes --diagnosed conditions */

gen heart= (C036<=3) /* heart problems */
replace heart=1 if C040==1
replace heart=1 if C048==1
replace heart=1 if C051==1
replace heart=1 if C052==1

gen hbp = (C005<=3) /* high blood pressure */

gen stroke= (C053<=3) /* stroke */
gen stroke2=stroke  
replace stroke2=0 if C055==5 /*stroke2 only counts stroke as feeling the effects of it */

gen diabetes= (C010<=3) /* diabetes */

gen lung= (C030<=3) /* chronic lung disease */

gen arthritis=(C070==1 | C070==3) /* arthritis */

gen cancer=(C019==1) /* cancer -- seen doc since last int?*/
replace cancer=1 if C020==1 /* received treatment */

gen psych = (C065<=3) /* psychological problems */

gen dementia = (C272==1 | C273==1)

/*******************************************************************************
Ordinal physical indicators & others 
*******************************************************************************//* Objective health outcomes --diagnosed conditions */
gen pain = (C104==1)

/* BMI */
sort HHID PN wave
/* if height is missing, pull from prior wave*/
replace C141 = C141[_n-1] if missing(C141) & wave>=8 & HHID==HHID[_n-1] & PN==PN[_n-1] 
replace C142 = C142[_n-1] if missing(C142) & wave>=8 & HHID==HHID[_n-1] & PN==PN[_n-1]
replace C139=. if C139 >400
replace C141=. if C141 >=8
replace C142=. if C142 >=98
gen bmi = C141*0.3048+C142*0.0254
replace bmi = bmi*bmi
replace bmi = (C139*0.4536) / bmi
gen bmi2 = bmi * bmi
gen bmi_under= (bmi<18.5)
gen bmi_over = (bmi>=25 & bmi<30)
gen bmi_obese = (bmi>=30 & !missing(bmi))
drop C* G*

/*******************************************************************************
CES-D score
*******************************************************************************/
gen CESD=3
replace CESD = CESD+1 if D110==1
replace CESD = CESD+1 if D111==1
replace CESD = CESD+1 if D112==1
replace CESD = CESD-1 if D113==1
replace CESD = CESD+1 if D114==1
replace CESD = CESD-1 if D115==1
replace CESD = CESD+1 if D116==1
replace CESD = CESD+1 if D117==1
replace CESD = CESD-1 if D118==1

drop D1*


