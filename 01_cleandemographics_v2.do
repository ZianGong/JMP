/******************************************************************************
 01_cleandemographics.do 
 Description:
 Cleans up demographic variables
******************************************************************************/

gen edu_hs = (SCHLYRS>=12 & SCHLYRS<16)
gen edu_col = (SCHLYRS>=16 & SCHLYRS!=.)
gen female=(GENDER==2)
gen age= 2006-BIRTHYR if BIRTHYR!=0 & wave==8/*age is 2006 age */
replace age= 2006-BIRTHYR if BIRTHYR!=0 & wave==9
replace age= 2010-BIRTHYR if BIRTHYR!=0 & wave==10
replace age= 2012-BIRTHYR if BIRTHYR!=0 & wave==11
gen hisp = (HISPANIC>=1& HISPANIC<=3)
gen age2 = age*age

drop SCHLYRS GENDER BIRTHYR



gen black = (RACE==2)
gen married=(KMARST==1) /* married in 2006 */
drop RACE KMARST HISPANIC
