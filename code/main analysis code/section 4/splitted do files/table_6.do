*Table 6
// Table 6 is not automatically built, but aggregates different tables 
// results_arabicafrican/Table3_arabicafrican.tex (col 2)
// results_arabicafrican/Table4_arabicafrican.tex (col 2)


*Col 2 : Arabic/Muslims
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
drop minodummy
drop if black_pic==1 & arabic_african==0
rename arabic_african minodummy
global sample "arabicafrican"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do


*Col 3 : African-Americans
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
drop minodummy
drop if arabic_african==1 & black_pic==0
rename black_pic minodummy
global sample "black"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do


*Col 4 : US/CANADA
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
keep if (us==1 | can==1)
global sample "uscan"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do


*Col 5 : Europe
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
keep if euro==1
global sample "euro"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do


*Col 6 : Entire Flat
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
keep if entireflat==1
global sample "entireflat"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do


*Col 7 : Shared Flat
clear all
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0
*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit
keep if entireflat==0
global sample "sharedflat"
capture mkdir "$results//$sample/"
global results_sample "$results//$sample/"
do $code/fun_reg_price_Xratings_bynbrev.do
fun_reg_price_Xratings_bynbrev
do $code/3_structural.do

 
