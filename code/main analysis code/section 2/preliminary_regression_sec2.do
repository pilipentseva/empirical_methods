
use $data/base_airbnb_AEJ.dta, clear
xtset newid wave

global sample "full"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"

keep if Drev100>0

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit


// Call functions
do $code/fun_reg_price_X.do
do $code/fun_reg_price_Xratings_bynbrev.do
do $code/fun_xtreg_price_X_rev.do

fun_reg_price_X
fun_reg_price_Xratings_bynbrev
fun_xtreg_price_X_rev


/*
Section 1
Table 2 - ethnic  price  differential  for  several specifications
Table 3 - ethnic price gap, for several segments of the number of reviews


Section 4
Table 5 -  Robustness:  Linear and quadratic models of price with listing fixed effects

*/
