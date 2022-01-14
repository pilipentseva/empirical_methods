


// Table 7 - Ethnic  matching  between  Arabic/Muslim  hosts  and  Arabic/Muslim guests

use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit

 foreach x in nber_names nber_black_names nber_arabic_african_names nber_mino_names {
egen `x'_total = total(`x'), by(newid) 
}
 
*Calcul Probas*
gen  proba_black=  nber_black_names_total/nber_names_total
gen  proba_arabic_african=  nber_arabic_african_names_total/nber_names_total
gen  proba_mino=  nber_mino_names_total/nber_names_total

*Proba par NEWID
preserve
keep if wave==maxwave

quietly{

areg proba_arabic_african log_price  _IcitywaveI_* _IhoodcityI_*  $lesX ///
 c.lastrat0 c.lastrat7 c.lastrat8 c.lastrat9 c.rev100 arabic_african ///
 nber_names_total, robust cl(blockID) absorb(blockID)
estimates store m1

}

estout  m1  using $results/Table7.tex, cells(b(star fmt(%9.4f)) se(par fmt (%9.4f))) ///
 keep(arabic_african) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs."))  ///
    varlabels(arabic_african "Arabic/Muslim Host" ) ///
  title(Ethnic matching between Arabic/Muslim hosts and Arabic/Muslim guests\label{tab.matching}) ///
   style(tex) replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///  
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression with listings fixed-effects.""\end{center}" "\end{table}")

restore



// Table 8 - Average rating, depending on hosts’ and guests’ ethnicity
 
    ***FLUX***
	
// inno_names: the number of new guests (whose names are in _n and were not in _n-1)
// inno_mino_names: the number of new minority guests (whose names that are in _n and were not in _n-1)
gen inno_names=nber_names if wave!=minwave
gen inno_mino_names=nber_mino_names if wave!=minwave

replace rating_visible=. if rating_visible==0

gen share_inno_mino_names = inno_mino_names/inno_names
bys newid (wave): gen Dreview = review[_n]-review[_n-1]
bys newid (wave): gen L_guest_satisfaction_overall = guest_satisfaction_overall[_n-1]
bys newid (wave): gen L_rating_visible = rating_visible[_n-1]
gen L_guest_satisfaction_overallNA = missing(L_guest_satisfaction_overall)
gen L_rating_visibleNA = missing(L_rating_visible)
replace L_guest_satisfaction_overall = 0 if missing(L_guest_satisfaction_overall)
replace L_rating_visible = 0 if missing(L_rating_visible)

// Innovation in ratings
bys newid (wave): gen inno_satis = ((guest_satisfaction_overall[_n]*review[_n])-(guest_satisfaction_overall[_n-1]*review[_n-1]))/(review[_n]-review[_n-1])
bys newid (wave): gen inno_rating = ((rating_visible[_n]*review[_n])-(rating_visible[_n-1]*review[_n-1]))/(review[_n]-review[_n-1])
replace inno_satis = guest_satisfaction_overall[_n] if missing(guest_satisfaction_overall[_n-1])
replace inno_rating = rating_visible[_n] if missing(rating_visible[_n-1])

sum inno_satis inno_rating inno_names

replace inno_satis=inno_satis/20
replace L_guest_satisfaction_overall=L_guest_satisfaction_overall/20

sum inno_satis  L_guest_satisfaction_overall

// Interaction : Coeff d'interet
gen mino_share = minodummy*share_inno_mino_names

// Regressions
quietly {
xtreg inno_satis i.hoodcityID $lesX mino_share minodummy share_inno_mino_names inno_names review Dreview L_guest_satisfaction_overall L_guest_satisfaction_overallNA ///
 if inno_names>0 & !missing(inno_satis), robust fe i(blockID)
estimates store ols1

xtreg inno_satis i.citywaveID $lesX mino_share share_inno_mino_names inno_names review Dreview L_guest_satisfaction_overall L_guest_satisfaction_overallNA ///
 if inno_names>0 & !missing(inno_satis), fe i(newid) robust cl(newid)
estimates store xt1
}
estout xt1 using $results/Table8.tex , cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) keep(share_inno_mino_names mino_share) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
varlabels(share_inno_mino_names "Share of minority among new guests" mino_share "Minority host \$ \times \$ Share of minority among new guests") ///
  title(Average rating, depending on hosts' and guests' ethnicity\label{tab.ratings.minority}) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 )  ///
 mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression in column (1), and OLS regression with listings fixed-effects in column (2).""\end{center}" "\end{table}")



// Table 9 - Differential Upgrading

use $data/base_airbnb_AEJ.dta, clear


global lesX_1 sharedflat $descrip_flat $loueur picture_count change_pics noccur_pro_true count_descrip
global lesX_2 sharedflat $descrip_flat $loueur 

*sur le Price*
quietly xtreg log_price i.citywaveID i.hoodcityID $lesX , fe i(newid) robust cl(newid)
predict phat, xb 
sort newid wave
bys newid (wave): gen Dphat = (phat[_n+1]-phat[_n])*100
bys newid (wave): gen Drating = (guest_satisfaction_overall[_n+1]-guest_satisfaction_overall[_n])*100
summ Dphat, det

keep if Drev100>0


gen KKrho = rev100/(.136+rev100)
gen lastrat10_KKrho=KKrho*lastrat10
gen lastrat9_KKrho=KKrho*lastrat9
gen lastrat8_KKrho=KKrho*lastrat8
gen lastrat7_KKrho=KKrho*lastrat7
gen minodummy_KKrho=minodummy*KKrho


** With interactions between last rating and f(K)

quietly{
xtreg phat i.citywaveID c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho, fe i(newid) robust cl(newid)
estimates store xtr0
* Word count in listing description
xtreg count_descrip i.citywaveID $lesX_2 c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho, ///
fe i(newid) robust cl(newid)
estimates store xtr1
* Number of pictures on listing profile
xtreg picture_count i.citywaveID $lesX_2 c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho, ///
fe i(newid) robust cl(newid)
estimates store xtr2
* Number of professional pictures on listing profile
xtreg noccur_pro_true i.citywaveID $lesX_2 c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho, ///
fe i(newid) robust cl(newid)
estimates store xtr3
* Rating
xtreg guest_satisfaction_overall i.citywaveID $lesX1 c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho if guest_satisfaction_overall!=., ///
fe i(newid) robust cl(newid)
estimates store xtr4
* Rating(t+1) - Rating(t)
xtreg Drating i.citywaveID $lesX1 c.minodummy#ib10.wave ///
lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho if guest_satisfaction_overall!=., ///
fe i(newid) robust cl(newid)
estimates store xtr4diff
}

estout xtr0 xtr1 xtr2 xtr3 using $results/Table9.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
keep(*Krho*) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
title(Differential Upgrading\label{tab.upgrading}) ///
varlabels(minodummy_KKrho "Minority \$ \times f(K)\$" ///
lastrat7 "3.5 stars" lastrat8 "4 stars" lastrat9 "4.5 stars" lastrat10 "5 stars" ///
lastrat7_KKrho "3.5 stars \$ \times f(K)\$" ///
lastrat8_KKrho "4 stars \$ \times f(K)\$" ///
lastrat9_KKrho "4.5 stars \$ \times f(K)\$" ///
lastrat10_KKrho "5 stars \$ \times f(K)\$") ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: FE regression.""\end{center}" "\end{table}") 




// Table 10 - Ethnic differentials in the accumulation of reviews over time

use $data/base_airbnb_AEJ.dta, clear

keep if Drev100>0
  
gen KKrho = rev100/(.136+rev100)
gen lastrat10_KKrho=KKrho*lastrat10
gen lastrat9_KKrho=KKrho*lastrat9
gen lastrat8_KKrho=KKrho*lastrat8
gen lastrat7_KKrho=KKrho*lastrat7
gen minodummy_KKrho=minodummy*KKrho

global struc_step1 c.minodummy#ib10.wave $lesX i.citywaveID lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho 

sort newid wave
bys newid : gen rev100_t1=rev100[_n+1]
 
gen diff= rev100_t1-rev100
gen taux=diff/rev100

xtreg diff $struc_step1 , fe i(newid) robust cl(newid)
estimates store xtr1
xtreg taux $struc_step1 , fe i(newid) robust cl(newid)
estimates store xtr2

estout xtr1 xtr2 using $results/Table10.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
keep(*Krho*) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
title(Ethnic differentials in the accumulation of reviews over time\label{tab.reviewaccumulation}) ///
varlabels(minodummy_KKrho "Minority \$ \times f(K)\$" ///
lastrat7 "3.5 stars" lastrat8 "4 stars" lastrat9 "4.5 stars" lastrat10 "5 stars" ///
lastrat7_KKrho "3.5 stars \$ \times f(K)\$" ///
lastrat8_KKrho "4 stars \$ \times f(K)\$" ///
lastrat9_KKrho "4.5 stars \$ \times f(K)\$" ///
lastrat10_KKrho "5 stars \$ \times f(K)\$") ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\midrule) ///
prefoot(\midrule) ///
postfoot("\bottomrule""\end{tabular}" "Notes: FE regression.""\end{center}" "\end{table}")	
		

// Table 6 - Results on sub-samples
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

 
