



// Table A7 - Probability to leave the market at wave t

use $data/base_airbnb_AEJ.dta, clear

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit


* Detailed rating for first and last
gen rating_det = guest_satisfaction_overall/100-1
sort newid wave

keep if Drev100>0

bys newid (wave): gen last_wave = (wave==maxwave & maxwave<19)
bys minodummy : tab last_wave, missing
bys newid : egen last_wave_newid=max(last_wave)

preserve
duplicates drop newid, force
bys minodummy : tab last_wave_newid, missing
restore

quietly{
    areg  last_wave _IcitywaveI_* _IhoodcityI_* $lesX minodummy $ratinglist, robust cl(blockID) absorb(blockID)
    estimates store m1b
    areg  last_wave _IcitywaveI_* _IhoodcityI_* $lesX minodummy log_price $ratinglist, robust cl(blockID) absorb(blockID)
    estimates store m2b	
    areg last_wave _IcitywaveI_* _IhoodcityI_* $lesX minodummy log_price review $ratinglist, robust cl(blockID) absorb(blockID)
    estimates store m3b	
}
 estout  m1b m2b m3b  using $results/TableA7.tex, cells(b(star fmt(%9.4f)) se(par fmt (%9.4f))) ///
 keep(minodummy log_price review) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) ///
 title(Probability to leave the market at wave $t$\label{tab.sorting}) ///
  varlabels( minodummy "Minority" log_price "Log Price" review "Review") ///
 style(tex) replace starlevels(* 0.1 ** 0.05 *** 0.01 )  ///
  mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression.""\end{center}" "\end{table}")


 // Table A8 - Behaviour of hosts posting non-person pictures

use $data/base_airbnb_AEJ.dta, clear


keep if black_pic==1 | black_pic==0
keep black_pic hoodcityID newid city
duplicates drop
bys hoodcityID : egen share_black=mean(black_pic)
keep hoodcityID share_black city
duplicates drop

save $results/base_share_black_hood.dta, replace

use $data/base_airbnb_AEJ.dta, clear

keep if Drev100>0

merge m:1 hoodcityID using $results/base_share_black_hood.dta

keep if _merge==3
quietly{
reg pic_no_ethnic i.citywaveID share_black $lesX, robust cl(newid) 
estimates store m0a	
}

gen pic_no_ethnic_share_black=pic_no_ethnic*share_black

quietly{
reg log_price i.citywaveID i.hoodcityID $lesX pic_no_ethnic , robust cl(newid)
estimates store m1a
reg log_price i.citywaveID i.hoodcityID $lesX pic_no_ethnic pic_no_ethnic_share_black , robust cl(newid)
estimates store m2a
}

estout m0a m1a m2a using $results/TableA6.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
keep(share_black pic_no_ethnic pic_no_ethnic_share_black) ///
 stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
 replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
 title(Behavior of hosts posting non-person pictures \label{tab.non_person_pics}) ///
 varlabels(share_black  "Local share of Blacks" pic_no_ethnic   "Non-person picture" ///
  pic_no_ethnic_share_black "Non-person picture x share Blacks")  ///
 mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression.""\end{center}" "\end{table}")	



****Correlation between % of minority hosts by block/hood & Price Estimation****

use $data/base_airbnb_AEJ.dta, clear

duplicates drop newid, force
bys blockID : gen sum_minodummy_block=_N
bys blockID : egen mean_minodummy_block=mean(minodummy)

keep blockID mean_minodummy_block sum_minodummy_block
duplicates drop 

sum sum_minodummy_block,d
drop if  sum_minodummy_block<5
save $results/mean_minodummy_block.dta, replace


use $data/base_airbnb_AEJ.dta, clear
xtset newid wave

merge m:1 blockID using $results/mean_minodummy_block.dta
keep if _merge==3

quietly xtreg log_price i.citywaveID i.blockID $lesX minodummy, fe i(hoodcityID)

parmest, saving($results/res_reg.dta, replace)



use $results/res_reg.dta, clear
drop dof t p min95 max95
keep if regexm(parm,"block")
gen blockID=substr(parm,1,strpos(parm,".")-1)
destring blockID ,replace force
drop if blockID==.
save $results/res_reg.dta, replace

merge 1:1 blockID using $results/mean_minodummy_block.dta
keep if _merge==3
corr estimate mean_minodummy_block

reg estimate mean_minodummy_block

sum estimate mean_minodummy_block

	






