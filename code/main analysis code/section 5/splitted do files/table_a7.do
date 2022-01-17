*Table A7
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

