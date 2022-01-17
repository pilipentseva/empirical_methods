*Tablr 9
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


