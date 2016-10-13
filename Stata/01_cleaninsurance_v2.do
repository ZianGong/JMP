/******************************************************************************
 01_cleaninsurance.do 
 Description:
 Cleans up health insurance related variables from section N of HRS, 
 renames them as necessary
 then drops raw variables
******************************************************************************/

/* Note: default is no insurance if no indicator is turned on */
/* Health insurance status */
** indicator for non-employer tied insurance
** indicator for having employer tied insurance, avail after separation to 65
** indicator for having employer tied insurance, not avail after separation to 65

gen medicare =(N001 ==1)
gen medicaid =(N006 ==1)
replace medicaid =1 if N007 ==1 /*Vet insurance also counts in here */
replace N023 =. if N023 >10
forvalues j =1/3{
	replace N033_`j' =0 if N033_`j' >1
	replace N034_`j' =0 if N034_`j' >1
	replace N059_`j' =0 if N059_`j' >1
	}
egen einsure = rowmax(N033_1  N033_2  N033_3 )
egen einsure65 = rowmax(N034_1  N034_2  N034_3  N059_1  N059_2  N059_3 )
replace einsure =0 if einsure65 ==1
gen insureother = (N023 >0 & !missing(N023 ) & einsure ==0 & einsure65 ==0)
gen insure = (einsure==1 | einsure65==1)
drop N*
/* recode insureother to be has coverage through spouse? */


/* 
einsure65: has any kind of employer-tied insurance that covers up to age 65
	even if R has left employer
einsure: has any kind of employer-tied insurance that cover health care that 
	does not cover up to age 65 
*N033* *N034* *N035* *N036*  *N059* *N060* *N062* *N063*);
note: have not touched coverage through spouse yet. 
